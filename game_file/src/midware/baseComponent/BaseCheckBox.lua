local BaseCheckBox = class("BaseCheckBox", fgui.GButton)
function BaseCheckBox:create(bgName, iconName)
	local ret = fgui.UIPackage.CreateObject1("Base", "BaseCheckBox")
	ret.isCocos = true
	ret:setPosition(0, 0)
	if bgName then
		local bg = ret:getChild("bg")
		bg.isCocos = false
		ret:getChild("bg"):setURL(bgName)
		ret:getChild("icon"):setURL(iconName)
	end
	return ret
end
return BaseCheckBox
