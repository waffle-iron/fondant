defmodule Fondant.Service.Filter.Type.Diet.Model do
    use Ecto.Schema
    use Translecto.Schema.Translatable
    import Ecto.Changeset
    @moduledoc """
      A model representing the different diets.

      ##Fields

      ###:id
      Is the unique reference to the diet entry. Is an `integer`.

      ###:name
      Is the name of the diet. Is a `translatable`.
    """

    schema "diets" do
        translatable :name, Fondant.Service.Filter.Type.Diet.Translation.Name.Model
        timestamps()
    end

    @doc """
      Builds a changeset based on the `struct` and `params`.

      Enforces:
      * `name` field is translatable
      * `name` field is required
      * `name` field is unique
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> translatable_changeset(params, [:name])
        |> validate_required([:name])
        |> unique_constraint(:name)
    end
end
