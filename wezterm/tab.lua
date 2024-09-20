local wezterm = require("wezterm")

local module = {}

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

function module.setup(config)
    config.window_frame.font = wezterm.font_with_fallback({"RobotoMono Nerd Font Mono", "Iosevka Nerd Font"})
    config.window_frame.font_size = 10
    config.window_frame.active_titlebar_bg = config.colors.background
    config.window_frame.inactive_titlebar_bg = config.colors.background
    config.tab_bar_at_bottom = true
    config.show_new_tab_button_in_tab_bar = false
    config.use_fancy_tab_bar = true
    config.tab_max_width = 50
    config.hide_tab_bar_if_only_one_tab = true
    config.show_new_tab_button_in_tab_bar = false -- Wait for https://github.com/wez/wezterm/pull/3818 to be merged.

    wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
        local background = config.colors.background
        local foreground = config.colors.cursor_bg

        if tab.is_active then
            foreground = config.colors.ansi[2]
        elseif hover then
            foreground = config.colors.foreground
        end

        local title = tab_title(tab)

        -- ensure that the titles fit in the available space,
        -- and that we have room for the edges.
        title = wezterm.truncate_right(title, max_width - 2)

        return {{
            Background = {
                Color = background
            }
        }, {
            Foreground = {
                Color = foreground
            }
        }, {
            Text = string.format(" %s ", title)
        }, {
            Background = {
                Color = background
            }
        }, {
            Foreground = {
                Color = foreground
            }
        }}
    end)
end

return module

