require 'set'

#INPUT='test'
INPUT='input'

# read_input
graph = {}
data = File.read(INPUT).split("\n").map do |row|
	from, to = row.split(": ")
	to = to.split(" ")
	to.each do |t|
		graph[from] ||= Set.new
		graph[from] << t
		graph[t] ||= Set.new
		graph[t] << from
	end
end

def components graph, skipedge
	seen = Set.new
	expand = []
	sizes = []
	cnt = 0
	while seen.length < graph.keys.length
		if expand.length == 0
			sizes << cnt if cnt > 0
			cnt = 0
			expand << (graph.keys.to_set - seen).first
		end
		item = expand.pop
		next if seen.include? item
		next if item.nil?
		cnt += 1
		seen << item
		graph[item].each do |x|
			expand << x if !skipedge.include?([item, x].sort)
		end
	end
	sizes << cnt
	return sizes
end

def findway graph, a, b
	seen = {}
	expand = []
	expand << a
	while true
		item = expand.pop
		break if item == b
		graph[item].to_a.shuffle.each do |x|
			next if !seen[x].nil? 
			seen[x] = item
			expand << x
		end
	end
	edges = []
	current = b
	while current != a
		edges << [current, seen[current]].sort
		current = seen[current]
	end
	edges
end

def part1 graph
	edge_visit_cnt = {}
	graph.keys.length.times do
		x = graph.keys.shuffle
		findway(graph, x[0], x[1]).each do |edge|
			edge_visit_cnt[edge] ||= 0 
			edge_visit_cnt[edge] += 1
		end
	end
	candidates = edge_visit_cnt.to_a.sort{|a,b|b.last-a.last}.map(&:first)[0..10]
	candidates.combination(3).each do |black|
		comps = components(graph, black)
		if comps.length == 2
			return comps.first * comps.last
		end
	end
	return nil
end

# solve
p part1(graph)  # probabilistic

#  25   00:56:45   1362      0          -      -      -
# 602151
