module ApplicationHelper
  def due_stats_button
    link_to "NextUp (#{Clip.overdue_count})", nextup_path
  end

  def twitterized_type(type)
    case type
    when :alert
      "alert-warning"
    when :error
      "alert-error"
    when :notice
      "alert-info"
    when :success
      "alert-success"
    else
      type.to_s
    end
  end
end
