defmodule Fondant.Service.Locale do
    @moduledoc """
      Convenience functions for retrieving locale id's.
    """

    import Ecto.Query

    defmodule NotFoundError do
        @moduledoc """
          Exception raised when a locale does not exist.
        """
        defexception [:message, :code]

        def exception(option), do: %Fondant.Service.Locale.NotFoundError{ message: "no locale exists for code: #{option[:code]}", code: option[:code] }
    end

    @doc """
      Get the locale_id for the given string or raise the exception
      `Fondant.Service.Locale.NotFoundError` on an invalid locale. For more details
      see: `to_locale_id/1`.
    """
    @spec to_locale_id!(String.t) :: integer
    def to_locale_id!(code) do
        case to_locale_id(code) do
            nil -> raise(Fondant.Service.Locale.NotFoundError, code: code)
            locale -> locale
        end
    end

    @doc """
      Get the locale_id for the given string or nil on an invalid locale.

      The string format takes the form of `language_country` or `language` when no
      country is specified. e.g. `"en"` and `"en_AU"` would be valid formats, the
      first referring to the english locale, the second referring to Australian
      english.
    """
    @spec to_locale_id(String.t) :: integer | nil
    def to_locale_id(<<language :: binary-size(2), "_", country :: binary-size(2)>>), do: to_locale_id(language, country)
    def to_locale_id(<<language :: binary-size(2)>>), do: to_locale_id(language, nil)

    @doc """
      Get the fallback list of locale_id's for the given string or raise the exception
      `Fondant.Service.Locale.NotFoundError` when no locales are found. For more details
      see: `to_locale_id_list/1`.
    """
    @spec to_locale_id_list!(String.t) :: [integer]
    def to_locale_id_list!(code) do
        case to_locale_id_list(code) do
            [] -> raise(Fondant.Service.Locale.NotFoundError, code: code)
            locale -> locale
        end
    end

    @doc """
      Get the fallback list of locale_id's for the given string or empty list if no
      locales were valid.

      The string format takes the form of `language_country` or `language` when no
      country is specified. e.g. `"en"` and `"en_AU"` would be valid formats, the
      first referring to the english locale, the second referring to Australian
      english.

      This list includes the top-most locale, and parent locales (to fallback to).
    """
    @spec to_locale_id_list(String.t) :: [integer] | nil
    def to_locale_id_list(<<language :: binary-size(2), "_", country :: binary-size(2)>>), do: [to_locale_id(language, country), to_locale_id(language, nil)] |> Enum.filter(&(&1 != nil))
    def to_locale_id_list(<<language :: binary-size(2)>>), do: [to_locale_id(language, nil)] |> Enum.filter(&(&1 != nil))

    defp to_locale_id(language, nil) do
        query = from locale in Fondant.Service.Locale.Model,
            where: locale.language == ^String.downcase(language) and is_nil(locale.country),
            select: locale.id

        Fondant.Service.Repo.one(query)
    end
    defp to_locale_id(language, country) do
        query = from locale in Fondant.Service.Locale.Model,
            where: locale.language == ^String.downcase(language) and locale.country == ^String.upcase(country),
            select: locale.id

        Fondant.Service.Repo.one(query)
    end
end
