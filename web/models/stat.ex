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
    field :expires_at, Ecto.Time

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:key, :data, :project_id, :workflow_id, :subject_set_id, :subject_id, :user_id, :expires_at])
    |> validate_required([:key, :data, :expires_at])
  end
end
