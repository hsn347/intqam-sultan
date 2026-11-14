local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_gate = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SoldierRush/Btn_gate", Btn_gate)
function Btn_gate:onInit()
	self:addClickListener(handler(self, self.onGateClick))
end
function Btn_gate:onShow()
end
function Btn_gate:initData(chapter, gate)
	self.chapter = tonumber(chapter)
	self.gate = tonumber(gate)
	self.id = soldierRushRead.getLevelID(self.chapter, self.gate)
	_ENV = nil
	;(nil).var1 = self.chapter
	;(nil).var2 = self.gate
	self.fields.Text_gate:setString(i18n("%{var1}-%{var2}", nil))
	local status = 0
	local toID = soldierRushRead.getChapterLevel(soldierRushCtrl:getToGateIndex())
	if self.id == toID then
		status = 1
	end
	if soldierRushCtrl:getGateRecord(self.id) then
		status = 2
		self.fields.Com_star:initData(soldierRushCtrl:getGateStars(self.id))
	end
	self.controllers.c1:setSelectedIndex(status)
end
function Btn_gate:onGateClick()
	if not soldierRushCtrl:isGateUnlock(self.id) then
		local frontCfg = soldierRushRead.getLevelFrontCfg(self.chapter, self.gate)
		soldierRushCtrl = nil
		;(nil).num1 = frontCfg.Chapter
		;(nil).num2 = frontCfg.LevelId
		SoraDShowMsgTip(i18n("soldier_rush_text_05", nil))
	else
		soldierRushCtrl = i18n("soldier_rush_text_05", nil)
		i18n("soldier_rush_text_05", nil).id = self.id
		i18n("soldier_rush_text_05", nil).chapter = self.chapter
		i18n("soldier_rush_text_05", nil).gate = self.gate
		uiManager:show("SoldierRushGateInfo", i18n("soldier_rush_text_05", nil))
	end
end
return Btn_gate
