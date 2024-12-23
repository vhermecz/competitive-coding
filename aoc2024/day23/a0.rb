require 'set'

# INPUT='test'
INPUT='input'  # 520 nodes, 13 connections each
data = File.read(INPUT).split("\n").map do |line|
  line.split("-").sort!
end

# part1
nodes = data.flatten.uniq
t_nodes = nodes.filter{|x|x[0]=='t'}
conns = data.to_set
combos = t_nodes.product(nodes, nodes).filter{|x|x.uniq.length==3}.map(&:sort)
p1 = combos.filter do |combo|
  combo.combination(2).all? do |a, b|
    conns.include?([a,b].sort)
  end
end.uniq.length
p p1

# part2
conns = (data + data.map(&:reverse)).group_by(&:first).to_a.map do |k, v|
  [k, v.map(&:last).sort]
end.to_h

$best = []

def grow(curr, conns)
  next_nodes = if curr.empty?
                 conns.keys.sort
               else
                 conns[curr.last].filter{|v|v>curr.last}
               end
  found = false
  next_nodes.each do |next_node|
    if curr.to_set.subset?(conns[next_node].to_set)
      found = true
      grow(curr + [next_node], conns)
    end
  end
  if not found
    local_best = curr.to_a.sort
    if local_best.length > $best.length
      $best = local_best
    end
  end
end

grow([], conns)
p $best.join(",")

# 1378
# bs,ey,fq,fy,he,ii,lh,ol,tc,uu,wl,xq,xv
