local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampHatchRead = include("magicLampHatchRead")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local publicRead = include("publicRead")
local MagicLampHatchChoosePanel = class("MagicLampHatchChoosePanel", baseFguiPanel)
function MagicLampHatchChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MagicLampHatchChoosePanel:ctor", self.viewName)
end
function MagicLampHatchChoosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampHatchChoosePanel:onInit()
	print("=======MagicLampHatchChoosePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Jinn_hatch_text_46"))
	self.fields.list_reward1:setItemRenderer(handler(self, self.onDesireItemsRender))
	self.fields.tips1:setString(i18n("Jinn_hatch_text_53"))
	self.hatchType = self.param.hatchType
	self.desireItems = self.param.desireItems
	self.fields.button_choose:setTitle(i18n("common_text_204"))
	self.fields.button_choose:addClickEventListener(handler(self, self.onChooseClick))
end
function MagicLampHatchChoosePanel:onShow()
	print("=======MagicLampHatchChoosePanel:onShow")
	self:updateView()
end
function MagicLampHatchChoosePanel:updateView()
	self.hatchData = magicLampHatchCtrl:getHatchData(self.hatchType)
	if self.hatchData == nil then
		return
	end
	self.desireCfg = magicLampHatchRead.getDesireCfg(self.hatchType, self.hatchData.lv)
	self.desireInfo = self.hatchData.desireInfo
	if self.chooseItemID == nil then
		self.chooseItemID = self.desireInfo.chooseItemID
	end
	if self.desireInfo.chooseItemID ~= 0 then
		magicLampHatchCtrl = nil
		;(nil).item = publicRead.getName(self.desireInfo.chooseItemID)
		self.fields.tips2:setString(i18n("Jinn_hatch_text_41", nil))
	else
		self.fields.tips2:setString(i18n("Jinn_hatch_text_48"))
	end
	self.fields.button_choose:setEnabled(self.chooseItemID ~= 0)
	dump(self.desireItems, "self.desireItems")
	self.fields.list_reward1:setNumItems(#self.desireItems)
end
function MagicLampHatchChoosePanel:onDesireItemsRender(index, obj)
	local desireItem = self.desireItems[index + 1]
	obj:initData(desireItem, self.hatchData, self.chooseItemID)
	obj:setClickCallback(handler(self, self.onDesireItemsClick))
end
function MagicLampHatchChoosePanel:onDesireItemsClick(item)
	local itemid = item.id
	if itemid == self.chooseItemID then
		return
	end
	self.chooseItemID = itemid
	self.fields.button_choose:setEnabled(self.chooseItemID ~= 0)
	self.fields.list_reward1:setNumItems(#self.desireItems)
end
function MagicLampHatchChoosePanel:onChooseClick()
	if self.chooseItemID == self.desireInfo.chooseItemID then
		self:close()
		return
	end
	magicLampHatchCtrl:reqMagicLampHatchDesireItem(self.hatchType, self.chooseItemID)
	self:close()
end
return MagicLampHatchChoosePanel
