def count_messages_matching_rule_0
  input_lines = File.readlines('input.txt', chomp: true)
  divider_index = input_lines.index('')

  rules = build_rules(input_lines[0...divider_index])

  messages_lines = input_lines[(divider_index+1)..]
  matches = 0
  messages_lines.each do |message_line|
    matches += 1 if leading_characters_matching_rule(message_line, rules, '0') == message_line.length
  end
  matches
end

def build_rules(rule_lines)
  rules = {}
  rule_lines.each do |rule_line|
    rule_id_and_body = rule_line.split(':')
    rule_id = rule_id_and_body[0]
    rule_body = rule_id_and_body[1]
    if rule_body[1] == '"'
      rules[rule_id] = rule_body[2]
      next
    end
    next_rules = rule_body.split('|')
    next_rules_1 = next_rules[0].split(' ')
    next_rules_2 = next_rules[1].split(' ') unless next_rules[1].nil?
    rules[rule_id] = {
      next_rules_1: next_rules_1,
      next_rules_2: next_rules_2
    }
  end
  rules
end

def leading_characters_matching_rule(input, rules, rule_id)
  rule = rules[rule_id]

  if (rule == 'a' || rule == 'b')
    return 1 if rule == input[0]
    return nil
  end

  trimmed_input = trim_leading_matches(rule[:next_rules_1], input, rules)
  return input.length - trimmed_input.length unless trimmed_input.nil?

  return nil if rule[:next_rules_2].nil?
  trimmed_input = trim_leading_matches(rule[:next_rules_2], input, rules)
  return nil if trimmed_input.nil?
  input.length - trimmed_input.length
end

def trim_leading_matches(rules_list, input, rules)
  trimmed_input = input
  rules_list.each do |next_rule_id|
    characters_matched = leading_characters_matching_rule(trimmed_input, rules, next_rule_id)
    return nil if characters_matched.nil?
    trimmed_input = trimmed_input[characters_matched..]
  end
  trimmed_input
end

pp count_messages_matching_rule_0
