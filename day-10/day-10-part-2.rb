def count_possible_adapter_combinations
  joltages = File.readlines('input.txt').map(&:to_i)
  joltages << 0
  joltages.sort!
  possible_paths_to_joltage = { 0 => 1 }

  joltages[1..].each do |joltage|
    input_joltages = joltage_inputs_for(joltages, joltage)
    possible_paths_to_joltage[joltage] = 0
    input_joltages.each do |input_joltage|
      possible_paths_to_joltage[joltage] += possible_paths_to_joltage[input_joltage]
    end
  end

  possible_paths_to_joltage[joltages[-1]]
end

def joltage_inputs_for(joltages, joltage)
  joltages.select { |input_joltage| joltage - input_joltage <= 3 && joltage - input_joltage >= 1 }
end

puts count_possible_adapter_combinations
