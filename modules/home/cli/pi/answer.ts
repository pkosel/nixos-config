/**
 * Adapted from mitsuhiko/agent-stuff's extensions/answer.ts.
 * https://github.com/mitsuhiko/agent-stuff/blob/main/extensions/answer.ts
 * Modified for this configuration.
 * Upstream: Apache-2.0; local modifications: MIT. See answer.LICENSE.
 */

import {
	parseJsonWithRepair,
	type Api,
	type Model,
	type UserMessage,
} from "@earendil-works/pi-ai";
import {
	BorderedLoader,
	type ExtensionAPI,
	type ExtensionContext,
	type ModelRegistry,
	type Theme,
} from "@earendil-works/pi-coding-agent";
import {
	type Component,
	Editor,
	type EditorTheme,
	type Focusable,
	Key,
	matchesKey,
	truncateToWidth,
	type TUI,
	visibleWidth,
	wrapTextWithAnsi,
} from "@earendil-works/pi-tui";

interface ExtractedQuestion {
	question: string;
	context?: string;
}

interface ExtractionResult {
	questions: ExtractedQuestion[];
}

type ExtractionOutcome =
	| { status: "ok"; result: ExtractionResult }
	| { status: "cancelled" }
	| { status: "error"; message: string };

const SYSTEM_PROMPT = `You are a question extractor. Given text from a conversation, extract any questions that need answering.

Output a JSON object with this structure:
{
  "questions": [
    {
      "question": "The question text",
      "context": "Optional context that helps answer the question"
    }
  ]
}

Rules:
- Extract all questions that require user input
- Keep questions in the order they appeared
- Be concise with question text
- Include context only when it provides essential information for answering
- If no questions are found, return {"questions": []}

Example output:
{
  "questions": [
    {
      "question": "What is your preferred database?",
      "context": "We can only configure MySQL and PostgreSQL because of what is implemented."
    },
    {
      "question": "Should we use TypeScript or JavaScript?"
    }
  ]
}`;

function selectExtractionModel(
	currentModel: Model<Api>,
	modelRegistry: ModelRegistry,
): Model<Api> {
	const modelReference = process.env.PI_ANSWER_MODEL;
	if (modelReference === undefined) {
		return currentModel;
	}

	const separatorIndex = modelReference.indexOf("/");
	if (
		separatorIndex < 1 ||
		separatorIndex === modelReference.length - 1 ||
		/\s/.test(modelReference)
	) {
		throw new Error("PI_ANSWER_MODEL must use provider/modelId.");
	}

	const provider = modelReference.slice(0, separatorIndex);
	const modelId = modelReference.slice(separatorIndex + 1);
	const model = modelRegistry.find(provider, modelId);
	if (!model) {
		throw new Error(`Unknown PI_ANSWER_MODEL: ${modelReference}`);
	}
	if (!modelRegistry.hasConfiguredAuth(model)) {
		throw new Error(
			`No authentication configured for PI_ANSWER_MODEL: ${modelReference}`,
		);
	}
	return model;
}

function toExtractedQuestion(value: unknown): ExtractedQuestion | null {
	if (typeof value !== "object" || value === null) {
		return null;
	}
	const record = value as Record<string, unknown>;
	if (typeof record.question !== "string" || record.question.trim() === "") {
		return null;
	}
	if (
		record.context !== undefined &&
		record.context !== null &&
		typeof record.context !== "string"
	) {
		return null;
	}
	const question = record.question.trim();
	const context =
		typeof record.context === "string" ? record.context.trim() : "";
	return context ? { question, context } : { question };
}

function toExtractionResult(value: unknown): ExtractionResult | null {
	if (typeof value !== "object" || value === null) {
		return null;
	}
	const record = value as Record<string, unknown>;
	if (!Array.isArray(record.questions)) {
		return null;
	}
	const questions: ExtractedQuestion[] = [];
	for (const questionValue of record.questions) {
		const question = toExtractedQuestion(questionValue);
		if (!question) {
			return null;
		}
		questions.push(question);
	}
	return { questions };
}

function parseExtractionResult(text: string): ExtractionResult | null {
	const candidates: string[] = [];
	const fencedJson = text.match(/```(?:json)?\s*([\s\S]*?)```/);
	if (fencedJson) {
		candidates.push(fencedJson[1].trim());
	}
	const trimmed = text.trim();
	candidates.push(trimmed);
	const firstBrace = trimmed.indexOf("{");
	const lastBrace = trimmed.lastIndexOf("}");
	if (firstBrace !== -1 && lastBrace > firstBrace) {
		candidates.push(trimmed.slice(firstBrace, lastBrace + 1));
	}

	for (const candidate of candidates) {
		try {
			const result = toExtractionResult(
				parseJsonWithRepair<unknown>(candidate),
			);
			if (result) {
				return result;
			}
		} catch {
			// A later candidate may contain the complete JSON object.
		}
	}
	return null;
}

function getLastAssistantText(ctx: ExtensionContext): string {
	const branch = ctx.sessionManager.getBranch();
	for (let i = branch.length - 1; i >= 0; i--) {
		const entry = branch[i];
		if (entry.type !== "message") continue;
		const message = entry.message;
		if (message.role !== "assistant") continue;
		if (message.stopReason !== "stop") {
			throw new Error(
				`Last assistant message incomplete (${message.stopReason})`,
			);
		}
		const text = message.content
			.filter(
				(part): part is { type: "text"; text: string } => part.type === "text",
			)
			.map((part) => part.text)
			.join("\n");
		if (text.trim()) return text;
	}
	throw new Error("No assistant messages found");
}

function getErrorMessage(error: unknown): string {
	return error instanceof Error ? error.message : String(error);
}

async function extractQuestions(
	modelRegistry: ModelRegistry,
	model: Model<Api>,
	assistantText: string,
	signal: AbortSignal,
): Promise<ExtractionOutcome> {
	const userMessage: UserMessage = {
		role: "user",
		content: [{ type: "text", text: assistantText }],
		timestamp: Date.now(),
	};
	const response = await modelRegistry.complete(
		model,
		{ systemPrompt: SYSTEM_PROMPT, messages: [userMessage] },
		{ signal },
	);
	if (response.stopReason === "aborted") {
		return { status: "cancelled" };
	}
	if (response.stopReason === "error") {
		return {
			status: "error",
			message: response.errorMessage ?? "question extraction failed",
		};
	}
	if (response.stopReason !== "stop") {
		return {
			status: "error",
			message: `question extraction incomplete (${response.stopReason})`,
		};
	}
	const responseText = response.content
		.filter(
			(part): part is { type: "text"; text: string } => part.type === "text",
		)
		.map((part) => part.text)
		.join("\n");
	const result = parseExtractionResult(responseText);
	if (!result) {
		return {
			status: "error",
			message: "question extraction returned invalid questions",
		};
	}
	return { status: "ok", result };
}

class AnswerComponent implements Component, Focusable {
	private readonly questions: ExtractedQuestion[];
	private readonly answers: string[];
	private currentIndex = 0;
	private readonly editor: Editor;
	private readonly tui: TUI;
	private readonly theme: Theme;
	private readonly onDone: (result: string | null) => void;
	private isConfirming = false;
	private cachedWidth?: number;
	private cachedLines?: string[];

	constructor(
		questions: ExtractedQuestion[],
		tui: TUI,
		theme: Theme,
		onDone: (result: string | null) => void,
	) {
		this.questions = questions;
		this.answers = questions.map(() => "");
		this.tui = tui;
		this.theme = theme;
		this.onDone = onDone;
		const editorTheme: EditorTheme = {
			borderColor: (text) => theme.fg("borderMuted", text),
			selectList: {
				selectedPrefix: (text) => theme.fg("accent", text),
				selectedText: (text) =>
					theme.style(text, { fg: "accent", bg: "selectedBg" }),
				description: (text) => theme.fg("muted", text),
				scrollInfo: (text) => theme.fg("dim", text),
				noMatch: (text) => theme.fg("warning", text),
			},
		};
		this.editor = new Editor(tui, editorTheme);
		// Preserve the text when Enter advances to another question.
		this.editor.disableSubmit = true;
		this.editor.onChange = () => this.refresh();
	}

	get focused(): boolean {
		return this.editor.focused;
	}

	set focused(value: boolean) {
		if (this.editor.focused === value) return;
		this.editor.focused = value;
		this.refresh();
	}

	private refresh(): void {
		this.invalidate();
		this.tui.requestRender();
	}

	private saveCurrentAnswer(): void {
		this.answers[this.currentIndex] = this.editor.getExpandedText();
	}

	private navigateTo(index: number): void {
		if (index < 0 || index >= this.questions.length) return;
		this.saveCurrentAnswer();
		this.currentIndex = index;
		this.editor.setText(this.answers[index]);
		this.refresh();
	}

	private submit(): void {
		this.saveCurrentAnswer();
		const parts: string[] = [];
		for (let i = 0; i < this.questions.length; i++) {
			const question = this.questions[i];
			const answer = this.answers[i].trim() || "(no answer)";
			parts.push(`Q: ${question.question}`);
			if (question.context) parts.push(`> ${question.context}`);
			parts.push(`A: ${answer}`, "");
		}
		this.onDone(parts.join("\n").trim());
	}

	invalidate(): void {
		this.cachedWidth = undefined;
		this.cachedLines = undefined;
		this.editor.invalidate();
	}

	handleInput(data: string): void {
		if (this.isConfirming) {
			if (matchesKey(data, Key.enter) || data.toLowerCase() === "y") {
				this.submit();
			} else if (
				matchesKey(data, Key.escape) ||
				matchesKey(data, Key.ctrl("c")) ||
				data.toLowerCase() === "n"
			) {
				this.isConfirming = false;
				this.refresh();
			}
			return;
		}
		if (matchesKey(data, Key.escape) || matchesKey(data, Key.ctrl("c"))) {
			this.onDone(null);
			return;
		}
		if (matchesKey(data, Key.tab)) {
			this.navigateTo(this.currentIndex + 1);
			return;
		}
		if (matchesKey(data, Key.shift("tab"))) {
			this.navigateTo(this.currentIndex - 1);
			return;
		}
		if (
			matchesKey(data, Key.up) &&
			this.editor.getText() === "" &&
			this.currentIndex > 0
		) {
			this.navigateTo(this.currentIndex - 1);
			return;
		}
		if (
			matchesKey(data, Key.down) &&
			this.editor.getText() === "" &&
			this.currentIndex < this.questions.length - 1
		) {
			this.navigateTo(this.currentIndex + 1);
			return;
		}
		if (matchesKey(data, Key.enter) && !matchesKey(data, Key.shift("enter"))) {
			if (this.currentIndex < this.questions.length - 1) {
				this.navigateTo(this.currentIndex + 1);
			} else {
				this.saveCurrentAnswer();
				this.isConfirming = true;
				this.refresh();
			}
			return;
		}
		this.editor.handleInput(data);
		this.refresh();
	}

	render(width: number): string[] {
		if (this.cachedLines && this.cachedWidth === width) return this.cachedLines;
		const maximumPanelWidth = 120;
		const outerMargin = 4;
		const panelWidth = Math.min(width - outerMargin, maximumPanelWidth);
		const borderWidth = 2;
		const leftPadding = 2;
		const contentWidth = panelWidth - borderWidth - leftPadding;
		const answerPrefix = "A: ";
		const answerRightPadding = 4;
		const editorWidth =
			contentWidth - visibleWidth(answerPrefix) - answerRightPadding;
		// The editor needs two columns for a wide grapheme plus its reserved cursor column.
		if (editorWidth < 3) {
			return [truncateToWidth("Widen terminal to answer questions", width, "")];
		}
		const border = (left: string, right: string) =>
			this.theme.fg(
				"borderMuted",
				left + "─".repeat(panelWidth - borderWidth) + right,
			);
		const boxLine = (content: string): string => {
			const paddedContent =
				" ".repeat(leftPadding) + truncateToWidth(content, contentWidth);
			const rightPadding =
				panelWidth - visibleWidth(paddedContent) - borderWidth;
			return (
				this.theme.fg("borderMuted", "│") +
				paddedContent +
				" ".repeat(rightPadding) +
				this.theme.fg("borderMuted", "│")
			);
		};
		const title = this.theme.style("Questions", { fg: "accent", bold: true });
		const position = this.theme.fg(
			"dim",
			`(${this.currentIndex + 1}/${this.questions.length})`,
		);
		const lines = [
			border("╭", "╮"),
			boxLine(`${title} ${position}`),
			border("├", "┤"),
		];
		const progress = this.questions.map((_, index) => {
			if (index === this.currentIndex) return this.theme.fg("accent", "●");
			return this.answers[index].trim()
				? this.theme.fg("success", "●")
				: this.theme.fg("dim", "○");
		});
		for (const line of wrapTextWithAnsi(progress.join(" "), contentWidth)) {
			lines.push(boxLine(line));
		}
		lines.push(boxLine(""));
		const question = this.questions[this.currentIndex];
		const questionText = `${this.theme.bold("Q:")} ${question.question}`;
		for (const line of wrapTextWithAnsi(questionText, contentWidth)) {
			lines.push(boxLine(line));
		}
		if (question.context) {
			lines.push(boxLine(""));
			const contextText = this.theme.fg("muted", `> ${question.context}`);
			for (const line of wrapTextWithAnsi(
				contextText,
				contentWidth - leftPadding,
			)) {
				lines.push(boxLine(line));
			}
		}
		lines.push(boxLine(""));
		const editorLines = this.editor.render(editorWidth);
		// Omit the editor's own borders inside the surrounding panel.
		for (let i = 1; i < editorLines.length - 1; i++) {
			const prefix =
				i === 1
					? this.theme.bold(answerPrefix)
					: " ".repeat(visibleWidth(answerPrefix));
			lines.push(boxLine(prefix + editorLines[i]));
		}
		lines.push(boxLine(""), border("├", "┤"));
		if (this.isConfirming) {
			const message = this.theme.fg("warning", "Submit all answers?");
			const controls = this.theme.fg(
				"dim",
				"(Enter/y to confirm, Esc/n to cancel)",
			);
			lines.push(boxLine(`${message} ${controls}`));
		} else {
			const controls = [
				`${this.theme.fg("dim", "Tab/Enter")} next`,
				`${this.theme.fg("dim", "Shift+Tab")} prev`,
				`${this.theme.fg("dim", "Shift+Enter")} newline`,
				`${this.theme.fg("dim", "Esc")} cancel`,
			].join(" · ");
			lines.push(boxLine(controls));
		}
		lines.push(border("╰", "╯"));
		this.cachedWidth = width;
		this.cachedLines = lines.map(
			(line) => line + " ".repeat(Math.max(0, width - visibleWidth(line))),
		);
		return this.cachedLines;
	}
}

export default function (pi: ExtensionAPI) {
	const answerHandler = async (ctx: ExtensionContext) => {
		if (ctx.mode !== "tui") {
			ctx.ui.notify("answer requires interactive mode", "error");
			return;
		}
		if (!ctx.model) {
			ctx.ui.notify("No model selected", "error");
			return;
		}
		let assistantText: string;
		let extractionModel: Model<Api>;
		try {
			assistantText = getLastAssistantText(ctx);
			extractionModel = selectExtractionModel(ctx.model, ctx.modelRegistry);
		} catch (error) {
			ctx.ui.notify(getErrorMessage(error), "error");
			return;
		}

		const outcome = await ctx.ui.custom<ExtractionOutcome>(
			(tui, theme, _keybindings, done) => {
				const loader = new BorderedLoader(
					tui,
					theme,
					`Extracting questions using ${extractionModel.id}...`,
				);
				let hasFinished = false;
				const finishExtraction = (result: ExtractionOutcome) => {
					if (hasFinished) return;
					hasFinished = true;
					done(result);
				};
				loader.onAbort = () => finishExtraction({ status: "cancelled" });
				extractQuestions(
					ctx.modelRegistry,
					extractionModel,
					assistantText,
					loader.signal,
				).then(finishExtraction, (error: unknown) =>
					finishExtraction(
						loader.signal.aborted
							? { status: "cancelled" }
							: { status: "error", message: getErrorMessage(error) },
					),
				);
				return loader;
			},
		);
		if (outcome.status === "cancelled") {
			ctx.ui.notify("Cancelled", "info");
			return;
		}
		if (outcome.status === "error") {
			ctx.ui.notify(`Question extraction failed: ${outcome.message}`, "error");
			return;
		}
		if (outcome.result.questions.length === 0) {
			ctx.ui.notify("No questions found in the last message", "info");
			return;
		}
		const answers = await ctx.ui.custom<string | null>(
			(tui, theme, _keybindings, done) =>
				new AnswerComponent(outcome.result.questions, tui, theme, done),
		);
		if (answers === null) {
			ctx.ui.notify("Cancelled", "info");
			return;
		}
		pi.sendMessage(
			{
				customType: "answers",
				content: `I answered your questions in the following way:\n\n${answers}`,
				display: true,
			},
			{ triggerTurn: true },
		);
	};
	pi.registerCommand("answer", {
		description:
			"Extract questions from last assistant message into interactive Q&A",
		handler: (_args, ctx) => answerHandler(ctx),
	});
	pi.registerShortcut("ctrl+.", {
		description: "Extract and answer questions",
		handler: answerHandler,
	});
}
