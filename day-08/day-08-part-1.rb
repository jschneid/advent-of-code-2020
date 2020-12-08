def boot_game_console
  instructions = File.readlines('input.txt', chomp: true)
  state = {
    instruction_pointer: 0,
    accumulator: 0,
    instructions_executed: []
  }

  loop do
    return state[:accumulator] if state[:instructions_executed].include?(state[:instruction_pointer])
    process_instruction(instructions, state)
  end
end

def process_instruction(instructions, state)
  instruction = instructions[state[:instruction_pointer]][0..2]
  argument = instructions[state[:instruction_pointer]][4..].to_i
  state[:instructions_executed] << state[:instruction_pointer]
  case instruction
  when 'nop'
    state[:instruction_pointer] += 1
  when 'acc'
    state[:accumulator] += argument
    state[:instruction_pointer] += 1
  when 'jmp'
    state[:instruction_pointer] += argument
  end
end

puts boot_game_console
