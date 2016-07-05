require IEx

defmodule Pronto.StatController do
  use Pronto.Web, :controller

  alias Pronto.Stat

  def index(conn, params) do
    stats = find_stats(params)
    render(conn, "index.json", stats: stats)
  end

  def upsert(conn, params) do
    case find_stat(params) do
      nil -> create_stat(conn, params)
      stat -> update_stat(conn, stat, params)
    end
  end

  defp create_stat(conn, %{"stat" => stat_params}) do
    changeset = Stat.changeset(%Stat{}, stat_params)

    case Repo.insert(changeset) do
      {:ok, stat} ->
        conn
        |> put_status(:created)
        |> render("show.json", stat: stat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Pronto.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp update_stat(conn, stat, %{"stat" => stat_params}) do
    changeset = Stat.changeset(stat, stat_params)

    case Repo.update(changeset) do
      {:ok, stat} ->
        conn
        |> put_status(:created)
        |> render("show.json", stat: stat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Pronto.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, params) do
    case find_stat(params) do
      nil -> put_status(conn, :not_found)
      stat ->
        Repo.delete!(stat)
        send_resp(conn, :no_content, "")
    end
  end

  defp find_stat(params = %{"key" => key}) do
    Stat
    |> Stat.with_key(key)
    |> Stat.filter(params)
    |> Repo.one
  end

  defp find_stats(params = %{"key" => key}) do
    Stat
    |> Stat.with_key(key)
    |> Stat.filter(params)
    |> Repo.all
  end
end
