local _ENV, BaseSlider
function BaseSlider:create()
	local ret = fgui.UIPackage.CreateObject("Base", "BaseSlider")
	ret.isCocos = true
	ret:setPosition(0, 0)
	return ret
end
return BaseSlider
