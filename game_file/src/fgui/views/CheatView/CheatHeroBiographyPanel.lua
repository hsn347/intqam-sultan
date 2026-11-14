local heroBiographyRead = include("heroBiographyRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatHeroBiographyPanel = class("CheatHeroBiographyPanel", baseFguiPanel)
function CheatHeroBiographyPanel:ctor(...)
	CheatHeroBiographyPanel.super.ctor(self, ...)
	print("CheatHeroBiographyPanel:ctor", self.viewName)
end
function CheatHeroBiographyPanel:onInit()
	print("=======CheatHeroBiographyPanel:onInit")
	self.fields.Panel_bg:setString("英雄列传")
	self.fields.Text_selectAll:setString("全选")
	self.fields.Check_tick:addClickListener(handler(self, self.btnClick))
	self.fields.List:setItemRenderer(handler(self, self.onBiographyRenderer))
end
function CheatHeroBiographyPanel:onBiographyRenderer(index, obj)
	obj:initData(index + 1, self.editData)
end
function CheatHeroBiographyPanel:onShow()
	print("=======CheatHeroBiographyPanel:onShow")
	self.editData = self.param.editData
	self.num = heroBiographyRead.getBiographyNum()
	self:setAllSelect()
	self:initView()
end
function CheatHeroBiographyPanel:setAllSelect()
	local isAllSelect = true
	for i = 1, self.num do
		if not self.editData.biographyIndex[i] then
			isAllSelect = false
			break
		end
	end
	self.fields.Check_tick:setSelected(isAllSelect)
end
function CheatHeroBiographyPanel:initView(target, data)
	if data then
		if data.index then
			self.editData.biographyIndex[data.index] = data.isSelect
		elseif data.isAllSelect ~= nil then
			for i = 1, self.num do
				self.editData.biographyIndex[i] = data.isAllSelect
			end
		end
		self:setAllSelect()
	end
	self.fields.List:setNumItems(self.num)
end
function CheatHeroBiographyPanel:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_BIOGRAPHY"
	;(nil).isAllSelect = self.fields.Check_tick:isSelected()
	SoraDSendMessage(nil)
end
function CheatHeroBiographyPanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_BIOGRAPHY"
	;(nil).biographyIndex = self.editData.biographyIndex
	SoraDSendMessage(nil)
end
return CheatHeroBiographyPanel
