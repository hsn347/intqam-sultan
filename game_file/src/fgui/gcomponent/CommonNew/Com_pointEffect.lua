local baseComponent = require("fgui.base.baseComponent")
local Com_pointEffect = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_pointEffect", Com_pointEffect)
function Com_pointEffect:onInit()
	self.tableLabelSpare, _UPVALUE0_ = nil, nil
end
function Com_pointEffect:onShow()
end
function Com_pointEffect:showAddExpEffect(addExp)
	if addExp <= 0 then
		return
	end
	local comp
	if table.nums(self.tableLabelSpare) > 10 then
		comp = table.remove(self.tableLabelSpare, 1)
	else
		comp = fgui.UIPackage:createObjectFromURL("ui://CommonNew/Label_pointEffect")
		comp:addTo(self)
		local Ani_point = comp:getChild("Ani_point")
		Ani_point:setAllFrameName("dh_zbhd1_%.2d.png", 1)
	end
	table.insert(self.tableLabelSpare, comp)
	comp:setPosition(math.random(0, self:getWidth()), math.random(0, self:getHeight()))
	comp:setString("+" .. tostring(addExp))
	comp:getTransition("t0"):play()
end
return Com_pointEffect
