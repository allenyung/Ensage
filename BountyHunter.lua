damage = {100,200,250,325}
range = 650
sleepTick = nil

-- Setting
-- % enemy hp for use track.
hpbarfortrack = 0.4
function Tick( tick )
	if not client.connected or client.loading or client.console or client.paused or  not entityList:GetMyHero() then 
		return 
	end
	
	me = entityList:GetMyHero()	
	if sleepTick and sleepTick > tick then
		return
	end

	if me.name ~= "npc_dota_hero_bounty_hunter" then
		script:Unload()
		return
	end
	
	local Shuriken = me:GetAbility(1)
	local Track = me:GetAbility(4)
	
	enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true})
	for i,v in ipairs(enemies) do
		if v.team ~= me.team and GetDistance2D(me,v) <= 1300 then
			local distance = GetDistance2D(me,v)
			local CheckTrack = v:DoesHaveModifier("modifier_bounty_hunter_track")
			local CheckInvis = me:DoesHaveModifier("modifier_bounty_hunter_wind_walk")
			if InvisibleHeroes(v) and CheckSpells(Track) and not CheckTrack and not CheckInvis and v.health > 0 and distance <= 1200 then
				me:SafeCastAbility(Track,v)
				sleepTick = tick + 500
				return
			end		
			
			if CheckSpells(Track) and not CheckTrack and not CheckInvis and v.health > 0 and v.health/v.maxHealth < hpbarfortrack and distance <= 1200  then
				me:SafeCastAbility(Track,v)
				sleepTick = tick + 500
				return
			end
			if CheckSpells(Shuriken) and v.health > 0 and v.health < damage[Shuriken.level]*(1-v.magicDmgResist) and distance < range and not v.illusion then
				me:SafeCastAbility(Shuriken,v)
				sleepTick = tick + 500
				return
			end
		end
	end
end

function CheckSpells(spell)
	if spell or spell.level ~= 0 or spell.state ~= LuaEntityAbility.STATE_READY then
		return true
	end
	return false
end

function InvisibleHeroes(v)
	local invokerhuesos=ivoka("invoker_ghost_walk",v)
	invisItem = v:FindItem("item_invis_sword")
	invisBottle = v:FindItem("item_bottle_invisible")
	if invisItem and invisItem.state == LuaEntityAbility.STATE_READY and invisItem.cd == 0 then
		return true
	end
	if invisBottle and invisBottle.state == LuaEntityAbility.STATE_READY and invisBottle.cd == 0  then
		return true
	end
	if v.name == "npc_dota_hero_riki" then
		if v:GetAbility(4).level ~=0 then
			return true
		end
	elseif v.name == "npc_dota_hero_clinkz" then
		if v:GetAbility(3).level ~=0 and v:GetAbility(3).state == LuaEntityAbility.STATE_READY and v:GetAbility(3).cd == 0 then
			return true
		end
	elseif v.name == "npc_dota_hero_nyx_assassin" then
		if v:GetAbility(3).level ~=0 and v:GetAbility(3).state == LuaEntityAbility.STATE_READY and v:GetAbility(3).cd == 0 then
			return true
		end
	elseif v.name == "npc_dota_hero_templar_assassin" then
		if v:GetAbility(2).level ~=0 and v:GetAbility(2).state == LuaEntityAbility.STATE_READY and v:GetAbility(2).cd == 0 then
			return true
		end
	elseif v.name == "npc_dota_hero_broodmother" then
		if v:GetAbility(2).level ~=0 and v:GetAbility(2).state == LuaEntityAbility.STATE_READY and v:GetAbility(2).cd == 0 then
			return true
		end
	elseif v.name == "npc_dota_hero_weaver" then
		if v:GetAbility(2).level ~=0 and v:GetAbility(2).state == LuaEntityAbility.STATE_READY and v:GetAbility(2).cd == 0 then
			return true
		end
	elseif v.name == "npc_dota_hero_treant" then
		if v:GetAbility(1).level ~=0 and v:GetAbility(1).state == LuaEntityAbility.STATE_READY and v:GetAbility(1).cd == 0 then
			return true
		end
	elseif v.name == "npc_dota_hero_sand_king" then
		if v:GetAbility(2).level ~=0 and v:GetAbility(2).state == LuaEntityAbility.STATE_READY and v:GetAbility(2).cd == 0 then
			return true
		end
	elseif v.name == "npc_dota_hero_invoker" then
			if invokerhuesos then
				if invokerhuesos.state == LuaEntityAbility.STATE_READY and invokerhuesos.cd == 0 then
					return true
				end
			end
	end
	return false
end

function etotJeEtotSpell(spellname,v)
        return (v:GetAbility(4).name == spellname) or (v:GetAbility(5).name == spellname)
end

function ivoka(spellname,v)
        if spellname and etotJeEtotSpell(spellname,v) then
                if v:GetAbility(4).name == spellname then
                        return v:GetAbility(4)
                elseif v:GetAbility(5).name == spellname then
                        return v:GetAbility(5)
                end
        end
end

script:RegisterEvent(EVENT_TICK,Tick)
