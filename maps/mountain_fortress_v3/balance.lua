local Event = require 'utils.event'
local Difficulty = require 'modules.difficulty_vote_by_amount'

local Public = {}

Public.events = {breached_wall = Event.generate_event_name('breached_wall')}

function Public.init_enemy_weapon_damage()
    local data = {
        ['artillery-shell'] = -1.3,
        ['biological'] = 0,
        ['beam'] = 0,
        ['bullet'] = 0,
        ['cannon-shell'] = 0,
        ['capsule'] = 0,
        ['electric'] = 0,
        ['flamethrower'] = 0,
        ['grenade'] = 0,
        ['laser'] = 0,
        ['landmine'] = 0,
        ['melee'] = 0,
        ['rocket'] = 0,
        ['shotgun-shell'] = 0
    }

    local e = game.forces.enemy

    e.technologies['refined-flammables-1'].researched = true
    e.technologies['refined-flammables-2'].researched = true
    e.technologies['energy-weapons-damage-1'].researched = true

    for k, v in pairs(data) do
        e.set_ammo_damage_modifier(k, v)
    end
end

local function enemy_weapon_damage()
    local e = game.forces.enemy

    local data = {
        ['artillery-shell'] = 0.05,
        ['biological'] = 0.06,
        ['beam'] = 0.08,
        ['bullet'] = 0.08,
        ['capsule'] = 0.08,
        ['electric'] = 0.08,
        ['flamethrower'] = 0.08,
        ['laser'] = 0.08,
        ['landmine'] = 0.08,
        ['melee'] = 0.08
    }

    for k, v in pairs(data) do
        local new = Difficulty.get().value * v

        local e_old = e.get_ammo_damage_modifier(k)

        e.set_ammo_damage_modifier(k, new + e_old)
    end
end

Event.add(Public.events.breached_wall, enemy_weapon_damage)

return Public
