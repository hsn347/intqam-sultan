local constantRead = include("constantRead")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroReforgePopPanel = class("HeroReforgePopPanel", baseFguiPanel)
function HeroReforgePopPanel:ctor(...)
	HeroReforgePopPanel.super.ctor(self, ...)
	print("HeroReforgePopPanel:ctor", self.viewName)
end
function HeroReforgePopPanel:onInit()
	print("=======HeroReforgePopPanel:onInit")
	self.fields.Text_tip:setString(i18n("Hero_reshape_20"))
	self.fields.Text_back:setString(i18n("Hero_reshape_3"))
	self.cdTime = constantRead.getConstValue("HERO_RESHAPE_CD")
	_ENV = i18n("Hero_reshape_3")
	i18n("Hero_reshape_3").num = fguiHelper.getColorString("#F0E6D2", math.ceil(self.cdTime / 86400))
	self.fields.Text_cd:setString(i18n("Hero_reshape_14", i18n("Hero_reshape_3")))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_cancel:setString(i18n("common_text_185"))
	self.fields.Btn_cancel:addClickListener(handler(self, self.btnCancelClick))
	self.fields.Btn_free:setString(i18n("Hero_reshape_5"))
	self.fields.Btn_free:addClickListener(handler(self, self.btnReforgelClick))
	self.fields.Btn_item:setString(i18n("Hero_reshape_5"))
	self.fields.Btn_item:addClickListener(handler(self, self.btnItemRelClick))
end
function HeroReforgePopPanel:onItemRenderer(index, obj)
	obj:initData(self.items[index + 1].id, self.items[index + 1].count)
end
function HeroReforgePopPanel:onShow()
	print("=======HeroReforgePopPanel:onShow")
	self.cType = self.param.cType
	self.items = self.param.items
	self.heroID = self.param.heroID
	self.parent = self.param.parent
	self.costItem = constantRead.getConstValue("HERO_RESHAPE_COST_ITEM")
	self.fields.Btn_item:setCost(self.costItem, 1)
	self.controllers.c1:setSelectedIndex(self.cType)
	self.fields.List_item:setNumItems(#self.items)
end
function HeroReforgePopPanel:btnCancelClick()
	SoraDPlaySound()
	self:close()
end
function HeroReforgePopPanel:btnReforgelClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Hero_reshape_21")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		heroCtrl:reforge(self.heroID, true)
		self.parent:close()
		self:close()
	end
	uiManager:show("MessageBox", nil)
end
function HeroReforgePopPanel:btnItemRelClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Hero_reshape_21")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		heroCtrl:reforge(self.heroID)
		self.parent:close()
		self:close()
	end
	uiManager:show("MessageBox", nil)
end
return HeroReforgePopPanel
