local activity_9001596_Read = include("activity_9001596_Read")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_partGain = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001596/Com_partGain", Com_partGain)
function Com_partGain:onInit()
	self.wayList, _ENV = nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_count:fixPos()
end
function Com_partGain:onShow()
end
function Com_partGain:onListRenderer(index, obj)
	obj:initData(self.wayList[index + 1])
end
function Com_partGain:initData(part)
	self.part = part
	self.itemID = activity_9001596_Read.getPartID(self.part)
	local num = backpackCtrl:getItemCount(self.itemID)
	local need = activity_9001596_Read.getPartNum(self.part)
	self.fields.item:initData(self.itemID, num)
	self.fields.Text_name:setString(publicRead.getName(self.itemID))
	activity_9001596_Read = publicRead.getName(self.itemID)
	publicRead.getName(self.itemID).num = fguiHelper.getColorString(num >= need and "#00BE1E" or "#FF0000", num)
	publicRead.getName(self.itemID).need = need
	self.fields.Text_count:setString(i18n("Ramadan_2024_text16", publicRead.getName(self.itemID)))
	self.wayList = activity_9001596_Read.getPartJump(self.part)
	self.fields.List:setNumItems(#self.wayList)
end
return Com_partGain
