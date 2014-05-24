require("libs.Utils")
local BsleepTick = nil

-- Setting
-- Enable Abuse Bottle?
local funcbottle = true
-- Enable Auto Phase Boots?
local funcphaseboots = true

function BTick( tick )
	if not client.connected or client.loading or client.console then
			return
	end
	
	if BsleepTick and BsleepTick > tick then
		return
	end
	
	local me = entityList:GetMyHero()
	if not me then
		return
	end
	
	local bottle = me:FindItem("item_bottle")
	local phaseboots = me:FindItem("item_phase_boots")
	local DruidBear = entityList:FindEntities({classId=CDOTA_Unit_SpiritBear,controllable=true,alive=true,visible=true})
	local Meepos = entityList:FindEntities({classId=TYPE_HERO,controllable=true,alive=true,visible=true,illusion=true})
	
	if not bottle and not phaseboots and #DruidBear == 0 then
		return
	end
	
	if not funcbottle and not funcphaseboots then
		return
	end
	
	if  funcbottle and bottle and not me.invisible and not me:IsChanneling() and me:DoesHaveModifier("modifier_fountain_aura_buff") and not me:DoesHaveModifier("modifier_bottle_regeneration") then
		me:SafeCastItem("item_bottle")
	end
	
	if funcphaseboots and phaseboots and me.alive == true and phaseboots.state == -1 and me.unitState ~= 33554432 and me.unitState ~= 256 and me.unitState ~= 33554688 then
		me:SafeCastItem("item_phase_boots")
	end
	
	if #DruidBear > 0 then
		for _,v in ipairs(DruidBear) do
			if v.controllable and v.unitState ~= -1031241196 then
				local duingoboots = v:FindItem("item_phase_boots")
				if duingoboots and duingoboots.state == -1 then
					v:SafeCastItem("item_phase_boots")
				end
			end
		end
	end
	
	if #Meepos > 0 then
		for _,v in ipairs(Meepos) do
			if v.controllable and v.unitState ~= -1031241196 then
				local meepoboots = v:FindItem("item_phase_boots")
				if meepoboots and meepoboots.state == -1 then
					v:SafeCastItem("item_phase_boots")
				end
			end
		end
	end
	
	BsleepTick = tick + 500
	return
end
script:RegisterEvent(EVENT_TICK,BTick)
