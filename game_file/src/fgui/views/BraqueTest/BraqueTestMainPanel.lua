local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local warOrderRead = include("warOrderRead")
local eventQuestRead = include("eventQuestRead")
local activityTimeRead = include("activityTimeRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BraqueTestMainPanel = class("BraqueTestMainPanel", baseFguiPanel)
function BraqueTestMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BraqueTestMainPanel:ctor", self.viewName)
end
function BraqueTestMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BraqueTestMainPanel:onInit()
	print("=======BraqueTestMainPanel:onInit")
	self.taskList, _ENV = print, print
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	self.curCtrl = warOrderCtrl:getCurCtrl(self.activityID)
	local activityName = i18n(activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)))
	self.fields.Com_title:initData(activityName, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.ProgressBar_Level:fixChildrenPos()
	self.fields.Label_lv = self.fields.ProgressBar_Level:getChildByName("Label_lv")
	self.fields.Label_lv:getChildByName("Text_lv"):setString("lv")
	self.fields.Text_Title1:setString(i18n("Braque_text_03"))
	self.fields.Button_GetAward:setString(i18n("summoned_btn_01"))
	self.fields.Button_GetAward:addClickListener(handler(self, self.onClickAllAward))
	self.fields.Button_Active:addClickListener(handler(self, self.onClickUnlock))
	self.fields.Button_view:setString(i18n("Battle_Towers_23"))
	self.fields.Button_view:addClickListener(handler(self, self.onClickBuffPreview))
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemAwardRederer))
	self.fields.List_Task:setItemRenderer(handler(self, self.onItemTaskRederer))
	local taskName
	if self.activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY then
		self.fields.Button_Add:addClickListener(handler(self, self.jumpToRechargeView))
		self.fields.Button_Active:setString(i18n("Braque_text_06"))
		self.fields.Text_Tip:setString(i18n("Braque_text_08"))
		self.fields.Text_Title2:setString(i18n("Braque_text_04"))
		self.fields.Text_Title3:setString(i18n("Braque_text_05"))
		taskName = i18n("Braque_text_02")
	else
		self.fields.Button_Active:setString(i18n("StarlitNight_text_02"))
		self.fields.Text_Title2:setString(i18n("StarlitNight_text_07"))
		taskName = i18n("MagiclampDecree_02")
	end
	if self.fields.Usm then
		self.fields.Usm:setIgnoreClearEffect(true)
	end
	_ENV = self.fields.Usm.setIgnoreClearEffect
	_ENV, _ENV, self.fields.Usm.setIgnoreClearEffect.defaultClick = true, self.tag, self.tag
	;(true).title = activityName
	_ENV, self.tag[1], (true).tag = true, true, 1
	;(true).title = taskName
	self.fields.Usm.setIgnoreClearEffect.tabsetArray, self.tag[2], (true).tag = self.tag, true, 2
	local self.fields.Usm.setIgnoreClearEffect.callback, param = handler(self, self.onClickTab), self.fields.Usm.setIgnoreClearEffect
	self.fields.Com_tab:initView(param)
end
function BraqueTestMainPanel:initHeadSpine()
	if self.activityID ~= gActivityTimeActivityID.WAR_ORDER_ACTIVITY then
		return
	end
	local dressID = warOrderRead.getHeroDressID(SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID))
	print("dressID=====", dressID)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.fields.Spine:setVisible(not isUsm)
	self.fields.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.fields.Usm:setEffectPath(spineCfg)
		self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm:setScale(cfg.detail[1])
		self.fields.Usm:setUsmAP(cc.p(0.5, 0))
		self.fields.Usm:setUsmPos(cc.p(cfg.detail[2], cfg.detail[3]))
		if dressID == 171602 then
			self.fields.Usm:setUsmPos(cc.p(cfg.detail[2] + 50, cfg.detail[3] - 200))
		end
	else
		self.fields.Spine:setEffectPath(spineCfg)
		self.fields.Spine:setScale(cfg.detail[1])
		self.fields.Spine:setSpinePos(cc.p(cfg.detail[2], cfg.detail[3]))
		self.fields.Spine:getSpine():setAutoCull(false)
		if dressID == 172302 then
			self.fields.Spine:setSpinePos(cc.p(cfg.detail[2], cfg.detail[3] - 200))
		end
	end
	local viewBg, isNewBg = heroltCtrl:getDressViewBg(dressID)
	self.fields.bg:setSpriteFrame(viewBg)
	local viewBgWidth = self.fields.bg:getWidth()
	print("viewBgWidth", viewBgWidth, self:getWidth())
	if viewBgWidth < 852 then
		self.fields.bg:setScale(self:getWidth() / viewBgWidth)
	else
		self.fields.bg:setScale(1)
	end
end
function BraqueTestMainPanel:onShow()
	print("=======BraqueTestMainPanel:onShow")
	SoraDShowLoading(self)
	self.curCtrl:sendReqInitDataMsg()
	self:initHeadSpine()
end
function BraqueTestMainPanel:updateReward()
	self:updateView()
	self.lvRewardList = warOrderRead.getLvAwardList(self.activityID, self.curCtrl:getGroupIndex())
	local lvRewardMax = 0
	warOrderRead = self.activityID
	self.activityID[gActivityTimeActivityID.WAR_ORDER_ACTIVITY] = true
	self.activityID[gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY] = true
	local self.activityID[gActivityTimeActivityID.NORMAL_ACTIVITY_9001701], config = true, self.activityID
	if config[self.activityID] then
		lvRewardMax = #self.lvRewardList
	else
		lvRewardMax = #self.lvRewardList - 1
	end
	self.fields.List_Award:setNumItems(lvRewardMax)
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	print("#self.lvRewardList-1,self.curLv-1", lvRewardMax - 1, self.curLv - 1)
	self.fields.List_Award:scrollToView(math.min(lvRewardMax - 1, math.max(0, self.curLv - 1)))
end
function BraqueTestMainPanel:updateTask()
	self.taskList = self.curCtrl:getTaskList()
	dump(self.taskList, "self.taskList")
	self.fields.List_Task:setNumItems(#self.taskList)
end
function BraqueTestMainPanel:updateView()
	local buffType = self.curCtrl:getBuffTypeEx()
	if self.activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY then
		self.controllers.c2:setSelectedIndex(math.max(0, buffType - 1))
		if buffType == 2 then
			self.fields.Button_Active:setString(i18n("Braque_text_07"))
		end
	else
		local classMax = warOrderRead.getClassTypeMax(self.activityID)
		if buffType > classMax then
			self.controllers.c2:setSelectedIndex(1)
			if self.curCtrl:getLevel() < self.curCtrl:getUnlockBuffLv() then
				_ENV = i18n("Braque_text_07")
				i18n("Braque_text_07").lv = self.curCtrl:getUnlockBuffLv()
				self.fields.Text_Tip:setString(i18n("GloriousDecree_33", i18n("Braque_text_07")))
			else
				self.fields.Text_Tip:setString(i18n("Braque_text_08"))
			end
		end
	end
	self.curLv = self.curCtrl:getLevel()
	local maxValue = warOrderRead.getNextExp(self.activityID, self.curLv, self.curCtrl:getGroupIndex())
	self.fields.Label_lv:setString(self.curLv)
	self.fields.ProgressBar_Level:setMax(maxValue)
	self.fields.ProgressBar_Level:setValue(self.curCtrl:getExp())
	self.fields.Button_GetAward:setEnabled(0 < self.curCtrl:getLvRewardStatusAndNum())
	self:setBuffRange()
end
function BraqueTestMainPanel:setBuffRange()
	if not self.fields.Text_rangeROS then
		return
	end
	if IsArClient then
		self.fields.Text_rangeROS:setVisible(false)
		return
	end
	local _ENV, buffShow = self.fields.Text_rangeROS.setVisible, self.fields.Text_rangeROS.setVisible
	local _UPVALUE3_, _ENV, limitLv = false, self.fields.Text_rangeROS, self.fields.Text_rangeROS
	;(false)[1] = BUILD_ENUM.CASTLE_STAR
	;(false)[2] = BUILD_ENUM.GLORIOUS_STATUE
	local (false)[3], buffTypeList = BUILD_ENUM.MAGIC_LAMP, false
	for i = 1, 3 do
		local buffInfo = warOrderRead.getBuffInfo(self.activityID, buffTypeList[i], i)
		limitLv[i] = buffInfo.CastleLv
	end
	if 0 < #limitLv then
		table.insert(buffShow, i18n("common_text_4859"))
		if limitLv[1] then
			_ENV = i18n("common_text_4859")
			i18n("common_text_4859").lv = string.format("%d~%d", limitLv[1][1], limitLv[1][2])
			table.insert(buffShow, i18n("Glory_text_24", i18n("common_text_4859")))
		end
		if limitLv[2] then
			_ENV = i18n("Glory_text_24", i18n("common_text_4859"))
			i18n("Glory_text_24", i18n("common_text_4859")).lv1 = limitLv[2][1]
			i18n("Glory_text_24", i18n("common_text_4859")).lv2 = limitLv[2][2]
			table.insert(buffShow, i18n("common_text_4860", i18n("Glory_text_24", i18n("common_text_4859"))))
		end
		if limitLv[3] then
			_ENV = i18n("common_text_4860", i18n("Glory_text_24", i18n("common_text_4859")))
			i18n("common_text_4860", i18n("Glory_text_24", i18n("common_text_4859"))).lv1 = limitLv[3][1]
			i18n("common_text_4860", i18n("Glory_text_24", i18n("common_text_4859"))).lv2 = limitLv[3][2]
			table.insert(buffShow, i18n("MagiclampDecree_09", i18n("common_text_4860", i18n("Glory_text_24", i18n("common_text_4859")))))
		end
		self.fields.Text_rangeROS:setString(table.concat(buffShow, "\n"))
		self.fields.Text_rangeROS:setAlign(2)
		self.fields.Text_rangeROS:setVisible(true)
	else
		self.fields.Text_rangeROS:setVisible(false)
	end
end
function BraqueTestMainPanel:updatRed()
	local rewardRedNum = self.curCtrl:getLvRewardStatusAndNum()
	local taskRedNum = self.curCtrl:getTaskStatusAndNum()
	self.fields.Com_tab:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
	self.fields.Com_tab:setBtnRedDot(2, 0 < taskRedNum, taskRedNum)
end
function BraqueTestMainPanel:onItemAwardRederer(index, target)
	target:initActivityData(self.activityID, self.lvRewardList[index + 1], index, self.curLv)
end
function BraqueTestMainPanel:onItemTaskRederer(index, target)
	local taskID = self.taskList[index + 1]
	eventQuestRead = nil
	;(nil).taskID = taskID
	;(nil).progress = self.curCtrl:getTaskProgress(taskID)
	;(nil).taskStatus = self.curCtrl:getTaskState(taskID)
	;(nil).taskDes = eventQuestRead.getDes(taskID)
	;(nil).award = eventQuestRead.getReward(taskID)
	;(nil).aim = eventQuestRead.getAim(taskID)
	;(nil).guideId = eventQuestRead.getGuideId(taskID)
	;(nil).isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	;(nil).activityID = self.activityID
	target:initData(nil)
end
function BraqueTestMainPanel:onClickUnlock()
	SoraDPlaySound()
	local tip = false
	if self.activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		local magicLampRead = include("magicLampRead")
		local data = magicLampCtrl:getJinnByType(gJinnType.JINN_ONE)
		tip = data.lv >= magicLampRead.getMaxLv(gJinnType.JINN_ONE)
	elseif self.activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
		local magicLampHatchRead = include("magicLampHatchRead")
		local data = magicLampHatchCtrl:getHatchData(1)
		tip = data.lv >= magicLampHatchRead.getMaxLv(1)
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		local magicLampRead = include("magicLampRead")
		local data = magicLampCtrl:getJinnByType(gJinnType.JINN_TWO)
		tip = data.lv >= magicLampRead.getMaxLv(gJinnType.JINN_TWO)
	end
	if tip then
		_ENV = data.lv
		data.lv.content = i18n("common_text_4951")
		function data.lv.confirmFunc()
			_ENV = nil
			;(nil).activityID = self.activityID
			;(nil).type = 2
			uiManager:show("BraqueTestBuyGift", nil)
		end
		data.lv.cancel = true
		uiManager:show("MessageBox", data.lv)
	else
		_ENV = data.lv
		data.lv.activityID = self.activityID
		data.lv.type = 2
		uiManager:show("BraqueTestBuyGift", data.lv)
	end
end
function BraqueTestMainPanel:onClickTab(tag)
	self.tag = tag
	if self.tag == 1 then
		if self.activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
			self.fields.Usm_1:setEffectPath("xssd_bj.usm")
			self.fields.Usm_1:setPositionX(196)
		elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
			self.fields.Usm_1:setEffectPath("SD_yijiedjfire_01.usm")
			self.fields.Usm_1:setPositionX(196)
		end
	end
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 2 then
		self:updateTask()
	else
		self:updateReward()
	end
end
function BraqueTestMainPanel:onClickAllAward()
	SoraDPlaySound()
	SoraDShowLoading(self)
	self.curCtrl:reqWarOrderReceive()
end
function BraqueTestMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound[gActivityTimeActivityID.WAR_ORDER_ACTIVITY] = "Braque_text_01"
	SoraDPlaySound[gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY] = "HatchDecree_text_05"
	local SoraDPlaySound[gActivityTimeActivityID.NORMAL_ACTIVITY_9001701], config = "AnilaDecree_text_04", SoraDPlaySound
	local contentKey = config[self.activityID] or "MagiclampDecree_01"
	local content = i18n(contentKey)
	_ENV = nil
	;(nil).content = content
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function BraqueTestMainPanel:onClickBuffPreview()
	SoraDPlaySound()
	warOrderRead.openSkillBuffView(self.activityID)
end
function BraqueTestMainPanel:jumpToRechargeView()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeIDList = activityTimeRead.getRechargeId(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID))
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNodeByList(12, activityTimeRead.getRechargeId(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)))
		panel:show()
	end
end
return BraqueTestMainPanel
