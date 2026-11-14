local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicUtil = include("publicUtil")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_exchangeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001639/Com_exchangeSingle", Com_exchangeSingle)
function Com_exchangeSingle:onInit()
	self.fields.CheckBox:addClickListener(handler(self, self.onClickCheckBox))
	self.fields.Text_notify:setString(i18n("exchange_btn_01"))
	self.fields.Button_exchange:setString(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickExchange))
	self.fields.toItemL:setItemRenderer(handler(self, self.onToItemRender))
	self.fields.fromItemL:setItemRenderer(handler(self, self.onFromItemRender))
	self:fixChildrenPos()
	self.fields.Sprite_line:fix()
	self.fields.Sprite_arrow:fix()
end
function Com_exchangeSingle:onShow()
end
function Com_exchangeSingle:onToItemRender(index, object)
	local itemInfo = self.shopItemList[index + 1]
	object:initData(itemInfo.id, itemInfo.count)
end
function Com_exchangeSingle:onFromItemRender(index, object)
	local itemID = self.exchangeitemList[index + 1].id
	local needNum = self.exchangeitemList[index + 1].count
	local ownNum = publicUtil.getCount(itemID)
	object:initData(itemID)
	local stringColor = needNum > ownNum and "#BE2828" or "#36bf36"
	object:setNum(ownNum, needNum, stringColor)
end
function Com_exchangeSingle:initData(cfg)
	self.cfg = cfg
	self.shopItemID = cfg.storeID
	self.fromItemID = cfg.exchangeitem[1]
	self.fromItemCount = cfg.exchangeitem[2]
	self.fromItemID2 = cfg.exchangeitem[3]
	self.fromItemCount2 = cfg.exchangeitem[4]
	self.toItemID = cfg.shopitem[1]
	self.toItemCount = cfg.shopitem[2]
	self.toItemID2 = cfg.shopitem[3]
	self.toItemCount2 = cfg.shopitem[4]
	self.limitNum = cfg.limitnum
	self.fields.CheckBox:setSelected(cfg.remindStatus == 1)
	_ENV, _UPVALUE1_ = self.fields.CheckBox, self.fields.CheckBox.setSelected
	self.fields.CheckBox.id = self.toItemID
	self.fields.CheckBox.count = self.toItemCount
	_ENV, _UPVALUE1_, self.shopItemList, self.fields.CheckBox.setSelected[1] = self.fields.CheckBox, self.fields.CheckBox.setSelected, self.fields.CheckBox.setSelected, self.fields.CheckBox
	self.fields.CheckBox.id = self.fromItemID
	self.fields.CheckBox.count = self.fromItemCount
	self.exchangeitemList, self.fields.CheckBox.setSelected[1] = self.fields.CheckBox.setSelected, self.fields.CheckBox
	if self.fromItemID2 and self.fromItemCount2 then
		_ENV = self.fromItemCount
		self.fromItemCount.id = self.fromItemID2
		self.fromItemCount.count = self.fromItemCount2
		table.insert(self.exchangeitemList, self.fromItemCount)
	end
	if self.toItemID2 and self.toItemCount2 then
		_ENV = self.fromItemCount
		self.fromItemCount.id = self.toItemID2
		self.fromItemCount.count = self.toItemCount2
		table.insert(self.shopItemList, self.fromItemCount)
	end
	self.leftCount = math.max(0, self.limitNum - cfg.curExchangeNum)
	local countStr = string.format("%d/%d", self.leftCount, self.limitNum)
	_ENV = nil
	;(nil).count = countStr
	self.fields.Text_leftCount:setString(i18n("common_text_1673", nil))
	self.controllers.c1:setSelectedIndex(self.leftCount <= 0 and 1 or 0)
	self.fields.fromItemL:setNumItems(#self.exchangeitemList)
	self.fields.toItemL:setNumItems(#self.shopItemList)
end
function Com_exchangeSingle:onClickCheckBox()
	SoraDPlaySound()
	newExchangeMallCtrl:reqNewExchangeRemind(self.shopItemID, self.fields.CheckBox:isSelected() and 1 or 0)
end
function Com_exchangeSingle:onClickExchange()
	SoraDPlaySound()
	local isEnough = true
	for _, v in ipairs(self.exchangeitemList) do
		local ownNum = publicUtil.getCount(v.id)
		if ownNum < v.count then
			isEnough = false
			break
		end
	end
	if not isEnough then
		SoraDShowMsgTip(i18n("gemEnchant_text_62"))
	elseif self.leftCount <= 0 then
		SoraDShowMsgTip(i18n("common_text_1865"))
	elseif #self.shopItemList == 1 and #self.exchangeitemList == 1 then
		local maxNum = math.floor(publicUtil.getCount(self.fromItemID) / self.fromItemCount)
		if self.leftCount and self.leftCount > 0 then
			maxNum = math.min(maxNum, self.leftCount)
		end
		_ENV, _ENV, _ENV = i18n("common_text_1865")
		i18n("common_text_1865").targetID = self.toItemID
		i18n("common_text_1865").exchangeID = self.fromItemID
		i18n("common_text_1865").singCount = self.fromItemCount
		i18n("common_text_1865").curNum = maxNum
		i18n("common_text_1865").exchangeData, i18n("common_text_1865").singleGet = i18n("common_text_1865")
		i18n("common_text_1865").exchangeCfg, i18n("common_text_1865").exchangeHandler = i18n("common_text_1865")
		uiManager:show("newShopSingleBuy", i18n("common_text_1865"))
	else
		_ENV = "newShopSingleBuy"
		;("newShopSingleBuy").shopItemList = self.shopItemList
		;("newShopSingleBuy").exchangeItemList = self.exchangeitemList
		;("newShopSingleBuy").leftCount = self.leftCount
		;("newShopSingleBuy").exchangeHandler = function(exchangeNum)
			newExchangeMallCtrl:reqNewExchangeGood(self.shopItemID, exchangeNum)
		end
		uiManager:show("ShopSingleMoreBuy", "newShopSingleBuy")
	end
end
return Com_exchangeSingle
