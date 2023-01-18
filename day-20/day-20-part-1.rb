class Tile
  attr_reader :id, :transformations

  def initialize(data)
    @id = data[0][5..8].to_i

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

  def debug_print
    p "Tile ID: #{@id}"
    transformations.each_with_index do |transformation, i|
      p "  Transformation #{i}:"
      @transformations[i].each do |line|
        p "  #{line}"
      end
      p ''
    end
    p ''
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

tiles = tiles_from_input
tiles[0].debug_print

