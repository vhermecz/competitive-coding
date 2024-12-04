require 'set'

# INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map do |line|
  line.split("")
end

class MyKernel
  attr_accessor :points, :pattern

  def initialize(points, value)
    @points = points
    @pattern = value
  end
end

KERNELS_XMAS = [
  MyKernel.new(
    [
      [0, 0],
      [0, 1],
      [0, 2],
      [0, 3],
    ],
    "XMAS",
    ),
  MyKernel.new(
    [
      [0, 0],
      [1, 1],
      [2, 2],
      [3, 3],
    ],
    "XMAS",
    ),
]

KERNELS_MAS_CROSS = [
  MyKernel.new(
    [
      [0, 0],
      [0, 2],
      [1, 1],
      [2, 0],
      [2, 2],
    ],
    "MSAMS",
    ),
]

# solve
def search_kernel(data, kernel)
  h = kernel.points.last.first
  w = kernel.points.last.last
  (0...data.length-h).map do |y|
    (0...data[y].length-w).map do |x|
      word = kernel.points.map{|dy,dx|data[y+dy][x+dx]}.join("")
      word == kernel.pattern ? 1 : 0
    end.sum
  end.sum
end

def rot90(data)
  data.transpose.map(&:reverse)
end

def solve(data, kernels)
  kernels.map do |kernel|
    3.times.reduce([data]) do |acc, _|
      acc << rot90(acc.last)
    end.map do |data_rot|
      search_kernel(data_rot, kernel)
    end.sum
  end.sum
end

p1 = solve(data, KERNELS_XMAS)
p2 = solve(data, KERNELS_MAS_CROSS)

p p1
p p2

# 2532
# 1941
