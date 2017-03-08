if myHero.charName ~= "Rengar" then return end

class "RengoUnchained"
require("DamageLib")

function OnLoad() RengoUnchained() end


class "RengoUnchained"

function RengoUnchained:__init()
    Q = {range = myHero:GetSpellData(_Q).range, delay = myHero:GetSpellData(_Q).delay, speed = myHero:GetSpellData(_Q).speed, width = myHero:GetSpellData(_Q).width}
    W = {range = myHero:GetSpellData(_W).range, delay = myHero:GetSpellData(_W).delay, speed = myHero:GetSpellData(_W).speed, width = myHero:GetSpellData(_W).width}
    E = {range = myHero:GetSpellData(_E).range, delay = myHero:GetSpellData(_E).delay, speed = myHero:GetSpellData(_E).speed, width = myHero:GetSpellData(_E).width}

    self:Menu()
    Callback.Add("Tick", function() self:Tick() end)
end


function RengoUnchained:Menu()
    self.Menu = MenuElement({type = MENU, name = "RengoUnchained", id = "RengoUnchained"})

    self.Menu:MenuElement({type = MENU, id ="Combo", name = "Combo Settings"})
    self.Menu.Combo:MenuElement({id = "Q", name ="Use Q", value = true})
    self.Menu.Combo:MenuElement({id = "W", name ="Use W", value = true})
    self.Menu.Combo:MenuElement({id = "E", name ="Use E", value = true})
end

function RengoUnchained:Tick()
    if not myHero.dead  then
        local target = _G.SDK.TargetSelector:GetTarget(1.2*E.range)
        if target and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then   
            self:Combo(target)
        end        
    end
end

function RengoUnchained:Combo(target)
    if not Utility:HasBuff(myHero, "RengarR") and myHero.mana < 4 then
        if myHero.pos:DistanceTo(target.pos) < Q.range and Utility:IsReady(_Q) and self.Menu.Combo.Q:Value() then
            local Epos = target:GetPrediction(Q.speed, Q.delay)
            if Epos and myHero.pos:DistanceTo(Epos) < Q.range then
                Control.CastSpell(HK_Q, Epos)
            end
        end
        if myHero.pos:DistanceTo(target.pos) < 1.1*E.range and Utility:IsReady(_E) and target:GetCollision(E.width,E.speed,E.delay) == 0 and self.Menu.Combo.E:Value() then
            local Epos = target:GetPrediction(E.speed, E.delay)
            if Epos and myHero.pos:DistanceTo(Epos) < E.range then
                Control.CastSpell(HK_E, Epos)
            end
        end
        if myHero.pos:DistanceTo(target.pos) < 0.9*W.range and Utility:IsReady(_W) and self.Menu.Combo.W:Value() then
            Control.CastSpell(HK_W)
        end      
    end
	if not Utility:HasBuff(myHero, "RengarR") and myHero.mana == 4 then
		if myHero.pos:DistanceTo(target.pos) < Q.range  and Utility:IsReady(_Q) and self.Menu.Combo.Q:Value() then
            local Epos = target:GetPrediction(Q.speed, Q.delay)
            if Epos and myHero.pos:DistanceTo(Epos) < Q.range then
                Control.CastSpell(HK_Q, Epos)
            end
        end
        if myHero.pos:DistanceTo(target.pos) < 1.1*E.range and myHero.pos:DistanceTo(target.pos) > Q.range and Utility:IsReady(_E) and target:GetCollision(E.width,E.speed,E.delay) == 0 and self.Menu.Combo.E:Value() then
            local Epos = target:GetPrediction(E.Speed, E.delay)
            if Epos and myHero.pos:DistanceTo(Epos) < E.range then
                Control.CastSpell(HK_E, Epos)
            end
        end
	end
end

--Utility (Credit to Tristana)
class "Utility"

function Utility:__init()
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
