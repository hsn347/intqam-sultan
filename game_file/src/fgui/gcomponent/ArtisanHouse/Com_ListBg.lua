local baseComponent = require("fgui.base.baseComponent")
local Com_ListBg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ArtisanHouse/Com_ListBg", Com_ListBg)
function Com_ListBg:onInit()
	_UPVALUE8_ = nil
	;(nil)[1] = "n0"
	;(nil)[2] = "n1"
	;(nil)[3] = "n2"
	;(nil)[4] = "n3"
	;(nil)[5] = "n4"
	;(nil)[6] = "n5"
	;(nil)[7] = "n7"
	;(nil)[8] = "n8"
	for i, v in ipairs(nil) do
		self.fields[v]:fix(false)
	end
end
function Com_ListBg:onShow()
end
return Com_ListBg
