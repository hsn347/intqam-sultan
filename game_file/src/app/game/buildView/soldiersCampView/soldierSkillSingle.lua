local armyDesRead = include("armyDesRead")
local SoldierSkillSingle = class("soldierSkillSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("soldierSkillSingle")
	end
	return target
end)
function SoldierSkillSingle:ctor()
	self:setCascadeOpacityEnabled(true)
	self.skillID = 0
	self.btnSkill = SoraDGetChildByName(self, "Button_skillBg")
	self.imgIcon = SoraDGetChildByName(self, "Image_icon")
	self.labelLv = SoraDGetChildByName(self, "Text_lv")
	if self.btnSkill then
		self.btnSkill:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function SoldierSkillSingle:initData(skillData)
	self.skillID = skillData
	self.imgIcon:loadTexture(armyDesRead.getSkillIcon(self.skillID))
	armyDesRead = armyDesRead.getSkillIcon(self.skillID)
	armyDesRead.getSkillIcon(self.skillID).lv = armyDesRead.getSkillLv(self.skillID)
	self.labelLv:setString(i18n("common_text_100", armyDesRead.getSkillIcon(self.skillID)))
end
function SoldierSkillSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).skillID = self.skillID
		uiManager:show("soldiersSkillInfoView", nil)
	end
end
function SoldierSkillSingle:setTouchEnabled(enable)
	if self.btnSkill then
		self.btnSkill:setSwallowTouches(false)
		self.btnSkill:setTouchEnabled(enable or false)
	end
end
return SoldierSkillSingle
