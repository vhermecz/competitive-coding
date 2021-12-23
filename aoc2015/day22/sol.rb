
Hit Points: 58
Damage: 9

BOSS_HP = 58
BOSS_DAMANGE = 9

STATE_BOSSHP = 0
STATE_HP = 1
STATE_MANA = 2
STATE_TOTAL_MANA = 3
STATE_COOLDOWN = 4

SPELL_COST=0
SPELL_TURNS=1
SPELL_DAMAGE=2
SPELL_HEAL=3
SPELL_ARMOR=4
SPELL_MANA=5
#     cost,turns,damage,heal,armor,mana
SPELLS = [
	[53,   0,    4,    0,    0,   0 ],
	[73,   0,    2,    2,    0,   0 ],
	[113,  6,    0,    0,    7,   0 ],
	[173,  6,    3,    0,    0,   0 ],
	[229,  5,    0,    0,    0,  101],
	[0,    0,    0,    0,    0,   0 ],
]

def vadd(a,b)
	a.zip(b).map(&:sum)
end

initstate = [BOSS_HP, 50, 500, 0, [0]*SPELLS.length]

states = [initstate]
res = []
while true
	states.each do |state|
		SPELLS.each_with_index do |spell, spell_id|
			next if state[STATE_COOLDOWN][spell_id] > 1
			next if state[STATE_MANA] < spell[SPELL_COST]
			state = state.dup
			state[STATE_COOLDOWN] = state[STATE_COOLDOWN].dup
			state[STATE_MANA] -= spell[SPELL_COST]
			state[STATE_TOTAL_MANA] += spell[SPELL_COST]
			active_spells = state[STATE_COOLDOWN].each_with_index.filter{|v,i|v>0}.map{|_,i|SPELLS[i]}
			active_spells += [spell] if spell[SPELL_TURNS]==0
			effect = active_spells.reduce{|a,b|vadd(a,b)}
			state[STATE_BOSSHP] -= effect[SPELL_DAMAGE]
			state[STATE_HP] += effect[SPELL_HEAL]
			state[STATE_MANA] += effect[SPELL_MANA]
			armor = state[SPELL_ARMOR]
			if state[STATE_BOSSHP] < 0
				res << state
				next
			end
			

		end
	end
end