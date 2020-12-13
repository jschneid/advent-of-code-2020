def earliest_bus_wait_time_product
  input = File.readlines('input.txt')
  start_timestamp = input[0].to_i
  bus_ids = input[1].split(',').map(&:to_i).reject(&:zero?)

  minimum_delay = nil
  product = nil
  bus_ids.each do |bus_id|
    next_departure_delay = next_departure_delay(bus_id, start_timestamp)
    if minimum_delay.nil? || next_departure_delay < minimum_delay
      minimum_delay = next_departure_delay
      product = bus_id * next_departure_delay
    end
  end

  product
end

def next_departure_delay(bus_id, timestamp)
  (bus_id - (timestamp % bus_id)) % bus_id
end

puts earliest_bus_wait_time_product
