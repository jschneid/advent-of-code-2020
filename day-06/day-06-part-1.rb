def count_total_yes_answers
  answers = File.readlines('input.txt', chomp: true)
  total_yes_answers = 0
  current_group_answers = ''
  answers.each do |person_answers|
    if person_answers == ''
      total_yes_answers += group_yes_answers_count(current_group_answers)
      current_group_answers = ''
    else
      current_group_answers += person_answers
    end
  end
  total_yes_answers += group_yes_answers_count(current_group_answers)
  total_yes_answers
end

def group_yes_answers_count(group_answers)
  count = 0
  ('a'..'z').each do |letter|
    count += 1 if group_answers.include?(letter)
  end
  count
end

puts count_total_yes_answers
