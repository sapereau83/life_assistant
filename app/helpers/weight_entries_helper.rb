module WeightEntriesHelper
  # Builds the geometry for a zero-JS, server-rendered SVG line chart.
  # Pass `target:` (kg) to draw a goal line; the y-range is stretched to keep
  # it in view. Returns nil when there isn't enough data to draw a line.
  def weight_chart(entries, width: 720, height: 220, pad: 28, target: nil)
    points = entries.map { |e| [ e.recorded_on, e.weight_kg.to_f ] }
    return nil if points.size < 2

    weights = points.map(&:last)
    min = weights.min
    max = weights.max
    # Stretch the range so the target line stays visible.
    if target
      min = [ min, target ].min
      max = [ max, target ].max
    end
    margin = (max - min).zero? ? 1.0 : (max - min) * 0.06
    min -= margin
    max += margin
    span = (max - min).zero? ? 1.0 : (max - min)

    inner_w = width - pad * 2
    inner_h = height - pad * 2
    last_i = points.size - 1
    y_for = ->(kg) { (pad + inner_h * (1 - (kg - min) / span)).round(1) }

    coords = points.each_with_index.map do |(date, kg), i|
      x = pad + (inner_w * (last_i.zero? ? 0 : i.to_f / last_i))
      { x: x.round(1), y: y_for.call(kg), date: date, kg: kg }
    end

    {
      width:, height:, pad:,
      min:, max:,
      coords:,
      target:,
      target_y: target && y_for.call(target),
      line: coords.map { |c| "#{c[:x]},#{c[:y]}" }.join(" "),
      area: "#{pad},#{height - pad} " +
            coords.map { |c| "#{c[:x]},#{c[:y]}" }.join(" ") +
            " #{width - pad},#{height - pad}"
    }
  end
end
