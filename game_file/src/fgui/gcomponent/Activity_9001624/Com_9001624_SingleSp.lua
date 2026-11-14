local activity_9001624_Read = include("activity_9001624_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001624_SingleSp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001624/Com_9001624_SingleSp", Com_9001624_SingleSp)
function Com_9001624_SingleSp:onInit()
	self:fixChildrenPos()
	self.fields.List_normal:setItemRenderer(handler(self, self.onItemRendererNormal))
	self.fields.List_extra:setItemRenderer(handler(self, self.onItemRendererExtra))
	self.fields.Text_normal:setString(i18n("cityUp_title_03"))
	self.fields.Text_gold:setString(i18n("StarlitNight_text_07"))
	self.fields.bg_normal:fix()
	self.fields.bg_gold:fix()
end
function Com_9001624_SingleSp:onShow()
end
function Com_9001624_SingleSp:initData(activityID, data)
	if data == nil then
		return
	end
	self.activityID = activityID
	self.activity_Ctrl = activity_9001624_Read.getActivityCtrl(self.activityID)
	self.unlock = self.activity_Ctrl:getIsAdvanceRewardUnlock()
	self.normalData = data.normalReward
	self.extralData = data.advanceReward
	self.fields.Text_num_normal:setString("" .. data.point .. "M")
	self.fields.Text_num_gold:setString("" .. data.point .. "M")
	if #self.normalData > 0 and #self.extralData > 0 then
		self.controllers.c1:setSelectedIndex(2)
	elseif #self.normalData > 0 then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	if #self.normalData > 0 then
		self:updateNormalData()
	end
	if #self.extralData > 0 then
		self:updateAdvanceData()
	end
end
function Com_9001624_SingleSp:updateNormalData()
	self.fields.List_normal:setNumItems(table.nums(self.normalData))
end
function Com_9001624_SingleSp:updateAdvanceData()
	self.fields.List_extra:setNumItems(table.nums(self.extralData))
end
function Com_9001624_SingleSp:onItemRendererNormal(index, object)
	object:initData(index + 1, self.normalData[index + 1], false, true)
end
function Com_9001624_SingleSp:onItemRendererExtra(index, object)
	object:initData(index + 1, self.extralData[index + 1], false, self.unlock)
end
return Com_9001624_SingleSp
