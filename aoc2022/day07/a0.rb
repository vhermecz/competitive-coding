require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("$").map{|a|a.strip.split("\n").map{|a|a.split(" ")}}

tree = {}
cwd = []

def getpath(tree, path)
	item = tree
	path.each do |level|
		item = item[level]
	end
	item
end

data.each do |item|
	next if item == []
	cmd = item[0]
	if cmd[0] == "cd"
		if cmd[1] == "/"
			cwd = []
		elsif cmd[1] == ".."
			cwd.pop
		else
			cwd << cmd[1]
		end
	else # ls
		item[1..].each do |entry|
			ccwd = getpath(tree, cwd)
			if entry[0]=="dir"
				ccwd[entry[1]] = {}
			else	
				ccwd[entry[1]] = entry[0].to_i
			end
		end
	end
end

def getsize(tree)
	tree.map do |k, v|
		if v.class==Hash
			getsize(v)
		else
			v
		end
	end.sum
end

def visit1(tree)
	selfsize = getsize(tree)
	if selfsize > 100000
		selfsize = 0
	end	
	tree.map do |k, v|
		if v.class==Hash
			visit1(v)
		else
			0
		end
	end.sum	+ selfsize
end

def visit2(tree)
	selfsize = getsize(tree)
	tree.map do |k, v|
		if v.class==Hash
			visit2(v)
		else
			nil
		end
	end.compact.flatten	+ [selfsize]
end


# solve
p visit1(tree)
tofree = 30000000 - (70000000 - getsize(tree))
p visit2(tree).filter{|x|x >= tofree}.sort.first

# 19:57 bad 48145603 (typo 1e6 instead of 1e5 limit)
# 21:00 1642503 869
# 28:11 bad 17187447, comma
# 29:11 bad 17187447 wrong required space calc
# 30:56 6999588 1300
