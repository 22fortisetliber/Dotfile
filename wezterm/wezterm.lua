-- Pull in the wezterm API
local wezterm = require 'wezterm'
local fonts = require 'fonts'
-- This will hold the configuration.
local config = wezterm.config_builder()
config.enable_tab_bar = true
config.automatically_reload_config = true

-- Window appearance
config.window_background_opacity = 1.0
-- config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false

config.tab_bar_style = {
  new_tab = wezterm.format {
    { Foreground = { Color = '#618774' } },
    { Text = ' + ' },
  },
  new_tab_hover = wezterm.format {
    { Foreground = { Color = '#faf4ed' } },
    { Background = { Color = '#56949f' } },
    { Text = ' + ' },
  },
}

-- Define our DawnFox theme
config.color_schemes = {
  ["DawnFox"] = {
    foreground = "#575279",
    background = "#faf4ed",
    cursor_bg = "#d7827e",
    cursor_fg = "#faf4ed",
    cursor_border = "#d7827e",
    selection_bg = "#9F86C0",
    selection_fg = "#575279",
    
    ansi = {
      "#f2e9de", -- black (soft cream)
      "#b4637a", -- red (rose)
      "#618774", -- green (sage)
      "#ea9d34", -- yellow (amber)
      "#286983", -- blue (deep teal)
      "#907aa9", -- magenta (lavender)
      "#56949f", -- cyan (teal)
      "#575279", -- white (slate purple)
    },
    brights = {
      "#e6e0d8", -- bright black (lighter cream)
      "#d7827e", -- bright red (coral)
      "#68a49f", -- bright green (brighter sage)
      "#f6c177", -- bright yellow (golden)
      "#3e8fb0", -- bright blue (sky blue)
      "#9893bf", -- bright magenta (periwinkle)
      "#6cbfcb", -- bright cyan (bright teal)
      "#433e5c", -- bright white (dark slate)
    },
  },
}




-- Set our custom theme as the default
config.color_scheme = 'DawnFox'

-- Window frame styling with DawnFox colors
config.window_frame = {
  font_size = 10,
  -- Fancy tab bar with DawnFox theme
  active_titlebar_bg = '#f2e9de',
  inactive_titlebar_bg = '#f2e9de',
  inactive_titlebar_fg = '#9893a5',
  active_titlebar_fg = '#575279',
  inactive_titlebar_border_bottom = '#ebe0d6',
  active_titlebar_border_bottom = '#ebe0d6',
  button_fg = '#618774',
  button_bg = '#f2e9de',
  button_hover_fg = '#faf4ed',
  button_hover_bg = '#56949f',
}

-- Setup font configuration 
fonts.setup(config)

-- Window padding for a more spacious look
config.window_padding = {
  left = 14,
  right = 14,
  top = 14,
  bottom = 14,
}

-- Helper function to check if a string contains a substring
function contains(str, substr)
  return string.find(str, substr) ~= nil
end

-- This function returns the suggested title for a tab.
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

-- Get current working directory function
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

-- Tab title formatting with DawnFox colors
wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#ebe0d6'
    local background = '#f2e9de'
    local foreground = '#797593'
    
    if tab.is_active then
      background = '#d7827e' -- Coral for active tab (instead of pink)
      foreground = '#faf4ed'
    elseif hover then
      background = '#f6c177' -- Golden yellow for hover
      foreground = '#575279'
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

-- Mouse bindings (keeping the same as your original config)
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

-- Cursor customization
config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 800

-- Define key bindings for quick actions
local act = wezterm.action
config.keys = {
  -- Split panes
  { key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- Navigate between panes
  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  
  -- Tabs
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  
  -- Font size
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}

-- and finally, return the configuration to wezterm
return config
