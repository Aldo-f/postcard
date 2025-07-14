module ThemeHelper
  # Renders a partial from the current theme if it exists, otherwise falls back to the default partial.
  def render_theme_partial(partial_path, **options)
    theme = current_theme || "default"
    theme_path = "themes/#{theme}/#{partial_path}"
    Rails.logger.info "[render_theme_partial] theme: #{theme}, partial_path: #{partial_path.inspect}, theme_path: #{theme_path.inspect}"
    if lookup_context.exists?(theme_path, [], true)
      Rails.logger.info "[render_theme_partial] Using theme override: #{theme_path}"
      render partial: theme_path, **options
    else
      Rails.logger.info "[render_theme_partial] No theme override found, using default: #{partial_path}"
      render partial: partial_path, **options
    end
  end

  # Returns the current theme. Override this method to provide custom theme selection logic.
  def current_theme
    @current_theme || Rails.configuration.theme_name || "default"
  end
end