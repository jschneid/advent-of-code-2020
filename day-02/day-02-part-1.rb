def valid_passwords_count
  records = File.readlines('input.txt')
  valid_passwords = 0

  records.each do |record|
    count_separator_index = record.index('-')
    count_end_index = record.index(' ')
    target_character_separator_index = record.index(':')

    minimum_allowed_count = record[0..count_separator_index - 1].to_i
    maximum_allowed_count = record[count_separator_index + 1..count_end_index - 1].to_i
    target_character = record[target_character_separator_index - 1]
    password = record[target_character_separator_index + 2..-1]

    target_character_count = password.count(target_character)

    if target_character_count >= minimum_allowed_count && target_character_count <= maximum_allowed_count
      valid_passwords += 1
    end
  end

  valid_passwords
end

puts valid_passwords_count
