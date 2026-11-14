local itemDesRead = include("itemDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceStore = gametop.playertop_:getModule("allianceStore")
local allianceltCtrl = include("allianceltCtrl")
local allianceShopReturnGoodsView = class("allianceShopSingleBuy", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("shopSingleBuy")
	end
	return target
end)
function allianceShopReturnGoodsView:ctor()
	self.tableData, _ENV = nil, nil
	self.labelPay = SoraDGetChildByName(self, "Text_needPay")
	self.Node_next = SoraDGetChildByName(self, "Node_next")
	self.Node_next:setVisible(false)
	self.Text_resTotal = SoraDGetChildByName(self, "Text_resTotal")
	self.Text_resTotal:setVisible(false)
	self.Node_gold = SoraDGetChildByName(self, "Node_gold")
	self.Node_gold:setVisible(false)
	self.Node_ori = SoraDGetChildByName(self, "Node_ori")
	self.Node_ori:setVisible(false)
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labNotice = SoraDGetChildByName(self, "Text_notice")
	self.btnBuy = SoraDGetChildByName(self, "Button_Buy")
	self.btnBuy:setTitleFontSize(22)
	self.btnBuy:setTitleText(i18n("alliance_store_returns_button"))
	self.bagShopSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.bagShopSlider:setSliderCallBack(handler(self, self.payGoldChange))
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItems_item")
	self.imgGole = SoraDGetChildByName(self, "Image_gold")
	self.needBuy = 0
	self.btnBuy:addTouchEventListener(handler(self, self.onBuy))
end
function allianceShopReturnGoodsView:setActionData(fromPos)
	_ENV = nil
	;(nil).x = self.item:getPositionX()
	self.oldPos, (nil).y = nil, self.item:getPositionY()
	fromPos = self.item:getParent():convertToNodeSpace(fromPos)
	self.item:setPosition(fromPos)
	self.item:setScale(0.5)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(0.3, 1)
	;(nil)[2] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[3] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[4] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[5] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	self.item:runAction(cca.spawn(nil))
end
function allianceShopReturnGoodsView:onBuy(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.needBuy > 0 then
			allianceStore:reqReturnGoods(self.tableData.itemID, self.needBuy)
		end
		self:removeFromParent()
	end
end
function allianceShopReturnGoodsView:initData(data)
	self.tableData = data
	itemDesRead = nil
	;(nil).itemID = self.tableData.itemID
	self.item:initData(nil)
	itemDesRead = nil
	;(nil).maxValue = self.tableData.itemCount
	;(nil).minValue = 1
	;(nil).curValue = 1
	self.bagShopSlider:initData(nil)
	self.labelName:setString(itemDesRead.getName(self.tableData.itemID))
	self.labelDes:setString(itemDesRead.getDes(self.tableData.itemID))
	self.imgGole:ignoreContentAdaptWithSize(true)
	self.imgGole:setScale(0.9)
end
function allianceShopReturnGoodsView:payGoldChange(needBuy)
	self.needBuy = needBuy
	local pay = allianceltCtrl.getPrice(self.tableData.itemID, gIDDef.ALLIANCE_HONOR)
	allianceltCtrl = nil
	;(nil).var1 = string.formatnumberthousands(self.needBuy)
	;(nil).var2 = itemDesRead.getName(self.tableData.itemID)
	;(nil).var3 = string.formatnumberthousands(self.needBuy * pay)
	;(nil).var4 = i18n("common_text_032")
	self.labNotice:setString(i18n("alliance_store_returns_description_1", nil))
end
return allianceShopReturnGoodsView
