local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local Com_runeChoose = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/Com_runeChoose", Com_runeChoose)
function Com_runeChoose:onInit()
	self.isChoose = false
	self:addClickListener(handler(self, self.onClick))
end
function Com_runeChoose:onShow()
end
function Com_runeChoose:initData(data, isChoose, tag)
	self.data = data
	self.isChoose = isChoose
	self.tag = tag
	self.fields.single:initData(self.data)
	self.controllers.c1:setSelectedIndex(self.isChoose and 1 or 0)
end
function Com_runeChoose:onClick()
	SoraDPlaySound()
	local choose = function()
		self.isChoose = not self.isChoose
		self.controllers.c1:setSelectedIndex(self.isChoose and 1 or 0)
		self = self.controllers.c1
		self.controllers.c1.msg = "MESSAGE_UI_RUNE_INHERIT_CHOOSE"
		self.controllers.c1.data = self.data
		self.controllers.c1.isChoose = self.isChoose
		SoraDSendMessage(self.controllers.c1)
	end
	if self.data.isWear then
		SoraDShowMsgBox(i18n("Weapon_Rune_tips_048"), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				local wearRuneInfo = godArmsRuneCtrl:getWearRuneInfo(self.data.uid)
				godArmsRuneCtrl:sendTakeoff(wearRuneInfo.armid, wearRuneInfo.cell, wearRuneInfo.group)
				if not self.data.isLock then
					choose()
				else
					_ENV = godArmsRuneCtrl
					godArmsRuneCtrl.msg = "MESSAGE_UI_RUNE_INHERIT_CHOOSE"
					godArmsRuneCtrl.data = self.data
					godArmsRuneCtrl.isChoose = false
					SoraDSendMessage(godArmsRuneCtrl)
				end
			end
		end)
	elseif self.data.isLock and self.tag == 0 then
		SoraDShowMsgBox(i18n("Weapon_Rune_tips_031"), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				SoraDCheckSecondaryLock(function()
					godArmsRuneCtrl:sendLock(self.data.uid, 0)
					choose()
				end, gSecondaryLockType.ArmsRuneUnlock)
			end
		end)
	else
		choose()
	end
end
return Com_runeChoose
