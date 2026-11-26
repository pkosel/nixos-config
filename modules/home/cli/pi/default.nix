{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      pi
      # The mcp-nixos server used by pi runs through uvx.
      uv
    ];

    file = {
      ".pi/agent/themes/nightowl.json".source = ./themes/nightowl.json;
      ".pi/agent/themes/nightowl-light.json".source = ./themes/nightowl-light.json;
      # Loading agent-stuff's answer extension as well would register /answer twice.
      ".pi/agent/extensions/answer.ts".source = ./extensions/answer.ts;
      ".pi/agent/extensions/answer.LICENSE".source = ./extensions/answer.LICENSE;
      ".pi/agent/skills/commit".source = ./skills/commit;
      # https://github.com/janestreet/agent_skills/tree/469868f4489cbdbe178c775a0af05bb6bef63689/socratic-tutor
      ".pi/agent/skills/socratic-tutor".source = ./skills/socratic-tutor;
    };

    sessionVariables.PI_ANSWER_MODEL = "openai/gpt-6-luna";
  };
}
