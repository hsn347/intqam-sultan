local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillSetSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_skillSetSingle", Com_skillSetSingle)
function Com_skillSetSingle:onInit()
	self.skillID = nil
	self:addClickListener(handler(self, self.onClick))
	self.fields.Btn_reduce:addClickListener(handler(self, self.onRemoveClick))
end
function Com_skillSetSingle:onShow()
end
function Com_skillSetSingle:updateData(index, skillID)
	if skillID then
		self.skillID = skillID
		self.controllers.c1:setSelectedIndex(0)
		local cfg = soldierRushRead.getSkillCfg(skillID)
		self.fields.icon:setSpriteFrame(cfg.SkillIcon)
		self.fields.qualityBg:setIcon(heroltCtrl.getBg(cfg.SkillQuality))
	else
		self.skillID = nil
		if self.controllers.c1:getSelectedIndex() == 2 then
		else
			self.controllers.c1:setSelectedIndex(1)
		end
	end
end
function Com_skillSetSingle:initData(index, status, skillID)
	print("index,status,skillID====", index, status, skillID)
	self.index = index
	self.controllers.c1:setSelectedIndex(status)
	local skillSlotData = soldierRushCtrl:getSkillSlot()
	if skillID then
		self.skillID = skillID
		local cfg = soldierRushRead.getSkillCfg(skillID)
		self.fields.icon:setSpriteFrame(cfg.SkillIcon)
		self.fields.qualityBg:setIcon(heroltCtrl.getBg(cfg.SkillQuality))
	end
end
function Com_skillSetSingle:getData()
	return self.controllers.c1:getSelectedIndex(), self.skillID
end
function Com_skillSetSingle:onClick()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 2 then
		local cfgID = soldierRushRead.getConstantVal("Unlock_Hero_Slot" .. self.index)
		local lvCfg = soldierRushRead.getLevelCfg(cfgID)
		_ENV = nil
		;(nil).num1 = lvCfg.Chapter
		;(nil).num2 = lvCfg.LevelId
		SoraDShowMsgTip(i18n("soldier_rush_text_16", nil))
		return
	end
	_ENV = soldierRushRead.getLevelCfg(cfgID)
	soldierRushRead.getLevelCfg(cfgID).msg = "MESSAGE_SOLDIERRUSH_UI_SKILL_SLOT_INDEX"
	soldierRushRead.getLevelCfg(cfgID).index = self.index
	SoraDSendMessage((soldierRushRead.getLevelCfg(cfgID)))
end
function Com_skillSetSingle:onRemoveClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_SKILL_CHOOSE"
	SoraDSendMessage(nil)
end
return Com_skillSetSingle
