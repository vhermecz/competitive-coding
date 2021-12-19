data = File.open("input").read.split("\n").map(&:strip)

puts data.map{|str|2+3*str.scan(/\\x[0-9a-f]{2}/).flatten.length+1*str.scan(/\\[\"\\]/).flatten.length}.sum

puts data.map{|str|str.split("").filter{|c|["\"", "\\"].include? c}.length+2}.sum
