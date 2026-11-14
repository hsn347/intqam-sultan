local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local CommonSystemMsgBox = class("commonSystemMsgBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSystemMsgBox")
	end
	return target
end)
function CommonSystemMsgBox:ctor()
	_ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	SoraDGetChildByName(self, "Center_Node").download = 1
	SoraDGetChildByName(self, "Center_Node").willing = 2
	SoraDGetChildByName(self, "Center_Node").fanspage = 3
	self.showType, SoraDGetChildByName(self, "Center_Node").predownload = SoraDGetChildByName(self, "Center_Node"), 4
	self.style = 0
	self.callYesHandl = nil
	self.callNoHandl = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.scroll = SoraDGetChildByName(self, "ScrollView_msg")
	self.txtMsg = SoraDGetChildByName(self, "Text_msg")
	self.txtMsg:setString(i18n("common_text_939"))
	self.btnYes = SoraDGetChildByName(self, "Button_yes")
	self.node_fanpage = SoraDGetChildByName(self, "Node_fanpage")
	self.node_fanpage:setVisible(false)
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTime:setVisible(false)
	self.txtCurTime = SoraDGetChildByName(self, "Text_curSvrTime")
	self.txtCurTime:setString(i18n("common_text_2633"))
	self.labTime = SoraDGetChildByName(self, "Text_time")
	self.labTime = SoraDCreateTimerLabel(self, self.labTime)
	self.btnNo = SoraDGetChildByName(self, "Button_no")
	self.btnYes:addTouchEventListener(handler(self, self.btnYesClick))
	self.btnNo:addTouchEventListener(handler(self, self.btnNoClick))
	SoraDAutoSizeButtonText(self.btnYes, cc.size(215, 70))
	SoraDAutoSizeButtonText(self.btnNo, cc.size(215, 70))
	self:setBackGround(127.5)
	self:setContentSize(display.realSize)
	self:setAnchorPoint(cc.p(0.5, 0))
	self:setPosition(cc.p(display.cx, 0))
end
function CommonSystemMsgBox:setViewType(style)
	self.style = style
	self:initView()
end
function CommonSystemMsgBox:initView()
	if self.style == self.showType.download then
		local txt = i18n("common_text_3523")
		if not userSDKManager.isAR() then
			if device.platform == "ios" then
				txt = i18n("updata_tips_text_01")
			elseif device.platform == "android" then
				txt = i18n("updata_tips_text_02")
			end
		end
		self.txtMsg:setString(txt)
		self.btnYes:setTitleText(i18n("common_text_900"))
		self.btnNo:setTitleText(i18n("common_text_2102"))
	elseif self.style == self.showType.willing then
		self.txtMsg:setString(i18n("common_text_899"))
		self.btnYes:setTitleText(i18n("common_text_900"))
		self.btnNo:setTitleText(i18n("common_text_2973"))
	elseif self.style == self.showType.predownload then
		self.btnYes:setTitleText(i18n("common_text_900"))
		self.btnNo:setVisible(false)
		self.btnYes:setPositionX(0)
		self.btnNo:setPositionX(0)
	elseif self.style == self.showType.fanspage then
		self.timeHandle = nil
		self.txtFunpage = SoraDGetChildByName(self, "Text_fanpage")
		self.txtFunpage:setString(i18n("common_text_2634"))
		self.Sprite_facebook = SoraDGetChildByName(self, "Sprite_facebook")
		function self.callYesHandl()
			device.openURL(gSvrConfig.facebookHomepage)
		end
		self.btnNo:setVisible(false)
		self.btnYes:setPositionX(0)
		self.btnNo:setPositionX(0)
		local channel = userSDKManager.getChannel()
		if channel == "fa" then
			self.txtFunpage:setString("Telegram")
			self.Sprite_facebook:setSpriteFrame("icon_telegram_login.png")
			function self.callYesHandl()
				device.openURL("https://t.me/Magnetgame_ROS")
			end
		end
		self.node_fanpage:setVisible(true)
		SoraDToCenter(self.node_fanpage)
	end
end
function CommonSystemMsgBox:initData(table)
	if table and table.handle_yes then
		self.callYesHandl = table.handle_yes
	end
	if table and table.handle_no then
		self.callNoHandl = table.handle_no
	end
	if table and table.time then
		if table.msg and string.len(table.msg) > 0 then
			self.txtMsg:setString(table.msg)
		end
		self.time = table.time
		self.nodeTime:setVisible(true)
		self.time = self.time - 1
		self:updateTime()
		SoraDToCenter(self.nodeTime)
		self.timeHandle = schedulerTime.scheduleGlobal(function(dt)
			self:updateTime(dt)
		end, 1.0)
	end
	if table.content then
		self.txtMsg:setString(table.content)
	end
	local labelDesH = SoraDGetAutoHeightLabel(self.txtMsg)
	self.scroll:setPositionY(self.nodeTime:isVisible() and 0 or -40)
	self.scroll:setContentSize(cc.size(520, self.nodeTime:isVisible() and 200 or 240))
	self.scroll:setInnerContainerSize(cc.size(520, labelDesH))
	self.scroll:setBounceEnabled(labelDesH > self.scroll:getContentSize().height)
	self.txtMsg:setPositionY(math.max(labelDesH / 2, self.scroll:getContentSize().height / 2))
end
function CommonSystemMsgBox:updateTime(dt)
	self.labTime:setString(os.date("!%Y-%m-%d %H:%M:%S", self.time))
	self.time = self.time + 1
end
function CommonSystemMsgBox:btnYesClick(button, event)
	if event == ccui.TouchEventType.ended and self.callYesHandl then
		self.callYesHandl(self)
	end
end
function CommonSystemMsgBox:btnNoClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.callNoHandl then
			self.callNoHandl(self)
		else
			print("关掉自己====")
			self:close(nil, ccui.TouchEventType.ended)
		end
	end
end
function CommonSystemMsgBox:onExitPanel()
	if self.timeHandle then
		schedulerTime.unscheduleGlobal(self.timeHandle)
		self.timeHandle = nil
	end
end
return CommonSystemMsgBox
