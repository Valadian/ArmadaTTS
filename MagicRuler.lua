rulers = {}
cmds = {}
last_rot = 0
target_rot = 0
cmd_dir = 0
stable_count = 0
--real_rot = 0
function onload()
    drawButtons()
    last_rot = self.getRotation()[2]
    target_rot = self.getRotation()[2]
    --real_rot = self.getRotation()[2]
end
function update ()
    local cmd_string = self.getDescription()
--    if cmd == " " then
--        destroyRulers()
--    end
    self.setDescription("");
    if string.len(cmd_string)>0 then
        printToAll('Processing Cmd "'..cmd_string..'"',{1,0,0})
        local new_cmds = string:split(cmd_string,",",5,false)
        if #new_cmds>0 then
            if isCmd(new_cmds[1]) then
                buildRuler(new_cmds)
            end
        end
    end
    --restrictRotation(22.5)
    --moveRuler()
    moveChildren()
end
function buildRuler(new_cmds)
    destroyRulers()
    cmds = table.copy(new_cmds)
--    for _,c in ipairs(new_cmds) do
--        printToAll('"'..tonumber(c)..'"',{1,0,0})
--    end
    if #new_cmds>0 then
        extendSelf(self, 1, new_cmds)
    end
    drawButtons()
end
--colliding = false
--function onCollisionExit( collision_info )
--    colliding = false
--end
--function onCollisionStay( collision_info )
--    self.setRotation({0,target_rot,0})
--end
--pickedUp = false
--override = 0
--dropProtect = 0
--function onPickedUp( player_color )
--    pickedUp = true
--    override = self.getRotation()[2]
--    stable_count = 10
--    cmd_dir = 0
--end
--function onDropped( player_color )
--    pickedUp = false
--    printToAll("Dropped "..cmd_dir.." "..stable_count,{1,0,0})
--    target_rot = override
--    dropProtect = 20
--end
function restrictRotation(increment)
    if pickedUp then
        self.setRotation({0,override,0})
    elseif not colliding then
        local curr_rot = self.getRotation()[2]
        --printToAll(curr_rot,{1,0,0})
        local diff = angleDiff(curr_rot,last_rot)
        --printToAll(diff,{1,0,0})
        last_rot = curr_rot
        if math.abs(diff)<0.01 then
            stable_count = stable_count + 1
            if stable_count>2 then
                cmd_dir = 0
                if target_rot~=nil then
                    --printToAll("Adjust",{0,1,0})
                    --NOT COMMANDED
                    -- target_rot = math.round(curr_rot/increment)*increment
                    local new_rot = math.clamp(target_rot,curr_rot-3,curr_rot+3)
                    last_rot = math.mod(new_rot,360)
                    self.setRotation({0,new_rot,0})
                end
            end
        else
            stable_count = 0
            dropProtect = dropProtect -1
            if dropProtect<0 then
                cmd_dir = cmd_dir + math.sign(diff)
            end
            --external commanding
            --local direction = math.sign(diff)

            if cmd_dir > 5 and math.abs(curr_rot-target_rot)>7 then
                target_rot = math.mod(math.ceil(curr_rot/increment)*increment,360)
                printToAll("New Target CW - "..target_rot,{0,1,0})
            elseif cmd_dir < -5 then
                target_rot = math.floor(curr_rot/increment)*increment
                printToAll("New Target CCW- "..target_rot,{0,1,0})
            end
        end
    end
end
function math.sign(x)
    if x<0 then return -1
    elseif x>0 then return 1
    else return 0 end
end
function angleDiff(a,b)
    angle = a - b
    return math.mod(angle + 180, 360) - 180
--    local diff = a - b
--    if diff > 180 then diff=diff-360
--    elseif diff < 180 then diff=diff+360
--    end
--    if diff == 360 then diff = 0 end
--    return diff
end
function moveRuler()
    local pos = self.getPosition()
    if pos[2]>2 then
        pos = {pos[1],2,pos[3]}
    end
    self.setPosition(pos)
end
function moveChildren()
    if rulers[1]~=nil then
        moveChild(self, 1)
    end
end
function drawButtons()
    self.clearButtons()
    local z = 0.17
    if #cmds<4 then
        self.createButton(buildButton('+',{click_function='Action_AddRuler',position={0.3,z,-1.8}}))
    end
    if #cmds>0 then
        self.createButton(buildButton('Clear',{click_function='Action_ClearRuler',position={0,z,-1.4},width=500,font_size=180}))
        self.createButton(buildButton('Move',{position={0,z,-1.0},width=500,font_size=180}))
        if last_pos~=nil and last_rot~=nil and last_moved~=nil then
            self.createButton(buildButton('Undo',{position={0,z,-0.6},width=500,font_size=180}))
        end
        self.createButton(buildButton('-',{click_function='Action_RemoveRuler',position={-0.3,z,-1.8}}))
    end
    local y = -2.4
    for i,cmd in ipairs(cmds) do
        if tonumber(cmd)>-2 then
            self.createButton(buildButton('<',{click_function='Action_RulerLeft'..i,position={-0.3,z,y},width=150}))
        end
        local clicks = "-"
        if math.abs(tonumber(cmd))==1 then clicks = "|" end
        if math.abs(tonumber(cmd))==2 then clicks = "||" end
        self.createButton(buildButton(clicks,{click_function=''..i,position={0,z,y},font_size=180}))
        if tonumber(cmd)<2 then
            self.createButton(buildButton('>',{click_function='Action_RulerRight'..i,position={0.3,z,y},width=150}))
        end
        y = y - 0.5
    end
end
function Action_RulerLeft1() RotateRuler(1,-1) end
function Action_RulerLeft2() RotateRuler(2,-1) end
function Action_RulerLeft3() RotateRuler(3,-1) end
function Action_RulerLeft4() RotateRuler(4,-1) end
function Action_RulerLeft5() RotateRuler(5,-1) end
function Action_RulerRight1() RotateRuler(1,1) end
function Action_RulerRight2() RotateRuler(2,1) end
function Action_RulerRight3() RotateRuler(3,1) end
function Action_RulerRight4() RotateRuler(4,1) end
function Action_RulerRight5() RotateRuler(5,1) end
last_pos = nil
last_rot = nil
last_moved = nil
function Action_Move()
    local ship = self.getVar('ship')
    if ship == nil then
        ship = findNearestShip(self.getPosition(),self.getRotation()[2])
    end
    printToAll("Moving: "..ship.getName(),{1,0,0})
    local offset = vector.sub(ship.getPosition(),self.getPosition())
    local lastRuler = rulers[#rulers]
    local yRot = lastRuler.getRotation()[2] - self.getRotation()[2]
    local rotatedOffset = vector.rotate(offset,yRot)
    storeUndo(ship)
    ship.setPosition(vector.add(lastRuler.getPosition(),rotatedOffset))
    ship.setRotation(vector.add(last_rot,{0,yRot,0}))
    drawButtons()
    moveTokens(ship,last_pos,last_rot)
end
button_pos = {{1.15,0.5,-1.95},
    {1.65,0.5,-2.85},
    {2.05,0.5,-3.6},
    {-1.15,0.5,1.95},
    {-1.65,0.5,2.85},
    {-2.05,0.5,3.6}}
function moveTokens(ship, old_pos, old_rot)
    for _,obj in ipairs(getAllObjects()) do
        if obj.tag~="Figurine" and not obj.getName():match "Asteroid" then
            local offset = vector.rotate(vector.sub(obj.getPosition(),old_pos),-old_rot[2])
            local size = button_pos[ship.getVar('size')]
            if math.abs(offset[1])<math.abs(size[1]) and math.abs(offset[3])<math.abs(size[3]) then
                -- WAS ON BASE
                local new_pos = vector.add(ship.getPosition(),vector.rotate(offset, ship.getRotation()[2]))
                local new_rot = vector.add(vector.sub(ship.getRotation(),old_rot),obj.getRotation())
                obj.setPosition(new_pos)
                obj.setRotation(new_rot)
            end
        end
    end
end
function storeUndo(ship)
    last_pos = ship.getPosition()
    last_rot = ship.getRotation()
    last_moved = ship
end
function Action_Undo()
    local prev_pos = last_moved.getPosition()
    local prev_rot = last_moved.getRotation()
    last_moved.setPosition(last_pos)
    last_moved.setRotation(last_rot)
    drawButtons()
    moveTokens(last_moved,prev_pos,prev_rot)
    last_moved = nil
    last_pos = nil
    last_rot = nil
end
function findNearestShip(pos,rot_filter)
    local nearest
    local minDist = 999999
    for i,ship in ipairs(getAllObjects()) do
        if isShip(ship) then
            local distance = distance(pos[1],pos[3],ship.getPosition()[1],ship.getPosition()[3])
            -- TODO: implement rotation filter (0 or 180)
            --angleDiff(ship.getRotation()[1],rot_filter)
            if distance<minDist and ship.getRotation() then
                minDist = distance
                nearest = ship
            end
        end
    end
    return nearest
end
function distance(x,y,a,b)
    x = (x-a)*(x-a)
    y = (y-b)*(y-b)
    return math.sqrt(math.abs((x+y)))
end
function isShip(ship)
    local name = ship.getName()
    return ship.tag == "Figurine" and (name:match " S$" or name:match " M$" or name:match " L$"
            or name:match " SR$" or name:match " MR$" or name:match " LR$")
end
function RotateRuler(i, direction)
    cmds[i] = math.clamp(cmds[i]+direction,-2,2)
    buildRuler(cmds)
end
function Action_AddRuler()
    table.insert(cmds,"0")
    buildRuler(cmds)
end
function Action_RemoveRuler()
    table.remove(cmds)
    buildRuler(cmds)
end
function Action_ClearRuler()
    destroyRulers()
    drawButtons()
    self.setPosition({49,1,0})
    self.setRotation({0,0,0})
end
function buildButton(label, def)
    local DEFAULT_POSITION = {0,0.17,0}
    local DEFAULT_ROTATION = {0,0,0}
    --local DEFAULT_WIDTH_PER_CHAR = 125
    local DEFAULT_HEIGHT = 200
    local DEFAULT_WIDTH = 200
    local DEFAULT_FONT_SIZE = 250
    if def.position==nil then def.position = DEFAULT_POSITION end
    if def.rotation==nil then def.rotation = DEFAULT_ROTATION end
    --if def.width==nil then def.width = 100 + string.len(label)*DEFAULT_WIDTH_PER_CHAR end
    if def.width==nil then def.width = DEFAULT_WIDTH end
    if def.height==nil then def.height = DEFAULT_HEIGHT end
    if def.font_size==nil then def.font_size = DEFAULT_FONT_SIZE end
    if def.click_function==nil then def.click_function = 'Action_'..label end
    if def.function_owner==nil then def.function_owner = self end
    return {['click_function'] = def.click_function, ['function_owner'] = def.function_owner, ['label'] = label, ['position'] = def.position, ['rotation'] =  def.rotation, ['width'] = def.width, ['height'] = def.height, ['font_size'] = def.font_size}
end
function destroyRulers()
    for _,ruler in ipairs(rulers) do
        if ruler~=nil then
            ruler.destruct()
        end
    end
    rulers = {}
    cmds = {}
end
function isCmd(cmd)
    local dir = tonumber(cmd)
    return table.contains({-2,-1,0,1,2},dir)
end
ruler_diffuse = {
    'http://i.imgur.com/Y8LTHC2.png',
    'http://i.imgur.com/PbrGnQm.png',
    'http://i.imgur.com/rZPSomm.png',
    'http://i.imgur.com/WiZESBp.png'
}
end_diffuse = {
    'http://i.imgur.com/WH1KHQf.png',
    'http://i.imgur.com/ihm03Vm.png',
    'http://i.imgur.com/1q9uCVs.png',
    'http://i.imgur.com/eMbDz3j.png'
}
function extendSelf(this, index, new_cmds)
    local dir =  tonumber(new_cmds[1])
    table.remove(new_cmds, 1)
    local pos = this.getPosition()
    local rot = this.getRotation()[2]
    local offset = vector.scale({0,0,-5.1 },this.getScale())
    local rotated_offset = vector.rotate(offset,rot)
    local obj_parameters = {}
    obj_parameters.type = 'Custom_Token'
    obj_parameters.position = vector.add(pos, rotated_offset)
    local new_rot = dir * 22.5
    obj_parameters.rotation = {0,rot+new_rot,0 }
    local newruler = spawnObject(obj_parameters)
    local custom = {}
    if index==#cmds then
        custom.image = end_diffuse[index]
    else
        custom.image = ruler_diffuse[index]
    end
    custom.thickness = 0.3
    custom.merge_distance = 5
    newruler.setCustomObject(custom)
    newruler.lock()
    newruler.scale(this.getScale())
    rulers[index] = newruler
    if #new_cmds>0 then
        extendSelf(newruler, index+1, new_cmds)
    end
end
function moveChild(this, index)
    local dir =  tonumber(cmds[index])
    local pos = this.getPosition()
    if pos[2]>2 then
        pos = {pos[1],2,pos[3]}
    end
    local rot = this.getRotation()[2]
    local offset = vector.scale({0,0,-5.1 },this.getScale())
    local rotated_offset = vector.rotate(offset,rot)
    local child = rulers[index]
    child.setPosition(vector.add(pos, rotated_offset))
    local new_rot = dir * 22.5
    child.setRotation({0,rot+new_rot,0 })
    if cmds[index+1]~=nil then
        moveChild(child, index+1)
    end
end
vector = {}
function vector.add(pos, offset)
    return {pos[1] + offset[1],pos[2] + offset[2],pos[3] + offset[3]}
end
function vector.sub(pos, offset)
    return {pos[1] - offset[1],pos[2] - offset[2],pos[3] - offset[3]}
end
function vector.rotate(direction, yRotation)

    local rotval = math.round(yRotation)
    local radrotval = math.rad(rotval)
    local xDistance = math.cos(radrotval) * direction[1] + math.sin(radrotval) * direction[3]
    local zDistance = math.sin(radrotval) * direction[1] * -1 + math.cos(radrotval) * direction[3]
    return {xDistance, direction[2], zDistance}
end
function vector.scale(v,s)
    return {v[1] * s[1],v[2] * s[2],v[3] * s[3]}
end
function vector.tostring(v)
    return "{"..math.round(v[1],1)..","..math.round(v[2],1)..","..math.round(v[3],1).."}"
end
function math.clamp(val, lower, upper)
    assert(val and lower and upper, "sent nil value to clamp")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end
function math.mod(a,b)
    return a - math.floor(a/b)*b
end
function math.round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function math.round(num, idp)
    if num == nil then return nil end
    local mult = 10^(idp or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
end
function string:split(this,sSeparator, nMax, bRegexp)
    assert(sSeparator ~= '')
    assert(nMax == nil or nMax >= 1)

    local aRecord = {}

    if this:len() > 0 then
        local bPlain = not bRegexp
        nMax = nMax or -1

        local nField, nStart = 1, 1
        local nFirst,nLast = this:find(sSeparator, nStart, bPlain)
        while nFirst and nMax ~= 0 do
            aRecord[nField] = this:sub(nStart, nFirst-1)
            nField = nField+1
            nStart = nLast+1
            nFirst,nLast = this:find(sSeparator, nStart, bPlain)
            nMax = nMax-1
        end
        aRecord[nField] = this:sub(nStart)
    end

    return aRecord
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
function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
    copy = orig
    end
    return copy
end