local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local HeroSkillItem = class("heroSkillItem", function(target)
	if "userdata" == type(target) then
		return target
	else
		return SoraDCreateBasePanel("heroSkillItem")
	end
end)
function HeroSkillItem:ctor()
	self.imgIcon = SoraDGetChildByName(self, "Image_skillIcon")
	self.spBg = SoraDGetChildByName(self, "Sprite_skillBg")
	self.txtName = SoraDGetChildByName(self, "Text_skillName")
	self.Sprite_lock = SoraDGetChildByName(self, "Sprite_lock")
	if self.Sprite_lock then
		self.Sprite_lock:setVisible(false)
	end
	self.btnSkill = SoraDGetChildByName(self, "Button_skill")
	if self.btnSkill then
		self.btnSkill:addTouchEventListener(handler(self, self.btnSkillClick))
	end
end
function HeroSkillItem:initData(skillID, quality, otherData)
	self.skillID = skillID
	self.quality = quality
	self.otherData = otherData
	self:initView()
end
function HeroSkillItem:initView(...)
	local skillName = heroltCtrl:getSkillDes(self.skillID, self.quality)
	if self.txtName then
		self.txtName:setString(skillName)
	end
	local info = heroltCtrl.getSkillDesInfo(self.skillID)
	self.imgIcon:loadTexture(info.herIcon, ccui.TextureResType.plistType)
	self.spBg:setSpriteFrame(heroltCtrl.getSkillBg(self.quality))
	if self.otherData then
		if self.otherData.isActive then
			if self.txtName then
				self.txtName:setColor(cc.c3b(255, 255, 0))
				self.txtName:setString(i18n(skillName))
			end
			SoraDGetCSBFather(self):setColor(cc.c3b(255, 255, 255))
			if self.Sprite_lock then
				self.Sprite_lock:setVisible(false)
			end
		else
			if self.txtName then
				self.txtName:setColor(cc.c3b(150, 150, 150))
				self.txtName:setString(i18n(skillName))
			end
			SoraDGetCSBFather(self):setColor(cc.c3b(150, 150, 150))
			if self.Sprite_lock then
				self.Sprite_lock:setVisible(true)
			end
		end
	end
end
function HeroSkillItem:btnSkillClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).skillID = self.skillID
		;(nil).quality = self.quality
		;(nil).otherData = self.otherData
		uiManager:show("heroSkillPopView", nil)
	end
end
return HeroSkillItem
