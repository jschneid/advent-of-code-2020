def highest_seat_id
  boarding_passes = File.readlines('input.txt')
  highest_seat_id = 0
  boarding_passes.each do |boarding_pass|
    row = boarding_pass_code_to_int(boarding_pass[0..6])
    column = boarding_pass_code_to_int(boarding_pass[7..9])
    seat_id = row * 8 + column
    highest_seat_id = seat_id if seat_id > highest_seat_id
  end
  highest_seat_id
end

def boarding_pass_code_to_int(code)
  code = code.gsub('F', '0')
  code = code.gsub('B', '1')
  code = code.gsub('L', '0')
  code = code.gsub('R', '1')
  code.to_i(2)
end

puts highest_seat_id
