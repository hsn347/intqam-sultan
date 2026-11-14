local baseComponent = require("fgui.base.baseComponent")
local Com_lineSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlamewarwar/Com_lineSingle", Com_lineSingle)
function Com_lineSingle:onInit()
end
function Com_lineSingle:onShow()
end
function Com_lineSingle:initData(data)
	for i = 1, 3 do
		if data[i] then
			self.fields["Text_name" .. i]:setString(data[i].name)
		else
			self.fields["Text_name" .. i]:setString("")
		end
	end
end
return Com_lineSingle
