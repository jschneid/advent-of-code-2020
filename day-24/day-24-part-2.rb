def count_flipped_tiles
  tiles = build_tiles_from_input

  100.times do
    tiles = iterate(tiles)
  end

  tiles.values.count{ |tile| tile == true }
end

def build_tiles_from_input
  tile_paths = File.readlines('input.txt', chomp: true)
  tiles = {}

  tile_paths.each do |tile_path|
    position = get_tile_coordinate(tile_path)
    if tiles.key?(position)
      tiles[position] = !tiles[position]
    else
      tiles[position] = true
    end
  end

  tiles
end

def get_tile_coordinate(tile_path)
  position={x:0, y:0, z:0}
  i = 0
  while (i < tile_path.length)
    next_move = tile_path[i..(i+1)]
    if next_move[0] == 'e'
      position = move_east(position)
      i += 1
    elsif next_move == 'se'
      position = move_southeast(position)
      i += 2
    elsif next_move == 'sw'
      position = move_southwest(position)
      i += 2
    elsif next_move[0] == 'w'
      position = move_west(position)
      i += 1
    elsif next_move == 'nw'
      position = move_northwest(position)
      i += 2
    elsif next_move == 'ne'
      position = move_northeast(position)
      i += 2
    end
  end
  position
end

def move_east(position)
  {x:position[:x]+1, y:position[:y]-1, z:position[:z]}
end

def move_southeast(position)
  {x:position[:x], y:position[:y]-1, z:position[:z]+1}
end

def move_southwest(position)
  {x:position[:x]-1, y:position[:y], z:position[:z]+1}
end

def move_west(position)
  {x:position[:x]-1, y:position[:y]+1, z:position[:z]}
end

def move_northwest(position)
  {x:position[:x], y:position[:y]+1, z:position[:z]-1}
end

def move_northeast(position)
  {x:position[:x]+1, y:position[:y], z:position[:z]-1}
end

def fill_in_adjacent_white_tiles(tiles)
  new_tile_positions = []
  tiles.keys.each do |position|
    next unless tiles[position] == true
    adjacent = move_east(position)
    new_tile_positions << adjacent unless tiles.key?(adjacent)
    adjacent = move_southeast(position)
    new_tile_positions << adjacent unless tiles.key?(adjacent)
    adjacent = move_southwest(position)
    new_tile_positions << adjacent unless tiles.key?(adjacent)
    adjacent = move_west(position)
    new_tile_positions << adjacent unless tiles.key?(adjacent)
    adjacent = move_northwest(position)
    new_tile_positions << adjacent unless tiles.key?(adjacent)
    adjacent = move_northeast(position)
    new_tile_positions << adjacent unless tiles.key?(adjacent)
  end
  new_tile_positions.each do |new_tile_position|
    tiles[new_tile_position] = false
  end
  tiles
end

def count_adjacent_black_tiles(tiles, position)
  adjacent = 0
  adjacent += 1 if tiles[move_east(position)]
  adjacent += 1 if tiles[move_southeast(position)]
  adjacent += 1 if tiles[move_southwest(position)]
  adjacent += 1 if tiles[move_west(position)]
  adjacent += 1 if tiles[move_northwest(position)]
  adjacent += 1 if tiles[move_northeast(position)]
  adjacent
end

def iterate(tiles)
  tiles = fill_in_adjacent_white_tiles(tiles)
  new_tiles = Marshal.load(Marshal.dump(tiles))
  tiles.keys.each do |position|
    adjacent = count_adjacent_black_tiles(tiles, position)
    if tiles[position]
      if adjacent == 0 || adjacent > 2
        new_tiles[position] = false
      end
    else
      if adjacent == 2
        new_tiles[position] = true
      end
    end
  end
  new_tiles
end

pp count_flipped_tiles
