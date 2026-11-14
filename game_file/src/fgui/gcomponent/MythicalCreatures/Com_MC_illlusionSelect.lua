local baseComponent = require("fgui.base.baseComponent")
local Com_MC_illlusionSelect = fgui.extension_class(fgui.GComponent, baseComponent)
local equipDesRead = include("equipDesRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_illlusionSelect", Com_MC_illlusionSelect)
function Com_MC_illlusionSelect:onInit()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.list:setNumItems(5)
end
function Com_MC_illlusionSelect:onShow()
end
function Com_MC_illlusionSelect:setSelectCallback(callback)
	self.selectedCallback = callback
end
function Com_MC_illlusionSelect:onItemRenderer(index, obj)
	obj:setTitle(equipDesRead.getQualityName(index))
	obj:addClickEventListener(handler(self, self.onQualityClick), index)
end
function Com_MC_illlusionSelect:onQualityClick(sender, index)
	SoraDPlaySound()
	if self.selectedCallback then
		self.selectedCallback(index)
	end
	self:setVisible(false)
end
return Com_MC_illlusionSelect
