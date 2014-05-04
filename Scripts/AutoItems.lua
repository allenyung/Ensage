require("libs.Utils")
BsleepTick = nil

-- Setting
-- Enable Abuse Bottle?
funcbottle = true
-- Enable Auto Phase Boots?
funcphaseboots = true
-- Enable Auto Linken's Sphere?
funclsphere = true

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
	local lsphere = me:FindItem("item_sphere")
	
	if not bottle and not phaseboots and not lsphere then
		return
	end
	
	if not funcbottle and not funcphaseboots and not funclsphere then
		return
	end
	
	if  funcbottle and bottle and not me.invisible and not me:IsChanneling() and me:DoesHaveModifier("modifier_fountain_aura_buff") and not me:DoesHaveModifier("modifier_bottle_regeneration") then
		me:SafeCastItem("item_bottle")
	end
	
	if funcphaseboots and phaseboots and me.alive == true and phaseboots.state == -1 and me.unitState ~= 33554432 and me.unitState ~= 256 and me.unitState ~= 33554688 then
		me:SafeCastItem("item_phase_boots")
	end
	
	if funclsphere and lsphere and me.alive == true and lsphere.state == -1 and me.unitState ~= 33554432 and me.unitState ~= 256 and me.unitState ~= 33554688 then
		me:SafeCastItem("item_sphere",me)
	end
	
	BsleepTick = tick + 500
	return
end
script:RegisterEvent(EVENT_TICK,BTick)
