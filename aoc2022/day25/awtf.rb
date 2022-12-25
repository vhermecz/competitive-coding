VAL = "=-012".split("").each_with_index.map{|c,v|[c,v-2]}.to_h
num = File.read('input').split("\n").map{|v|v.split("").each_with_index.map{|d, i|5**(v.length-i-1)*VAL[d]}.sum}.sum
p Enumerator.produce(num){|v|(v+2)/5}.take_while{|v|v>0}.map{|v|VAL.invert[(v+2)%5-2]}.reverse.join
