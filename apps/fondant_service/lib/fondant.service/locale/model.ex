defmodule Fondant.Service.Locale.Model do
    use Ecto.Schema
    import Ecto
    import Ecto.Changeset
    import Protecto
    @moduledoc """
      A model representing the different languages using culture codes (ISO 3166-1
      alpha-2 and ISO 639-1 code).

      ##Fields
      The `:country` and `:language` fields are uniquely constrained.

      ###:id
      Is the unique reference to the locale entry. Is an `integer`.

      ###:country
      Is the country code (ISO 3166-1 alpha-2) of the locale. Is a 2 character
      uppercase `string`.

      ###:language
      Is the language code (ISO 639-1 code) of the locale. Is a 2 character
      lowercase `string`.
    """

    schema "locales" do
        field :country, :string
        field :language, :string
        timestamps()
    end

    @doc """
      Builds a changeset based on the `struct` and `params`.

      Enforces:
      * `language` field is supplied
      * `country` field is length of 2
      * `language` field is length of 2
      * formats the `country` field as uppercase
      * formats the `language` field as lowercase
      * checks uniqueness of given culture code
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:country, :language])
        |> validate_required(:language)
        |> validate_length(:country, is: 2)
        |> validate_length(:language, is: 2)
        |> format_uppercase(:country)
        |> format_lowercase(:language)
        |> unique_constraint(:culture_code)
    end
end
