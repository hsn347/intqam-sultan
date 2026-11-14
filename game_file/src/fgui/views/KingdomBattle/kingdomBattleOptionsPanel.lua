local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleOptionsPanel = class("kingdomBattleOptionsPanel", baseFguiPanel)
function kingdomBattleOptionsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleOptionsPanel:ctor", self.viewName)
end
function kingdomBattleOptionsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleOptionsPanel:onInit()
	print("=======kingdomBattleOptionsPanel:onInit")
	self.fields.Com_title:initData(i18n("conquestwar_text_57"), handler(self, self.onClickClose))
	self.viewType = self.proxy.param.viewType
	_UPVALUE4_ = self.fields.Com_title
	self.fields.Com_title[1] = "icon"
	self.fields.Com_title[2] = "Button_switch"
	self.fields.Com_title[3] = "Text_des"
	self.fields.Com_title[4] = "title"
	for _, value in ipairs(self.fields.Com_title) do
		self.fields.Com_Option:getChild(value):fixPos()
	end
	self.Button_switch = self.fields.Com_Option:getChild("Button_switch")
	self.Button_switch:addClickListener(handler(self, self.onClickSwitch))
	if self.viewType == 1 then
		self.fields.Com_Option:setString(i18n("conquestwar_text_59"))
		self.fields.Com_Option:getChild("Text_des"):setString(i18n("conquestwar_text_60"))
		self.fields.Text_des:setString(i18n("conquestwar_text_65"))
	else
		self.fields.Com_Option:setString(i18n("conquestwar_text_61"))
		self.fields.Com_Option:getChild("Text_des"):setString(i18n("conquestwar_text_62"))
		self.fields.Text_des:setString(i18n("conquestwar_text_63"))
	end
	self.fields.Label_Time:setTimeLast(function(_time)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, _time
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("conquestwar_text_58", nil, nil)
	end)
	if self.viewType == 1 then
		self.fields.Label_Time:beginTime(conquestWarCtrl:getSettingReinforceLefttime())
	else
		self.fields.Label_Time:beginTime(conquestWarCtrl:getSettingWaitingLefttime())
	end
	self.fields.Label_Time:setTimeEndListener(handler(self, self.close))
end
function kingdomBattleOptionsPanel:onShow()
	print("=======kingdomBattleOptionsPanel:onShow")
	self:updateButton()
end
function kingdomBattleOptionsPanel:updateButton()
	if self.viewType == 1 then
		self.Button_switch:setSelected(conquestWarCtrl:getToBeReinforcements())
	else
		self.Button_switch:setSelected(conquestWarCtrl:gettoBeReinforcHost())
	end
end
function kingdomBattleOptionsPanel:onClickSwitch(eventContext)
	SoraDPlaySound()
	local isSelected = eventContext:getSender():isSelected()
	_ENV = nil
	;(nil).chooseType = self.viewType
	;(nil).isOpen = isSelected
	conquestWarCtrl:reqReinforcementsChoose(nil)
end
return kingdomBattleOptionsPanel
