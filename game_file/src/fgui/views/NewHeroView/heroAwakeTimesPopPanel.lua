local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroAwakeTimesPopPanel = class("heroAwakeTimesPopPanel", baseFguiPanel)
function heroAwakeTimesPopPanel:ctor(...)
	self.isLRU = true
	heroAwakeTimesPopPanel.super.ctor(self, ...)
	print("heroAwakeTimesPopPanel:ctor", self.viewName)
end
function heroAwakeTimesPopPanel:onInit()
	print("=======heroAwakeTimesPopPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("common_text_4946"))
	self.fields.Text_tip:setString(i18n("common_text_4943"))
	self.fields.Text_chip_1:setString(i18n("common_text_4945"))
	self.fields.Text_chip_2:setString(i18n("common_text_4944"))
	self.fields.Check_tick_1:addClickListener(handler(self, self.onTick1Click))
	self.fields.Check_tick_2:addClickListener(handler(self, self.onTick2Click))
end
function heroAwakeTimesPopPanel:endShow()
	print("=======heroAwakeTimesPopPanel:endShow")
	self.costInfo = self.param.costInfo
	self.handler = self.param.handler
	self.id = self.param.costId or self.costInfo.id
	self.num = self.param.costNum or self.costInfo.num
	local isSp = self.costInfo.spId and self.param.costId and self.param.costId == self.costInfo.spId or false
	self.fields.Check_tick_1:setSelected(not isSp)
	self.fields.Check_tick_2:setSelected(isSp)
	self.controllers.c1:setSelectedIndex(self.costInfo.spId and 1 or 0)
	_UPVALUE4_ = self.costInfo.spId and 1 or 0
	;(self.costInfo.spId and 1 or 0)[1] = 1
	;(self.costInfo.spId and 1 or 0)[2] = 10
	;(self.costInfo.spId and 1 or 0)[3] = 50
	;(self.costInfo.spId and 1 or 0)[4] = 100
	self.timesCfg = constantRead.getConstValueArray("HERO_SPECIAL_SKILL_DISCOVERY_TIMES", self.costInfo.spId and 1 or 0)
	self.fields.List:setNumItems(#self.timesCfg)
end
function heroAwakeTimesPopPanel:itemRenderer_List(index, obj)
	local times = self.timesCfg[index + 1]
	obj:setCost(self.id, self.num * times)
	_ENV = nil
	;(nil).num = times
	obj:setTitle(i18n("common_text_4947", nil))
	obj:updateCostNum(times * self.num, self.id)
	obj:addClickListener(handlerEx(self, self.onBtnTimesClick, times))
end
function heroAwakeTimesPopPanel:onBtnTimesClick(times)
	SoraDPlaySound()
	print("self.id,self.num,times=====", self.id, self.num, times)
	if self.handler then
		self.handler(self.id, self.num, times)
	end
	self:close()
end
function heroAwakeTimesPopPanel:onTick1Click()
	SoraDPlaySound()
	self.id = self.costInfo.id
	self.num = self.costInfo.num
	self.fields.List:setNumItems(#self.timesCfg)
end
function heroAwakeTimesPopPanel:onTick2Click()
	SoraDPlaySound()
	self.id = self.costInfo.spId
	self.num = self.costInfo.spNum
	self.fields.List:setNumItems(#self.timesCfg)
end
return heroAwakeTimesPopPanel
