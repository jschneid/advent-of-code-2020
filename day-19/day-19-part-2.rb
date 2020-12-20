def count_messages_matching_rule_0
  input_lines = File.readlines('input.txt', chomp: true)
  divider_index = input_lines.index('')

  rules = build_rules(input_lines[0...divider_index])

  rules['8'][:next_rules_1] = ['42']
  rules['8'][:next_rules_2] = ['42', '8']
  rules['11'][:next_rules_1] = ['42', '31']
  rules['11'][:next_rules_2] = ['42', '11', '31']

  messages_lines = input_lines[(divider_index+1)..]
  matches = 0
  messages_lines.each do |message_line|
    matches += 1 if leading_characters_matching_rule(message_line, rules, '0').max == message_line.length
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
    next_rules_2 = []
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
    return [1] if rule == input[0]
    return []
  end

  trimmed_inputs_1 = trim_leading_matches(rule[:next_rules_1], input, rules)
  trimmed_inputs_2 = trim_leading_matches(rule[:next_rules_2], input, rules)

  (trimmed_inputs_1 + trimmed_inputs_2).compact.uniq.map { |trimmed_input| input.length - trimmed_input.length }
end

def trim_leading_matches(rules_list, input, rules)
  trimmed_inputs = [input]

  rules_list.each do |next_rule_id|
    new_trimmed_inputs = []
    trimmed_inputs.each do |trimmed_input|
      # next if trimmed_input == input

      characters_matched_counts = leading_characters_matching_rule(trimmed_input, rules, next_rule_id)

      characters_matched_counts.uniq.each do |characters_matched_count|
        new_trimmed_inputs = new_trimmed_inputs + trimmed_inputs.map { |trimmed_input_0 | trimmed_input_0[characters_matched_count..] } if characters_matched_count > 0
      end
    end

    trimmed_inputs = new_trimmed_inputs
  end

  trimmed_inputs
end

pp count_messages_matching_rule_0
