local colorYellow = cc.c3b(255, 255, 0)
local colorRed = cc.c3b(255, 30, 30)
local gametop = gModuleMgr.getObject("gametop")
local itemDesRead = include("itemDesRead")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local RemainsItemBuyBox = class("remainsItemBuyBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("remainsItemBuyBox")
	end
	return target
end)
function RemainsItemBuyBox:ctor()
	self.itemUseSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelTitle:setString(i18n("common_text_2923"))
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItems_item")
	self.btnTool = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_tool")
	_ENV = "CCS_commonGoldNormalBtn_tool"
	self.btnTool:initData("CCS_commonGoldNormalBtn_tool", 1)
	self.btnTool:setVisible(false)
	self.btnTool:setTouchEnabled(false)
	self.btnTool:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.itemUseSlider:setSliderCallBack(handler(self, self.sliderCallBack))
end
function RemainsItemBuyBox:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_BUY_SUCCESS", function(target, data)
		SoraDCloseLoading(self)
		if self.buyList then
			SoraDMailGainItems(self.buyList)
		end
		self:removeFromParent()
	end)
end
function RemainsItemBuyBox:setHandle(handle)
	self.handle = handle
end
function RemainsItemBuyBox:sliderCallBack(value)
	local cost = value * self.tableItemData.integral
	self.btnTool:setGoldText(cost)
	self.btnTool:setTouchEnabled(0 < value)
end
function RemainsItemBuyBox:initData(itemData)
	dump(itemData, "RemainsItemBuyBox======itemData", 10)
	self.tableItemData = itemData
	_ENV = "RemainsItemBuyBox======itemData"
	;("RemainsItemBuyBox======itemData").itemID = self.tableItemData.itemId
	self.item:initData("RemainsItemBuyBox======itemData")
	self.btnTool:setVisible(true)
	local integral = self.tableItemData.integral
	self.btnTool:setGoldText(integral)
	self.btnTool:setIconTexture("btn_ruins.png")
	local itemId = self.tableItemData.itemId
	local maxValue = self.tableItemData.limitNumber - (self.tableItemData.buyNum or 0)
	maxValue = math.min(maxValue, math.floor(remainsTeamCtrl:getPlayerShopScore() / integral))
	maxValue = math.max(0, maxValue)
	self.btnTool:setTitleStr(i18n("common_text_1889"))
	self.labelTitle:setString(itemDesRead.getName(self.tableItemData.itemId))
	self.labelDes:setString(itemDesRead.getDes(self.tableItemData.itemId))
	_ENV = itemDesRead.getDes(self.tableItemData.itemId)
	itemDesRead.getDes(self.tableItemData.itemId).maxValue = maxValue
	itemDesRead.getDes(self.tableItemData.itemId).minValue = 1
	itemDesRead.getDes(self.tableItemData.itemId).curValue = 1
	self.itemUseSlider:initData(itemDesRead.getDes(self.tableItemData.itemId))
end
function RemainsItemBuyBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.buyList, _ENV = self.handle, self.handle
			self.buyList[tostring(self.tableItemData.itemId)] = self.itemUseSlider:getSliderCurValue()
			local selfIndex = remainsTeamCtrl:getSegmentRealIndex(remainsTeamCtrl:getPlayerSegment())
			local needIndex = remainsTeamCtrl:getSegmentRealIndex(self.tableItemData.segment)
			if selfIndex < needIndex then
				SoraDShowMsgTip(i18n("arena_text_10"))
				self:removeFromParent()
			else
				_ENV = self
				self.id = self.tableItemData.shopItemID
				self.num = self.itemUseSlider:getSliderCurValue()
				self.handle(self)
				SoraDShowLoading(self, nil, nil, nil, 15)
			end
		end
	end
end
return RemainsItemBuyBox
