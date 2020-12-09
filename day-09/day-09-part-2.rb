def find_nonconformant_xmas_number(numbers)
  cycle_length = 25
  (cycle_length..numbers.length-1).each do |index|
    xmas_sums = get_xmas_sums(numbers, index - cycle_length, cycle_length)
    return numbers[index] if !xmas_sums.include?(numbers[index])
  end
end

def get_xmas_sums(numbers, start_index, cycle_length)
  xmas_sums = []
  (start_index..start_index+cycle_length-2).each do |i|
    (i+1..start_index+cycle_length-1).each do |j|
      xmas_sums << numbers[i] + numbers[j] if numbers[i] != numbers[j]
    end
  end
  xmas_sums
end

def find_contiguous_set_sum(numbers, nonconformant_xmas_number)
  (0..numbers.length-1).each do |i|
    sequence_sum = numbers[i]
    (i+1..numbers.length-1).each do |j|
      sequence_sum += numbers[j]
      if sequence_sum == nonconformant_xmas_number
        min_in_sequence = numbers[i..j].min
        max_in_sequence = numbers[i..j].max
        return min_in_sequence + max_in_sequence
      end
    end
  end
end

numbers = File.readlines('input.txt').map(&:to_i)
nonconformant_xmas_number = find_nonconformant_xmas_number(numbers)
puts find_contiguous_set_sum(numbers, nonconformant_xmas_number)
