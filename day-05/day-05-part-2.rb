def find_missing_seat_id
  boarding_passes = File.readlines('input.txt')
  seat_ids = []
  boarding_passes.each do |boarding_pass|
    row = boarding_pass_code_to_int(boarding_pass[0..6])
    column = boarding_pass_code_to_int(boarding_pass[7..9])
    seat_id = row * 8 + column
    seat_ids << seat_id
  end
  find_missing_entry_in_sequential_list(seat_ids)
end

def find_missing_entry_in_sequential_list(list)
  list.sort!
  list.each_with_index do |item, index|
    return item + 1 if item + 1 != list[index + 1]
  end
end

def boarding_pass_code_to_int(code)
  code = code.gsub('F', '0')
  code = code.gsub('B', '1')
  code = code.gsub('L', '0')
  code = code.gsub('R', '1')
  code.to_i(2)
end

puts find_missing_seat_id
