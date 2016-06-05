
local SQUAD_MOVE_RULER = 1
local SQUAD_ATTACK_RULER = 2
local SQUAD_RULERS = {
    'http://pastebin.com/raw/QspzqNUx',
    'http://pastebin.com/raw/v9PG9iFC'
}

ruler = nil
function onload()
    for i,ship in ipairs(getAllObjects()) do
        if isShip(ship) then
            drawShipButtons(ship)
        end
        if isSquad(ship) then
            updateSquadButtons(ship)
            updateColor(ship)
        end
    end
    ruler = findObjectByName('Magic Ruler')
end
function update()
    for _,ship in ipairs(getAllObjects()) do
        if ship.tag == 'Figurine' and ship.name ~= '' then
            if isSquad(ship) then
                local cmd = ship.getDescription()
                ship.setDescription("")
                if cmd=="r" then
                    spawnSquadRuler(ship,SQUAD_MOVE_RULER)
                end
                if cmd=="checkpos" then
                    printToAll(vector.tostring(ship.getPosition()))
                end
            end
        end
    end
end
button_pos = {{0.85,0.5,-1.7},
              {1.4,0.5,-2.5},
              {1.8,0.5,-3.3},
              {-0.85,0.5,1.7},
              {-1.4,0.5,2.5},
              {-1.8,0.5,3.3}}
function drawShipButtons(ship)
    local name = ship.getName()
    local index
    if name:match " S$" then index = 1 ship.setVar('size',1) end
    if name:match " M$" then index = 2 ship.setVar('size',2) end
    if name:match " L$" then index = 3 ship.setVar('size',3) end
    if name:match " SR$" then index = 4 ship.setVar('size',4) end
    if name:match " MR$" then index = 5 ship.setVar('size',5) end
    if name:match " LR$" then index = 6 ship.setVar('size',6) end
    if index~=nil then
        ship.clearButtons()
        local right_pos = vector.scale(button_pos[index],vector.onedividedby(ship.getScale()))
        local left_pos = {-right_pos[1],right_pos[2],right_pos[3]}
        ship.createButton(buildRelativeButton(ship, "R",{click_function="Action_ruler_left",position=left_pos},ship_button_def))
        ship.createButton(buildRelativeButton(ship, "R",{click_function="Action_ruler_right",position=right_pos},ship_button_def))
    end
end
function getSize(ship)
end
function updateSquadButtons(squad)
    squad.clearButtons()
    local state = squad.getVar('state')
--    if state ~= "A" then
    squad.createButton(buildButton("A",{click_function="Action_Attack",position = {-0.8,0.7,0.2}},squad_button_def))
    squad.createButton(buildButton("M",{click_function="Action_Move",position = {0.8,0.7,0.2}},squad_button_def))
    squad.createButton(buildButton("Activate",{position = {0,0.7,0.9}, width=900,font_size=200},squad_button_def))
--    elseif state ~= "B" then
--        squad.createButton(buildButton("B",{position = {1.5,0,0}},squad_button_def))
--    end
end
function updateColor(squad)
    local state = squad.getVar('state')
    if state == "A" then squad.setColorTint({0.3,1.0,1.0}) -- {0.78,0.86,0.99} C9DCFD
    elseif state == "B" then squad.setColorTint({1.0,0.9,0.4})  -- {0.52,0.29,0.19} FD8A5B
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
function Action_Move(squad)
    spawnSquadRuler(squad,SQUAD_MOVE_RULER)
end
function Action_Attack(squad)
    spawnSquadRuler(squad,SQUAD_ATTACK_RULER)
end
function isShip(ship)
    local name = ship.getName()
    return ship.tag == "Figurine" and (name:match " S$" or name:match " M$" or name:match " L$"
        or name:match " SR$" or name:match " MR$" or name:match " LR$")
end
function isSquad(ship)
    local name = ship.getName()
    return ship.tag == "Figurine" and name:match " Sq$"
end
function spawnSquadRuler(squad,type)
    squad.clearButtons()
    if type==SQUAD_MOVE_RULER then squad.unlock() end
    local world = squad.getPosition()
    local scale = squad.getScale()
    local s = 1.93804 --2.30362
    scale = {scale[1]*s,scale[2]*s,scale[3]*s}
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
    newruler.createButton(buildButton("Remove",{position={0,0.5,0},rotation=squad.getRotation(),width=1200,font_size=200},squad_button_def))
    newruler.setVar('parent',squad)

end
function Action_Remove(object)
    local squad = object.getVar('parent')
    updateSquadButtons(squad)
    object.destruct()
end
function Action_ruler_left(ship)
    local size = ship.getVar('size')
    local b_pos = button_pos[size]
    local pos = vector.add({b_pos[1],0,b_pos[3]},{0.65*math.sign(b_pos[1]),0,-0.7*math.sign(b_pos[3])})
    local rot = ship.getRotation()[2]
    local rotated = vector.rotate(pos, rot)
    if size>3 then rot=rot+180 end

    ruler.setPosition(vector.add(ship.getPosition(),rotated))
    ruler.setRotation({0,rot,0 })
    ruler.lock()
    ruler.setVar('ship',ship)
end
function Action_ruler_right(ship)
    local size = ship.getVar('size')
    local b_pos = button_pos[size]
    local pos = vector.add({-b_pos[1],0,b_pos[3]},{0.65*math.sign(-b_pos[1]),0,-0.7*math.sign(b_pos[3])})
    local rot = ship.getRotation()[2]
    local rotated = vector.rotate(pos, rot)
    if size>3 then rot=rot+180 end

    ruler.setPosition(vector.add(ship.getPosition(),rotated))
    ruler.setRotation({0,rot,0 })
    ruler.lock()
    ruler.setVar('ship',ship)
end
ship_button_def = {position = {0,0.17,0},rotation = {0,0,0},height = 200,width = 200,font_size = 250}
squad_button_def = {position = {0,0.17,0},rotation = {0,0,0},height = 300,width = 250,font_size = 300}
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
vector = {}
function vector.add(pos, offset)
    return {pos[1] + offset[1],pos[2] + offset[2],pos[3] + offset[3]}
end
function vector.scale(v,s)
    return {v[1] * s[1],v[2] * s[2],v[3] * s[3]}
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
function vector.tostring(v)
    return "{"..math.round(v[1],1)..","..math.round(v[2],1)..","..math.round(v[3],1).."}"
end
function findObjectByName(name)
    for i,obj in ipairs(getAllObjects()) do
        if obj.getName()==name then return obj end
    end
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