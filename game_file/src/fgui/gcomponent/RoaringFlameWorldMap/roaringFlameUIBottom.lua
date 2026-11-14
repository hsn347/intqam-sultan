local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local roaringFlameUIBottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWorldMap/roaringFlameUIBottom", roaringFlameUIBottom)
function roaringFlameUIBottom:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_INITDATA", handler(self, self.refreshWarData))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_LOTTERY", handler(self, self.onMessageSkillLottery))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_REPLACE", handler(self, self.onMessageSkillReplace))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_USE", handler(self, self.onMessageSkillUse))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_SELECT", handler(self, self.onMessageSkillSelect))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUYGIFT", handler(self, self.onMessageBuyGiftSuccess))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_DECREEREWARD", handler(self, self.updateRed))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_REFRESHDATA", handler(self, self.updateRed))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_QUESTREWARD", handler(self, self.updateRed))
end
function roaringFlameUIBottom:onInit()
	print("==roaringFlameUIBottom:onInit==")
	_UPVALUE2_, _UPVALUE10_ = "==roaringFlameUIBottom:onInit==", print
	;("==roaringFlameUIBottom:onInit==").icon = "icon_shmc_main_skill.png"
	_UPVALUE2_, ("==roaringFlameUIBottom:onInit==")[1] = self.fields.Button_skill, self.fields.Button_skill
	_UPVALUE2_, ("==roaringFlameUIBottom:onInit==")[2] = self.fields.Button_skill, i18n("atlantiswar_skill_text_001")
	self.fields.Button_skill.icon = "icon_9001674_rk_zhenying.png"
	_UPVALUE2_, self.fields.Button_skill[1] = self.fields.Button_camp, self.fields.Button_camp
	_UPVALUE2_, self.fields.Button_skill[2] = self.fields.Button_camp, i18n("nebula_war_text_0001")
	self.fields.Button_camp.icon = "icon_9001674_rk_zchuodong.png"
	_UPVALUE2_, self.fields.Button_camp[1] = self.fields.Button_activity, self.fields.Button_activity
	_UPVALUE2_, self.fields.Button_camp[2] = self.fields.Button_activity, i18n("flames_dunes_text23")
	self.fields.Button_activity.icon = "frame_qmx_jiangli.png"
	_UPVALUE2_, self.fields.Button_activity[1] = self.fields.Button_reward, self.fields.Button_reward
	_UPVALUE2_, self.fields.Button_activity[2] = self.fields.Button_reward, i18n("atlantiswar_text_0019")
	self.fields.Button_reward.icon = "frame_qmx_phb.png"
	_UPVALUE2_, self.fields.Button_reward[1] = self.fields.Button_rank, self.fields.Button_rank
	_UPVALUE2_, self.fields.Button_reward[2] = self.fields.Button_rank, i18n("pyramid_btn_29")
	self.fields.Button_rank.icon = "frame_qmx_tuichu.png"
	_UPVALUE2_, self.fields.Button_rank[1] = self.fields.Button_quit, self.fields.Button_quit
	_UPVALUE2_, self.fields.Button_rank[2] = self.fields.Button_quit, i18n("common_text_3351")
	self.fields.Button_quit.icon = "icon_9001674_rk_zcrenwu.png"
	_UPVALUE2_, self.fields.Button_quit[1] = self.fields.Button_task, self.fields.Button_task
	_UPVALUE2_, self.fields.Button_quit[2] = self.fields.Button_task, i18n("flames_dunes_text14")
	self.fields.Button_task.icon = "icon_9001674_rk_lichengbei.png"
	_UPVALUE2_, self.fields.Button_task[1] = self.fields.Button_milestone, self.fields.Button_milestone
	_UPVALUE2_, self.fields.Button_task[2] = self.fields.Button_milestone, i18n("history_text_60")
	self.fields.Button_milestone.icon = "icon_9001674_rk_zhankuang.png"
	_UPVALUE2_, self.fields.Button_milestone[1] = self.fields.Button_map, self.fields.Button_map
	_UPVALUE2_, self.fields.Button_milestone[2] = self.fields.Button_map, i18n("flames_dunes_text75")
	self.fields.Button_map.icon = "frame_qmx_shuoming.png"
	self.fields.Button_map[1] = self.fields.Button_explain
	self.fields.Button_map[2] = i18n("common_text_1173")
	print[1] = "==roaringFlameUIBottom:onInit=="
	print[2] = self.fields.Button_skill
	print[3] = self.fields.Button_camp
	print[4] = self.fields.Button_activity
	print[5] = self.fields.Button_reward
	print[6] = self.fields.Button_rank
	print[7] = self.fields.Button_quit
	print[8] = self.fields.Button_task
	print[9] = self.fields.Button_milestone
	local print[10], config = self.fields.Button_map, print
	for __, cfg in ipairs(config) do
		local widget, title = cfg[1], cfg[2]
		widget:setString(title)
		widget:setIcon(cfg.icon)
		widget:addClickListener(handler(self, self.onClickOperateBtn))
	end
	self.fields.Button_expand:addClickListener(handler(self, self.onClickBtnExpand))
	self.isSkillShow = false
	local ccs_skill = include("worldMapAtlantisSkill").new(nil, gKingdomClassType.roaringFlame)
	ccs_skill:addTo(self.fields.ccs_skill)
	ccs_skill:setPosition(0, 0)
	self.ccs_skill = ccs_skill
	self.ccs_skill:setStateShow(self.isSkillShow)
	self:fitTroops()
	self:updateRed()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function roaringFlameUIBottom:updateRed()
	local ret1 = roaringFlameWarCtrl:isHaveDecreeReward()
	local ret2 = roaringFlameWarCtrl:isHaveDecreeCampReward()
	local retWeek, retWeekNum = roaringFlameWarCtrl:isHaveDecreeTaskReward(1)
	local retSeason, retSeasonNum = roaringFlameWarCtrl:isHaveDecreeTaskReward(2)
	self.fields.Button_task:setReddot(ret1 or ret2 or retWeek or retSeason)
end
function roaringFlameUIBottom:fitTroops()
	local fitHeight = 1136
	if fitHeight <= display.height then
		self.fields.troops:setPositionY(425 - display.height)
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	self.fields.troops:setPositionY(425 - display.height / fitScale)
end
function roaringFlameUIBottom:onShow()
	self:refreshWarData()
end
function roaringFlameUIBottom:onClickBtnExpand(...)
	SoraDPlaySound()
	self.isExpandShow = not self.isExpandShow
	if self.isSkillShow and self.isExpandShow then
		self.isSkillShow = false
		self.ccs_skill:setStateShow(self.isSkillShow)
	end
	self.fields.Button_expand:setSelected(self.isExpandShow)
end
function roaringFlameUIBottom:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_skill then
		self.isSkillShow = not self.isSkillShow
		self.ccs_skill:setStateShow(self.isSkillShow)
		self:refreshSkillBtnEffect()
		if self.isSkillShow and self.isExpandShow then
			self.isExpandShow = false
			self.fields.Button_expand:setSelected(false)
		end
	elseif sender == self.fields.Button_camp then
		uiManager:show("RoaringFlame_CampManage")
	elseif sender == self.fields.Button_activity then
		uiManager:show("RoaringFlameActivity_Main")
	elseif sender == self.fields.Button_reward then
		uiManager:show("RoaringFlame_RewardView")
	elseif sender == self.fields.Button_rank then
		uiManager:show("RoaringFlame_Rank")
	elseif sender == self.fields.Button_quit then
		roaringFlameWarUtil.quitBattlefield()
	elseif sender == self.fields.Button_task then
		_ENV = nil
		;(nil).tag = 2
		uiManager:show("RoaringFlame_Decree", nil)
	elseif sender == self.fields.Button_milestone then
		uiManager:show("RoaringFlame_MileStone")
	elseif sender == self.fields.Button_map then
		uiManager:show("RoaringFlameMapView")
	elseif sender == self.fields.Button_explain then
		_ENV = nil
		;(nil).instanceType = 0
		;(nil).classId = 112
		;(nil).title = i18n("flames_dunes_guide_tiele01")
		uiManager:show("WorldMapExplain", nil)
	end
end
function roaringFlameUIBottom:checkShowSkillEffect(...)
	local skillSlot = roaringFlameWarCtrl:getSkillSlot()
	local time_cd = roaringFlameWarRead.getConstValue("FLAMES_DUNES_SKILL_CD", 0)
	for k, skill in pairs(skillSlot) do
		local lastUseTime = skill.lastUseTime
		if not (lastUseTime and 0 < lastUseTime) or not (lastUseTime + time_cd > serviceFunctions.systemTime()) then
			return true
		end
	end
end
function roaringFlameUIBottom:refreshSkillBtnEffect(...)
	if self:checkShowSkillEffect() and not self.isSkillShow then
		if not self.skillBtnEffect then
			local criSprite = cc.criSprite.createCriSprite("G_shahaiUI_01.usm", false, true, nil)
			criSprite:addTo(self.fields.Button_skill, 1)
			criSprite:setBlendFunc(gl.ONE, gl.ONE)
			if SoraDFIsRA() then
				criSprite:setPosition(3, 38)
			else
				criSprite:setPosition(75, 38)
				criSprite:setScale(-1, 1)
			end
			self.skillBtnEffect = criSprite
		end
		self.skillBtnEffect:setVisible(true)
		self.skillBtnEffect:runAction(cca.fadeTo(0.1, 1))
	elseif self.skillBtnEffect and self.skillBtnEffect:isVisible() then
		_UPVALUE1_ = cca.fadeTo(0.1, 1)
		cca.fadeTo(0.1, 1)[1] = cca.fadeTo(0.1, 0)
		cca.fadeTo(0.1, 1)[2] = cca.callFunc(function()
			self.skillBtnEffect:setVisible(false)
		end)
		cca.fadeTo(0.1, 1)[3] = cca.callFunc(function()
			self.skillBtnEffect:setVisible(false)
		end)
		self.skillBtnEffect:runAction(cca.seq(cca.fadeTo(0.1, 1)))
	end
end
function roaringFlameUIBottom:refreshWarData(...)
	print("==roaringFlameUIBottom:refreshWarData=")
	self.ccs_skill:initData()
end
function roaringFlameUIBottom:onMessageSkillLottery(target, event)
	local index = event.index
	if roaringFlameWarCtrl:checkCandidateSkill(index) then
		return
	end
	self.ccs_skill:refreshOutWarSingle(index)
	self:refreshSkillBtnEffect()
end
function roaringFlameUIBottom:onMessageSkillReplace(target, event)
	local index = event.index
	self.ccs_skill:refreshOutWarSingle(index)
end
function roaringFlameUIBottom:onMessageSkillUse(target, event)
	local index = event.index
	self.ccs_skill:refreshOutWarSingle(index)
	self:refreshSkillBtnEffect()
end
function roaringFlameUIBottom:onMessageSkillSelect(target, event)
	local index = event.index
	self.ccs_skill:refreshOutWarSingle(index)
end
function roaringFlameUIBottom:onMessageSkillNotify(target, event)
	local notifyType = event.notifyType
	local notifyData = event.notifyData
	local buffId = event.buffId
	local buffEffect = event.buffEffect or notifyData.effect
	if not ATLANTIS_WAR_BOSS_ACTIVE_BUFF[buffEffect] then
		return
	end
	if notifyType == "addPlayerBuff" then
		self.ccs_skill:addInWarSingle(buffId)
	elseif notifyType == "removePlayerBuff" then
		self.ccs_skill:removeInWarSingle(buffId)
	elseif notifyType == "updatePlayerBuff" then
		self.ccs_skill:refreshInWarSingle(buffId)
	end
	self:refreshSkillBtnEffect()
end
function roaringFlameUIBottom:onMessageBuyGiftSuccess(...)
	for i = 4, 5 do
		self.ccs_skill:refreshOutWarSingle(i)
	end
	self:updateRed()
end
function roaringFlameUIBottom:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_expand" then
		return self.fields.Button_expand
	end
end
return roaringFlameUIBottom
