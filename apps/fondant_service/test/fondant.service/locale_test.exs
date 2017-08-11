defmodule Fondant.Service.LocaleTest do
    use Fondant.Service.Case

    alias Fondant.Service.Locale

    @valid_model %Locale.Model{ language: "fr", country: "FR" }

    test "culture code lookups" do
        fr_france = Fondant.Service.Repo.insert!(@valid_model)

        assert fr_france.id == Locale.to_locale_id("fr_FR")
        assert nil == Locale.to_locale_id("fr")
        assert [fr_france.id] == Locale.to_locale_id_list("fr_FR")
        assert [] == Locale.to_locale_id_list("fr")

        fr = Fondant.Service.Repo.insert!(Locale.Model.changeset(@valid_model, %{ country: nil }))

        assert fr_france.id == Locale.to_locale_id("fr_FR")
        assert fr.id == Locale.to_locale_id("fr")
        assert [fr_france.id, fr.id] == Locale.to_locale_id_list("fr_FR")
        assert [fr.id] == Locale.to_locale_id_list("fr")
    end
end
