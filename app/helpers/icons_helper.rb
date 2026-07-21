module IconsHelper
  # Inline stroke icons (heroicons-style) keyed by name, matching the sidebar's
  # visual language. Reused across dashboard cards so we never lean on emoji.
  ICON_PATHS = {
    tasks:   %(<path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>),
    weight:  %(<path stroke-linecap="round" stroke-linejoin="round" d="M3 3v18h18M7 14l3-3 3 3 5-6"/>),
    meals:   %(<path stroke-linecap="round" stroke-linejoin="round" d="M4 3v18M4 8h6a2 2 0 002-2V3M20 3v18M18 3v6a2 2 0 002 2"/>),
    workout: %(<path stroke-linecap="round" stroke-linejoin="round" d="M6.5 6.5l11 11M4 9l2-2m14 8l-2 2M9 4l11 11M4 9l5 5m1-11l11 11M15 20l5-5"/>),
    steps:   %(<path stroke-linecap="round" stroke-linejoin="round" d="M13 5l7 7-7 7M5 5l7 7-7 7"/>),
    streak:  %(<path stroke-linecap="round" stroke-linejoin="round" d="M15.362 5.214A8.252 8.252 0 0112 21 8.25 8.25 0 016.038 7.047 8.287 8.287 0 009 9.601a8.983 8.983 0 013.361-6.867 8.21 8.21 0 003 2.48z"/><path stroke-linecap="round" stroke-linejoin="round" d="M12 18a3.75 3.75 0 00.495-7.467 5.99 5.99 0 00-1.925 3.546 5.974 5.974 0 01-2.133-1.001A3.75 3.75 0 0012 18z"/>),
    check:   %(<path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>),
    goal:    %(<path stroke-linecap="round" stroke-linejoin="round" d="M12 15a3 3 0 100-6 3 3 0 000 6zM12 3v2m0 14v2m9-9h-2M5 12H3m14.66-6.66l-1.42 1.42M7.76 16.24l-1.42 1.42m12.32 0l-1.42-1.42M7.76 7.76L6.34 6.34"/>),
    nudge:   %(<path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0"/>),
    repeat:  %(<path stroke-linecap="round" stroke-linejoin="round" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>)
  }.freeze

  # `css` is developer-controlled (never user input), so raw is safe here.
  def ui_icon(name, css: "h-5 w-5")
    path = ICON_PATHS[name.to_sym]
    return "".html_safe unless path

    raw(%(<svg class="#{css}" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.7">#{path}</svg>))
  end
end
