{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      pi
      # The mcp-nixos server used by pi runs through uvx.
      uv
    ];

    # pi finds themes in ~/.pi/agent/themes; select one in /settings.
    # Choose "nightowl-light/nightowl" to follow the terminal appearance.
    file = {
      ".pi/agent/themes/nightowl.json".source = ./nightowl.json;
      ".pi/agent/themes/nightowl-light.json".source = ./nightowl-light.json;
      # Local fork of the answer extension. Drops the hardcoded
      # Anthropic/Codex extraction chain and reads PI_ANSWER_MODEL instead.
      # Remove extensions/answer.ts from the agent-stuff package entry
      # in ~/.pi/agent/settings.json so it does not register twice.
      ".pi/agent/extensions/answer.ts".source = ./answer.ts;
      ".pi/agent/extensions/answer.LICENSE".source = ./answer.LICENSE;
    };

    # provider/modelId, parsed by answer.ts.
    sessionVariables.PI_ANSWER_MODEL = "openrouter/openai/gpt-6-luna";
  };
}
