require 'set'

INPUT='test'
#INPUT='input'

data = File.open( INPUT ).map(&:strip)

def split num
	num = num[0..]
	find_num_pos(num).each do |pos|
		if num[*pos].to_i >= 10
			v = num[*pos].to_i/2.0
			num[*pos] = "[#{v.floor},#{v.ceil}]"
			return num
		end
	end
	return num
end

def find_num_pos(num, offset=0)
	num.gsub(/\d+/).map{ Regexp.last_match.offset(0).then{|x,y|[offset+x,y-x]} }
end

def find_explode(tree, start, depth)
	#p [tree, depth]
	if tree.kind_of?(Array) && tree.length == 2 && tree[0].kind_of?(Integer) && tree[1].kind_of?(Integer) && depth == 4
		return [start, tree.to_s.gsub(" ", "").length]
	end
	start += 1
	tree.each do |item|
		if !item.kind_of?(Integer)
			subresult = find_explode(item, start, depth+1)
			return subresult if !subresult.nil?
		end
		start += item.to_s.gsub(" ", "").length + 1
	end
	return nil
end


def explode(num)
	num = num[0..]
	target_pos, target_length = find_explode(eval(num), 0, 0)
	if !target_pos.nil?
		target = num[target_pos, target_length]
#		p target
		lnum, rnum = eval(target)
		# find pos
		lposes = find_num_pos(num[0..(target_pos-1)])
		if !lposes.empty?
			nlnum = (num[*lposes.last].to_i + lnum).to_s
			num[*lposes.last] = nlnum
			target_pos += nlnum.length - num[*lposes.last].length
		end
		rposes = find_num_pos(num[(target_pos+target.length)..], offset=target_pos+target.length)
		if !rposes.empty?
#			p num
#			p rposes
			nrnum = (num[*rposes.first].to_i + rnum).to_s
			num[*rposes.first] = nrnum
		end
		num[target_pos,target.length] = "0"
	end
	num
end

def reduce(num)
	#p [" reducing", num]
	while true
		res = explode(num)
		if res != num
			num = res
			#p [" exploded", num]
			next
		end
		res = split(num)
		if res != num
			num = res
			#p [" split", num]
			next
		end
		return num
	end
end


def add(num1, num2)
	reduce("[#{num1},#{num2}]")
end

def magnitude(num)
	if num.kind_of? Integer
		return num
	else
		return magnitude(num[0])*3+magnitude(num[1])*2
	end
end

num = data[0]
data[1..].each do |nnum|
	#p ["adding1", num]
	#p ["adding2", nnum]
	num = add(num, nnum)
	#p ["got", num]
end
p num
p magnitude(eval(num))

max_mag = -1
data.permutation(2).each do |a,b|
	max_mag = [max_mag, magnitude(eval(add(a,b)))].max
end
p max_mag

# solve

# 01:49:34   1377 - 4008
# 01:55:11   1306 - 4667
