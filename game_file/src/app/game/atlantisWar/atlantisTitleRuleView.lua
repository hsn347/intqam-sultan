local atlantisActivityRead = include("atlantisActivityRead")
local atlantisTitleRuleView = class("atlantisTitleRuleView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("atlantisTitleRuleView")
end)
function atlantisTitleRuleView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.imgIcon = SoraDGetChildByName(self, "Image_Icon")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
end
function atlantisTitleRuleView:initData(index)
	local info = atlantisActivityRead.getTitleConfig()[index]
	self.nodeCommonPopBox:setTitleName(i18n(info.name))
	self.textTitle:setString(i18n(info.describe))
	self.imgIcon:loadTexture(info.icon, ccui.TextureResType.plistType)
end
return atlantisTitleRuleView
