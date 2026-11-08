{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      pi
      # The mcp-nixos server used by pi runs through uvx.
      uv
    ];

    file = {
      # Loading agent-stuff's answer extension as well would register /answer twice.
      ".pi/agent/extensions/answer.ts".source = ./answer.ts;
      ".pi/agent/extensions/answer.LICENSE".source = ./answer.LICENSE;
    };

    sessionVariables.PI_ANSWER_MODEL = "openrouter/openai/gpt-6-luna";
  };
}
