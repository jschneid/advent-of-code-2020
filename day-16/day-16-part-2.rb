def product_of_departure_values
  input_data = File.readlines('input.txt', chomp: true)
  valid_values = {}
  field_values = {}
  fields = []
  get_valid_values(input_data, valid_values, field_values, fields)

  first_nearby_ticket_index = input_data.find_index('nearby tickets:') + 1
  valid_tickets = []
  input_data[first_nearby_ticket_index..].each do |ticket|
    add_if_valid(ticket, valid_tickets, valid_values)
  end

  field_to_possible_positions = init_field_to_possible_positions(fields)

  pare_possible_positions_based_on_valid_tickets(field_to_possible_positions, valid_tickets, field_values)

  pare_fields_based_on_process_of_elimination(field_to_possible_positions)

  my_ticket_index = input_data.find_index('your ticket:') + 1
  my_ticket = input_data[my_ticket_index].split(',').map(&:to_i)
  product = 1
  field_to_possible_positions.each do |field, possible_positions|
    product *= my_ticket[possible_positions[0]] if field.start_with?('departure')
  end

  product
end

def add_if_valid(ticket, valid_tickets, valid_values)
  ticket.split(',').map(&:to_i).each do |value|
    return unless valid_values[value]
  end
  valid_tickets << ticket
end

def get_valid_values(input_data, valid_values, field_values, fields)
  last_ranges_index = input_data.find_index('') - 1
  (0..last_ranges_index).each do |i|
    sections = input_data[i].split(':')
    field = sections[0]
    fields << field
    field_values[field] = []
    ranges_words = sections[1].split(' ')
    add_values_in_range_to_valid_values(ranges_words[0], valid_values, field, field_values)
    add_values_in_range_to_valid_values(ranges_words[2], valid_values, field, field_values)
  end
end

def add_values_in_range_to_valid_values(range, valid_values, field, field_values)
  bounds = range.split('-').map(&:to_i)
  (bounds[0]..bounds[1]).each do |value|
    valid_values[value] = true
    field_values[field] << value
  end
end

def init_field_to_possible_positions(fields)
  field_to_possible_positions = {}

  fields.each do |field|
    field_to_possible_positions[field] = []
    fields.count.times do |position|
      field_to_possible_positions[field] << position
    end
  end

  field_to_possible_positions
end

def pare_possible_positions_based_on_valid_tickets(field_to_possible_positions, valid_tickets, field_values)
  field_to_possible_positions.each_key do |field|
    valid_tickets.each do |ticket|
      ticket.split(',').map(&:to_i).each_with_index do |value, index|
        field_to_possible_positions[field].delete(index) unless field_values[field].include?(value)
      end
    end
  end
end

def pare_fields_based_on_process_of_elimination(field_to_possible_positions)
  solved_fields = []
  while solved_fields.count < field_to_possible_positions.keys.count do
    field_to_possible_positions.each do |field, possible_positions|
      next if solved_fields.include?(field)
      if possible_positions.count == 1
        field_to_possible_positions.each_key do |field2|
          next if field == field2
          field_to_possible_positions[field2].delete(possible_positions[0])
        end
        solved_fields << field
      end
    end
  end
end

puts product_of_departure_values
