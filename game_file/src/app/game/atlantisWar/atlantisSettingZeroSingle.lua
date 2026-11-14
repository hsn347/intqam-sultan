local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisSettingZeroSingle = class("atlantisSettingZeroSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisSettingZeroSingle")
	end
	return target
end)
function atlantisSettingZeroSingle:ctor()
	self:initWidget()
end
function atlantisSettingZeroSingle:initWidget(...)
	self.ccs_member = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisMemberSingle")
	self.ccs_member:setShowOnline(false)
	local Button_change = SoraDGetChildByName(self, "Button_change")
	Button_change:setTitleText(i18n("common_text_3889"))
	Button_change:addTouchEventListener(handler(self, self.btnChangeClick))
	SoraChangeButtonImage(Button_change, "btn_alliance_red.png")
end
function atlantisSettingZeroSingle:initData(data, otherData)
	self.data = data
	self.ccs_member:initData(data, otherData)
end
function atlantisSettingZeroSingle:btnChangeClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		atlantisActivityCtrl:reqRemoveLv0User(self.data.uid)
	end
end
return atlantisSettingZeroSingle
