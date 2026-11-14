local buffDesRead = include("buffDesRead")
local buffltCtrl = include("buffltCtrl")
local extremelySkillfulRead = include("extremelySkillfulRead")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_BuffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExtremelySkillful/Com_BuffSingle", Com_BuffSingle)
function Com_BuffSingle:onInit()
	self:fixChildrenPos()
	self.fields.list:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_BuffSingle:onShow()
end
function Com_BuffSingle:onItemRederer(index, object)
	if index == 0 then
		object:setString(self.strText1)
		object:setSize(self.sizeText)
	else
		local effectType, buffNum = ExtremelySkillfulCtrl:getBuffInfoByTypeIndex(self.type, self.lvMin, index)
		object:setString(buffDesRead.getTitleValueWithValue(effectType, buffNum or 0, true))
		object:setSize(self.sizeText)
	end
end
function Com_BuffSingle:initData(CastleLv, index, type)
	self.index = index + 1
	self.type = type
	self.lvMin = CastleLv[2]
	self.lvMax = CastleLv[3]
	self.strText1 = string.format("%s-%s", string.format("lv%d", self.lvMin), string.format("lv%d", self.lvMax))
	self.controllers.c2:setSelectedIndex(0)
	self.controllers.c1:setSelectedIndex(index % 2)
	local nums = extremelySkillfulRead.getBuffNums(ExtremelySkillfulCtrl:getGroupIndex()) + 1
	self.sizeText = cc.size(544 / nums, 38)
	self.fields.list:setNumItems(nums)
end
return Com_BuffSingle
