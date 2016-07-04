defmodule Statistics.StatController do
  use Statistics.Web, :controller

  alias Statistics.Stat

  def index(conn, _params) do
    stats = Repo.all(Stat)
    render(conn, "index.json", stats: stats)
  end

  def create(conn, %{"stat" => stat_params}) do
    changeset = Stat.changeset(%Stat{}, stat_params)

    case Repo.insert(changeset) do
      {:ok, stat} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", stat_path(conn, :show, stat))
        |> render("show.json", stat: stat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Statistics.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, params) do
    stat = find_stat(params)
    render(conn, "show.json", stat: stat)
  end

  def update(conn, params = %{"stat" => stat_params}) do
    stat = find_stat(params)
    changeset = Stat.changeset(stat, stat_params)

    case Repo.update(changeset) do
      {:ok, stat} ->
        render(conn, "show.json", stat: stat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Statistics.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stat = Repo.get!(Stat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(stat)

    send_resp(conn, :no_content, "")
  end

  defp find_stat(params = %{"key" => key}) do
    Stat
    |> Stat.with_key(key)
    |> filter_project_id(params)
    |> filter_workflow_id(params)
    |> filter_subject_set_id(params)
    |> filter_subject_id(params)
    |> filter_user_id(params)
  end

  defp filter_project_id(query, %{"project_id" => project_id}) do
    from s in query, where: s.project_id == ^project_id
  end

  defp filter_project_id(query, _) do
    query
  end

  defp filter_workflow_id(query, %{"workflow_id" => workflow_id}) do
    from s in query, where: s.workflow_id == ^workflow_id
  end

  defp filter_workflow_id(query, _) do
    query
  end

  defp filter_subject_set_id(query, %{"subject_set_id" => subject_set_id}) do
    from s in query, where: s.subject_set_id == ^subject_set_id
  end

  defp filter_subject_set_id(query, _) do
    query
  end

  defp filter_subject_id(query, %{"subject_id" => subject_id}) do
    from s in query, where: s.subject_id == ^subject_id
  end

  defp filter_subject_id(query, _) do
    query
  end

  defp filter_user_id(query, %{"user_id" => user_id}) do
    from s in query, where: s.user_id == ^user_id
  end

  defp filter_user_id(query, _) do
    query
  end
end
