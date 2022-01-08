row=2947
column=3029

baserow = row+column-1
index = baserow*(baserow-1)/2+1 + column-1

i = 20151125
(index-1).times do
	i = (i * 252533) % 33554393
end
p i

# 7m07s