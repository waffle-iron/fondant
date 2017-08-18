defmodule Fondant.Service.Filter.Type.Ingredient.ModelTest do
    use Fondant.Service.Case
    use Translecto.Query

    alias Fondant.Service.Filter.Type.Ingredient

    @valid_model %Ingredient.Model{ type: 1, name: 1 }

    test "empty" do
        refute_change(%Ingredient.Model{})
    end

    test "only type" do
        refute_change(%Ingredient.Model{}, %{ type: 1 })
    end

    test "only name" do
        assert_change(%Ingredient.Model{}, %{ name: 1 })
    end

    test "uniqueness" do
        name = Fondant.Service.Repo.insert!(@valid_model)

        assert_change(%Ingredient.Model{}, %{ type: @valid_model.type + 1, name: @valid_model.name })
        |> assert_insert(:error)
        |> assert_error_value(:name, { "has already been taken", [] })

        assert_change(%Ingredient.Model{}, %{ type: @valid_model.type, name: @valid_model.name + 1 })
        |> assert_insert(:ok)

        assert_change(%Ingredient.Model{}, %{ type: @valid_model.type + 1, name: @valid_model.name + 2 })
        |> assert_insert(:ok)
    end

    test "translation" do
        en = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "en" })
        fr = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "fr" })
        en_fruit = Fondant.Service.Repo.insert!(Ingredient.Translation.Type.Model.changeset(%Ingredient.Translation.Type.Model{}, %{ translate_id: 1, locale_id: en.id, term: "fruit" }))
        fr_fruit = Fondant.Service.Repo.insert!(Ingredient.Translation.Type.Model.changeset(%Ingredient.Translation.Type.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "fruit" }))
        en_apple = Fondant.Service.Repo.insert!(Ingredient.Translation.Name.Model.changeset(%Ingredient.Translation.Name.Model{}, %{ translate_id: 1, locale_id: en.id, term: "apple" }))
        fr_apple = Fondant.Service.Repo.insert!(Ingredient.Translation.Name.Model.changeset(%Ingredient.Translation.Name.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "pomme" }))
        en_lemon = Fondant.Service.Repo.insert!(Ingredient.Translation.Name.Model.changeset(%Ingredient.Translation.Name.Model{}, %{ translate_id: 2, locale_id: en.id, term: "lemon" }))
        fr_lemon = Fondant.Service.Repo.insert!(Ingredient.Translation.Name.Model.changeset(%Ingredient.Translation.Name.Model{}, %{ translate_id: 2, locale_id: fr.id, term: "citron" }))

        ingredient_apple = Fondant.Service.Repo.insert!(Ingredient.Model.changeset(%Ingredient.Model{}, %{ type: en_fruit.translate_id, name: en_apple.translate_id }))
        ingredient_lemon = Fondant.Service.Repo.insert!(Ingredient.Model.changeset(%Ingredient.Model{}, %{ type: en_fruit.translate_id, name: en_lemon.translate_id }))

        query = from ingredient in Ingredient.Model,
            locale: ^en.id,
            translate: name in ingredient.name,
            translate: type in ingredient.type,
            select: { name.term, type.term }

        assert Fondant.Service.Repo.all(query) == [{ "apple", "fruit" }, { "lemon", "fruit" }]

        query = from ingredient in Ingredient.Model,
            locale: ^fr.id,
            translate: name in ingredient.name,
            translate: type in ingredient.type,
            select: { name.term, type.term }

        assert Fondant.Service.Repo.all(query) == [{ "pomme", "fruit" }, { "citron", "fruit" }]

        query = from ingredient in Ingredient.Model,
            locale: ^fr.id,
            translate: name in ingredient.name, where: name.term == "citron",
            translate: type in ingredient.type,
            select: type.term

        assert Fondant.Service.Repo.all(query) == ["fruit"]
    end
end
