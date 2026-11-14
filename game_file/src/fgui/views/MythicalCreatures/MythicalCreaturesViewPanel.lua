local baseFguiPanel = require("fgui.base.baseFguiPanel")
local divineBeastRead = include("divineBeastRead")
local constantRead = include("constantRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local buffDesRead = include("buffDesRead")
local publicRead = include("publicRead")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local nebulaMileStoneRead = include("nebulaMileStoneRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local magicLampRead = include("magicLampRead")
local publicUtil = include("publicUtil")
local activity_9001727_Ctrl = SoraDGetCtrl("activity_9001727_Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local MythicalCreaturesViewPanel = class("MythicalCreaturesViewPanel", baseFguiPanel)
_ENV = "MythicalCreaturesViewPanel"
;("MythicalCreaturesViewPanel").STAR = 1
;("MythicalCreaturesViewPanel").STEP = 2
local ("MythicalCreaturesViewPanel").TREAT, viewType = 3, "MythicalCreaturesViewPanel"
function MythicalCreaturesViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("MythicalCreaturesViewPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ALBARQ_DECREE_ACTIVITY
end
function MythicalCreaturesViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MythicalCreaturesViewPanel:onInit()
	if not SoraDFIsRA() then
		self.fields.list:fixPos()
		self.fields.Txt_title:fixPos()
		self.fields.line:fixPos()
		self.fields.Button_task:fixPos()
		self.fields.Button_mark:fixPos()
		self.fields.Btn_activity:fixPos()
		self.fields.Btn_dailyGift:fixPos()
		self.fields.Check_dispatch:fixPos()
		self.fields.text_dispatch:fixPos()
		self.fields.Com_MC_skillIcon1:fixPos()
		self.fields.Com_MC_skillIcon2:fixPos()
		self.fields.Com_MC_skillIcon3:fixPos()
		self.fields.Com_MC_skillIcon4:fixPos()
		self.fields.Com_MC_beastData:fixPos()
		self.fields.Com_MC_beastData:fixChildrenPos(false, true)
	end
	self.fields.Usm_1:setMaxChunkSize(76416)
	print("=======MythicalCreaturesViewPanel:onInit")
	self.treatLimit = constantRead.getConstValue("DIVINE_BEAST_TREAT_LIMIT", 5)
	self.dispatchShowStarLv = constantRead.getConstValue("DVINE_BEAST_UNLOCK_MARCH", 6)
	self.fields.Com_title:initData(i18n("Divine_beast_text_02"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.comBeastDataFiles = fguiHelper.get_fields(self.fields.Com_MC_beastData)
	self.selectedPage = self.param and self.param.page and self.param.page or viewType.STEP
	self.divineIDList = divineBeastCtrl:getUnlockBeastIDList()
	self.curIndex = 1
	local divineID = self.param and self.param.beastId or divineBeastCtrl:getShowingBeast()
	if divineID then
		for i, v in ipairs(self.divineIDList) do
			if v == divineID then
				self.curIndex = i
				break
			end
		end
	end
	_ENV = ipairs(self.divineIDList)
	_ENV, _ENV, ipairs(self.divineIDList).defaultClick = handler(self, self.onClickHelp)
	_ENV, self.selectedPage[1], handler(self, self.onClickHelp).title = handler(self, self.onClickHelp)
	_ENV, self.selectedPage[2], handler(self, self.onClickHelp).title = handler(self, self.onClickHelp)
	ipairs(self.divineIDList).tabsetArray, self.selectedPage[3], handler(self, self.onClickHelp).title = self.selectedPage, handler(self, self.onClickHelp)
	ipairs(self.divineIDList).callback = handler(self, self.onClickTabBtn)
	self.fields.Panel_tab:initView(ipairs(self.divineIDList))
	self.fields.Usm_1:setMaxChunkSize(202688)
	self.fields.Txt_treat:setString(i18n("Divine_beast_text_04"))
	self.fields.list:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.comBeastDataFiles.list_star:setItemRenderer(handler(self, self.onStarItemRenderer))
	self.fields.Button_cost:addClickEventListener(handler(self, self.onCostClick))
	self.fields.Button_task:setTitle(i18n("common_text_4498"))
	self.fields.Button_task:addClickEventListener(handler(self, self.onTaskClick))
	self.fields.Button_mark:setTitle(i18n("Divine_beast_mark_text_54"))
	self.fields.Button_mark:addClickEventListener(handler(self, self.onMarkClick))
	self.fields.Btn_dailyGift:setString(i18n("datepalm_tree_text18"))
	self.fields.Btn_dailyGift:addClickEventListener(handler(self, self.onDailyGiftClick))
	self.comBeastDataFiles.btn_damage_tips:addClickEventListener(handler(self, self.onClickDamgeFAQ))
	self.fields.btn_star_tips:addClickEventListener(handler(self, self.onClickStarFAQ))
	self.fields.Com_have:setAddCallback(handler(self, self.onAddClick))
	self.growSelectedIndex = 1
	self.fields.Button_grow1:setTitle(i18n("Divine_beast_text_55"))
	self.fields.Button_grow2:setTitle(i18n("Divine_beast_text_56"))
	self.fields.Button_grow3:setTitle(i18n("Divine_beast_text_57"))
	self.fields.Button_grow1:addClickEventListener(handler(self, self.onGrowClick), 1)
	self.fields.Button_grow2:addClickEventListener(handler(self, self.onGrowClick), 2)
	self.fields.Button_grow3:addClickEventListener(handler(self, self.onGrowClick), 3)
	self.fields.Com_MC_stepup:setTitle(i18n("Divine_beast_text_51"))
	self.fields.Com_MC_stepup:addClickEventListener(handler(self, self.onGrowClick), 4)
	self.fields.Com_MC_max:setTitle(i18n("magic_lamp_text_033"))
	self.fields.Check_dispatch:addClickEventListener(handler(self, self.onClickDispatch))
	self.fields.text_dispatch:setString(i18n("Divine_beast_text_68"))
	self.fields.Usm_2:setCompleteCallback(function()
		self.fields.Usm_2:clearEffect()
	end)
	self.fields.Usm_3:setCompleteCallback(function()
		self.fields.Usm_3:clearEffect()
	end)
	self.fields.Usm_4:setCompleteCallback(function()
		self.fields.Usm_4:clearEffect()
	end)
	self.fields.btn_left:addClickEventListener(handler(self, self.onPageClick), -1)
	self.fields.btn_right:addClickEventListener(handler(self, self.onPageClick), 1)
	self.fields.Btn_activity:addClickListener(handler(self, self.onClick_Button_activity))
end
function MythicalCreaturesViewPanel:onClick_Button_activity()
	SoraDPlaySound()
	uiManager:show("Activity_9001727_BuffShow")
end
function MythicalCreaturesViewPanel:onShow()
	print("=======MythicalCreaturesViewPanel:onShow")
	self.oriNum = nil
	self.fields.Btn_activity:setVisible(false)
	self:updateView()
end
function MythicalCreaturesViewPanel:onHide()
	print("=======MythicalCreaturesViewPanel:onHide")
	divineBeastCtrl:setShowingBeast(self.divineID)
end
function MythicalCreaturesViewPanel:updateView()
	mildGuideManager:clean()
	local isAddPageShow = self.divineIDList[self.curIndex + 1] ~= nil
	local isMinPageShow = self.divineIDList[self.curIndex - 1] ~= nil
	self.fields.btn_right:setVisible(isAddPageShow)
	self.fields.btn_left:setVisible(isMinPageShow)
	self.divineID = self.divineIDList[self.curIndex]
	self.beastCfg = divineBeastRead.getDbCfg(self.divineID)
	self.beastData = divineBeastCtrl:getBeastData(self.divineID)
	self.starCfgs = divineBeastRead.getStarCfgs(self.divineID)
	self.maxStepLv = divineBeastRead.getMaxStepLv(self.divineID)
	self.maxStarLv = divineBeastRead.getMaxStarLv(self.divineID)
	dump(self.beastData, "self.beastData")
	if self.divineID == gBestID.ONE then
		local isHaveBuff = activity_9001727_Ctrl:isBuffEffect(self.beastData.stepLv)
		self.fields.Btn_activity:setVisible(isHaveBuff)
		if clientEventMgr.judgeIsOpen(self.activityID) and isHaveBuff then
			self.fields.Btn_activity:getChild("Text_time"):beginTime(activityShowCtrl:getRemainTime(self.activityID))
		end
	else
		self.fields.Btn_activity:setVisible(false)
	end
	self.isDailyGot = not divineBeastCtrl:isCanGetFreeGift()
	self.fields.Btn_dailyGift:setReddot(not self.isDailyGot)
	if self.beastData == nil then
		return
	end
	self.treatCfg = divineBeastRead.getTreatCfg(self.divineID)
	self.usmData = divineBeastRead.getUsmData(self.divineID)
	self.fields.Button_task:setRedVisible(divineBeastCtrl:getIsHaveTaskFinished())
	self.isInTreat = self.beastData.state == DIVINE_BEAST_STATE.TREAT
	if self.isInTreat then
		self.selectedPage = viewType.STEP
		self.controllers.c1:setSelectedIndex(0)
		self:updateTreat()
		self:updateAnimation()
		self.fields.Check_dispatch:setVisible(false)
		self.fields.text_dispatch:setVisible(false)
		return
	end
	if self.oldIsInTreat and not self.isInTreat and not self.turnPage then
		self.view:getTransition("t0"):play(1, 0, 0, -1)
	end
	self:updateBeastData()
	if self.selectedPage == viewType.TREAT then
		self.controllers.c1:setSelectedIndex(1)
		self:updateTreat()
	end
	if self.selectedPage == viewType.STAR then
		self:updateStar()
	end
	if self.selectedPage == viewType.STEP then
		guideCtrl:updateGuideModule(gGuideModule.DIVINE_BEAST_TO_CANYON)
		self.controllers.c1:setSelectedIndex(2)
		self:updateStep()
	end
	if self.oldSelectedPage == nil or self.oldSelectedPage == self.selectedPage then
		self:updateAnimation()
	end
	self.oldSelectedPage = self.selectedPage
	self:mildGuideToStarUp()
end
function MythicalCreaturesViewPanel:playTreatAnimation()
	if self.isInTreat and not self.isActionPlaying then
		self.isActionPlaying = true
		self.fields.Usm_2:setEffectPath("G_SS_leiniaozhiliao_02.usm", false, true)
		self:playTreat(self.usmData.treating.treat)
		self.fields.Usm_1:stopAllActions()
		self.fields.Usm_1:runAction(ffa.seq(ffa.delay(3.0), ffa.callFunc(function()
			self.isActionPlaying = false
		end)))
	elseif not self.isActionPlaying then
		local usmFileData = self.usmData.star[self.starLv] or self.usmData.star.default
		self.isActionPlaying = true
		self.fields.Usm_2:setEffectPath("G_SS_leiniaozhiliao_02.usm", false, true)
		self:playTreat(usmFileData.treat)
		self.fields.Usm_1:stopAllActions()
		self.fields.Usm_1:runAction(ffa.seq(ffa.delay(3.0), ffa.callFunc(function()
			self.isActionPlaying = false
		end)))
	end
end
_ENV, MythicalCreaturesViewPanel.playTreat = function(self, effectPath)
	local effects = string.split(effectPath, ",")
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setEffectPath(effects[1], false)
	self.fields.Usm_1:setCompleteCallback(function()
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath(effects[2], true)
	end)
end, function(self, effectPath)
	local effects = string.split(effectPath, ",")
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setEffectPath(effects[1], false)
	self.fields.Usm_1:setCompleteCallback(function()
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath(effects[2], true)
	end)
end
;(function(self, effectPath)
	local effects = string.split(effectPath, ",")
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setEffectPath(effects[1], false)
	self.fields.Usm_1:setCompleteCallback(function()
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath(effects[2], true)
	end)
end)[1] = "G_leiniaogreen_01.usm"
;(function(self, effectPath)
	local effects = string.split(effectPath, ",")
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setEffectPath(effects[1], false)
	self.fields.Usm_1:setCompleteCallback(function()
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath(effects[2], true)
	end)
end)[2] = "G_leiniaoblue_01.usm"
local (function(self, effectPath)
	local effects = string.split(effectPath, ",")
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setEffectPath(effects[1], false)
	self.fields.Usm_1:setCompleteCallback(function()
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath(effects[2], true)
	end)
end)[3], growEffects = "G_leiniaored_01.usm", function(self, effectPath)
	local effects = string.split(effectPath, ",")
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setEffectPath(effects[1], false)
	self.fields.Usm_1:setCompleteCallback(function()
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath(effects[2], true)
	end)
end
function MythicalCreaturesViewPanel:updateAnimation()
	_UPVALUE2_ = nil
	;(nil)[1] = self.isInTreat
	;(nil)[2] = self.isActionPlaying
	dump(nil, "MythicalCreaturesViewPanel:updateAnimation")
	if self.isInTreat and not self.isActionPlaying then
		self.fields.bg:setURL(self.usmData.treating.bg)
		if self.fields.Usm_1.effectPath ~= self.usmData.treating.daiji then
			self.fields.Usm_1:clearEffect()
			self.fields.Usm_1:setEffectPath(self.usmData.treating.daiji, true)
		end
		return
	end
	local usmFileData = self.usmData.star[self.starLv] or self.usmData.star.default
	local actionDelay = 0
	if self.oldStepLv ~= nil and not self.turnPage and self.stepLv > self.oldStepLv and not self.isActionPlaying then
		if usmFileData.stepUp then
			actionDelay = 1.0
			self.fields.Usm_1:clearEffect()
			self.fields.Usm_1:setEffectPath(usmFileData.stepUp, true, true)
		else
			actionDelay = 1.0
			self:playTreat(usmFileData.treat)
		end
	end
	if self.oldStarLv ~= nil and not self.turnPage and self.starLv > self.oldStarLv and not self.isActionPlaying then
		actionDelay = 1.0
		if usmFileData.starUp then
			self.fields.Usm_1:clearEffect()
			self.fields.Usm_1:setEffectPath(usmFileData.starUp, true, true)
		else
			self:playTreat(usmFileData.treat)
		end
	end
	if self.oldGrowLv ~= nil and not self.turnPage and not self.isActionPlaying then
		for i, v in ipairs(self.oldGrowLv) do
			if v < self.growLv[i] then
				actionDelay = 2.0
				self.fields.Usm_4:setEffectPath(growEffects[i], false, true)
				self.fields.Usm_4.effect:setBlendFunc(gl.ONE, gl.ONE)
				break
			end
		end
	end
	if not self.turnPage and self.oldIsInTreat and not self.isInTreat then
		actionDelay = 3.0
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath(usmFileData.heal, true)
	elseif not self.isInTreat and not self.isActionPlaying and actionDelay <= 0 then
		self.fields.bg:setURL(usmFileData.bg)
		_UPVALUE2_ = self.fields.bg
		self.fields.bg[1] = self.fields.Usm_1.effectPath
		self.fields.bg[2] = usmFileData.daiji
		dump(self.fields.bg, "self.fields.Usm_1.effectPath ~= usmFileData.daiji")
		if self.fields.Usm_1.effectPath ~= usmFileData.daiji then
			self.fields.Usm_1:clearEffect()
			self.fields.Usm_1:setEffectPath(usmFileData.daiji, true)
		end
	end
	if 0 < actionDelay then
		self.isActionPlaying = true
		self.fields.Usm_1:stopAllActions()
		self.fields.Usm_1:runAction(ffa.seq(ffa.delay(actionDelay), ffa.callFunc(function()
			self.isActionPlaying = false
			self.fields.bg:setURL(usmFileData.bg)
		end)))
	end
	if self.oldStarLv ~= nil and not self.turnPage and self.starLv > self.oldStarLv and self.starLv == self.dispatchShowStarLv then
		_ENV = self.dispatchShowStarLv
		self.dispatchShowStarLv.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		self.dispatchShowStarLv.step = 9991200
		SoraDSendMessage(self.dispatchShowStarLv)
	end
	self.oldStepLv = self.stepLv
	self.oldStarLv = self.starLv
	self.oldGrowLv = self.growLv
	self.oldIsInTreat = self.isInTreat
end
_ENV, MythicalCreaturesViewPanel.updateItem = function(self, isMax)
	if not self.promoteItem then
		return
	end
	self.fields.Com_have:updateNum()
	self.fields.Button_cost:setCostDiscount(self.promoteItem.id, isMax and 0 or self.promoteItem.num, self.oriNum)
	if isMax then
		self.fields.Button_cost:setFree(i18n("Divine_beast_text_15"))
	end
end, function(self, isMax)
	if not self.promoteItem then
		return
	end
	self.fields.Com_have:updateNum()
	self.fields.Button_cost:setCostDiscount(self.promoteItem.id, isMax and 0 or self.promoteItem.num, self.oriNum)
	if isMax then
		self.fields.Button_cost:setFree(i18n("Divine_beast_text_15"))
	end
end
;(function(self, isMax)
	if not self.promoteItem then
		return
	end
	self.fields.Com_have:updateNum()
	self.fields.Button_cost:setCostDiscount(self.promoteItem.id, isMax and 0 or self.promoteItem.num, self.oriNum)
	if isMax then
		self.fields.Button_cost:setFree(i18n("Divine_beast_text_15"))
	end
end)[1900] = gNebulaMileStoneUnlockType.UNLOCK_DIVINE_BEAST_TREAT_TO_NORMAL
local (function(self, isMax)
	if not self.promoteItem then
		return
	end
	self.fields.Com_have:updateNum()
	self.fields.Button_cost:setCostDiscount(self.promoteItem.id, isMax and 0 or self.promoteItem.num, self.oriNum)
	if isMax then
		self.fields.Button_cost:setFree(i18n("Divine_beast_text_15"))
	end
end)[1901], type2Treat = gNebulaMileStoneUnlockType.UNLOCK_TREAT_DIVINE_BEAST_1901, function(self, isMax)
	if not self.promoteItem then
		return
	end
	self.fields.Com_have:updateNum()
	self.fields.Button_cost:setCostDiscount(self.promoteItem.id, isMax and 0 or self.promoteItem.num, self.oriNum)
	if isMax then
		self.fields.Button_cost:setFree(i18n("Divine_beast_text_15"))
	end
end
function MythicalCreaturesViewPanel:updateTreat()
	local isOverMax = not self.isInTreat
	if self.isInTreat then
		self.curProgress = self.beastData.hp or 0
		self.maxProgress = self.treatCfg.valueLimit
		self.fields.Progress:setMax(self.maxProgress)
		self.fields.Progress:setValue(self.curProgress)
		if self.maxProgress <= self.curProgress then
			fguiHelper.get_fields(self.fields.Progress).title:setString(i18n("hero_text_41"))
			local ret = type2Treat[self.divineID] and nebulaMileStoneCtrl:getPlusByUnlockType(type2Treat[self.divineID])
			if ret ~= nil then
				divineBeastCtrl:sendTreatToNormal(self.divineID)
			end
		end
		isOverMax = self.maxProgress <= self.curProgress
		self.fields.Txt_unlockDes:setVisible(isOverMax)
		if isOverMax then
			_ENV = self.fields.Txt_unlockDes.setVisible
			self.fields.Txt_unlockDes.setVisible[gBestID.ONE] = i18n("Divine_beast_text_62")
			local self.fields.Txt_unlockDes.setVisible[gBestID.TWO], tipsStr = i18n("magic_lamp_text_160"), self.fields.Txt_unlockDes.setVisible
			self.fields.Txt_unlockDes:setString(tipsStr[self.divineID])
		end
	end
	self.fields.txt_treat_desc:setString(i18n(isOverMax and "Divine_beast_text_64" or "Divine_beast_text_07"))
	self.fields.Txt_title:setString(i18n(isOverMax and "Divine_beast_text_06" or "Divine_beast_text_05"))
	if self.treatRewards == nil or self.turnPage then
		self.treatRewards = self.treatCfg.reward
		self.treatRewards2 = self.treatCfg.extraReward
		self.fields.list:setNumItems(#self.treatRewards)
		self.fields.list:scrollToView(0)
	end
	self:showLvMax(false)
	self.promoteItem = self.treatCfg.promoteItem[1]
	self.oriNum = nil
	dump(self.promoteItem, "self.promoteItem")
	self.fields.Com_have:initData(self.promoteItem.id)
	self.fields.Button_cost:setTitle(i18n(isOverMax and "Divine_beast_text_09" or "Divine_beast_text_08"))
	self:updateItem()
end
function MythicalCreaturesViewPanel:isBeastDataChange()
	if self.turnPage then
		return true
	end
	if self.growLv ~= nil then
		if not self.beastData.growLv then
			_UPVALUE3_ = self.beastData.growLv
			self.beastData.growLv[1] = 0
			self.beastData.growLv[2] = 0
			local self.beastData.growLv[3], growLv = 0, self.beastData.growLv
		end
		for i, v in ipairs(self.growLv) do
			if v ~= growLv[i] then
				return true
			end
		end
	end
	if self.stepLv == self.beastData.stepLv and self.starLv == self.beastData.starLv and self.growLv ~= nil and self.isInTreat == self.oldIsInTreat then
		return false
	end
	return true
end
function MythicalCreaturesViewPanel:updateBeastData()
	self:updateRedDot()
	if not self:isBeastDataChange() then
		return
	end
	self.stepLv = self.beastData.stepLv or 0
	self.starLv = self.beastData.starLv or 0
	if not self.beastData.growLv then
		guideCtrl = self.beastData.growLv
		self.beastData.growLv[1] = 0
		self.beastData.growLv[2] = 0
		self.beastData.growLv[3] = 0
	end
	self.growLv = self.beastData.growLv
	self.stepCfg = divineBeastRead.getStepCfg(self.divineID, self.stepLv)
	self.starCfg = divineBeastRead.getStarCfg(self.divineID, self.starLv)
	self.nextStarCfg = divineBeastRead.getStarCfg(self.divineID, self.starLv + 1)
	self.nextStepCfg = divineBeastRead.getStepCfg(self.divineID, self.stepLv + 1)
	self.attCfg = divineBeastRead.getAttributeCfg(self.divineID, self.stepLv)
	self.isMaxStarLv = self.nextStarCfg == nil
	self.starJinnLvLimitData = nil
	if self.nextStarCfg then
		self.starJinnLvLimitData = self.nextStarCfg.lampLimit
	end
	local iconName = SoraDFIsRA() and self.beastCfg.divineName .. "_ar.png" or self.beastCfg.divineName .. "_en.png"
	self.comBeastDataFiles.icon_name:setURL(iconName)
	divineBeastRead = nil
	;(nil).num = self.stepLv
	self.comBeastDataFiles.Txt_step:setString(i18n("Divine_beast_text_66", nil))
	self.comBeastDataFiles.Txt_damage:setString(self.stepCfg.damage[3] or 0)
	self.comBeastDataFiles.Com_MC_BaseInfo:initData(self.divineID)
	for i = 1, 4 do
		self.fields["Com_MC_skillIcon" .. i]:initData(self.beastCfg, self.beastData, i)
	end
	self.comBeastDataFiles.list_star:setNumItems(self.isMaxStarLv and self.starLv or self.starLv + 1)
	local isMarkOpen = divineBeastMarkCtrl:getIsFuncOpen(self.divineID)
	self.fields.Button_mark:setVisible(isMarkOpen)
	if isMarkOpen then
		self:updateMarkBtnRedDot()
		guideCtrl:updateGuideModule(gGuideModule.DIVINE_BEAST_MARK)
		if SoraDIsGameGuide() then
			self.fields.Button_mark:setOpacity(0)
		end
	end
	self.fields.Check_dispatch:setVisible(self.starLv >= self.dispatchShowStarLv)
	self.fields.Check_dispatch:setSelected(self.beastData.marchShow)
	self.fields.text_dispatch:setVisible(self.starLv >= self.dispatchShowStarLv)
end
function MythicalCreaturesViewPanel:updateRedDot()
	local isTreatEnough = (self.beastData.dayTreatCount or 0) < self.treatLimit and divineBeastCtrl:getIsEnough(self.treatCfg.promoteItem)
	self.fields.Panel_tab:setBtnRedDot(viewType.TREAT, isTreatEnough)
end
function MythicalCreaturesViewPanel:updateMarkBtnRedDot()
	local isMarkRed = divineBeastMarkCtrl:getIsShowBubble(self.divineID, self.stepLv)
	self.fields.Button_mark:setReddot(isMarkRed)
end
function MythicalCreaturesViewPanel:updateFc()
	self.comBeastDataFiles.Txt_fc:setString(lordInfoCtrl:getDivineBeastFc())
end
function MythicalCreaturesViewPanel:updateStar()
	self.controllers.c1:setSelectedIndex(4)
	local nowSkillLevel = self.starCfg.skillLevel
	local skillIds = self.beastCfg.divineSkill
	self.fields.txt_noStarUp_desc:setVisible(self.isMaxStarLv)
	self:showLvMax(self.isMaxStarLv)
	self.fields.Com_MC_StarDetails:initData(self.divineID, self.isMaxStarLv and self.starLv or self.starLv + 1, self.isMaxStarLv)
	if self.isMaxStarLv then
		return
	end
	self.promoteItem = clone(self.starCfg.promoteItem[1])
	self.oriNum = nil
	if self.divineID == gBestID.ONE then
		local buff = SoraDGetCtrl("activity_9001727_Ctrl"):getBuffVale(gBuffEffect.ONE_DIVINE_BEAST_STAR_UP_REDUCE, self.stepLv)
		self.oriNum = clone(self.promoteItem.num)
		self.promoteItem.num = math.ceil((1 - buff / 1000) * self.promoteItem.num)
	end
	dump(self.promoteItem, "self.promoteItem")
	self.fields.Button_cost:setTitle(i18n("Divine_beast_text_25"))
	self.fields.Com_have:initData(self.promoteItem.id)
	self:updateItem()
end
function MythicalCreaturesViewPanel:updateStep()
	local notMaxIndex
	for i, v in ipairs(self.growLv) do
		self.fields["Button_grow" .. i]:initData(self.growLv[i], self.attCfg.growLimit[i], i == self.growSelectedIndex)
		local isMax = self.fields["Button_grow" .. i]:getIsMax()
		if not isMax then
			notMaxIndex = i
		end
	end
	local isMaxStepLv = self.maxStepLv <= self.stepLv
	local isMaxStepLvAndGrowLv = isMaxStepLv and notMaxIndex == nil
	self:showLvMax(isMaxStepLvAndGrowLv or isMaxStepLv and self.growSelectedIndex == 4)
	if isMaxStepLv then
		self.fields.Com_MC_stepup:setStepLvMax()
	else
		self.fields.Com_MC_stepup:initData(self.growSelectedIndex == 4)
	end
	if isMaxStepLvAndGrowLv then
		self.fields.Usm_class:clearEffect()
		self.fields.Usm_classMax:setEffectPath("G_UIMAX.usm", true)
		self.fields.Usm_classMax.effect:setBlendFunc(gl.ONE, gl.ONE)
	elseif notMaxIndex == nil then
		self.fields.Usm_classMax:clearEffect()
		self.fields.Usm_class:setEffectPath("G_UISJ.usm", true)
		self.fields.Usm_class.effect:setBlendFunc(gl.ONE, gl.ONE)
	else
		self.fields.Usm_classMax:clearEffect()
		self.fields.Usm_class:clearEffect()
	end
	if isMaxStepLvAndGrowLv then
		for i, v in ipairs(self.growLv) do
			self.fields["Button_grow" .. i]:setStepLvMax()
		end
		return
	end
	self.notMaxIndex = notMaxIndex
	self.isCurGrowMax = false
	self.oriNum = nil
	if self.growSelectedIndex ~= 4 then
		self.promoteItem = self.attCfg.promoteItem[self.growSelectedIndex]
		self.fields.Button_cost:setTitle(i18n("Jinn_hatch_text_18"))
		self.isCurGrowMax = self.fields["Button_grow" .. self.growSelectedIndex]:getIsMax()
		local addBuff = self.beastCfg.buff[self.growSelectedIndex]
		local addValue = self.attCfg.growValue[self.growSelectedIndex] / 10
		local buffStr = buffDesRead.getTitleWithValue(addBuff.buffType, addValue)
		_ENV = i18n("Jinn_hatch_text_18")
		i18n("Jinn_hatch_text_18").num1 = self.promoteItem.num
		i18n("Jinn_hatch_text_18").num2 = 1
		i18n("Jinn_hatch_text_18").item = publicRead.getName(self.promoteItem.id)
		i18n("Jinn_hatch_text_18").var = buffStr
		i18n("Jinn_hatch_text_18").value = ""
		local str = i18n("Divine_beast_text_13", i18n("Jinn_hatch_text_18"))
		self.fields.txt_treat_desc:setString(str)
		if not SoraDIsGameGuide() and self.notMaxIndex == nil and guideCtrl:isGuideNotCompleted(gGuideModule.DIVINE_BEAST_STEP_UP) then
			_ENV = self.promoteItem.id
			mildGuideManager:drawFingerToTarget(self.fields.Com_MC_stepup, self.promoteItem.id)
			guideCtrl:CompleteGuideStep(nil, gGuideStep.DIVINE_BEAST_STEP_UP_STEP_1)
			self.isInStepUpGuide = true
		end
	else
		self.promoteItem = clone(self.stepCfg.promoteItem[1])
		if self.divineID == gBestID.ONE then
			local buff = SoraDGetCtrl("activity_9001727_Ctrl"):getBuffVale(gBuffEffect.ONE_DIVINE_BEAST_STEP_UP_REDUCE, self.stepLv)
			self.oriNum = clone(self.promoteItem.num)
			self.promoteItem.num = math.ceil((1 - buff / 1000) * self.promoteItem.num)
		end
		self.fields.Button_cost:setTitle(i18n("Divine_beast_text_51"))
		self.fields.txt_treat_desc:setVisible(true)
		local buffStr = ""
		if self.nextStepCfg.damage ~= nil and table.nums(self.nextStepCfg.damage) ~= 0 then
			buffStr = buffDesRead.getTitleWithValue(self.nextStepCfg.damage[1], self.nextStepCfg.damage[3] - (self.stepCfg.damage[3] or 0))
		end
		for i = 1, 3 do
			local addBuff = self.beastCfg.buff[i]
			local addValue = (self.nextStepCfg.attribute[i] - self.stepCfg.attribute[i]) / 10
			if addValue ~= 0 then
				if buffStr == "" then
					buffDesRead = i18n("Divine_beast_text_51")
					i18n("Divine_beast_text_51")[1] = buffStr
					i18n("Divine_beast_text_51")[2] = buffDesRead.getTitleWithValue(addBuff.buffType, addValue)
					i18n("Divine_beast_text_51")[3] = buffDesRead.getTitleWithValue(addBuff.buffType, addValue)
					i18n("Divine_beast_text_51")[4] = buffDesRead.getTitleWithValue(addBuff.buffType, addValue)
					dump(i18n("Divine_beast_text_51"))
					buffStr = buffStr .. buffDesRead.getTitleWithValue(addBuff.buffType, addValue)
				else
					buffStr = buffStr .. "," .. buffDesRead.getTitleWithValue(addBuff.buffType, addValue)
				end
			end
		end
		_ENV = 1
		;(1).num1 = self.promoteItem.num
		;(1).item = publicRead.getName(self.promoteItem.id)
		;(1).lv = self.stepLv + 1
		;(1).var = buffStr
		;(1).value = ""
		local str = i18n("Divine_beast_text_14", 1)
		self.fields.txt_treat_desc:setString(str)
		if self.isInStepUpGuide then
			_ENV = self.promoteItem.id
			mildGuideManager:drawFingerToTarget(self.fields.Button_cost, self.promoteItem.id)
		end
		self.isInStepUpGuide = false
	end
	dump(self.promoteItem, "self.promoteItem")
	self.fields.Com_have:initData(self.promoteItem.id)
	self:updateItem(self.isCurGrowMax)
end
function MythicalCreaturesViewPanel:showLvMax(isMax)
	self.fields.Com_MC_max:setVisible(isMax)
	self.fields.Button_cost:setVisible(not isMax)
	self.fields.Com_have:setVisible(not isMax)
	self.fields.txt_treat_desc:setVisible(not isMax)
end
function MythicalCreaturesViewPanel:onCostClick()
	SoraDPlaySound()
	if publicUtil.getCount(self.promoteItem.id) < self.promoteItem.num then
		SoraDShowMsgTip(i18n("common_text_2512"))
		return
	end
	if self.isInTreat or self.selectedPage == viewType.TREAT then
		if self.beastData.dayTreatCount ~= nil and self.beastData.dayTreatCount >= self.treatLimit then
			_ENV = i18n("common_text_2512")
			i18n("common_text_2512").time = serviceFunctions.getTodayRemainTime()
			SoraDShowMsgTip(i18n("Divine_beast_text_48", i18n("common_text_2512")))
			return
		end
		divineBeastCtrl:sendTreat(self.divineID)
		return
	elseif self.selectedPage == viewType.STAR then
		if self.nextStarCfg.stepDemand > self.stepLv then
			SoraDShowMsgTip(i18n("Divine_beast_text_27"))
			return
		end
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		if self.starJinnLvLimitData and self.starJinnLvLimitData[1] ~= nil and magicLampCtrl:getJinnLv(self.starJinnLvLimitData[1]) < self.starJinnLvLimitData[2] then
			_ENV = i18n("Divine_beast_text_27")
			i18n("Divine_beast_text_27").name = magicLampRead.getJinnName(self.starJinnLvLimitData[1], 1)
			i18n("Divine_beast_text_27").lv = self.starJinnLvLimitData[2]
			i18n("Divine_beast_text_27").num = self.starLv + 1
			SoraDShowMsgTip(i18n("Divine_beast_text_67", i18n("Divine_beast_text_27")))
			return
		end
		if self.nextStarCfg.NebulaMilestone ~= 0 then
			local nebulaMileStoneLimit = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(self.nextStarCfg.NebulaMilestone)
			if nebulaMileStoneLimit <= self.starLv then
				SoraDShowMsgTip(i18n("Divine_beast_text_70"))
				return
			end
		end
		divineBeastCtrl:sendUpStar(self.divineID)
	elseif self.selectedPage == viewType.STEP then
		if self.growSelectedIndex ~= 4 then
			if self.isCurGrowMax then
				SoraDShowMsgTip(i18n("Divine_beast_text_16"))
				return
			end
			self.fields["Button_grow" .. self.growSelectedIndex]:showGrowEffect()
			divineBeastCtrl:sendGrow(self.divineID, self.growSelectedIndex)
		else
			if self.notMaxIndex ~= nil then
				divineBeastCtrl = self.notMaxIndex
				self.notMaxIndex[1] = "Divine_beast_text_55"
				self.notMaxIndex[2] = "Divine_beast_text_56"
				local self.notMaxIndex[3], str = "Divine_beast_text_57", self.notMaxIndex
				_ENV = i18n("Divine_beast_text_16")
				i18n("Divine_beast_text_16").var = i18n(str[self.notMaxIndex])
				SoraDShowMsgTip(i18n("Divine_beast_text_19", i18n("Divine_beast_text_16")))
				return
			end
			if self.nextStepCfg.NebulaMilestone ~= 0 then
				local nebulaMileStoneLimit = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(self.nextStepCfg.NebulaMilestone)
				print("神兽阶级上限", self.stepLv, nebulaMileStoneLimit, self.nextStepCfg.NebulaMilestone)
				if nebulaMileStoneLimit <= self.stepLv then
					SoraDShowMsgTip(i18n("Divine_beast_text_70"))
					return
				end
			end
			if self.stepLv >= self.starCfg.stepLimit then
				SoraDShowMsgTip(i18n("Divine_beast_text_20"))
				return
			end
			divineBeastCtrl:sendUpStep(self.divineID)
		end
	end
end
function MythicalCreaturesViewPanel:onTaskClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).scene = 2
	userSDKManager.logEvent(gSDKDef.TDonEvent.divine_beast_action_task, nil)
	uiManager:show("MythicalCreaturesTask")
end
function MythicalCreaturesViewPanel:onMarkClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).beastId = self.divineID
	uiManager:show("DivineBeastMarkMain", nil)
end
function MythicalCreaturesViewPanel:onDailyGiftClick()
	SoraDPlaySound()
	if self.isDailyGot then
		SoraDShowMsgTip(i18n("wish_text_18"))
		return
	end
	divineBeastCtrl:sendFreeGift()
end
function MythicalCreaturesViewPanel:onClickTabBtn(index)
	if self.selectedPage == index then
		return
	end
	self.selectedPage = index
	self:updateView()
	if self.isInStarUpGuide and self.selectedPage == viewType.STAR then
		viewType = nil
		mildGuideManager:drawFingerToTarget(self.fields.Button_cost, nil)
		self.isInStarUpGuide = false
	end
end
function MythicalCreaturesViewPanel:onNormalItemRenderer(index, obj)
	local item = self.treatRewards[index + 1]
	obj:initData(item.id, item.num)
end
function MythicalCreaturesViewPanel:onNormalItemRenderer2(index, obj)
	local item = self.treatRewards2[index + 1]
	obj:initData(item.id, item.num)
end
function MythicalCreaturesViewPanel:onStarItemRenderer(index, obj)
	local i = index + 1
	obj:initData(i <= self.starLv, i == self.starLv + 1)
end
function MythicalCreaturesViewPanel:onGrowClick(sender, param)
	SoraDPlaySound()
	self.growSelectedIndex = param
	print("self.growSelectedIndex", self.growSelectedIndex)
	self:updateStep()
end
function MythicalCreaturesViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("common_text_001")
	;(nil).content = i18n(self.isInTreat and "Divine_beast_text_03" or "Divine_beast_text_11")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function MythicalCreaturesViewPanel:onClickDamgeFAQ()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("common_text_001")
	;(nil).content = i18n("Divine_beast_text_12")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function MythicalCreaturesViewPanel:onAddClick()
	SoraDPlaySound()
	if self.isInTreat or self.selectedPage == viewType.TREAT then
		_ENV = nil
		;(nil).scene = 3
		userSDKManager.logEvent(gSDKDef.TDonEvent.divine_beast_action_task, nil)
		uiManager:show("MythicalCreaturesTask")
	else
		_ENV = nil
		;(nil).itemID = self.promoteItem.id
		uiManager:show("CommonSourceGuide", nil)
	end
end
function MythicalCreaturesViewPanel:onClickStarFAQ()
	SoraDPlaySound()
	_ENV = nil
	;(nil).divineID = self.divineID
	uiManager:show("MythicalCreaturesStar", nil)
end
function MythicalCreaturesViewPanel:onClickDispatch(sender)
	SoraDPlaySound()
	local show = sender:isSelected()
	divineBeastCtrl:sendMarchShow(self.divineID, show)
end
function MythicalCreaturesViewPanel:mildGuideToStarUp()
	if SoraDIsGameGuide() or self.isInStepUpGuide or not guideCtrl:isGuideNotCompleted(gGuideModule.DIVINE_BEAST_STAR_UP) then
		return
	end
	if self.nextStarCfg and self.nextStarCfg.stepDemand <= self.stepLv then
		for k, v in pairs(self.starCfg.promoteItem) do
			if publicUtil.getCount(v.id) < v.num then
				return false
			end
		end
		_ENV = self.fields.Panel_tab
		self.fields.Panel_tab.z = 2
		mildGuideManager:drawFingerToTarget(self.fields.Panel_tab:getBtn(viewType.STAR), self.fields.Panel_tab)
		guideCtrl:CompleteGuideStep(nil, gGuideStep.DIVINE_BEAST_STAR_UP_STEP_1)
		self.isInStarUpGuide = true
	end
end
function MythicalCreaturesViewPanel:gameGuide_getTarget(itemName, parameters)
	_UPVALUE3_ = nil
	;(nil)[1] = self.fields[itemName]
	;(nil)[2] = itemName
	;(nil)[3] = parameters
	dump(nil, "gameGuide_getTarget")
	if itemName == "Button_close" then
		return self.fields.Com_title.fields.Button_close
	elseif itemName == "Button_task" then
		if not self.isInTreat and (not parameters or not parameters.isBeast2) then
			guideCtrl:CompleteGuideStep(nil, gGuideStep.DIVINE_BEAST_UNLOCK_STEP_1)
			_ENV = guideCtrl
			guideCtrl.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(guideCtrl)
			return nil
		end
		return self.fields.Button_task
	elseif itemName == "Tab_Menu" then
		dump(self.fields.Panel_tab:getBtn(parameters.Menu_Index), "self.fields.Panel_tab:getBtn(parameters.Menu_Index)")
		return self.fields.Panel_tab:getBtn(parameters.Menu_Index)
	elseif itemName == "Button_mark" then
		if not self.fields.Button_mark:isVisible() then
			_ENV = self.fields.Button_mark
			self.fields.Button_mark.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(self.fields.Button_mark)
		end
		return self.fields.Button_mark
	end
	return self.fields[itemName]
end
function MythicalCreaturesViewPanel:showMarkGuideAni()
	local startPos = self.fields.Button_mark:getPosition()
	self.fields.Button_mark:setOpacity(0)
	self.fields.Ani_yjjs:setVisible(true)
	self.fields.Ani_yjjs:setAllFrameNameOnce("ssyj_effect_tbcx_%02d.png", 1, false)
	self.fields.Button_mark:setReddot(false)
	self.fields.Button_mark:setPosition(cc.p(self:getSize().width / 2, self:getSize().height / 2))
	local scale = 1
	local _ENV, seq = self.fields.Button_mark, self.fields.Button_mark
	table.insert(seq, ffa.spawn(ffa.seq(ffa.scaleTo(0, 0.14 * scale), ffa.scaleTo(0.07, 1.14 * scale), ffa.scaleTo(0.1, 1.0 * scale)), ffa.fadeIn(0.1)))
	table.insert(seq, ffa.delay(0.5))
	table.insert(seq, ffa.moveTo(0.5, startPos.x, startPos.y))
	table.insert(seq, ffa.callFunc(function()
		self:updateMarkBtnRedDot()
	end))
	self.fields.Button_mark:runAction(ffa.seq(seq))
end
function MythicalCreaturesViewPanel:onPageClick(sender, params)
	SoraDPlaySound()
	local curIndex = self.curIndex + params
	if self.divineIDList[curIndex] == nil then
		if 0 < params then
			curIndex = #self.divineIDList
		else
			curIndex = 1
		end
	end
	self.curIndex = curIndex
	self.curType = self.divineIDList[self.curIndex]
	self.turnPage = true
	self.isActionPlaying = false
	self.isInTreat = false
	self.oldIsInTreat = false
	self.oldSelectedPage = nil
	self.fields.Usm_1:stopAllActions()
	self.treatRewards = nil
	self.treatRewards2 = nil
	self:updateView()
	self.fields.Panel_tab:setToTag(self.selectedPage, true)
	self.turnPage = false
end
return MythicalCreaturesViewPanel
