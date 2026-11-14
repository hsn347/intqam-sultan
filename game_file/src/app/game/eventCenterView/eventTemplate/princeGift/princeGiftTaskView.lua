local publicRead = include("publicRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local princeGiftRead = include("princeGiftRead")
local constantRead = include("constantRead")
local cityBuildMgr = include("cityBuildMgr")
local princeGiftTaskView = class("princeGiftTaskView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("princeGiftTaskView")
	end
	return target
end)
function princeGiftTaskView:ctor()
	self.cellList, _UPVALUE0_ = nil, nil
	self:initControls()
	self:initEffect()
end
function princeGiftTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_INIT", function(target, data)
		SoraDCloseLoading(self)
		self.isGotReward = false
		local stage = princeGiftCtrl:getWhichStage()
		local unReceiveNum = princeGiftRead.getTotalUnreceiveRewardNum(princeGiftCtrl:getCurScore())
		_ENV = princeGiftCtrl:getCurScore()
		princeGiftCtrl:getCurScore().byUID = true
		local saveNum = SoraDConfigGet("Game:princeGiftView:rewardNum~integer", princeGiftCtrl:getCurScore())
		print("我点进来啦", unReceiveNum, saveNum)
		if stage == 1 and unReceiveNum > saveNum then
			_ENV = saveNum
			saveNum.byUID = true
			SoraDConfigSet("Game:princeGiftView:rewardNum~integer", unReceiveNum, saveNum)
			_ENV = "Game:princeGiftView:rewardNum~integer"
			;("Game:princeGiftView:rewardNum~integer").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			;("Game:princeGiftView:rewardNum~integer").eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
			SoraDSendMessage("Game:princeGiftView:rewardNum~integer")
		end
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_BUY_PACKAGE", function(target, data)
		SoraDCloseLoading(self)
		local rechargePanel = SoraDSearchPanelFromManagerByName("rechargePopFrame")
		print("存在这里吗333")
		SoraDCloseLoading()
		if rechargePanel then
			print("存在这里吗444")
			rechargePanel:removeFromParent()
		end
		self.isGotReward = false
		if princeGiftCtrl:getIsBuy() then
			self:playAllHighAnimatio()
		end
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_GET_REWARD", function(target, data)
		SoraDCloseLoading(self)
		self.isGotReward = data.isGotReward or false
		print("slkdfsdlkjf", self.isGotReward)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function princeGiftTaskView:playAllHighAnimatio()
	local curScore = princeGiftCtrl:getCurScore()
	local curLv, targetScore = princeGiftRead.getLevelInfoByScore(curScore)
	for i, target in ipairs(self.cellList) do
		if i >= curLv then
			target:playSingleAnimation(true, true)
		end
	end
end
function princeGiftTaskView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("Wisdom_of_oriental_prince_text_01"))
	self.activityID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
	local castlePoint = constantRead.getConstValue("WISDOM_OF_ORIENTAL_PRINCECASTLE_POINTS")
	local otherPoint = constantRead.getConstValue("WISDOM_OF_ORIENTAL_PRINCEOTHER_BUILDING_POINTS")
	_ENV = i18n("Wisdom_of_oriental_prince_text_01")
	i18n("Wisdom_of_oriental_prince_text_01").num1 = castlePoint
	i18n("Wisdom_of_oriental_prince_text_01").num2 = otherPoint
	self.Text_ins:setString(i18n("Wisdom_of_oriental_prince_text_04", i18n("Wisdom_of_oriental_prince_text_01")))
	self.Button_receive:setTitleText(i18n("ice_carnival_text05"))
	self.Button_unlock:setTitleText(i18n("Payment_activity_optimization_text_14"))
	self.Text_free:setString(i18n("Wisdom_of_oriental_prince_text_21"))
	self.Text_package:setString(i18n("Wisdom_of_oriental_prince_text_22"))
	self.Button_back:setTitleText(i18n("common_text_006"))
	SoraDSetTextWidthHeight(self.Text_package, cc.size(100, 60))
	SoraDAutoSizeButtonText(self.Button_unlock, cc.size(80, 40))
	self.Panel_1:setContentSize(cc.size(display.width, display.height))
	self.nodeProBarPreview = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_preview")
	self.nodeProBarPreview:setActionDelay(0.5)
	self.nodeProBarPreview:setLocalZOrder(5)
	self.Button_receive:addTouchEventListener(handler(self, self.buttonGetRewardCallBack))
	self.btn_add:addTouchEventListener(handler(self, self.buttonAddCallBack))
	self.Button_unlock:addTouchEventListener(handler(self, self.buttonUnlockCallBack))
	self.Button_back:addTouchEventListener(handler(self, self.buttonBackCallBack))
	self.Top_Size_ScrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnHelpTip:setVisible(false)
	self.beginPercent = 1
	princeGiftCtrl:reqInitInfo()
	SoraDShowLoading(self)
	self.Text_des:setString(i18n("Payment_activity_optimization_text_13"))
end
function princeGiftTaskView:initEffect()
	local loop = true
	local cssFileName = "princeGiftTaskView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
	self.G_dh_Tex_lcks_005:setOpacity(76.5)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.fadeTo(1, 1)
	;(nil)[2] = cca.fadeTo(1, 0.3)
	;(nil)[3] = cca.fadeTo(1, 0.3)
	;(nil)[4] = cca.fadeTo(1, 0.3)
	self.G_dh_Tex_lcks_005:runAction(cca.repeatForever(cca.seq(nil)))
	SoraDMixtureGLONE(self.dh_Tex_yxzjz_001)
	self.dh_Tex_yxzjz_001:setOpacity(0)
	_UPVALUE1_ = cca.repeatForever(cca.seq(nil))
	cca.repeatForever(cca.seq(nil))[1] = cca.fadeTo(1, 1)
	cca.repeatForever(cca.seq(nil))[2] = cca.fadeTo(1, 0)
	cca.repeatForever(cca.seq(nil))[3] = cca.fadeTo(1, 0)
	cca.repeatForever(cca.seq(nil))[4] = cca.fadeTo(1, 0)
	self.dh_Tex_yxzjz_001:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
end
function princeGiftTaskView:initData()
	local stage = princeGiftCtrl:getWhichStage()
	local curScore = princeGiftCtrl:getCurScore()
	local curLv, targetScore = princeGiftRead.getLevelInfoByScore(curScore)
	local maxScore = princeGiftRead.getMaxScore()
	local unreceiveRewardNum = princeGiftRead.getTotalUnreceiveRewardNum(curScore)
	local isBuy = princeGiftCtrl:getIsBuy()
	print("sdlkfjslkdfjsldkfj", stage, curScore, curLv, targetScore, maxScore, unreceiveRewardNum)
	self.Button_back:setVisible(stage == 1)
	self.Button_receive:setVisible(stage == 2)
	self.Button_receive:setBright(stage == 2 and 0 < unreceiveRewardNum)
	self.Button_receive:setEnabled(stage == 2 and 0 < unreceiveRewardNum)
	self.dh_Tex_yxzjz_001:setVisible(stage == 2 and 0 < unreceiveRewardNum)
	self.Particle_receive:setVisible(stage == 2 and 0 < unreceiveRewardNum)
	self.Button_unlock:setVisible(stage == 2 and not isBuy)
	self.Text_des:setVisible(stage == 2 and not isBuy)
	if curScore >= maxScore then
		curScore = maxScore
	end
	if stage == 2 then
		self.ccs_title:setTitle(i18n("Wisdom_of_oriental_prince_text_01"))
		if isBuy then
			local castlePoint = constantRead.getConstValue("WISDOM_OF_ORIENTAL_PRINCECASTLE_POINTS")
			local otherPoint = constantRead.getConstValue("WISDOM_OF_ORIENTAL_PRINCEOTHER_BUILDING_POINTS")
			princeGiftCtrl = i18n("Wisdom_of_oriental_prince_text_01")
			i18n("Wisdom_of_oriental_prince_text_01").num1 = castlePoint
			i18n("Wisdom_of_oriental_prince_text_01").num2 = otherPoint
			self.Text_ins:setString(i18n("Wisdom_of_oriental_prince_text_04", i18n("Wisdom_of_oriental_prince_text_01")))
		else
			self.Text_ins:setString(i18n("Payment_activity_optimization_text_12"))
		end
	else
		self.ccs_title:setTitle(i18n("Payment_activity_optimization_text_07"))
		self.Text_ins:setString(i18n("Payment_activity_optimization_text_12"))
	end
	self.Button_back:setPositionX(stage == 1 and 0 or SoraDFPosX(180, 0))
	self.Button_receive:setPositionX((isBuy or stage == 1) and 0 or SoraDFPosX(180, 0))
	princeGiftCtrl = 0
	;(0).num1 = curScore
	;(0).num2 = targetScore
	;(0).num3 = curLv + 1
	self.Text_score:setString(i18n("Wisdom_of_oriental_prince_text_05", 0))
	self.btn_add:setPositionX(self.Text_score:getPositionX() + SoraDFSign(self.Text_score:getContentSize().width / 2) + SoraDFSign(20))
	if curLv == 10 then
		self.Text_score:setString(i18n("common_text_283"))
		self.btn_add:setVisible(false)
	end
	self.icon_lock_normal_6:setVisible(stage == 1)
	self.icon_lock_gold_6:setVisible(not isBuy)
	self:initScroll()
	local currentScene = display.getRunningScene()
	local currentView = currentScene:currentSceneShowView()
	if currentView.__cname == "worldMapView" then
		self.btn_add:setVisible(false)
	end
end
function princeGiftTaskView:initScroll()
	local lastLv = princeGiftCtrl:getLastLv()
	local infoTable = princeGiftRead.getAllTaskInfo()
	local curScore = princeGiftCtrl:getCurScore()
	local curLv, targetScore = princeGiftRead.getLevelInfoByScore(curScore)
	local isBuy = princeGiftCtrl:getIsBuy()
	local maxScore = princeGiftRead.getMaxScore()
	local sSize = self.Top_Size_ScrollView:getContentSize()
	local sH = math.max(sSize.height, #infoTable * 260)
	self.Top_Size_ScrollView:setInnerContainerSize(cc.size(sSize.width, sH))
	print("lastLv", lastLv)
	for i, v in ipairs(infoTable) do
		local cell
		if self.cellList[i] then
			cell = self.cellList[i]
		else
			cell = include("princeGiftTaskSingle").new(self.Node_single:clone())
			cell:addTo(self.Top_Size_ScrollView)
			table.insert(self.cellList, cell)
		end
		cell:setVisible(true)
		cell:setPosition(320, sH - i * 250)
		cell:initData(self, i, curLv)
		local nodeLevel = self.Node_level:clone()
		nodeLevel:setPosition(320, sH - i * 220 - (i - 1) * 30)
		nodeLevel:addTo(self.Top_Size_ScrollView, 6)
		local txtLevel = SoraDGetChildByName(nodeLevel, "Text_89")
		princeGiftCtrl = self.Node_single:clone()
		self.Node_single:clone().num = i
		txtLevel:setString(i18n("hero_text_13", self.Node_single:clone()))
	end
	for i = #infoTable + 1, #self.cellList do
		self.cellList[i]:setVisible(false)
	end
	self.nodeProBarPreview:setPosition(320, sH)
	local LoadingBar_progress = SoraDGetChildByName(self.nodeProBarPreview, "LoadingBar_progress_fg")
	LoadingBar_progress:setContentSize(cc.size(30, sH - 90))
	local progressHeight = sH - 100
	self.nodeProBarPreview:setProgressContentSize(cc.size(progressHeight, 25))
	local nextLv = curLv + 1
	if 10 < nextLv then
		nextLv = 10
	end
	singlePercent = 0.1
	local nextTargetScore = princeGiftRead.getTaskInfoByLevel(nextLv).integral
	local curTargetScore = princeGiftRead.getTaskInfoByLevel(curLv).integral
	curPercent = singlePercent * curLv + singlePercent * ((curScore - curTargetScore) / (nextTargetScore - curTargetScore))
	if curScore == 600 then
		curPercent = 1
	end
	self.nodeProBarPreview:setInitState(false)
	princeGiftCtrl = false
	;(false).maxValue = progressHeight
	;(false).curValue = curPercent * progressHeight
	self.nodeProBarPreview:setProgressDate(false)
	self.Node_Effect_ProgressHead:setPositionX(curPercent * progressHeight)
	princeGiftCtrl = curPercent * progressHeight
	;(curPercent * progressHeight).byUID = true
	SoraDConfigSet("Game:princeGiftCtrl:score~integer", curScore, curPercent * progressHeight)
	local scrollHeight = -sSize.height + self.Top_Size_ScrollView:getInnerContainerSize().height
	local scrollPercent = 260 * (curLv - 1) / scrollHeight
	if not self.isGotReward then
		self.Top_Size_ScrollView:scrollToPercentVertical(scrollPercent * 100, 1.5, true)
	end
end
function princeGiftTaskView:buttonBackCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(button, type)
	end
end
function princeGiftTaskView:buttonUnlockCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).id = 14141
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD01
			uiManager:show("rechargePopView", nil)
		else
			local panel = SoraDCreatePanel("rechargePopView")
			panel:initData(14141, gRechargeActiveFromEnum.ROAD01)
			panel:show()
		end
	end
end
function princeGiftTaskView:buttonGetRewardCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		princeGiftCtrl:reqGetAllReward()
		SoraDShowLoading(self)
	end
end
function princeGiftTaskView:buttonAddCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local buildlist = cityCtrl:getBuildList()
		local buildIndex = 101
		local _ENV, rightBuildtable
		for k, buildcell in pairs(buildlist) do
			local index = tonumber(buildcell.info.index)
			local level = tonumber(buildcell.info.lv)
			local buildEntity = cityBuildMgr:getBuildByIndex(index)
			if 6 < level and level < 30 and buildEntity:getBuildState() == BUILD_STATE.NORMAL and level ~= SoraDGetCastleLv() and not buildEntity:getIsLocked() then
				table.insert(rightBuildtable, tonumber(buildcell.info.bid))
			end
		end
		if next(rightBuildtable) then
			local rightNum = math.random(1, #rightBuildtable)
			buildIndex = rightBuildtable[rightNum]
		end
		_ENV = #rightBuildtable
		;(#rightBuildtable).bid = buildIndex
		;(#rightBuildtable).lv = 10
		gModuleMgr.sharedMgr("mildGuideManager"):starToUpgrade(#rightBuildtable)
		SoraDRemoveAllPanelFromManager()
	end
end
function princeGiftTaskView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		local scrollHeight = self.Top_Size_ScrollView:getContentSize().height
		local inner = self.Top_Size_ScrollView:getInnerContainer()
		local innerPosY = -inner:getPositionY()
		local innerHeight = inner:getContentSize().height
		local percent = innerPosY / (innerHeight - scrollHeight)
		if 0.9 < percent then
			self.Top_Size_ScrollView:setBounceEnabled(false)
		elseif percent < 0.1 then
			self.Top_Size_ScrollView:setBounceEnabled(true)
		end
	end
end
function princeGiftTaskView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function princeGiftTaskView:onExitPanel()
	local stage = princeGiftCtrl:getWhichStage()
	if stage == 2 then
		princeGiftCtrl = nil
		;(nil).msg = "MESSAGE_PRINCE_GIFT_GUIDE_BUFF_REFRESH"
		SoraDSendMessage(nil)
	end
end
return princeGiftTaskView
