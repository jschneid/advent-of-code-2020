def count_trees
  terrain = File.readlines('input.txt', chomp: true)
  x = 0
  trees_encountered = 0
  terrain.each do |row|
    trees_encountered += 1 if row[x] == '#'
    x = (x + 3) % terrain[0].length
  end
  trees_encountered
end

puts count_trees
