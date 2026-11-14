local princeGiftRead = include("princeGiftRead")
local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
local princeGiftBuffStrengthenView = class("princeGiftBuffStrengthenView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("princeGiftBuffStrengthenView")
	end
	return target
end)
singleNodeH = 100
function princeGiftBuffStrengthenView:ctor()
	self:initControls()
	self:initData()
end
function princeGiftBuffStrengthenView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.activityID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
	self.Text_name:setString(i18n("Wisdom_of_oriental_prince_text_01"))
	self.Text_ins:setString(i18n("Wisdom_of_oriental_prince_text_10"))
	self.Text_effect:setString(i18n("Wisdom_of_oriental_prince_text_23"))
	self.Text_one:setString(i18n("Wisdom_of_oriental_prince_text_12"))
	self.Text_already:setString(i18n("Wisdom_of_oriental_prince_text_14"))
	SoraDSetTextWidthHeight(self.Text_one, cc.size(520, 60))
	self.Text_one:setFontSize(16)
	SoraDChangeTextToHtml(self.Text_upgrade)
	self.Text_inmedia = SoraDCreateTimerLabel(self, self.Text_inmedia)
	local remainTime = princeGiftCtrl:getBuffEndTime() - serviceFunctions.systemTime()
	self.Text_inmedia:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	if 0 < remainTime then
		self.Text_inmedia:beginTime(remainTime)
	end
	self.Button_strengthen:setTitleText(i18n("Wisdom_of_oriental_prince_text_13"))
	self.Button_strengthen:addTouchEventListener(handler(self, self.onStrengthenClick))
end
function princeGiftBuffStrengthenView:initData()
	local totalTime = princeGiftRead.getStrengthBuffTotalTime() / 60
	local packageInfo = princeGiftRead.getFirstPackageInfo()
	self.Text_already:setVisible(0 < totalTime)
	self.Button_strengthen:setVisible(totalTime <= 0)
	self.Text_one:setVisible(totalTime <= 0)
	princeGiftRead = nil
	;(nil).num1 = 30 + totalTime
	princeGiftRead, princeGiftRead, (nil).num2 = nil, packageInfo.buffTime / 86400, packageInfo.buffTime / 86400
	princeGiftRead, (packageInfo.buffTime / 86400).num1, (nil).color = nil, nil, "#00FF00"
	princeGiftRead, (packageInfo.buffTime / 86400).num2, (nil).color = nil, nil, "#00FF00"
	;(packageInfo.buffTime / 86400).__default, (nil).color = nil, "#FAD26E"
	self.Text_upgrade:setString(i18n_html("Wisdom_of_oriental_prince_text_11", nil, packageInfo.buffTime / 86400))
	self.Text_already:setPositionX(self.Text_effect:getPositionX() - SoraDFSign(self.Text_effect:getContentSize().width / 2) - SoraDFSign(self.Text_already:getContentSize().width / 2) - SoraDFSign(10))
end
function princeGiftBuffStrengthenView:onStrengthenClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if clientEventMgr.judgeIsOpen(self.activityID, true) then
			clientEventMgr.singleClickEvent(self.activityID, 3)
		end
		self:removeFromParent()
	end
end
return princeGiftBuffStrengthenView
