defmodule Statistics.StatTest do
  use Statistics.ModelCase

  alias Statistics.Stat

  @valid_attrs %{data: %{}, expires_at: %{year: 2015, month: 10, day: 20, hour: 14, min: 0, sec: 0}, key: "some content", project_id: 42, subject_id: 42, subject_set_id: 42, user_id: 42, workflow_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Stat.changeset(%Stat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Stat.changeset(%Stat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
