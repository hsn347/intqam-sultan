local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local ASD = require_data("atlantiswar_skill_display").data
local qualityConfig = gAtlantisQualityConfig
local atlantisSkillSingle = class("atlantisSkillSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisSkillSingle")
	end
	return target
end)
_ENV = "atlantisSkillSingle"
;("atlantisSkillSingle").NO_SKILL = 1
;("atlantisSkillSingle").HAS_SKILL = 2
local ("atlantisSkillSingle").LOCK, stateType = 3, "atlantisSkillSingle"
function atlantisSkillSingle:ctor()
	self.index = 0
	self.curState = stateType.NO_SKILL
	self:initWidget()
end
function atlantisSkillSingle:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	_ENV = SoraDGetAllChildFromWidget
	SoraDGetAllChildFromWidget[stateType.NO_SKILL] = self.Node_state1
	SoraDGetAllChildFromWidget[stateType.HAS_SKILL] = self.Node_state2
	self.Node_state, SoraDGetAllChildFromWidget[stateType.LOCK] = SoraDGetAllChildFromWidget, self.Node_state3
	self.Button_get:setTitleText(i18n("common_text_4347"))
	SoraDAutoSizeButtonTextByContent(self.Button_get)
	self.Button_get:addTouchEventListener(handler(self, self.btnGetClick))
	self.Button_detail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.Button_change:setTitleText(i18n("common_text_1417"))
	SoraDAutoSizeButtonTextByContent(self.Button_change)
	self.Button_change:addTouchEventListener(handler(self, self.btnChangeClick))
	self.Panel_click:addTouchEventListener(handler(self, self.btnPanelClick))
end
function atlantisSkillSingle:initData(data)
	dump(data, "==atlantisSkillSingle:initData==")
	self.index = data.index
	local isLock = false
	if self.index >= 4 and data.isPrivilegeLock ~= nil then
		self.isPrivilegeLock = data.isPrivilegeLock
		if not self.isPrivilegeLock then
			self:setState(stateType.LOCK)
			isLock = true
		end
	end
	if not isLock then
		local skillSlot = data.skillSlot
		if skillSlot then
			self:setState(stateType.HAS_SKILL)
			self:initStateHasSkill(skillSlot)
		else
			self:setState(stateType.NO_SKILL)
			self:initNoSkillEffect()
		end
	end
end
function atlantisSkillSingle:initNoSkillEffect(...)
	if not self.noSkillEffect then
		local criSprite = cc.criSprite.createCriSprite("JN_cz.usm", false, true, nil)
		criSprite:addTo(self.Node_state1, -1)
		criSprite:setPosition(2, 11)
		self.noSkillEffect = criSprite
		self.Sprite_wh:setVisible(false)
		self.Button_get:getChild("icon"):setAlpha(0)
	end
end
function atlantisSkillSingle:setState(state)
	self.curState = state
	for i, v in ipairs(self.Node_state) do
		v:setVisible(i == state)
	end
	if self.curState == stateType.NO_SKILL then
		self.Sprite_frame:setVisible(false)
	else
		self.Sprite_frame:setVisible(true)
	end
end
function atlantisSkillSingle:initStateHasSkill(skillSlot)
	ASD = nil
	;(nil)[1] = "framer_zcjn_jnk_03.png"
	;(nil)[2] = "framer_zcjn_jnk_04.png"
	local (nil)[3], qualityIcon = "framer_zcjn_jnk_05.png", nil
	local skillId = skillSlot.skillId
	local config = ASD[skillId]
	local qConfig = qualityConfig[config.quality]
	SoraChangeSpriteImage(self.Image_skill, config.img)
	self.Text_name:setString(i18n(config.name))
	self.Text_name:setColor(qConfig.color)
	self.Sprite_frame:setSpriteFrame(qualityIcon[config.quality])
	self.Button_detail:setTag(skillId)
end
function atlantisSkillSingle:btnGetClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curState ~= stateType.NO_SKILL then
			return
		end
		if self:checkSeasonFinish() then
			return
		end
		atlantisActivityCtrl:reqSkillLottery(self.index)
	end
end
function atlantisSkillSingle:btnDetailClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curState ~= stateType.HAS_SKILL then
			return
		end
		local panel = SoraDCreatePanel("atlantisSkillDetail")
		panel:initData(button:getTag())
		panel:show()
	end
end
function atlantisSkillSingle:btnChangeClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curState ~= stateType.HAS_SKILL then
			return
		end
		if self:checkSeasonFinish() then
			return
		end
		local panel = SoraDCreatePanel("atlantisSkillChange")
		panel:initData(self.index)
		panel:show()
	end
end
function atlantisSkillSingle:btnPanelClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curState ~= stateType.LOCK then
			return
		end
		if self:checkSeasonFinish() then
			return
		end
		if atlantisActivityCtrl:getIsTest() then
			SoraDShowMsgTip(i18n("common_text_699"))
			return
		end
		local panel = SoraDCreatePanel("atlantisSeasonGift")
		panel:show()
	end
end
function atlantisSkillSingle:initSeasonGift(...)
	self.Panel_click:setVisible(false)
	self:setState(stateType.LOCK)
end
function atlantisSkillSingle:checkSeasonFinish(...)
	if atlantisActivityCtrl:getActivityCurState() == ATLANTIS_WAR_STATE.FINISH then
		SoraDShowMsgTip(i18n("atlantiswar_text_0253"))
		return true
	end
end
function atlantisSkillSingle:showUnLockEffect(...)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(function()
		SoraDShowLoading(self, nil, nil, true)
		SoraDCreatAnimation("petCarUnlock", self.lockNode, false)
	end)
	;(nil)[2] = cca.delay(0.7)
	;(nil)[3] = cca.callFunc(function()
		SoraDCloseLoading(self)
		_ENV = nil
		;(nil).index = self.index
		;(nil).isPrivilegeLock = true
		self:initData(nil)
	end)
	;(nil)[4] = cca.callFunc(function()
		SoraDCloseLoading(self)
		_ENV = nil
		;(nil).index = self.index
		;(nil).isPrivilegeLock = true
		self:initData(nil)
	end)
	self:runAction(cca.seq(nil))
end
function atlantisSkillSingle:showChangeSkillEffect(...)
	SoraDShowLoading(self, nil, nil, true)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(function()
		local criSprite = cc.criSprite.createCriSprite("G_JNBH.usm", true, false, nil)
		criSprite:addTo(self, 1)
		criSprite:setPosition(4, 6)
		criSprite:setBlendFunc(gl.ONE, gl.ONE)
	end)
	;(nil)[2] = cca.delay(0.5)
	;(nil)[3] = cca.callFunc(function()
		SoraDCloseLoading(self)
		local skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
		_ENV = nil
		;(nil).index = self.index
		;(nil).skillSlot = skillSlot[tostring(self.index)]
		self:initData(nil)
	end)
	;(nil)[4] = cca.callFunc(function()
		SoraDCloseLoading(self)
		local skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
		_ENV = nil
		;(nil).index = self.index
		;(nil).skillSlot = skillSlot[tostring(self.index)]
		self:initData(nil)
	end)
	self:runAction(cca.seq(nil))
end
return atlantisSkillSingle
