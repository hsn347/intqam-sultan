local baseComponent = require("fgui.base.baseComponent")
local Com_MC_MarkBtn = fgui.extension_class(fgui.GButton, baseComponent)
local divineBeastMarkRead = include("divineBeastMarkRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkBtn1", Com_MC_MarkBtn)
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkBtn2", Com_MC_MarkBtn)
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkBtn3", Com_MC_MarkBtn)
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkBtn4", Com_MC_MarkBtn)
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkBtn5", Com_MC_MarkBtn)
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkBtn6", Com_MC_MarkBtn)
function Com_MC_MarkBtn:onInit()
	self:addClickEventListener(handler(self, self.onClick))
	self.fields.Usm_starUp:setCompleteCallback(function()
		self.fields.Usm_starUp:setVisible(false)
		self.fields.Usm_starUp:clearEffect()
	end)
end
function Com_MC_MarkBtn:initData(beastId, mark, slot, stepLv, isIgnoreChange)
	self.beastId = beastId
	self.unlockLv = divineBeastMarkRead.getSlotUnlock(beastId, slot)
	print("Com_MC_MarkBtn:initData", self.unlockLv, beastId, slot, stepLv)
	self.isMileStoneUnlock = divineBeastMarkCtrl:getSlotMileStoneUnlock(beastId, slot)
	if not self.isMileStoneUnlock then
		self.taskName = divineBeastMarkCtrl:getMilStoneTaskName(self.beastId, slot)
		if self.taskName == nil then
			self:setVisible(false)
			return
		end
	end
	self.mark = mark
	self.slot = slot
	self.stepLv = stepLv
	self:setReddot(false)
	if stepLv < self.unlockLv or not self.isMileStoneUnlock then
		self.controllers.c1:setSelectedIndex(0)
		divineBeastMarkRead = slot
		slot.lv = self.unlockLv
		self.fields.Txt_UnlockLv:setString(i18n("common_text_100", slot))
		self.fields.Txt_UnlockLv:setColor(self.unlockLv <= self.stepLv and cc.c3b(255, 255, 255) or cc.c3b(160, 40, 40))
		self.lastBeastId = nil
		return
	end
	if self.mark == nil or next(self.mark) == nil then
		self.controllers.c1:setSelectedIndex(1)
		self:setReddot(self:checkReddot())
		self.lastBeastId = nil
		return
	end
	self.controllers.c1:setSelectedIndex(2)
	divineBeastMarkRead = self:checkReddot()
	self:checkReddot().lv = self.mark.lv
	self.fields.Txt_lv:setString(i18n("common_text_100", self:checkReddot()))
	self.fields.icon:setURL(self.mark.markCfg.ui_icon or "frame_ssyj_feng.png")
	self.controllers.quality:setSelectedIndex(self.mark.markCfg.if_rare == 0 and self.mark.markCfg.quality or 0)
	if self.lastBeastId ~= nil and not isIgnoreChange and self.lastBeastId == self.beastId and self.lastBagMarkId == self.mark.bagMarkId then
		if self.lastLv < self.mark.lv then
			self.fields.Ani_sj:setVisible(true)
			self.fields.Ani_sj:setAllFrameNameOnce("ssyj_effect_sj_%02d.png", 1, false)
		elseif self.lastStar < self.mark.star then
			self.fields.Usm_starUp:clearEffect()
			self.fields.Usm_starUp:setVisible(true)
			self.fields.Usm_starUp:setEffectPath("ssyj_effect_sx.usm", false)
		end
	end
	self.lastBeastId = self.beastId
	self.lastBagMarkId = self.mark.bagMarkId
	self.lastLv = self.mark.lv
	self.lastStar = self.mark.star
end
function Com_MC_MarkBtn:checkReddot()
	local bagMarkList = divineBeastMarkCtrl:getBagMarkList()
	local slotMarkTypeMap = divineBeastMarkCtrl:getSlotMarkTypeMap()
	dump(slotMarkTypeMap, "slotMarkTypeMap")
	for k, mark in pairs(bagMarkList) do
		if mark.slot == nil and mark.markCfg and not slotMarkTypeMap[mark.markCfg.type] then
			return true
		end
	end
	return false
end
function Com_MC_MarkBtn:isLocked()
	return self.unlockLv > self.stepLv or not self.isMileStoneUnlock
end
function Com_MC_MarkBtn:setSelected(val)
	self.fields.selected:setVisible(val and self.unlockLv <= self.stepLv)
end
function Com_MC_MarkBtn:setClickCallback(callback)
	self.callback = callback
end
function Com_MC_MarkBtn:onClick()
	SoraDPlaySound()
	if self.unlockLv > self.stepLv then
		if not self.isMileStoneUnlock and self.taskName == nil then
			SoraDShowMsgTip(i18n("common_text_1260"))
		else
			_ENV = i18n("common_text_1260")
			i18n("common_text_1260").num = self.unlockLv
			SoraDShowMsgTip(i18n("Divine_beast_mark_text_13", i18n("common_text_1260")))
		end
		return
	end
	if not self.isMileStoneUnlock then
		if self.taskName == nil then
			SoraDShowMsgTip(i18n("common_text_1260"))
		else
			_ENV = i18n("common_text_1260")
			i18n("common_text_1260").name = self.taskName
			SoraDShowMsgTip(i18n("divine_beast_mark_slot_unlock", i18n("common_text_1260")))
		end
		return
	end
	if self.mark == nil or next(self.mark) == nil then
		_ENV = i18n("divine_beast_mark_slot_unlock", i18n("common_text_1260"))
		i18n("divine_beast_mark_slot_unlock", i18n("common_text_1260")).beastId = self.beastId
		i18n("divine_beast_mark_slot_unlock", i18n("common_text_1260")).slot = self.slot
		uiManager:show("DivineBeastMarkEquip", i18n("divine_beast_mark_slot_unlock", i18n("common_text_1260")))
	end
	if self.callback then
		self.callback(self.slot)
	end
end
return Com_MC_MarkBtn
