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
      |> filter_odd_squares
      |> build_pixel_map
      |> draw_image
      |> save_image(input)
  end

  @doc """
    Saving and image file. (It is not Identicon.Image, it is a Imagefile from :egd file.)
  """
  def save_image(image_file, input) do
    File.write("#{input}.png", image_file)
  end

  @doc """
    Drawing an Identicon.Image struct.
  """
  def draw_image(image_struct) do
    %Identicon.Image{color: color, pixel_map: pixel_map} = image_struct

    # Creating canva
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    # Enum.each dont create a new collection.
    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)

    end)

    :egd.render(image)

  end


  @doc """
    Building pixel map from provided Identicon.Image grid and returns new Identicon.Image with created pixel map
  """
  def build_pixel_map(image_struct) do
    %Identicon.Image{grid: grid} = image_struct

    pixel_map = Enum.map(grid, fn({_code, index}) ->
      # Rest of dividing
      horizontal = rem(index, 5) * 50
      # Divides
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end)

    %Identicon.Image{image_struct | pixel_map: pixel_map}
  end

  @doc """
    Filters an grid in provided Identicon.Image and returns only even elements.
  """
  def filter_odd_squares(image_struct) do
    %Identicon.Image{image_struct | grid: image_struct.grid |> Enum.filter(fn {first, _} -> rem(first, 2) == 0 end)}
  end

  @doc """
    Building Image grid.
  """
  def build_grid(image_struct) do
    # What means '&mirror_row/1' - it means: for every 'iteration' of map function take the &mirror_row (Something like a C-lang address operator)
    #   and the '/1' is a length of arguments that takes this out function.
    %Identicon.Image{image_struct | grid: image_struct.hex |> Enum.chunk(3) |> Enum.map(&mirror_row/1) |> List.flatten |> Enum.with_index}
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
