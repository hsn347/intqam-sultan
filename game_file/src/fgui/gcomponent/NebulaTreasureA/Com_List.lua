local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_List = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaTreasureA/Com_List", Com_List)
function Com_List:onInit()
	self:fixChildrenPos()
	self.fields.Check_tick:addClickListener(handler(self, self.onClickCheck))
end
function Com_List:onShow()
end
function Com_List:initdata(index, award, isSelected, canTouch)
	self.index = index
	self.fields.Com_Item:initData(award.id, award.count)
	self.fields.Text_Name:setString(publicRead.getName(award.id))
	self.fields.Check_tick:setSelected(isSelected)
	self.fields.Check_tick:setTouchable(canTouch)
end
function Com_List:setHandleBack(handle)
	self.handle = handle
end
function Com_List:onClickCheck()
	SoraDPlaySound()
	if self.handle then
		self.handle(self.index)
	end
end
return Com_List
