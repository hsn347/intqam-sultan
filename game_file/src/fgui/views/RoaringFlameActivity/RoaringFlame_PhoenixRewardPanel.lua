local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_PhoenixRewardPanel = class("RoaringFlame_PhoenixRewardPanel", baseFguiPanel)
function RoaringFlame_PhoenixRewardPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_PhoenixRewardPanel.super.ctor(self, ...)
	print("RoaringFlame_PhoenixRewardPanel:ctor", self.viewName)
end
function RoaringFlame_PhoenixRewardPanel:onInit()
	print("=======RoaringFlame_PhoenixRewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Smelt_text_09"))
	_ENV, _ENV = self.fields.Panel_bg, self.fields.Panel_bg.setString
	self.fields.Panel_bg.title = i18n("flames_dunes_text124")
	self.fields.Panel_bg.tag = 1
	self.fields.Panel_bg.type = 2
	_ENV, self.fields.Panel_bg.setString[1], self.fields.Panel_bg.tip = self.fields.Panel_bg, self.fields.Panel_bg, i18n("flames_dunes_text129")
	self.fields.Panel_bg.title = i18n("flames_dunes_text125")
	self.fields.Panel_bg.tag = 2
	self.fields.Panel_bg.type = 3
	_ENV, self.fields.Panel_bg.setString[2], self.fields.Panel_bg.tip = self.fields.Panel_bg, self.fields.Panel_bg, i18n("flames_dunes_text128")
	self.fields.Panel_bg.title = i18n("flames_dunes_text126")
	self.fields.Panel_bg.tag = 3
	self.fields.Panel_bg.type = 1
	self.tabsetArray, self.fields.Panel_bg.setString[3], self.fields.Panel_bg.tip = self.fields.Panel_bg.setString, self.fields.Panel_bg, i18n("flames_dunes_text127")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RoaringFlame_PhoenixRewardPanel:onItemRenderer(index, obj)
	obj:initData(self.taskList[index + 1], self.tabsetArray[self.tag].type)
end
function RoaringFlame_PhoenixRewardPanel:endShow()
	print("=======RoaringFlame_PhoenixRewardPanel:endShow")
	self.taskList, _ENV, self.tag = print, print, 1
	_ENV = nil
	;(nil).defaultClick = self.tag
	;(nil).tabsetArray = self.tabsetArray
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_TabW:initView(nil)
end
function RoaringFlame_PhoenixRewardPanel:onTabClick(tag)
	self.tag = tag
	self.fields.Text_tip:setString(self.tabsetArray[self.tag].tip)
	self.taskList = roaringFlameWarRead.getPhoenixTaskCfg(self.tabsetArray[self.tag].type)
	self:initView()
end
function RoaringFlame_PhoenixRewardPanel:sortTask()
	for k, v in ipairs(self.taskList) do
		v.status = roaringFlameWarCtrl:getPhoenixTaskStatus(v.index, self.tabsetArray[self.tag].type)
	end
	table.sort(self.taskList, function(a, b)
		if a.status == b.status then
			return a.index < b.index
		else
			return a.status < b.status
		end
	end)
end
function RoaringFlame_PhoenixRewardPanel:initView(target, data)
	self:sortTask()
	self.fields.List:setNumItems(#self.taskList)
	for k, v in ipairs(self.tabsetArray) do
		local num = roaringFlameWarCtrl:getPhoenixTaskRedNum(v.type)
		self.fields.com_TabW:setBtnRedDot(k, 0 < num, num)
	end
end
return RoaringFlame_PhoenixRewardPanel
