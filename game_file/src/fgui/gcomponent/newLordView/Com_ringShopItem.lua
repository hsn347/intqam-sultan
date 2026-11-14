local equipmentCell = include("equipmentCell")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_ringShopItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_ringShopItem", Com_ringShopItem)
function Com_ringShopItem:onInit()
	self.fields.Button_buy:addClickListener(handler(self, self.btnClickBuy))
	self.fields.com_item:forbidLongPress()
	self.fields.com_item:addClickListener(handler(self, self.singleClickBack))
	self:fixChildrenPos()
end
function Com_ringShopItem:onShow()
end
function Com_ringShopItem:initData(data)
	self.info = data
	self.fields.Text_Name:setString(equipDesRead.getName(self.info.ringId))
	self.fields.com_item:initData(self.info.ringId, 1)
	if self.info.buyNum then
		equipDesRead = equipDesRead.getName(self.info.ringId)
		equipDesRead.getName(self.info.ringId).value = self.info.buyNum
		if i18n("common_text_1359", equipDesRead.getName(self.info.ringId)) then
			goto lbl_34
		end
	end
	::lbl_34::
	self.fields.Text_Limit:setString("")
	self.fields.Button_buy:initData(gIDDef.GOLD, self.info.price, self.info.originalPrice)
	self.fields.Button_buy:setTitleTextColor(cc.c3b(255, 255, 0, 1), cc.c3b(255, 200, 0, 1))
end
function Com_ringShopItem:singleClickBack()
	local partType = equipmentltCtrl.getEquipmentPart(self.info.ringId)
	if partType >= gEquipmentPart.RING then
		equipmentltCtrl = nil
		;(nil).eid = self.info.ringId
		;(nil).epid = nil
		;(nil).slv = 0
		;(nil).qly = self.info.quality
		;(nil).wear = gStatus.NO
		local data = equipmentCell.new(nil)
		equipmentltCtrl = nil
		;(nil).data = data
		;(nil).buyInfo = self.info
		uiManager:show("ringNeckInfoView", nil)
	end
end
function Com_ringShopItem:btnClickBuy()
	SoraDPlaySound()
	if SoraDEnoughGold(self.info.price) then
		_ENV, _ENV = nil, nil
		;(nil).id = self.info.ringId
		;(nil).originalPrice = self.info.originalPrice
		;(nil).price = self.info.price
		;(nil).data, (nil).shopItemID = nil, self.info.shopItemID
		uiManager:show("ringShopPopView", nil)
	end
end
return Com_ringShopItem
