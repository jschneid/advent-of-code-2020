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

def corner_tile_id_product(tiles)
  min_y = tiles.map(&:y).min
  max_y = tiles.map(&:y).max
  min_x = tiles.map(&:x).min
  max_x = tiles.map(&:x).max

  top_left_corner_tile = tiles.find { |tile| tile.x == min_x && tile.y == min_y }
  top_right_corner_tile = tiles.find { |tile| tile.x == max_x && tile.y == min_y }
  bottom_left_corner_tile = tiles.find { |tile| tile.x == min_x && tile.y == max_y }
  bottom_right_corner_tile = tiles.find { |tile| tile.x == max_x && tile.y == max_y }

  top_left_corner_tile.id * top_right_corner_tile.id * bottom_left_corner_tile.id * bottom_right_corner_tile.id
end

tiles = tiles_from_input
assemble_tiles(tiles)
p corner_tile_id_product(tiles)
