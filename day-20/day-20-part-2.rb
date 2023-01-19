class Tile
  attr_reader :id, :transformations
  attr_accessor :x, :y, :fit_transformation

  def initialize(data)
    @id = data[0][5..8].to_i

    # Pre-compute all 8 possible transformations for this tile.
    # 0-3: The tile with rotations of 0, 90, 180, and 270 degrees.
    # 4-7: As 0-3, but with the tile having been flipped first.
    @transformations = []
    image = data[1..10].map(&:chars)

    4.times do
      @transformations << image
      image = rotate_clockwise(image)
    end

    image = flip_horizontally(image)
    @transformations << image

    3.times do
      image = rotate_clockwise(image)
      @transformations << image
    end
  end

  def rotate_clockwise(image)
    image.transpose.map(&:reverse)
  end

  def flip_horizontally(image)
    image.map(&:reverse)
  end

  # Borders are returned as a string in either left-to-right order
  # (for top and bottom edges) or top-to-bottom order (for left and
  # right edges). This allows us to determine if a pair of tiles
  # fit together by directly comparing their pair of touching borders.
  def top_border(transformation = @fit_transformation)
    @transformations[transformation][0].join
  end

  def bottom_border(transformation = @fit_transformation)
    @transformations[transformation].last.join
  end

  def left_border(transformation = @fit_transformation)
    @transformations[transformation].map(&:first).join
  end

  def right_border(transformation = @fit_transformation)
    @transformations[transformation].map(&:last).join
  end

  def row(row_number)
    @transformations[@fit_transformation][row_number]
  end

  def trim_border!
    @transformations[@fit_transformation] = @transformations[@fit_transformation][1..-2]

    @transformations[@fit_transformation].each_index do |row|
      @transformations[@fit_transformation][row] = @transformations[@fit_transformation][row][1..-2]
    end
  end
end

class Image
  def initialize(tiles)
    tiles.each do |tile|
      tile.trim_border!
    end

    min_y = tiles.map(&:y).min
    max_y = tiles.map(&:y).max

    pixels = []

    (min_y..max_y).each do |row_y|
      row_tiles = tiles.find_all{ |tile| tile.y == row_y }
      row_tiles.sort_by! { |tile| tile.x }
      (0..7).each do |tile_y|
        pixels << row_tiles.map { |row_tile| row_tile.row(tile_y) }.join.chars
      end
    end

    # Pre-compute all 8 possible transformations for this tile.
    @transformations = []

    4.times do
      @transformations << pixels
      pixels = rotate_clockwise(pixels)
    end

    pixels = flip_horizontally(pixels)
    @transformations << pixels

    3.times do
      pixels = rotate_clockwise(pixels)
      @transformations << pixels
    end

    @transformations.each { |transformation| tag_sea_monsters(transformation) }
  end

  def rotate_clockwise(pixels)
    pixels.transpose.map(&:reverse)
  end

  def flip_horizontally(pixels)
    pixels.map(&:reverse)
  end

  def water_roughness
    # We'll assume that the transformation with the most sea monsters
    # was the correct transformation. (In my input, only one transformation
    # had ANY sea monsters.)
    min_roughness = Float::INFINITY
    @transformations.each do |transformation|
      roughness = transformation.join.count('#')
      min_roughness = roughness if min_roughness > roughness
    end
    min_roughness
  end

  def tag_sea_monsters(transformation)
    (0..transformation.count - 4).each do |y|
      (0..transformation.first.count - 20).each do |x|
        tag_sea_monster(transformation, x, y) if sea_monster?(transformation, x, y)
      end
    end
  end

  def sea_monster?(transformation, x, y)
    monster_chars = ['#', 'O']
    monster_chars.include?(transformation[y + 1][x]) &&
      monster_chars.include?(transformation[y + 2][x + 1]) &&
      monster_chars.include?(transformation[y + 2][x + 4]) &&
      monster_chars.include?(transformation[y + 1][x + 5]) &&
      monster_chars.include?(transformation[y + 1][x + 6]) &&
      monster_chars.include?(transformation[y + 2][x + 7]) &&
      monster_chars.include?(transformation[y + 2][x + 10]) &&
      monster_chars.include?(transformation[y + 1][x + 11]) &&
      monster_chars.include?(transformation[y + 1][x + 12]) &&
      monster_chars.include?(transformation[y + 2][x + 13]) &&
      monster_chars.include?(transformation[y + 2][x + 16]) &&
      monster_chars.include?(transformation[y + 1][x + 17]) &&
      monster_chars.include?(transformation[y + 1][x + 18]) &&
      monster_chars.include?(transformation[y + 1][x + 19]) &&
      monster_chars.include?(transformation[y][x + 18])
  end

  def tag_sea_monster(transformation, x, y)
    transformation[y + 1][x] = 'O'
    transformation[y + 2][x + 1] = 'O'
    transformation[y + 2][x + 4] = 'O'
    transformation[y + 1][x + 5] = 'O'
    transformation[y + 1][x + 6] = 'O'
    transformation[y + 2][x + 7] = 'O'
    transformation[y + 2][x + 10] = 'O'
    transformation[y + 1][x + 11] = 'O'
    transformation[y + 1][x + 12] = 'O'
    transformation[y + 2][x + 13] = 'O'
    transformation[y + 2][x + 16] = 'O'
    transformation[y + 1][x + 17] = 'O'
    transformation[y + 1][x + 18] = 'O'
    transformation[y + 1][x + 19] = 'O'
    transformation[y][x + 18] = 'O'
  end
end

def tiles_from_input
  data = File.readlines('input.txt', chomp:true)

  tiles = []
  while data.length > 0
    tiles << Tile.new(data.shift(12))
  end

  tiles
end

# A key assumption that this makes which doesn't appear in the problem statement
# is that each pair of matching borders is UNIQUE. That is, if there exists a pair
# of tiles for which the borders match up (after flipping/rotating), we assume
# that there will NOT exist any other tiles with that same border.
#
# This assumption DOES hold up for my particular puzzle input, at least!
#
# If this assumption did NOT hold up, we'd need fancier logic which would undo
# some set of placed tiles, and try again in other combinations, in the event
# that we hit some state where no more tiles could be placed; or if the assembled
# map was some shape other than a square. We'd also need to test for ALL edges of
# a given tile matching the surrounding tiles, instead of assuming that match on
# one edge is good enough to be sure (as we do here).
def attempt_to_place_tile(remaining_tile, remaining_tiles, fit_tiles)
  fit_tiles.each do |fit_tile|
    (0..7).each do |transformation|
      if fit_tile.bottom_border == remaining_tile.top_border(transformation)
        place_tile(remaining_tile, fit_tile.x, fit_tile.y + 1, transformation, remaining_tiles, fit_tiles)
        return
      elsif fit_tile.top_border == remaining_tile.bottom_border(transformation)
        place_tile(remaining_tile, fit_tile.x, fit_tile.y - 1, transformation, remaining_tiles, fit_tiles)
        return
      elsif fit_tile.right_border == remaining_tile.left_border(transformation)
        place_tile(remaining_tile, fit_tile.x + 1, fit_tile.y, transformation, remaining_tiles, fit_tiles)
        return
      elsif fit_tile.left_border == remaining_tile.right_border(transformation)
        place_tile(remaining_tile, fit_tile.x - 1, fit_tile.y, transformation, remaining_tiles, fit_tiles)
        return
      end
    end
  end
end

def place_tile(remaining_tile, x, y, transformation, remaining_tiles, fit_tiles)
  remaining_tile.fit_transformation = transformation
  remaining_tile.x = x
  remaining_tile.y = y

  remaining_tiles.delete(remaining_tile)
  fit_tiles << remaining_tile
end

def assemble_tiles(tiles)
  tiles[0].x = 0
  tiles[0].y = 0
  tiles[0].fit_transformation = 0
  fit_tiles = [tiles[0]]

  remaining_tiles = tiles.drop(1)

  while remaining_tiles.count > 0
    remaining_tiles.each do |remaining_tile|
      attempt_to_place_tile(remaining_tile, remaining_tiles, fit_tiles)
    end
  end
end

tiles = tiles_from_input
assemble_tiles(tiles)
image = Image.new(tiles)
p image.water_roughness
