local snowyNightCarnivalCtrl = SoraDGetCtrl("snowyNightCarnivalCtrl")
local snowyNightCarnivalltCtrl = include("snowyNightCarnivalltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local SnowNightSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity2112/SnowNightSingle", SnowNightSingle)
function SnowNightSingle:onInit()
	_ENV = nil
	;(nil).unlock = false
	;(nil).gotNormal = false
	;(nil).gotExtra = false
	self.state, (nil).levelState = nil, false
	self.fields.List_normal:setItemRenderer(handler(self, self.onItemRendererNormal))
	self.fields.List_extra:setItemRenderer(handler(self, self.onItemRendererExtra))
	self:addClickListener(handler(self, self.onClickGetReward))
end
function SnowNightSingle:initData(index, data)
	self.level = index
	self.score = data.score
	self.normalData = snowyNightCarnivalltCtrl.getRewardConfigByLevel(self.level).normalreward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.normalData = serviceFunctions.tableFormat(self.normalData, nil)
	self.extralData = snowyNightCarnivalltCtrl.getRewardConfigByLevel(self.level).specialreward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.extralData = serviceFunctions.tableFormat(self.extralData, nil)
	self:setData()
	self.fields.Text_title:setString(tostring(index))
	self.fields.List_normal:setNumItems(table.nums(self.normalData))
	self.fields.List_extra:setNumItems(table.nums(self.extralData))
	self:setState()
end
function SnowNightSingle:setData()
	self.state.unlock = snowyNightCarnivalCtrl:getUnlockFurther()
	self.state.gotNormal = snowyNightCarnivalCtrl:isInGotNormal(self.level)
	self.state.gotExtra = snowyNightCarnivalCtrl:isInGotExtra(self.level)
	self.state.levelState = snowyNightCarnivalCtrl:getLevelState(self.level, self.score)
	dump(self.state, "fsjkfksdfjkdfjkd")
	print(self.state.levelState and self.state.gotNormal)
	print(self.state.levelState and self.state.gotExtra)
end
function SnowNightSingle:onItemRendererNormal(index, object)
	object:initData(index + 1, self.normalData[index + 1], self.state.levelState and self.state.gotNormal, true)
end
function SnowNightSingle:onItemRendererExtra(index, object)
	object:initData(index + 1, self.extralData[index + 1], self.state.levelState and self.state.gotExtra, self.state.unlock)
end
function SnowNightSingle:setState()
	if self.level > snowyNightCarnivalCtrl:getCanGetLevel() then
		self.controllers.state:setSelectedIndex(0)
	else
		self.controllers.state:setSelectedIndex(2)
	end
end
function SnowNightSingle:onClickGetReward(context)
	if self.level <= snowyNightCarnivalCtrl:getCanGetLevel() then
		snowyNightCarnivalCtrl:sendGetRewardByLevelMsg(self.level)
	else
		SoraDShowMsgTip(i18n("PrideRebate_text_13"))
	end
end
function SnowNightSingle:onShow()
end
return SnowNightSingle
