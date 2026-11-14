local constantRead = include("constantRead")
local legendPointsCtrl = SoraDGetCtrl("legendPointsCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local legendaryExchangeShopView = class("legendaryExchangeShopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryExchangeShopView")
end)
function legendaryExchangeShopView:ctor(properties)
	self.activityID = gActivityTimeActivityID.LEGEND_LORD
	self.nodeText = SoraDGetChildByName(self, "Node_text")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.textToken = SoraDGetChildByName(self, "Text_token")
	self.textToken = SoraDChangeTextToHtml(self.textToken)
	self.textTip = SoraDGetChildByName(self, "Text_Tip")
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("legendaryking_text_38"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleCCS("legendaryExchangeSingle")
	self.panelTouch = SoraDGetChildByName(self, "Panel_touch")
end
function legendaryExchangeShopView:setActivityID(activityID)
	self.activityID = activityID
	if worldMapDefine.isKingStarActivityID(self.activityID) then
		self.nodeCommonFramTitle:setTitle(i18n("kingstarbattle_text_47"))
		self.mapid = worldMapDefine.getKingStarMapid(self.activityID)
	end
	self:initItemInfo()
	self:initData()
end
function legendaryExchangeShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH", handler(self, self.initItemInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function()
		SoraDCloseLoading(self)
	end)
end
function legendaryExchangeShopView:initData(target, data)
	SoraDCloseLoading(self)
	if not activityExchangeMallRead:getShopItemList(self.activityID) then
		local _ENV, showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID), activityExchangeMallRead:getShopItemList(self.activityID)
	end
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).activityID = self.activityID
	self.scroll:updateScrollView(cc.size(624, 170), showShopItemList, 1, nil)
end
function legendaryExchangeShopView:initItemInfo()
	local maxValue = string.formatnumberthousands(constantRead.getConstValue("MAX_GET_LEGEND_POINTS"))
	if worldMapDefine.isKingStarActivityID(self.activityID) then
		self.legenPoint = string.formatnumberthousands(legendPointsCtrl:getKingStarPoint(self.activityID))
		constantRead = legendPointsCtrl:getKingStarPoint(self.activityID)
		_ENV, _ENV, legendPointsCtrl:getKingStarPoint(self.activityID).num = "%s/%s", string.format("%s/%s", self.legenPoint, maxValue), string.format("%s/%s", self.legenPoint, maxValue)
		_ENV, string.format("%s/%s", self.legenPoint, maxValue).num, ("%s/%s").color = "%s/%s", "%s/%s", "#FFFFFF"
		string.format("%s/%s", self.legenPoint, maxValue).__default, ("%s/%s").color = "%s/%s", "#E6C991"
		legendPointsCtrl:getKingStarPoint(self.activityID)[1] = string.format("%s/%s", self.legenPoint, maxValue)
		self.textToken:setString(i18n_html("kingstarbattle_text_48", legendPointsCtrl:getKingStarPoint(self.activityID)))
		self.textTip:setString(i18n("kingstarbattle_text_49"))
	else
		self.legenPoint = string.formatnumberthousands(legendPointsCtrl:getLegenPoint())
		constantRead = legendPointsCtrl:getLegenPoint()
		_ENV, _ENV, legendPointsCtrl:getLegenPoint().num = "%s/%s", string.format("%s/%s", self.legenPoint, maxValue), string.format("%s/%s", self.legenPoint, maxValue)
		_ENV, string.format("%s/%s", self.legenPoint, maxValue).num, ("%s/%s").color = "%s/%s", "%s/%s", "#FFFFFF"
		string.format("%s/%s", self.legenPoint, maxValue).__default, ("%s/%s").color = "%s/%s", "#E6C991"
		legendPointsCtrl:getLegenPoint()[1] = string.format("%s/%s", self.legenPoint, maxValue)
		self.textToken:setString(i18n_html("legendaryking_text_49", legendPointsCtrl:getLegenPoint()))
		self.textTip:setString(i18n("legendaryking_text_48"))
	end
	SoraDToCenter(self.nodeText)
end
function legendaryExchangeShopView:createScrollSingle()
	return include("legendaryExchangeSingle").new(self.panelTouch:clone())
end
function legendaryExchangeShopView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("legendaryExchangePointView")
		panel:initData(self.mapid)
		panel:show()
	end
end
function legendaryExchangeShopView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return legendaryExchangeShopView
