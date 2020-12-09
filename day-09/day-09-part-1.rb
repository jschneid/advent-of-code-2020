def find_nonconformant_xmas_number
  numbers = File.readlines('input.txt').map(&:to_i)
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

puts find_nonconformant_xmas_number
