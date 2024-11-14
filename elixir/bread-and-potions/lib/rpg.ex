defmodule RPG do
  defprotocol Edible do
    def eat(item, character)
  end
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defimpl Edible, for: LoafOfBread do
    def eat(%LoafOfBread{}, %Character{} = character) do
      {nil, %{character | health: character.health + 5}}
    end
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defimpl Edible, for: ManaPotion do
    def eat(%ManaPotion{} = potion, %Character{} = character) do
      {%EmptyBottle{}, %{character | mana: character.mana + potion.strength}}
    end
  end

  defmodule Poison do
    defstruct []
  end

  defimpl Edible, for: Poison do
    def eat(%Poison{}, %Character{} = character) do
      {%EmptyBottle{}, %{character | health: 0}}
    end
  end
  # Add code to define the protocol and its implementations below here...
end
