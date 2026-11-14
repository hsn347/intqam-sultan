local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local activity_9001661_Read = include("activity_9001661_Read")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local constantRead = include("constantRead")
local dailyRemindManager = include("dailyRemindManager")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001661_MainPanel = class("Activity_9001661_MainPanel", baseFguiPanel)
function Activity_9001661_MainPanel:ctor(...)
	Activity_9001661_MainPanel.super.ctor(self, ...)
	print("Activity_9001661_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.BUBBLE_GRANGE_ACTIVITY
end
function Activity_9001661_MainPanel:onInit()
	print("=======Activity_9001661_MainPanel:onInit")
	self.wateringNum = constantRead.getConstValue("FARM_WATERING_NUM", 2)
	self.helpNum = constantRead.getConstValue("FARM_HELP_NUM", 2)
	self.accepptHelpNum = constantRead.getConstValue("FARM_ACCEPPT_HELP_NUM", 2)
	self.fields.mv_ds:setAllFrameName("ds_9001661_%.2d.png", 1)
	self.fields.mv_zl_1:setAllFrameName("zl_9001661_01_%.2d.png", 1)
	self.fields.mv_zl_2:setAllFrameName("zl_9001661_02_%.2d.png", 1)
	self.fields.mv_ds:setVisible(false)
	self.fields.mv_zl_1:setVisible(false)
	self.fields.mv_zl_2:setVisible(false)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	fguiHelper.SoraDSetComFields(self)
	self.fields.Text_des:setString(i18n("bubble_farm_text21"))
	self.fields.Text_des:setAlign(cc.TEXT_ALIGNMENT_LEFT)
	self.fields.UI_Bar = self.fields.bar:getChild("UI_Bar")
	self.fields.UI_Bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	self.fields.Label_lv = self.fields.bar:getChild("Label_lv")
	self.fields.Button_cook:setString(i18n("activity_name_9001669"))
	self.fields.Button_cook:addClickListener(handler(self, self.btnCookClick))
	self.fields.Button_farm:setString(i18n("bubble_farm_text1"))
	self.fields.Button_farm:addClickListener(handler(self, self.btnFarmClick))
	self.fields.Button_rank:setString(i18n("pyramid_btn_29"))
	self.fields.Button_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Button_reward:setString(i18n("atlantiswar_text_0019"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_goHome:setString(i18n("soldier_rush_skill_name_5"))
	self.fields.Button_goHome:addClickListener(handler(self, self.btnGoHomeClick))
	self.fields.Button_clean:setString(i18n("bubble_farm_text5"))
	self.fields.Button_clean:addClickListener(handler(self, self.btnCleanClick))
	self.fields.Button_takeCare:setString(i18n("bubble_farm_text7"))
	self.fields.Button_takeCare:addClickListener(handler(self, self.btnTakeCareClick))
	self.fields.Button_help:setString(i18n("exitic_pavillion_text_0022"))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Com_tip:addClickListener(handler(self, self.onClickBtnTip))
	local _fields = fguiHelper.get_fields(self.fields.Com_tip)
	_fields.Text_point:setString("...")
	if SoraDFIsRA() then
		_fields.Image_new:setURL("img_common_new_ar.png")
	else
		_fields.Image_new:setURL("img_common_new_en.png")
	end
	self.fields.Com_tip:fixChildrenPos()
	self.farm = self.fields.bg:getChild("Mod_left")
	self.Usm_tree = self.farm:getChild("Usm_tree")
	self.Button_touch = self.farm:getChild("Button_touch")
	self.Button_touch:addClickListener(handler(self, self.btnTouchClick))
	self.Com_lvup = self.farm:getChild("Com_lvup")
	self.Com_lvup:setVisible(false)
end
function Activity_9001661_MainPanel:onShow()
	print("=======Activity_9001661_MainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.member = self.param and self.param.member
	self.from = self.param and self.param.from or nil
	self:initData()
	if allianceMgr:hasJoinAlliance() then
		activity_9001661_Ctrl:reqBubbleGrangeEnter()
	end
	if not self.member then
		if activity_9001661_Ctrl:checkCanReceive() then
			activity_9001661_Ctrl:reqBubbleGrangeReward()
		end
		activity_9001661_Ctrl:reqBubbleGrangeRecord()
	end
end
function Activity_9001661_MainPanel:initData()
	self.controllers.c1:setSelectedIndex(self.member and 2 or 0)
	if self.member then
		_ENV = nil
		;(nil).name = self.member.nickName
		if i18n("bubble_farm_text11", nil) then
			goto lbl_30
		end
	end
	::lbl_30::
	self.fields.Com_title:updateTitle((i18n("activity_name_9001661")))
	if self.member then
		_ENV = nil
		;(nil).name = self.member.nickName
		if i18n("bubble_farm_text11", nil) then
			goto lbl_51
		end
	end
	::lbl_51::
	self.farm:getChild("title"):setString((i18n("bubble_farm_text16")))
	self.fields.Com_gift:initData()
	self.fields.sheep:initData()
	self.fields.Com_info:initData(self.member)
	self.barValue = nil
	self:updateProgressBar()
	self:updateFarmShow()
	if self.member then
		self:updateDailyHelp()
	else
		self:setCleanBtn()
		self:setTakeCareBtn()
		self:updateComTip()
		self.fields.Button_farm:setReddot(activity_9001661_Ctrl:checkAssist())
	end
end
function Activity_9001661_MainPanel:updateDailyHelp()
	if self.member then
		local times = self.helpNum - activity_9001661_Ctrl:getAssistanceTimes()
		activity_9001661_Ctrl = nil
		;(nil).num = times
		self.fields.Text_dailyTimes:setString(i18n("bubble_farm_text8", nil))
		local isHelped = SoraDisInList(SoraDGetPlayerID(), self.member.assistanceUsers)
		self.fields.Button_help:setBright(0 < times and not isHelped and #self.member.assistanceUsers < self.accepptHelpNum)
	end
end
function Activity_9001661_MainPanel:updateFarmShow()
	local curLv = activity_9001661_Ctrl:getGrowthLv(self.member)
	self.farm:getChild("icon"):setSpriteFrame(activity_9001661_Read.getFarmIcon(curLv))
	self.farm:getChild("Text_lv"):setString(curLv)
	local liveshow = activity_9001661_Read.getLevelConfigLiveshow(curLv)
	self.Usm_tree:setPositionX(liveshow == 1 and 350 or 250)
	self.Com_lvup:initData(curLv + 1)
end
function Activity_9001661_MainPanel:updateProgressBar()
	local growthValue = activity_9001661_Ctrl:getGrowthValue(self.member)
	local curLv = activity_9001661_Ctrl:getGrowthLv(self.member)
	self.fields.Label_lv:setString(curLv)
	local lvMax = activity_9001661_Read.getLevelMax()
	if curLv == lvMax then
		self.fields.UI_Bar:setMax(1)
		self.fields.UI_Bar:setValue(1)
		self.fields.UI_Bar:setBarTitle(i18n("hero_text_41"))
	else
		local nextLv = curLv + 1
		local curExp = activity_9001661_Read.getLevelConfigExp(curLv)
		local nextExp = activity_9001661_Read.getLevelConfigExp(nextLv)
		local expMax = nextExp - curExp
		self.fields.UI_Bar:setMax(expMax)
		local newValue = growthValue - curExp
		self:showBarValueEffect(newValue)
	end
	if self.curLv ~= curLv then
		self.curLv = curLv
	end
end
function Activity_9001661_MainPanel:showBarValueEffect(newValue)
	local expMax = self.fields.UI_Bar:getMax()
	local newPercent = newValue / expMax
	if not self.barValue then
		self.fields.UI_Bar:setValue(newValue)
		self.barValue = newValue
		self.barPercent = newPercent
		return
	end
	self.fields.UI_Bar:stopAllActions()
	local totalTime = 0.5
	if newPercent > self.barPercent then
		local duration = (newValue - self.barValue) / expMax * totalTime
		self.fields.UI_Bar:tweenValue(newValue, duration)
	else
		local time1 = (1 - self.barPercent) * totalTime
		local time2 = newPercent * totalTime
		_UPVALUE2_ = nil
		;(nil)[1] = ffa.callFunc(function()
			if 0 < time1 then
				self.fields.UI_Bar:tweenValue(expMax, time1)
			else
				self.fields.UI_Bar:setValue(expMax)
			end
		end)
		;(nil)[2] = ffa.delay(time1)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.UI_Bar:setValue(0)
			if 0 < time2 then
				self.fields.UI_Bar:tweenValue(newValue, time2)
			end
		end)
		;(nil)[4] = ffa.callFunc(function()
			self.fields.UI_Bar:setValue(0)
			if 0 < time2 then
				self.fields.UI_Bar:tweenValue(newValue, time2)
			end
		end)
		self.fields.UI_Bar:runAction(ffa.seq(nil))
	end
	self.barValue = newValue
	self.barPercent = newPercent
end
function Activity_9001661_MainPanel:setCleanBtn()
	self.remian = activity_9001661_Ctrl:getRemainCleanTimes()
	activity_9001661_Ctrl = nil
	;(nil).num = self.remian
	;(nil).max = self.wateringNum
	self.fields.Button_clean:setFree(i18n_html("eidal_celebration_text22", nil))
	self.fields.Button_clean:setReddot(self.remian > 0)
	self.fields.Button_clean:setBright(self.remian > 0)
end
function Activity_9001661_MainPanel:setTakeCareBtn()
	local spreadTimes = activity_9001661_Ctrl:getSpreadTimes()
	self.spreadTimes = spreadTimes
	local costGold = activity_9001661_Read.getCostGold(spreadTimes + 1)
	self.costGold = costGold
	self.fields.Button_takeCare:setCostNum(costGold, SoraDGetGold())
end
function Activity_9001661_MainPanel:updateComTip()
	local _fields = fguiHelper.get_fields(self.fields.Com_tip)
	local _controllers = fguiHelper.get_controllers(self.fields.Com_tip)
	local record, recordStr = activity_9001661_Ctrl:getLastRecordStr()
	if recordStr then
		local readTime = activity_9001661_Ctrl:getRecordReadTime()
		if not readTime or readTime < record.time then
			_controllers.c_new:setSelectedIndex(1)
		else
			_controllers.c_new:setSelectedIndex(0)
		end
		_fields.title:setString(recordStr)
		local showPoint = _fields.title:getWidth() >= 400
		_fields.Text_point:setVisible(showPoint)
	else
		_controllers.c_new:setSelectedIndex(0)
		_fields.title:setString(i18n("datepalm_tree_text44"))
		_fields.Text_point:setVisible(false)
	end
end
function Activity_9001661_MainPanel:onMsgUpdateData(target, event)
	SoraDCloseLoading(self)
	if event then
		if event.key == "reward" then
			self.fields.Com_gift:initData()
			self.fields.sheep:initData()
		elseif event.key == "clean" then
			self:playCleanAct()
			self:setCleanBtn()
			self:updateProgressBar()
			self:updateFarmShow()
			self.fields.Com_info:initData()
		elseif event.key == "takeCare" then
			self:playTakeCareAct()
			self:setTakeCareBtn()
			self:updateProgressBar()
			self:updateFarmShow()
			self.fields.Com_info:initData()
		elseif event.key == "assist" and event.member then
			self:playCleanAct()
			self.member = event.member
			self.fields.Com_info:initData(self.member)
			self:updateFarmShow()
			self:updateProgressBar()
			self:updateDailyHelp()
			self.fields.Button_farm:setReddot(activity_9001661_Ctrl:checkAssist())
		elseif event.key == "assisted" then
			self.fields.Com_info:initData(self.member)
			self:updateFarmShow()
			self:updateProgressBar()
			self:updateComTip()
		elseif event.key == "record" or event.key == "recordRead" then
			self:updateComTip()
		elseif event.key == "initData" and self.member then
			self:initData()
		end
		self:showExpAndLvEffect(event)
	end
end
function Activity_9001661_MainPanel:showExpAndLvEffect(event)
	if self.member then
		return
	end
	local addExp = event.addExp
	if addExp and 0 < addExp then
		self.fields.Com_pointEffect:showAddExpEffect(addExp)
	end
	local addLv = event.addLv
	if addLv and 0 < addLv then
		self.Usm_tree:clearEffect()
		self.Usm_tree:setEffectPath("G_activity_usm_9001594_01.usm")
		self.Usm_tree:play()
	elseif addExp and 0 < addExp then
		self.Usm_tree:clearEffect()
		self.Usm_tree:setEffectPath("G_activity_usm_9001594_02.usm")
		self.Usm_tree:play()
	end
end
function Activity_9001661_MainPanel:btnCookClick()
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(gActivityTimeActivityID.NORMAL_ACTIVITY_9001669)
end
function Activity_9001661_MainPanel:btnFarmClick()
	SoraDPlaySound()
	if allianceMgr:hasJoinAlliance() then
		uiManager:show("Activity_9001661_Map")
	else
		SoraDShowMsgTip(i18n("notice_0066"))
	end
end
function Activity_9001661_MainPanel:btnRankClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001661_Rank")
end
function Activity_9001661_MainPanel:btnRewardClick()
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(1)
	self.fields.Com_title:setTimeShowIndex(1)
	self.fields.Com_title:updateTitle(i18n("bubble_farm_text33"))
	self.Com_lvup:setVisible(false)
end
function Activity_9001661_MainPanel:btnGoHomeClick()
	SoraDPlaySound()
	if self.member then
		self.member = nil
		self:initData()
	end
	if self.from and self.from == "map" then
		local mapPanel = SoraDSearchPanelFromManagerByName("Activity_9001661_Map")
		if mapPanel then
			SoraDRemovePanelFromManager(mapPanel)
		end
	end
end
function Activity_9001661_MainPanel:close()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 1 then
		self.member = nil
		self:initData()
		self.fields.Com_title:setTimeShowIndex(0)
		self.fields.Com_title:initCommonActivityTime(self.activityID)
	elseif self.controllers.c1:getSelectedIndex() == 2 then
		if self.from and self.from == "record" then
			self.member = nil
			self:initData()
		elseif self.from and self.from == "map" then
			self.member = nil
			self:initData()
			uiManager:show("Activity_9001661_Map")
		else
			self:closePanel()
		end
	else
		self:closePanel()
	end
end
function Activity_9001661_MainPanel:playCleanAct()
	self.fields.mv_ds:setVisible(true)
	self.fields.mv_ds:setAlpha(0)
	self.fields.mv_ds:stopAllActions()
	_UPVALUE1_ = nil
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.fadeIn(0.2)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.mv_ds:setPlaySettings(0, -1, 3, -1, function()
			self.fields.mv_ds:setVisible(false)
		end)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.mv_ds:setPlaySettings(0, -1, 3, -1, function()
			self.fields.mv_ds:setVisible(false)
		end)
	end)
	;(nil)[1] = ffa.spawn(nil)
	;(nil)[2] = ffa.fadeOut(1.6)
	;(nil)[3] = ffa.fadeOut(1.6)
	;(nil)[4] = ffa.fadeOut(1.6)
	;(nil)[5] = ffa.fadeOut(1.6)
	self.fields.mv_ds:runAction(ffa.seq(nil))
end
function Activity_9001661_MainPanel:btnCleanClick()
	SoraDPlaySound()
	if self.remian < 1 then
		SoraDShowMsgTip(i18n("bubble_farm_text6"))
		return
	end
	SoraDShowLoading(self)
	activity_9001661_Ctrl:reqBubbleGrangeClean()
end
function Activity_9001661_MainPanel:playTakeCareAct()
	local rIndex = math.random(2)
	local mvTarget = self.fields["mv_zl_" .. rIndex]
	mvTarget:setVisible(true)
	mvTarget:setAlpha(0)
	mvTarget:stopAllActions()
	_UPVALUE2_ = nil
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.fadeIn(0.2)
	;(nil)[2] = ffa.callFunc(function()
		mvTarget:setPlaySettings(0, -1, 2, -1, function()
			mvTarget:setVisible(false)
		end)
	end)
	;(nil)[3] = ffa.callFunc(function()
		mvTarget:setPlaySettings(0, -1, 2, -1, function()
			mvTarget:setVisible(false)
		end)
	end)
	;(nil)[1] = ffa.spawn(nil)
	;(nil)[2] = ffa.delay(rIndex == 2 and 0.1 or 2)
	;(nil)[3] = ffa.fadeOut(rIndex == 2 and 2.2 or 3.6)
	;(nil)[4] = ffa.fadeOut(rIndex == 2 and 2.2 or 3.6)
	;(nil)[5] = ffa.fadeOut(rIndex == 2 and 2.2 or 3.6)
	mvTarget:runAction(ffa.seq(nil))
end
function Activity_9001661_MainPanel:btnTakeCareClick()
	SoraDPlaySound()
	if activity_9001661_Ctrl:getGrowthLv() >= activity_9001661_Read.getLevelMax() then
		SoraDShowMsgTip(i18n("bubble_farm_text36"))
		return
	end
	if not SoraDEnoughGold(self.costGold) then
		return
	end
	print("self.spreadTimes=====", self.spreadTimes)
	local remainKey = dailyRemindManager.REMIND_TYPE.activity_9001661
	if self.spreadTimes >= 3 and not dailyRemindManager.checkNeedRemind(remainKey) then
		SoraDShowLoading(self)
		activity_9001661_Ctrl:reqBubbleGrangeCare()
		return
	end
	local remindFunc
	if self.spreadTimes >= 3 then
		function remindFunc(value)
			if value then
				dailyRemindManager.addRemindToManager(remainKey)
			end
		end
	end
	local addExp = constantRead.getConstValue("FARM_GOLD_FERTLIZE_EXP", 2)
	_ENV = i18n("bubble_farm_text36")
	i18n("bubble_farm_text36").num = string.formatnumberthousands(self.costGold)
	i18n("bubble_farm_text36").exp = addExp
	local msgStr1 = i18n("bubble_farm_text22", i18n("bubble_farm_text36"))
	_ENV = string.formatnumberthousands(self.costGold)
	string.formatnumberthousands(self.costGold).time = self.spreadTimes
	local msgStr2 = i18n("bubble_farm_text23", (string.formatnumberthousands(self.costGold)))
	local msgStr = msgStr1 .. "\n" .. msgStr2
	_ENV = i18n("bubble_farm_text36")
	i18n("bubble_farm_text36").content = msgStr
	i18n("bubble_farm_text36").confirmFunc = function()
		SoraDShowLoading(self)
		activity_9001661_Ctrl:reqBubbleGrangeCare()
	end
	i18n("bubble_farm_text36").remindFunc = remindFunc
	uiManager:show("Activity_9001661_Message", i18n("bubble_farm_text36"))
end
function Activity_9001661_MainPanel:btnHelpClick()
	SoraDPlaySound()
	local times = self.helpNum - activity_9001661_Ctrl:getAssistanceTimes()
	if times <= 0 then
		SoraDShowMsgTip(i18n("bubble_farm_text13"))
		return
	end
	if #self.member.assistanceUsers >= self.accepptHelpNum then
		SoraDShowMsgTip(i18n("bubble_farm_text14"))
		return
	end
	if SoraDisInList(SoraDGetPlayerID(), self.member.assistanceUsers) then
		SoraDShowMsgTip(i18n("bubble_farm_text15"))
		return
	end
	self:playCleanAct()
	SoraDShowLoading(self)
	activity_9001661_Ctrl:reqBubbleGrangeAssist(self.member.uid)
end
function Activity_9001661_MainPanel:onClickBtnTip()
	SoraDPlaySound()
	uiManager:show("Activity_9001661_Record")
end
function Activity_9001661_MainPanel:btnTouchClick()
	if not self.member and activity_9001661_Ctrl:getGrowthLv() < activity_9001661_Read.getLevelMax() then
		SoraDPlaySound()
		self.Com_lvup:setVisible(not self.Com_lvup:isVisible())
	else
		self.Com_lvup:setVisible(false)
	end
end
function Activity_9001661_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("bubble_farm_rule1")
	uiManager:show("RuleView", nil)
end
return Activity_9001661_MainPanel
