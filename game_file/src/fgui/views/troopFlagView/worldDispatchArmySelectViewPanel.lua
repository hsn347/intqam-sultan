local gSoldierSelectType = _G.gSoldierSelectType
_ENV = nil
;(nil)[gSoldierSelectType.SOLDIER_SELECT_TYPE_BUBING] = "common_btn_12"
;(nil)[gSoldierSelectType.SOLDIER_SELECT_TYPE_QIBING] = "common_btn_14"
;(nil)[gSoldierSelectType.SOLDIER_SELECT_TYPE_GONGBING] = "common_btn_13"
;(nil)[gSoldierSelectType.SOLDIER_SELECT_TYPE_CHEBING] = "common_btn_16"
;(nil)[gSoldierSelectType.SOLDIER_SELECT_TYPE_WEIGHT] = "common_btn_11"
local (nil)[gSoldierSelectType.SOLDIER_SELECT_TYPE_LEVEL], selectTypeTable = "common_btn_15", nil
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local worldDispatchArmySelectViewPanel = class("worldDispatchArmySelectViewPanel", baseFguiPanel)
function worldDispatchArmySelectViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("worldDispatchArmySelectViewPanel:ctor", self.viewName)
end
function worldDispatchArmySelectViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function worldDispatchArmySelectViewPanel:onInit()
	print("=======worldDispatchArmySelectViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("gem_btn_01"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_sort:setItemRenderer(handler(self, self.onItemRenderer_sort))
	self.fields.txt_title1:setString(i18n("common_text_4925"))
	self.fields.txt_tip1:setString(i18n("common_text_4926"))
	self.fields.txt_title2:setString(i18n("common_text_4927"))
	self.fields.txt_tip2:setString(i18n("common_text_4928"))
	self.fields.Text_defaultHero:setString(i18n("common_text_4942"))
	self.fields.Check_tick:addClickListener(handler(self, self.btnTickClick))
	self.fields.Text_defaultHero:fixPos()
	self.fields.Check_tick:fixPos()
end
function worldDispatchArmySelectViewPanel:onItemRenderer(index, obj)
	obj:setBtnColorIndex(3)
	obj:setString(i18n(selectTypeTable[index + 1]))
	obj:setTag(index + 1)
	obj:addClickListener(handler(self, self.btnClick))
end
function worldDispatchArmySelectViewPanel:onItemRenderer_sort(index, obj)
	obj:setBtnColorIndex(3)
	obj:setString(i18n(selectTypeTable[index + 1]))
	obj:setTag(index + 1)
	obj:addClickListener(handler(self, self.btnClick_sort))
end
function worldDispatchArmySelectViewPanel:onShow()
	print("=======worldDispatchArmySelectViewPanel:onShow")
	self.fields.List:setNumItems(#selectTypeTable)
	self.fields.List_sort:setNumItems(4)
	local isSelected = true
	_ENV = nil
	;(nil).byUID = true
	local defaultHero = SoraDConfigGet("Game:worldDispatchArmySelectViewPanel:defaultHero~bool", nil)
	if defaultHero ~= nil then
		isSelected = defaultHero
	end
	self.fields.Check_tick:setSelected(isSelected)
end
function worldDispatchArmySelectViewPanel:btnClick(eventContext)
	SoraDPlaySound()
	local tag = eventContext:getSender():getTag()
	print("btn click", tag)
	_ENV = "btn click"
	;("btn click").msg = "MESSAGE_ARMY_SELECT_TYPE"
	;("btn click").selectType = tag
	SoraDSendMessage("btn click")
	SoraDShowMsgTip(i18n("common_text_4359"))
	self:close()
end
function worldDispatchArmySelectViewPanel:btnClick_sort(eventContext)
	SoraDPlaySound()
	local tag = eventContext:getSender():getTag()
	print("btn click", tag)
	SoraDConfigSet("Game:worldDispatchArmySelectViewPanel:saveSort~integer", tag)
	_ENV = "Game:worldDispatchArmySelectViewPanel:saveSort~integer"
	;("Game:worldDispatchArmySelectViewPanel:saveSort~integer").msg = "MESSAGE_ARMY_SELECT_TYPE"
	;("Game:worldDispatchArmySelectViewPanel:saveSort~integer").sort = tag
	SoraDSendMessage("Game:worldDispatchArmySelectViewPanel:saveSort~integer")
	SoraDShowMsgTip(i18n("common_text_4359"))
	self:close()
end
function worldDispatchArmySelectViewPanel:btnTickClick()
	SoraDPlaySound()
	local defaultHero = self.fields.Check_tick:isSelected()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:worldDispatchArmySelectViewPanel:defaultHero~bool", defaultHero, nil)
	_ENV = "Game:worldDispatchArmySelectViewPanel:defaultHero~bool"
	;("Game:worldDispatchArmySelectViewPanel:defaultHero~bool").msg = "MESSAGE_ARMY_SELECT_TYPE"
	;("Game:worldDispatchArmySelectViewPanel:defaultHero~bool").defaultHero = defaultHero and 1 or 0
	SoraDSendMessage("Game:worldDispatchArmySelectViewPanel:defaultHero~bool")
end
return worldDispatchArmySelectViewPanel
