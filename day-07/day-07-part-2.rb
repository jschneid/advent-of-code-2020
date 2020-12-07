def shiny_gold_bag_contains_count
  records = File.readlines('input.txt', chomp: true)

  rules = {}
  records.each do |record|
    rules = add_rule(record, rules)
  end

  traverse(rules, 'shiny gold') - 1
end

def add_rule(record, rules)
  split_rule = record.split(' bags contain ')
  container_color = split_rule[0]

  if split_rule[1] == 'no other bags.'
    rules[container_color] = nil
  else
    rules[container_color] = []
    contained_color_substrings = split_rule[1].split(', ')
    contained_color_substrings.each do |contained_color_substring|
      bag_word_index = contained_color_substring.index(' bag')
      quantity = contained_color_substring[0].to_i
      contained_color = contained_color_substring[2..bag_word_index - 1]
      rules[container_color] << {quantity => contained_color}
    end
  end
  rules
end

def traverse(rules, color)
  return 1 if rules[color].nil?

  contained_bags_count = 1
  rules[color].each do |contained_quantity_and_color|
    contained_bags_count += contained_quantity_and_color.keys[0] * traverse(rules, contained_quantity_and_color.values[0])
  end

  contained_bags_count
end

puts shiny_gold_bag_contains_count
