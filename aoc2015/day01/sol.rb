data = File.read('input')
data.split("").tally.then do |stat|
	p stat['(']-stat[')']
end
p data.split("").inject([0]){|acc,v|acc << (acc.last + (v=='('?1:-1))}[1..].find_index{|v|v==-1}+1