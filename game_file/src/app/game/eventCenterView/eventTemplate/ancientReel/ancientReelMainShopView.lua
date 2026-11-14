local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local ancientReelMainShopView = class("ancientReelMainShopView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
function ancientReelMainShopView:ctor()
	self.activityID = gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.txtToken = SoraDGetChildByName(self, "Text_token")
	self.txtActivieyTime = SoraDGetChildByName(self, "Text_activiey_time")
	self.img_icon = SoraDGetChildByName(self, "Image_icon")
	self.txtActivieyTime = SoraDCreateTimerLabel(self, self.txtActivieyTime)
	self.txtActivieyTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_4451", nil)
	end)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setIsRight(SoraDFIsRA())
	self.scroll:setSingleCCS("ancientReelMainShopSingle")
	self.tableCurItems, _ENV = self.scroll.setSingleCCS, self.scroll.setSingleCCS
end
function ancientReelMainShopView:init()
	SoraDCloseLoading(self)
	self:updateTokenInfo()
	self:updateActivityTime()
	self:initScrollList()
end
function ancientReelMainShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.init))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.init))
end
function ancientReelMainShopView:updateActivityTime()
	local time = ancientReelCtrl:getActivityStatusTime()
	if 0 < time then
		self.txtActivieyTime:beginTime(time)
	end
end
function ancientReelMainShopView:updateTokenInfo()
	local tokenNum = ancientReelCtrl:getKingTokenNum()
	ancientReelCtrl = nil
	;(nil).num = string.formatnumberthousands(tokenNum)
	self.txtToken:setString(i18n("Ancient_reel_text_08", nil))
	_UPVALUE3_ = i18n("Ancient_reel_text_08", nil)
	i18n("Ancient_reel_text_08", nil)[1] = self.img_icon
	i18n("Ancient_reel_text_08", nil)[2] = self.txtToken
	i18n("Ancient_reel_text_08", nil)[3] = self.btnHelp
	_UPVALUE2_ = self.txtToken
	self.txtToken[1] = 5
	self.txtToken[2] = 10
	_G.SoraDAlignNodeArrayOnCenterX(320, i18n("Ancient_reel_text_08", nil))
end
function ancientReelMainShopView:initScrollList()
	self:updateScrollData()
end
function ancientReelMainShopView:updateScrollData()
	if not activityExchangeMallRead:getShopItemList(self.activityID) then
		local activityExchangeMallRead, showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID), activityExchangeMallRead:getShopItemList(self.activityID)
	end
	activityExchangeMallRead = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).activityID = self.activityID
	self.scroll:updateScrollView(cc.size(624, 170), showShopItemList, 1, nil)
end
function ancientReelMainShopView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1173"
		;("common_text_1173")[1] = i18n("Ancient_reel_text_09")
		;("common_text_1173")[2] = i18n("Ancient_reel_text_09")
		SoraDShowFixWindow(i18n("common_text_1173"), "common_text_1173")
	end
end
return ancientReelMainShopView
