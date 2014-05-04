require("libs.TargetFind")
activated = false

-- Setting
activated_button = string.byte(" ") -- KEY TO USE
mode=3 -- MODE 1/2/3 see http://www.zynox.net/forum/newthread.php?do=postthread&f=12

function Tick( tick )
	if not client.connected or client.loading or client.console or client.paused or  not entityList:GetMyHero() then 
		return 
	end
	
	me = entityList:GetMyHero()	
	if sleepTick and sleepTick > tick then
		return
	end
	local target = nil
	local myrab = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Neutral,controllable=true,alive=true,visible=true})
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
			for i,v in ipairs(myrab) do
				if v.controllable then
					if v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							if v.name == "npc_dota_neutral_centaur_khan" then
								if distance < 250 then
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
								if distance < 550 then
									v:SafeCastAbility(v:GetAbility(1),target)
								end							
							end
							v:Attack(target)
							sleepTick = tick + 250
							return
						end
					end
				end
			end
		end
	end
end

function Key(msg,code)
    if code == activated_button and not client.chat then
        activated = (msg == KEY_DOWN)
	end
end
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_TICK,Tick)
