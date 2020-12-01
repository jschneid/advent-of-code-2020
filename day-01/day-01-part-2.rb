def product_of_problematic_expense_report_entries
  entries = File.readlines('input.txt').map(&:to_i)
  entries.each_with_index do |entry1, i|
    entries.each_with_index do |entry2, j|
      entries.each_with_index do |entry3, k|
        next if i == j || i == k || j == k
        return entry1 * entry2 * entry3 if entry1 + entry2 + entry3 == 2020
      end
    end
  end
end

puts product_of_problematic_expense_report_entries
