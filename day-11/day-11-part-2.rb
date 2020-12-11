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

  (-1..1).each do |dy|
    (-1..1).each do |dx|
      next if dy == 0 && dx == 0
      visible_seat = get_visible_seat_in_direction(seat_x, seat_y, dx, dy, layout)
      adjacent_occupied_seats += 1 if visible_seat == '#'
    end
  end

  return '#' if layout[seat_y][seat_x] == 'L' && adjacent_occupied_seats == 0
  return 'L' if layout[seat_y][seat_x] == '#' && adjacent_occupied_seats >= 5
  layout[seat_y][seat_x]
end

def get_visible_seat_in_direction(seat_x, seat_y, dx, dy, layout)
  x = seat_x
  y = seat_y
  loop do
    x += dx
    y += dy

    return '.' if x < 0 || y < 0 || y >= layout.length || x >= layout[0].length

    next if layout[y][x] == '.'

    return layout[y][x]
  end
end

puts count_quiescent_occupied_seats
