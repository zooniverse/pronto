defmodule Pronto.GuardianSerializer do
  @behaviour Guardian.Serializer

  def for_token(user = %{}), do: { :ok, user }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token(user), do: { :ok, user }
  def from_token(_), do: { :error, "Unknown resource type" }
end
