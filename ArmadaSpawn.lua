function update()
    for _,card in ipairs(getAllObjects()) do
        if card.tag == 'Card' then
            local cmd = card.getDescription()
            local oldName = card.getVar('oldName')
            card.setVar('oldName',card.getName())
            if cmd:starts "spawn" then
                if oldName ~= card.getName() then
                    card.setName(oldName)
                end
                local count = tonumber(cmd:match "spawn%s(.*)")
                if count == nil then count = 1 end
                printToAll("Spawn ship '"..card.getName().."'",{0,1,1})
                spawnShip(card.getName(),card.getPosition(),count)
                card.setDescription("")
                --card.lock()
            end
        end
    end
end
SmallShip = {
    collider = "http://paste.ee/r/eDbf1",
    convex = true,
    type = 1,
    material = 3,
    maneuver = {}
}
function SmallShip:new (o)
    o = o or {}
    setmetatable(o, SmallShip)
    SmallShip.__index = SmallShip
    return o
end
MediumShip = {
    collider = "http://paste.ee/r/6LYTT",
    convex = true,
    type = 1,
    material = 3,
    maneuver = {}
}
function MediumShip:new (o)
    o = o or {}
    setmetatable(o, MediumShip)
    MediumShip.__index = MediumShip
    return o
end
LargeShip = {
    collider = "http://paste.ee/r/a7mfW",
    convex = true,
    type = 1,
    material = 3,
    maneuver = {}
}
function LargeShip:new (o)
    o = o or {}
    setmetatable(o, LargeShip)
    LargeShip.__index = LargeShip
    return o
end
Squadron = {
    collider = "http://paste.ee/r/nAMCQ",
    convex = false,
    type = 1,
    material = 1
}
function Squadron:new (o)
    o = o or {}
    setmetatable(o, Squadron)
    Squadron.__index = Squadron
    return o
end

SHIPS = {}
function onload()
    SHIPS["GR-75 Medium Transports"] = SmallShip:new{
        mesh = "http://paste.ee/r/b9fTk",
        diffuse = "http://i.imgur.com/2A2pAEI.png",
        ruler = "http://paste.ee/r/FSip2",
        maneuver = {{"II"},{"I","II"},{"-","I","II"}}
    }
    SHIPS["GR-75 Combat Retrofits"] = SmallShip:new{
        mesh = "http://paste.ee/r/b9fTk",
        diffuse = "http://i.imgur.com/dO7rAWL.png",
        ruler = "http://paste.ee/r/FSip2",
        maneuver = {{"II"},{"I","II"},{"-","I","II"}}
    }
    SHIPS["CR90 Corvette A"] = SmallShip:new{
        mesh = "http://paste.ee/r/ciL22",
        diffuse = "http://i.imgur.com/0kAY3h2.png",
        ruler = "http://paste.ee/r/H13ZL",
        maneuver = {{"II"},{"I","II"},{"-","I","II"},{"-","I","I","II"}}
    }
    SHIPS["CR90 Corvette B"] = SmallShip:new{
        mesh = "http://paste.ee/r/ciL22",
        diffuse = "http://i.imgur.com/k7I0BOQ.png",
        ruler = "http://paste.ee/r/H13ZL",
        maneuver = {{"II"},{"I","II"},{"-","I","II"},{"-","I","I","II"}}
    }
    SHIPS["Nebulon-B Support Refit"] = SmallShip:new{
        mesh = "http://paste.ee/r/5jlFC",
        diffuse = "http://i.imgur.com/4LZROT5.png",
        ruler = "http://paste.ee/r/xI908",
        maneuver = {{"II"},{"I","I"},{"-","I","II"}}
    }
    SHIPS["Nebulon-B Escort Frigate"] = SmallShip:new{
        mesh = "http://paste.ee/r/5jlFC",
        diffuse = "http://i.imgur.com/avcsD9I.png",
        ruler = "http://paste.ee/r/xI908",
        maneuver = {{"II"},{"I","I"},{"-","I","II"}}
    }
    SHIPS["MC30c Scout Frigate"] = SmallShip:new{
        mesh = "http://paste.ee/r/oErZc",
        diffuse = "http://i.imgur.com/u3vlpCP.png",
        ruler = "http://paste.ee/r/g71A1",
        maneuver = {{"I"},{"I","I"},{"-","I","II"},{"-","I","I","-"}}
    }
    SHIPS["MC30c Torpedo Frigate"] = SmallShip:new{
        mesh = "http://paste.ee/r/oErZc",
        diffuse = "http://i.imgur.com/ijQ9qP3.png",
        ruler = "http://paste.ee/r/g71A1",
        maneuver = {{"I"},{"I","I"},{"-","I","II"},{"-","I","I","-"}}
    }
    SHIPS["Modified Pelta-class Command Ship"] = SmallShip:new{
        mesh = "http://paste.ee/p/bBiGO",
        diffuse = "http://i.imgur.com/KIlZlxH.png",
        ruler = "http://paste.ee/p/RDjaZ",
        maneuver = {{"II"},{"I","I"}}
    }
    SHIPS["Modified Pelta-class Assault Ship"] = SmallShip:new{
        mesh = "http://paste.ee/p/bBiGO",
        diffuse = "http://i.imgur.com/erI0mWb.png",
        ruler = "http://paste.ee/p/RDjaZ",
        maneuver = {{"II"},{"I","I"}}
    }

    SHIPS["Hammerhead Scout Corvette"] = SmallShip:new{
        mesh = "https://paste.ee/p/1zKki",
        diffuse = "http://i.imgur.com/m9jyRy6.png",
        ruler = "https://paste.ee/p/DA9vu",
        maneuver = {{"II"},{"II","I"},{"I","I","-"}}
    }
    SHIPS["Hammerhead Torpedo Corvette"] = SmallShip:new{
        mesh = "https://paste.ee/p/1zKki",
        diffuse = "http://i.imgur.com/21escRb.png",
        ruler = "https://paste.ee/p/DA9vu",
        maneuver = {{"II"},{"II","I"},{"I","I","-"}}
    }

    SHIPS["Assault Frigate Mark II A"] = MediumShip:new{
        mesh = "http://paste.ee/r/ZdluE",
        diffuse = "http://i.imgur.com/5gcQx98.png",
        ruler = "http://paste.ee/r/kmnpd",
        maneuver = {{"I"},{"I","I"},{"-","I","I"}}
    }
    SHIPS["Assault Frigate Mark II B"] = MediumShip:new{
        mesh = "http://paste.ee/r/ZdluE",
        diffuse = "http://i.imgur.com/T1u6SU1.png",
        ruler = "http://paste.ee/r/kmnpd",
        maneuver = {{"I"},{"I","I"},{"-","I","I"}}
    }
    SHIPS["MC80 Command Cruiser"] = LargeShip:new{
        mesh = "http://paste.ee/r/am8JC",
        diffuse = "http://i.imgur.com/pW1iM1a.png",
        ruler = "http://paste.ee/r/YcTl3",
        maneuver = {{"I"},{"I","I"}}
    }
    SHIPS["MC80 Assault Cruiser"] = LargeShip:new{
        mesh = "http://paste.ee/r/am8JC",
        diffuse = "http://i.imgur.com/xklILcW.png",
        ruler = "http://paste.ee/r/YcTl3",
        maneuver = {{"I"},{"I","I"}}
    }
    SHIPS["MC80 Star Cruiser"] = LargeShip:new{
        mesh = "http://paste.ee/r/eEzbI",
        diffuse = "http://i.imgur.com/Cb3Nexq.png",
        ruler = "http://paste.ee/r/XjDg0",
        maneuver = {{"I"},{"I","-"},{"I","-","I"}}
    }
    SHIPS["MC80 Battle Cruiser"] = LargeShip:new{
        mesh = "http://paste.ee/r/eEzbI",
        diffuse = "http://i.imgur.com/DHGrZcJ.png",
        ruler = "http://paste.ee/r/XjDg0",
        maneuver = {{"I"},{"I","-"},{"I","-","I"}}
    }

    SHIPS["Gozanti-class Cruisers"] = SmallShip:new{
        mesh = "http://paste.ee/r/a4Qg8",
        diffuse = "http://i.imgur.com/98SoFSS.png",
        ruler = "http://paste.ee/r/jbTlM",
        maneuver = {{"II"},{"I","I"},{"I","I","-"}}
    }
    SHIPS["Gozanti-class Assault Carriers"] = SmallShip:new{
        mesh = "http://paste.ee/r/a4Qg8",
        diffuse = "http://i.imgur.com/US2K0XY.png",
        ruler = "http://paste.ee/r/jbTlM",
        maneuver = {{"II"},{"I","I"},{"I","I","-"}}
    }
    SHIPS["Raider I-class Corvette"] = SmallShip:new{
        mesh = "http://paste.ee/r/qsGM3",
        diffuse = "http://i.imgur.com/uO4qw7R.png",
        ruler = "http://paste.ee/r/JwnWk",
        maneuver = {{"II"},{"II","II"},{"-","I","I"},{"-","I","I","I"}}
    }
    SHIPS["Raider II-class Corvette"] = SmallShip:new{
        mesh = "http://paste.ee/r/qsGM3",
        diffuse = "http://i.imgur.com/9uZDh0o.png",
        ruler = "http://paste.ee/r/JwnWk",
        maneuver = {{"II"},{"II","II"},{"-","I","I"},{"-","I","I","I"}}
    }
    SHIPS["Gladiator I-class Star Destroyer"] = SmallShip:new{
        mesh = "http://paste.ee/r/8150f",
        diffuse = "http://i.imgur.com/CBFTsv3.png",
        ruler = "http://paste.ee/r/PnVAt",
        maneuver = {{"II"},{"I","I"},{"-","I","I"}}
    }
    SHIPS["Gladiator II-class Star Destroyer"] = SmallShip:new{
        mesh = "http://paste.ee/r/8150f",
        diffuse = "http://i.imgur.com/KFO7rmN.png",
        ruler = "http://paste.ee/r/PnVAt",
        maneuver = {{"II"},{"I","I"},{"-","I","I"}}
    }
    SHIPS["Arquitens-class Light Cruiser"] = SmallShip:new{
        mesh = "https://paste.ee/p/i5otm",
        diffuse = "http://i.imgur.com/QAy7MNw.png",
        ruler = "http://paste.ee/p/wZK5w",
        maneuver = {{"II"},{"-","II"},{"-","-","II"}}
    }
    SHIPS["Arquitens-class Command Cruiser"] = SmallShip:new{
        mesh = "https://paste.ee/p/i5otm",
        diffuse = "http://i.imgur.com/yxQ3F2V.png",
        ruler = "http://paste.ee/p/wZK5w",
        maneuver = {{"II"},{"-","II"},{"-","-","II"}}
        --maneuver = "II|-,II|-,-,II"
    }
    SHIPS["Victory I-class Star Destroyer"] = MediumShip:new{
        mesh = "http://paste.ee/r/pPCJ8",
        diffuse = "http://i.imgur.com/b7CDloK.png",
        ruler = "http://paste.ee/r/f1IHk",
        maneuver = {{"I"},{"-","I"}}
    }
    SHIPS["Victory II-class Star Destroyer"] = MediumShip:new{
        mesh = "http://paste.ee/r/pPCJ8",
        diffuse = "http://i.imgur.com/BB2Rflo.png",
        ruler = "http://paste.ee/r/f1IHk",
        maneuver = {{"I"},{"-","I"}}
    }
    SHIPS["Interdictor Suppression Refit"] = MediumShip:new{
        mesh = "http://paste.ee/r/roSj5",
        diffuse = "http://i.imgur.com/OMoTh9y.png",
        ruler = "http://paste.ee/r/cqUDP",
        maneuver = {{"I"},{"I","I"}}
    }
    SHIPS["Interdictor Combat Refit"] = MediumShip:new{
        mesh = "http://paste.ee/r/roSj5",
        diffuse = "http://i.imgur.com/0xIlJlb.png",
        ruler = "http://paste.ee/r/cqUDP",
        maneuver = {{"I"},{"I","I"}}
    }
    SHIPS["Quasar Fire I-class Cruiser-Carrier"] = MediumShip:new{
        mesh = "https://paste.ee/p/aoLPn",
        diffuse = "http://i.imgur.com/WyRNlCF.png",
        ruler = "https://paste.ee/p/wOQfL",
        maneuver = {{"II"},{"I","I"},{"-","I","I"}}
    }
    SHIPS["Quasar Fire II-class Cruiser-Carrier"] = MediumShip:new{
        mesh = "https://paste.ee/p/aoLPn",
        diffuse = "http://i.imgur.com/xfMXMUr.png",
        ruler = "https://paste.ee/p/wOQfL",
        maneuver = {{"II"},{"I","I"},{"-","I","I"}}
    }

    SHIPS["Imperial I-class Star Destroyer"] = LargeShip:new{
        mesh = "http://paste.ee/r/jrPtR",
        diffuse = "http://i.imgur.com/FrFBut6.png",
        ruler = "http://paste.ee/r/6SQoL",
        maneuver = {{"I"},{"I","I"},{"-","I","I"}}
    }
    SHIPS["Imperial II-class Star Destroyer"] = LargeShip:new{
        mesh = "http://paste.ee/r/jrPtR",
        diffuse = "http://i.imgur.com/usykAgi.png",
        ruler = "http://paste.ee/r/6SQoL",
        maneuver = {{"I"},{"I","I"},{"-","I","I"}}
    }


    local ship = {
        mesh = "http://paste.ee/r/ZqCC6",
        diffuse = "http://i.imgur.com/QSLaqgW.png",
        health = 5,
        move = 2 }
    SHIPS["B-wing Squadron"] = Squadron:new(ship)
    SHIPS["Keyan Farlander"] = Squadron:new(table.copy(ship))
    SHIPS["Keyan Farlander"].diffuse = "http://i.imgur.com/r7YB80F.png"
    SHIPS["Ten Numb"] = Squadron:new(table.copy(ship))
    SHIPS["Ten Numb"].diffuse = "http://i.imgur.com/r7YB80F.png"
    SHIPS["Dagger Squadron"] = Squadron:new(table.copy(ship))
    SHIPS["Dagger Squadron"].diffuse = "http://i.imgur.com/swXemsa.png"
    SHIPS["Dagger Squadron"].mesh = "http://paste.ee/p/NpCQt"
    ship = {
        mesh = "http://paste.ee/r/AG2g4",
        diffuse = "http://i.imgur.com/ObUEAK5.png",
        health = 6,
        move = 3 }
    SHIPS["Y-wing Squadron"] = Squadron:new(ship)
    SHIPS['"Dutch" Vander'] = Squadron:new(table.copy(ship))
    SHIPS['"Dutch" Vander'].diffuse = "http://i.imgur.com/pRu0c7d.png"
    SHIPS['Norra Wexley'] = Squadron:new(table.copy(ship))
    SHIPS['Norra Wexley'].diffuse = "http://i.imgur.com/pRu0c7d.png"
    SHIPS['Norra Wexley'].mesh = "http://paste.ee/p/5i0Ma"
    SHIPS['Gold Squadron'] = Squadron:new(table.copy(ship))
    SHIPS['Gold Squadron'].mesh = "http://paste.ee/p/5i0Ma"
    SHIPS['Gold Squadron'].diffuse = "http://i.imgur.com/pRu0c7d.png"
    ship = {
        mesh = "http://paste.ee/r/3Wdv8",
        diffuse = "http://i.imgur.com/6vlNuEY.png",
        health = 4,
        move = 5 }
    SHIPS["A-wing Squadron"] = Squadron:new(ship)
    SHIPS["Tycho Celchu"] = Squadron:new(table.copy(ship))
    SHIPS["Tycho Celchu"].diffuse = "http://i.imgur.com/QZPi4e7.png"
    SHIPS["Shara Bey"] = Squadron:new(table.copy(ship))
    SHIPS["Shara Bey"].diffuse = "http://i.imgur.com/QZPi4e7.png"
    SHIPS["Green Squadron"] = Squadron:new(table.copy(ship))
    SHIPS["Green Squadron"].mesh = "http://paste.ee/p/ybtPs"
    SHIPS["Green Squadron"].diffuse = "http://i.imgur.com/0awlEmY.png"
    ship = {
        mesh = "http://paste.ee/r/zjUF1",
        diffuse = "http://i.imgur.com/HHbQ8lf.png",
        health = 5,
        move = 3 }
    SHIPS["X-wing Squadron"] = Squadron:new(ship)
    SHIPS["Luke Skywalker"] = Squadron:new(table.copy(ship))
    SHIPS["Luke Skywalker"].diffuse = "http://i.imgur.com/6xKSmMQ.png"
    SHIPS["Wedge Antilles"] = Squadron:new(table.copy(ship))
    SHIPS["Wedge Antilles"].diffuse = "http://i.imgur.com/6xKSmMQ.png"
    SHIPS["Biggs Darklighter"] = Squadron:new(table.copy(ship))
    SHIPS["Biggs Darklighter"].diffuse = "http://i.imgur.com/6xKSmMQ.png"
    SHIPS["Rogue Squadron"] = Squadron:new(table.copy(ship))
    SHIPS["Rogue Squadron"].diffuse = "http://i.imgur.com/6xKSmMQ.png"
    SHIPS["Rogue Squadron"].mesh = "http://paste.ee/p/PsdOf"
    ship = {
        mesh = "http://paste.ee/r/919yT",
        diffuse = "http://i.imgur.com/P11kSne.png",
        health = 6,
        move = 4 }
    SHIPS["YT-2400"] = Squadron:new(ship)
    SHIPS["Dash Rendar"] = Squadron:new(table.copy(ship))
    SHIPS["Dash Rendar"].mesh = "http://paste.ee/r/V5oHI"
    SHIPS["Dash Rendar"].diffuse = "http://i.imgur.com/3iJ0Wxe.png"
    ship = {
        mesh = "http://paste.ee/r/hhbic",
        diffuse = "http://i.imgur.com/bndtRkF.png",
        health = 7,
        move = 2 }
    SHIPS["YT-1300"] = Squadron:new(ship)
    SHIPS["Han Solo"] = Squadron:new(table.copy(ship))
    SHIPS["Han Solo"].mesh = "http://paste.ee/r/6yDva"
    SHIPS["Han Solo"].diffuse = "http://i.imgur.com/v16flTU.png"
    SHIPS["Han Solo"].move = 3
    ship = {
        mesh = "http://paste.ee/r/DURQd",
        diffuse = "http://i.imgur.com/03TMKSR.png",
        health = 4,
        move = 3 }
    SHIPS["HWK-290"] = Squadron:new(ship)
    SHIPS["Jan Ors"] = Squadron:new(table.copy(ship))
    SHIPS["Jan Ors"].diffuse = "http://i.imgur.com/bnknApA.png"
    ship = {
        mesh = "http://paste.ee/r/dvrOX",
        diffuse = "http://i.imgur.com/4Stv3go.png",
        health = 6,
        move = 3 }
    SHIPS["Scurrg H-6 Bomber"] = Squadron:new(ship)
    SHIPS["Nym"] = Squadron:new(table.copy(ship))
    SHIPS["Nym"].mesh = "http://paste.ee/r/96QNu"
    SHIPS["Nym"].diffuse = "http://i.imgur.com/QAaYYfU.png"
    ship = {
        mesh = "http://paste.ee/p/ZHpHT",
        diffuse = "http://i.imgur.com/zYmUqph.png",
        health = 3,
        move = 3 }
    SHIPS["Z-95 Headhunter Squadron"] = Squadron:new(ship)
    SHIPS["Lieutenant Blount"] = Squadron:new(table.copy(ship))
    SHIPS["Lieutenant Blount"].diffuse = "http://i.imgur.com/aTuRbPL.png"
    ship = {
        mesh = "http://paste.ee/p/ElhHc",
        diffuse = "http://i.imgur.com/X9E1n2M.png",
        health = 5,
        move = 4 }
    SHIPS["E-wing Squadron"] = Squadron:new(ship)
    SHIPS["Corran Horn"] = Squadron:new(table.copy(ship))
    SHIPS["Corran Horn"].mesh = "http://paste.ee/p/r2fsB"
    SHIPS["Corran Horn"].diffuse = "http://i.imgur.com/3uSFKMb.png"
    ship = {
        mesh = "http://paste.ee/p/3QIXa",
        diffuse = "http://i.imgur.com/5UVGuIg.png",
        health = 8,
        move = 3 }
    SHIPS["VCX-100 Freighter"] = Squadron:new(ship)
    SHIPS["Hera Syndulla"] = Squadron:new(table.copy(ship))
    SHIPS["Hera Syndulla"].mesh = "http://paste.ee/p/3NpiT"
    SHIPS["Hera Syndulla"].diffuse = "http://i.imgur.com/wPzX0MW.png"
    ship = {
        mesh = "http://paste.ee/p/L9ygS",
        diffuse = "http://i.imgur.com/CZ3eF4M.png",
        health = 4,
        move = 4 }
    SHIPS["Lancer-class Pursuit Craft"] = Squadron:new(ship)
    SHIPS["Ketsu Onyo"] = Squadron:new(table.copy(ship))
    SHIPS["Ketsu Onyo"].diffuse = "http://i.imgur.com/eJxMrk2.png"



    ship = {
        mesh = "http://paste.ee/r/Z1d7z",
        diffuse = "http://i.imgur.com/iuWpy6O.png",
        health = 3,
        move = 4 }
    SHIPS["TIE Fighter Squadron"] = Squadron:new(ship)
    SHIPS['"Mauler" Mithel'] = Squadron:new(table.copy(ship))
    SHIPS['"Mauler" Mithel'].diffuse = "http://i.imgur.com/aKtLAbl.png"
    SHIPS['"Howlrunner"'] = Squadron:new(table.copy(ship))
    SHIPS['"Howlrunner"'].diffuse = "http://i.imgur.com/aKtLAbl.png"
    SHIPS['Valen Rudor'] = Squadron:new(table.copy(ship))
    SHIPS['Valen Rudor'].diffuse = "http://i.imgur.com/aKtLAbl.png"
    SHIPS['Black Squadron'] = Squadron:new(table.copy(ship))
    SHIPS['Black Squadron'].diffuse = "http://i.imgur.com/aKtLAbl.png"
    SHIPS['Black Squadron'].mesh = "http://paste.ee/p/z7soo"
    ship = {
        mesh = "http://paste.ee/r/tSt9Z",
        diffuse = "http://i.imgur.com/eonWxFU.png",
        health = 3,
        move = 5 }
    SHIPS["TIE Interceptor Squadron"] = Squadron:new(ship)
    SHIPS["Soontir Fel"] = Squadron:new(table.copy(ship))
    SHIPS["Soontir Fel"].diffuse = "http://i.imgur.com/19ksb4d.png"
    SHIPS["Ciena Ree"] = Squadron:new(table.copy(ship))
    SHIPS["Ciena Ree"].diffuse = "http://i.imgur.com/19ksb4d.png"
    SHIPS["Saber Squadron"] = Squadron:new(table.copy(ship))
    SHIPS["Saber Squadron"].diffuse = "http://i.imgur.com/19ksb4d.png"
    SHIPS["Saber Squadron"].mesh = "http://paste.ee/p/GqMPV"
    ship = {
        mesh = "http://paste.ee/r/QPs1M",
        diffuse = "http://i.imgur.com/L6U7Pca.png",
        health = 5,
        move = 4 }
    SHIPS["TIE Bomber Squadron"] = Squadron:new(ship)
    SHIPS["Major Rhymer"] = Squadron:new(table.copy(ship))
    SHIPS["Major Rhymer"].diffuse = "http://i.imgur.com/o9KJLV8.png"
    SHIPS["Captain Jonus"] = Squadron:new(table.copy(ship))
    SHIPS["Captain Jonus"].diffuse = "http://i.imgur.com/o9KJLV8.png"
    SHIPS["Captain Jonus"].mesh = "http://paste.ee/p/ekNwl"
    SHIPS["Gamma Squadron"] = Squadron:new(table.copy(ship))
    SHIPS["Gamma Squadron"].diffuse = "http://i.imgur.com/o9KJLV8.png"
    SHIPS["Gamma Squadron"].mesh = "http://paste.ee/p/cFgCe"
    ship = {
        mesh = "http://paste.ee/r/5YfqM",
        diffuse = "http://i.imgur.com/VDIMZqW.png",
        health = 5,
        move = 4 }
    SHIPS["TIE Advanced Squadron"] = Squadron:new(ship)
    SHIPS["Darth Vader"] = Squadron:new(table.copy(ship))
    SHIPS["Darth Vader"].diffuse = "http://i.imgur.com/YJm6aoS.png"
    SHIPS["Zertik Strom"] = Squadron:new(table.copy(ship))
    SHIPS["Zertik Strom"].diffuse = "http://i.imgur.com/YJm6aoS.png"
    SHIPS["Tempest Squadron"] = Squadron:new(table.copy(ship))
    SHIPS["Tempest Squadron"].diffuse = "http://i.imgur.com/YJm6aoS.png"
    SHIPS["Tempest Squadron"].mesh = "http://paste.ee/p/6Zar9"
    ship = {
        mesh = "http://paste.ee/r/SsZzy",
        diffuse = "http://i.imgur.com/xq6IPfk.png",
        health = 6,
        move = 3 }
    SHIPS["Firespray-31"] = Squadron:new(ship)
    SHIPS["Boba Fett"] = Squadron:new(table.copy(ship))
    SHIPS["Boba Fett"].diffuse = "http://i.imgur.com/rH8e7j0.png"
    ship = {
        mesh = "http://paste.ee/r/6kd8r",
        diffuse = "http://i.imgur.com/iEZieyE.png",
        health = 4,
        move = 4 }
    SHIPS["JumpMaster 5000"] = Squadron:new(ship)
    SHIPS["Dengar"] = Squadron:new(table.copy(ship))
    SHIPS["Dengar"].diffuse = "http://i.imgur.com/Y9MYLmc.png"
    ship = {
        mesh = "http://paste.ee/r/Kc5iy",
        diffuse = "http://i.imgur.com/FW8XU1X.png",
        health = 5,
        move = 3 }
    SHIPS["Aggressor Assault Fighter"] = Squadron:new(ship)
    SHIPS["IG-88"] = Squadron:new(table.copy(ship))
    SHIPS["IG-88"].diffuse = "http://i.imgur.com/eLOTz1a.png"
    SHIPS["IG-88"].move = 5
    ship = {
        mesh = "http://paste.ee/r/zRpzx",
        diffuse = "http://i.imgur.com/YU9FikV.png",
        health = 7,
        move = 2 }
    SHIPS["YV-666"] = Squadron:new(ship)
    SHIPS["Bossk"] = Squadron:new(table.copy(ship))
    SHIPS["Bossk"].mesh = "http://paste.ee/r/BX64Q"
    SHIPS["Bossk"].diffuse = "http://i.imgur.com/qGvYpdJ.png"
    SHIPS["Bossk"].move = 3
    ship = {
        mesh = "http://paste.ee/p/VogTD",
        diffuse = "http://i.imgur.com/lJBVPTD.png",
        health = 4,
        move = 4 }
    SHIPS['TIE Phantom Squadron'] = Squadron:new(ship)
    SHIPS['"Whisper"'] = Squadron:new(table.copy(ship))
    SHIPS['"Whisper"'].diffuse = "http://i.imgur.com/wKQfGQs.png"
    ship = {
        mesh = "http://paste.ee/p/4Nnjz",
        diffuse = "http://i.imgur.com/pXxfv23.png",
        health = 6,
        move = 5 }
    SHIPS['TIE Defender Squadron'] = Squadron:new(ship)
    SHIPS['Maarek Stele'] = Squadron:new(table.copy(ship))
    SHIPS['Maarek Stele'].mesh = "http://paste.ee/p/hQtGH"
    SHIPS['Maarek Stele'].diffuse = "http://i.imgur.com/2wkGtqX.png"
    ship = {
        mesh = "http://paste.ee/p/EriDZ",
        diffuse = "http://i.imgur.com/VE1qnP0.png",
        health = 6,
        move = 3 }
    SHIPS['Lambda-class Shuttle'] = Squadron:new(ship)
    SHIPS['Colonel Jendon'] = Squadron:new(table.copy(ship))
    SHIPS['Colonel Jendon'].mesh = "http://paste.ee/p/LJqy6"
    SHIPS['Colonel Jendon'].diffuse = "http://i.imgur.com/ku8uSvD.png"
    ship = {
        mesh = "http://paste.ee/p/2k8Qn",
        diffuse = "http://i.imgur.com/YQ501vt.png",
        health = 8,
        move = 3 }
    SHIPS['VT-49 Decimator'] = Squadron:new(ship)
    SHIPS['Morna Kee'] = Squadron:new(table.copy(ship))
    SHIPS['Morna Kee'].mesh = "http://paste.ee/p/5DPYJ"
    SHIPS['Morna Kee'].diffuse = "http://i.imgur.com/JHZ5Ig0.png"

    for _,ship in ipairs(getAllObjects()) do
        if ship.tag == 'Figurine' then
            for key,ship_def in pairs(SHIPS) do
                --printToAll("Checking Ship Def: "..key,{0,1,1})
                if ship_def.mesh == ship.getCustomObject().mesh then
                    ship.setVar("rulerMesh",ship_def.ruler)
                    --printToAll("set ruler for: "..ship_def.ruler,{0,1,1})
                end
            end
        end
    end
end
function spawnShip(name, pos,count)
    local ship_def = SHIPS[name]
    if ship_def~=nil then
    --for _,ship_def in ipairs(SHIPS) do
    --    if ship_def.name == name then
        if ship_def.health~=nil and ship_def.move~=nil then
            name = "("..ship_def.health.."/"..ship_def.health..") ["..ship_def.move.."] "..name
        end
        for i=1, count, 1 do
            local obj_parameters = {}
            obj_parameters.type = 'Custom_Model'
            obj_parameters.position = {pos[1],4+i,pos[3]}
            obj_parameters.rotation = {0,0,0 }
            local ship = spawnObject(obj_parameters)
            local custom = {}
            custom.mesh = ship_def.mesh
            custom.collider = ship_def.collider
            custom.diffuse = ship_def.diffuse
            custom.convex = ship_def.convex
            custom.type = ship_def.type
            custom.material = ship_def.material
            ship.setCustomObject(custom)

            ship.setName(name)
            ship.setVar("rulerMesh",ship_def.ruler)
            ship.setTable("maneuver",ship_def.maneuver)
        end
    --    end
    --end
    end
end
function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
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