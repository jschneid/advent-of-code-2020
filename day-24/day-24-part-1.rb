def count_flipped_tiles
  tile_paths = File.readlines('input.txt', chomp: true)
  black_tiles = {}

  tile_paths.each do |tile_path|
    position = get_tile_coordinate(tile_path)
    if black_tiles.key?(position)
      black_tiles[position] = !black_tiles[position]
    else
      black_tiles[position] = true
    end
  end

  black_tiles.values.count{ |tile| tile == true }
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

pp count_flipped_tiles
