
local SQUAD_MOVE_RULER = 1
local SQUAD_ATTACK_RULER = 2
local SQUAD_RULERS = {
    'http://pastebin.com/raw/QspzqNUx',
    'http://pastebin.com/raw/v9PG9iFC'
}
local SHIPS = {
    "http://paste.ee/r/eDbf1",
    "http://paste.ee/r/6LYTT",
    "http://paste.ee/r/a7mfW" }
local CMD_MESHES = {
    "http://i.imgur.com/q0kgzJZ.jpg", --repair
    "http://i.imgur.com/kCZ8ogN.jpg", --navigate
    "http://i.imgur.com/BRFhnnN.jpg", --concentrate
    "http://i.imgur.com/mlC12j8.jpg"} --squadron
local SQUAD = "http://paste.ee/r/nAMCQ"
local A_COLOR = {0,0.5,1.0 }
local B_COLOR = {1.0,0.25,0}
ruler = nil
shield_dials = nil
function onload(save_string)
--    for i,ship in ipairs(getAllObjects()) do
--        if isShip(ship) then
--            Ship_Initialize(ship)
--        end
--        if isSquad(ship) then
--            Squad_Initialize(ship)
--        end
--    end
    ruler = findObjectByName('Magic Ruler')
    shield_dials = findObjectByName('Shield Dials')
    if save_string~="" then
        local data = JSON.decode(save_string)
        for i, shipdata in pairs(data) do
            local obj = getObjectFromGUID(shipdata["GUID"])
            obj.setVar('owner',shipdata["owner"])
            obj.setVar('rulerMesh',shipdata["rulerMesh"])
            obj.setTable('maneuver',shipdata["maneuver"])
        end
    end
end
function onSave()
    local save = {}
    for i, ship in ipairs(getAllObjects()) do
        if ship.tag == "Figurine" and ship.getVar('owner')~=nil then
            local data = {}
            data["GUID"] = ship.getGUID()
            data["rulerMesh"] = ship.getVar('rulerMesh')
            data["maneuver"] = ship.getTable('maneuver')
            data["owner"] = ship.getVar('owner')
            save[ship.getGUID()] = data
        end
    end
    local save_string = JSON.encode_pretty(save)
    return save_string
end
function update()
    for _,ship in ipairs(getAllObjects()) do
        if ship.tag == 'Figurine' and ship.name ~= '' then
            local cmd = ship.getDescription()
            local oldName = ship.getVar('oldName')
            ship.setVar('oldName',ship.getName())
            if not ship.getVar('init') then
                Initialize(ship)
            end
            if isSquad(ship) then
                stopDropLock(ship)
            elseif isShip(ship) then
                CheckShip(ship)
            end
            if cmd~="" then
                if oldName ~= ship.getName() then
                    ship.setName(oldName)
                end
                ship.setDescription("")
                if cmd=="checkscale" then
                    printToAll(ship.getScale()[1],{0,1,1})
                end
                if cmd:starts "setscale " then
                    local s = string.gsub(cmd,"setscale ","")
                    ship.setScale({s,s,s})
                end
                if cmd=="checkpos" then
                    printToAll(vector.tostring(ship.getPosition()),{0,1,1})
                end
                if cmd=="checkrot" then
                    printToAll(tostring(ship.getRotation()[2]),{0,1,1})
                end
                if cmd:starts "var " then
                    printToAll(ship.getVar(cmd:match "var%s(.*)"),{0,1,0})
                end
                if isSquad(ship) then
                    if cmd=="r" then
                        spawnSquadRuler(ship,SQUAD_MOVE_RULER)
                    end
                    if cmd=="checkscale" then
                        printToAll(ship.getScale()[1],{0,1,1})
                    end
                    if cmd:starts "health" then
                        squad.UpdateName(ship,cmd:match "health%s(.*)",nil,nil)
                    end
                    if cmd:starts "maxhealth" then
                        squad.UpdateName(ship,nil,cmd:match "maxhealth%s(.*)",nil)
                    end
                    if cmd:starts "speed" then
                        squad.UpdateName(ship,nil,nil,cmd:match "speed%s(.*)")
                    end
                    --stopDropLock(ship)
                elseif isShip(ship) then
--                    CheckShip(ship)
                    if cmd =="shields" then
                        spawnShields(ship)
                    end
                    if cmd =="cmds" then
                        printCmds(ship)
                    end
                end
            end
        end
    end
    restrictMoveDistance(moving_with_ruler)
end
function printCmds(ship)
    --printToAll("printCmds",{1,0,0})
    local owner = ship.getVar('owner')
    --printToAll(owner,{1,0,0})
    if owner==nil then
        printToAll('Ship has no owner, pick it up to claim ownership',{1,0,0})
    elseif not table.contains(getSeatedPlayers(),owner) then
        printToAll('No player seated at: '..owner,{1,0,0})
    else
        local cmds = {}
        for i,token in ipairs(getAllObjects()) do
            local custom = token.getCustomObject()
            local isDial = custom~=nil and table.contains(CMD_MESHES,custom.diffuse)
            local offset = vector.rotate(vector.sub(token.getPosition(),ship.getPosition()),-ship.getRotation()[2])
            local size = ship_size[ship.getVar('size')]
            local isOnBase = math.abs(offset[1])<math.abs(size[1]) and math.abs(offset[3])<math.abs(size[3])
            if isOnBase and isDial then
                table.insert(cmds,token)
            end
        end
        table.sort(cmds, function(a,b) return a.getPosition()[2] > b.getPosition()[2] end)
        printToColor("Cmds for: "..ship.getName(), owner, {0,1,0} )
        for i,token in ipairs(cmds) do
            printToColor("#"..i.." "..dial.name(token), owner, {0,1,1} )
        end
    end
end
dial = {}
function dial.name(dial)
    local mesh = dial.getCustomObject().diffuse
    if mesh == "http://i.imgur.com/q0kgzJZ.jpg" then
        return "Repair"
    elseif mesh == "http://i.imgur.com/kCZ8ogN.jpg" then
        return "Navigate"
    elseif mesh == "http://i.imgur.com/BRFhnnN.jpg" then
            return "Concentrate Fire"
    elseif mesh == "http://i.imgur.com/mlC12j8.jpg" then
            return "Squadron"
    end
    return ""
end
--shieldedShip = nil
ship_size = {
    {0.807,0,1.398},
    {1.201,0,2.008},
    {1.496,0,2.539}
}
shield_pos = {
    {0.634,0,1.176},
    {1.028,0,1.835},
    {1.323,0,2.377}
}
function spawnShields(ship)
--    local pos = ship.getPosition()
--    ship.unlock()
--    ship.setPosition({pos[1],15,pos[3]})
    ship.lock()
    local size = getSize(ship)
    local o = shield_pos[math.mod(size-1,3)+1]
    local offsets = {
        {math.abs(o[1]),0,0},
        {-math.abs(o[1]),0,0},
        {0,0,math.abs(o[3])},
        {0,0,-math.abs(o[3])},
    }

    local world = ship.getPosition()
    local ground = {world[1],1,world[3]}
    for i,pos in ipairs(offsets) do

        local offset = vector.rotate(pos, ship.getRotation()[2])

        local params = {}
        params.position = vector.add(ground,offset)
        params.rotation = ship.getRotation()
        params.callback = 'fixshieldheight'
        params.callback_owner = Global
        params.params = {ship}
        local shield = shield_dials.takeObject(params)
        -- TODO: move up to 1.36
    end
end
function fixshieldheight(object, params)
    local pos = object.getPosition()
    local rot = object.getRotation()
    object.lock()
    object.setPosition({pos[1],1.36,pos[3]})
    object.setRotation({0,rot[2],0})
--    local ship = params[1]
--    local size = ship_size[ship.getVar('size')]
--    for _,obj in ipairs(getAllObjects()) do
--        local offset = vector.rotate(vector.sub(obj.getPosition(),ship.getPosition()),-ship.getRotation()[2])
--        if math.abs(offset[1])<math.abs(size[1]) and math.abs(offset[3])<math.abs(size[3]) then
--            -- WAS ON BASE
--            local pos = obj.getPosition()
--            pos[2] = 1.36
--            obj.setPosition(pos)
--            obj.lock()
--        end
--    end
    --http://i.imgur.com/WQJNmkt.png
end
--function spawnShieldsCorout()
--    local size = getSize(shieldedShip)
--    local o = button_pos[size]
--    local offsets = {
--        {o[1],0,0},
--        {-o[1],0,0},
--        {0,0,o[3]},
--        {0,0,-o[3]},
--    }
--
--    local world = shieldedShip.getPosition()
--    local ground = {world[1],0,world[2]}
--    shieldedShip.lock()
--    shieldedShip.setPosition(newpos)
--    for i,pos in ipairs(offsets) do
--
--        local offset = vector.rotate(pos, shieldedShip.getRotation()[2])
--
--        local params = {}
--        params.position = vector.add(ground,offset)
--        local shield = shield_dials.takeObject(params)
----        for i=1, 150, 1 do
----            coroutine.yield(0)
----        end
----            --delay
----        shield.lock()
----        local pos = shield.getPosition()
----        pos[2] = 0
----        shield.setPosition(pos)
--    end
--    return true
--end
function stopDropLock(squadron)
    local stop = squadron.getVar('stop')
    local drop = squadron.getVar('drop')
    if stop~=nil and stop>0 then
        squadron.setVar('stop',stop-1)
    elseif stop~=nil and stop==0 then
        squadron.setVar('stop',nil)
        --squadron.setVar('drop',30)
        squadron.unlock()
--    elseif drop~=nil and drop>0 then
--        squadron.setVar('drop',drop-1)
--    elseif drop~=nil and drop==0 then
--        squadron.setVar('drop',nil)
        --squadron.lock()
    end
end
function restrictMoveDistance(squadron)
    local distances = {2.93,4.875,7.25,9.625,12}
    if squadron~=nil then
        local ruler = squad_move_rulers[squadron.getGUID()]
        if ruler~=nil then
            local speed = squad.speed(squadron)
            local maxDistance = distances[speed] -- * 1.206
            local offset = vector.sub(squadron.getPosition(),ruler.getPosition())
            offset[2] = 0
            local distance = vector.length(offset)
            if distance>maxDistance then
                local restricted = vector.prod(offset,maxDistance/distance)
                local new_pos = vector.add(ruler.getPosition(),restricted)
                new_pos[2] = squadron.getPosition()[2]
                squadron.setPosition(new_pos)
            end
        end
    end
end
function Initialize(ship)
    --printToAll('initialize '..ship.getName(),{0,1,0})
    if isShip(ship) then
        ship.setVar('init',true)
        ship.setVar('size',getSize(ship))
        drawShipButtons(ship)
    elseif isSquad(ship) then
        ship.setVar('init',true)
        --printToAll(vector.tostring(ship.getColorTint()),{0,1,1})
        --local btint = {1.0,0.9,0.4}
        --printToAll(vector.tostring(btint),{0,1,1})
        --printToAll("compare "..ship.getColorTint()[1].." "..btint[1].." = "..tostring(double.eq(ship.getColorTint()[1],btint[1])),{0,1,1})
        --printToAll("compare "..ship.getColorTint()[2].." "..btint[2].." = "..tostring(double.eq(ship.getColorTint()[2],btint[2])),{0,1,1})
        --printToAll("compare "..ship.getColorTint()[3].." "..btint[3].." = "..tostring(double.eq(ship.getColorTint()[3],btint[3])),{0,1,1})
        if vector.eq(ship.getColorTint(),B_COLOR) then
            ship.setVar('state',"B")
        else
            ship.setVar('state',"A")
        end
        updateSquadButtons(ship)
        updateColor(ship)
    end
end
squad = {}
function squad.UpdateName(ship, new_health, new_maxhealth, new_speed)
    local health = squad.health(ship)
    local maxHealth = squad.maxhealth(ship)
    local speed = squad.speed(ship)
    local name = squad.name(ship)
    if new_health~=nil and health ~= new_health then
        printToAll("Changing health for '"..name.."' from "..health.." to "..new_health,{0,1,1})
        health = new_health
    end
    if new_maxhealth~=nil and maxHealth ~= new_maxhealth then
        printToAll("Changing maxhealth for '"..name.."' from "..maxHealth.." to "..new_maxhealth,{0,1,1})
        maxHealth = new_maxhealth
    end
    if new_speed~=nil and speed ~= new_speed then
        printToAll("Changing speed for '"..name.."' from "..speed.." to "..new_speed,{0,1,1})
        speed = new_speed
    end
    ship.setName("("..health.."/"..maxHealth..") ["..speed.."] "..name)
end
function Action_PlusHealth(ship)
    local health = squad.health(ship)
    local maxHealth = squad.maxhealth(ship)
    if health<maxHealth then
        squad.UpdateName(ship,health+1)
    end
    updateSquadButtons(ship)
end
function Action_MinusHealth(ship)
    local health = squad.health(ship)
    if health>0 then
        squad.UpdateName(ship,health-1)
    end
    updateSquadButtons(ship)
end
function squad.health(squad)
    local health = squad.getName():match "%((%d)/?%d?%)"
    if health == nil then return 5
    else return tonumber(health) end
end
function squad.maxhealth(squad)
    local health = squad.getName():match "%(%d/?(%d?)%)"
    if health == nil then return 5
    else return tonumber(health) end
end
function squad.speed(squad)
    local speed = squad.getName():match "%[(%d)%]"
    if speed == nil then return 5
    else return tonumber(speed) end
end
function squad.name(squad)
    local name = squad.getName():match "%(?%d?/?%d?%)?%s?%[?%d?%]?%s?(.*)$"
    return name
end
function CheckShip(ship)
    local savedSize = ship.getVar('size')
    local sizeFromName = getSize(ship)
    if savedSize~=sizeFromName then
        drawShipButtons(ship)
        ship.setVar('size',sizeFromName)
    end
end
--button_pos = {{0.85,0.5,-1.7},
--              {1.4,0.5,-2.5},
--              {1.8,0.5,-3.3},
--              {-0.85,0.5,1.7},
--              {-1.4,0.5,2.5},
--              {-1.8,0.5,3.3}}
function drawShipButtons(ship)
    --printToAll('drawShipButtons for '..ship.getName(),{0,1,1})
    local name = ship.getName()
    local index = ship.getVar('size') --getSize(ship)
--    local index
--    if name:match " S$" then index = 1 ship.setVar('size',1) end
--    if name:match " M$" then index = 2 ship.setVar('size',2) end
--    if name:match " L$" then index = 3 ship.setVar('size',3) end
--    if name:match " SR$" then index = 4 ship.setVar('size',4) end
--    if name:match " MR$" then index = 5 ship.setVar('size',5) end
--    if name:match " LR$" then index = 6 ship.setVar('size',6) end
    if index~=nil then
        clearButtons(ship)
        local left_pos = vector.add(vector.scale(ship_size[index],vector.onedividedby(ship.getScale())),{-0.2,0.53,-0.3})
        local right_pos = vector.scale(left_pos, {-1,1,1})
        local back_left_pos = {left_pos[1],0.53,-left_pos[3]}
        local back_right_pos = {-left_pos[1],0.53,-left_pos[3]}
        ship.createButton(buildRelativeButton(ship, "M",{click_function="Action_ruler_left",position=left_pos},ship_button_def))
        ship.createButton(buildRelativeButton(ship, "M",{click_function="Action_ruler_right",position=right_pos},ship_button_def))
        ship.createButton(buildRelativeButton(ship, "R",{click_function="Action_attack_ruler",position=back_left_pos},ship_button_def))
        ship.createButton(buildRelativeButton(ship, "r",{click_function="Action_15range_ruler",position=vector.add(back_left_pos,{0,0,0.4})},ship_button_def))
        ship.createButton(buildRelativeButton(ship, "C",{click_function="Action_cmds",position=back_right_pos},ship_button_def))
    end
end
ATTACK_RULERS = {
    "http://paste.ee/r/b5yCa",
    "http://paste.ee/r/Gwytv",
    "http://paste.ee/r/yBgAR"
}
RANGE_RULER_MESH = {
    "http://paste.ee/p/zS6HS",
    "http://paste.ee/p/j8OxD",
    "https://paste.ee/p/ayQRT"
}
function Action_cmds(ship)
    printCmds(ship)
end
function Action_15range_ruler(ship)
    local ruler = ship.getVar('ruler')
    if ruler == nil then
        ship.lock()
        --local mesh = ship.getVar("rulerMesh")
        local obj_parameters = {}
        obj_parameters.type = 'Custom_Model'
        obj_parameters.position = ship.getPosition()
        obj_parameters.rotation = ship.getRotation()
        local newruler = spawnObject(obj_parameters)
        local custom = {}
        custom.mesh = RANGE_RULER_MESH[ship.getVar('size')]
        custom.collider = ATTACK_RULERS[ship.getVar('size')]
        newruler.setCustomObject(custom)
        newruler.lock()
        ship.setVar('ruler',newruler)
    else
        ruler.destruct()
        ship.setVar('ruler',nil)
    end
end
function Action_attack_ruler(ship)
    local ruler = ship.getVar('ruler')
    if ruler == nil then
        ship.lock()
        local mesh = ship.getVar("rulerMesh")
        local obj_parameters = {}
        obj_parameters.type = 'Custom_Model'
        obj_parameters.position = ship.getPosition()
        obj_parameters.rotation = ship.getRotation()
        local newruler = spawnObject(obj_parameters)
        local custom = {}
        custom.mesh = mesh
        custom.collider = ATTACK_RULERS[ship.getVar('size')]
        newruler.setCustomObject(custom)
        newruler.lock()
        ship.setVar('ruler',newruler)
    else
        ruler.destruct()
        ship.setVar('ruler',nil)
    end
end
function getSize(ship)
    local index
    local ship_collider = ship.getCustomObject().collider
    for i,collider in ipairs(SHIPS) do
        if collider==ship_collider then
            index=i
            break
        end
    end
    --ship.setVar('size',index)
    -- printToAll('size for '..ship.getName()..' is '..tostring(index),{0,1,1})
    return index
--    local sizes = {S=1,M=2,L=3,SR=4,MR=5,LR=6 }
--    local sizeFromName = ship.getName():match "%s(%u%u?)$"
--    local size
--    if sizeFromName~=nil then
--        --printToAll("Found size "..sizeFromName,{0,1,1})
--        size = sizes[sizeFromName]
--    end
--    return size
end
function updateSquadButtons(ship)
    clearButtons(ship)
    local state = ship.getVar('state')
--    if state ~= "A" then
    local y = 0.3
    ship.createButton(buildButton("-",{click_function="Action_MinusHealth",position = {-0.2,y,0}},squad_button_def))
    ship.createButton(buildButton(tostring(squad.health(ship)),{position = {0,y,0}},squad_button_def))
    ship.createButton(buildButton("+",{click_function="Action_PlusHealth",position = {0.2,y,0}},squad_button_def))
    ship.createButton(buildButton("Attack",{click_function="Action_Attack",position = {0,y,0.7}, width=250,font_size=70},squad_button_def))
    ship.createButton(buildButton("Move",{click_function="Action_Move",position = {0,y,-0.7}, width=250,font_size=70},squad_button_def))
    ship.createButton(buildButton("Activate",{position = {0.6,0.15,0}, rotation = {0,90,0},width=250,font_size=70},squad_button_def))
    ship.createButton(buildButton("Activate",{position = {-0.6,0.15,0}, rotation = {0,90,0}, width=250,font_size=70},squad_button_def))
--    elseif state ~= "B" then
--        squad.createButton(buildButton("B",{position = {1.5,0,0}},squad_button_def))
--    end
end
function updateColor(squad)
    local state = squad.getVar('state')
    if state == "A" then squad.setColorTint(A_COLOR) --({0.3,1.0,1.0}) -- {0.78,0.86,0.99} C9DCFD
    elseif state == "B" then squad.setColorTint(B_COLOR) --({1.0,0.9,0.4})  -- {0.52,0.29,0.19} FD8A5B
    end
end
function Action_Activate(squad)
    local state = squad.getVar('state')
    if state == "A" then squad.setVar('state',"B")
    else squad.setVar('state',"A") end --if state == "B" then
    updateSquadButtons(squad)
    updateColor(squad)
    squad.lock()
end
undos = {}
function Action_Move(squad)
    undos[squad.getGUID()] = squad.getPosition()
    spawnSquadRuler(squad,SQUAD_MOVE_RULER)
end
function Action_Undo(squad)
    local old_pos = undos[squad.getGUID()]
    if old_pos~=nil then
        squad.setPosition(old_pos)
        local squad_rot = squad.getRotation()
        squad.setRotation({0,squad_rot[2],0})
        squad.unlock()
    end
end
function Action_Attack(squad)
    spawnSquadRuler(squad,SQUAD_ATTACK_RULER)
end
function isShip(ship)
    return table.contains(SHIPS,ship.getCustomObject().collider)
--    local name = ship.getName()
--    return ship.tag == "Figurine" and (name:match " S$" or name:match " M$" or name:match " L$"
--        or name:match " SR$" or name:match " MR$" or name:match " LR$")
end
function isSquad(ship)
    return SQUAD ==ship.getCustomObject().collider
--    local name = ship.getName()
--    return ship.tag == "Figurine" and name:match " Sq$"
end
squad_move_rulers = {}
function spawnSquadRuler(squad,type)
    clearButtons(squad)
    if type==SQUAD_MOVE_RULER then
        squad.unlock()
        squad.createButton(buildButton("Undo",{position={0,0.3,0.2},width=400,font_size=100},squad_button_def))
    end
    local world = squad.getPosition()
    local scale = squad.getScale()
    --local s = scale[2] --2.30362
    --scale = {scale[1]*s,scale[2]*s,scale[3]*s}
    local obj_parameters = {}
    obj_parameters.type = 'Custom_Model'
    obj_parameters.position = world
    obj_parameters.rotation = { 0, 0, 0 }
    local newruler = spawnObject(obj_parameters)
    local custom = {}
    -- Attack mesh http://pastebin.com/raw/v9PG9iFC
    -- custom.mesh = 'http://pastebin.com/raw/QspzqNUx'
    custom.mesh = SQUAD_RULERS[type]
    custom.collider = 'http://pastebin.com/raw/fnyPsyke'
    newruler.setCustomObject(custom)
    newruler.lock()
    newruler.scale(scale)
    squad.createButton(buildButton("Done",{position={0,0.3,-0.2},width=400,font_size=100},squad_button_def))
    squad.setVar('ruler',newruler)
    newruler.setVar('parent',squad)
    squad_move_rulers[squad.getGUID()] = newruler
end
moving_with_ruler = nil
function onObjectPickedUp( player_color, picked_up_object )
    if isSquad(picked_up_object) and squad_move_rulers[picked_up_object.getGUID()]~=nil then
        --moving squad with ruler
        moving_with_ruler = picked_up_object
    end
end
function onObjectDropped( player_color, dropped_object )
    if dropped_object==moving_with_ruler then
        moving_with_ruler.lock()
        restrictMoveDistance(moving_with_ruler)
--        local newpos = moving_with_ruler.getPosition()
--        newpos[2] = 0.5
--        moving_with_ruler.setPosition(newpos)
        --TODO: implement unlock and drop
        --stop,drop,lock
        moving_with_ruler.setVar('stop',2)
        moving_with_ruler=nil
    end
    local droppos = dropped_object.getPosition()
    if dropped_object.tag == "Figurine" then
        dropped_object.setVar('owner',player_color)
    end
    local custom = dropped_object.getCustomObject()
    local isDial = custom~=nil and table.contains(CMD_MESHES,custom.diffuse)
    local wasDropped = dropped_object.getVar('dropped')==true
    if isDial and not wasDropped then
        local ship = findShip(dropped_object.getPosition())
        if ship~=nil and ship.getVar('owner')==player_color then
            --lift existing tokens
            --increase others to 0.36
            for i,token in ipairs(getAllObjects()) do
                local other_custom = token.getCustomObject()
                local otherIsDial = other_custom~=nil and table.contains(CMD_MESHES,other_custom.diffuse)
                local offset = vector.rotate(vector.sub(token.getPosition(),ship.getPosition()),-ship.getRotation()[2])
                local size = ship_size[ship.getVar('size')]
                local isOnBase = math.abs(offset[1])<math.abs(size[1]) and math.abs(offset[3])<math.abs(size[3])
                if otherIsDial and isOnBase and token~=dropped_object then
                    --printToAll("moving: "..token.getGUID(),{1,0,0})
                    local pos = token.getPosition()
                    token.setPosition({pos[1],pos[2]-1.43+1.0+droppos[2],pos[3]})
                end
            end
            --printToAll("DialDroppedNearOwnedShip",{0,1,0})

            --move to 1.76
            local shippos = ship.getPosition()
            local shippos = ship.getPosition()
            local offset = {0,0,-ship_size[ship.getVar('size')][3]+0.9 }
            local rotoff = vector.rotate(offset,ship.getRotation()[2])
            dropped_object.setPositionSmooth({shippos[1]+rotoff[1],droppos[2],shippos[3]+rotoff[3]}) --shippos[2]+0.807
            dropped_object.setRotationSmooth({0,ship.getRotation()[2]+180,0})
            dropped_object.lock()
            dropped_object.setVar('dropped',true)
            local color = stringColorToRGB(player_color)
            if player_color=="White" then
                color.r = 0.4
                color.g = 0.4
                color.b = 0.4
            end
            dropped_object.setColorTint({1-(1-color.r)/2,1-(1-color.g)/2,1-(1-color.b)/2})
        end
    end
end
function findShip(position)
    for i,ship in ipairs(getAllObjects()) do
        if ship.tag == "Figurine" then
            local offset = vector.rotate(vector.sub(position,ship.getPosition()),-ship.getRotation()[2])
            local size = ship_size[ship.getVar('size')]
            if size ~=nil then
                local isOnBase = math.abs(offset[1])<math.abs(size[1]) and math.abs(offset[3])<math.abs(size[3])
                if isOnBase then
                    return ship
                end
            end
        end
    end
    return nil
end
function Action_Done(squad)
    local ruler = squad.getVar('ruler')
    --local squad = object.getVar('parent')
    squad_move_rulers[squad.getGUID()]=nil
    updateSquadButtons(squad)
    ruler.destruct()
    squad.lock()
end
function Action_ruler_left(ship)
    moveRuler(ship, -1)
end
function Action_ruler_right(ship)
    moveRuler(ship, 1)
end
function moveRuler(ship, direction)
    ship.lock()
    local size = ship.getVar('size')
    local b_pos = ship_size[size]
    local pos = vector.add({b_pos[1]*direction,0,b_pos[3]},{0.32*direction,0,-0.78})
    local rot = ship.getRotation()[2]
    local rotated = vector.rotate(pos, rot)
    --if size>3 then rot=rot+180 end

    ruler.setPosition(vector.add(ship.getPosition(),rotated))
    ruler.setRotation({0,rot,0 })
    ruler.lock()
    ruler.setVar('ship',ship)
    ruler.setTable('maneuver',ship.getTable('maneuver'))
end
ship_button_def = {position = {0,0.3,0},rotation = {0,180,0},height = 200,width = 200,font_size = 200}
squad_button_def = {position = {0,0.17,0},rotation = {0,0,0},height = 150,width = 125,font_size = 150}
function buildRelativeButton(object, label, def, defaults)
    local scale = object.getScale()[1]
    if def.position==nil then def.position = defaults.position end
    if def.rotation==nil then def.rotation = defaults.rotation end
    --if def.width==nil then def.width = 100 + string.len(label)*DEFAULT_WIDTH_PER_CHAR end
    if def.width==nil then def.width = defaults.width / scale end
    if def.height==nil then def.height = defaults.height / scale end
    if def.font_size==nil then def.font_size = defaults.font_size / scale end
    if def.click_function==nil then def.click_function = 'Action_'..label end
    if def.function_owner==nil then def.function_owner = self end
    return {['click_function'] = def.click_function, ['function_owner'] = def.function_owner, ['label'] = label, ['position'] = def.position, ['rotation'] =  def.rotation, ['width'] = def.width, ['height'] = def.height, ['font_size'] = def.font_size}
end
function buildButton(label, def, defaults)
    if def.position==nil then def.position = defaults.position end
    if def.rotation==nil then def.rotation = defaults.rotation end
    --if def.width==nil then def.width = 100 + string.len(label)*DEFAULT_WIDTH_PER_CHAR end
    if def.width==nil then def.width = defaults.width end
    if def.height==nil then def.height = defaults.height end
    if def.font_size==nil then def.font_size = defaults.font_size end
    if def.click_function==nil then def.click_function = 'Action_'..label end
    if def.function_owner==nil then def.function_owner = self end
    return {['click_function'] = def.click_function, ['function_owner'] = def.function_owner, ['label'] = label, ['position'] = def.position, ['rotation'] =  def.rotation, ['width'] = def.width, ['height'] = def.height, ['font_size'] = def.font_size}
end
function clearButtons(object)
    --this is a workaround for obj.clearButtons() being broken as of v7.10
    if object.getButtons() ~= nil then
        for i=#object.getButtons()-1,0,-1 do
            object.removeButton(i)
        end
    end
end
vector = {}
function vector.length(v)
    return math.sqrt(v[1]*v[1]+v[2]*v[2]+v[3]*v[3])
end
function vector.add(pos, offset)
    return {pos[1] + offset[1],pos[2] + offset[2],pos[3] + offset[3]}
end
function vector.sub(pos, offset)
    return {pos[1] - offset[1],pos[2] - offset[2],pos[3] - offset[3]}
end
function vector.scale(v,s)
    return {v[1] * s[1],v[2] * s[2],v[3] * s[3]}
end
function vector.prod(v,s)
    return {v[1] * s,v[2] * s,v[3] * s}
end
function vector.onedividedby(v)
    return {1/v[1],1/v[2] ,1/v[3]}
end
function vector.rotate(direction, yRotation)

    local rotval = math.round(yRotation)
    local radrotval = math.rad(rotval)
    local xDistance = math.cos(radrotval) * direction[1] + math.sin(radrotval) * direction[3]
    local zDistance = math.sin(radrotval) * direction[1] * -1 + math.cos(radrotval) * direction[3]
    return {xDistance, direction[2], zDistance}
end
function vector.eq(a,b)
    return double.eq(a[1],b[1]) and double.eq(a[2],b[2]) and double.eq(a[3],b[3])
end
double = {}
function double.eq(a,b)
    return math.round(a,2)==math.round(b,2)
end
function vector.tostring(v)
    return "{"..math.round(v[1],3)..","..math.round(v[2],3)..","..math.round(v[3],3).."}"
end
function findObjectByName(name)
    for i,obj in ipairs(getAllObjects()) do
        if obj.getName()==name then return obj end
    end
end
function math.mod(a,b)
    return a - math.floor(a/b)*b
end
function math.round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function math.sign(x)
    if x<0 then return -1
    elseif x>0 then return 1
    else return 0 end
end
function math.round(num, idp)
    if num == nil then return nil end
    local mult = 10^(idp or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
end
function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end
function table.contains(self, val)
    for index, value in ipairs (self) do
        if value == val then
            return true
        end
    end

    return false
end