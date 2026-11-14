local activity_9001700_Read = include("activity_9001700_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_firework = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001700/Com_firework", Com_firework)
_ENV = fgui.register_extension
fgui.register_extension.dw = 1
fgui.register_extension.zs = 2
local fgui.register_extension.zf, select_type = 3, fgui.register_extension
function Com_firework:onInit()
end
function Com_firework:onShow()
end
function Com_firework:initData(fireType, select1, select2, select3)
	self.fireType = fireType
	self:updateSelect(select_type.dw, select1)
	self:updateSelect(select_type.zs, select2)
	self:updateSelect(select_type.zf, select3)
end
function Com_firework:updateSelect(selectType, selectValue)
	local resource = activity_9001700_Read.getFireworkResource(self.fireType, selectType, selectValue)
	local Load_select = self.fields["Load_select" .. selectType]
	Load_select:setURL(resource)
	if selectType == select_type.dw then
		if selectValue == 3 then
			self.fields.Load_select2:setPosition(12, -8)
		else
			self.fields.Load_select2:setPosition(-7, -2)
		end
	end
end
function Com_firework:initFireWorksID(fireWorksID)
	local fireType = activity_9001700_Read.getFireWorksType(fireWorksID)
	local fireWorksNeeds = activity_9001700_Read.getFireWorksNeeds(fireWorksID)
	local select1 = fireWorksNeeds[select_type.dw]
	local select2 = fireWorksNeeds[select_type.zs]
	local select3 = fireWorksNeeds[select_type.zf]
	self:initData(fireType, select1, select2, select3)
end
return Com_firework
