def get_ticket_scanning_error_rate
  input_data = File.readlines('input.txt', chomp: true)
  valid_values = get_valid_values(input_data)

  ticket_scanning_error_rate = 0
  first_nearby_ticket_index = input_data.find_index('nearby tickets:') + 1
  input_data[first_nearby_ticket_index..].each do |ticket|
    ticket.split(',').map(&:to_i).each do |value|
      ticket_scanning_error_rate += value unless valid_values[value]
    end
  end

  ticket_scanning_error_rate
end

def get_valid_values(input_data)
  valid_values = {}
  last_ranges_index = input_data.find_index('') - 1
  (0..last_ranges_index).each do |i|
    sections = input_data[i].split(':')
    ranges_words = sections[1].split(' ')
    add_values_in_range_to_valid_values(ranges_words[0], valid_values)
    add_values_in_range_to_valid_values(ranges_words[2], valid_values)
  end
  valid_values
end

def add_values_in_range_to_valid_values(range, valid_values)
  bounds = range.split('-').map(&:to_i)
  (bounds[0]..bounds[1]).each do |value|
    valid_values[value] = true
  end
end

puts get_ticket_scanning_error_rate
