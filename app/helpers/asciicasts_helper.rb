module AsciicastsHelper

  def player(asciicast, options = {})
    if params[:fallback]
      player_class = "Asciinema.FallbackPlayer"
    else
      player_class =
        "window.Worker ? Asciinema.Player : Asciinema.FallbackPlayer"
    end

    if custom_renderer = params[:renderer]
      renderer_class = "Asciinema.Renderer.#{custom_renderer.capitalize}"
    else
      renderer_class = "Asciinema.Renderer.Pre"
    end

    render :partial => 'asciicasts/player', :locals => {
      asciicast: serialized_asciicast(asciicast),
      player_class: player_class,
      speed: (options[:speed] || params[:speed] || 1).to_f,
      benchmark: !!params[:bm],
      container_width: params[:container_width],
      renderer_class: renderer_class,
      auto_play: options.key?(:auto_play) ? !!options[:auto_play] : false,
      hud: options.key?(:hud) ? !!options[:hud] : true,
      size: options[:size] || params[:size] || 'small'
    }
  end

  def link_to_delete_asciicast(name, asciicast)
    link_to name, asciicast_path(asciicast), :method => :delete,
      :data => { :confirm => 'Really delete this asciicast?' }
  end

  private

  def serialized_asciicast(asciicast)
    AsciicastSerializer.new(asciicast).to_json
  end

end
