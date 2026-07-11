module WeightEntriesHelper
  # Builds the geometry for a zero-JS, server-rendered SVG line chart.
  # Returns nil when there isn't enough data to draw a line.
  def weight_chart(entries, width: 720, height: 220, pad: 28)
    points = entries.map { |e| [ e.recorded_on, e.weight_kg.to_f ] }
    return nil if points.size < 2

    weights = points.map(&:last)
    min = weights.min
    max = weights.max
    span = (max - min).zero? ? 1.0 : (max - min)

    inner_w = width - pad * 2
    inner_h = height - pad * 2
    last_i = points.size - 1

    coords = points.each_with_index.map do |(date, kg), i|
      x = pad + (inner_w * (last_i.zero? ? 0 : i.to_f / last_i))
      y = pad + inner_h * (1 - (kg - min) / span)
      { x: x.round(1), y: y.round(1), date: date, kg: kg }
    end

    {
      width:, height:, pad:,
      min:, max:,
      coords:,
      line: coords.map { |c| "#{c[:x]},#{c[:y]}" }.join(" "),
      area: "#{pad},#{height - pad} " +
            coords.map { |c| "#{c[:x]},#{c[:y]}" }.join(" ") +
            " #{width - pad},#{height - pad}"
    }
  end
end
