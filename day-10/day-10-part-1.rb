def product_of_1_and_3_diffs
  joltages = File.readlines('input.txt').map(&:to_i)
  joltages.sort!
  last_joltage = 0
  diff_1_count = 0
  diff_3_count = 0
  joltages.each do |joltage|
    diff = joltage - last_joltage
    diff_1_count += 1 if diff == 1
    diff_3_count += 1 if diff == 3
    last_joltage = joltage
  end
  diff_3_count += 1
  diff_1_count * diff_3_count
end

puts product_of_1_and_3_diffs
