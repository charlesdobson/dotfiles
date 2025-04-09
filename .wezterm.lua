local wezterm = require 'wezterm'
local config = wezterm.config_builder()

function scheme_for_appearance(appearance)
    if appearance:find "Dark" then
      return "Catppuccin Mocha"
    else
      return "Catppuccin Latte"
    end
end
local selected_scheme =  scheme_for_appearance(wezterm.gui.get_appearance())
local scheme =  wezterm.color.get_builtin_schemes()[selected_scheme]
config.color_schemes = {
    [selected_scheme] = scheme,
}
config.color_scheme = selected_scheme
config.colors = {
    tab_bar = {
        background = scheme.tab_bar.background,
        inactive_tab_edge = scheme.tab_bar.inactive_tab_edge,
        active_tab = {
            fg_color = scheme.tab_bar.active_tab.fg_color,
            bg_color = scheme.tab_bar.active_tab.bg_color,
            intensity = scheme.tab_bar.active_tab.intensity,
            italic = scheme.tab_bar.active_tab.italic,
            strikethrough = scheme.tab_bar.active_tab.strikethrough,
            underline = scheme.tab_bar.active_tab.underline,
        },
        inactive_tab = {
            fg_color = scheme.tab_bar.inactive_tab.fg_color,
            bg_color = scheme.tab_bar.inactive_tab.bg_color,
            intensity = scheme.tab_bar.inactive_tab.intensity,
            italic = scheme.tab_bar.inactive_tab.italic,
            strikethrough = scheme.tab_bar.inactive_tab.strikethrough,
            underline = scheme.tab_bar.inactive_tab.underline,
        },
        inactive_tab_hover = {
            fg_color = scheme.tab_bar.inactive_tab_hover.fg_color,
            bg_color = scheme.tab_bar.inactive_tab_hover.bg_color,
            intensity = scheme.tab_bar.inactive_tab_hover.intensity,
            italic = scheme.tab_bar.inactive_tab_hover.italic,
            strikethrough = scheme.tab_bar.inactive_tab_hover.strikethrough,
            underline = scheme.tab_bar.inactive_tab_hover.underline,
        },
    }
}

-- Main config
config.font = wezterm.font('JetBrains Mono')
config.font_size = 14.0
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.automatically_reload_config = true
config.window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 20,
}
config.exit_behavior = 'Close'
config.window_decorations = "RESIZE"
config.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.6,
}
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20
config.pane_focus_follows_mouse = true

-- Tab bar appearance
config.window_frame = {
    font = wezterm.font('JetBrains Mono'),
    font_size = 12.0,
    active_titlebar_bg = scheme.background,
    inactive_titlebar_bg = scheme.background,
}
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false

-- Key bindings
config.leader = {
    key = 'a',
    mods = 'CTRL',
    timeout_milliseconds = 1000
}
config.keys = {
    {
        key = 'f',
        mods = 'CMD',
        action = wezterm.action.ToggleFullScreen,
    },
    {
        key = 'w',
        mods = 'CMD',
        action = wezterm.action.CloseCurrentTab { confirm = true },
    },
    {
        key = 'd',
        mods = 'SHIFT|CMD',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'd',
        mods = 'CMD',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'w',
        mods = 'SHIFT|CMD',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    {key='k', mods='CMD', action=wezterm.action_callback(function(window, pane)
        local pos = pane:get_cursor_position()
        local move_viewport_to_scrollback = string.rep('\r\n', pos.y)
        pane:inject_output(move_viewport_to_scrollback)
        pane:send_text('\x0c') -- CTRL-L
      end)
    },
    {
        key = 'LeftArrow',
        mods = 'OPT',
        action = wezterm.action.SendString '\x1bb',
    },
    {
        key = 'RightArrow',
        mods = 'OPT',
        action = wezterm.action.SendString '\x1bf',
    },
    {
        key = 'LeftArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Left'),
    },
    {
        key = 'UpArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Up'),
    },
    {
        key = 'RightArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Right'),
    },
    {
        key = 'DownArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Down'),
    },
}

local function segments_for_right_status(window)
    return {
      os.getenv('USER'),
      wezterm.strftime('%a %b %-d %H:%M'),
      wezterm.hostname(),
    }
end

wezterm.on('update-status', function(window, _)
    local segments = segments_for_right_status(window)
  
    local color_scheme = window:effective_config().resolved_palette
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground
  
    local gradient_to, gradient_from = bg
    gradient_from = gradient_to:lighten(0.2)
  
    local gradient = wezterm.color.gradient(
      {
        orientation = 'Horizontal',
        colors = { gradient_from, gradient_to },
      },
      #segments -- only gives us as many colours as we have segments.
    )
  
    -- We'll build up the elements to send to wezterm.format in this table.
    local elements = {}
  
    for i, seg in ipairs(segments) do
      local is_first = i == 1
  
      if is_first then
        table.insert(elements, { Background = { Color = 'none' } })
      end
      table.insert(elements, { Foreground = { Color = gradient[i] } })
      table.insert(elements, { Text = utf8.char(0xe0b2)  }) -- solid left arrow
  
      table.insert(elements, { Foreground = { Color = fg } })
      table.insert(elements, { Background = { Color = gradient[i] } })
      table.insert(elements, { Text = ' ' .. seg .. ' ' })
    end
  
    window:set_right_status(wezterm.format(elements))
end)

local success, date, stderr = wezterm.run_child_process { 'date' }

wezterm.log_info(wezterm.format {
  { Attribute = { Underline = 'Single' } },
  { Foreground = { AnsiColor = 'Fuchsia' } },
  { Background = { Color = 'blue' } },
  { Text = 'Hello ' .. date .. ' ' },
  'ResetAttributes',
  { Text = 'this text has default attributes' },
})

-- Return the configuration
return config
