def shiny_gold_bag_containers_count
  records = File.readlines('input.txt', chomp: true)

  rules = {}
  records.each do |record|
    rules = add_rule(record, rules)
  end

  can_contain_shiny_gold = 0
  rules.keys.each do |color|
    can_contain_shiny_gold += 1 if traverse(rules, color)
  end

  can_contain_shiny_gold
end

def add_rule(record, rules)
  split_rule = record.split(' bags contain ')
  container_color = split_rule[0]

  return rules if container_color == 'shiny gold'

  if split_rule[1] == 'no other bags.'
    rules[container_color] = nil
  else
    rules[container_color] = []
    contained_color_substrings = split_rule[1].split(', ')
    contained_color_substrings.each do |contained_color_substring|
      bag_word_index = contained_color_substring.index(' bag')
      rules[container_color] << contained_color_substring[2..bag_word_index - 1]
    end
  end
  rules
end

def traverse(rules, color)
  return true if color == 'shiny gold'
  return false if rules[color].nil?

  rules[color].each do |contained_color|
    return true if traverse(rules, contained_color)
  end

  false
end

puts shiny_gold_bag_containers_count
