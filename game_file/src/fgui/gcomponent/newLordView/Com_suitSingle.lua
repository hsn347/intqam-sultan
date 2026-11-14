local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_suitSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_suitSingle", Com_suitSingle)
function Com_suitSingle:onInit()
end
function Com_suitSingle:onShow()
end
function Com_suitSingle:initData(data, equipWearInfo)
	local isMatch = false
	local quality = 0
	for _, info in pairs(equipWearInfo) do
		if type(info) == "table" and info:getEID() == data.equipid then
			quality = info:getEquipmentQuality()
			isMatch = true
		end
	end
	self.fields.bg:setSpriteFrame(isMatch and equipDesRead.getBg(quality) or equipDesRead.getBg(0))
	self.fields.icon:setSpriteFrame(data.icon)
	self.controllers.c1:setSelectedIndex(isMatch and 0 or 1)
end
return Com_suitSingle
