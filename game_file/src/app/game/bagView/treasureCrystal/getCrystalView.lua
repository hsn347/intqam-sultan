local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local treasureCrystalRead = include("treasureCrystalRead")
local itemDesRead = include("itemDesRead")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local getCrystalView = class("getCrystalView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("getCrystalView")
	end
	return target
end)
function getCrystalView:ctor()
	self.textTitle = SoraDGetChildByName(self, "Text_Get")
	self.textTitle:setString(i18n("Lucky_treasure_text_05"))
	self.itemIcon = SoraDGetChildByName(self, "Image_Icon")
	self.textItemName = SoraDGetChildByName(self, "Text_ItemName")
	self.textItemTip = SoraDGetChildByName(self, "Text_Tip")
	self.btnGain = SoraDGetChildByName(self, "Button_gain")
	self.btnGain:addTouchEventListener(handler(self, self.btnClickGain))
	self.btnGain:setTitleText(i18n("common_text_204"))
end
function getCrystalView:initData(itemData)
	dump(itemData, "itemData", 10)
	self.itemID = itemData.id
	self.itemLimitedTime = timeLimitedItemCtrl:getNewLimitedTime(self.itemID)
	local crystalData = treasureCrystalRead.getCrystalConfig(self.itemID)
	self.taskStage = crystalData.lv
	self.itemQuality = crystalData.quality
	self.textItemTip:setString(i18n(self.itemQuality == 1 and "item_des_819101" or "item_des_819601"))
	self.textItemName:setString(i18n(itemDesRead.getName(self.itemID)))
	self.textItemName:setColor(itemDesRead.getColor(self.itemID))
	self.itemIcon:loadTexture(itemDesRead.getIcon(self.itemID), ccui.TextureResType.plistType)
end
function getCrystalView:btnClickGain(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("treasureCrystalView")
		_ENV, _ENV = nil, nil
		;(nil).dataFromItem, (nil).isLimitedItem = nil, self.itemLimitedTime
		panel:setItemData(self.itemID, nil)
		panel:show()
		self:close(self, type)
	end
end
return getCrystalView
