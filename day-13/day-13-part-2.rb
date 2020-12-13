def find_contest_earliest_timestamp
  input = File.readlines('input.txt')
  bus_ids = input[1].split(',').map(&:to_i)

  bus_positions = {}
  bus_ids.each_with_index do |bus_id, i|
    next if bus_id == 0
    bus_positions[i] = bus_id
  end

  solve(bus_positions)
end

def solve(bus_positions)
  # The approach we'll take here, in order to keep the runtime short, is to find a series of
  # "partial solutions": The first for just the first two bus IDs; then for those two and
  # the next one; and so on, until we've included them all.

  t = bus_positions[0]
  solved_bus_positions = {}
  solved_bus_positions[0] = bus_positions[0]

  bus_positions.each do |position, bus_id|

    # The delta between the timestamp of the last partial solution we found, and the next one,
    # will be some multiple of the least common multiple of the bus_ids in that partial solution.
    interval = solved_bus_positions.values.reduce(1, :lcm)

    active_bus_positions = solved_bus_positions
    active_bus_positions[position] = bus_id

    loop do
      if check_solution(active_bus_positions, t)
        solved_bus_positions = active_bus_positions
        break
      end
      t += interval
    end
  end

  t
end

def check_solution(bus_positions, t)
  bus_positions.each do |position, bus_id|
    return false if (t + position) % bus_id != 0
  end
  true
end

puts find_contest_earliest_timestamp
