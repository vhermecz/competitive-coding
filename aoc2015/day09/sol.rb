require 'set'
edges = File.open("input").read.split("\n").map{|row|row.gsub("=","to").split(" to ")}.map{|a,b,c|[[[a,b], c.to_i], [[b,a], c.to_i]]}.flatten(1).to_h
nodes = edges.keys.flatten.to_set.to_a
p nodes.permutation.map{|p|p.each_cons(2).map{|edge|edges[edge]}.sum}.minmax
