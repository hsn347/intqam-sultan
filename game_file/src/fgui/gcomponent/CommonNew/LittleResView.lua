local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local LittleResView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/LittleResView", LittleResView)
function LittleResView:onInit()
	self.columnGap = self.fields.List_res:getColumnGap()
	self.record_y = self:getY()
	self.fields.List_res:setItemRenderer(handler(self, self.onItemRenderer))
end
function LittleResView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshRes))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_REFREASH_ESSENCE", handler(self, self.refreshRes))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA_BAG", handler(self, self.refreshRes))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshRes))
end
function LittleResView:onItemRenderer(index, obj)
	obj:setIcon(self:getIcon(index + 1))
	obj:setString(self:getCount(index + 1))
end
function LittleResView:getIcon(index)
	local info = self.resList[index]
	if info.icon then
		print("icon", info.icon)
		return info.icon
	end
	return publicRead.getIcon(info.id)
end
function LittleResView:getCount(index)
	local info = self.resList[index]
	if info.getCountFunc then
		return info.getCountFunc(info.id)
	end
	return publicUtil.getCount(info.id)
end
function LittleResView:onShow()
	self:refreshRes()
end
function LittleResView:initData(resList)
	dump(resList, "resList====", 10)
	self.resList = resList
	self:refreshRes()
end
function LittleResView:refreshRes(target, data)
	print("refreshRes!!!", target, data)
	if self.resList then
		print("LittleResView:refreshRes count====", #self.resList)
		self.fields.List_res:setNumItems(#self.resList)
		self.fields.List_res:resizeToFit(#self.resList)
	end
end
return LittleResView
