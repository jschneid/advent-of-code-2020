def valid_passwords_count
  records = File.readlines('input.txt')
  valid_passwords = 0

  records.each do |record|
    position_separator_index = record.index('-')
    position_end_index = record.index(' ')
    target_character_separator_index = record.index(':')

    target_index_1 = record[0..position_separator_index - 1].to_i - 1
    target_index_2 = record[position_separator_index + 1..position_end_index - 1].to_i - 1
    target_character = record[target_character_separator_index - 1]
    password = record[target_character_separator_index + 2..-1]

    target_character_count = 0
    target_character_count += 1 if password[target_index_1] == target_character
    target_character_count += 1 if password[target_index_2] == target_character

    valid_passwords += 1 if target_character_count == 1
  end

  valid_passwords
end

puts valid_passwords_count
