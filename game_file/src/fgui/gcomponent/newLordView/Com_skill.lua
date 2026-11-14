local lordSkillDesRead = include("lordSkillDesRead")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local baseComponent = require("fgui.base.baseComponent")
local Com_skill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_skill", Com_skill)
function Com_skill:onInit()
	self.controllers.c1:setSelectedIndex(0)
	self.fields.btnIcon:addClickListener(handler(self, self.btnClick))
end
function Com_skill:onShow()
end
function Com_skill:initData(data, iconType, setID)
	self.data = data
	self.iconType = iconType
	self.setID = setID
	self.controllers.c2:setSelectedIndex(self.data.isOpened and 1 or 0)
	self:showByIconType()
	self.fields.imgSkill:setSpriteFrame(lordSkillDesRead.getIcon(self.data.skillID))
	self.fields.labelLv:setString(self.data.currentLevel .. "/" .. self.data.maxLevel)
	self.fields.labelName:setString(lordSkillDesRead.getName(self.data.skillID))
end
function Com_skill:getBtnIcon()
	return self.fields.btnIcon
end
function Com_skill:showByIconType()
	local bgImgName = "frame_common_jinengkuanghong.png"
	if self.iconType == LORD_ATTR.Auxiliary then
		bgImgName = "frame_common_jinengkuanglv.png"
	elseif self.iconType == LORD_ATTR.Develop then
		bgImgName = "frame_common_jinengkuanglan.png"
	elseif self.iconType == LORD_ATTR.Battle then
		bgImgName = "frame_common_jinengkuanghong.png"
	end
	self.fields.imgBg:setSpriteFrame(bgImgName)
end
function Com_skill:btnClick()
	SoraDPlaySound()
	local isOK, needVipLv = lordSkillModuleAPI:isSkillSetUnlock(tostring(self.setID))
	if not isOK then
		_ENV = tostring(self.setID)
		tostring(self.setID).lv = needVipLv
		SoraDShowMsgTip(i18n("lordequip_text_11", tostring(self.setID)))
		return
	end
	_ENV = i18n("lordequip_text_11", tostring(self.setID))
	i18n("lordequip_text_11", tostring(self.setID)).skillID = self.data.skillID
	i18n("lordequip_text_11", tostring(self.setID)).setID = self.setID
	i18n("lordequip_text_11", tostring(self.setID)).iconType = self.iconType
	uiManager:show("skillStudyView", i18n("lordequip_text_11", tostring(self.setID)))
end
return Com_skill
