def emulate_ferry_initialization
  instructions = File.readlines('input.txt', chomp: true)
  memory = []
  or_bitmask = 0
  and_bitmask = 1

  instructions.each do |instruction|
    if (instruction[0..3] == 'mask')
      or_bitmask = build_bitmask(instruction[7..], '1', '0')
      and_bitmask = build_bitmask(instruction[7..], '0', '1')
    else
      address = instruction[4..].to_i
      instruction_index = instruction.index('= ') + 2
      instruction_value = instruction[instruction_index..].to_i
      instruction_value &= and_bitmask
      instruction_value |= or_bitmask
      memory[address] = instruction_value
    end
  end

  memory.compact.sum
end

def build_bitmask(input_bitmask, hot_character, noop_character)
  bitmask = ''
  input_bitmask.each_char do |char|
    bitmask += char == hot_character ? hot_character : noop_character
  end
  bitmask.to_i(2)
end

puts emulate_ferry_initialization
