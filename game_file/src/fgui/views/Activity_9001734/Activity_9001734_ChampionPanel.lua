local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001734_ChampionPanel = class("Activity_9001734_ChampionPanel", baseFguiPanel)
function Activity_9001734_ChampionPanel:ctor(...)
	self.isLRU = true
	Activity_9001734_ChampionPanel.super.ctor(self, ...)
	print("Activity_9001734_ChampionPanel:ctor", self.viewName)
end
function Activity_9001734_ChampionPanel:onInit()
	print("=======Activity_9001734_ChampionPanel:onInit")
	self.fields.list_country:setItemRenderer(handler(self, self.itemRenderer_list_country))
	self.fields.list_country:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItemEnter))
	self.fields.Panel_bg:setString(i18n("football_betting_text_04"))
	self.fields.btnConfirm:setString(i18n("common_text_054"))
	self.fields.btnConfirm:addClickListener(handler(self, self.onClick_btnConfirm))
end
function Activity_9001734_ChampionPanel:endShow()
	print("=======Activity_9001734_ChampionPanel:endShow")
	self:initData()
end
function Activity_9001734_ChampionPanel:onHide()
	self.param.callback = nil
end
function Activity_9001734_ChampionPanel:initData()
	self.curSelect = self.param.optionid
	local championSelectCfg = activity_9001734_Read.getChampionSelectCfg()
	self.countryList = championSelectCfg.options
	self.fields.list_country:setNumItems(#self.countryList)
	self:updateBtnConfirm()
end
function Activity_9001734_ChampionPanel:updateBtnConfirm()
	self.fields.btnConfirm:setEnabled(self.curSelect > 0)
end
function Activity_9001734_ChampionPanel:itemRenderer_list_country(index, obj)
	local data = self.countryList[index + 1]
	obj:initData(data)
	obj:setCheck(self.curSelect == data.optionid)
end
function Activity_9001734_ChampionPanel:onClickItemEnter()
	SoraDPlaySound()
	local index = self.fields.list_country:getSelectedIndex() + 1
	if index == 0 or index == self.curSelect then
		return
	end
	if 0 < self.curSelect then
		local lastSelectObj = self.fields.list_country:getChildAt(self.curSelect - 1)
		if lastSelectObj then
			lastSelectObj:setCheck(false)
		end
	end
	self.curSelect = index
	local obj = self.fields.list_country:getChildAt(index - 1)
	obj:setCheck(true)
	self:updateBtnConfirm()
end
function Activity_9001734_ChampionPanel:onClick_btnConfirm(context)
	SoraDPlaySound()
	if self.param.callback then
		local optionid = 0
		if 0 < self.curSelect then
			local data = self.countryList[self.curSelect]
			optionid = data.optionid
		end
		self.param.callback(optionid)
		self.param.callback = nil
	end
	self:close()
end
return Activity_9001734_ChampionPanel
