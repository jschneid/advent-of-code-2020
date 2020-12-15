def get_2020th_number_spoken
  numbers = File.read('input.txt').split(',').map(&:to_i)
  while numbers.count < 2020 do
    add_next_number(numbers)
  end
  numbers[-1]
end

def add_next_number(numbers)
  prior_index = numbers[..-2].rindex(numbers[-1])
  if prior_index.nil?
    numbers << 0
  else
    numbers << numbers.length - prior_index - 1
  end
end

pp get_2020th_number_spoken

