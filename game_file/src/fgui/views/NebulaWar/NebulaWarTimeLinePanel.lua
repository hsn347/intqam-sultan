local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTimeLinePanel = class("NebulaWarTimeLinePanel", baseFguiPanel)
function NebulaWarTimeLinePanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTimeLinePanel:ctor", self.viewName)
	self.isHidePrePanel = true
end
function NebulaWarTimeLinePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarTimeLinePanel:onInit()
	print("=======NebulaWarTimeLinePanel:onInit")
	self.timeLineData = nebulaWarUtil.getTimeLineData()
	local curState = nebulaActivityCtrl:getActivityCurState()
	if 0 < curState then
		local selectIndex = 1
		for i, data in ipairs(self.timeLineData) do
			if curState >= data.state then
				selectIndex = i
			else
				break
			end
		end
		self.selectIndex = selectIndex
	end
	self.fields.Text_title:setString(i18n("nebula_war_text_0217"))
	self.fields.List_item:setItemRenderer(handler(self, self.onTimeLineItemRederer))
	self.fields.List_item:setNumItems(#self.timeLineData)
	if self.selectIndex then
		self.fields.List_item:scrollToView(self.selectIndex - 1)
		self.fields.List_item:setSelectedIndex(self.selectIndex - 1)
	end
	self.fields.Movie_frame:setAllFrameName("dh_Xingyunqysjz_%02d.png", 1)
	self.fields.Usm_bg:updateUsmColor(self.fields.Image_bg:getColor())
end
function NebulaWarTimeLinePanel:onShow()
	print("=======NebulaWarTimeLinePanel:onShow")
end
function NebulaWarTimeLinePanel:onTimeLineItemRederer(index, obj)
	local curIndex = index + 1
	if not self.timeLineData[curIndex] then
		local _UPVALUE0_, data = self.timeLineData[curIndex], self.timeLineData[curIndex]
	end
	obj:setString(data.name or "")
	obj:getChild("Text_time"):setString(data.timeStr or "")
	obj:setTouchable(false)
	obj:getChild("Movie_select"):setAllFrameName("dh_Xingyunqyxz_%02d.png", 1)
	obj:fixChildrenPos()
	obj:fixChildren()
	local c_type = obj:getController("c_type")
	if curIndex == 1 then
		c_type:setSelectedIndex(1)
	elseif curIndex == #self.timeLineData then
		c_type:setSelectedIndex(2)
	else
		c_type:setSelectedIndex(0)
	end
	local c_state = obj:getController("c_state")
	if curIndex < self.selectIndex then
		c_state:setSelectedIndex(0)
	elseif curIndex == self.selectIndex then
		if curIndex == 1 then
			c_state:setSelectedIndex(2)
		elseif curIndex == #self.timeLineData then
			c_state:setSelectedIndex(0)
		else
			c_state:setSelectedIndex(1)
		end
	else
		c_state:setSelectedIndex(2)
	end
end
return NebulaWarTimeLinePanel
