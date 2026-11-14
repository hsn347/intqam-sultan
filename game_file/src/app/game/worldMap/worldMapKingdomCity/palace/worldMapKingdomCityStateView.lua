local WorldMapKingdomCityStateView = class("worldMapKingdomCityStateView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapKingdomCityStateView")
	end
	return target
end)
function WorldMapKingdomCityStateView:ctor()
	self.timer = nil
	self.timerCount = 0
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapKingdomCityBg_bg")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtExplain = SoraDGetChildByName(self, "Text_explain")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtExplain:setString(i18n("common_text_1215"))
	self.Text_warn = SoraDGetChildByName(self, "Text_warn")
	self.Text_warn:setString(i18n("common_text_1133"))
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeEndListener(function(...)
		self:removeFromParent()
	end)
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnGift = SoraDGetChildByName(self, "Button_gift")
	self.btnGift:setTitleText(i18n("kindofwar_btn_01"))
	self.btnGift:addTouchEventListener(handler(self, self.btnGiftClick))
end
function WorldMapKingdomCityStateView:initView(warStatusTime)
	local coolTime = warStatusTime
	if not coolTime then
		local gametop = gModuleMgr.getObject("gametop")
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		coolTime = kingdomMapCtrl:getWarStatusTime()
	end
	if 0 < coolTime then
		self.txtTime:beginTime(coolTime)
	else
		self.txtTime:endTime()
	end
	self.txtTitle:setString(i18n("common_text_839"))
end
function WorldMapKingdomCityStateView:stopTime()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
		self.txtTime:setString(i18n("common_text_699"))
	end
end
function WorldMapKingdomCityStateView:btnHelpClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.KINGDOM_WAR)
	end
end
function WorldMapKingdomCityStateView:btnGiftClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
		_ENV = nil
		;(nil).viewType = 1
		panel:init(nil)
		panel:show()
	end
end
return WorldMapKingdomCityStateView
