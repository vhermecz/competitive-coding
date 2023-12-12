require 'set'

INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|row
	cond_bitmap, cond_nums = row.split(" ")
	[cond_bitmap, cond_nums.split(",").map(&:to_i)]
end

# state
#  remaining list
#  bitmap position
#  active opengroup

ST_EMPTY = '.'
ST_DAMAGED = '#'
ST_UNKNOWN = '?'

$cache = Hash.new
def calcgroup(bitmap, i_bitmap, is_open, rem_list)
	cached = $cache[[i_bitmap, is_open, rem_list]]
	if cached.nil?
		cached = calcgroup_raw(bitmap, i_bitmap, is_open, rem_list)
		$cache[[i_bitmap, is_open, rem_list]] = cached
	end
	cached
end

def eval_position(current, bitmap, i_bitmap, is_open, rem_list)
	if current == ST_EMPTY
		if is_open
			if rem_list[0] == 0
				return calcgroup(bitmap, i_bitmap+1, false, rem_list[1..])
			else
				return 0
			end
		else
			return calcgroup(bitmap, i_bitmap + 1, false, rem_list)
		end
	elsif current == ST_DAMAGED
		if rem_list.empty?
			return 0
		end
		if is_open
			if rem_list[0] == 0
				return 0
			else
				rem_list_rest = rem_list.dup
				rem_list_rest[0] -= 1
				return calcgroup(bitmap, i_bitmap + 1, true, rem_list_rest)
			end
		else
			rem_list_rest = rem_list.dup
			rem_list_rest[0] -= 1
			return calcgroup(bitmap, i_bitmap + 1, true, rem_list_rest)
		end
	end
end

def calcgroup_raw(bitmap, i_bitmap, is_open, rem_list)
	if i_bitmap == bitmap.length
		if rem_list.empty? || rem_list == [0]
			return 1
		else
			return 0
		end
	elsif bitmap[i_bitmap] == ST_UNKNOWN
		return eval_position(ST_EMPTY, bitmap, i_bitmap, is_open, rem_list) + eval_position(ST_DAMAGED, bitmap, i_bitmap, is_open, rem_list)
	else
		return eval_position(bitmap[i_bitmap], bitmap, i_bitmap, is_open, rem_list)
	end
end

part1 = data.map do |conf|
	$cache = Hash.new
	calcgroup(conf[0], 0, false, conf[1])
end.sum

#solve
p part1

data = data.map do |a, b|
	[([a]*5).join("?"), b*5]
end

part2 = data.map do |conf|
	$cache = Hash.new
	calcgroup(conf[0], 0, false, conf[1])
end.sum

# solve
p part2

# 12   00:33:22   2183      0   00:51:51    895      0
# 7344
# 35467034624 @38:10 wrong
# 1088006519007
