def count_active_cubes_after_6_cycles
  input_layout = File.readlines('input.txt', chomp: true)
  layout = initialize_layout(input_layout)

  6.times do
    layout = advance_state(layout)
  end

  get_total_active_count(layout)
end

def initialize_layout(input_layout)
  w_0_z_0_layout = {}
  input_layout.each_with_index do | row, y |
    w_0_z_0_layout[y] = {}
    row.each_char.with_index do | c, x |
      w_0_z_0_layout[y][x] = (c == '#')
    end
  end
  { 0 => { 0 => w_0_z_0_layout } }
end

def active?(w, z, y, x, layout)
  return false unless layout.key?(w)
  return false unless layout[w].key?(z)
  return false unless layout[w][z].key?(y)
  return false unless layout[w][z][y].key?(x)
  layout[w][z][y][x]
end

def advance_state(layout)
  new_layout = Marshal.load(Marshal.dump(layout))
  w_range = expand_range_by_1(get_w_range(layout))
  z_range = expand_range_by_1(get_z_range(layout))
  y_range = expand_range_by_1(get_y_range(layout))
  x_range = expand_range_by_1(get_x_range(layout))

  w_range.each do |w|
    z_range.each do |z|
      y_range.each do |y|
        x_range.each do |x|
          adjacent_active_count = get_adjacent_active_count(w, z, y, x, layout)
          if active?(w, z, y, x, layout)
            set_cell(w, z, y, x, new_layout, (adjacent_active_count == 2 || adjacent_active_count == 3))
          else
            set_cell(w, z, y, x, new_layout, (adjacent_active_count == 3))
          end
        end
      end
    end
  end
  new_layout
end

def set_cell(w, z, y, x, layout, new_state)
  layout[w] = {} if !layout.key?(w)
  layout[w][z] = {} if !layout[w].key?(z)
  layout[w][z][y] = {} if !layout[w][z].key?(y)
  layout[w][z][y][x] = new_state
end

def expand_range_by_1(range)
  (range.min-1..range.max+1)
end

def get_x_range(layout)
  min_x = 0
  max_x = 0
  layout.each_key do |w|
    layout[w].each_key do |z|
      layout[w][z].each_key do |y|
        x_values = layout[w][z][y].keys.sort
        min_x = x_values[0] if x_values[0] < min_x
        max_x = x_values[-1] if x_values[-1] > max_x
      end
    end
  end
  (min_x..max_x)
end

def get_y_range(layout)
  min_y = 0
  max_y = 0
  layout.each_key do |w|
    layout[w].each_key do |z|
      y_values = layout[w][z].keys.sort
      min_y = y_values[0] if y_values[0] < min_y
      max_y = y_values[-1] if y_values[-1] > max_y
    end
  end
  (min_y..max_y)
end

def get_z_range(layout)
  min_z = 0
  max_z = 0
  layout.each_key do |w|
    z_values = layout[w].keys.sort
    min_z = z_values[0] if z_values[0] < min_z
    max_z = z_values[-1] if z_values[-1] > max_z
  end
  (min_z..max_z)
end

def get_w_range(layout)
  w_values = layout.keys.sort
  (w_values[0]..w_values[-1])
end

def get_adjacent_active_count(wp,zp,yp,xp,layout)
  active_count = 0
  (wp-1..wp+1).each do |w|
    (zp-1..zp+1).each do |z|
      (yp-1..yp+1).each do |y|
        (xp-1..xp+1).each do |x|
          next if wp == w && zp == z && yp == y && xp == x
          active_count += 1 if active?(w, z, y, x, layout)
        end
      end
    end
  end
  active_count
end

def get_total_active_count(layout)
  active_count = 0
  layout.each_key do |w|
    layout[w].each_key do |z|
      layout[w][z].each_key do |y|
        layout[w][z][y].each_key do |x|
          active_count += 1 if active?(w, z, y, x, layout)
        end
      end
    end
  end
  active_count
end

puts count_active_cubes_after_6_cycles
