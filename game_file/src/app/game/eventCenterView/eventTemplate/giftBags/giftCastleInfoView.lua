local gametop = gModuleMgr.getObject("gametop")
local giftCastleInfoView = class("giftCastleInfoView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("giftCastleInfoView")
end)
function giftCastleInfoView:ctor()
	self.isAddToPopManager = true
	SoraDGetChildByName(self, "Text_name"):setString(i18n("common_text_4030"))
	self.btnLook = SoraDGetChildByName(self, "Button_Look")
	self.btnLook:addTouchEventListener(handler(self, self.btnClickLook))
	self.btnLook:setTitleText(i18n("common_text_477"))
	self.textInfo = SoraDGetChildByName(self, "Text_Info")
	self.textInfo:setString(i18n("castle_privilege_text_02"))
	SoraDGetAutoHeightLabel(self.textInfo, 480)
	local lang = SoraDGetDefaultLanguage()
	local bgName = string.format("font_castleprivilege_01_%s.png", lang)
	print(bgName, "bgName")
	local spTitle = SoraDGetChildByName(self, "img_title")
	spTitle:setSpriteFrame(bgName)
	spTitle:setPositionY(self.textInfo:getPositionY() + self.textInfo:getContentSize().height + 10)
end
function giftCastleInfoView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function giftCastleInfoView:btnClickLook(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
			_ENV = nil
			;(nil).lv = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("castle_privilige_tips_05", nil))
		else
			local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
			local gift = privilegeGiftCtrl:getCurCanBuyRechargeID()
			if gift and next(gift) then
				_ENV = i18n("castle_privilige_tips_05", nil)
				i18n("castle_privilige_tips_05", nil).privilegeType = gRechargePrivilegeType.castle
				i18n("castle_privilige_tips_05", nil).title = i18n("common_text_4030")
				i18n("castle_privilige_tips_05", nil).fromCenter = gRechargeActiveFromEnum.ROAD14
				uiManager:show("MagicLampPrivilegeView", i18n("castle_privilige_tips_05", nil))
			end
		end
		self:close(self, type)
	end
end
function giftCastleInfoView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_PRIVILEGE_GIFT_ACTIVITY) then
		self:layerClickCallBack(self, ccui.TouchEventType.ended)
	end
end
return giftCastleInfoView
