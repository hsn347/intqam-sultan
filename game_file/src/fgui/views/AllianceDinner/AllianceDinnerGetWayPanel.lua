local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceDinnerGetWayPanel = class("AllianceDinnerGetWayPanel", baseFguiPanel)
function AllianceDinnerGetWayPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AllianceDinnerGetWayPanel:ctor", self.viewName)
end
function AllianceDinnerGetWayPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceDinnerGetWayPanel:onInit()
	print("=======AllianceDinnerGetWayPanel:onInit")
	self.itemID = 861401
	self.fields.bg:setString(i18n("common_text_4342"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_use:addClickEventListener(handler(self, self.onUseClick))
	self.fields.btn_use:setTitle(i18n("common_text_314"))
	self.fields.btn_use:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_desc:fixPos()
	self.fields.Text_num:fixPos()
	self.fields.icon:fixPos()
	self.fields.n4:fixPos()
end
function AllianceDinnerGetWayPanel:onShow()
	print("=======AllianceDinnerGetWayPanel:onShow")
	self:updateItemNum()
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.itemID))
	self.fields.Text_name:setString(publicRead.getName(self.itemID))
	self.fields.Text_desc:setString(publicRead.getDes(self.itemID))
	local itemDesRead = include("itemDesRead")
	self.wayCfg = itemDesRead.getOutput(self.itemID)
	self.fields.list:setNumItems(#self.wayCfg)
end
function AllianceDinnerGetWayPanel:updateItemNum()
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	backpackCtrl = nil
	;(nil).count = self.itemNum
	self.fields.Text_num:setString(i18n("common_text_1377", nil))
end
function AllianceDinnerGetWayPanel:onItemRenderer(index, obj)
	obj:initData(self.wayCfg[index + 1], self)
end
function AllianceDinnerGetWayPanel:onUseClick()
	SoraDPlaySound()
	if self.itemNum > 0 then
		_ENV, _ENV = nil, nil
		;(nil).id = self.itemID
		;(nil).itemData, (nil).count = nil, self.itemNum
		uiManager:show("newItemSingleUse", nil)
	else
		SoraDShowMsgTip(i18n("gemEnchant_text_48"))
	end
end
return AllianceDinnerGetWayPanel
