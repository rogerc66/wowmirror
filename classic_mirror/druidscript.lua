local _,Name = BeeGetShapeshiftId();
local tlzd = BeeUnitBuffList("player");
local tbl = BeeUnitBuffList("target");
local ttbl = BeeUnitBuffList("targettarget");
local yhs = 1; -- 月火
local yaodai1="风炎束腰";
local yaodai2="风炎束腰";
local luaunlock = 0;
local autoshift=1;
local qsmouse=1;
local shroom=0;
local manapotion = 0; --1: 神效法力,  2:炼金师回春
local ningjing = BeeStringFind("宁静", BeeUnitCastSpellName("player"));
local GCD=GetSpellCooldown("回春术");
local InRangeT = IsSpellInRange("愤怒","target");
local grouptype="party";
if GetNumRaidMembers() then
    grouptype="raid"
end
if GetNumPartyMembers() and not GetNumRaidMembers() then
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
if Name and BeeStringFind("冰霜新星,冰冻术,冰冻,震荡射击,冻疮,断筋,寒冰锁链,寒冰陷阱,险境求生,霜火之箭,寒冰箭,刺耳怒吼,枯萎凋零,冰锥术,罪状负担,感染伤口,蛛网,寒冰结界,迟滞,纠缠根须,陷地,减速药膏,精神鞭挞,冰霜吐息,公正圣印,台风,诱捕,寒冰宝珠,群体缠绕,冰霜震击",tlzd) then    BeeRun("Powershift");
    return;
end
if not Name and not UnitChannelInfo("player") and not BeeUnitCastSpellName("player") and BeeUnitBuffsSpells("player","冰霜新星,冰冻术,断筋,寒冰锁链,险境求生,刺耳怒吼,冰锥术,蛛网,寒冰结界,迟滞,纠缠根须,陷地,冰霜吐息,诱捕,群体缠绕","猎豹形态") then
    return;
end
--[[if BeeIsRun("惊魂咆哮","nogoal") and BeeUnitAffectingCombat() and not UnitIsDeadOrGhost("target") and BeeUnitCanAttack() and UnitIsEnemy("player","target") and not BeeStringFind("圣盾术,寒冰屏障,突袭,旋风",tbl) and not UnitChannelInfo("player") and not IsStealthed() and not IsMounted() and not BeeUnitCastSpellName("player") and not UnitInVehicle("target") and ActionRange then 
    BeeRun("惊魂咆哮","nogoal");
    return;
end]]--
if SpellIsTargeting() and luaunlock==1 then  
    CameraOrSelectOrMoveStart()  
    CameraOrSelectOrMoveStop() 
    return;
end
if BeeStringFind("影遁" , tlzd) and BeeIsRun("旅行形态") then
    BeeRun("旅行形态")
    return;
end
--在飞行中，不施法 Feral
if IsMounted("player")==1 or BeeGetShapeshiftFormInfo(3) or SpellIsTargeting() or UnitChannelInfo("player") or BeeUnitCastSpellName("player") or IsStealthed() or UnitInVehicle("player") then
    return;
end
if not Name and BeePlayerBuffTime("喝水")<1 and not UnitChannelInfo("player") and GCD==0 and BeeUnitBuff("生命绽放","focus")<0 and BeeUnitAffectingCombat("focus") and IsSpellInRange("生命绽放","focus") then BeeRun("生命绽放","focus");
    return;
end
if not BeeGetShapeshiftFormInfo(1) and not IsStealthed() and UnitHealth("player")/UnitHealthMax("player")<0.70 and BeeIsRun("回春术","player") and BeeUnitBuff("回春术","player")<1 and not BeeStringFind("急奔,狂奔怒吼",tlzd) and GCD==0 then
    BeeRun("回春术","player");
    return;
end
---Trinker
if IsEquippedItem("骄矜角斗士的残酷勋章") and  BeeUnitBuffsSpells("player","恐惧,心灵尖啸,恐惧嚎叫,瘫痪,破胆怒吼,恐惧术,死亡缠绕,肾击,制裁之锤,制裁之拳,深度冻结,偷袭,割碎,冰冻陷阱,窒息,蛮力猛击,心灵恐惧,冰霜之环,变形术,迷魅,妖术,震荡波,扫堂腿,金刚震,盲目之光,风暴之锤,严酷寒冬","骄矜角斗士的残酷勋章",false) then
    return;
end
--buff
--[[if not Name and BeeIsRun("狂乱水晶","player") and BeePlayerBuffTime("癫狂视觉")<60 and not BeeStringFind("秋叶合剂,暖阳合剂,春华合剂",tlzd) then
    BeeRun("狂乱水晶","player")
    return;
end
if not IsFalling() and BeeIsRun("野性印记","player")  and  BeePlayerBuffTime("野性印记")<600 and not Name and GCD==0 or not IsFalling() and not BeeStringFind("野性印记",tlzd) and not Name and GCD==0 then
    BeeRun("野性印记","player")
    return;
end
if not Name and BeeIsRun("炼金师的合剂","player") and BeePlayerBuffTime("增强智力")<600 and BeePlayerBuffTime("癫狂视觉")<60 and not BeeStringFind("秋叶合剂,暖阳合剂,春华合剂",tlzd) then
    BeeRun("炼金师的合剂","player")
    return;
end]]--
--rezmouse
if BeeRangeR("mouseover")<=40 and UnitIsDead("mouseover") and BeeIsRun("复生","mouseover") and not Name and BeePlayerBuffTime("喝水")<1 and BeeUnitAffectingCombat() then 
    BeeRun("复生","mouseover");
end
if BeeRangeR("mouseover")<=40 and UnitIsDead("mouseover") and BeeIsRun("起死回生","mouseover") and not Name and BeePlayerBuffTime("喝水")<1 and not BeeUnitAffectingCombat() then
    BeeRun("起死回生","mouseover");
end
--autofocus&targetfocus
if BeeUnitAffectingCombat() and (UnitName("focus")==nil or UnitIsDead("focus")) then 
    BeeRun("/focus player");
end
if BeeUnitAffectingCombat() and UnitName("target")==nil or UnitIsDead("target") and BeeUnitAffectingCombat() then
    BeeRun("/target focus");
end
if UnitName("focus") and UnitCanAssist("player","focus") and IsSpellInRange("回春术","focus")==0 then
    BeeRun("/clearfocus")
    --EuiAlertRun("失去焦点",0.1,1,0.1)
    return;
end
if UnitName("focus") and GetRaidTargetIndex("focustarget")==nil and BeeUnitCanAttack("focustarget") and GetNumPartyMembers() and not GetNumRaidMembers() then
    SetRaidTarget("focustarget", 8)
    return;
end
---combat survive
if IsFalling() and not BeeGetShapeshiftFormInfo(1) and not BeeGetShapeshiftFormInfo(2) and BeeIsRun("旅行形态") and not BeeStringFind("地精滑翔器",tlzd) and GCD==0 then
    BeeRun("旅行形态")
    return;
end
if IsFalling() and IsEquippedItem("吉康，赤精之仁") and BeeIsRun("吉康，赤精之仁") and BeeUnitAffectingCombat() and not UnitChannelInfo("player") then
    BeeRun("/use 15");
    return;
end
if IsEquippedItem(yaodai1) and BeeIsRun(yaodai1,"nogoal") and BeeStringFind("旅行形态",tlzd) then
    BeeRun("/use 6");
    return;
end
if not IsStealthed() and BeeGetShapeshiftFormInfo(2) and BeeIsRun("潜行") then
    BeeRun("潜行");
end
if BeeStringFind("影遁", tlzd) and BeeGetShapeshiftFormInfo(2) and BeeIsRun("潜行") then 
    BeeRun("潜行");end
if UnitHealth("player")/UnitHealthMax("player")<0.60 and BeeUnitAffectingCombat() and BeeSpellCD("树皮术")<1 and BeeIsRun("树皮术") and not UnitChannelInfo("player") then
    BeeRun("树皮术");
    return;
elseif BeeUnitBuffsSpells("player","军团烈焰,偷袭,肾击,制裁之锤,深度冻结,刺骨之寒,震荡波","树皮术") then
    return;
elseif  UnitHealth("player")/UnitHealthMax("player")<0.50 and BeeUnitAffectingCombat() and BeeIsRun("治疗石") then
    BeeRun("治疗石");
    return;
elseif  UnitHealth("player")/UnitHealthMax("player")<0.30 and BeeUnitAffectingCombat() and BeeIsRun("炼金师的回春水") and manapotion==2 then   BeeRun("炼金师的回春水");
    return;
end
if BeeTargetTargetIsPlayer() and BeeUnitCanAttack() and UnitIsEnemy("player","target") and IsSpellInRange("群体缠绕","target") and not BeeStringFind("影遁" , tlzd) and BeeIsRun("群体缠绕","target") and not BeeUnitCastSpellName("player") and GCD==0 and not BeeStringFind("圣盾术,寒冰屏障,旋风,根基图腾效果,光环掌握,暗影斗篷,纠缠根须,威慑",tbl) then
    BeeRun("群体缠绕","target")
    return;
end
if not BeeGetShapeshiftFormInfo(3) and not IsStealthed() and BeeUnitAffectingCombat() and BeeUnitHealth(player,"%")<75 and not BeeStringFind("影遁" , tlzd) and BeePlayerBuffTime("铁木树皮")<0 and BeeIsRun("铁木树皮","player") and BeeSpellCD("树皮术")>3 and BeePlayerBuffTime("树皮术")<0 then
    BeeRun("铁木树皮","player")
    return;
end
--[[if not Name and BeeIsRun("神效法力药水") and BeeUnitMana("player","%",0)<3 and BeeUnitAffectingCombat() and manapotion==1 then
    BeeRun("神效法力药水")
    return;
end
if not Name and BeeIsRun("炼金师的回春水") and BeeUnitMana("player","%",0)<3 and BeeUnitAffectingCombat() and manapotion==2 then
    BeeRun("炼金师的回春水")
    return;
end]]--
---triggers bear
if BeeGetShapeshiftFormInfo(1) and BeeUnitAffectingCombat() and GCD==0 then
    if BeeIsRun("裂伤") then
        BeeRun("裂伤");
        return;
    end
    if UnitHealth("player")/UnitHealthMax("player")<0.50 and BeeIsRun("狂暴回复") then
        BeeRun("狂暴回复" , "nogoal");
        return;
    end    
    if  BeeIsRun("痛击") and BeeTargetDeBuffTime("痛击")<5 then
        BeeRun("痛击") ;
        return;
    end   
end
---Triggers Cat
if BeeGetShapeshiftFormInfo(2) and not IsStealthed("player") and BeeUnitAffectingCombat() and GCD==0 then 
    if BeeStringFind("精灵之火,猎人印记,精灵虫群,虚空风暴,炎爆术,活体炸弹,寒冰炸弹,毒蛇钉刺,瘫痪药膏,燃烧,献祭,元素诅咒,末日降临,腐蚀术",tlzd) and BeeIsRun("自然之愈","player") then
        BeeRun("自然之愈","player");
        return;
    end    
    if BeeIsRun("凶猛撕咬") and BeeGetComboPoints()==5 then
        BeeRun("凶猛撕咬") return;
    end
    if BeeGetComboPoints()<5 and  BeeIsRun("撕碎") then
        BeeRun("撕碎");
        return;
    end  
end
local n,YXCZ = BeeGroupCountScript('BeeIsRun("野性成长",unit) and BeeRangeR(unit)<40',"BeeUnitHealth(unit,'%')<90 and not UnitIsDeadOrGhost(unit)",grouptype) if not Name and n>2 and BeeIsRun("野性成长",YXCZ) and BeeUnitAffectingCombat() and not UnitChannelInfo("player") and GCD==0 then 
    BeeRun("野性成长",YXCZ);
    return;
end
local TMSP = BeeGroupMinScript('BeeIsRun("铁木树皮",unit) and BeeUnitHealth(unit,"%")<60 and UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and IsSpellInRange("回春术",unit)',"BeeUnitHealth(unit)",grouptype)if TMSP and not Name and BeeIsRun("铁木树皮",TMSP) and BeeUnitAffectingCombat() then 
    BeeRun("铁木树皮",TMSP);
    return;
end
---healer job
local DXJ = BeeGroupMaxScript('UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and BeeUnitHealth(unit,"%")<50 and BeeRangeR(unit)<40',"BeeUnitHealth(unit,nil,1)",grouptype) 
if not Name and DXJ and not IsFalling() and not IsStealthed() and not UnitChannelInfo("player") and BeeIsRun("治疗之触",DXJ) and BeeIsRun("自然迅捷","nogoal") and BeeUnitAffectingCombat() then
    BeeRun("自然迅捷","nogoal")
    return;
end
if BeePlayerBuffTime("自然迅捷")>-1 then
    BeeRun("治疗之触",DXJ)
    return;
end
if BeeIsRun("治疗之触","focus") and BeeUnitBuff("修缮贤哲","player")<5 and BeeUnitBuffCount("修缮贤哲","player")>4  then
    BeeRun("治疗之触","focus");
    return;
end
if not Name and BeeIsRun("治疗之触","focus") and BeeUnitBuffCount("修缮贤哲","player")>4 and BeeUnitHealth("focus","%")<85 and BeeUnitAffectingCombat() then
    BeeRun("治疗之触","focus");
    return;
end
--[[if not Name and BeePlayerBuffTime("喝水")<1 and not UnitChannelInfo("player") and GCD==0 then     \n    local YXYJP = BeePartyScript('BeeIsRun("野性印记",unit) and UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and BeeRangeR(unit)<40')\n    if YXYJP and BeeIsRun("野性印记",YXYJP) and BeeUnitBuff("野性印记",YXYJP)<120 and not BeeUnitAffectingCombat() and BeeUnitMana()>30 and GCD==0 then \n        BeeRun("野性印记",YXYJP);\n        return; \n    end        \n    if BeeUnitBuffInfo("target",2,"Magic,Curse,Poison",0)>=1 and BeeIsRun("自然之愈","target") and BeeUnitHealth("target","%")>40 and BeeRangeR()<40 then\n        BeeRun("自然之愈","target\" ) ; \n    end    \n    if BeeUnitBuffInfo("mouseover",2,"Magic,Curse,Poison",0)>=1 and BeeIsRun("自然之愈","mouseover") and BeeUnitHealth("mouseover","%")>40 and qsmouse==1 then\n        BeeRun("自然之愈","mouseover\" ) ; \n    end     \n    --remove rage\n    if BeeIsRun("安抚","target") and BeeUnitAffectingCombat() and BeeUnitCanAttack() and InRangeT and isPurgeable() then\n        BeeRun("安抚","target");\n        return; \n    end        \n    local XJ = BeeGroupMinScript('BeeIsRun("迅捷治愈",unit) and BeeUnitBuff("回春术",unit)>0 and BeeUnitHealth(unit,"%")<75 and UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and IsSpellInRange("回春术",unit)',"BeeUnitHealth(unit)",grouptype)\n    if XJ and BeeIsRun("迅捷治愈",XJ) and BeeUnitAffectingCombat() then \n        BeeRun("迅捷治愈",XJ);\n        return; \n    end    \n    local YH = BeeGroupMinScript('BeeIsRun("愈合",unit) and BeeUnitHealth(unit,"%")<85 and UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and BeeRangeR(unit)<40',"BeeUnitHealth(unit)",grouptype)\n    if YH and BeeIsRun("愈合",YH) and BeeUnitBuff("节能施法", player)>1 and GetUnitSpeed("player")==0 then\n        BeeRun("愈合",YH);\n        return; \n    end     \n    local HC = BeeGroupMinScript('BeeIsRun("回春术",unit) and BeeUnitHealth(unit,"%")<90 and BeeUnitBuff("回春术",unit)<1 and UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and IsSpellInRange("回春术",unit)',"BeeUnitHealth(unit)",grouptype)\n    if HC and BeeIsRun("回春术",HC) then\n        BeeRun("回春术",HC);\n        return; \n    end    \n    if BeeIsRun("回春术","focus") and BeeUnitBuff("回春术","focus")<1 and BeeUnitHealth("focus","%")<90 and IsSpellInRange("回春术","focus") then \n        BeeRun("回春术","focus");\n        return; \n    end    \n    if BeeIsRun("回春术","target") and BeeUnitBuff("回春术","target")<1 and BeeUnitHealth("target","%")<90 and BeeUnitAffectingCombat() and UnitCanAssist("player","target") and not UnitIsDeadOrGhost("target") and IsSpellInRange("回春术","target") then \n        BeeRun("回春术","target");\n        return; \n    end    \n    if BeeIsRun("愈合","target") and BeeUnitBuff("回春术","target")>0 and BeeUnitHealth("target","%")<80 and BeeUnitAffectingCombat() and UnitCanAssist("player","target") and not UnitIsDeadOrGhost("target") and GetUnitSpeed("player")==0 and IsSpellInRange("愈合","target") then \n        BeeRun("愈合","target");\n        return; \n    end\n    if BeeUnitPlayerControlled("focus") and BeeIsRun("愈合","focus") and BeeUnitHealth("focus","%")<75 and BeeUnitAffectingCombat("focus") and GetUnitSpeed("player")==0 and IsSpellInRange("愈合","focus") then \n        BeeRun("愈合","focus");\n        return; \n    end    \n    if BeeUnitPlayerControlled("focus") and BeeIsRun("治疗之触","focus") and BeeUnitHealth("focus","%")<85 and BeeUnitAffectingCombat("focus") and BeeUnitBuff("回春术","focus")>0 and BeeStringFind("丛林之魂",tlzd) and GetUnitSpeed("player")==0 and IsSpellInRange("治疗之触","focus") then \n        BeeRun("治疗之触","focus");\n        return; \n    end    \n    local YHP = BeeGroupMinScript('BeeIsRun("愈合",unit) and BeeUnitHealth(unit,"%")<70 and UnitCanAssist("player",unit) and not UnitIsDeadOrGhost(unit) and IsSpellInRange("回春术",unit)',"BeeUnitHealth(unit)",grouptype)\n    if YHP and BeeIsRun("愈合",YHP) and BeeUnitHealth("focus","%")>60 and BeeUnitAffectingCombat() and GetUnitSpeed("player")==0 then\n        BeeRun("愈合",YHP);\n        return; \n    end          \n    if not IsStealthed() and UnitHealth("player")/UnitHealthMax("player")<0.60 and BeeIsRun("源生","nogoal") and BeeUnitBuff("回春术","player")>8 and not BeeStringFind("急奔,狂奔怒吼",tlzd) and BeeSpellCD("迅捷治愈")>0 and BeeSpellCD("自然迅捷")>0 then\n        BeeRun("源生","nogoal");\n        return;\n    end\n    if not IsStealthed() and UnitHealth("focus")/UnitHealthMax("focus")<0.60 and BeeIsRun("源生","nogoal") and BeeUnitBuff("回春术","focus")>8 and not BeeStringFind("急奔,狂奔怒吼",tlzd) and BeeRangeR("focus")<60 and BeeSpellCD("迅捷治愈")>0 and BeeSpellCD("自然迅捷")>0 then\n        BeeRun("源生","nogoal");\n        return;\n    end\n    \n  ]]--  

--offensive
if BeeUnitBuff("月火术","target",2)<0 and BeeUnitAffectingCombat() and not BeeStringFind("法术反射,圣盾术,寒冰屏障,",tbl) and not BeeUnitPlayerControlled() and yhs==1 and InRangeT then
    BeeRun("月火术") 
    return;
end        
if BeeIsRun("愤怒")  and BeeUnitAffectingCombat() and not BeeUnitPlayerControlled() and yhs==1 and InRangeT then
    BeeRun("愤怒") 
    return;
end      