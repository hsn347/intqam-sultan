local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local BAR_LEN = 460
local heroUskillStudySingle = class("heroUskillStudySingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroUskillStudySingle")
	end
	return target
end)
function heroUskillStudySingle:ctor()
	self.Node_normal = SoraDGetChildByName(self, "Node_normal")
	self.Sprite_skill = SoraDGetChildByName(self, "Sprite_skill")
	self.Text_skillName = SoraDGetChildByName(self, "Text_skillName")
	self.Text_oriBuff = SoraDGetChildByName(self, "Text_oriBuff")
	self.Text_preBuff = SoraDGetChildByName(self, "Text_preBuff")
	self.frame_buff = SoraDGetChildByName(self, "frame_buff")
	self.frame_buff:setVisible(false)
	self.Text_active = SoraDGetChildByName(self, "Text_active")
	self.Panel_pre = SoraDGetChildByName(self, "Panel_pre")
	self.Panel_pre:setSwallowTouches(false)
	self.Panel_now = SoraDGetChildByName(self, "Panel_now")
	self.Panel_now:setSwallowTouches(false)
	self.Text_MAX = SoraDGetChildByName(self, "Text_MAX")
	self.Text_MAX:setString("MAX")
	self.imgSelect = SoraDGetChildByName(self, "img_select")
	self.panelLock = SoraDGetChildByName(self, "panel_lock")
	self.panelLock:setSwallowTouches(false)
	self.txtLock = SoraDGetChildByName(self, "Text_lockLv")
	self.imgClick = SoraDGetChildByName(self, "Image_frm")
	self.spriteCrit = SoraDGetChildByName(self, "Sprite_crit")
	self.imgClick:setSwallowTouches(false)
	if not IsArClient then
		self.imgClick:addTouchEventListener(handler(self, self.btnImgCallBack))
		self.imgClick:setTouchEnabled(true)
	end
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	SoraDSetNodeArrayAdditive(self.Node_effect:getChildren())
	self:initEffectSet()
end
function heroUskillStudySingle:initEffectSet()
	SoraDStopEffectNode(self.Node_effect)
	SoraDGetChildByName(self.Node_effect, "dh_lingwu_01"):setOpacity(0)
	SoraDGetChildByName(self.Node_effect, "dh_xunzhangcx_05"):setOpacity(0)
	SoraDGetChildByName(self.Node_effect, "dh_lingwu_02"):setOpacity(0)
	SoraDGetChildByName(self.Node_effect, "dh_lingwu_03"):setOpacity(0)
end
function heroUskillStudySingle:initUnlockEffect()
	if not self.unlockAct then
		self.unlockAct = SoraDCreatAnimationEx("petCarUnlock", nil, false)
		self.unlockAct:setScale(0.8)
		self.unlockAct:setPosition(320, 60)
		self.unlockAct:addTo(self.Node_normal)
	end
end
function heroUskillStudySingle:showEffect(isCrit)
	self:stopAllActions()
	self:initEffectSet()
	_UPVALUE1_ = self
	self[1] = cca.delay(0.08333333333333333)
	self[2] = cca.callFunc(function()
		local cssFilePath = getCCSPath("heroUskillStudySingle")
		local action = cc.CSLoader:createTimeline(cssFilePath)
		action:gotoFrameAndPlay(0, false)
		self:runAction(action)
		action:setFrameEventCallFunc(function(frameEventName)
			if frameEventName:getEvent() == "reset" then
				SoraDResetEffectNode(self.Node_effect)
			end
		end)
	end)
	self[3] = cca.callFunc(function()
		local cssFilePath = getCCSPath("heroUskillStudySingle")
		local action = cc.CSLoader:createTimeline(cssFilePath)
		action:gotoFrameAndPlay(0, false)
		self:runAction(action)
		action:setFrameEventCallFunc(function(frameEventName)
			if frameEventName:getEvent() == "reset" then
				SoraDResetEffectNode(self.Node_effect)
			end
		end)
	end)
	local seq = cca.seq(self)
	self.Node_effect:setVisible(isCrit ~= true)
	self.spriteCrit:setVisible(isCrit)
	self:runAction(seq)
end
function heroUskillStudySingle:initData(data, otherData)
	local isAllUp = data.isAllUp
	local isRefresh = otherData.scroll and otherData.scroll.isRefresh
	local isSelect = data.isSelect or false
	local isFailed = otherData.isFailed
	local isAutoSave = otherData.isAutoSave
	if isRefresh then
		self:showEffect(false)
	end
	if isAllUp then
		self.Node_normal:setVisible(false)
		return
	end
	self.Node_normal:setVisible(true)
	local preData = otherData.skillBack
	local skillInfo = heroltCtrl:getStuntSkillInfo(data.skillID)
	heroltCtrl = heroltCtrl
	heroltCtrl[gSkillActiveType.PASSIVE_SKILL] = i18n("hero_text_63")
	heroltCtrl[gSkillActiveType.BATTLE_SKILL] = i18n("hero_text_64")
	local heroltCtrl[gSkillActiveType.INITIATIVE_SKILL], desTbl = i18n("hero_text_65"), heroltCtrl
	local stuntSkillInfo = heroltCtrl:queryPowerSkillByID(data.skillID)
	SoraDSetTextWidthHeight(self.Text_active, cc.size(470, 45))
	self.Text_active:setFontSize(16)
	self.Text_active:setString(desTbl[stuntSkillInfo.activeType] or i18n("hero_text_63"))
	self.Sprite_skill:setSpriteFrame(skillInfo.icon)
	self.Text_skillName:setString(i18n(skillInfo.des))
	local isMax = data.buffValue >= heroltCtrl:getMaxBuffValue(data.skillID)
	self.Text_oriBuff:setString(SoraDPreciseDecimal(data.buffValue / 1000, 4) * 100 .. "%")
	self.Text_MAX:setVisible(isMax)
	if SoraDFIsRA() then
		self.Text_oriBuff:setPositionX(math.min(300, self.Text_skillName:getPositionX() - self.Text_skillName:getContentSize().width - 5))
	else
		self.Text_oriBuff:setPositionX(math.max(340, self.Text_skillName:getPositionX() + self.Text_skillName:getContentSize().width + 5))
	end
	if not IsArClient then
		self.imgClick:setTag(data.skillID)
		self.imgClick:setTouchEnabled(data.isActive and not isMax)
		if data.isActive and data.buffValue <= 0 and data.skillID % 10 ~= 1 then
			heroltCtrl = data.isActive and not isMax
			;(data.isActive and not isMax).byUID = true
			local actData = SoraDConfigGet("Game:heroUskillStudySingle:finishStunt~table", data.isActive and not isMax)
			if actData[tostring(data.skillID % 10)] == nil then
				if not actData[tostring(data.skillID % 10)] then
					self:initUnlockEffect()
				end
				actData[tostring(data.skillID % 10)] = true
				heroltCtrl = math.max(340, self.Text_skillName:getPositionX() + self.Text_skillName:getContentSize().width + 5)
				math.max(340, self.Text_skillName:getPositionX() + self.Text_skillName:getContentSize().width + 5).byUID = true
				SoraDConfigSet("Game:heroUskillStudySingle:finishStunt~table", actData, math.max(340, self.Text_skillName:getPositionX() + self.Text_skillName:getContentSize().width + 5))
			end
		end
	end
	self.imgSelect:setVisible(not IsArClient and data.isActive and not isMax and isSelect)
	self.panelLock:setVisible(not IsArClient and not data.isActive and not isMax)
	heroltCtrl = math.max(340, self.Text_skillName:getPositionX() + self.Text_skillName:getContentSize().width + 5)
	math.max(340, self.Text_skillName:getPositionX() + self.Text_skillName:getContentSize().width + 5).lv = data.activeLevel
	self.txtLock:setString(i18n("hero_text_109", math.max(340, self.Text_skillName:getPositionX() + self.Text_skillName:getContentSize().width + 5)))
	if isMax and not isRefresh and not isAutoSave then
		self.frame_buff:setVisible(false)
		self.Text_preBuff:setVisible(false)
		self.Panel_pre:setContentSize(cc.size(0, 21))
		self.Panel_now:setContentSize(cc.size(BAR_LEN, 21))
	elseif next(preData) then
		local preValue = preData[tostring(data.skillID)].buffValue - data.buffValue
		local isCrit = preData[tostring(data.skillID)].crit == 1
		self.frame_buff:setVisible(preValue ~= 0 and IsArClient)
		self.frame_buff:setSpriteFrame(preValue < 0 and "frame_YX_juejidown.png" or isCrit and "img_lwbj_jiantou.png" or "frame_YX_juejiup.png")
		if isCrit then
			self:showEffect(true)
		end
		local char = 0 <= preValue and "+" or ""
		self.Text_preBuff:setVisible(IsArClient)
		self.Text_preBuff:setString(char .. SoraDPreciseDecimal(preValue / 1000, 4) * 100 .. "%")
		if SoraDFIsRA() then
			self.Text_preBuff:setPositionX(math.min(140, self.Text_oriBuff:getPositionX() - self.Text_oriBuff:getContentSize().width - 20))
			self.frame_buff:setPositionX(self.Text_preBuff:getPositionX() - self.Text_preBuff:getContentSize().width - 20)
		else
			self.Text_preBuff:setPositionX(math.max(500, self.Text_oriBuff:getPositionX() + self.Text_oriBuff:getContentSize().width + 20))
			self.frame_buff:setPositionX(self.Text_preBuff:getPositionX() + self.Text_preBuff:getContentSize().width + 20)
		end
		self.Text_preBuff:setColor(0 <= preValue and (isCrit and cc.c3b(255, 255, 0, 1) or cc.c3b(0, 190, 30)) or cc.c3b(190, 40, 40))
		self:setBar(data.buffValue, preData[tostring(data.skillID)].buffValue, heroltCtrl:getMaxBuffValue(data.skillID))
		if not IsArClient then
			if not isFailed then
				self.Text_oriBuff:setString(SoraDPreciseDecimal(preData[tostring(data.skillID)].buffValue / 1000, 4) * 100 .. "%")
			else
				self.Text_oriBuff:setString(SoraDPreciseDecimal(data.buffValue / 1000, 4) * 100 .. "%")
			end
		end
	else
		self.spriteCrit:setVisible(false)
		self.frame_buff:setVisible(false)
		self.Text_preBuff:setVisible(false)
		self.Panel_pre:setContentSize(cc.size(0, 21))
		self:setBar(data.buffValue, 0, heroltCtrl:getMaxBuffValue(data.skillID), true)
	end
end
function heroUskillStudySingle:setBar(oriVal, preVal, maxVal, isNoPreVal)
	if oriVal <= preVal then
		SoraDGetChildByName(self.Panel_now, "Image_bar"):loadTexture("progressbar_alliance_yellow.png", ccui.TextureResType.plistType)
		SoraDGetChildByName(self.Panel_pre, "Image_bar"):loadTexture("progressbar_01_green1.png", ccui.TextureResType.plistType)
		self.Panel_now:setContentSize(cc.size(BAR_LEN * (oriVal / maxVal), 21))
		self.Panel_pre:setContentSize(cc.size(BAR_LEN * (preVal / maxVal), 21))
	else
		if isNoPreVal then
			SoraDGetChildByName(self.Panel_pre, "Image_bar"):loadTexture("progressbar_alliance_yellow.png", ccui.TextureResType.plistType)
		else
			SoraDGetChildByName(self.Panel_now, "Image_bar"):loadTexture("progressbar_alliance_yellow.png", ccui.TextureResType.plistType)
			SoraDGetChildByName(self.Panel_pre, "Image_bar"):loadTexture("progressbar_01_red.png", ccui.TextureResType.plistType)
		end
		self.Panel_now:setContentSize(cc.size(BAR_LEN * (preVal / maxVal), 21))
		self.Panel_pre:setContentSize(cc.size(BAR_LEN * (oriVal / maxVal), 21))
	end
end
function heroUskillStudySingle:btnImgCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_HERO_AWAKE_SKILL_CLICK"
		;(nil).skillID = button:getTag()
		SoraDSendMessage(nil)
	end
end
return heroUskillStudySingle
