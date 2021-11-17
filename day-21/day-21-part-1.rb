def load_foods
  input_lines = File.readlines('input.txt', chomp: true)

  foods = []
  input_lines.each do |input_line|
    separated_input_line = input_line.split('(contains ')
    ingredients = separated_input_line[0].split(' ')
    if (separated_input_line.length > 1)
      allergens = separated_input_line[1][..-2].split(', ')
    end

    foods << { ingredients: ingredients, allergens: allergens }
  end
  foods
end

def initialize_allergens_to_ingredients_map(foods)
  allergens_to_ingredients_map = {}
  foods.each do |food|
    food[:allergens].each do |allergen|
      if allergens_to_ingredients_map.key?(allergen)
        allergens_to_ingredients_map[allergen] &= food[:ingredients]
      else
        allergens_to_ingredients_map[allergen] = food[:ingredients]
      end
    end
  end
  allergens_to_ingredients_map
end

def safe_foods(allergens_to_ingredients_map, foods)
  allergen_foods = allergens_to_ingredients_map.values.flatten
  all_ingredients = foods.map { |food| food[:ingredients] }.flatten
  all_ingredients - allergen_foods
end

foods = load_foods
allergens_to_ingredients_map = initialize_allergens_to_ingredients_map(foods)
safe_foods = safe_foods(allergens_to_ingredients_map, foods)
pp safe_foods.length
