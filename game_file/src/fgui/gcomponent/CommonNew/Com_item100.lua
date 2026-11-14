local Com_item = require("fgui.gcomponent.CommonNew.Com_item")
local baseComponent = require("fgui.base.baseComponent")
local Com_item100 = fgui.extension_class(fgui.GButton, Com_item)
fgui.register_extension("ui://CommonNew/Com_item40", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item50", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item60", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item70", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item80", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item90", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item95", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item100", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item110", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item120", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item130", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item140", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item150", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item55", Com_item100)
fgui.register_extension("ui://CommonNew/Com_item100WithText", Com_item100)
fgui.register_extension("ui://Shiftingstars/Com_item45", Com_item100)
fgui.register_extension("ui://Anniversary2022/Com_item115", Com_item100)
fgui.register_extension("ui://pyramidView/Com_item", Com_item100)
fgui.register_extension("ui://EighthAnniversary/Com_item45", Com_item100)
fgui.register_extension("ui://ManorFarm/ComFarmItem100", Com_item100)
fgui.register_extension("ui://ManorFarm/ComFarmItem120", Com_item100)
fgui.register_extension("ui://ManorFarm/Com_item120_farmbag", Com_item100)
function Com_item100:onInit()
	local item = self:getChild("Com_item")
	self.fields = fguiHelper.get_fields(item)
	self.oriControllers = self.controllers
	self.controllers = fguiHelper.get_controllers(item)
	self.transitions = fguiHelper.get_transitions(item)
	self.super.onInit(self)
	self:fitImageSelect()
end
function Com_item100:onShow()
end
function Com_item100:setItemStatus(index)
	if self.oriControllers.cStatus then
		self.oriControllers.cStatus:setSelectedIndex(index)
	end
end
function Com_item100:fitImageSelect(...)
	local obj = self.fields.Image_select
	if obj then
		local item = self:getChild("Com_item")
		local itemScale = item:getScale()
		if itemScale ~= 0 then
			local scale = obj:getScale()
			obj:setScale(scale / itemScale)
		end
		local size = self:getSize()
		obj:setSize(size.width + 20, size.height + 20)
	end
end
return Com_item100
