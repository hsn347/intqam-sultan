local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_buffDes = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_buffDes", com_Meteorite_buffDes)
local meteorMagicRead = include("meteorMagicRead")
local buffDesRead = include("buffDesRead")
function com_Meteorite_buffDes:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function com_Meteorite_buffDes:onShow()
end
function com_Meteorite_buffDes:initData(data, isShowBg)
	self.fields.bg:setVisible(data.title ~= nil or isShowBg)
	self.controllers.c1:setSelectedIndex(data.title == nil and 0 or 1)
	if data.title ~= nil then
		self.fields.title:setString(data.title)
		return
	end
	local buffDes = meteorMagicRead.getTitleBase(data.buffType, nil, true)
	local buffValue = meteorMagicRead.getTitleValueWithValue(data.buffType, data.value)
	self.fields.name:setString(buffDes)
	self.fields.value:setString(buffValue)
end
return com_Meteorite_buffDes
