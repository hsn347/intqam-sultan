local constantRead = include("constantRead")
local activity_9001720_Ctrl = SoraDGetCtrl("activity_9001720_Ctrl")
local activity_9001720_Read = include("activity_9001720_Read")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local dailyRemindManager = include("dailyRemindManager")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001720_MainPanel = class("Activity_9001720_MainPanel", baseFguiPanel)
function Activity_9001720_MainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity_9001661"
	end
	return self._packageList
end
function Activity_9001720_MainPanel:ctor(...)
	Activity_9001720_MainPanel.super.ctor(self, ...)
	print("Activity_9001720_MainPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720
	self.exchange_activityID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010015
	self.doStage = activityShowCtrl:getDoStageByID(self.activityID)
	self.activityName = activityTimeRead.getActivityShowName(self.activityID)
end
function Activity_9001720_MainPanel:onInit()
	print("=======Activity_9001720_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickBack), handler(self, self.onClickHelp))
	self.fields.Com_title:setTitleWidthHeight(480, 40)
	_UPVALUE1_, _UPVALUE8_ = self.fields.Com_title, self.fields.Com_title.setTitleWidthHeight
	_UPVALUE1_, self.fields.Com_title[1] = self.fields.Button_members, self.fields.Button_members
	_UPVALUE1_, self.fields.Com_title[2] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[3] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[4] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[5] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[6] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[7] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[8] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[9] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[10] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Com_title[11] = self.fields.Button_members, i18n("lion_park_text1")
	_UPVALUE1_, self.fields.Button_members[1] = self.fields.Button_shop, self.fields.Button_shop
	_UPVALUE1_, self.fields.Button_members[2] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_members[3] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_members[4] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_members[5] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_members[6] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_members[7] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_members[8] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_members[9] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_members[10] = self.fields.Button_shop, i18n("worldboss_monkey_03")
	_UPVALUE1_, self.fields.Button_shop[1] = self.fields.Button_rank, self.fields.Button_rank
	_UPVALUE1_, self.fields.Button_shop[2] = self.fields.Button_rank, i18n("common_text_851")
	_UPVALUE1_, self.fields.Button_shop[3] = self.fields.Button_rank, i18n("common_text_851")
	_UPVALUE1_, self.fields.Button_shop[4] = self.fields.Button_rank, i18n("common_text_851")
	_UPVALUE1_, self.fields.Button_shop[5] = self.fields.Button_rank, i18n("common_text_851")
	_UPVALUE1_, self.fields.Button_shop[6] = self.fields.Button_rank, i18n("common_text_851")
	_UPVALUE1_, self.fields.Button_shop[7] = self.fields.Button_rank, i18n("common_text_851")
	_UPVALUE1_, self.fields.Button_shop[8] = self.fields.Button_rank, i18n("common_text_851")
	_UPVALUE1_, self.fields.Button_shop[9] = self.fields.Button_rank, i18n("common_text_851")
	_UPVALUE1_, self.fields.Button_rank[1] = self.fields.Button_reward, self.fields.Button_reward
	_UPVALUE1_, self.fields.Button_rank[2] = self.fields.Button_reward, i18n("common_text_2078")
	_UPVALUE1_, self.fields.Button_rank[3] = self.fields.Button_reward, i18n("common_text_2078")
	_UPVALUE1_, self.fields.Button_rank[4] = self.fields.Button_reward, i18n("common_text_2078")
	_UPVALUE1_, self.fields.Button_rank[5] = self.fields.Button_reward, i18n("common_text_2078")
	_UPVALUE1_, self.fields.Button_rank[6] = self.fields.Button_reward, i18n("common_text_2078")
	_UPVALUE1_, self.fields.Button_rank[7] = self.fields.Button_reward, i18n("common_text_2078")
	_UPVALUE1_, self.fields.Button_rank[8] = self.fields.Button_reward, i18n("common_text_2078")
	_UPVALUE1_, self.fields.Button_reward[1] = self.fields.Button_home, self.fields.Button_home
	_UPVALUE1_, self.fields.Button_reward[2] = self.fields.Button_home, i18n("soldier_rush_skill_name_5")
	_UPVALUE1_, self.fields.Button_reward[3] = self.fields.Button_home, i18n("soldier_rush_skill_name_5")
	_UPVALUE1_, self.fields.Button_reward[4] = self.fields.Button_home, i18n("soldier_rush_skill_name_5")
	_UPVALUE1_, self.fields.Button_reward[5] = self.fields.Button_home, i18n("soldier_rush_skill_name_5")
	_UPVALUE1_, self.fields.Button_reward[6] = self.fields.Button_home, i18n("soldier_rush_skill_name_5")
	_UPVALUE1_, self.fields.Button_reward[7] = self.fields.Button_home, i18n("soldier_rush_skill_name_5")
	_UPVALUE1_, self.fields.Button_home[1] = self.fields.Button_spread, self.fields.Button_spread
	_UPVALUE1_, self.fields.Button_home[2] = self.fields.Button_spread, i18n("lion_park_text5")
	_UPVALUE1_, self.fields.Button_home[3] = self.fields.Button_spread, i18n("lion_park_text5")
	_UPVALUE1_, self.fields.Button_home[4] = self.fields.Button_spread, i18n("lion_park_text5")
	_UPVALUE1_, self.fields.Button_home[5] = self.fields.Button_spread, i18n("lion_park_text5")
	_UPVALUE1_, self.fields.Button_home[6] = self.fields.Button_spread, i18n("lion_park_text5")
	_UPVALUE1_, self.fields.Button_spread[1] = self.fields.Button_water, self.fields.Button_water
	_UPVALUE1_, self.fields.Button_spread[2] = self.fields.Button_water, i18n("lion_park_text3")
	_UPVALUE1_, self.fields.Button_spread[3] = self.fields.Button_water, i18n("lion_park_text3")
	_UPVALUE1_, self.fields.Button_spread[4] = self.fields.Button_water, i18n("lion_park_text3")
	_UPVALUE1_, self.fields.Button_spread[5] = self.fields.Button_water, i18n("lion_park_text3")
	self.fields.Button_water[1] = self.fields.Button_assist
	self.fields.Button_water[2] = i18n("lion_park_text11")
	self.fields.Button_water[3] = i18n("lion_park_text11")
	self.fields.Button_water[4] = i18n("lion_park_text11")
	self.fields.Com_title.setTitleWidthHeight[1] = self.fields.Com_title
	self.fields.Com_title.setTitleWidthHeight[2] = self.fields.Button_members
	self.fields.Com_title.setTitleWidthHeight[3] = self.fields.Button_shop
	self.fields.Com_title.setTitleWidthHeight[4] = self.fields.Button_rank
	self.fields.Com_title.setTitleWidthHeight[5] = self.fields.Button_reward
	self.fields.Com_title.setTitleWidthHeight[6] = self.fields.Button_home
	self.fields.Com_title.setTitleWidthHeight[7] = self.fields.Button_spread
	local self.fields.Com_title.setTitleWidthHeight[8], config = self.fields.Button_water, self.fields.Com_title.setTitleWidthHeight
	for __, cfg in ipairs(config) do
		local widget, title = cfg[1], cfg[2]
		if title then
			widget:setString(title)
		end
		widget:addClickListener(handler(self, self.onClickOperateBtn))
	end
	self.fields.Label_lv = self.fields.bar:getChild("Label_lv")
	self.fields.Com_timegift:setActivityID(self.activityID)
	self.fields.Com_tip:addClickListener(handler(self, self.onClickBtnTip))
	local _fields = fguiHelper.get_fields(self.fields.Com_tip)
	_fields.Text_point:setString("...")
	if SoraDFIsRA() then
		_fields.Image_new:setURL("img_common_new_ar.png")
	else
		_fields.Image_new:setURL("img_common_new_en.png")
		_fields.title:fixChildrenPos()
	end
	if not SoraDFIsRA() then
		self.fields.bar:getChild("bar"):fixPos()
		self.fields.Button_spread:fixPos()
		self.fields.Button_water:fixPos()
		self.fields.Com_tip:fixChildrenPos()
		local _fields = fguiHelper.get_fields(self.fields.Com_player)
		_fields.Text_assCount:setAlign(cc.TEXT_ALIGNMENT_LEFT)
		_fields.Text_beAssCount:setAlign(cc.TEXT_ALIGNMENT_LEFT)
	end
end
function Activity_9001720_MainPanel:onShow()
	print("=======Activity_9001720_MainPanel:onShow")
	self:updateBtnShop()
	self:updateProgressBar()
	self:updatePlayerInfo()
	self:updateTextAssist()
	if self.doStage == 0 then
		self:updateBtnMembers()
		self:updateBtnWater()
		self:updateBtnSpread()
		self:updateTextReceive()
		self:updateLabelSpread()
		self:updateComTip()
		activity_9001720_Ctrl:reqRecord()
		if self.canReceive then
			SoraDShowLoading(self)
			activity_9001720_Ctrl:reqReward()
		end
	else
		self:updateDoStage()
	end
end
function Activity_9001720_MainPanel:onIntoPanel(...)
	self.fields.prefabExBtm:setVisible(false)
	self.fields.prefabExTop:setVisible(false)
	if self.enterShop then
		self.enterShop = false
		self:updateBtnShop()
	end
end
function Activity_9001720_MainPanel:onClickBack(...)
	if self.controllers.c1:getSelectedIndex() == 1 then
		SoraDPlaySound("uicontrol", 1)
		self:backHome()
		return
	end
	self:onClickClose()
end
function Activity_9001720_MainPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("lion_park_text31")
	uiManager:show("RuleView", nil)
end
function Activity_9001720_MainPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_members then
		if not allianceMgr:hasJoinAlliance() then
			SoraDShowMsgTip(i18n("datepalm_tree_text48"))
			return
		end
		uiManager:show("Activity_9001720_Members")
	elseif sender == self.fields.Button_reward then
		uiManager:show("Activity_9001720_Reward")
	elseif sender == self.fields.Button_rank then
		uiManager:show("Activity_9001720_Rank")
	elseif sender == self.fields.Button_shop then
		if clientEventMgr.judgeIsOpen(self.exchange_activityID, true) then
			self.enterShop = true
			_ENV = i18n("datepalm_tree_text48")
			i18n("datepalm_tree_text48").id = self.exchange_activityID
			uiManager:show("ExchangeEventPage", i18n("datepalm_tree_text48"))
		end
	elseif sender == self.fields.Button_home then
		self:backHome()
	elseif sender == self.fields.Button_spread then
		self:clickBtnSpread()
	elseif sender == self.fields.Button_water then
		self:clickBtnWater()
	elseif sender == self.fields.Button_assist then
		self:clickBtnAssist()
	end
end
function Activity_9001720_MainPanel:clickBtnSpread(...)
	if not SoraDEnoughGold(self.costGold) then
		return
	end
	if activity_9001720_Read.getLevelByExp(activity_9001720_Ctrl:getGrowthValue()) >= activity_9001720_Read.getLevelMax() then
		SoraDShowMsgTip(i18n("lion_park_text42"))
		return
	end
	local remainKey = dailyRemindManager.REMIND_TYPE.Activity_9001720
	if self.spreadTimes >= 3 and not dailyRemindManager.checkNeedRemind(remainKey) then
		SoraDShowLoading(self)
		activity_9001720_Ctrl:reqCare()
		return
	end
	local addExp = constantRead.getConstValue("LION_PARK_GOLD_FERTLIZE_EXP", 2)
	_ENV = i18n("lion_park_text42")
	i18n("lion_park_text42").num = string.formatnumberthousands(self.costGold)
	i18n("lion_park_text42").exp = addExp
	local msgStr1 = i18n("lion_park_text8", i18n("lion_park_text42"))
	_ENV = string.formatnumberthousands(self.costGold)
	string.formatnumberthousands(self.costGold).time = self.spreadTimes
	local msgStr2 = i18n("lion_park_text34", (string.formatnumberthousands(self.costGold)))
	local msgStr = msgStr1 .. "\n" .. msgStr2
	local remindFunc
	if self.spreadTimes >= 3 then
		function remindFunc(value)
			if value then
				dailyRemindManager.addRemindToManager(remainKey)
			end
		end
	end
	_ENV = i18n("lion_park_text42")
	i18n("lion_park_text42").content = msgStr
	i18n("lion_park_text42").confirmFunc = function(...)
		SoraDShowLoading(self)
		activity_9001720_Ctrl:reqCare()
	end
	i18n("lion_park_text42").remindFunc = remindFunc
	uiManager:show("Activity_9001720_Message", i18n("lion_park_text42"))
end
function Activity_9001720_MainPanel:clickBtnWater(...)
	if self.waterRemain <= 0 then
		SoraDShowMsgTip(i18n("lion_park_text4"))
		return
	end
	if activity_9001720_Read.getLevelByExp(activity_9001720_Ctrl:getGrowthValue()) >= activity_9001720_Read.getLevelMax() then
		SoraDShowMsgTip(i18n("lion_park_text43"))
		return
	end
	SoraDShowLoading(self)
	activity_9001720_Ctrl:reqClean()
end
function Activity_9001720_MainPanel:clickBtnAssist(...)
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("lion_park_text32"))
		return
	end
	if self.member then
		if activity_9001720_Ctrl:checkHasAssist(self.member) then
			SoraDShowMsgTip(i18n("lion_park_text15"))
			return
		end
		local limit = constantRead.getConstValue("LION_PARK_HELP_NUM", 2)
		local assistanceTimes = activity_9001720_Ctrl:getAssistanceTimes()
		if limit <= assistanceTimes then
			SoraDShowMsgTip(i18n("lion_park_text13"))
			return
		end
		local limit = constantRead.getConstValue("LION_PARK_ACCEPPT_HELP_NUM", 2)
		local times = activity_9001720_Ctrl:getBeAssistanceTimes(self.member)
		if limit <= times then
			SoraDShowMsgTip(i18n("lion_park_text14"))
			return
		end
		SoraDShowLoading(self)
		activity_9001720_Ctrl:reqAssist(self.member.uid)
	end
end
function Activity_9001720_MainPanel:onClickBtnTip(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001720_Record")
end
function Activity_9001720_MainPanel:updateTextReceive(...)
	local canReceive = activity_9001720_Ctrl:checkLionCanReceive()
	if self.canReceive ~= canReceive then
		self.canReceive = canReceive
		self:updateTreeIcon()
	end
	self.fields.Com_timegift:initData()
end
function Activity_9001720_MainPanel:updateLabelSpread(...)
	local limit = constantRead.getConstValue("LION_PARK_ACCEPPT_HELP_NUM", 2)
	local times = activity_9001720_Ctrl:getBeAssistanceTimes(self.member)
	local remain = math.max(0, limit - times)
	local _fields = fguiHelper.get_fields(self.fields.Com_player)
	constantRead = nil
	;(nil).num = remain
	;(nil).maxnum = limit
	_fields.Text_beAssCount:setString(i18n("bubble_farm_text9", nil))
end
function Activity_9001720_MainPanel:updateProgressBar(...)
	local growthValue = activity_9001720_Ctrl:getGrowthValue(self.member)
	local curLv = activity_9001720_Read.getLevelByExp(growthValue)
	self.fields.Label_lv:setString(curLv)
	local _fields = fguiHelper.get_fields(self.fields.Com_treeInfo)
	_fields.Text_lv:setString(curLv)
	local lvMax = activity_9001720_Read.getLevelMax()
	if curLv == lvMax then
		self.fields.bar:setMax(1)
		self.fields.bar:setValue(1)
		self.fields.bar:getChild("title"):setString(i18n("hero_text_41"))
	else
		local nextLv = curLv + 1
		local curExp = activity_9001720_Read.getLevelConfigExp(curLv)
		local nextExp = activity_9001720_Read.getLevelConfigExp(nextLv)
		local expMax = nextExp - curExp
		self.fields.bar:setMax(expMax)
		local newValue = growthValue - curExp
		self:showBarValueEffect(newValue)
	end
	if self.curLv ~= curLv then
		self.curLv = curLv
		self:updateTreeIcon()
	end
end
function Activity_9001720_MainPanel:showBarValueEffect(newValue)
	local expMax = self.fields.bar:getMax()
	local newPercent = newValue / expMax
	if not self.barValue then
		self.fields.bar:setValue(newValue)
		self.barValue = newValue
		self.barPercent = newPercent
		return
	end
	self.fields.bar:stopAllActions()
	local totalTime = 0.5
	if newPercent > self.barPercent then
		local duration = (newValue - self.barValue) / expMax * totalTime
		self.fields.bar:tweenValue(newValue, duration)
	else
		local time1 = (1 - self.barPercent) * totalTime
		local time2 = newPercent * totalTime
		_UPVALUE2_ = nil
		;(nil)[1] = ffa.callFunc(function()
			if 0 < time1 then
				self.fields.bar:tweenValue(expMax, time1)
			else
				self.fields.bar:setValue(expMax)
			end
		end)
		;(nil)[2] = ffa.delay(time1)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.bar:setValue(0)
			if 0 < time2 then
				self.fields.bar:tweenValue(newValue, time2)
			end
		end)
		;(nil)[4] = ffa.callFunc(function()
			self.fields.bar:setValue(0)
			if 0 < time2 then
				self.fields.bar:tweenValue(newValue, time2)
			end
		end)
		self.fields.bar:runAction(ffa.seq(nil))
	end
	self.barValue = newValue
	self.barPercent = newPercent
end
function Activity_9001720_MainPanel:updateTreeIcon(...)
	if self.curLv then
		if self.member then
			local treeIcon = activity_9001720_Read.getTreeIcon(self.curLv, true)
			self.fields.Usm_tree:clearEffect()
			self.fields.Usm_tree:setEffectPath(treeIcon, true)
		elseif self.canReceive ~= nil then
			local treeIcon = activity_9001720_Read.getTreeIcon(self.curLv, true)
			self.fields.Usm_tree:clearEffect()
			self.fields.Usm_tree:setEffectPath(treeIcon, true)
		end
	end
end
function Activity_9001720_MainPanel:updateBtnWater(...)
	local total = constantRead.getConstValue("LION_PARK_WATERING_NUM", 2)
	local remian = activity_9001720_Ctrl:getRemainWaterTimes()
	self.waterRemain = remian
	local Text_free = self.fields.Button_water:getWidget("Text_free")
	if remian <= 0 then
		Text_free:setColor(cc.c3b(190, 40, 40))
	else
		Text_free:setColor(cc.c3b(255, 251, 213))
	end
	constantRead = cc.c3b(255, 251, 213)
	cc.c3b(255, 251, 213).member = remian
	cc.c3b(255, 251, 213).total = total
	self.fields.Button_water:setFree(i18n("common_text_155", cc.c3b(255, 251, 213)))
	self.fields.Button_water:setReddot(0 < remian)
end
function Activity_9001720_MainPanel:updateBtnSpread(...)
	local spreadTimes = activity_9001720_Ctrl:getSpreadTimes()
	self.spreadTimes = spreadTimes
	local costGold = activity_9001720_Read.getCostGold(spreadTimes + 1)
	self.costGold = costGold
	self.fields.Button_spread:setCostNum(costGold, SoraDGetGold())
end
function Activity_9001720_MainPanel:updateComTip(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_tip)
	local _controllers = fguiHelper.get_controllers(self.fields.Com_tip)
	local record, recordStr = activity_9001720_Ctrl:getLastRecordStr()
	print("==Activity_9001720_MainPanel:updateComTip==", recordStr)
	if recordStr then
		local readTime = activity_9001720_Ctrl:getRecordReadTime()
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
function Activity_9001720_MainPanel:updateTextAssist(...)
	local remain = activity_9001720_Ctrl:getRemainAssistanceTimes()
	activity_9001720_Ctrl = nil
	;(nil).num = remain
	self.fields.Text_assist:setString(i18n("datepalm_tree_text64", nil))
	local _fields = fguiHelper.get_fields(self.fields.Com_player)
	activity_9001720_Ctrl = i18n("datepalm_tree_text64", nil)
	i18n("datepalm_tree_text64", nil).num = remain
	_fields.Text_assCount:setString(i18n("datepalm_tree_text64", i18n("datepalm_tree_text64", nil)))
end
function Activity_9001720_MainPanel:updateBtnMembers(...)
	local remain = activity_9001720_Ctrl:getRemainAssistanceTimes()
	self.fields.Button_members:setRedVisible(0 < remain, remain)
end
function Activity_9001720_MainPanel:updateBtnShop(...)
	local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
	local ret, num = newExchangeMallCtrl:getReceiveStatusAndNum(self.exchange_activityID)
	self.fields.Button_shop:setRedVisible(ret, num)
end
function Activity_9001720_MainPanel:showExpAndLvEffect(event)
	if self.member then
		return
	end
	local addExp = event.addExp
	if addExp and 0 < addExp then
		self.fields.Com_pointEffect:showAddExpEffect(addExp)
	end
	local addLv = event.addLv
	if addLv and 0 < addLv then
		self.fields.prefabExBtm:setVisible(true)
		self.fields.prefabExTop:setVisible(true)
		self.fields.prefabExBtm:clearEffect()
		self.fields.prefabExBtm:setEffectPath("fx_ui_ssly_boom_btm_01.prefab")
		self.fields.prefabExTop:clearEffect()
		self.fields.prefabExTop:setEffectPath("fx_ui_ssly_boom_top_01.prefab")
	elseif addExp and 0 < addExp then
		self.fields.prefabExBtm:setVisible(true)
		self.fields.prefabExTop:setVisible(true)
		self.fields.prefabExBtm:clearEffect()
		self.fields.prefabExBtm:setEffectPath("fx_ui_ssly_boom_btm_01.prefab")
		self.fields.prefabExTop:clearEffect()
		self.fields.prefabExTop:setEffectPath("fx_ui_ssly_boom_top_01.prefab")
	end
end
function Activity_9001720_MainPanel:onMsgUpdateData(target, event)
	local key = event.key
	if key == "clean" then
		SoraDCloseLoading(self)
		self:updateProgressBar()
		self:updateBtnWater()
		self:updatePlayerInfo()
		self:playWaterAct()
	elseif key == "care" then
		SoraDCloseLoading(self)
		self:updateProgressBar()
		self:updateBtnSpread()
		self:updatePlayerInfo()
		self:playSpreadAct()
	elseif key == "assisted" then
		if self.member then
			return
		end
		self:updateLabelSpread()
		self:updateProgressBar()
		self:updateComTip()
		self:updatePlayerInfo()
	elseif key == "assist" then
		SoraDCloseLoading(self)
		if event.err ~= gErrDef.Err_None then
			return
		end
		if self.member then
			table.merge(self.member, event.member)
		else
			self.member = event.member
		end
		self:updateLabelSpread()
		self:updateProgressBar()
		self:updateTextAssist()
		self:updateBtnMembers()
		self:updateComTip()
		self:updateBtnAssist()
		self:updatePlayerInfo(self.member)
		self:playSpreadAct()
	elseif key == "gotoOther" then
		local member = event.member
		self:gotoOther(member)
	elseif key == "record" then
		self:updateComTip()
	elseif key == "reward" then
		SoraDCloseLoading(self)
		self:updateTextReceive()
	elseif key == "backHome" then
		self:backHome()
	elseif key == "recordRead" then
		self:updateComTip()
	elseif key == "initData" then
		if self.member then
			return
		end
		if self.doStage == 0 then
			self:updateBtnMembers()
			self:updateBtnWater()
			self:updateBtnSpread()
			self:updateTextReceive()
			self:updateLabelSpread()
			self:updateTextAssist()
		end
	end
	self:showExpAndLvEffect(event)
end
function Activity_9001720_MainPanel:gotoOther(member)
	self.controllers.c1:setSelectedIndex(1)
	self.member = member
	self.barValue = nil
	self:updatePlayerInfo(self.member)
	if self.doStage == 0 then
		self:updateLabelSpread()
		self:updateProgressBar()
		self:updateTextAssist()
		self:updateBtnAssist()
	else
		self:updateProgressBar()
	end
end
function Activity_9001720_MainPanel:updateBtnAssist(...)
	local ret = activity_9001720_Ctrl:checkCanAssist(self.member)
	if ret then
		self.fields.Button_assist:setReddot(true)
	else
		self.fields.Button_assist:setReddot(false)
	end
end
function Activity_9001720_MainPanel:backHome(...)
	self.controllers.c1:setSelectedIndex(0)
	self.member = nil
	self.barValue = nil
	self:updatePlayerInfo()
	if self.doStage == 0 then
		self:updateBtnMembers()
		self:updateProgressBar()
		self:updateTextReceive()
		self:updateLabelSpread()
	else
		self:updateProgressBar()
	end
end
function Activity_9001720_MainPanel:judgeClose(target, event)
	local activityID = event.activityID
	if not activityID or type(activityID) ~= "table" or not table.indexof(activityID, self.activityID) then
		return
	end
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if doStage ~= self.doStage then
		self.doStage = doStage
		self:updateDoStage()
	end
end
function Activity_9001720_MainPanel:updateDoStage(...)
	if self.doStage ~= 1 then
		return
	end
	self.controllers.c_stage:setSelectedIndex(1)
	local remainTime = activityShowCtrl:getRemainTime(self.activityID)
	self.fields.Com_title:initSpecialActivityTime(remainTime, i18n("datepalm_tree_text30"))
	self.fields.Label_end:setString(i18n("common_text_1859"))
end
function Activity_9001720_MainPanel:updatePlayerInfo(member)
	if member then
		_ENV = nil
		;(nil).name = member.nickName
		self.fields.Com_title:setString(i18n("lion_park_text10", nil))
	else
		self.fields.Com_title:setString(self.activityName)
	end
	local _fields = fguiHelper.get_fields(self.fields.Com_player)
	local c1 = self.fields.Com_player:getController("c1")
	if member then
		c1:setSelectedIndex(1)
		_fields.Com_head:setHeadSprite(member.iconID, member.avatar)
		_fields.Com_head:setAvatarFrame(member.avatarFrameId)
	else
		c1:setSelectedIndex(0)
		_fields.Com_head:setSelfHead()
	end
	local growthValue = activity_9001720_Ctrl:getGrowthValue(member)
	local curLv = activity_9001720_Read.getLevelByExp(growthValue)
	_fields.Text_lv:setString("Lv." .. curLv)
	local _fields = fguiHelper.get_fields(self.fields.Com_treeInfo)
	if member then
		_ENV = i18n("lion_park_text10", nil)
		i18n("lion_park_text10", nil).name = member.nickName
		_fields.Text_name:setString(i18n("lion_park_text10", i18n("lion_park_text10", nil)))
	else
		_fields.Text_name:setString(i18n("lion_park_text2"))
	end
	if self.doStage == 0 then
		if member then
			c1:setSelectedIndex(1)
		else
			c1:setSelectedIndex(0)
		end
	else
		c1:setSelectedIndex(2)
	end
end
function Activity_9001720_MainPanel:playWaterAct()
	if not self.fields.Spine.effect then
		self.fields.Spine:setEffectPath("spine/activity/ssfm_dh_01.skel", "animation01", false)
	else
		self.fields.Spine.effect:setAnimation(0, "animation01", false)
	end
end
function Activity_9001720_MainPanel:playSpreadAct()
	if not self.fields.Spine.effect then
		self.fields.Spine:setEffectPath("spine/activity/ssfm_dh_01.skel", "animation02", false)
	else
		self.fields.Spine.effect:setAnimation(0, "animation02", false)
	end
end
return Activity_9001720_MainPanel
