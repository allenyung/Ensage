-- Основа для скриптов by kj2a.
-- Для написания создайте файл "имя.lua" скопируйте данный код и очистите в функции GoUseTick: от -- inc ;) до Attack(target)
-- К примеру возьмём героя Life Stealer.
-- 1. Придаём название скрипту: ScriptConfig:SetName("Life Stealer")
-- 2. Выставляем имя героя: me.name ~= "Life Stealer"
-- 3. Выставляем радиус таргета для Life Stealer хватит: targetFind:GetLastMouseOver(600)
--[[
 
-- Переменные:
range = 0
Erange = {200,300,400,500}
 
-- После взятия таргета: targetFind:GetLastMouseOver(600)
local armlet = me:FindItem("item_armlet")
-- Пример содержания GoUseTick учитывая от inc ;) до Attack(target):
                        if _E.level ~= 0 then
                                range = Erange[_E.level]
                        end
                        if distance < range then
                                QueueSpell(_E,target,50)
                        end
                        QueueSpell(_Q,nil,100)
                       
                        if not me:DoesHaveModifier("modifier_item_armlet_unholy_strength") and armlet then
                                me:SafeCastItem("item_armlet")
                        end
                       
                        CastItems({"item_abyssal_blade"},target,50)
]]
require("libs.Utils")
require("libs.TargetFind")
require("libs.HotkeyConfig")
ScriptConfig = ConfigGUI:New(script.name)
ScriptConfig:SetName("new heroes") --  Имя скрипта (Будет отображаться в правом верхнем углу.)
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)
ScriptConfig:AddParam("combo","Combo",SGC_TYPE_ONKEYDOWN,false,false,string.byte(" ")) -- При нажатии на данную кнопку будет срабатывать GoUseTick тоесть наше комбо вомбо. (Можно менять в игре в правом верхнем углу.)
 
TargetName = "None"
sleepTick = {0,0,0}
Queue = {}
currentTick = nil
lastSpell = nil
function Tick(tick)
        if me and engineClient.ingame and not engineClient.console and (sleepTick[1] and sleepTick[1] < tick) then
                currentTick = tick
                if not ProcessQueue() then
                        return
                end
                if not PlayingGame() then
                        ScriptConfig:SetVisible(false)
                        return
                end
                if me.name ~= "Hero Name" then -- Имя героя?
                        -- print(me.name) -- Не знаешь имя? Убери в начале -- Включи скрипт и смотри в Debug Console.
                        ScriptConfig:SetVisible(false)
                        script:Disable()
                        return
                else
                        GoUseTick() -- Выполнение основы.
                end
        end
end
function sleep(i,d)
    sleepTick[i] = currentTick + d
end
function ProcessQueue()
    if #Queue == 0 then return true end
    target = Queue[1][2]
    spell = Queue[1][1]
    delay = Queue[1][3]
   if (lastSpell and lastSpell.state ==  STATE_COOLDOWN) then table.remove(Queue,1) end
    if  (me.unitState > 33600000 or me.unitState == 16 )and target then
        if currentTick > sleepTick[2] then
            Attack(target)
            sleepTick[2] = currentTick + 500
        end
        return false
    end
    Cast(spell,target)
    sleep(1,delay)
    lastSpell = spell
    table.remove(Queue,1)
end
function QueueSpell(spell,target,delay)
    table.insert(Queue, {spell,target,delay})
end
function GoUseTick()
        ScriptConfig:SetVisible(true)
    local _Q = me:GetAbility(1)
    local _W = me:GetAbility(2)
    local _E = me:GetAbility(3)
    local _R = me:GetAbility(4)
        if ScriptConfig.combo then
                local target = nil
                target = targetFind:GetLastMouseOver(1200) -- Берёт таргет по наведению мышки в районе?
                -- К данному таргету нужно привыкать так как мышка должна постоянно быть на вражеском герое.
                -- Если к примеру вражеских героев будет 2 и вы при нажатии комбо-вомбо поводите мышкой по обоим то вашь герой будет мешкатся туда суда.
               
                if not target then return end
                TargetName = target.name
               
                if  #Queue == 0 then
                        local distance = GetDistance3D(me,target) -- Дистанция до цели. "distance"
 
                        -- inc ;)
                       
                        -- Использование итемов без таргета.
                        -- Порядок итемов тоже играет роль. Использование идёт по порядку.
                        CastItems({"black_king_bar","item_manta","item_mask_of_madness","item_satanic"},nil,50)
                       
                        -- Всегда накладываем по откату на себя какой либо спелл.
                        QueueSpell(_Q,me,50)
                       
                        -- Если до цели меньши или 1200 то вьёбываем Q
                        -- Spell используется на цель.
                        if distance <= 1200 then
                                QueueSpell(_Q,target,50)
                        end
                       
                        -- Если до цели меньши или 260 то вьёбываем Q
                        -- Spell используется без цели пример данного спелла Storm Spirit.
                        if distance <= 260 then
                                QueueSpell(_Q,nil,50)
                        end
                       
                       
                        -- Если до цели меньши или 315 то вьёбываем Q
                        -- Spell используется по позиции цели пример данного спелла Legion Commander.
                        if distance <= 315 then
                                QueueSpell(_Q,getPosition(target),50)
                        end
 
                       
                        -- Использования итемов по таргету.
                        CastItems({"sheepstick","orchid","ethereal","dagon","item_heavens_halberd","item_abyssal_blade","item_diffusal_blade","item_ethereal_blade"},target,50)
                       
                        -- Используем даггер. К примеру для кентавра.
                        -- Суть: if "Есть даггер" and "Дистанция больше радиуса _Q стана кентавра" and "Дистанция меньше каста даггера"
                        local _B = FindItem("item_blink") -- Обьявить в самом начале GoUseTick.
                        if _B ~= false and distance > 315 and not distance < 1300 then
                                Cast(_B,getPosition(target))
                        end
                       
                        -- Игра с баффами.
                        -- Пример: Если EmberSpirit использовал _W на героя то у него появляется бафф указанный ниже.
                        -- Мы пытаемся привязать его _Q.
                        if me:DoesHaveModifier("modifier_ember_spirit_sleight_of_fist_caster") or distance < 400 then -- "or distance < 400" Означает или дистанция меньше 400.
                        -- Тоесть мы проверяем бафф если его нет также проверяем дистанцию.
                                if not target:IsMagicDmgImmune() then -- ЕСЛИ таргет не имеет магического иммунитета.
                                        QueueSpell(_Q,nil,50)
                                end
                        end
                       
                        -- Пример: Если вы забываете включать армлет. (Auto Armlet Toggle) перестанет работать!
                        -- Когда наше комбо в действии проверяем наличее указанного ниже баффа на себе если его нет то используем то что нам нужно.
                        local armlet = me:FindItem("item_armlet") -- Обьявить в самом начале GoUseTick.
                        if not me:DoesHaveModifier("modifier_item_armlet_unholy_strength") and armlet then
                                me:SafeCastItem("item_armlet")
                        end
                       
                        -- Пример: В лицо _W кентавра.
                        -- Урон у _W по уровням 175/250/325/400 значит мы будем узнавать уровень спелла после чего урон за каждый уровень.
                        _WdamageL = {175,250,325,400} -- обьявить в самое начало скрипта.
                        _Wdamage = 0 -- обьявить в самое начало скрипта.
                       
                        -- Если уровень _W не равен 0.
                        if _W.level ~= 0 then
                                -- Каждый уровень свой дамаг.
                                -- Получаем в переменную _Wdamage текущий дамаг нашего спелла.
                                _Wdamage = _WdamageL[_W.level]
                        end    
                       
                        -- if "Хп противника меньше урона нашей _W с учётом магического резиста" and "Наше хп больше урона нашей _W с учётом магического резиста"
                        if target.health < _Wdamage*(1-target.magicDmgResist) and me.health > _Wdamage*(1-me.magicDmgResist) then
                                QueueSpell(_W,target,50)
                        end
                       
                       
                        -- Атака цели.
                        Attack(target)
                        return
                end
               
        end
end
function CastItems(itemList,target,delay)
    for i,name in ipairs(itemList) do
        local item = FindItem(name)
        if (item ~= false) then
            QueueSpell(item,target,delay)
        end
    end
end
function getPosition(target)
        return Vector(target.x,target.y,target.z)
end
function Cast(spell,target)
    if spell.state == STATE_READY then
        if target then
                       
            UseAbility(spell,target)
        else
            UseAbility(spell)
        end
    end
end
function GetDistance3D(p,t)
    return math.sqrt(math.pow(p.x-t.x,2)+math.pow(p.y-t.y,2)+math.pow(p.z-t.z,2))
end
function Frame(tick)
    if not engineClient.ingame or engineClient.console or not ScriptConfig.combo then
        return
    end
    length = 40+#TargetName*6.5
    if length > 100 then length = length*0.87+3 end
    drawManager:DrawOutline(30,50,length,15,0xFFBB00FF)
    drawManager:DrawText(33,50,0xFFFFFFFF,"Target: "..TargetName)
end
 
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_FRAME,Frame)
