local equipmentCell = include("equipmentCell")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_List6 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_List6", Com_List6)
function Com_List6:onInit()
	self.fields.Button_buy:addClickListener(handler(self, self.btnClickBuy))
	self.fields.com_item:forbidLongPress()
	self.fields.com_item:addClickListener(handler(self, self.singleClickBack))
end
function Com_List6:onShow()
end
function Com_List6:initData(data)
	self.info = data
	self.fields.Text_Name:setString(equipDesRead.getName(self.info.ringId))
	self.fields.com_item:initData(self.info.ringId, 1)
	self.fields.Label_timer:beginTime(self.info.endTime - serviceFunctions.systemTime())
	equipDesRead = equipDesRead.getName(self.info.ringId)
	equipDesRead.getName(self.info.ringId).value = self.info.buyNum
	self.fields.Text_Limit:setString(i18n("common_text_1359", equipDesRead.getName(self.info.ringId)))
	self.fields.Button_buy:initData(gIDDef.GOLD, self.info.price, self.info.originalPrice)
	self.fields.Button_buy:setTitleTextColor(cc.c3b(255, 255, 0, 1), cc.c3b(255, 200, 0, 1))
	self.fields.Button_buy:setEnabled(self.info.buyNum > 0)
end
function Com_List6:singleClickBack()
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
function Com_List6:btnClickBuy()
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
return Com_List6
