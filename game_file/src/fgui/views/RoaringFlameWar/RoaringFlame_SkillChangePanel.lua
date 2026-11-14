local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local qualityConfig = gAtlantisQualityConfig
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_SkillChangePanel = class("RoaringFlame_SkillChangePanel", baseFguiPanel)
function RoaringFlame_SkillChangePanel:ctor(...)
	RoaringFlame_SkillChangePanel.super.ctor(self, ...)
	print("RoaringFlame_SkillChangePanel:ctor", self.viewName)
	self.candidateSkill = roaringFlameWarCtrl:getCandidateSkill()
	self.skillSlot = roaringFlameWarCtrl:getSkillSlot()
	self.lotteryTimes = roaringFlameWarCtrl:getLotteryTimes()
	self.itemID = roaringFlameWarRead.getConstValue("ATLANTIS_WAR_SKILL_CAR", 839601)
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	self.itemCost = 1
	self.isAction = false
end
function RoaringFlame_SkillChangePanel:onInit()
	print("=======RoaringFlame_SkillChangePanel:onInit")
	self.fields.Panel_bg:setString(i18n("atlantiswar_skill_text_024"))
	self.fields.Text_tip:setString(i18n("atlantiswar_skill_text_025"))
	local Text_skillCur = self.fields.Node_skillCur:getChild("Text_skillCur")
	Text_skillCur:setString(i18n("atlantiswar_skill_text_026"))
	local Text_skillNew = self.fields.Node_skillNew:getChild("Text_skillNew")
	Text_skillNew:setString(i18n("atlantiswar_skill_text_053"))
	self.fields.Button_use:setString(i18n("Canyon_Treasur_text_14"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Button_get:addClickListener(handler(self, self.btnGetClick))
	self.fields.Button_get:setCost(self.itemID, self.itemCost)
	self.fields.Sprite_arrow:setRotation(SoraDFIsRA() and 180 or 0)
	self.fields.Node_skillNew:fixPos()
	self.fields.Node_skillCur:fixPos()
	self.fields.Usm_new:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Usm_show:setPositionX(self.fields.Node_skillNew:getPositionX() + 2)
	self.fields.Button_extra:addClickListener(handler(self, self.btnExtraClick))
	if not SoraDFIsRA() then
		self.controllers.ar:setSelectedIndex(1)
	end
end
function RoaringFlame_SkillChangePanel:onShow()
	print("=======RoaringFlame_SkillChangePanel:onShow")
	self:refreshItemCount()
	self:refreshLotteryTimes()
	self:updateBtnExtra()
	local index = self.param and self.param.index
	self:initData(index)
end
function RoaringFlame_SkillChangePanel:initData(index)
	self.index = index
	self.curSkillId = self.skillSlot[tostring(self.index)].skillId
	self:initSkillSingle(self.fields.Node_skillCur, self.curSkillId)
	self:refreshNewSkill()
end
function RoaringFlame_SkillChangePanel:btnUseClick(...)
	SoraDPlaySound()
	if self.isAction then
		return
	end
	roaringFlameWarCtrl:reqSkillReplace(self.index)
	SoraDShowLoading()
end
function RoaringFlame_SkillChangePanel:btnGetClick()
	SoraDPlaySound()
	if self.isAction then
		return
	end
	if self.itemCount < self.itemCost then
		_ENV, _ENV = nil, nil
		;(nil).noStyle, (nil).normal = nil, "btn_green_normal_01.png"
		SoraDShowMsgBox(i18n("atlantiswar_text_0262"), i18n("atlantiswar_skill_text_010"), i18n("common_text_1809"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_UPVALUE3_ = MSGBOX_CALLBACK_YES
				MSGBOX_CALLBACK_YES[1] = 14426
				MSGBOX_CALLBACK_YES[2] = 14427
				local MSGBOX_CALLBACK_YES[3], giftArray = 14428, MSGBOX_CALLBACK_YES
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).rechargeIDList = giftArray
					uiManager:show("rechargeView", nil)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:jumpToLimitNodeByList(IsArClient and 5 or 12, giftArray)
					panel:show()
				end
			elseif MSGBOX_CALLBACK_NO == eventType and clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE, true) then
				uiManager:show("RoaringFlame_Shop")
			end
		end, nil)
	else
		roaringFlameWarCtrl:reqSkillLottery(self.index)
		SoraDShowLoading()
	end
end
function RoaringFlame_SkillChangePanel:initSkillSingle(single, skillId)
	roaringFlameWarRead = nil
	;(nil)[1] = "framer_zcjn_jnk_03.png"
	;(nil)[2] = "framer_zcjn_jnk_04.png"
	local (nil)[3], qualityIcon = "framer_zcjn_jnk_05.png", nil
	local config = roaringFlameWarRead.getSkillDisplayConfig(skillId)
	local qConfig = qualityConfig[config.quality]
	local sConfig = qualityConfig[config.sort]
	local _fields = fguiHelper.get_fields(single)
	_fields.Image_skill:setURL(config.img)
	_fields.Text_name:setString(i18n(config.name))
	_fields.Text_name:setColor(qConfig.color)
	_fields.Sprite_frame:setURL(qualityIcon[config.quality])
	_fields.Text_type:setString(i18n(sConfig.tName))
	_fields.Text_des:setString(i18n(config.describe))
	local c1 = single:getController("c1")
	if single == self.fields.Node_skillNew then
		c1:setSelectedIndex(1)
	else
		c1:setSelectedIndex(0)
	end
end
function RoaringFlame_SkillChangePanel:resetSkillSingle(single)
	local c1 = single:getController("c1")
	c1:setSelectedIndex(2)
end
function RoaringFlame_SkillChangePanel:refreshNewSkill(...)
	self.newSkillId = self.candidateSkill[tostring(self.index)]
	if self.newSkillId then
		self.fields.Button_use:setVisible(true)
		self.fields.Button_use:setPositionX(SoraDFPosX(self.view:getWidth() / 2 - 132))
		self.fields.Button_get:setPositionX(SoraDFPosX(self.view:getWidth() / 2 + 132))
		self.fields.Text_remain:setPositionX(self.fields.Button_get:getPositionX())
		self.fields.Button_get:setString(i18n("atlantiswar_skill_text_031"))
		self:initSkillSingle(self.fields.Node_skillNew, self.newSkillId)
	else
		self.fields.Button_use:setVisible(false)
		self.fields.Button_get:setPositionX(self.view:getWidth() / 2)
		self.fields.Text_remain:setPositionX(self.fields.Button_get:getPositionX())
		self.fields.Button_get:setString(i18n("atlantiswar_skill_text_029"))
		self:resetSkillSingle(self.fields.Node_skillNew)
	end
end
function RoaringFlame_SkillChangePanel:refreshLotteryTimes(...)
	self.lotteryTimes = roaringFlameWarCtrl:getLotteryTimes()
	local times_max = roaringFlameWarRead.getConstValue("FLAMES_DUNES_SKILL_LOTTERY_TIMES", 250)
	local remain = math.max(0, times_max - self.lotteryTimes)
	if 0 < remain then
		self.fields.Button_get:setTouchEnabled(true)
		roaringFlameWarCtrl = nil
		;(nil).var1 = remain
		;(nil).var2 = times_max
		self.fields.Text_remain:setString(i18n("atlantiswar_skill_text_028", nil))
	else
		self.fields.Button_get:setTouchEnabled(false)
		roaringFlameWarCtrl = i18n("atlantiswar_skill_text_028", nil)
		i18n("atlantiswar_skill_text_028", nil).var1 = remain
		roaringFlameWarCtrl, roaringFlameWarCtrl, i18n("atlantiswar_skill_text_028", nil).var2 = i18n("atlantiswar_skill_text_028", nil)
		i18n("atlantiswar_skill_text_028", nil).var1, i18n("atlantiswar_skill_text_028", nil).color = i18n("atlantiswar_skill_text_028", nil)
		self.fields.Text_remain:setString(i18n_html("atlantiswar_skill_text_028", i18n("atlantiswar_skill_text_028", nil)))
	end
end
function RoaringFlame_SkillChangePanel:onMessageSkillLottery(target, event)
	if event.index ~= self.index then
		return
	end
	SoraDCloseLoading()
	self.candidateSkill = roaringFlameWarCtrl:getCandidateSkill()
	self.newSkillId = self.candidateSkill[tostring(self.index)]
	if self.newSkillId then
		self.isAction = true
		self:initShowSkillEffect(self.fields.Node_skillNew)
		roaringFlameWarCtrl = nil
		;(nil)[1] = ffa.delay(0.5)
		;(nil)[2] = ffa.callFunc(function()
			self.isAction = false
			self:refreshNewSkill()
		end)
		;(nil)[3] = ffa.callFunc(function()
			self.isAction = false
			self:refreshNewSkill()
		end)
		self:runAction(ffa.seq(nil))
	end
	self:refreshLotteryTimes()
	self:updateBtnExtra()
end
function RoaringFlame_SkillChangePanel:onMessageSkillReplace(target, event)
	if event.index ~= self.index then
		return
	end
	SoraDCloseLoading()
	self.isAction = true
	self:initReplaceSkillEffect()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(1)
	;(nil)[2] = ffa.callFunc(function()
		self.isAction = false
		self:replaceSkill()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.isAction = false
		self:replaceSkill()
	end)
	self:runAction(ffa.seq(nil))
end
function RoaringFlame_SkillChangePanel:initShowSkillEffect(skillSingle)
	self.fields.Usm_show:setVisible(true)
	self.fields.Usm_show:play()
end
function RoaringFlame_SkillChangePanel:initReplaceSkillEffect(...)
	self.fields.Usm_new:setVisible(true)
	self.fields.Usm_new:play()
end
function RoaringFlame_SkillChangePanel:replaceSkill(...)
	self.candidateSkill = roaringFlameWarCtrl:getCandidateSkill()
	self:refreshNewSkill()
	self:updateCurSkill()
	self:initShowSkillEffect(self.fields.Node_skillCur)
end
function RoaringFlame_SkillChangePanel:updateCurSkill()
	self.skillSlot = roaringFlameWarCtrl:getSkillSlot()
	self.curSkillId = self.skillSlot[tostring(self.index)].skillId
	self:initSkillSingle(self.fields.Node_skillCur, self.curSkillId)
end
function RoaringFlame_SkillChangePanel:onMessageBagChange(target, event)
	if not event.itemMap then
		return
	end
	if event.itemMap[self.itemID] then
		self:refreshItemCount()
	end
end
function RoaringFlame_SkillChangePanel:refreshItemCount()
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	backpackCtrl = self.itemID
	self.itemID.member = string.formatnumberthousands(self.itemCount)
	self.itemID.total = tostring(self.itemCost)
	local goldStr = i18n("common_text_155", self.itemID)
	self.fields.Button_get:setCostNum(goldStr)
	self.fields.Button_get:setIsEnough(self.itemCount >= self.itemCost)
end
function RoaringFlame_SkillChangePanel:btnExtraClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).skillIdx = self.index
	uiManager:show("RoaringFlame_SkillSelect", nil)
end
function RoaringFlame_SkillChangePanel:updateBtnExtra()
	local curNum = roaringFlameWarCtrl:getUsedSkillTimes()
	local maxNum = roaringFlameWarRead.getConstValue("FLAMES_DUNES_SKILL_TIME", 100)
	local isEnough = curNum >= maxNum
	local numStr = ""
	if isEnough then
		roaringFlameWarCtrl = nil
		;(nil).color = "#00FF00"
		roaringFlameWarCtrl = nil
		;(nil).color = "#00FF00"
		numStr = SoraDWrapHtmlTagByStyle(curNum, nil) .. "/" .. SoraDWrapHtmlTagByStyle(maxNum, nil)
	else
		roaringFlameWarCtrl = SoraDWrapHtmlTagByStyle(maxNum, nil)
		SoraDWrapHtmlTagByStyle(maxNum, nil).color = "#FFD43E"
		numStr = SoraDWrapHtmlTagByStyle(curNum, (SoraDWrapHtmlTagByStyle(maxNum, nil))) .. "/" .. maxNum
	end
	local btnStr = i18n("Promise_Summit_text_41") .. "\n" .. numStr
	self.fields.Button_extra:setString(btnStr)
	self.fields.Button_extra:setReddot(isEnough)
end
function RoaringFlame_SkillChangePanel:onMessageSkillSelect(target, event)
	if event.index ~= self.index then
		return
	end
	SoraDCloseLoading()
	self:updateCurSkill()
	self:updateBtnExtra()
	self.fields.mv_sx:setFrames("G_frame_9001674_jineng_sx%02d.png", false)
	self.fields.mv_sx2:setFrames("G_frame_9001674_jineng_sx%02d.png", false)
	self.fields.mv_sx3:setFrames("dh_9001649_01_%02d.png", false)
	self.fields.mv_sx4:setFrames("G_9001702_baodian_%02d.png", false)
	self.fields.mv_sx5:setFrames("YDTS_glowkuang_%02d.png", false)
	self.transitions.t0:play()
end
return RoaringFlame_SkillChangePanel
