require 'set'

#INPUT='test'
INPUT='input'

# read_input
# data = []
# File.open( INPUT ) do |f|
# 	while true do
# 		row = f.gets.strip
# 		break if row.empty?
# 		data << row.split(",").map(&:to_i)
# 	end
# end
data = File.read(INPUT).split("\n").map do |line|
  line.split(" ").map do |value|
    value.split("=").last.split(",").map(&:to_i)
  end
end

if INPUT == 'test'
  w=11
  h=7
else
  w=101
  h=103
end

def debug(pos, w, h)
  h.times do |r|
    line = w.times.map do |c|
      cnt = pos.filter{|v|v==[c,r]}.count
      cnt>0 ? cnt.to_s : "."
    end
    p line.join("")
  end
end

def mul(values)
  mul.inject(1) { |product, number| product * number }
end

def symmetric(values)
  values[0..1] == values [2..3]
end

def symmetric2(pos,w,h)
  pos2 = pos.to_set
  pos.all? do |p|
    c,r = p
    pos2.include?([w-1-c, r])
  end
end

def quadrant_score(pos, w, h)
  s = pos.filter do |p|
    c,r = p
    c != w/2 && r != h/2
  end.group_by do |p|
    c,r = p
    v = (c < w/2 ? 0 : 2) + (r < h/2 ? 0 : 1)
    v
  end.values.map(&:length)
end

pos = data.map{|datum|datum.first.dup}

10000000.times do |i|
  pos = pos.each_with_index.map do |p, i|
    c = (p.first + data[i].last.first) % w
    r = (p.last + data[i].last.last) % h
    [c, r]
  end
  if symmetric2(pos, w, h)
    debug(pos, w, h)
    p i
  end
end


p quadrant_score(pos, w, h)

# solve
