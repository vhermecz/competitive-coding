require 'set'

# INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").map do |frame|
  frame.split("\n").map do |line|
    line.split("")
  end
end

locks = []
keys = []

data.each do |frame|
  is_lock = frame.first.uniq == ["#"]
  hs = 5.times.map do |c|
    7.times.map do |r|
      frame[r][c] == "#" ? 1: 0
    end.sum - 1
  end
  if is_lock
    locks << hs
  else
    keys << hs
  end
end

p1 = keys.product(locks).filter do |key, lock|
  key.zip(lock).map do |a, b|
    a+b < 6
  end.all?
end.length

# solve
p p1
