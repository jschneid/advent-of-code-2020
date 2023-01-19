def count_messages_matching_rule_0
  input_lines = File.readlines('input.txt', chomp: true)
  divider_index = input_lines.index('')

  rules = build_rules(input_lines[0...divider_index])

  # The rule changes for Day 19 part 2 are:
  #   8: 42 | 42 8
  #   11: 42 31 | 42 11 31
  #
  # Conveniently, our root rule, rule 0, is:
  #   0: 8 11
  #
  # And rules 8 and 11 aren't referenced from anywhere else (other than rule 0).
  #
  # The recursiveness in rule 8 can be extrapolated out to the following pattern:
  #   8: 42 | 42 42 | 42 42 42 | 42 42 42 42 | ...
  #
  # Similarly, rule 11 can be extrapolated out to this pattern:
  #   11: 42 31 | 42 42 31 31 | 42 42 42 31 31 31 | ...
  #
  # So, what we can do is, pregenerate a bunch of variations of rule 0, each with
  # a distinct combination of the non-recursive possible values of rules 8 and 11
  # (as shown above). Then, just run our logic from Part 1 with each of those
  # pregenerated rule 0 variations.
  # .
  # (Up to 10 copies of each of rules 8 and 11 is more than enough to cover all of
  # the message strings that appear in the input.)
  rule_0_list = []
  (1..10).each do |i|
    (1..10).each do |j|
      new_rule_0_list_item = []
      i.times { new_rule_0_list_item << '42' }
      j.times { new_rule_0_list_item << '42' }
      j.times { new_rule_0_list_item << '31' }
      rule_0_list << new_rule_0_list_item
    end
  end

  messages_lines = input_lines[(divider_index+1)..]
  matches = 0
  messages_lines.each do |message_line|
    rule_0_list.each do |rule_0|
      rules['0'][:next_rules_1] = rule_0
      if leading_characters_matching_rule(message_line, rules, '0') == message_line.length
        matches += 1
        break
      end
    end
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

  next_rules_list = [rule[:next_rules_1]]
  next_rules_list << rule[:next_rules_2] unless rule[:next_rules_2].nil?

  next_rules_list.each do |next_rules|
    trimmed_input = trim_leading_matches(next_rules, input, rules)
    return input.length - trimmed_input.length unless trimmed_input.nil?
  end

  nil
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
