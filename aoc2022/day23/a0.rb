require 'set'

DEBUG = false
#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").each_with_index.map do |r,y|
	r.split("").each_with_index.map do |c,x|
		[x, y] if c == "#"
	end
end.flatten(1).compact

LOOK_N = 0
LOOK_E = 2
LOOK_S = 4
LOOK_W = 6

LOOKSY = [LOOK_N, LOOK_S, LOOK_W, LOOK_E]
SCAN = [
	[0, -1],  # LOOK_N
	[1, -1],
	[1, 0],  # LOOK_E
	[1, 1],
	[0, 1],  # LOOK_S
	[-1, 1],
	[-1, 0],  # LOOK_W
	[-1, -1],
]

def v_add(v1, v2)
	v1.zip(v2).map(&:sum)
end

def scan(pos, elves)
	SCAN.map do |d|
		elves.include? v_add(pos, d)
	end
end

def consider(scan, looksy)
	return nil unless scan.any?
	looksy.each do |look_dir|
		return look_dir unless scan[look_dir] or scan[(look_dir-1)%8] or scan[(look_dir+1)%8]
	end
	nil
end

def bbox_size(elves)
	stat = elves[0].zip(*elves[1..])
	[
		stat.first.max - stat.first.min + 1,
		stat.last.max - stat.last.min + 1
	]
end

def debug(elves)
	elveset = Set.new elves
	elfmap = elves.each_with_index.to_h
	stat = elves[0].zip(*elves[1..])
	(stat.last.min..stat.last.max).to_a.each do |y|
		r = (stat.first.min..stat.first.max).to_a.map do |x|
			elfcode = (65 + (elfmap[[x,y]] || -19)).clamp(32,126).chr
		end.to_a.join
		p r
	end
end

DIRDEBUG = {
	nil => "-",
	0 => "N",
	4 => "S",
	6 => "W",
	2 => "E",
}

def stepper(elves, looksy)
	p looksy.map{|d|DIRDEBUG[d]}.join if DEBUG
	elveset = Set.new elves
	dirdbg = []
	nelves = elves.map do |elf|
		motion = consider(scan(elf, elveset), looksy)
		dirdbg << DIRDEBUG[motion]
		if motion.nil?
			elf
		else
			v_add(elf, SCAN[motion])
		end
	end
	p dirdbg.join  if DEBUG
	stat = nelves.tally
	colldbg = []
	nelves = elves.zip(nelves).map do |elf, nelf|
		if stat[nelf] == 1
			colldbg << "-"
			nelf
		else
			colldbg << "X"
			elf
		end
	end
	p colldbg.join if DEBUG
	debug(nelves) if DEBUG
	nelves
end

def solve1(data)
	looksy = LOOKSY
	elves = data
	10.times do |t|
		elves = stepper(elves, looksy)
		looksy = looksy[1..] + [looksy[0]]
	end
	bboxs = bbox_size(elves)
	size = bboxs.first * bboxs.last - elves.length
end

def solve2(data)
	looksy = LOOKSY
	elves = data
	t = 1
	while true
		nelves = stepper(elves, looksy)
		return t if nelves == elves
		elves = nelves
		looksy = looksy[1..] + [looksy[0]]
		t += 1
	end
end

debug(data) if DEBUG
# solve
p solve1(data)
p solve2(data)

# 53:10 3684 1299 (debug: missed that elves stop when no ones around)
# 55:29 862 1121