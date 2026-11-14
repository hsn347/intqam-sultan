local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Lab_item = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Lab_item", Lab_item)
function Lab_item:onInit()
	self:fixChildrenPos()
end
function Lab_item:onShow()
end
function Lab_item:initData(id, num, needNum)
	self.fields.icon:setSpriteFrame(publicRead.getIcon(id))
	if needNum then
		publicRead = publicRead.getIcon(id)
		publicRead.getIcon(id).var1 = fguiHelper.getColorString(needNum <= num and "#FFFFFF" or "#FF0000", num)
		publicRead.getIcon(id).var2 = needNum
		self.fields.title:setString(i18n("%{var1}/%{var2}", publicRead.getIcon(id)))
	else
		self.fields.title:setString(fguiHelper.getColorString("#FFFFFF", num))
	end
end
return Lab_item
