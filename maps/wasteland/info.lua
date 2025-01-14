local Public = {}

local changelog =
    [[[font=heading-1]Apr 2023 updates[/font]
 - Tank combat rebalance
   - Tanks are much weaker against physical damage
   - Tank vs Tank damage is now 10x increased
 - PvP shields are stronger and some bugs fixed
 - Starting towns late game is easier
 - Research difficulty decreased for towns with multiple players
 - Chests with explosive items don't explode anymore]]

local info =
    [[[font=heading-1]Welcome to the wasteland[/font]
Build a town that can survive against biters and other players!


]] .. changelog

local info_adv =
    changelog ..
    [[


[font=heading-1]Goal of the game[/font]
Survive as long as you can. Raid other towns. Defend your town.

[font=heading-1]Advanced tips and tricks[/font]
- To join our discord, open wasteland-discord.fun in your web browser
- It's best to found new towns far from existing towns, as enemies will become aggressive with town's research.
    Biters and spitters become more aggressive towards towns that are advanced in research.
    Their evolution will scale around technology progress in any nearby towns and pollution levels.
- How to get more ores? Make sure you researched steel processing,
    then hand mine a few big rocks to find ore patches under them!
- How to get more oil? Kill worms - some of them will leave you an oil patch
- The town market is the heart of your town. If it is destroyed, you lose everything.
    So protect it well, repair it whenever possible, and increase its health by purchasing upgrades.
- It's possible to automate trading with the town center! How cool is that?!! Try it out.
    Tip: use filter inserters with to get coins/iron/.. out of the market
- Fishes procreate near towns. The more fishes, the quicker they multiply. Automated fish farm, anyone?
    Accidentally overfished? No problem, you can drop them back in
- Use /rename-town NEWNAME (chat command) to rename your town
- If you get stuck or trapped, use the /suicide chat command to respawn
- It is not possible to build near enemy turrets or power poles
    except logistics entities (inserters, belts, boxes, rails) that can be used to steal items
- Research modifier: Towns with more members (online+recently offline) have more expensive research. Less advanced towns have cheaper research
- Damage modifier: Members of towns with more online members cause reduced damage against other towns and players

[font=heading-1]PvP Shields[/font]
- PvP shields prevent players from entering, building and damaging
- Offline PvP shields deploy automatically once all players of a town go offline
    The size is same as your initial town wall, marked by the blue tiles
- Your town has a AFK PvP shield that you can use to safely take a quick break
    Deploy it from the market
- Big and behemoth biters can't penetrate your shield, but small and medium ones can

[font=heading-1]Town members and alliances[/font]
- Once a town is formed, members may invite other players and teams using a coin. To invite another player, drop a coin
on that player (with the Z key). To accept an invite, offer a coin in return to the member. To leave a town, simply drop coal
on the market.
- To form any alliance with another town, drop a coin on a member or their market. If they agree they can reciprocate with a
coin offering.]]

function Public.toggle_button(player)
    if player.gui.top['towny_map_intro_button'] then
        return
    end
    local b = player.gui.top.add({type = 'sprite-button', caption = 'Help', name = 'towny_map_intro_button'})
    b.style.font_color = {r = 0.5, g = 0.3, b = 0.99}
    b.style.font = 'heading-1'
    b.style.minimal_height = 38
    b.style.minimal_width = 80
    b.style.top_padding = 1
    b.style.left_padding = 1
    b.style.right_padding = 1
    b.style.bottom_padding = 1

    local last_winner_name = "[[WINNER_NAME]]"
    local b = player.gui.top.add({type = 'sprite-button', caption = "Last round winner: " .. last_winner_name,
                                  name = 'towny_map_last_winner'})
    b.style.font_color = {r = 1, g = 0.7, b = 0.1}
    b.style.minimal_height = 38
    b.style.minimal_width = 320
    b.style.top_padding = 1
    b.style.left_padding = 1
    b.style.right_padding = 1
    b.style.bottom_padding = 1
end

function Public.show(player, info_type)
    if player.gui.center['towny_map_intro_frame'] then
        player.gui.center['towny_map_intro_frame'].destroy()
    end
    local frame = player.gui.center.add {type = 'frame', name = 'towny_map_intro_frame'}
    frame = frame.add {type = 'frame', direction = 'vertical'}

    local cap = info
    if info_type == 'adv' then
        cap = info_adv
    end
    local l2 = frame.add {type = 'label', caption = cap}
    l2.style.single_line = false
    l2.style.font = 'heading-2'
    l2.style.font_color = {r = 0.8, g = 0.7, b = 0.99}
end

function Public.close(event)
    if not event.element then
        return
    end
    if not event.element.valid then
        return
    end
    local parent = event.element.parent
    for _ = 1, 4, 1 do
        if not parent then
            return
        end
        if parent.name == 'towny_map_intro_frame' then
            parent.destroy()
            return
        end
        parent = parent.parent
    end
end

function Public.toggle(event)
    if not event.element then
        return
    end
    if not event.element.valid then
        return
    end
    if event.element.name == 'towny_map_intro_button' then
        local player = game.players[event.player_index]
        if player.gui.center['towny_map_intro_frame'] then
            player.gui.center['towny_map_intro_frame'].destroy()
        else
            Public.show(player, 'adv')
        end
    end
end

local function on_gui_click(event)
    Public.close(event)
    Public.toggle(event)
end

local Event = require 'utils.event'
Event.add(defines.events.on_gui_click, on_gui_click)

return Public
