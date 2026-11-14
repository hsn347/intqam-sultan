local baseComponent = require("fgui.base.baseComponent")
local Com_officialAttrSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMemberView/Com_officialAttrSingle", Com_officialAttrSingle)
function Com_officialAttrSingle:onInit()
	self:fixChildrenPos()
	self.fields.Icon_bg:fix()
end
function Com_officialAttrSingle:onShow()
end
function Com_officialAttrSingle:initData(data)
	self.fields.Icon_bg:setSpriteFrame(data.png)
	self.fields.Text_officialName:setString(data.name)
	self.fields.Text_attribute:setString(data.attribute)
end
return Com_officialAttrSingle
