def manhattan_distance_to_destination
  instructions = File.readlines('input.txt')
  ship_position = {
    x: 0,
    y: 0
  }
  waypoint_position = {
    x: 10,
    y: 1
  }
  instructions.each do |instruction|
    if instruction[0] == 'F'
      update_ship_position(ship_position, waypoint_position, instruction)
    else
      update_waypoint_position(waypoint_position, instruction)
    end
  end
  ship_position[:x].abs() + ship_position[:y].abs()
end

def update_waypoint_position(waypoint_position, instruction)
  maneuver_type = instruction[0]
  maneuver_value = instruction[1..].to_i
  case maneuver_type
  when 'N'
    waypoint_position[:y] += maneuver_value
  when 'S'
    waypoint_position[:y] -= maneuver_value
  when 'E'
    waypoint_position[:x] += maneuver_value
  when 'W'
    waypoint_position[:x] -= maneuver_value
  when 'L'
    rotate_waypoint_position(waypoint_position, 360 - maneuver_value)
  when 'R'
    rotate_waypoint_position(waypoint_position, maneuver_value)
  end
end

def rotate_waypoint_position(waypoint_position, degrees)
  prior_x = waypoint_position[:x]
  prior_y = waypoint_position[:y]

  case degrees
  when 90
    waypoint_position[:x] = prior_y
    waypoint_position[:y] = -1 * prior_x
  when 180
    waypoint_position[:x] = -1 * prior_x
    waypoint_position[:y] = -1 * prior_y
  when 270
    waypoint_position[:x] = -1 * prior_y
    waypoint_position[:y] = prior_x
  end
end

def update_ship_position(ship_position, waypoint_position, instruction)
  repeats = instruction[1..].to_i
  repeats.times do
    ship_position[:x] += waypoint_position[:x]
    ship_position[:y] += waypoint_position[:y]
  end
end

puts manhattan_distance_to_destination
