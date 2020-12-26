def find_encryption_key
  public_keys = File.readlines('input.txt').map(&:to_i)
  card_loop_size = find_card_loop_size(public_keys[0])
  calculate_encryption_key(public_keys[1], card_loop_size)
end

def find_card_loop_size(card_public_key)
  initial_subject_number = 7
  value = 1
  loop_size = 0

  while value != card_public_key
    value = perform_step(value, initial_subject_number)
    loop_size += 1
  end

  loop_size
end

def calculate_encryption_key(public_key, loop_size)
  value = 1
  loop_size.times do
    value = perform_step(value, public_key)
  end
  value
end

def perform_step(value, subject_number)
  value = value * subject_number
  value % 20201227
end

pp find_encryption_key
