# INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map do |row|
  row.split(" ").map(&:to_i)
end

def is_safe(list)
  deltas = list.each_cons(2).map{|a, b|a-b}
  is_unidir = deltas.map{|v| v <=> 0}.uniq.count == 1
  min = deltas.map(&:abs).min
  max = deltas.map(&:abs).max
  min >= 1 && max <= 3 && is_unidir
end

def is_safe_damp(list)
  return true if is_safe(list)
  (0...list.count).each do |i|
    test = list.dup
    test.delete_at(i)
    return true if is_safe(test)
  end
  false
end

# solve
pt1 = data.filter{|l| is_safe(l)}.count
p(pt1)
pt2 = data.filter{|l| is_safe_damp(l)}.count
p(pt2)

# 218
# 290
