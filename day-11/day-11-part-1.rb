def count_quiescent_occupied_seats
  layout = File.readlines('input.txt', chomp: true)

  loop do
    previous_layout = Marshal.load(Marshal.dump(layout))
    layout = next_round_layout(layout)
    return count_occupied_seats(layout) if layout == previous_layout
  end
end

def count_occupied_seats(layout)
  occupied_seats = 0
  layout.each do |row|
    occupied_seats += row.count('#')
  end
  occupied_seats
end

def next_round_layout(layout)
  new_layout = Marshal.load(Marshal.dump(layout))

  (0..(layout.length - 1)).each do |y|
    (0..(layout[0].length - 1)).each do |x|
      new_layout[y][x] = next_round_seat(x, y, layout) if layout[y][x] != '.'
    end
  end

  new_layout
end

def next_round_seat(seat_x, seat_y, layout)
  adjacent_occupied_seats = 0
  ((seat_y - 1)..(seat_y + 1)).each do |y|
    ((seat_x - 1)..(seat_x + 1)).each do |x|
      next if seat_y == y && seat_x == x
      adjacent_occupied_seats += 1 if is_occupied(x, y, layout)
    end
  end

  return '#' if layout[seat_y][seat_x] == 'L' && adjacent_occupied_seats == 0
  return 'L' if layout[seat_y][seat_x] == '#' && adjacent_occupied_seats >= 4
  layout[seat_y][seat_x]
end

def is_occupied(x, y, layout)
  return false if x < 0 || y < 0 || y >= layout.length || x >= layout[0].length
  layout[y][x] == '#'
end

puts count_quiescent_occupied_seats
