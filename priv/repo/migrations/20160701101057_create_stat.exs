defmodule Statistics.Repo.Migrations.CreateStat do
  use Ecto.Migration

  def change do
    create table(:stats) do
      add :key, :string, null: false
      add :data, :map, null: false
      add :expires_at, :datetime

      add :project_id, :integer
      add :workflow_id, :integer
      add :subject_set_id, :integer
      add :subject_id, :integer
      add :user_id, :integer

      timestamps()
    end

    create index(:stats, [:key])
    create index(:stats, [:project_id])
    create index(:stats, [:workflow_id])
    create index(:stats, [:subject_set_id])
    create index(:stats, [:subject_id])
    create index(:stats, [:user_id])
  end
end
