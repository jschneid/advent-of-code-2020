def count_trees(terrain, slope_x, slope_y)
  x = 0
  y = 0
  trees_encountered = 0
  while y < terrain.length
    trees_encountered += 1 if terrain[y][x] == '#'
    x = (x + slope_x) % terrain[0].length
    y += slope_y
  end
  trees_encountered
end

terrain = File.readlines('input.txt', chomp: true)
trees_encountered_1_1 = count_trees(terrain, 1, 1)
trees_encountered_3_1 = count_trees(terrain, 3, 1)
trees_encountered_5_1 = count_trees(terrain, 5, 1)
trees_encountered_7_1 = count_trees(terrain, 7, 1)
trees_encountered_1_2 = count_trees(terrain, 1, 2)
puts trees_encountered_1_1 * trees_encountered_3_1 * trees_encountered_5_1 * trees_encountered_7_1 * trees_encountered_1_2
