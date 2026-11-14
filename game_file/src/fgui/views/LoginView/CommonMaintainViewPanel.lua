local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonMaintainViewPanel = class("CommonMaintainViewPanel", baseFguiPanel)
function CommonMaintainViewPanel:ctor(...)
	CommonMaintainViewPanel.super.ctor(self, ...)
	print("CommonMaintainViewPanel:ctor", self.viewName)
end
function CommonMaintainViewPanel:onInit()
	print("=======CommonMaintainViewPanel:onInit")
	_ENV = "=======CommonMaintainViewPanel:onInit"
	;("=======CommonMaintainViewPanel:onInit").msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
	;("=======CommonMaintainViewPanel:onInit").onEnter = true
	;("=======CommonMaintainViewPanel:onInit").opacity = self:getBackGroundColorOpacity()
	SoraDSendMessage("=======CommonMaintainViewPanel:onInit")
	self.fanPageHomeURL = gSvrConfig.facebookHomepage
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.panel_web = SoraDGetChildByName(self, "Panel_web")
	self.btn_facebook = SoraDGetChildByName(self, "Button_facebook")
	self.btn_facebook:setTitle(i18n("common_text_2634"))
	self.btn_facebook:addClickEventListener(handler(self, self.toFanPage))
	if userSDKManager.isKO() then
		if SoraDGetDefaultLanguage() == "ko" then
			self.btn_facebook:setTitle("공식카페")
		else
			self.btn_facebook:setTitle("Naver Cafe")
		end
		self.btn_facebook:setIcon("icon_community_korea.png")
	end
end
function CommonMaintainViewPanel:onShow()
	print("=======CommonMaintainViewPanel:onShow")
end
function CommonMaintainViewPanel:onHide()
	if self.timeHandle then
		schedulerTime.unscheduleGlobal(self.timeHandle)
		self.timeHandle = nil
	end
end
function CommonMaintainViewPanel:loadWeb(webUrl)
	if webUrl and display.platform ~= "mac" then
		local size = self.panel_web:getContentSize()
		self.webView = ccexp.WebView:create()
		self.webView:setContentSize(cc.size(size.width, size.height))
		self.webView:setPosition(0, 0)
		self.panel_web:addChild(self.webView)
		self.webView:setScalesPageToFit(true)
		self.webView:setBGIsAlpha(true)
		self.webView:loadURL(webUrl)
	end
end
function CommonMaintainViewPanel:initData(time)
	self.time = time
	self.time = self.time - 1
	self:updateTime()
	if not self.timeHandle then
		self.timeHandle = schedulerTime.scheduleGlobal(function(dt)
			self:updateTime(dt)
		end, 1.0)
	end
end
function CommonMaintainViewPanel:updateTime(dt)
	self.text_time:setString(i18n("common_text_2633") .. " " .. os.date("!%Y-%m-%d %H:%M:%S", self.time))
	self.time = self.time + 1
end
function CommonMaintainViewPanel:toFanPage(target, event)
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
function CommonMaintainViewPanel:setLink(link)
	print("==CommonMaintainViewPanel:setLink==", link)
	if link then
		self.hasLink = true
		self.fanPageHomeURL = link
	end
end
return CommonMaintainViewPanel
