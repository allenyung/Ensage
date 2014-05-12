require("libs.Utils")
require("libs.TargetFind")
activated = false
creepHandle = nil
param = 1
Font = drawMgr:CreateFont("NoStack","Arial",14,500)
NoStackText = drawMgr:CreateText(5,63,-1,"",Font)

-- Setting
activated_button = string.byte(" ") -- KEY TO USE
no_stack_creep_button = string.byte("L") -- KEY TO USE
mode=3 -- MODE 1/2/3 see http://www.zynox.net/forum/threads/674-ez4-Chuan-by-kj2a

function Tick( tick )
	if not client.connected or client.loading or client.console or client.paused then 
		return 
	end
	
	me = entityList:GetMyHero()
	if not me then return end
	
	if sleepTick and sleepTick > tick then
		return
	end
	local target = nil
	local Neutrals = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Neutral,controllable=true,alive=true,visible=true})
	local InvForgeds = entityList:FindEntities({classId=CDOTA_BaseNPC_Invoker_Forged_Spirit,controllable=true,alive=true,visible=true})
	local WarlockGolem = entityList:FindEntities({classId=CDOTA_BaseNPC_Warlock_Golem,controllable=true,alive=true,visible=true})
	local TuskSigil = entityList:FindEntities({classId=CDOTA_BaseNPC_Tusk_Sigil,controllable=true,alive=true,visible=true})
	local Illusions = entityList:FindEntities({classId=TYPE_HERO,controllable=true,alive=true,visible=true,illusion=true})
	
	if mode == 1 then
		target = targetFind:GetLastMouseOver(1300)
	elseif mode == 2 then
		target = entityList:GetMouseover()
	elseif mode == 3 then
		target = targetFind:GetClosestToMouse(1300)
	else
		print("please check mode 1/2/3. Thank.")
	end
	if target and activated then
		if target.team == (5-me.team) then
			if #Neutrals > 0 then
			CheckStun = target:DoesHaveModifier("modifier_centaur_hoof_stomp")
			CheckSetka = target:DoesHaveModifier("modifier_dark_troll_warlord_ensnare")
				for i,v in ipairs(Neutrals) do
					if v.controllable and v.handle ~= creepHandle then
						if v.unitState ~= -1031241196 then
							local distance = GetDistance2D(v,target)
							if distance <= 1300 then
								if v.name == "npc_dota_neutral_centaur_khan" then
									if distance < 250 and not (CheckStun or CheckSetka) then
										v:SafeCastAbility(v:GetAbility(1),nil)
									end
								elseif v.name == "npc_dota_neutral_satyr_hellcaller" then
									if distance < 980 then
										v:SafeCastAbility(v:GetAbility(1),target.position)
									end						
								elseif v.name == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
									if distance < 300 then
										v:SafeCastAbility(v:GetAbility(1),nil)
									end							
								elseif v.name == "npc_dota_neutral_dark_troll_warlord" then
									if distance < 550 and not (CheckStun or CheckSetka) then
										v:SafeCastAbility(v:GetAbility(1),target)
									end							
								end
								v:Attack(target)
							end
						end
					end
				end
			end
			
			if #InvForgeds > 0 then
				for i,v in ipairs(InvForgeds) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #WarlockGolem > 0 then
				for i,v in ipairs(WarlockGolem) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #TuskSigil > 0 then
				for i,v in ipairs(TuskSigil) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Follow(target)
						end
					end
				end
			end
			
			if #Illusions > 0 then
				for i,v in ipairs(Illusions) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
		end
	end
	sleepTick = tick + 333
	return
end

function Key(msg,code)
	if client.chat or not client.connected or client.loading then
		return
	end
	
    if code == activated_button then
        activated = (msg == KEY_DOWN)
	end
		
	if code == no_stack_creep_button and msg == KEY_UP then
		local player = entityList:GetMyPlayer()
		if not player or player.team == LuaEntity.TEAM_NONE then
			return
		end
		
		if param == 2 then
			creepHandle = nil
			NoStackText.visible = false
			param = 1
		end

		local selection = player.selection
		if #selection ~= 1 or (selection[1].type ~= LuaEntity.TYPE_CREEP and selection[1].type ~= LuaEntity.TYPE_NPC) or not selection[1].controllable then
			return
		end

		if param == 1 then
			creepHandle = selection[1].handle
			NoStackText.text = "Stack Creep: "..client:Localize(selection[1].name)
			NoStackText.visible = true
			param = 2
		end
	end
end
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_TICK,Tick)
