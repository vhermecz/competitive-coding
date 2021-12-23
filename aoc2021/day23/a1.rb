require 'set'
require 'fibonacci_heap'  # https://github.com/mudge/fibonacci_heap
ST_SCORE = 0
ST_CORR = 1
ST_ROOMS = 2

INPUT = [
	0,
	[nil]*11,
	[
		[1,2],
		[3,1],
		[0,3],
		[2,0]
	]
]
TEST = [
	0,
	[nil]*11,
	[
		[0,1],
		[3,2],
		[2,1],
		[0,3]
	]
]
PATCH = [
	[3, 3],
	[1, 2],
	[0, 1],
	[2, 0]
]

def patch(state)
	state = deepcopy(state)
	4.times.each{|i|state[ST_ROOMS][i].insert(1, *PATCH[i])}
	state
end

def deepcopy(a)
	[a[0], a[1].dup, [a[2][0].dup,a[2][1].dup,a[2][2].dup,a[2][3].dup]] #8.5s/100k
end

def deepcopy2(a)
	return a unless a.kind_of? Array
	a.map{|v|deepcopy2(v)}
end

def is_goal state
	state[ST_CORR].all?{|v|v.nil?} && state[ST_ROOMS].each_with_index.all?{|r,idx|r.all?{|v|v==idx}}
end

def get_steps(state, room_depth)
	res = []
	# from the corridor
	state[ST_CORR].each_with_index do |val, index|
		next if val.nil? # nobody there
		next if state[ST_ROOMS][val].length == room_depth # room is full
		next if !state[ST_ROOMS][val].empty? && state[ST_ROOMS][val].uniq != [val] # sy else in room
		target_index = (val+1)*2  # room pos
		steps = Range.new *[index,target_index].sort
		next unless state[ST_CORR][steps].compact==[val] # sy in the way
		nstate = deepcopy(state)
		nstate[ST_SCORE] += ((steps.size-1)+(room_depth-nstate[ST_ROOMS][val].length)) * (10**val)
		nstate[ST_ROOMS][val] << val
		nstate[ST_CORR][index] = nil
		res << nstate
	end
	# to corridor
	4.times do |val|
		next if state[ST_ROOMS][val].empty? # nobody
		next if state[ST_ROOMS][val].uniq == [val] # at home
		rval = state[ST_ROOMS][val][-1]
		# opt1 - go home if you can
		if val != rval && (state[ST_ROOMS][rval].empty? || state[ST_ROOMS][rval].uniq == [rval])
			source_index = (val+1)*2  # room pos
			target_index = (rval+1)*2  # target room pos
			steps = Range.new *[target_index,source_index].sort
			if state[ST_CORR][steps].compact.empty? # can move it home
				nstate = deepcopy(state)	
				nstate[ST_ROOMS][val].pop
				nstate[ST_SCORE] += ((steps.size-1)+(room_depth-nstate[ST_ROOMS][val].length)+(room_depth-nstate[ST_ROOMS][rval].length)) * (10**rval)
				nstate[ST_ROOMS][rval] << rval
				return [nstate]
			end
		end

		11.times do |index|
			next if index == 2 || index == 4 || index == 6 || index == 8
			source_index = (val+1)*2  # room pos
			steps = Range.new *[index,source_index].sort
			next unless state[ST_CORR][steps].compact.empty? # sy in the way
			nstate = deepcopy(state)
			rval = nstate[ST_ROOMS][val].pop
			nstate[ST_SCORE] += ((steps.size-1)+(room_depth-nstate[ST_ROOMS][val].length)) * (10**rval)
			nstate[ST_CORR][index] = rval
			res << nstate
		end
	end
	res
end

def solve(state)
	room_depth = state[ST_ROOMS][0].length
	stack = FibonacciHeap::Heap.new
	stack.insert FibonacciHeap::Node.new(0, state)
	cnt = 0
	while !stack.empty?
		cnt+=1
		state = stack.pop.value
		p [cnt,state[ST_SCORE],stack.length] if cnt % 100000 == 0
		return state[ST_SCORE] if is_goal(state)
		get_steps(state, room_depth).each do |nstate|
			stack.insert FibonacciHeap::Node.new(nstate[ST_SCORE], nstate)
		end
	end
	return nil
end

p solve(INPUT)
p solve(patch(INPUT))

#st1 - 13520
#st2 - 48708

__END__
   . . . .
#0123456789A#
#...........#
###C#B#D#A###
  #B#D#A#C#
  #########
