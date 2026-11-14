local soldierRushRead = include("soldierRushRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_skillInfo", Com_skillInfo)
function Com_skillInfo:onInit()
end
function Com_skillInfo:onShow()
end
function Com_skillInfo:initData(skillId)
	local cfg = soldierRushRead.getSkillCfg(skillId)
	self.fields.icon:setSpriteFrame(cfg.SkillIcon)
	self.fields.qualityBg:setIcon(heroltCtrl.getBg(cfg.SkillQuality))
	self.fields.Text_name:setString(i18n(cfg.SkillName))
	soldierRushRead = i18n(cfg.SkillName)
	i18n(cfg.SkillName).num = cfg.SkillCd
	self.fields.Text_cd:setString(i18n("soldier_rush_text_18", i18n(cfg.SkillName)))
	local nameStr = ""
	local numStr = ""
	if cfg.EffectTarget == 0 then
		local skillType = cfg.UnactiveAttr[1]
		local skillVal = cfg.UnactiveAttr[2]
		if skillType == 1 then
			nameStr = i18n("攻击")
			numStr = skillVal
		elseif skillType == 2 then
			nameStr = i18n("生命")
			numStr = skillVal
		elseif skillType == 3 then
			nameStr = i18n("移速")
			numStr = skillVal
		elseif skillType == 4 then
			nameStr = i18n("攻击加成")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 5 then
			nameStr = i18n("生命加成")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 6 then
			nameStr = i18n("移速加成")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 7 then
			nameStr = i18n("建筑内攻击加成")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 8 then
			nameStr = i18n("建筑内生命加成")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 9 then
			nameStr = i18n("可持有士兵总上限")
			numStr = skillVal
		end
		soldierRushRead = i18n("soldier_rush_text_18", i18n(cfg.SkillName))
		i18n("soldier_rush_text_18", i18n(cfg.SkillName)).name = nameStr
		i18n("soldier_rush_text_18", i18n(cfg.SkillName)).num = numStr
		self.fields.Text_des:setString(i18n("soldier_rush_text_25") .. i18n(cfg.UnactiveDesc, i18n("soldier_rush_text_18", i18n(cfg.SkillName))))
	else
		local skillType = cfg.ActiveSkillType
		local skillVal = 100
		if skillType == 1 then
			nameStr = i18n("击杀士兵")
			numStr = skillVal
		elseif skillType == 2 then
			nameStr = i18n("补充士兵")
			numStr = skillVal
		elseif skillType == 3 then
			nameStr = i18n("改变士兵状态")
			numStr = skillVal
		elseif skillType == 4 then
			nameStr = i18n("改变建筑状态")
			numStr = skillVal
		elseif skillType == 5 then
			nameStr = i18n("增加士兵属性")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 6 then
			nameStr = i18n("减少士兵属性")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 7 then
			nameStr = i18n("增加建筑属性")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 8 then
			nameStr = i18n("减少建筑属性")
			numStr = skillVal / 10 .. "%"
		elseif skillType == 0 then
			nameStr = ""
			numStr = skillVal
		end
		soldierRushRead = i18n("soldier_rush_text_18", i18n(cfg.SkillName))
		i18n("soldier_rush_text_18", i18n(cfg.SkillName)).name = nameStr
		i18n("soldier_rush_text_18", i18n(cfg.SkillName)).num = numStr
		self.fields.Text_des:setString(i18n("soldier_rush_text_26") .. i18n(cfg.ActiveDesc, i18n("soldier_rush_text_18", i18n(cfg.SkillName))))
	end
end
return Com_skillInfo
