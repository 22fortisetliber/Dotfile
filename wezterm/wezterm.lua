-- Pull in the wezterm API
local wezterm = require 'wezterm'
local fonts = require 'fonts'
-- This will hold the configuration.
local config = wezterm.config_builder()
config.enable_tab_bar = true
config.automatically_reload_config = true
config.window_frame = {
	font_size = 10,
	-- Fancy tab bar
	active_titlebar_bg = '#5e7351',
	inactive_titlebar_bg = '#5e7351',
  	inactive_titlebar_fg = '#6881a1',
  	active_titlebar_fg = '#ffffff',
  	inactive_titlebar_border_bottom = '#2b2042',
  	active_titlebar_border_bottom = '#2b2042',
  	button_fg = '#cccccc',
  	button_bg = '#2b2042',
  	button_hover_fg = '#ffffff',
  	button_hover_bg = '#3b3052', }
-- Setup font configuration 
fonts.setup(config)
-- Setup tab configuration
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Lunaria Light (Gogh)'
-- config.color_scheme = 'Catppuccin Latte'

-- Setup tab title
function contains(str, substr)
    return string.find(str, substr) ~= nil
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

local function get_current_working_dir(tab)
    local current_tilte = tab_title(tab)
    if contains(current_tilte, "tmux") then
        return "TMUX Session"
    end
	local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = '' }
	local HOME_DIR = string.format('file://%s', os.getenv('HOME'))
	return current_dir == HOME_DIR and '.'
	or string.gsub(current_dir.file_path, '(.*[/\\])(.*)', '%2')
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#800610'
      foreground = '#c0c0c0'
    elseif hover then
      background = '#3b3052'
      foreground = '#909090'
    end

    local edge_foreground = background

    local title = tab_title(tab)
    local index = tonumber(tab.tab_index) + 1
    local custom_title = tab.tab_title
    local title = get_current_working_dir(tab)
    if custom_title and #custom_title > 0 then
    	title = custom_title
    end
    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = string.format('  %s•%s  ', index, title) },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
    }
  end
)

-- Mouse
config.mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'NONE',
		action = wezterm.action.CompleteSelection('ClipboardAndPrimarySelection'),
	},

	-- Open links on Cmd+click
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CMD',
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
  }
-- and finally, return the configuration to wezterm
return config
