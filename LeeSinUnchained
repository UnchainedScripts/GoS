if myHero.charName ~= "LeeSin" then PrintChat("Not right") return end

class "LeeSinUnchained"
require("DamageLib")
require 'MapPositionGOS'

function OnLoad() LeeSinUnchained() end

--insect Variables
local originalPos = nil
local wardPos = nil
local wardEst = nil
local itemUsed = nil
local timeHolder = 0

local wardJumpPos = nil
local itemUsed2 = nil
local jumpComplete = false

function LeeSinUnchained:__init()
    Q = {range = myHero:GetSpellData(_Q).range, delay = myHero:GetSpellData(_Q).delay, speed = myHero:GetSpellData(_Q).speed, width = myHero:GetSpellData(_Q).width}
    W = {range = myHero:GetSpellData(_W).range, delay = myHero:GetSpellData(_W).delay, speed = myHero:GetSpellData(_W).speed, width = myHero:GetSpellData(_W).width}
    E = {range = myHero:GetSpellData(_E).range, delay = myHero:GetSpellData(_E).delay, speed = myHero:GetSpellData(_E).speed, width = myHero:GetSpellData(_E).width}
    R = {range = myHero:GetSpellData(_R).range, delay = myHero:GetSpellData(_R).delay, speed = myHero:GetSpellData(_R).speed, width = myHero:GetSpellData(_R).width}
    self:Menu()
    Callback.Add("Tick", function() self:Tick() end)
end

function LeeSinUnchained:Menu()
    self.Menu = MenuElement({type = MENU, name = "LeeSinUnchained", id = "LeeSinUnchained"})

    self.Menu:MenuElement({type = MENU, id ="Combo", name = "Combo Settings"})
    self.Menu.Combo:MenuElement({id = "Q", name ="Use Q", value = true})
    self.Menu.Combo:MenuElement({id = "Q2", name ="Use Q2", value = true})
    self.Menu.Combo:MenuElement({id = "W", name ="Use W", value = false})
    self.Menu.Combo:MenuElement({id = "E", name ="Use E", value = true})
    --self.Menu.Combo:MenuElement({id = "R", name ="Use R", value = true})
    --self.Menu.Combo:MenuElement({id = "Star", name ="Star Combo", value = false, key = 72, toggle = true})
    --self.Menu.Combo:MenuElement({id = "REnemies", name ="Enemies for R", value = 2, min = 0, max = 5, step = 1})

    self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
    self.Menu.Harass:MenuElement({id = "Q", name ="Use Q", value = true})
    self.Menu.Harass:MenuElement({id = "Q2", name ="Use Q2", value = true})
    self.Menu.Harass:MenuElement({id = "E", name ="Use E", value = true})

    self.Menu:MenuElement({type = MENU, id = "Misc", name = "Misc. Settings"})
    self.Menu.Misc:MenuElement({id = "WardJump", name = "Ward Jump", key = 72})
    self.Menu.Misc:MenuElement({id = "Insect", name = "Insect", key = 72})
    
end

function LeeSinUnchained:Tick()
    if not myHero.dead  then
        local target = _G.SDK.TargetSelector:GetTarget(1.5*Q.range)
        self:InsectResetCheck()

        if self.Menu.Misc.WardJump:Value() then
            if(Utility:IsReady(_W)) then
                self:WardJump()
            end
        end

        if target and self.Menu.Misc.Insect:Value() then
            self:Insect(target)
        end

        if target  and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then   
            self:Combo(target)
        end 

        if target and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
            self:Harass(target)
        end 
    end
end

function LeeSinUnchained:Combo(target)
    if not Utility:IsImmune(target) then
        self:StandardCombo(target)   
    end
end

function LeeSinUnchained:StandardCombo(target)

    if myHero.pos:DistanceTo(target.pos) < 1.1*Q.range and Utility:IsReady(_Q) and target:GetCollision(Q.width,Q.speed,Q.delay) == 0 and self.Menu.Combo.Q:Value() and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
        local Epos = target:GetPrediction(Q.speed, Q.delay)
        if Epos and myHero.pos:DistanceTo(Epos) < Q.range then
            Control.CastSpell(HK_Q, Epos)
        end
    end
    
    if self.Menu.Combo.Q2:Value() and Utility:HasBuff(target, "BlindMonkQOne") then
        Control.CastSpell(HK_Q)
    end

    if myHero.pos:DistanceTo(target.pos) < E.range-50 and Utility:IsReady(_E) and self.Menu.Combo.E:Value() and not Utility:HasBuff(myHero, "blindmonkpassive_cosmetic") then
        Control.CastSpell(HK_E)
    end

    if Utility:IsReady(_W) and self.Menu.Combo.W:Value() and not Utility:HasBuff(myHero, "blindmonkpassive_cosmetic") and Utility:GetPercentHP(myHero) <= 35 then
        Control.CastSpell(HK_W, myHero)
    end
    
end

function LeeSinUnchained:Harass(target)
    if myHero.pos:DistanceTo(target.pos) < 1.1*Q.range and Utility:IsReady(_Q) and target:GetCollision(Q.width,Q.speed,Q.delay) == 0 and self.Menu.Harass.Q:Value() and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
        local Epos = target:GetPrediction(Q.speed, Q.delay)
        if Epos and myHero.pos:DistanceTo(Epos) < Q.range then
            Control.CastSpell(HK_Q, Epos)
        end
    end
    
    if self.Menu.Harass.Q2:Value() and Utility:HasBuff(target, "BlindMonkQOne") then
        Control.CastSpell(HK_Q)
    end

    if myHero.pos:DistanceTo(target.pos) < E.range-50 and Utility:IsReady(_E) and self.Menu.Harass.E:Value() and not Utility:HasBuff(myHero, "blindmonkpassive_cosmetic") then
        Control.CastSpell(HK_E)
    end
end

function LeeSinUnchained:Insect(target)
    if(Utility:IsReady(_R)) then
        if(myHero.pos:DistanceTo(target.pos) >= R.range) then
            originalPos = myHero.pos
            if(target:GetCollision(Q.width,Q.speed,Q.delay) == 0 and myHero.pos:DistanceTo(target:GetPrediction(Q.speed,Q.delay)) <= Q.range and Utility:IsReady(_Q)) then
                local ePos = target:GetPrediction(Q.speed,Q.delay)
                Control.CastSpell(HK_Q,ePos)
            end
             if(myHero.pos:DistanceTo(target.pos) <= 1.2*Q.range and Utility:IsReady(_Q) and Utility:HasBuff(target, "BlindMonkQOne")) then
                Control.CastSpell(HK_Q)
            end
        else
            if(wardEst == nil) then
                wardEst = self:InsectCheck(target)
                timeHolder = Game.Timer()
            end

            if(itemUsed == nil) then
                itemUsed = self:WardItems()
            end

            if(wardEst ~= nil and itemUsed ~= nil and Utility:IsReady(_W) and not myHero.isChanneling) then
                Control.SetCursorPos(wardEst)
                Control.CastSpell(itemUsed,wardEst)
            end

            if(wardEst ~= nil and itemUsed ~= nil and self:WardCdChecker(itemUsed) > 0) then
                Control.SetCursorPos(wardEst)
                Control.CastSpell(HK_W,wardEst)
            end

            if(wardEst ~= nil and itemUsed ~= nil and not Utility:IsReady(_W)) then
                Control.CastSpell(HK_R,target)
            end
        end
    end
end

function LeeSinUnchained:WardItems() 
    local wardingTotem = 3340
	local sightStone = 2049
	local rubySightStone = 2045
	local trackersKnife = 3711
	local warrior = 1408
	local cinderhulk = 1409
	local bloodrazor = 1418
	local runicEchos = 1410
    local controlWard = 2055

    local wardingItems = {}
    wardingItems[1] = {3340,2045,3711,1408,1409,1418,1420,2055,2049}
    wardingItems[2] = {0,0,0,0,0,0,0,0,0}
    
    for i=1, #wardingItems[1] do
        for item = ITEM_1, ITEM_6 do
            if i ~= 9 and myHero:GetItemData(item).itemID == wardingItems[1][i] and myHero:GetItemData(item).ammo > 0 then
                wardingItems[2][i] = self:WardStringToObject("HK_ITEM_"..item-5)
            end
            if i == 9 and myHero:GetItemData(item).itemID == 2055 and myHero:GetItemData(item).stacks > 0 then
                wardingItems[2][i] = self:WardStringToObject("HK_ITEM_"..item-5)
            end
        end
    end
    if myHero:GetSpellData(ITEM_7).ammo > 0 then
        wardingItems[2][1] = HK_ITEM_7
    end

    for i=1, #wardingItems[1] do
        if wardingItems[2][i] ~= 0 then
            return wardingItems[2][i]
        end
    end  
    return nil
end

function LeeSinUnchained:WardStringToObject(value)
    if(value == "HK_ITEM_1") then
        return 49
    end
    if(value == "HK_ITEM_2") then
        return HK_ITEM_2
    end
    if(value == "HK_ITEM_3") then
        return HK_ITEM_3
    end
    if(value == "HK_ITEM_4") then
        return HK_ITEM_4
    end
    if(value == "HK_ITEM_5") then
        return HK_ITEM_5
    end
    if(value == "HK_ITEM_6") then
        return HK_ITEM_6
    end
    return 0
end

function LeeSinUnchained:WardCdChecker(value)
    if(value == 49) then
        return myHero:GetSpellData(6).currentCd
    end
    if(value == HK_ITEM_2) then
        return myHero:GetSpellData(7).currentCd
    end
    if(value == HK_ITEM_3) then
        return myHero:GetSpellData(8).currentCd
    end
    if(value == HK_ITEM_4) then
        return myHero:GetSpellData(9).currentCd
    end
    if(value == HK_ITEM_5) then
        return myHero:GetSpellData(10).currentCd
    end
    if(value == HK_ITEM_6) then
        return myHero:GetSpellData(11).currentCd
    end
    if(value == HK_ITEM_7) then
        return myHero:GetSpellData(ITEM_7).currentCd
    end
    if value == false then
        return  0
    end
end

function LeeSinUnchained:FlashCheck()
    if myHero:GetSpellData(4).name == "SummonerFlash" and myHero:GetSpellData(4).currentCd == 0 then
        return "HK_SUMMONER_1"
    elseif myHero:GetSpellData(5).name == "SummonerFlash" and myHero:GetSpellData(5).currentCd == 0 then
        return "HK_SUMMONER_2"
    else  
        return false
    end
end

function LeeSinUnchained:InsectCheck(target)
    local closestHeroDistance = math.huge
    local closestHero = nil
    local closestTurretDistance = math.huge
    local closestTurret = nil

    for i = 1, #Utility:GetAllyHeroes() do
        local temp = myHero.pos:DistanceTo(Utility:GetAllyHeroes()[i].pos)
        if (temp < 1000 and temp < closestHeroDistance) then
            closestHeroDistance = temp
            closestHero = Utility:GetAllyHeroes()[i]
        end
    end

    for i = 1, Game.TurretCount() do
        local temp = myHero.pos:DistanceTo(Game.Turret(i).pos)
        if Game.Turret(i).isAlly == true and temp < 1000 and temp < closestTurretDistance and Game.Turret(i).health > 0 then
            closestTurretDistance = temp
            closestTurret = Game.Turret(i)
        end
    end

    if(closestHero == nil and closestTurret == nil) then
        local tempPos = myHero.pos:DistanceTo(target.pos) + R.range - 100      
        wardPos = myHero.pos:Extended(target.pos, tempPos)
    elseif(closestTurret == nil) then
        local tempPos = closestHero.pos:DistanceTo(target.pos) + R.range - 100
        wardPos = closestHero.pos:Extended(target.pos, tempPos)
    else
        local tempPos = closestTurret.pos:DistanceTo(target.pos) + R.range - 100
        wardPos = closestTurret.pos:Extended(target.pos, tempPos)
    end

    if not MapPosition:inWall(wardPos) then
        return wardPos
    else
        PrintChat("In Wall!")
        return nil
    end
end

function LeeSinUnchained:InsectResetCheck()
    if(myHero.activeSpellSlot == 3) then
        wardEst = nil
        itemUsed = nil
    end

    if(timeHolder + 1.2 - Game.Timer() < 0) then
        wardEst = nil
        itemUsed = nil
    end

    if(myHero.activeSpellSlot == 1) then
        wardJumpPos = nil
        itemUsed2 = nil
    end
end

function LeeSinUnchained:WardJump()
    if(wardJumpPos == nil) then
        if(not MapPosition:inWall(mousePos)) then
            wardJumpPos = mousePos
        end
    end

    if(itemUsed2 == nil) then
        itemUsed2 = self:WardItems()
    end

    if(wardJumpPos ~= nil and itemUsed2 ~= nil and Utility:IsReady(_W) and not myHero.isChanneling) then
        Control.SetCursorPos(wardJumpPos)
        Control.CastSpell(itemUsed2,wardJumpPos)
    end

    if(wardJumpPos ~= nil and itemUsed2 ~= nil and self:WardCdChecker(itemUsed2) > 0) then
        Control.SetCursorPos(wardJumpPos)
        Control.CastSpell(HK_W,wardJumpPos)
    end
end

class "Utility"

function Utility:__init()
end

function Utility:Mode()
    if Orbwalker["Combo"].__active then
        return "Combo"
    elseif Orbwalker["Harass"].__active then
        return "Harass"
    elseif Orbwalker["Farm"].__active then
        return "Farm"
    elseif Orbwalker["LastHit"].__active then
        return "LastHit"
    end
    return ""
end

function Utility:GetPercentHP(unit)
	return 100 * unit.health / unit.maxHealth
end

function Utility:GetPercentMP(unit)
	return 100 * unit.mana / unit.maxMana
end

function Utility:GetEnemyHeroes()
	self.EnemyHeroes = {}
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isEnemy then
			table.insert(self.EnemyHeroes, Hero)
		end
	end
	return self.EnemyHeroes
end

function Utility:GetAllyHeroes()
	self.AllyHeroes = {}
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isAlly and not Hero.isMe then
			table.insert(self.AllyHeroes, Hero)
		end
	end
	return self.AllyHeroes
end

function Utility:GetBuffs(unit)
	self.T = {}
	for i = 0, unit.buffCount do
		local Buff = unit:GetBuff(i)
		if Buff.count > 0 then
			table.insert(self.T, Buff)
		end
	end
	return self.T
end

function Utility:HasBuff(unit, buffname)
	for K, Buff in pairs(self:GetBuffs(unit)) do
		if Buff.name:lower() == buffname:lower() then
			return true
		end
	end
	return false
end

function Utility:GetBuffData(unit, buffname)
	for i = 0, unit.buffCount do
		local Buff = unit:GetBuff(i)
		if Buff.name:lower() == buffname:lower() and Buff.count > 0 then
			return Buff
		end
	end
	return {type = 0, name = "", startTime = 0, expireTime = 0, duration = 0, stacks = 0, count = 0}
end

function Utility:IsImmune(unit)
	for K, Buff in pairs(self:GetBuffs(unit)) do
		if (Buff.name == "kindredrnodeathbuff" or Buff.name == "undyingrage") and self:GetPercentHP(unit) <= 10 then
			return true
		end
		if Buff.name == "vladimirsanguinepool" or Buff.name == "judicatorintervention" then 
            return true
        end
	end
	return false
end

function Utility:IsValidTarget(unit, range, checkTeam, from)
    local range = range == nil and math.huge or range
    if type(range) ~= "number" then error("{IsValidTarget}: bad argument #2 (number expected, got "..type(range)..")") end
    if type(checkTeam) ~= "nil" and type(checkTeam) ~= "boolean" then error("{IsValidTarget}: bad argument #3 (boolean or nil expected, got "..type(checkTeam)..")") end
    if type(from) ~= "nil" and type(from) ~= "userdata" then error("{IsValidTarget}: bad argument #4 (vector or nil expected, got "..type(from)..")") end
    if unit == nil or not unit.valid or not unit.visible or unit.dead or not unit.isTargetable or Utility:IsImmune(unit) or (checkTeam and unit.isAlly) then 
    return false 
  end 
  return unit.pos:DistanceTo(from and from or myHero) < range 
end

function Utility:IsReady(slot)
	if Game.CanUseSpell(slot) == 0 then
		return true
	end
	return false
end


Utility()
