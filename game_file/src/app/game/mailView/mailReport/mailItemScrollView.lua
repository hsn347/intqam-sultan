local mailCtrl = SoraDGetCtrl("mailCtrl")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailItemScrollView = class("mailItemScrollView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemScrollView"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
_ENV = "mailItemScrollView"
;("mailItemScrollView").win = 0
;("mailItemScrollView").faild = 1
local ("mailItemScrollView").invalid, FIGHT_RESULT = 2, "mailItemScrollView"
function mailItemScrollView:onExitOther()
	self:cleanAll()
end
function mailItemScrollView:ctor()
	self:setCascadeOpacityEnabled(true)
	self:setAnchorPoint(cc.p(0, 0))
	self.mailType = 0
	self.mailSetType = 0
	self.heightNotice = 52
	self.heightEnableNotice = 55
	self.heightTopAutoScroll = 100
	self.hasMore = true
	self.itemsData, _ENV, self.historyData, _ENV, self.recycledListInvalid, _ENV, self.recycledListFail, _ENV, self.recycledListWin, _ENV, self.recycleList, _ENV, self.needRequestMore = self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, self.setAnchorPoint, false
	self.scrollView = SoraDGetChildByName(self, "Size_scrollView")
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self:setContentSize(self.scrollView:getContentSize())
end
function mailItemScrollView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_REQ_MAIL_TYPE_LIST_BACK", handler(self, self.refreshScrollData))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_NEW_MAIL", handler(self, self.refreshViewByNewMail))
end
function mailItemScrollView:createMailTitleInfo()
	local panel = include("mailItemDetailTitleInfo").new()
	panel:initWithData(self.mail)
	panel:addTo(self.scrollView:getInnerContainer())
	return panel
end
function mailItemScrollView:refreshScrollData(target, data)
