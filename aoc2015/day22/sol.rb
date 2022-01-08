require 'fibonacci_heap'  # https://github.com/mudge/fibonacci_heap
require 'json'
require 'set'

BOSS_HP = 58
BOSS_DAMANGE = 9

Spell = Struct.new(:name, :mana_cost, :turns, :damage, :heal, :armor_boost, :mana_boost, :idx)
SPELLS = [
	Spell.new("Magic Missile", 53, 0, 4, 0, 0, 0),
	Spell.new("Drain", 73, 0, 2, 2, 0, 0),
	Spell.new("Shield", 113, 6, 0, 0, 7, 0),
	Spell.new("Poison", 173, 6, 3, 0, 0, 0),
	Spell.new("Recharge", 229, 5, 0, 0, 0, 101),
]
SPELLS.each_with_index{|s,idx|s.idx=idx}

def apply_spell(state, spell)
	state.boss_hp -= spell.damage
	state.hp += spell.heal
	state.mana += spell.mana_boost
	state.armor_boost += spell.armor_boost
	if !state.effects[spell.idx].nil?
		state.effects[spell.idx] -= 1
		state.effects.delete(spell.idx) if state.effects[spell.idx] == 0
	end
end

def cast_spell(state, spell)
	state.total_mana += spell.mana_cost
	state.mana -= spell.mana_cost
	if spell.turns == 0
		apply_spell(state, spell)
	else
		state.effects[spell.idx] = spell.turns
	end
end

def apply_spells(state)
	state.effects.keys.each do |spell_idx|
		apply_spell(state, SPELLS[spell_idx])
	end
end

def valid_spells(state)
	SPELLS.filter do |spell|
		next if !state.effects[spell.idx].nil?
		next if state.mana < spell.mana_cost
		true
	end
end

def clone_state(state)
	nstate = state.clone
	nstate.effects = nstate.effects.clone
	nstate
end

State = Struct.new(:boss_hp, :hp, :mana, :total_mana, :armor_boost, :effects)

def solve(extra_damage=0)
	initstate = State.new(BOSS_HP, 50, 500, 0, 0, {})
	seen = Set.new()
	stack = FibonacciHeap::Heap.new
	stack.insert FibonacciHeap::Node.new(0, initstate)
	res = []
	cnt = 0
	while !stack.empty?
		cnt += 1
		state = stack.pop.value
		p [cnt, stack.length, state.total_mana] if cnt % 10000 == 0
		state = clone_state state
		state.hp -= extra_damage
		next if state.hp <= 0
		apply_spells state
		return state if state.boss_hp <= 0
		valid_spells(state).each do |spell|
			nstate = clone_state(state)
			cast_spell(nstate, spell)
			nstate.armor_boost = 0
			apply_spells nstate
			nstate.hp -= [BOSS_DAMANGE-nstate.armor_boost, 1].max if nstate.boss_hp > 0
			nstate.armor_boost = 0
			if nstate.hp > 0 && !seen.include?(nstate)
				stack.insert FibonacciHeap::Node.new(nstate.total_mana, nstate) 
				seen << nstate
			end
		end
	end
end

p solve(0).total_mana
p solve(1).total_mana

# s1 5186 too high (break)
# s1 1269
# s2 1362 too high (extra casting cost, not minimal)
# s2 1309

# mistakes:
# - break exits only a single loop (superlame)
# - return on boss dying
#   - state should be pushed to stack
#   - it is only minimal when popped from stack
