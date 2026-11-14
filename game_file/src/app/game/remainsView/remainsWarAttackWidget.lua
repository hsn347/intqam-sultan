local remainsWarAttackWidget = class("remainsWarAttackWidget", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarAttackWidget")
	end
	return target
end)
function remainsWarAttackWidget:ctor()
	self.Node_attack_info = SoraDGetChildByName(self, "Node_attack_info")
	self.Node_attack_info:setVisible(false)
	self.iconHeadAttack1 = SoraDGetChildByName(self, "icon_head_attack_1")
	self.iconHeadDef1 = SoraDGetChildByName(self, "icon_head_def_1")
	self.txtAttackInfo = SoraDGetChildByName(self, "Text_attack_info")
	self.txtAttackTitle1 = SoraDGetChildByName(self, "Text_attack_title_1")
	self.txtAttackTitle1:setString(i18n("remains_text_182"))
	SoraDSetTextWidthHeight(self.txtAttackInfo, cc.size(320, 60))
	self.jibai_4 = SoraDGetChildByName(self, "jibai_4")
	local effect = SoraDCreatAnimation("Node_Effect_jsym01")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.jibai_4:getParent(), 1)
	local x, y = self.jibai_4:getPosition()
	effect:setPosition(x, y)
	self.campEffect = effect
end
_ENV, remainsWarAttackWidget.onMessageListener = function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end, function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end
;(function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end)[1] = "remains_text_175"
;(function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end)[2] = "remains_text_176"
;(function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end)[3] = "remains_text_177"
;(function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end)[4] = "remains_text_178"
local (function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end)[5], Attack_Info_Title = "remains_text_179", function(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end
function remainsWarAttackWidget:updateAttackInfo(data)
	local attackInfo = data.attackInfo
	if attackInfo == nil or not next(attackInfo) then
		return
	end
	dump(attackInfo, "attackInfo", 10)
	if attackInfo.bossType then
		self:updateAttackInfoBoss_imp(attackInfo)
	else
		self:updateAttackInfo_imp(attackInfo)
	end
end
function remainsWarAttackWidget:updateAttackInfo_imp(attackInfo)
	SoraDGetHeadFromManager(self.iconHeadAttack1, attackInfo.atkHeadid, attackInfo.atkAvatar)
	SoraDGetHeadFromManager(self.iconHeadDef1, attackInfo.defHeadid, attackInfo.defAvatar)
	local attackName = attackInfo.atkName
	if attackInfo.atkKid then
		attackName = attackName .. "#" .. tostring(attackInfo.atkKid)
	end
	local defName = attackInfo.defName
	if attackInfo.defKid then
		defName = defName .. "#" .. tostring(attackInfo.defKid)
	end
	self.iconHeadDef1:setScale(0.8)
	local winNum = attackInfo.atkWinNum or 1
	local attackTitle = Attack_Info_Title[winNum] or "remains_text_179"
	_ENV = nil
	;(nil).attackname = attackName
	;(nil).defname = defName
	self.txtAttackInfo:setString(i18n(attackTitle, nil))
	self:runAttackAnimation()
	if attackInfo.atkCamp == _G.RW_CAMP.SOUTH then
		self.jibai_4:runAction(cca.callFunc(function()
			self.jibai_4:setRotation(180)
			self.campEffect:setRotation(180)
		end))
	else
		self.jibai_4:runAction(cca.callFunc(function()
			self.jibai_4:setRotation(0)
			self.campEffect:setRotation(0)
		end))
	end
	if self.headAttackEffect then
		self.headAttackEffect:removeFromParent()
		self.headAttackEffect = nil
	end
	local effect = self:createHeadEffect(attackInfo.atkCamp)
	effect:addTo(self.iconHeadAttack1:getParent(), 1)
	self.headAttackEffect = effect
	if self.headDefEffect then
		self.headDefEffect:removeFromParent()
		self.headDefEffect = nil
	end
	local effect = self:createHeadEffect(attackInfo.defCamp)
	effect:addTo(self.iconHeadDef1:getParent(), 1)
	self.headDefEffect = effect
end
function remainsWarAttackWidget:createHeadEffect(camp)
	_ENV = nil
	;(nil)[_G.RW_CAMP.NORTH] = "Node_Effect_jsym02_blue"
	local (nil)[_G.RW_CAMP.SOUTH], campFileName = "Node_Effect_jsym02_red", nil
	local effect = SoraDCreatAnimation(campFileName[camp])
	effect:setScale(1.15)
	return effect
end
function remainsWarAttackWidget:runAttackAnimation()
	self.Node_attack_info:setVisible(true)
	_UPVALUE1_ = self.Node_attack_info
	self.Node_attack_info[1] = cca.delay(2)
	self.Node_attack_info[2] = cca.callFunc(function()
		self.Node_attack_info:setVisible(false)
	end)
	self.Node_attack_info[3] = cca.callFunc(function()
		self.Node_attack_info:setVisible(false)
	end)
	local seq = cca.seq(self.Node_attack_info)
	self.Node_attack_info:stopAllActions()
	self.Node_attack_info:runAction(seq)
	self:initEffect()
end
function remainsWarAttackWidget:updateAttackInfoBoss_imp(attackInfo)
	SoraDGetHeadFromManager(self.iconHeadAttack1, attackInfo.atkHeadid, attackInfo.atkAvatar)
	local attackName = attackInfo.atkName
	if attackInfo.atkKid then
		attackName = attackName .. "#" .. tostring(attackInfo.atkKid)
	end
	local remainsWarRead = include("remainsWarRead")
	local teamName = remainsWarRead.getCampName(attackInfo.atkCamp or 1)
	local defName
	local bossData = worldMapDefine.getWorldBossShow(attackInfo.bossType)
	if bossData then
		defName = i18n(bossData.name)
		local headImg = bossData.icon
		self.iconHeadDef1:setSpriteFrame(headImg)
		self.iconHeadDef1:setScale(1.0)
	end
	local attackTitle = "remains_text_206"
	_ENV = nil
	;(nil).attackname = attackName
	;(nil).defname = defName
	;(nil).teamName = teamName
	self.txtAttackInfo:setString(i18n(attackTitle, nil))
	self:runAttackAnimation()
	if attackInfo.atkCamp == _G.RW_CAMP.SOUTH then
		self.jibai_4:runAction(cca.callFunc(function()
			self.jibai_4:setRotation(180)
			self.campEffect:setRotation(180)
		end))
	else
		self.jibai_4:runAction(cca.callFunc(function()
			self.jibai_4:setRotation(0)
			self.campEffect:setRotation(0)
		end))
	end
	if self.headAttackEffect then
		self.headAttackEffect:removeFromParent()
		self.headAttackEffect = nil
	end
	local effect = self:createHeadEffect(attackInfo.atkCamp)
	effect:addTo(self.iconHeadAttack1:getParent(), 1)
	self.headAttackEffect = effect
	if self.headDefEffect then
		self.headDefEffect:removeFromParent()
		self.headDefEffect = nil
	end
end
function remainsWarAttackWidget:initEffect()
	local loop = false
	local cssFileName = "remainsWarAttackWidget"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(30, loop)
	self:stopAllActions()
	self:runAction(action)
end
function remainsWarAttackWidget:test()
	self:setVisible(true)
	_ENV = self.setVisible
	self.setVisible.atkWinNum = 1
	self.setVisible.atkKid = 1
	self.setVisible.atkName = "atkName"
	self.setVisible.atkHeadid = 1401
	self.setVisible.atkCamp = _G.RW_CAMP.SOUTH
	self.setVisible.defKid = 2
	self.setVisible.defName = "defName"
	self.setVisible.defHeadid = 1402
	local self.setVisible.defCamp, attackInfo = _G.RW_CAMP.NORTH, self.setVisible
	self:updateAttackInfo_imp(attackInfo)
end
return remainsWarAttackWidget
