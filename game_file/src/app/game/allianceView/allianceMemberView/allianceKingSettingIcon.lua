local gametop = gModuleMgr.getObject("gametop")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceKingSettingIcon = class("allianceKingSettingIcon", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceKingSettingIcon")
	end
	return target
end)
function allianceKingSettingIcon:ctor()
	self.pID = 0
	self.tableSingleData, _ENV, self.curID = nil, nil, nil
	self.labelName = SoraDGetChildByName(self, "Text_title")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.btnIcon = SoraDGetChildByName(self, "Button_icon")
	if self.btnIcon then
		self.btnIcon:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function allianceKingSettingIcon:initData(pID, tableSingleData)
	self.pID = pID
	self.tableSingleData = tableSingleData
	self.labelName:setString(allianceDesRead.getPermissionName(self.pID))
	self.spriteIcon:setSpriteFrame(allianceDesRead.getPermissionIcon(self.pID))
end
function allianceKingSettingIcon:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
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
