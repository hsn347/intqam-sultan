local gametop = gModuleMgr.getObject("gametop")
local legendPointsCtrl = gametop.playertop_:getModule("legendPointsCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local hegemonStoreView = class("hegemonStoreView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("hegemonStoreView")
	end
	return target
end)
function hegemonStoreView:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("hegemon_text_60"))
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.onBtnHelpClick))
	self.Text_point = SoraDGetChildByName(self, "Text_point")
	self.Sprite_icon = SoraDGetChildByName(self, "Sprite_icon")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("hegemon_text_61"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_items")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("hegemonStoreSingle")
end
function hegemonStoreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH", handler(self, self.initData))
end
function hegemonStoreView:setActivityID(activityID)
	self.activityID = activityID
	self:initData()
end
function hegemonStoreView:initData()
	local point = legendPointsCtrl:getHegemonPoint()
	legendPointsCtrl = nil
	;(nil).num = string.formatnumberthousands(point)
	self.Text_point:setString(i18n("hegemon_text_62", nil))
	if SoraDFIsRA() then
		self.Sprite_icon:setPositionX(self.Text_point:getPositionX() - self.Text_point:getContentSize().width - 40)
	else
		self.Sprite_icon:setPositionX(self.Text_point:getPositionX() + self.Text_point:getContentSize().width + 40)
	end
	self.tableData = activityExchangeMallRead:getShopItemList(gActivityTimeActivityID.LEGEND_HEGEMON_1)
	legendPointsCtrl = i18n("hegemon_text_62", nil)
	i18n("hegemon_text_62", nil).scroll = self.scroll
	i18n("hegemon_text_62", nil).view = self
	i18n("hegemon_text_62", nil).activityID = self.activityID
	self.scroll:updateScrollView(cc.size(624, 165), self.tableData, 1, i18n("hegemon_text_62", nil))
end
function hegemonStoreView:onBtnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("hegemonPointView"):show()
	end
end
return hegemonStoreView
