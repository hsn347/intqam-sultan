local MAX_ROW_NUM = 5
local SCROLL_ITEM_HEIGHT = 110
local pyramidOneKeyRewardView = class("pyramidOneKeyRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pyramidOneKeyRewardView")
	end
	return target
end)
function pyramidOneKeyRewardView:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_award")
	SoraDGetChildByName(self, "Image_cBg"):setFillType(1)
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("Promise_Summit_text_29"))
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_1402"))
	self.Button_ok:addTouchEventListener(handler(self, self.onBtnOKClick))
	SoraDCreatAnimation("pyramidOneKeyRewardView", self, false)
end
function pyramidOneKeyRewardView:onBtnOKClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function pyramidOneKeyRewardView:onExitPanel()
	SoraDMailGainItems(self.itemList, true)
	_ENV = self.itemList
	self.itemList.msg = "MESSAGE_SERVER_PYRAMID_INIT_DATA_BACK"
	SoraDSendMessage(self.itemList)
	_ENV = self.itemList
	self.itemList.msg = "MESSAGE_MAINCITYVIEW_UPDATE_LeisureCenter_VIEW"
	SoraDSendMessage(self.itemList)
end
function pyramidOneKeyRewardView:initData(itemList)
	self.itemList = itemList
	self:initScrollList()
end
function pyramidOneKeyRewardView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
end
function pyramidOneKeyRewardView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH + 0)
end
function pyramidOneKeyRewardView:updateScrollData()
	for k, v in ipairs(self.itemList) do
		local award = self:getSingle_AwardItem()
		award:initItem(v)
		local x = (k - 1) % MAX_ROW_NUM
		local y = math.floor((k - 1) / MAX_ROW_NUM)
		local posX = SoraDFPosX(220 - x * 110, 0, self.scroll:getContentSize().width)
		local posy = y * SCROLL_ITEM_HEIGHT + 80
		award:setPosition(cc.p(posX, -(self.scrollH + posy)))
	end
	self.scrollH = self.scrollH + math.ceil(#self.itemList / MAX_ROW_NUM) * SCROLL_ITEM_HEIGHT
end
function pyramidOneKeyRewardView:getSingle_AwardItem()
	local single = include("pyramidRwardItem").new()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setOwnView(self)
	return single
end
return pyramidOneKeyRewardView
