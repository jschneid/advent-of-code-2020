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
  key_value_pair_strings = passport_string.split
  key_value_pairs = key_value_pair_strings.map { |key_value_pair_string| key_value_pair_string.split(':') }

  validate_byr(get_value_for_key('byr', key_value_pairs)) &&
    validate_iyr(get_value_for_key('iyr', key_value_pairs)) &&
    validate_eyr(get_value_for_key('eyr', key_value_pairs)) &&
    validate_hgt(get_value_for_key('hgt', key_value_pairs)) &&
    validate_hcl(get_value_for_key('hcl', key_value_pairs)) &&
    validate_ecl(get_value_for_key('ecl', key_value_pairs)) &&
    validate_pid(get_value_for_key('pid', key_value_pairs))
end

def get_value_for_key(key, key_value_pairs)
  key_value_pair = key_value_pairs.find { |key_value_pair| key_value_pair[0] == key }
  return '' if key_value_pair.nil?
  key_value_pair[1]
end

def validate_byr(byr)
  year = byr.to_i
  year >= 1920 && year <= 2002
end

def validate_iyr(iyr)
  year = iyr.to_i
  year >= 2010 && year <= 2020
end

def validate_eyr(eyr)
  year = eyr.to_i
  year >= 2020 && year <= 2030
end

def validate_hgt(hgt)
  return false if hgt.empty?
  number = hgt[..-3].to_i
  units = hgt[-2..]
  return (number >= 150 && number <= 193) if units == 'cm'
  number >= 59 && number <= 76
end

def validate_hcl(hcl)
  return false if hcl.length != 7
  /#[a-fA-F0-9]{6}/.match?(hcl)
end

def validate_ecl(ecl)
  valid_colors = ['amb','blu','brn','gry','grn','hzl','oth']
  valid_colors.include?(ecl)
end

def validate_pid(pid)
  return false if pid.length != 9
  /[0-9]{9}/.match?(pid)
end


puts valid_passports_count
