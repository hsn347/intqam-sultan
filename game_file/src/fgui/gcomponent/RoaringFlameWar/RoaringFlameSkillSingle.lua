local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local RoaringFlameSkillSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/RoaringFlameSkillSingle", RoaringFlameSkillSingle)
_ENV = fgui.register_extension
fgui.register_extension.NO_SKILL = 1
fgui.register_extension.HAS_SKILL = 2
local fgui.register_extension.LOCK, stateType = 3, fgui.register_extension
function RoaringFlameSkillSingle:onInit()
	self.index = 0
	self.curState = stateType.NO_SKILL
	self.fields.Button_get:setString(i18n("common_text_4347"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickBtnGet))
	self.fields.Button_detail:addClickListener(handler(self, self.onClickBtnDetail))
	self.fields.Button_change:setString(i18n("common_text_1417"))
	self.fields.Button_change:addClickListener(handler(self, self.onClickBtnChange))
	self:addClickListener(handler(self, self.onClickBtnLock))
end
function RoaringFlameSkillSingle:onShow()
end
function RoaringFlameSkillSingle:initData(data)
	dump(data, "==RoaringFlameSkillSingle:initData==")
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
function RoaringFlameSkillSingle:setState(state)
	self.curState = state
	self.controllers.c_state:setSelectedIndex(state - 1)
	if self.curState == stateType.NO_SKILL then
		self.fields.Sprite_frame:setVisible(false)
	else
		self.fields.Sprite_frame:setVisible(true)
	end
end
function RoaringFlameSkillSingle:initStateHasSkill(skillSlot)
	roaringFlameWarRead = nil
	;(nil)[1] = "framer_zcjn_jnk_03.png"
	;(nil)[2] = "framer_zcjn_jnk_04.png"
	local (nil)[3], qualityIcon = "framer_zcjn_jnk_05.png", nil
	local skillId = skillSlot.skillId
	self.skillId = skillId
	local config = roaringFlameWarRead.getSkillDisplayConfig(skillId)
	local qConfig = gAtlantisQualityConfig[config.quality]
	self.fields.Image_skill:setURL(config.img)
	self.fields.Text_name:setString(i18n(config.name))
	self.fields.Text_name:setColor(qConfig.color)
	self.fields.Sprite_frame:setURL(qualityIcon[config.quality])
end
function RoaringFlameSkillSingle:initNoSkillEffect(...)
	if not self.noSkillEffect then
		self.noSkillEffect = true
	end
end
function RoaringFlameSkillSingle:onClickBtnGet(...)
	SoraDPlaySound()
	if self.curState ~= stateType.NO_SKILL then
		return
	end
	roaringFlameWarCtrl:reqSkillLottery(self.index)
end
function RoaringFlameSkillSingle:onClickBtnDetail(...)
	SoraDPlaySound()
	if self.curState ~= stateType.HAS_SKILL then
		return
	end
	_ENV = nil
	;(nil).skillId = self.skillId
	uiManager:show("RoaringFlame_SkillDetail", nil)
end
function RoaringFlameSkillSingle:onClickBtnChange(...)
	SoraDPlaySound()
	if self.curState ~= stateType.HAS_SKILL then
		return
	end
	_ENV = nil
	;(nil).index = self.index
	uiManager:show("RoaringFlame_SkillChange", nil)
end
function RoaringFlameSkillSingle:onClickBtnLock(...)
	SoraDPlaySound()
	if self.curState ~= stateType.LOCK then
		return
	end
	uiManager:show("RoaringFlame_SkillGift")
end
function RoaringFlameSkillSingle:showUnLockEffect(...)
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.callFunc(function()
		SoraDShowLoading(self, nil, nil, true)
		self.fields.Com_Lock:setStatus(gHeroStoryUnLockType.ACTIVED)
	end)
	;(nil)[2] = ffa.delay(0.7)
	;(nil)[3] = ffa.callFunc(function()
		SoraDCloseLoading(self)
		_ENV = nil
		;(nil).index = self.index
		;(nil).isPrivilegeLock = true
		self:initData(nil)
	end)
	;(nil)[4] = ffa.callFunc(function()
		SoraDCloseLoading(self)
		_ENV = nil
		;(nil).index = self.index
		;(nil).isPrivilegeLock = true
		self:initData(nil)
	end)
	self:runAction(ffa.seq(nil))
end
function RoaringFlameSkillSingle:showChangeSkillEffect(...)
	SoraDShowLoading(self, nil, nil, true)
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.callFunc(function()
		local criSprite = cc.criSprite.createCriSprite("G_JNBH.usm", true, false, nil)
		criSprite:addTo(self, 1)
		criSprite:setPosition(self:getWidth() / 2 + 4, self:getHeight() / 2 + 6)
		criSprite:setBlendFunc(gl.ONE, gl.ONE)
	end)
	;(nil)[2] = ffa.delay(0.5)
	;(nil)[3] = ffa.callFunc(function()
		SoraDCloseLoading(self)
		local skillSlot = roaringFlameWarCtrl:getSkillSlot()
		_ENV = nil
		;(nil).index = self.index
		;(nil).skillSlot = skillSlot[tostring(self.index)]
		self:initData(nil)
	end)
	;(nil)[4] = ffa.callFunc(function()
		SoraDCloseLoading(self)
		local skillSlot = roaringFlameWarCtrl:getSkillSlot()
		_ENV = nil
		;(nil).index = self.index
		;(nil).skillSlot = skillSlot[tostring(self.index)]
		self:initData(nil)
	end)
	self:runAction(ffa.seq(nil))
end
return RoaringFlameSkillSingle
