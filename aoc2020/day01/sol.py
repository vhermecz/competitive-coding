nums = [int(line.strip()) for line in open("input")]
for x in nums:
	for y in nums:
		if x+y==2020:
			print([x,y, x*y])

for x in nums:
    for y in nums:
        for z in nums:
            if x+y+z==2020:
                print([x,y,z,x*y*z])
