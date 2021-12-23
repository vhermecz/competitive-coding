# Hit Points: 109
# Damage: 8
# Armor: 2

HP = 0
DAMAGE = 1
ARMOR = 2
$boss = [109, 8, 2]
$ws = [[8,4,0],[10,5,0],[25,6,0],[40,7,0],[74,8,0]]
$as = [nil, [13,0,1],[31,0,2],[53,0,3],[75,0,4],[102,0,5]]
$rs = [nil, [25,1,0],[50,2,0],[100,3,0],[20,0,1],[40,0,2],[80,0,3]]

def match(boss, player)
	while true
		boss[HP] -= [1, player[DAMAGE]-boss[ARMOR]].max
		return true if boss[HP]<=0
		player[HP] -= [1, boss[DAMAGE]-player[ARMOR]].max
		return false if player[HP]<=0
	end
end

def solve(wins)
	$ws.map do |weapon|
		$as.map do |armor|
			$rs.map do |ring1|
				$rs.map do |ring2|
					next if !ring1.nil? && !ring2.nil? && ring1==ring2
					cost, val_damage, val_armor = [weapon, armor, ring1, ring2].compact.transpose.map(&:sum)
					cost if match($boss.dup, [100, val_damage, val_armor])==wins
				end
			end
		end
	end.flatten.compact.minmax
end

p solve(true).first
p solve(false).last
