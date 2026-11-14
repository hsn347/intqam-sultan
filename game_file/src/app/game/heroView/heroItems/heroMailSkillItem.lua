local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local HeroMailSkillItem = class("heroMailSkillItem", function(target)
	if "userdata" == type(target) then
		return target
	else
		return SoraDCreateBasePanel("heroMailSkillItem")
	end
end)
function HeroMailSkillItem:ctor()
	self:setCascadeOpacityEnabled(true)
	self.imgIcon = SoraDGetChildByName(self, "Image_skillIcon")
	self.spBg = SoraDGetChildByName(self, "Sprite_skillBg")
	self.txtName = SoraDGetChildByName(self, "Text_skillName")
	self.txtDes = SoraDGetChildByName(self, "Text_skillDes")
	self.btnSkill = SoraDGetChildByName(self, "Button_skill")
	self.imgSkillFrm = SoraDGetChildByName(self, "Image_skillFrm")
	if self.btnSkill then
		self.btnSkill:addTouchEventListener(handler(self, self.btnSkillClick))
	end
end
function HeroMailSkillItem:initData(skillInfo)
	self.skillID = skillInfo.sid or skillInfo.skillID
	self.quality = skillInfo.quality
	self.skillInfo = skillInfo
	self:initView()
end
function HeroMailSkillItem:initPowerSkill(data)
	local sInfo = heroltCtrl:getStuntSkillInfo(data.skillID)
	local stuntSkillInfo = heroltCtrl:queryPowerSkillByID(data.skillID)
	if self.txtName then
		self.txtName:setString(i18n(sInfo.name))
	end
	self.imgIcon:loadTexture(sInfo.icon, ccui.TextureResType.plistType)
	self.btnSkill:setSwallowTouches(false)
	self.btnSkill:setTouchEnabled(false)
	self.spBg:setVisible(false)
	self.imgSkillFrm:setVisible(false)
	self.txtDes:setString(string.format("%s +%s%%(%s)", i18n(sInfo.des), tostring(stuntSkillInfo.buffData.max / 10), i18n("buff_text_27")))
	self.txtDes:setColor(cc.c3b(102, 50, 12))
end
function HeroMailSkillItem:initAwakeSkill(heroID)
	local awakeInfo = heroltCtrl:getAwakeSkill(heroID)
	local skillID = awakeInfo.skillID
	local skillInfo = heroltCtrl.getSkillDesInfo(skillID)
	self.txtDes:setContentSize(cc.size(350, 60))
	local desStr = SoraDGetCtrl("heroCtrl"):getHeroUSkillDes(heroID)
	self.txtDes:setString(desStr)
	self.imgIcon:loadTexture(skillInfo.herIcon, ccui.TextureResType.plistType)
	if self.txtName then
		self.txtName:setString(i18n(skillInfo.herName))
	end
	self.btnSkill:setSwallowTouches(false)
	self.btnSkill:setTouchEnabled(false)
	self.txtDes:setColor(cc.c3b(102, 50, 12))
end
function HeroMailSkillItem:initView(...)
	if self.txtDes then
		print("self.skillID=", self.skillID, "self.quality=", self.quality)
		local strDes = self.skillInfo.des
		if self.skillInfo.isLock then
			strDes = strDes .. "(" .. i18n("common_text_2274") .. ")"
			self.txtDes:setColor(cc.c3b(102, 50, 12))
		else
			self.txtDes:setColor(cc.c3b(102, 50, 12))
		end
		self.txtDes:setString(strDes)
	end
	if self.txtName then
		self.txtName:setString(self.skillInfo.title)
	end
	local info = heroltCtrl.getSkillDesInfo(self.skillID)
	self.imgIcon:loadTexture(info.herIcon, ccui.TextureResType.plistType)
	self.btnSkill:setSwallowTouches(false)
	self.spBg:setSpriteFrame(heroltCtrl.getSkillBg(self.quality))
end
function HeroMailSkillItem:btnSkillClick(sender, event)
	if event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		_ENV = tonumber(distance)
		tonumber(distance).skillID = self.skillID
		tonumber(distance).quality = self.quality
		uiManager:show("heroSkillPopView", (tonumber(distance)))
	end
end
return HeroMailSkillItem
