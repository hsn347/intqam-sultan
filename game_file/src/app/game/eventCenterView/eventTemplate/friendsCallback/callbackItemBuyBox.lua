local colorYellow = cc.c3b(255, 255, 0)
local colorRed = cc.c3b(255, 30, 30)
local gametop = gModuleMgr.getObject("gametop")
local itemDesRead = include("itemDesRead")
local friendsCallbackCtrl = gametop.playertop_:getModule("friendsCallbackCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local callbackItemBuyBox = class("callbackItemBuyBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("callbackItemBuyBox")
	end
	return target
end)
function callbackItemBuyBox:ctor()
	self.itemUseSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelTitle:setString(i18n("common_text_2923"))
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItems_item")
	self.btnTool = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_tool")
	_ENV = "CCS_commonGoldNormalBtn_tool"
	self.btnTool:initData("CCS_commonGoldNormalBtn_tool", 1)
	self.btnTool:setVisible(false)
	self.btnTool:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.itemUseSlider:setSliderCallBack(handler(self, self.sliderCallBack))
end
function callbackItemBuyBox:setHandle(handle)
	self.handle = handle
end
function callbackItemBuyBox:sliderCallBack(value)
	local cost = value * self.tableItemData.changeID.count
	self.btnTool:setGoldText(cost)
end
function callbackItemBuyBox:initData(itemData)
	dump(itemData, "callbackItemBuyBox======itemData", 10)
	self.tableItemData = itemData
	_ENV = "callbackItemBuyBox======itemData"
	;("callbackItemBuyBox======itemData").itemID = self.tableItemData.itemID.id
	self.item:initData("callbackItemBuyBox======itemData")
	self.btnTool:setVisible(true)
	local integral = itemData.changeID.count
	self.btnTool:setGoldText(integral)
	self.btnTool:setIconTexture("7129.png")
	local itemId = self.tableItemData.itemID.id
	local haveBuy = friendsCallbackCtrl.shopData[tostring(itemData.shopItemID)] or 0
	local maxValue = self.tableItemData.limitNum - haveBuy
	maxValue = math.min(maxValue, math.floor(backpackCtrl:getItemCount(itemData.changeID.id) / itemData.changeID.count))
	self.btnTool:setTitleStr(i18n("common_text_1889"))
	self.labelTitle:setString(itemDesRead.getName(itemId))
	self.labelDes:setString(itemDesRead.getDes(itemId))
	_ENV = itemDesRead.getDes(itemId)
	itemDesRead.getDes(itemId).maxValue = maxValue
	itemDesRead.getDes(itemId).minValue = 1
	itemDesRead.getDes(itemId).curValue = 1
	self.itemUseSlider:initData(itemDesRead.getDes(itemId))
end
function callbackItemBuyBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.buyList, _ENV = SoraDPlaySound, SoraDPlaySound
		_ENV, self.buyList[tostring(self.tableItemData.itemID.id)] = self.buyList, self.itemUseSlider:getSliderCurValue()
		self.buyList.index = self.tableItemData.shopItemID
		local self.buyList.count, table = self.itemUseSlider:getSliderCurValue(), self.buyList
		_ENV = self.itemUseSlider
		self.itemUseSlider.index = self.tableItemData.shopItemID
		self.itemUseSlider.count = self.itemUseSlider:getSliderCurValue()
		friendsCallbackCtrl:reqBuyItem(self.itemUseSlider)
		self:removeFromParent()
	end
end
return callbackItemBuyBox
