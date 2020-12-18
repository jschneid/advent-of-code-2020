def sum_of_addition_precedence_expressions
  expressions = File.readlines('input.txt', chomp: true)
  sum = 0
  expressions.each do |expression|
    result = evaluate_expression(expression).to_i
    sum += result
  end
  sum
end

def evaluate_expression(expression)
  return evaluate_expression_without_parenthesis(expression) unless expression.include?('(')
  nest_level = 0
  deepest_nest_level = 0
  deepest_nest_start_index = 0
  deepest_nest_end_index = 0
  in_deepest_nest = false
  expression.each_char.with_index do |c, i|
    if c == '('
      nest_level += 1
      if nest_level > deepest_nest_level
        deepest_nest_start_index = i
        deepest_nest_level = nest_level
        in_deepest_nest = true
      end
    elsif c == ')'
      if in_deepest_nest
        deepest_nest_end_index = i
        in_deepest_nest = false
      end
      nest_level -= 1
    end
  end
  new_expression = ''
  new_expression += "#{expression[..(deepest_nest_start_index - 1)]} " if deepest_nest_start_index > 0
  new_expression += "#{evaluate_expression_without_parenthesis(expression[deepest_nest_start_index + 1..deepest_nest_end_index - 1])}"
  new_expression += " #{expression[(deepest_nest_end_index + 1)..]}" if deepest_nest_end_index < (expression.length - 1)
  new_expression.squeeze!(' ')
  new_expression.gsub!('( ', '(')
  new_expression.gsub!(' )', ')')
  evaluate_expression(new_expression)
end

def evaluate_expression_without_parenthesis(expression)
  words = expression.split(' ')

  if expression.include?('+') && expression.include?('*')
    plus_index = words.find_index('+')
    words[plus_index-1] = '(' + words[plus_index-1]
    words[plus_index+1] = words[plus_index+1] + ')'
    expression = words.join(' ')
    return evaluate_expression(expression)
  end

  last_result = words[0].to_i
  i = 1
  while i < words.length
    if words[i] == '+'
      last_result += words[i+1].to_i
    else
      last_result *= words[i+1].to_i
    end
    i += 2
  end
  last_result
end

puts sum_of_addition_precedence_expressions

