def boot_game_console
  instructions = File.readlines('input.txt', chomp: true)
  instruction_flip_index = -1

  loop do
    instruction_flip_index = flip_next_instruction(instructions, instruction_flip_index)
    run_result = run_program(instructions)
    return run_result unless run_result.nil?
    undo_flip_instruction(instructions, instruction_flip_index)
  end
end

def run_program(instructions)
  state = {
    instruction_pointer: 0,
    accumulator: 0,
    instructions_executed: []
  }
  loop do
    return state[:accumulator] if state[:instruction_pointer] >= instructions.length
    return nil if state[:instructions_executed].include?(state[:instruction_pointer])
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

def flip_next_instruction(instructions, instruction_flip_index)
  loop do
    instruction_flip_index += 1
    instruction = instructions[instruction_flip_index][0..2]
    if (instruction == 'nop')
      instructions[instruction_flip_index] = 'jmp' + instructions[instruction_flip_index][3..]
      return instruction_flip_index
    elsif (instruction == 'jmp')
      instructions[instruction_flip_index] = 'nop' + instructions[instruction_flip_index][3..]
      return instruction_flip_index
    end
  end
end

def undo_flip_instruction(instructions, instruction_flip_index)
  instruction = instructions[instruction_flip_index][0..2]
  if (instruction == 'nop')
    instructions[instruction_flip_index] = 'jmp' + instructions[instruction_flip_index][3..]
  else # jmp
    instructions[instruction_flip_index] = 'nop' + instructions[instruction_flip_index][3..]
  end
end

puts boot_game_console
