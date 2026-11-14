local baseComponent = require("fgui.base.baseComponent")
local Com_mapFloor = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroWeapon/Com_mapFloor", Com_mapFloor)
function Com_mapFloor:onInit()
	self:fixChildrenPos()
end
function Com_mapFloor:onShow()
end
function Com_mapFloor:initData(list)
	for i = 1, 3 do
		if list[i] then
			self.fields["n" .. i]:setVisible(true)
			self.fields["n" .. i]:initData(list[i])
		else
			self.fields["n" .. i]:setVisible(false)
		end
	end
end
return Com_mapFloor
