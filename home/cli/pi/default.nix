{ ... }:

{
  # pi finds themes in ~/.pi/agent/themes. Selecting one is "theme" in
  # ~/.pi/agent/settings.json, which stays unmanaged because pi rewrites that
  # file itself (changelog version, model choice). Choose "nightowl-light/nightowl"
  # in /settings to follow the terminal's light or dark appearance.
  home.file = {
    ".pi/agent/themes/nightowl.json".source = ./nightowl.json;
    ".pi/agent/themes/nightowl-light.json".source = ./nightowl-light.json;
    # Local fork of the answer extension from mitsuhiko/agent-stuff. The fork
    # drops the hardcoded Anthropic/Codex extraction chain and reads
    # PI_ANSWER_MODEL instead; the upstream git checkout gets overwritten on
    # package updates. Remove extensions/answer.ts from the agent-stuff package
    # entry in ~/.pi/agent/settings.json so it does not register twice.
    ".pi/agent/extensions/answer.ts".source = ./answer.ts;
  };

  # provider/modelId, parsed by answer.ts. Keep in sync with enabledModels.
  home.sessionVariables.PI_ANSWER_MODEL = "openrouter/deepseek/deepseek-v4.1-flash";
}
