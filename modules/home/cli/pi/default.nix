{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      pi
      # The mcp-nixos server used by pi runs through uvx.
      uv
    ];

    file = {
      ".pi/agent/themes/nightowl.json".source = ./nightowl.json;
      ".pi/agent/themes/nightowl-light.json".source = ./nightowl-light.json;
      # Loading agent-stuff's answer extension as well would register /answer twice.
      ".pi/agent/extensions/answer.ts".source = ./answer.ts;
      ".pi/agent/extensions/answer.LICENSE".source = ./answer.LICENSE;
    };

    sessionVariables.PI_ANSWER_MODEL = "openrouter/openai/gpt-6-luna";
  };
}
