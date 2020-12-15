def get_30000000th_number_spoken
  starting_numbers = File.read('input.txt').split(',').map(&:to_i)

  numbers_to_last_round_spoken = {}
  starting_numbers[..-2].each_with_index do |number, i|
    numbers_to_last_round_spoken[number] = i
  end

  round = starting_numbers.count
  last_number_spoken = starting_numbers[-1]
  while round < 30000000 do
    last_number_spoken = add_next_number(numbers_to_last_round_spoken, last_number_spoken, round)
    round += 1
  end
  last_number_spoken
end

def add_next_number(numbers_to_last_round_spoken, last_number_spoken, round)
  last_round_spoken = numbers_to_last_round_spoken[last_number_spoken]
  if last_round_spoken.nil?
    numbers_to_last_round_spoken[last_number_spoken] = round - 1
    return 0
  else
    delta = (round - 1) - numbers_to_last_round_spoken[last_number_spoken]
    numbers_to_last_round_spoken[last_number_spoken] = round - 1
    return delta
  end
end

puts get_30000000th_number_spoken

