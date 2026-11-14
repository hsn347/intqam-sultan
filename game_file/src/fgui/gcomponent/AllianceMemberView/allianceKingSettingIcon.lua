local allianceDesRead = include("allianceDesRead")
local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceKingSettingIcon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceMemberView/allianceKingSettingIcon", allianceKingSettingIcon)
function allianceKingSettingIcon:onInit()
	self.pID = 0
	self.tableSingleData, _ENV, self.curID = nil, nil, nil
	self:addClickListener(handler(self, self.btnClick))
end
function allianceKingSettingIcon:onShow()
end
function allianceKingSettingIcon:initData(pID, tableSingleData)
	self.pID = pID
	self.tableSingleData = tableSingleData
	self.fields.title:setString(allianceDesRead.getPermissionName(self.pID))
	self.fields.icon:setSpriteFrame(allianceDesRead.getPermissionIcon(self.pID))
end
function allianceKingSettingIcon:btnClick()
	SoraDPlaySound()
	self.curID = self.pID
	_ENV = nil
	;(nil).name = self.tableSingleData:getProperty("nickName")
	msg = i18n("common_text_1186", nil)
	SoraDShowMsgBox(msg, i18n("common_text_054"), nil, function(type)
		if type == MSGBOX_CALLBACK_YES then
			SoraDShowMsgBox(i18n("common_text_1185"), i18n("common_text_054"), nil, handler(self, self.makeSure))
		end
	end)
end
function allianceKingSettingIcon:makeSure(type)
	if type == MSGBOX_CALLBACK_YES then
		local uid = self.tableSingleData:getProperty("uid")
		KWKingdomCtrl:appiontKing(uid)
		self:closeSettingView(uid)
	end
end
function allianceKingSettingIcon:closeSettingView(uid)
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIACNE_MEMBER_SETTING_CLOSE"
	;(nil).uid = uid
	SoraDSendMessage(nil)
end
return allianceKingSettingIcon
