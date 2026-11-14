local artifactRuneRead = include("artifactRuneRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_attrEx = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_attrEx", Com_attrEx)
function Com_attrEx:onInit()
end
function Com_attrEx:onShow()
end
function Com_attrEx:initData(data)
	local artifactRuneRead, extraProperty = nil, data or nil
	for i = 1, 3 do
		if extraProperty[i] then
			self.fields["n" .. i]:setVisible(true)
			local _, quality = artifactRuneRead.getPropertyArray(extraProperty[i][1])
			self.fields["n" .. i]:setColor(artifactRuneRead.getColor(quality, extraProperty[i][3]))
		else
			self.fields["n" .. i]:setVisible(false)
		end
	end
end
return Com_attrEx
