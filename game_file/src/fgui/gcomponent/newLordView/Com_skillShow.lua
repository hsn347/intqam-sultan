local lordSkillDesRead = include("lordSkillDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillShow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_skillShow", Com_skillShow)
function Com_skillShow:onInit()
end
function Com_skillShow:onShow()
end
function Com_skillShow:initData(skillID, iconType)
	self.skillID = tonumber(skillID)
	self.iconType = iconType
	self:showByIconType()
	self.fields.imgSkill:setSpriteFrame(lordSkillDesRead.getIcon(self.skillID))
end
function Com_skillShow:showByIconType()
	local bgImgName = "frame_common_jinengkuanghong.png"
	if self.iconType == LORD_ATTR.Auxiliary then
		bgImgName = "frame_common_jinengkuanghong.png"
	elseif self.iconType == LORD_ATTR.Develop then
		bgImgName = "frame_common_jinengkuanglan.png"
	elseif self.iconType == LORD_ATTR.Battle then
		bgImgName = "frame_common_jinengkuanglv.png"
	end
	self.fields.imgBg:setSpriteFrame(bgImgName)
end
function Com_skillShow:setGrayStatus(isGray)
	self.controllers.c1:setSelectedIndex(isGray and 0 or 1)
end
function Com_skillShow:setLabStatus(ret, str)
	self.controllers.c2:setSelectedIndex(ret and 1 or 0)
	self.fields.labelName:setString(str or "")
end
return Com_skillShow
