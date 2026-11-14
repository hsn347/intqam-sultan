local funUnlockRead = include("funUnlockRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_alliance = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_alliance", Btn_alliance)
function Btn_alliance:onInit()
	self.unlockKey = gFunBuildKey.ALLIANCE
	self.fields.mv_join:setAllFrameName("et_alliance_newjoin_%.2d.png", 1)
	self.fields.title:setString(i18n("common_text_069"))
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.lab_red:setVisible(false)
end
function Btn_alliance:onShow()
end
function Btn_alliance:setRed(num)
	self.fields.lab_red:setTitle(num)
	self.fields.lab_red:setVisible(0 < num)
end
function Btn_alliance:setBtnName(name)
	self.fields.title:setString(name)
end
function Btn_alliance:isShowJoinGold(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
function Btn_alliance:isShowInWar(ret)
	self.controllers.c2:setSelectedIndex(ret and 1 or 0)
end
function Btn_alliance:setStatus()
	local unlockLv = funUnlockRead.getUnlockLevel(self.unlockKey)
	self.controllers.c3:setSelectedIndex(unlockLv <= SoraDGetCastleLv() and 0 or 1)
end
function Btn_alliance:onBtnClick()
	if self.isEmpty then
		return
	end
	local unlockLv = funUnlockRead.getUnlockLevel(self.unlockKey)
	if unlockLv <= SoraDGetCastleLv() then
		SoraDPlaySound("uicontrol", 29)
		local worldMapWarDef = include("worldMapWarDef")
		worldMapWarDef.onClickBtnAlliance()
	else
		SoraDPlaySound("uicontrol", 20)
		funUnlockRead = nil
		;(nil).name = i18n("common_text_069")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	end
end
function Btn_alliance:isEmptyModel(ret)
	self.isEmpty = ret
	if self.isEmpty then
		self.fields.lab_red:setVisible(false)
	end
	self.fields.mv_join:setVisible(not self.isEmpty)
	self.fields.fight:setVisible(not self.isEmpty)
end
return Btn_alliance
