defmodule Statistics.StatView do
  use Statistics.Web, :view

  def render("index.json", %{stats: stats}) do
    %{data: render_many(stats, Statistics.StatView, "stat.json")}
  end

  def render("show.json", %{stat: stat}) do
    %{data: render_one(stat, Statistics.StatView, "stat.json")}
  end

  def render("stat.json", %{stat: stat}) do
    %{key: stat.key,
      data: stat.data,
      project_id: stat.project_id,
      workflow_id: stat.workflow_id,
      subject_set_id: stat.subject_set_id,
      subject_id: stat.subject_id,
      user_id: stat.user_id,
      expires_at: stat.expires_at}
  end
end
