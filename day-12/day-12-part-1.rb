def manhattan_distance_to_destination
  instructions = File.readlines('input.txt')
  position = {
    facing: 90,
    x: 0,
    y: 0
  }
  instructions.each do |instruction|
    update_position(position, instruction)
  end
  position[:x].abs() + position[:y].abs()
end

def update_position(position, instruction)
  maneuver_type = instruction[0]
  maneuver_value = instruction[1..].to_i
  case maneuver_type
  when 'N'
    position[:y] += maneuver_value
  when 'S'
    position[:y] -= maneuver_value
  when 'E'
    position[:x] += maneuver_value
  when 'W'
    position[:x] -= maneuver_value
  when 'L'
    position[:facing] = (position[:facing] - maneuver_value) % 360
  when 'R'
    position[:facing] = (position[:facing] + maneuver_value) % 360
  when 'F'
    translated_instruction = get_direction_of_facing(position[:facing]) + maneuver_value.to_s
    update_position(position, translated_instruction)
  end
end

def get_direction_of_facing(facing)
  case facing
  when 0
    return 'N'
  when 90
    return 'E'
  when 180
    return 'S'
  else
    return 'W'
  end
end

puts manhattan_distance_to_destination
