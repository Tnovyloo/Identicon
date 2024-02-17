defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
    main function of program.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
    Building Image grid.
  """
  def build_grid(image_struct) do
    # What means '&mirror_row/1' - it means: for every 'iteration' of map function take the &mirror_row (Something like a C-lang address operator)
    #   and the '/1' is a length of arguments that takes this out function.
    image_struct = %Identicon.Image{image_struct | grid: image_struct.hex |> Enum.chunk(3) |> Enum.map(&mirror_row/1)}

  end

  @doc """
    Mirror row function, if [220, 120, 212] array is given then returned value will be [220, 120, 212, 120, 220]
  """
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
    Function to get only first 3 values (R, G, B), and returning new Struct with color property.
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image_struct) do
    # We could return this
    # %Identicon.Image{hex: image_struct.hex, color: {r, g, b}}
    # Or we could return this:
    %Identicon.Image{image_struct | color: {r, g, b}}
  end

  @doc """
    Hashing input to list of numbers.
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end



end
