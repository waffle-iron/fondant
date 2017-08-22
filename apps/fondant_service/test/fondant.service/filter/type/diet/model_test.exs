defmodule Fondant.Service.Filter.Type.Diet.ModelTest do
    use Fondant.Service.Case
    use Translecto.Query

    alias Fondant.Service.Filter.Type.Diet

    @valid_model %Diet.Model{ name: 1 }

    test "empty" do
        refute_change(%Diet.Model{})
    end

    test "only name" do
        assert_change(%Diet.Model{}, %{ name: 1 })
    end

    test "uniqueness" do
        name = Fondant.Service.Repo.insert!(@valid_model)

        assert_change(%Diet.Model{}, %{ name: @valid_model.name })
        |> assert_insert(:error)
        |> assert_error_value(:name, { "has already been taken", [] })

        assert_change(%Diet.Model{}, %{ name: @valid_model.name + 1 })
        |> assert_insert(:ok)
    end

    test "translation" do
        en = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "en" })
        fr = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "fr" })
        en_vegan = Fondant.Service.Repo.insert!(Diet.Translation.Name.Model.changeset(%Diet.Translation.Name.Model{}, %{ translate_id: 1, locale_id: en.id, term: "vegan" }))
        fr_vegan = Fondant.Service.Repo.insert!(Diet.Translation.Name.Model.changeset(%Diet.Translation.Name.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "végétalien" }))
        en_vegetarian = Fondant.Service.Repo.insert!(Diet.Translation.Name.Model.changeset(%Diet.Translation.Name.Model{}, %{ translate_id: 2, locale_id: en.id, term: "vegetarian" }))
        fr_vegetarian = Fondant.Service.Repo.insert!(Diet.Translation.Name.Model.changeset(%Diet.Translation.Name.Model{}, %{ translate_id: 2, locale_id: fr.id, term: "végétarien" }))

        diet_vegan = Fondant.Service.Repo.insert!(Diet.Model.changeset(%Diet.Model{}, %{ name: en_vegan.translate_id }))
        diet_vegetarian = Fondant.Service.Repo.insert!(Diet.Model.changeset(%Diet.Model{}, %{ name: en_vegetarian.translate_id }))

        query = from diet in Diet.Model,
            locale: ^en.id,
            translate: name in diet.name,
            select: name.term

        assert Fondant.Service.Repo.all(query) == ["vegan", "vegetarian"]

        query = from diet in Diet.Model,
            locale: ^fr.id,
            translate: name in diet.name,
            select: name.term

        assert Fondant.Service.Repo.all(query) == ["végétalien", "végétarien"]

        query = from diet in Diet.Model,
            locale: ^fr.id,
            translate: name in diet.name, where: name.term == "végétarien",
            select: name.term

        assert Fondant.Service.Repo.all(query) == ["végétarien"]
    end
end
