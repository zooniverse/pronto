defmodule Statistics.Stat do
  use Statistics.Web, :model

  schema "stats" do
    field :key, :string
    field :data, :map
    field :project_id, :integer
    field :workflow_id, :integer
    field :subject_set_id, :integer
    field :subject_id, :integer
    field :user_id, :integer
    field :expires_at, Ecto.DateTime

    timestamps()
  end

  def with_key(query, key) do
    query |> where([stat], stat.key == ^key) 
  end

  def filter(query, params) do
    query
    |> filter_project_id(params)
    |> filter_workflow_id(params)
    |> filter_subject_set_id(params)
    |> filter_subject_id(params)
    |> filter_user_id(params)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:key, :data, :project_id, :workflow_id, :subject_set_id, :subject_id, :user_id, :expires_at])
    |> validate_required([:key, :data, :expires_at])
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
