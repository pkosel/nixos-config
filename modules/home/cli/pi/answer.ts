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

class QnAComponent implements Component, Focusable {
	private questions: ExtractedQuestion[];
	private answers: string[];
	private currentIndex: number = 0;
	private editor: Editor;
	private tui: TUI;
	private onDone: (result: string | null) => void;
	private showingConfirmation: boolean = false;

	private cachedWidth?: number;
	private cachedLines?: string[];

	private dim = (s: string) => `\x1b[2m${s}\x1b[0m`;
	private bold = (s: string) => `\x1b[1m${s}\x1b[0m`;
	private cyan = (s: string) => `\x1b[36m${s}\x1b[0m`;
	private green = (s: string) => `\x1b[32m${s}\x1b[0m`;
	private yellow = (s: string) => `\x1b[33m${s}\x1b[0m`;
	private gray = (s: string) => `\x1b[90m${s}\x1b[0m`;

	constructor(
		questions: ExtractedQuestion[],
		tui: TUI,
		onDone: (result: string | null) => void,
	) {
		this.questions = questions;
		this.answers = questions.map(() => "");
		this.tui = tui;
		this.onDone = onDone;

		const editorTheme: EditorTheme = {
			borderColor: this.dim,
			selectList: {
				selectedPrefix: this.cyan,
				selectedText: (s: string) => `\x1b[44m${s}\x1b[0m`,
				description: this.gray,
				scrollInfo: this.dim,
				noMatch: this.yellow,
			},
		};

		this.editor = new Editor(tui, editorTheme);
		// Disable the editor's built-in submit (which clears the editor)
		// We'll handle Enter ourselves to preserve the text
		this.editor.disableSubmit = true;
		this.editor.onChange = () => {
			this.invalidate();
			this.tui.requestRender();
		};
	}

	get focused(): boolean {
		return this.editor.focused;
	}

	set focused(value: boolean) {
		if (this.editor.focused === value) return;
		this.editor.focused = value;
		this.invalidate();
		this.tui.requestRender();
	}

	private saveCurrentAnswer(): void {
		this.answers[this.currentIndex] = this.editor.getText();
	}

	private navigateTo(index: number): void {
		if (index < 0 || index >= this.questions.length) return;
		this.saveCurrentAnswer();
		this.currentIndex = index;
		this.editor.setText(this.answers[index] || "");
		this.invalidate();
	}

	private submit(): void {
		this.saveCurrentAnswer();

		const parts: string[] = [];
		for (let i = 0; i < this.questions.length; i++) {
			const q = this.questions[i];
			const a = this.answers[i]?.trim() || "(no answer)";
			parts.push(`Q: ${q.question}`);
			if (q.context) {
				parts.push(`> ${q.context}`);
			}
			parts.push(`A: ${a}`);
			parts.push("");
		}

		this.onDone(parts.join("\n").trim());
	}

	private cancel(): void {
		this.onDone(null);
	}

	invalidate(): void {
		this.cachedWidth = undefined;
		this.cachedLines = undefined;
	}

	handleInput(data: string): void {
		if (this.showingConfirmation) {
			if (matchesKey(data, Key.enter) || data.toLowerCase() === "y") {
				this.submit();
				return;
			}
			if (
				matchesKey(data, Key.escape) ||
				matchesKey(data, Key.ctrl("c")) ||
				data.toLowerCase() === "n"
			) {
				this.showingConfirmation = false;
				this.invalidate();
				this.tui.requestRender();
				return;
			}
			return;
		}

		if (matchesKey(data, Key.escape) || matchesKey(data, Key.ctrl("c"))) {
			this.cancel();
			return;
		}

		if (matchesKey(data, Key.tab)) {
			if (this.currentIndex < this.questions.length - 1) {
				this.navigateTo(this.currentIndex + 1);
				this.tui.requestRender();
			}
			return;
		}
		if (matchesKey(data, Key.shift("tab"))) {
			if (this.currentIndex > 0) {
				this.navigateTo(this.currentIndex - 1);
				this.tui.requestRender();
			}
			return;
		}

		if (matchesKey(data, Key.up) && this.editor.getText() === "") {
			if (this.currentIndex > 0) {
				this.navigateTo(this.currentIndex - 1);
				this.tui.requestRender();
				return;
			}
		}
		if (matchesKey(data, Key.down) && this.editor.getText() === "") {
			if (this.currentIndex < this.questions.length - 1) {
				this.navigateTo(this.currentIndex + 1);
				this.tui.requestRender();
				return;
			}
		}

		if (matchesKey(data, Key.enter) && !matchesKey(data, Key.shift("enter"))) {
			this.saveCurrentAnswer();
			if (this.currentIndex < this.questions.length - 1) {
				this.navigateTo(this.currentIndex + 1);
			} else {
				this.showingConfirmation = true;
			}
			this.invalidate();
			this.tui.requestRender();
			return;
		}

		this.editor.handleInput(data);
		this.invalidate();
		this.tui.requestRender();
	}

	render(width: number): string[] {
		if (this.cachedLines && this.cachedWidth === width) {
			return this.cachedLines;
		}

		const lines: string[] = [];
		const boxWidth = Math.min(width - 4, 120); // Allow wider box
		const contentWidth = boxWidth - 4;
		const editorWidth = contentWidth - 4 - 3; // Extra padding + space for "A: "

		// The editor needs two columns for a wide grapheme plus its reserved cursor column.
		if (editorWidth < 3) {
			return [truncateToWidth("Widen terminal to answer questions", width, "")];
		}

		const horizontalLine = (count: number) => "─".repeat(count);

		const boxLine = (content: string, leftPad: number = 2): string => {
			const paddedContent =
				" ".repeat(leftPad) + truncateToWidth(content, boxWidth - leftPad - 2);
			const contentLen = visibleWidth(paddedContent);
			const rightPad = Math.max(0, boxWidth - contentLen - 2);
			return (
				this.dim("│") + paddedContent + " ".repeat(rightPad) + this.dim("│")
			);
		};

		const emptyBoxLine = (): string => {
			return this.dim("│") + " ".repeat(boxWidth - 2) + this.dim("│");
		};

		const padToWidth = (line: string): string => {
			const len = visibleWidth(line);
			return line + " ".repeat(Math.max(0, width - len));
		};

		lines.push(padToWidth(this.dim("╭" + horizontalLine(boxWidth - 2) + "╮")));
		const title = `${this.bold(this.cyan("Questions"))} ${this.dim(`(${this.currentIndex + 1}/${this.questions.length})`)}`;
		lines.push(padToWidth(boxLine(title)));
		lines.push(padToWidth(this.dim("├" + horizontalLine(boxWidth - 2) + "┤")));

		const progressParts: string[] = [];
		for (let i = 0; i < this.questions.length; i++) {
			const answered = (this.answers[i]?.trim() || "").length > 0;
			const current = i === this.currentIndex;
			if (current) {
				progressParts.push(this.cyan("●"));
			} else if (answered) {
				progressParts.push(this.green("●"));
			} else {
				progressParts.push(this.dim("○"));
			}
		}
		for (const line of wrapTextWithAnsi(
			progressParts.join(" "),
			contentWidth,
		)) {
			lines.push(padToWidth(boxLine(line)));
		}
		lines.push(padToWidth(emptyBoxLine()));

		const q = this.questions[this.currentIndex];
		const questionText = `${this.bold("Q:")} ${q.question}`;
		const wrappedQuestion = wrapTextWithAnsi(questionText, contentWidth);
		for (const line of wrappedQuestion) {
			lines.push(padToWidth(boxLine(line)));
		}

		if (q.context) {
			lines.push(padToWidth(emptyBoxLine()));
			const contextText = this.gray(`> ${q.context}`);
			const wrappedContext = wrapTextWithAnsi(contextText, contentWidth - 2);
			for (const line of wrappedContext) {
				lines.push(padToWidth(boxLine(line)));
			}
		}

		lines.push(padToWidth(emptyBoxLine()));

		const answerPrefix = this.bold("A: ");
		const editorLines = this.editor.render(editorWidth);
		for (let i = 1; i < editorLines.length - 1; i++) {
			if (i === 1) {
				lines.push(padToWidth(boxLine(answerPrefix + editorLines[i])));
			} else {
				lines.push(padToWidth(boxLine("   " + editorLines[i])));
			}
		}

		lines.push(padToWidth(emptyBoxLine()));

		if (this.showingConfirmation) {
			lines.push(
				padToWidth(this.dim("├" + horizontalLine(boxWidth - 2) + "┤")),
			);
			const confirmMsg = `${this.yellow("Submit all answers?")} ${this.dim("(Enter/y to confirm, Esc/n to cancel)")}`;
			lines.push(
				padToWidth(boxLine(truncateToWidth(confirmMsg, contentWidth))),
			);
		} else {
			lines.push(
				padToWidth(this.dim("├" + horizontalLine(boxWidth - 2) + "┤")),
			);
			const controls = `${this.dim("Tab/Enter")} next · ${this.dim("Shift+Tab")} prev · ${this.dim("Shift+Enter")} newline · ${this.dim("Esc")} cancel`;
			lines.push(padToWidth(boxLine(truncateToWidth(controls, contentWidth))));
		}
		lines.push(padToWidth(this.dim("╰" + horizontalLine(boxWidth - 2) + "╯")));

		this.cachedWidth = width;
		this.cachedLines = lines;
		return lines;
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
			(tui, _theme, _keybindings, done) =>
				new QnAComponent(outcome.result.questions, tui, done),
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
