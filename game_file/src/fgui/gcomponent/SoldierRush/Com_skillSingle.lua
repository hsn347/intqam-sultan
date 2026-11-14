local soldierRushRead = include("soldierRushRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_skillSingle", Com_skillSingle)
function Com_skillSingle:onInit()
	self.isLong = false
	self:addClickListener(handler(self, self.onClick))
	self:addLongPressListener(handler(self, self.onLongPress))
	self.fields.progress:setTexture("SinglePicture/G_round.png")
end
function Com_skillSingle:onShow()
end
function Com_skillSingle:initData(index, status, skillID, isUseModel, minCfgID)
	self.index = index
	self.status = status
	self.skillID = skillID
	self.isUseModel = isUseModel
	self.minCfgID = minCfgID
	if self.status == 1 and self.isUseModel then
		self.status = 3
	end
	self.controllers.c1:setSelectedIndex(self.status)
	if self.status == 0 then
		local skillCfg = soldierRushRead.getSkillCfg(self.skillID)
		self.fields.icon:setSpriteFrame(skillCfg.SkillIcon)
		self.fields.qualityBg:setIcon(heroltCtrl.getBg(skillCfg.SkillQuality))
	end
end
function Com_skillSingle:setData(data)
	self.controllers.c1:setSelectedIndex(0)
	local skillCfg = soldierRushRead.getSkillCfg(data.id)
	self.fields.icon:setSpriteFrame(skillCfg.SkillIcon)
	self.fields.qualityBg:setIcon(heroltCtrl.getBg(skillCfg.SkillQuality))
end
function Com_skillSingle:onClick()
	SoraDPlaySound()
	if self.isLong then
		self.isLong = false
		return
	end
	if self.status == 2 then
		local lvCfg = soldierRushRead.getLevelCfg(self.minCfgID)
		_ENV = nil
		;(nil).num1 = lvCfg.Chapter
		;(nil).num2 = lvCfg.LevelId
		SoraDShowMsgTip(i18n("soldier_rush_text_16", nil))
	elseif self.status == 1 or self.status == 0 and not self.isUseModel then
		_ENV = i18n("soldier_rush_text_16", nil)
		i18n("soldier_rush_text_16", nil).index = self.index
		uiManager:show("SoldierRushSkillChoose", i18n("soldier_rush_text_16", nil))
	elseif self.status == 0 and self.isUseModel then
		if self._cdTime and 0 < self._cdTime then
			SoraDShowMsgTip(i18n("soldier_rush_text_35"))
			return
		end
		local skillCfg = soldierRushRead.getSkillCfg(self.skillID)
		self.cdTime = skillCfg.SkillCd
		local skillEffect = skillCfg.EffectTarget
		if skillEffect == 0 then
		elseif skillEffect == 1 then
		elseif skillEffect == 2 then
		elseif skillEffect == 3 then
		end
		self:runCDAction()
	end
end
function Com_skillSingle:runCDAction()
	if self.cdTime > 0 then
		self.controllers.c2:setSelectedIndex(1)
		self._cdTime = self.cdTime
		_UPVALUE2_ = self.controllers.c2
		self.controllers.c2[1] = ffa.callFunc(function()
			self.fields.progress:setFillAmount(self._cdTime / self.cdTime)
			self._cdTime = self._cdTime - 1
		end)
		self.controllers.c2[2] = ffa.delay(1)
		self.controllers.c2[3] = ffa.callFunc(function()
			if self._cdTime <= 0 then
				self:stopAllActions()
				self.controllers.c2:setSelectedIndex(0)
			end
		end)
		self.controllers.c2[4] = ffa.callFunc(function()
			if self._cdTime <= 0 then
				self:stopAllActions()
				self.controllers.c2:setSelectedIndex(0)
			end
		end)
		local action = ffa.seq(self.controllers.c2)
		self:runAction(ffa.repeatForever(action))
	end
end
function Com_skillSingle:onLongPress()
	SoraDPlaySound()
	if self.isUseModel then
		self.isLong = true
		_ENV = nil
		;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_SKILL_INFO"
		;(nil).index = self.skillID
		SoraDSendMessage(nil)
	end
end
return Com_skillSingle
