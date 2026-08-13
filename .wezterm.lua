-- Pull in the wezterm API
local wezterm = require("wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 240
config.initial_rows = 60

-- or, changing the font size and color scheme.
config.font_size = 13
-- config.color_scheme = "iTerm2 Solarized Dark"
config.color_scheme = "Solarized Dark (Gogh)"
-- config.color_scheme = "Catppuccin Macchiato"

config.font = wezterm.font("Pragmata Pro NerdFont")

config.use_fancy_tab_bar = false
tabline.setup({
	options = {
		icons_enabled = true,
		theme = config.color_scheme,
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = { " " },
		tab_active = {
			"index",
			{ "process", padding = { left = 0, right = 0 } },
			":",
			{ "parent", padding = { left = 1, right = 0 } },
			"/",
			{ "cwd", max_length = 10, padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = {
			"index",
			{ "process", padding = { left = 0, right = 0 } },
			":",
			{ "parent", padding = { left = 1, right = 0 } },
			"/",
			{ "cwd", max_length = 10, padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tabline_x = { "ram", "cpu" },
		tabline_y = { "battery", "datetime" },
		tabline_z = { "domain" },
	},
	extensions = {},
})
tabline.apply_to_config(config)

local act = wezterm.action
config.keys = {
    -- Disabled in favor of Zellij^W Herdr
    --[=[
	{
		key = "LeftArrow",
		mods = "ALT|CTRL",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "ALT|CTRL",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "LeftArrow",
		mods = "SHIFT|ALT|CTRL",
		action = act.MoveTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "SHIFT|ALT|CTRL",
		action = act.MoveTabRelative(1),
	},
	{
		key = "t",
		mods = "CTRL",
		action = act.SpawnCommandInNewTab({ cwd = "/home/sergey-morozov" }),
	},
    --]=]

	-- Clears the scrollback and viewport, and then sends CTRL-L to ask the
	-- shell to redraw its prompt
    -- Disabled not to uglify Herdr
    --[=[
	{
		key = "K",
		mods = "CTRL|SHIFT",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
    --]=]
}

local act = wezterm.action
config.mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("PrimarySelection"),
	},

	-- and make CTRL-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},

	-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.Nop,
	},
}

-- Maximize terminal window on startup
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Finally, return the configuration to wezterm:
return config
