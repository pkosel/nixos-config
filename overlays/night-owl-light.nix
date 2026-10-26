# Overlay that patches night-owl-nvim with a light variant.
# The patch replaces palette.lua with an auto-detecting version,
# removes the hardcoded dark background, and adds:
#   - palette-light.lua: light color palette
#   - night-owl-light.lua: lualine light theme
_final: prev: {
  vimPlugins = prev.vimPlugins // {
    night-owl-nvim = prev.vimPlugins.night-owl-nvim.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        cp ${./night-owl-light/palette.lua} lua/night-owl/palette.lua
        cp ${./night-owl-light/palette-light.lua} lua/night-owl/palette-light.lua
        cp ${./night-owl-light/config.lua} lua/night-owl/config.lua
        cp ${./night-owl-light/night-owl-light.lua} lua/lualine/themes/night-owl-light.lua
      '';
    });
  };
}
