module WorkoutsHelper
  # Server-rendered SVG bar chart of daily steps (zero JS).
  # `series` is an array of [date, steps] pairs; returns nil if too little data.
  def steps_chart(series, width: 720, height: 200, pad: 28)
    series = series.select { |(_d, s)| s.to_i.positive? }
    return nil if series.size < 2

    values = series.map { |(_d, s)| s.to_i }
    max = values.max
    inner_w = width - pad * 2
    inner_h = height - pad * 2
    gap = 4
    bar_w = [ (inner_w / series.size) - gap, 2 ].max

    bars = series.each_with_index.map do |(date, steps), i|
      h = max.zero? ? 0 : (inner_h * steps.to_f / max)
      {
        x: (pad + i * (inner_w / series.size)).round(1),
        y: (pad + inner_h - h).round(1),
        w: bar_w.round(1),
        h: h.round(1),
        steps: steps,
        date: date
      }
    end

    { width:, height:, pad:, max:, bars: }
  end
end
