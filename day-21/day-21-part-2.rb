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

def remove_safe_foods_from_map(allergens_to_ingredients_map, foods)
  safe_foods = safe_foods(allergens_to_ingredients_map, foods)
  allergens_to_ingredients_map.each_key do |allergen|
    allergens_to_ingredients_map[allergen] -= safe_foods
  end
end

def reduce_map_to_unique_mappings(allergens_to_ingredients_map)
  identified_allergens = []
  while identified_allergens.length < allergens_to_ingredients_map.length
    identified_allergen = allergens_to_ingredients_map.find { |allergen, ingredients| ingredients.length == 1 && !identified_allergens.include?(allergen) }[0]
    identified_allergens << identified_allergen
    identified_ingredient = allergens_to_ingredients_map[identified_allergen][0]
    allergens_to_ingredients_map.each_key do |allergen|
      next if allergen == identified_allergen
      allergens_to_ingredients_map[allergen].delete(identified_ingredient)
    end
  end
end

def ingredients_csv_sorted_alphabetically_by_allergen(allergens_to_ingredients_map)
  allergens_to_ingredients_map.sort.to_h.values.join(',')
end

foods = load_foods
allergens_to_ingredients_map = initialize_allergens_to_ingredients_map(foods)
remove_safe_foods_from_map(allergens_to_ingredients_map, foods)
reduce_map_to_unique_mappings(allergens_to_ingredients_map)
pp ingredients_csv_sorted_alphabetically_by_allergen(allergens_to_ingredients_map)
