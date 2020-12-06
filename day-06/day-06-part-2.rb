def count_unanimous_yes_answers
  answers = File.readlines('input.txt', chomp: true)
  total_unanimous_yes_answers = 0
  current_unanimous_group_answers = nil
  answers.each do |person_answers|
    if person_answers == ''
      total_unanimous_yes_answers += current_unanimous_group_answers.values.count(true)
      current_unanimous_group_answers = nil
    else
      current_unanimous_group_answers = update_unanimous_group_answers(person_answers, current_unanimous_group_answers)
    end
  end
  total_unanimous_yes_answers += current_unanimous_group_answers.values.count(true)
  total_unanimous_yes_answers
end

def update_unanimous_group_answers(person_answers, group_answers)
  return initialize_group_answers(person_answers) if group_answers.nil?

  ('a'..'z').each do |letter|
    group_answers[letter] = group_answers[letter] && person_answers.include?(letter)
  end
  group_answers
end

def initialize_group_answers(person_answers)
  group_answers = {}
  ('a'..'z').each do |letter|
    group_answers[letter] = person_answers.include?(letter)
  end
  group_answers
end

puts count_unanimous_yes_answers
