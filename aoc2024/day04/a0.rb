require 'set'

# INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map do |line|
  line.split("")
end

DIR = [-1, 0, 1]
DIRS = DIR.product(DIR).filter{|a,b|!(a==0 and b==0)}

# solve
def get_at(data, y, x)
  h = data.length
  w = data.first.length
  return "" unless (0...h).include?(y)
  return "" unless (0...w).include?(x)
  data[y][x]
end

def count_dir_xmas(data, dir)
  (0...data.length).map do |y|
    (0...(data[y].length)).map do |x|
      word = (0..3).map{|i|get_at(data, y+dir[0]*i, x+dir[1]*i)}.join("")
      word == "XMAS" ? 1 : 0
    end.sum
  end.sum
end

def solve_pt1(data)
  DIRS.map do |dir|
    count_dir_xmas(data, dir)
  end.sum
end

def search_x_shape(data)
  (0...data.length-2).map do |y|
    (0...(data[y].length-2)).map do |x|
      [
        data[y+2][x],
        data[y][x],
        data[y+1][x+1],
        data[y+2][x+2],
        data[y][x+2]
      ].join("") == "MMASS" ? 1 : 0
    end.sum
  end.sum
end

def solve_pt2(data)
  search_x_shape(data) +
    search_x_shape(data.transpose) +
    search_x_shape(data.transpose.map(&:reverse)) +
    search_x_shape(data.map(&:reverse))
end

p1 = solve_pt1(data)
p2 = solve_pt2(data)

p p1
p p2

# 2532
# 1941
