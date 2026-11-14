local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local mailGivePopPanel = class("mailGivePopPanel", baseFguiPanel)
function mailGivePopPanel:ctor(...)
	mailGivePopPanel.super.ctor(self, ...)
	print("mailGivePopPanel:ctor", self.viewName)
end
function mailGivePopPanel:onInit()
	print("=======mailGivePopPanel:onInit")
	self.itemList, _ENV = print, print
	self.selIndex = 1
	self.fields.Panel_bg:setString(i18n("common_text_4364"))
	self.fields.Text_tip:setString(i18n("pigeon_text_04"))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.Button_ok:setEnabled(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
end
function mailGivePopPanel:onShow()
	print("=======mailGivePopPanel:onShow")
	self:initData()
end
function mailGivePopPanel:initData()
	backpackCtrl, backpackCtrl = nil, nil
	;(nil).id = 501901
	backpackCtrl, (nil)[1], (nil).count = nil, nil, backpackCtrl:getItemCount(501901)
	;(nil).id = 511701
	self.itemList, (nil)[2], (nil).count = nil, nil, backpackCtrl:getItemCount(511701)
	self.fields.List:setNumItems(#self.itemList)
end
function mailGivePopPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
	obj:setSelectShow(true)
end
function mailGivePopPanel:onChooseItem()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self.fields.Button_ok:setEnabled(true)
end
function mailGivePopPanel:btnOkClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).name = self.param.name
	;(nil).abbr = self.param.abbr
	;(nil).itemID = self.itemList[self.selIndex].id
	uiManager:show("mailGivePresent", nil)
	self:close()
end
return mailGivePopPanel
