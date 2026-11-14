local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001691_ItemUsePanel = class("Activity_9001691_ItemUsePanel", baseFguiPanel)
function Activity_9001691_ItemUsePanel:ctor(...)
	self.isLRU = true
	Activity_9001691_ItemUsePanel.super.ctor(self, ...)
	print("Activity_9001691_ItemUsePanel:ctor", self.viewName)
end
_ENV, Activity_9001691_ItemUsePanel.onInit = function(self)
	self.view:fixChildrenPos()
	print("=======Activity_9001691_ItemUsePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("surprise_box_026"))
	self.fields.Button_sure:setTitle(i18n("common_text_204"))
	self.fields.Button_sure:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_cancel:addClickEventListener(handler(self, self.onClickClose))
	self.fields.text_tips:setString(i18n("surprise_box_082"))
end, function(self)
	self.view:fixChildrenPos()
	print("=======Activity_9001691_ItemUsePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("surprise_box_026"))
	self.fields.Button_sure:setTitle(i18n("common_text_204"))
	self.fields.Button_sure:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_cancel:addClickEventListener(handler(self, self.onClickClose))
	self.fields.text_tips:setString(i18n("surprise_box_082"))
end
;(function(self)
	self.view:fixChildrenPos()
	print("=======Activity_9001691_ItemUsePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("surprise_box_026"))
	self.fields.Button_sure:setTitle(i18n("common_text_204"))
	self.fields.Button_sure:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_cancel:addClickEventListener(handler(self, self.onClickClose))
	self.fields.text_tips:setString(i18n("surprise_box_082"))
end)[1] = "icon_9001691_fangdajing.png"
;(function(self)
	self.view:fixChildrenPos()
	print("=======Activity_9001691_ItemUsePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("surprise_box_026"))
	self.fields.Button_sure:setTitle(i18n("common_text_204"))
	self.fields.Button_sure:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_cancel:addClickEventListener(handler(self, self.onClickClose))
	self.fields.text_tips:setString(i18n("surprise_box_082"))
end)[2] = "icon_9001691_huixue.png"
local _ENV, (function(self)
	self.view:fixChildrenPos()
	print("=======Activity_9001691_ItemUsePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("surprise_box_026"))
	self.fields.Button_sure:setTitle(i18n("common_text_204"))
	self.fields.Button_sure:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_cancel:addClickEventListener(handler(self, self.onClickClose))
	self.fields.text_tips:setString(i18n("surprise_box_082"))
end)[3], itemIcon = baseFguiPanel, "icon_9001691_xiayihuihe.png", function(self)
	self.view:fixChildrenPos()
	print("=======Activity_9001691_ItemUsePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("surprise_box_026"))
	self.fields.Button_sure:setTitle(i18n("common_text_204"))
	self.fields.Button_sure:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_cancel:addClickEventListener(handler(self, self.onClickClose))
	self.fields.text_tips:setString(i18n("surprise_box_082"))
end
baseFguiPanel[1] = "surprise_box_028"
baseFguiPanel[2] = "surprise_box_029"
local _ENV, baseFguiPanel[3], itemName = nil, "surprise_box_030", baseFguiPanel
;(nil)[1] = "surprise_box_031"
;(nil)[2] = "surprise_box_032"
local (nil)[3], itemDes = "surprise_box_033", nil
function Activity_9001691_ItemUsePanel:endShow()
	print("=======Activity_9001691_ItemUsePanel:endShow")
	self.useItem = self.param.useItem
	self.useCallback = self.param.useCallback
	self:updateView()
end
function Activity_9001691_ItemUsePanel:updateView()
	self.fields.item_icon:setURL(itemIcon[self.useItem] or itemIcon[1])
	itemIcon = nil
	;(nil).name = i18n(itemName[self.useItem] or itemName[1])
	self.fields.text_des:setString(i18n("surprise_box_027", nil))
	self.fields.text_msg:setString(i18n(itemDes[self.useItem] or itemDes[1]))
end
function Activity_9001691_ItemUsePanel:onSureClick()
	print("=======Activity_9001691_ItemUsePanel:onSureClick")
	SoraDPlaySound()
	if self.useCallback then
		self.useCallback()
	end
	self:close()
end
return Activity_9001691_ItemUsePanel
