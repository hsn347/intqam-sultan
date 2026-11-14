local baseComponent = require("fgui.base.baseComponent")
local Com_jinnBeastLv = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonUI/Com_jinnBeastLv", Com_jinnBeastLv)
function Com_jinnBeastLv:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
	self.fields.Image_jinn:setVisible(false)
	self.fields.Text_jinn:setVisible(false)
end
function Com_jinnBeastLv:onShow()
end
function Com_jinnBeastLv:initData(data)
	if not data.beast then
		local _UPVALUE0_, beast = data.beast, data.beast
	end
	self:setBeastList(beast)
	if not data.jinnList then
		local _UPVALUE0_, jinnList = data.jinnList, data.jinnList
	end
	self:setJinnList(jinnList)
end
function Com_jinnBeastLv:setBeastList(beast)
	local divineBeastRead = include("divineBeastRead")
	local divineID = divineBeastRead.getDefaultDivineID()
	if not beast[tostring(divineID)] then
		local _ENV, info = beast[tostring(divineID)], beast[tostring(divineID)]
	end
	if info.stepLv then
		self.fields.Image_beast:setVisible(true)
		self.fields.title:setVisible(true)
		self.fields.title:setString(info.stepLv)
	else
		self.fields.Image_beast:setVisible(false)
		self.fields.title:setVisible(false)
	end
end
function Com_jinnBeastLv:setJinnList(jinnList)
end
return Com_jinnBeastLv
