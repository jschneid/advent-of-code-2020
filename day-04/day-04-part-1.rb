def valid_passports_count
  valid_count = 0
  passport = ''
  File.readlines('input.txt').each do |input_line|
    if input_line == "\n"
      valid_count += 1 if is_valid_passport(passport)
      passport = ''
    else
      passport += input_line
    end
  end
  valid_count += 1 if is_valid_passport(passport)
  valid_count
end

def is_valid_passport(passport_string)
  passport_string.include?('byr:') &&
    passport_string.include?('iyr:') &&
    passport_string.include?('eyr:') &&
    passport_string.include?('hgt:') &&
    passport_string.include?('hcl:') &&
    passport_string.include?('ecl:') &&
    passport_string.include?('pid:')
end

puts valid_passports_count
