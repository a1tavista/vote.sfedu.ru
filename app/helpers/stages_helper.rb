module StagesHelper
  def stage_semesters_list(stage)
    result = stage.semesters.map(&:full_title)

    if result.length > 1
      result[0..-2].join(", ") + " и " + result[-1]
    elsif result.length == "1"
      result[0]
    else
      "–"
    end
  end

  def stage_ladder_table(stage)
    index = 1
    result = ""
    result += <<~RANGE
      <tr>
        <td>от 0.0 до #{stage.scale_min.to_f}</td>
        <td>0</td>
      </tr>
    RANGE
    stage.scale_ladder.each do |range|
      range_begin, range_end = range.split("...")
      range_begin, range_end = range.split("..") if range_end.nil?
      result += <<~RANGE
        <tr>
          <td>от #{range_begin} до #{range_end}</td>
          <td>#{index}</td>
        </tr>
      RANGE
      index += 1
    end
    result.html_safe
  end
end
