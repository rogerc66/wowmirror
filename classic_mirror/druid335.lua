local _,Name = BeeGetShapeshiftId();
local tlzd = BeeUnitBuffList("player");
local tbl = BeeUnitBuffList("target");
local ttbl = BeeUnitBuffList("targettarget");
local yhs = 1; -- 月火
local luaunlock = 0;
local autoshift=1;
local qsmouse=1;
local shroom=0;
local manapotion = 0; --1: 神效法力,  2:炼金师回春
local ningjing = BeeStringFind("宁静", BeeUnitCastSpellName("player"));
local GCD=GetSpellCooldown("治疗之触");
local InRangeT = IsSpellInRange("愤怒","target");
local grouptype="party";
if GetNumRaidMembers()>0 then
    grouptype="raid"
end
if GetNumPartyMembers()>0 and not GetNumRaidMembers() then
    grouptype="party"
end
local MeleeRange;
if IsSpellInRange("裂伤","target")==nil or IsSpellInRange("裂伤","target")==0 then
    MeleeRange = false
elseif  IsSpellInRange("裂伤","target")==1 then
    MeleeRange = true
end
local ActionRange
if CheckInteractDistance("target", 3)==nil or CheckInteractDistance("target", 3)==0 then
    ActionRange = false
elseif  CheckInteractDistance("target", 3)==1 then
    ActionRange = true
end

---manual cast
if BeeCastSpellFast() then
    return true;
end
--Must Dispell
if not Name and not IsStealthed() and BeeStringFind("精灵之火,精灵虫群,虚空风暴,炎爆术,活体炸弹,瘫痪药膏,减速药膏,燃烧,猎人印记,寒冰炸弹,元素诅咒",tlzd) and BeeIsRun("自然之愈","player") and not UnitChannelInfo("player") and GCD==0 then
    BeeRun("自然之愈","player");
    return;
end

--Powershift
if Name and BeeStringFind("冰霜新星,冰冻术,冰冻,震荡射击,冻疮,断筋,寒冰锁链,寒冰陷阱,险境求生,霜火之箭,寒冰箭,刺耳怒吼,枯萎凋零,冰锥术,罪状负担,感染伤口,蛛网,寒冰结界,迟滞,纠缠根须,陷地,减速药膏,精神鞭挞,冰霜吐息,公正圣印,台风,诱捕,寒冰宝珠,群体缠绕,冰霜震击",tlzd) then  BeeRun("Powershift");
    return;
end
if not Name and not UnitChannelInfo("player") and not BeeUnitCastSpellName("player") and BeeStringFind("冰霜新星,冰冻术,断筋,寒冰锁链,险境求生,刺耳怒吼,冰锥术,蛛网,寒冰结界,迟滞,纠缠根须,陷地,冰霜吐息,诱捕,群体缠绕",tlzd) and BeeIsRun("猎豹形态","nogoal") then
    BeeRun("猎豹形态","nogoal")
    return;
end

if SpellIsTargeting() and luaunlock==1 then  
    CameraOrSelectOrMoveStart()  
    CameraOrSelectOrMoveStop() 
    return;
end
if BeeIsRun("法力回复","nogoal") and not name and BeeUnitMana("player","%",0)<70 then 
    BeeRun("法力回复","nogoal");
end

--在飞行中，不施法 Feral
if IsMounted("player")==1 or BeeGetShapeshiftFormInfo(2) or SpellIsTargeting() or UnitChannelInfo("player") or BeeUnitCastSpellName("player") or IsStealthed() or UnitInVehicle("player") then
    return;
end

--combat survival
if not Name and not IsStealthed() and BeePlayerBuffTime("反射之盾")<3 and BeeUnitHealth(player,"%")<95 and BeeUnitAffectingCombat() and BeeIsRun("反射之盾","nogoal") and BeeUnitMana("player","%",0)>50 then
    BeeRun("反射之盾","nogoal")
    return;
end
if not Name and not IsStealthed() and BeePlayerBuffTime("圣盾术")<0 and BeeUnitHealth(player,"%")<25 and BeeUnitAffectingCombat() and BeeIsRun("圣盾术","nogoal") then
    BeeRun("圣盾术","nogoal")
    return;
end
if not Name and not IsStealthed() and BeeUnitHealth(player,"%")<95 and BeeUnitAffectingCombat() and BeeIsRun("自然之握","nogoal") and BeeUnitBuff("回春术","player")>1 and GCD==0 then
    BeeRun("自然之握","nogoal")
    return;
end
if not IsStealthed() and BeeGetShapeshiftFormInfo(3)==1 and BeeIsRun("潜行","nogoal") then
    BeeRun("潜行","nogoal");
end
if BeeStringFind("影遁", tlzd) and BeeGetShapeshiftFormInfo(3)==1 and BeeIsRun("潜行","nogoal") then 
    BeeRun("潜行","nogoal");end
--buff
if not IsFalling() and BeeIsRun("野性印记","player") and  BeePlayerBuffTime("野性印记")<600 and not Name and GCD==0 or not IsFalling() and not BeeStringFind("野性印记",tlzd) and not Name and GCD==0 then
    BeeRun("野性印记","player")
    return;
end
if not IsFalling() and BeeIsRun("荆棘术","player") and  BeePlayerBuffTime("荆棘术")<60 and not Name and GCD==0 or not IsFalling() and not BeeStringFind("荆棘术",tlzd) and not Name and GCD==0 then
    BeeRun("荆棘术","player")
    return;
end
if BeeRangeR("mouseover")<=30 and not UnitIsDead("mouseover") and BeeIsRun("野性印记","mouseover") and not Name and BeePlayerBuffTime("喝水")<1  and BeeUnitBuff("野性印记","mouseover")<1 and (BeeUnitPlayerControlled("mouseover") or UnitIsUnit("pet","mouseover")==1) and GCD==0 then 
    BeeRun("野性印记","mouseover");
end
if BeeRangeR("mouseover")<=30 and not UnitIsDead("mouseover") and BeeIsRun("荆棘术","mouseover") and not Name and BeePlayerBuffTime("喝水")<1  and BeeUnitBuff("荆棘术","mouseover")<1 and UnitIsUnit("pet","mouseover")==1 and GCD==0 then 
    BeeRun("荆棘术","mouseover");
end

--autofocus&targetfocus
if BeeUnitAffectingCombat() and (UnitName("focus")==nil or UnitIsDead("focus")) then 
    BeeRun("/focus player");
end
if BeeUnitAffectingCombat() and UnitName("target")==nil or UnitIsDead("target") and BeeUnitAffectingCombat() then
    BeeRun("/target focus");
end
if UnitName("focus") and UnitCanAssist("player","focus") and IsSpellInRange("治疗之触","focus")==0 then
    BeeRun("/clearfocus")
    --EuiAlertRun("失去焦点",0.1,1,0.1)
    return;
end
if UnitName("focus") and GetRaidTargetIndex("focustarget")==nil and BeeUnitCanAttack("focustarget") and GetNumPartyMembers() and not GetNumRaidMembers() then
    SetRaidTarget("focustarget", 8)
    return;
end

---triggers bear
if BeeGetShapeshiftFormInfo(1) and BeeUnitAffectingCombat() and GCD==0 then    
    if  BeeIsRun("重殴") and BeeUnitMana()>30 then
        BeeRun("重殴") ;
        return;
    end    
end

--healer job
if not Name and BeePlayerBuffTime("喝水")<1 and not UnitChannelInfo("player") and GCD==0 then     
    local HC = BeeGroupMinScript('BeeIsRun("回春术",unit) and BeeUnitHealth(unit,"%")<90 and BeeUnitBuff("回春术",unit)<1 and UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and IsSpellInRange("回春术",unit)',"BeeUnitHealth(unit)",grouptype)
    if HC and BeeIsRun("回春术",HC) then
        BeeRun("回春术",HC);
        return;
    end
    if BeeIsRun("回春术","focus") and BeeUnitBuff("回春术","focus")<1 and BeeUnitHealth("focus","%")<90 and IsSpellInRange("回春术","focus") then 
        BeeRun("回春术","focus");
        return; 
    end 
    if BeeIsRun("回春术","mouseover") and BeeUnitBuff("回春术","mouseover")<1 and BeeUnitHealth("mouseover","%")<80 and IsSpellInRange("回春术","mouseover") then 
        BeeRun("回春术","mouseover");
        return; 
    end
    local YHP = BeeGroupMinScript('BeeIsRun("愈合",unit) and BeeUnitHealth(unit,"%")<75 and BeeUnitBuff("愈合",unit)<1 and UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and IsSpellInRange("愈合",unit)',"BeeUnitHealth(unit)",grouptype)
    if YHP and BeeIsRun("愈合",YHP) then
        BeeRun("愈合",YHP);
        return;
    end
    if BeeIsRun("回春术","pet") and BeeUnitBuff("回春术","pet")<1 and BeeUnitHealth("pet","%")<90 and IsSpellInRange("回春术","pet") then 
        BeeRun("回春术","pet");
        return; 
    end
    if BeeIsRun("回春术","focus") and BeeUnitBuff("反射之盾","focus")<1 and BeeUnitHealth("focus","%")<50 and IsSpellInRange("回春术","focus") and BeeUnitAffectingCombat() then 
        BeeRun("focusdef");
        return; 
    end
    if BeeIsRun("回春术","pet") and BeeUnitBuff("反射之盾","pet")<1 and BeeUnitHealth("pet","%")<80 and IsSpellInRange("回春术","pet") and BeeUnitAffectingCombat() then 
        BeeRun("petdeflect");
        return; 
    end
    
    --offensive
    if BeeIsRun("月火术") and BeeUnitBuff("月火术","target",2)<0 and BeeUnitAffectingCombat() and not BeeStringFind("纠缠根须,法术反射,圣盾术,寒冰屏障,",tbl) and not BeeUnitPlayerControlled() and yhs==1 and InRangeT and not UnitIsDeadOrGhost("target") then
        BeeRun("月火术") 
        return;
    end
    if BeeIsRun("愤怒") and BeeUnitAffectingCombat() and not BeeUnitPlayerControlled() and yhs==1 and BeeRangeR() and not BeeStringFind("纠缠根须,法术反射,圣盾术,寒冰屏障,",tbl) and BeeUnitHealth("player","%")>85 and BeeUnitMana()>70 and not UnitIsDeadOrGhost("target") then
        BeeRun("愤怒") 
        return;
    end   
end
