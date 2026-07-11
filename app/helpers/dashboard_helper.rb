module DashboardHelper
  # Geometry for the steps-vs-weight-delta scatter plot (zero JS to draw;
  # Stimulus only adds hover tooltips). Returns nil if too few points.
  def scatter_chart(points, width: 720, height: 260, pad: 40)
    return nil if points.size < 3

    xs = points.map(&:steps)
    ys = points.map(&:delta)
    xmin, xmax = xs.minmax
    ymin, ymax = ys.minmax
    xmax += 1 if xmax == xmin
    ymin -= 0.1 if ymin == ymax
    ymax += 0.1 if ymin == ymax
    xspan = (xmax - xmin).to_f
    yspan = (ymax - ymin).to_f

    inner_w = width - pad * 2
    inner_h = height - pad * 2

    dots = points.map do |p|
      x = pad + inner_w * (p.steps - xmin) / xspan
      y = pad + inner_h * (1 - (p.delta - ymin) / yspan)
      sign = p.delta > 0 ? "+" : ""
      {
        x: x.round(1),
        y: y.round(1),
        gain: p.delta > 0,
        label: "#{l(p.date, format: :short)} · #{number_with_delimiter(p.steps)} pas · #{sign}#{number_with_precision(p.delta, precision: 1)} kg"
      }
    end

    zero_y = pad + inner_h * (1 - (0 - ymin) / yspan)
    zero_y = nil unless zero_y.between?(pad, height - pad)

    { width:, height:, pad:, dots:, zero_y: zero_y&.round(1), xmin:, xmax: }
  end
end
