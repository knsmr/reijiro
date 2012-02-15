module ApplicationHelper
  def due_stats_button
    link_to "NextUp (#{Clip.overdue_count})", nextup_path
  end
end
