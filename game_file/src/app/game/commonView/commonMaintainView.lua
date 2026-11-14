local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local commonMaintainView = class("commonMaintainView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonMaintainView")
	end
	return target
end)
function commonMaintainView:ctor()
	self:setBackGround(178.5, cc.c3b(0, 0, 0))
	_ENV = self
	self.msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
	self.onEnter = true
	self.opacity = self:getBackGroundColorOpacity()
	SoraDSendMessage(self)
	self.fanPageHomeURL = gSvrConfig.facebookHomepage
	self.text_title = SoraDGetChildByName(self, "Text_title")
	self.text_title:setString(i18n("common_text_541"))
	self.dh_left = SoraDGetChildByName(self, "Image_left")
	self.dh_right = SoraDGetChildByName(self, "Image_right")
	self.dh_bg = SoraDGetChildByName(self, "Image_tbg")
	self.node_time = SoraDGetChildByName(self, "Node_time")
	self.node_time:setVisible(false)
	self.text_curTime = SoraDGetChildByName(self, "Text_curSvrTime")
	self.text_curTime:setString(i18n("common_text_2633"))
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.panel_web = SoraDGetChildByName(self, "Panel_web")
	self.btn_facebook = SoraDGetChildByName(self, "Button_facebook")
	self.btn_facebook:addTouchEventListener(handler(self, self.toFanPage))
	self.node_facebook = SoraDGetChildByName(self, "Node_facebook")
	self.icon_facebook = SoraDGetChildByName(self, "icon_facebook")
	self.text_facebook = SoraDGetChildByName(self, "Text_facebook")
	self.text_facebook:setString(i18n("common_text_2634"))
	SoraDToCenter(self.node_facebook, 10, SoraDFIsRA())
	if userSDKManager.isKO() then
		if SoraDGetDefaultLanguage() == "ko" then
			self.text_facebook:setString("공식카페")
		else
			self.text_facebook:setString("Naver Cafe")
		end
		self.icon_facebook:setSpriteFrame("icon_community_korea.png")
		self.icon_facebook:setScale(0.07)
		self.icon_facebook:setPositionX(-70)
	end
	self:suitView()
end
function commonMaintainView:suitView()
	self.dh_left:setPositionX(math.min(self.text_title:getPositionX() - self.text_title:getContentSize().width / 2 - 20, -80))
	self.dh_right:setPositionX(math.max(self.text_title:getPositionX() + self.text_title:getContentSize().width / 2 + 20, 80))
	self.dh_bg:setContentSize(cc.size(math.max(160, self.text_title:getContentSize().width), 50))
end
function commonMaintainView:loadWeb(webUrl)
	if webUrl then
		local size = self.panel_web:getContentSize()
		self.webView = ccexp.WebView:create()
		self.webView:setContentSize(cc.size(size.width, size.height))
		self.webView:setPosition(0, 0)
		self.panel_web:addChild(self.webView, 1)
		self.webView:setScalesPageToFit(true)
		self.webView:setBGIsAlpha(true)
		self.webView:loadURL(webUrl)
	end
end
function commonMaintainView:initData(time)
	self.time = time
	self.node_time:setVisible(true)
	self.time = self.time - 1
	self:updateTime()
	SoraDToCenter(self.node_time, 10, SoraDFIsRA())
	if not self.timeHandle then
		self.timeHandle = schedulerTime.scheduleGlobal(function(dt)
			self:updateTime(dt)
		end, 1.0)
	end
end
function commonMaintainView:updateTime(dt)
	self.text_time:setString(os.date("!%Y-%m-%d %H:%M:%S", self.time))
	self.time = self.time + 1
end
function commonMaintainView:toFanPage(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.hasLink then
			if IsArClient then
				userSDKManager.openWithFacebook("fb://facewebmodal/f?href=" .. self.fanPageHomeURL, self.fanPageHomeURL)
			else
				userSDKManager.openWithFacebook("fb://page/945786632178612", "https://fb.me/revengeofsultans")
			end
		else
			local feedType = "Maintenance"
			userSDKManager.openFeedback(feedType)
		end
	end
end
function commonMaintainView:setLink(link)
	print("==commonMaintainView:setLink==", link)
	if link then
		self.hasLink = true
		self.fanPageHomeURL = link
	end
end
function commonMaintainView:initContentLabel()
	self.txt_content:setVisible(true)
	self.txt_content:setString(i18n("common_text_1122"))
	self.txt_content:setTextHorizontalAlignment(SoraDFLabelR())
end
function commonMaintainView:onExitPanel()
	if self.timeHandle then
		schedulerTime.unscheduleGlobal(self.timeHandle)
		self.timeHandle = nil
	end
end
return commonMaintainView
