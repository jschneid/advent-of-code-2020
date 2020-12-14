def emulate_ferry_initialization_v2
  instructions = File.readlines('input.txt', chomp: true)
  memory = {}
  bitmask = '0'

  instructions.each do |instruction|
    if (instruction[0..3] == 'mask')
      bitmask = instruction[7..]
    else
      instruction_address = instruction[4..].to_i
      floating_address = floating_address_from(instruction_address, bitmask)
      addresses = addresses_from_floating_address(floating_address)

      instruction_index = instruction.index('= ') + 2
      instruction_value = instruction[instruction_index..].to_i

      addresses.each do |address|
        memory[address] = instruction_value
      end
    end
  end

  memory.values.sum
end

def build_bitmask(input_bitmask, hot_character, noop_character)
  bitmask = ''
  input_bitmask.each_char do |char|
    bitmask += char == hot_character ? hot_character : noop_character
  end
  bitmask.to_i(2)
end

def floating_address_from(address, bitmask)
  floating_address = ''
  address_string = address.to_s(2).rjust(36, '0')
  (0..35).each do |i|
    case bitmask[i]
    when '0'
      floating_address += address_string[i]
    when '1'
      floating_address += '1'
    when 'X'
      floating_address += 'X'
    end
  end
  floating_address
end

def addresses_from_floating_address(floating_address)
  addresses = ['']
  floating_address.each_char do |char|
    case char
    when '0'
      addresses.map! { |address| address + '0' }
    when '1'
      addresses.map! { |address| address + '1' }
    when 'X'
      addresses_append_0 = addresses.map { |address| address + '0' }
      addresses_append_1 = addresses.map { |address| address + '1' }
      addresses = addresses_append_0 + addresses_append_1
    end
  end
  addresses.map { |address| address.to_i(2) }
end

puts emulate_ferry_initialization_v2
