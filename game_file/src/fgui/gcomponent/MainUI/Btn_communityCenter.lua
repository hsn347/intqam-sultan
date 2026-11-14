local baseComponent = require("fgui.base.baseComponent")
local Btn_communityCenter = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_communityCenter", Btn_communityCenter)
function Btn_communityCenter:onInit()
	self.text_time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_communityCenter:onShow()
end
function Btn_communityCenter:initData(info)
	self.info = info
	local showType = self.info.param.show
	self.controllers.c1:setSelectedIndex(showType - 1)
	if self.info.param.type == 1 then
		self.text_time:beginTime(self.info.endtime - serviceFunctions.systemTime())
	end
end
function Btn_communityCenter:onBtnClick()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound[gActivityCenterUIEnum.COMMUNITY_CENTER_1] = "https://www.facebook.com/slateen/"
	SoraDPlaySound[gActivityCenterUIEnum.COMMUNITY_CENTER_2] = "https://www.instagram.com/revengeofsultans/"
	local SoraDPlaySound[gActivityCenterUIEnum.COMMUNITY_CENTER_3], localUrl = "https://twitter.com/EntkamElSlaten", SoraDPlaySound
	if self.info.url and self.info.url ~= "" then
		userSDKManager.openSDKLink(self.info.url)
	elseif self.info.show == gActivityCenterUIEnum.COMMUNITY_CENTER_4 or self.info.show == gActivityCenterUIEnum.COMMUNITY_CENTER_5 then
		userSDKManager.showSocial()
	else
		userSDKManager.openSDKLink(localUrl[self.info.show])
	end
	local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
	activityCenterUICtrl:sendClearNewMsg(gActivityTimeActivityID.COMMUNITY_CENTER_MAIN_UI)
end
return Btn_communityCenter
