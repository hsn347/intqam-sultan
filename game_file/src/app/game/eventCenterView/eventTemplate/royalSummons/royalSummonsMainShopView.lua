local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsMainShopView = class("royalSummonsMainShopView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
local itemSize = cc.size(624, 160)
function royalSummonsMainShopView:ctor()
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
	self.scroll:setSingleCCS("royalSummonsMainShopSingle")
	self.tableCurItems, _ENV = self.scroll.setSingleCCS, self.scroll.setSingleCCS
end
function royalSummonsMainShopView:init()
	SoraDCloseLoading(self)
	self:updateTokenInfo()
	self:updateActivityTime()
	self:initScrollList()
end
function royalSummonsMainShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_SHOP", handler(self, self.init))
end
function royalSummonsMainShopView:updateActivityTime()
	local time = royalSummonsCtrl:getActivityStatusTime()
	if 0 < time then
		self.txtActivieyTime:beginTime(time)
	end
end
function royalSummonsMainShopView:updateTokenInfo()
	local tokenNum = royalSummonsCtrl:getKingTokenNum()
	royalSummonsCtrl = nil
	;(nil).num = string.formatnumberthousands(tokenNum)
	self.txtToken:setString(i18n("summoned_text_31", nil))
	_UPVALUE3_ = i18n("summoned_text_31", nil)
	i18n("summoned_text_31", nil)[1] = self.img_icon
	i18n("summoned_text_31", nil)[2] = self.txtToken
	i18n("summoned_text_31", nil)[3] = self.btnHelp
	_UPVALUE2_ = self.txtToken
	self.txtToken[1] = 5
	self.txtToken[2] = 10
	_G.SoraDAlignNodeArrayOnCenterX(320, i18n("summoned_text_31", nil))
end
function royalSummonsMainShopView:initScrollList()
	self:updateScrollData()
	self.scroll:jumpToTop()
end
function royalSummonsMainShopView:updateScrollData()
	local royalSummonsRead = include("royalSummonsRead")
	self.tableCurItems = royalSummonsRead:getShopItemList(royalSummonsCtrl:getClassType())
	_ENV = royalSummonsCtrl:getClassType()
	royalSummonsCtrl:getClassType().scroll = self.scroll
	royalSummonsCtrl:getClassType().view = self
	royalSummonsCtrl:getClassType().mainView = self
	self.scroll:updateScrollView(itemSize, self.tableCurItems, 1, royalSummonsCtrl:getClassType())
end
function royalSummonsMainShopView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1173"
		;("common_text_1173")[1] = i18n("summoned_text_32")
		;("common_text_1173")[2] = i18n("summoned_text_32")
		SoraDShowFixWindow(i18n("common_text_1173"), "common_text_1173")
	end
end
return royalSummonsMainShopView
