require 'set'
require 'io/console'

#INPUT='test'
INPUT='input'

# read_input
JETS = File.read(INPUT).strip

WIDTH = 7
# parts
SHAPES = [
	[[4, 1], [[0, 0], [1, 0], [2, 0], [3, 0]]],
	[[3, 3], [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]]],
	[[3, 3], [[2, 0], [2, 1], [0, 2], [1, 2], [2, 2]]],
	[[1, 4], [[0, 0], [0, 1], [0, 2], [0, 3]]],
	[[2, 2], [[0, 0], [1, 0], [0, 1], [1, 1]]],
]

def headspace(pit)
	WIDTH.times.map do |idx|
		cnt = 0
		while pit[pit.length-1-cnt][idx+1] == 0
			cnt += 1
		end
		cnt
	end.min
end

def blit(pit, pos, shape, color:0)
	shape[1].map do |shixel|
		x, y = pos.zip(shixel).map(&:sum)
		pit[pit.length-1-y][x] = color if color > 0
		pit[pit.length-1-y][x]
	end.sum
end

def pittop(pit, rowcnt)
	[rowcnt, pit.length].min.times do |i|
		p pit[pit.length-1-i].join
	end
	STDIN.getch		
end

def pittopmoving(pit, pos, shape, rowcnt)
	pit = pit.map{|r|r[0..]}
	blit(pit, pos, shape, color:2)
	pittop(pit, rowcnt)
end

def extend(pit, rows)
	rows.times do
		pit << [1] + [0]*WIDTH + [1]
	end
	pit
end

def fingerprint(pit)
	row = -1
	while pit[row].sum == 2
		row -=1
	end
	res = []
	while pit[row].sum < 9
		res << pit[row][1...-1]
		row -= 1
	end
	res.flatten.each_with_index.map{|v,i|v*2**i}.sum
end

def inject(pit, shape, jet_idx)
	rows_needed = 3 - headspace(pit) + shape[0][1]
	pit = extend(pit, rows_needed)
	pos = [3, [rows_needed, 0].min * -1]
	#p ["START"]
	#pittopmoving(pit, pos, shape, 10)
	while true
		dpush = JETS[jet_idx % JETS.length].ord - 61
		jet_idx += 1
		if blit(pit, [pos[0]+dpush, pos[1]], shape, color:0) == 0
			pos[0] += dpush
			#p [dpush, "MOVE"]
		else
			#p [dpush, "STAY"]
		end
		#pittopmoving(pit, pos, shape, 10)
		if blit(pit, [pos[0], pos[1]+1], shape, color:0) == 0
			pos[1] += 1
			#p ["DROP"]
			#pittopmoving(pit, pos, shape, 10)
			next
		end
		blit(pit, pos, shape, color:1)
		#p ["LAND"]
		#pittop(pit, 10)
		break
	end
	jet_idx
end

# solve
def solve1()
	pit = [[1] * (WIDTH+2)]
	shape_idx = 0
	jet_idx = 0
	2022.times do |shape_idx|
		shape = SHAPES[shape_idx % SHAPES.length]
		jet_idx = inject(pit, shape, jet_idx)
	end
	pit.length - headspace(pit) -1	
end

def solve(total_step)
	pit = [[1] * (WIDTH+2)]
	shape_idx = 0
	jet_idx = 0
	seen = {}
	hist = []
	while true do
		shape = SHAPES[shape_idx % SHAPES.length]
		shape_idx += 1
		jet_idx = inject(pit, shape, jet_idx)
		fp = [shape_idx % SHAPES.length, jet_idx % JETS.length, fingerprint(pit)]
		hist << pit.length - headspace(pit) - 1
		if seen.include? fp
			l_loop = shape_idx - seen[fp][1]
			res = pit.length - headspace(pit) - 1
			h_loop = res - seen[fp][0]
			res += (total_step - shape_idx) / l_loop * h_loop
			tail_step_cnt = (total_step - shape_idx) % l_loop
			res += hist[seen[fp][1]+tail_step_cnt-1] - hist[seen[fp][1]-1]
			return res
		else
			seen[fp] = [pit.length - headspace(pit) - 1, shape_idx]
		end
	end
end

p solve(2022)
p solve(1000000000000)

# 04:00:00 start
# 05:15:24 3133 5598
# ..:..:.. 1580701754313 too high (few errawrs)
# 05:56:28 1547953216393 3225
