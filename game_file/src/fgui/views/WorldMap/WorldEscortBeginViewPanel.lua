local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local mailFunctions = include("mailFunctions")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local chatFunctions = include("chatFunctions")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local escortCartCtrl = gametop.playertop_:getModule("escortCartCtrl")
local escortCtrl = gametop.playertop_:getModule("escortCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local escortAssistCtrl = gametop.playertop_:getModule("escortAssistCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldEscortBeginViewPanel = class("WorldEscortBeginViewPanel", baseFguiPanel)
function WorldEscortBeginViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("WorldEscortBeginViewPanel:ctor", self.viewName)
end
function WorldEscortBeginViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldEscortBeginViewPanel:onInit()
	self.fields.text_invite_help:fixPos()
	self.fields.btn_invite:fixPos()
	print("=======WorldEscortBeginViewPanel:onInit")
	self.text_remain_time = self.fields.text_remain_time
	self.text_choose_char_tip = self.fields.text_choose_char_tip
	self.car1 = self.fields.CCS_worldEscortCar_Node_1
	self.car2 = self.fields.CCS_worldEscortCar_Node_2
	self.car3 = self.fields.CCS_worldEscortCar_Node_3
	self.car4 = self.fields.CCS_worldEscortCar_Node_4
	self.car5 = self.fields.CCS_worldEscortCar_Node_5
	self.btn_beginEscort = self.fields.btn_beginEscort
	self.btn_refresh = self.fields.CCS_commonGoldNormalBtn_refresh
	self.btn_gold = self.fields.CCS_commonGoldNormalBtn_gold
	self.btn_invite = self.fields.btn_invite
	self.btn_openBuff = self.fields.btn_openBuff
	self.text_invite_tip = self.fields.text_invite_tip
	self.text_invite_help = self.fields.text_invite_help
	self.img_car = self.fields.img_car
	self.sprite_baoche = self.fields.sprite_baoche
	self.member = self.fields.CS_worldEscortMember_member
	self.bg_escort = self.fields.bg_escort
	self.text_add = self.fields.text_add
	self.fields.Com_title:initData(i18n("common_text_2465"), handler(self, self.onClickClose), handler(self, self.btnHelpTip))
	self.text_choose_char_tip:setString(i18n("common_text_2337"))
	self.text_invite_help:setString(i18n("common_text_2338"))
	self.text_invite_tip:setString(i18n("common_text_2347"))
	self.text_invite_tip:setVisible(false)
	self.member:setVisible(false)
	self.btn_refresh:setTitle(i18n("common_text_911"))
	self.btn_invite:setTitle(i18n("common_text_189"))
	self.btn_beginEscort:setTitle(i18n("common_text_2340"))
	self.btn_openBuff:setTitle(i18n("common_text_2320"))
	self.btn_gold:setTitle(i18n("common_text_4402"))
	self.btn_gold:setCostNum(GOLD_CAR_COST)
	self.btn_invite:addClickEventListener(handler(self, self.btnInviteEvent))
	self.btn_refresh:addClickEventListener(handler(self, self.btnRefreshEvent))
	self.btn_gold:addClickEventListener(handler(self, self.btnGoldEvent))
	self.btn_beginEscort:addClickEventListener(handler(self, self.btnBeginEscort))
	self.btn_openBuff:addClickEventListener(handler(self, self.btnOpenBuff))
	self.carLv = 1
	self.refreshGold = 50
	self.escortDayMax = 0
	self.tabDecList, _ENV, self.isNeedRefreshGoldTip = self.btn_openBuff.addClickEventListener, self.btn_openBuff.addClickEventListener, true
	_ENV = handler(self, self.btnOpenBuff)
	handler(self, self.btnOpenBuff).lv = 1
	self.car1:initWithData(handler(self, self.btnOpenBuff))
	_ENV = handler(self, self.btnOpenBuff)
	handler(self, self.btnOpenBuff).lv = 2
	self.car2:initWithData(handler(self, self.btnOpenBuff))
	_ENV = handler(self, self.btnOpenBuff)
	handler(self, self.btnOpenBuff).lv = 3
	self.car3:initWithData(handler(self, self.btnOpenBuff))
	_ENV = handler(self, self.btnOpenBuff)
	handler(self, self.btnOpenBuff).lv = 4
	self.car4:initWithData(handler(self, self.btnOpenBuff))
	_ENV = handler(self, self.btnOpenBuff)
	handler(self, self.btnOpenBuff).lv = 5
	self.car5:initWithData(handler(self, self.btnOpenBuff))
	local nodeFormat = "biaoche01_yd_ws_%02d.png"
	local sp = display.newSprite("#biaoche01_yd_ws_01.png")
	sp:addTo(self.img_car)
	local frames = display.newFrames(nodeFormat, 1, 8)
	local animation = display.newAnimation(frames, 0.16666666666666666)
	sp:playAnimationForever(animation)
	self.sprite_baoche:setVisible(false)
	self:requestData()
end
function WorldEscortBeginViewPanel:onShow()
	print("=======WorldEscortBeginViewPanel:onShow")
end
function WorldEscortBeginViewPanel:initWithData(data)
	if not data then
		return
	end
	self.itemData = data
end
function WorldEscortBeginViewPanel:requestData()
	SoraDShowLoading(self)
	escortCartCtrl:reqCartData()
end
function WorldEscortBeginViewPanel:updateCarAddValue()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomLevelCtrl = gametop.playertop_:getModule("kingdomLevelCtrl")
	local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
	local ret = false
	local addValue = 0
	if allianceMgr:hasJoinAlliance() then
		local alliance = allianceMgr:getAlliance()
		if alliance then
			addValue = math.floor(alliance:getEscortAddValue() * 100)
		end
	end
	local buffData = worldKingdomLvDesRead.queryBuffData(kingdomLevelCtrl:getKingdomLevel())
	local gametop, escortBuff = kingdomLevelCtrl:getKingdomLevel()
	for i, v in ipairs(buffData) do
		if v.buffType == 119 then
			escortBuff = v
		end
	end
	if next(escortBuff) then
		addValue = addValue + math.floor(escortBuff.value / 10)
	end
	if 0 < addValue then
		local strAddValue = string.format("+%d%%", addValue)
		self.text_add:setString(strAddValue)
		ret = true
	end
	self.text_add:setVisible(ret)
end
function WorldEscortBeginViewPanel:showEscortMember(data)
	print("TOOD:获取数据 援助的成员")
	self.member:setVisible(true)
	self.member:initWithData(data)
	self.btn_invite:setVisible(false)
	self.text_invite_tip:setVisible(false)
	self.text_invite_help:setVisible(false)
end
function WorldEscortBeginViewPanel:hideEscortMember()
	if self.worldEscortMember then
		self.worldEscortMember:setVisible(false)
	end
end
function WorldEscortBeginViewPanel:btnInviteEvent(target, event)
	SoraDPlaySound()
	print("TODO: 邀请帮助")
	if escortCtrl:isReachEscortLimit() then
		SoraDShowMsgTip(i18n("common_text_2490"), "#icon_escort_convey.png")
		return
	end
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		_ENV = allianceMgr
		allianceMgr.msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
		allianceMgr.info = "from escort"
		SoraDSendMessage(allianceMgr)
		return
	end
	local selfUid = chatFunctions:getSelfId()
	print("自己的selfUid = ", selfUid)
	local panel = uiManager:show("LordSelectView").view
	panel:initData(lordSearchType.ALLIANCE, 5)
	panel:showOnline(true)
	panel:showOwnKingdom(true)
	panel:setFilterCityLv(12)
	panel:setStickOnline(true)
	panel:setHandle(function(data, dataCount)
		local uids = data
		dump(uids, "uids")
		SoraDShowLoading(self)
		local gametop = gModuleMgr.getObject("gametop")
		local escortAssistCtrl = gametop.playertop_:getModule("escortAssistCtrl")
		escortAssistCtrl:reqInviteAssist(uids)
	end)
end
function WorldEscortBeginViewPanel:btnRefreshEvent(target, event)
	SoraDPlaySound()
	if escortCtrl:isReachEscortLimit() then
		SoraDShowMsgTip(i18n("common_text_2490"), "#icon_escort_convey.png")
		return
	end
	if self.carLv >= MAX_CAR_LV then
		SoraDShowMsgTip(i18n("common_text_2342"), "#icon_escort_convey.png")
	elseif self.refreshGold > 0 and self.isNeedRefreshGoldTip then
		_ENV = "#icon_escort_convey.png"
		;("#icon_escort_convey.png").gold = self.refreshGold
		local strMsg = i18n("common_text_2466", "#icon_escort_convey.png")
		SoraDShowMsgBox(strMsg, i18n("common_text_054"), nil, handler(self, self.confirmCallBack))
	else
		self:confirmCallBack(MSGBOX_CALLBACK_YES)
	end
end
function WorldEscortBeginViewPanel:confirmCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		self.isNeedRefreshGoldTip = false
		local isEnough = SoraDEnoughGold(self.refreshGold)
		if isEnough then
			print("刷新 押运车辆")
			SoraDShowLoading(self)
			escortCartCtrl:reqCartRefresh()
		end
	end
end
function WorldEscortBeginViewPanel:btnGoldEvent(target, event)
	SoraDPlaySound()
	print("高级召唤====")
	if escortCtrl:isReachEscortLimit() then
		SoraDShowMsgTip(i18n("common_text_2490"), "#icon_escort_convey.png")
		return
	end
	if self.carLv >= MAX_CAR_LV then
		SoraDShowMsgTip(i18n("common_text_2343"), "#icon_escort_convey.png")
	else
		_ENV = nil
		;(nil).gold = GOLD_CAR_COST
		SoraDShowBuyBox(i18n("common_text_2467", nil), GOLD_CAR_COST, i18n("common_text_204"), handler(self, self.confirmGoldCallBack))
	end
end
function WorldEscortBeginViewPanel:confirmGoldCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		self.isNeedRefreshGoldTip = false
		local isEnough = SoraDEnoughGold(GOLD_CAR_COST)
		if isEnough then
			print("召唤最高级车辆")
			SoraDShowLoading(self)
			escortCartCtrl:reqCartAppoint()
		end
	end
end
function WorldEscortBeginViewPanel:btnBeginEscort(target, event)
	SoraDPlaySound()
	if escortCtrl:isReachEscortLimit() then
		SoraDShowMsgTip(i18n("common_text_2490"), "#icon_escort_convey.png")
		return
	end
	print("TODO:  开始押运==============================")
	if SoraDEnoughTroops() then
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		dispatchPanel:initData(self.itemData.dispatchData)
	end
end
function WorldEscortBeginViewPanel:btnHelpTip(target, event)
	SoraDPlaySound()
	print("TODO:  帮助FAQ跳转")
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ESCORT)
end
function WorldEscortBeginViewPanel:btnOpenBuff(target, event)
	SoraDPlaySound()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		uiManager:show("worldEscortOpenView")
	else
		_ENV = uiManager
		uiManager.msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
		uiManager.info = "from escort"
		SoraDSendMessage(uiManager)
	end
end
function WorldEscortBeginViewPanel:getCarNode(lv)
	if lv >= MIN_CAR_LV and lv <= MAX_CAR_LV then
		return self["car" .. lv]
	end
end
function WorldEscortBeginViewPanel:updateCar(lv)
	local escortDesRead = include("escortDesRead")
	_UPVALUE5_ = "escortDesRead"
	;("escortDesRead")[1] = self.car1
	;("escortDesRead")[2] = self.car2
	;("escortDesRead")[3] = self.car3
	;("escortDesRead")[4] = self.car4
	local ("escortDesRead")[5], carNodes = self.car5, "escortDesRead"
	for i, v in ipairs(carNodes) do
		v:doSelect(false)
	end
	local carNode = self:getCarNode(lv)
	if carNode then
		carNode:doSelect(true)
	end
	if lv < MAX_CAR_LV then
		self.car5:setCallEnable(true)
	else
		self.car5:setCallEnable(false)
	end
	self.sprite_baoche:setVisible(self.carLv > 1)
	if self.carLv > 1 then
		local ex_format = "biaoche0" .. self.carLv .. "_yd_ws_01.png"
		self.sprite_baoche:setURL(ex_format)
	end
end
function WorldEscortBeginViewPanel:updateEscortCount()
	local count = math.max(0, self.escortDayMax - escortCtrl.dataMgr:getEscortCount())
	_ENV = nil
	;(nil).count = count
	self.text_remain_time:setString(i18n("common_text_2336", nil))
end
function WorldEscortBeginViewPanel:updateRefreshGold()
	local refreshGold = escortCartCtrl:getRefreshGold()
	print(" refreshGold = ", refreshGold)
	self.refreshGold = refreshGold
	if self.refreshGold == 0 then
		self.btn_refresh:setCostNum(0)
	else
		self.btn_refresh:setCostNum(self.refreshGold)
	end
end
function WorldEscortBeginViewPanel:showWaitInvited(data)
	self.btn_invite:setVisible(false)
	self.text_invite_tip:setVisible(true)
	self.text_invite_help:setVisible(false)
	self.inviteMap = clone(data.data.inviteMap)
	self.invitName = ""
	local _ENV, names = clone(data.data.inviteMap), clone(data.data.inviteMap)
	for k, v in pairs(self.inviteMap) do
		table.insert(names, #names + 1, v.nickName)
	end
	self.invitName = table.concat(names, ",")
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function WorldEscortBeginViewPanel:hideWaitInvited()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.member:setVisible(false)
	self.btn_invite:setVisible(true)
	self.text_invite_tip:setVisible(false)
	self.text_invite_help:setVisible(true)
end
function WorldEscortBeginViewPanel:updateTime()
	local queue = self:getWaitInvitedQueue()
	if queue then
		local totalTime = queue.totaltime
		local remainTime = queue.timerNode.timer:getRemainTime()
		_ENV = nil
		;(nil).name = self.invitName
		;(nil).remainTime = remainTime
		self.text_invite_tip:setString(i18n("common_text_2347", nil))
	end
end
function WorldEscortBeginViewPanel:getWaitInvitedQueue()
	local queueType = gQueueTypeDef.escort_assist_invite_send
	local queue = queueCtrl:queryQueue(queueType)
	return queue
end
function WorldEscortBeginViewPanel:getWaitEscortQueue()
	local queueType = gQueueTypeDef.escort_assist_wait_self_escort
	local queue = queueCtrl:queryQueue(queueType)
	return queue
end
function WorldEscortBeginViewPanel:updateInvite()
	local bWaitInvitee = self:isWaitInvitee()
	local bWaitEscort = self:isWaitEscort()
	if bWaitInvitee and escortAssistCtrl.dataMgr:getInviteSendMap() ~= nil then
		escortAssistCtrl, escortAssistCtrl = escortAssistCtrl.dataMgr, escortAssistCtrl.dataMgr:getInviteSendMap()
		escortAssistCtrl.dataMgr:getInviteSendMap().data, escortAssistCtrl.dataMgr.inviteMap = escortAssistCtrl.dataMgr, escortAssistCtrl.dataMgr:getInviteSendMap()
		local data = escortAssistCtrl.dataMgr:getInviteSendMap()
		self:showWaitInvited(data)
	elseif bWaitEscort and escortAssistCtrl.dataMgr:getInviteSendMap() ~= nil then
		local invitee
		for k, v in pairs(escortAssistCtrl.dataMgr:getInviteSendMap()) do
			if v.queueInfo then
				invitee = v
			end
		end
		if invitee then
			escortAssistCtrl = pairs(escortAssistCtrl.dataMgr:getInviteSendMap())
			pairs(escortAssistCtrl.dataMgr:getInviteSendMap()).queueInfo = invitee.queueInfo
			self:showEscortMember(pairs(escortAssistCtrl.dataMgr:getInviteSendMap()))
		end
	end
end
function WorldEscortBeginViewPanel:isWaitInvitee()
	local isWait = false
	local queue = self:getWaitInvitedQueue()
	dump(queue, "等待别人同意", 10)
	if queue and queue.remainTime ~= 0 then
		isWait = true
	end
	print("iswait = ", isWait)
	return isWait
end
function WorldEscortBeginViewPanel:isWaitEscort()
	local isWait = false
	local queue = self:getWaitEscortQueue()
	if queue and queue.remainTime ~= 0 then
		isWait = true
	end
	return isWait
end
function WorldEscortBeginViewPanel:showNormalInvite()
	self.member:setVisible(false)
	self.text_invite_tip:setVisible(false)
	self.btn_invite:setVisible(true)
	self.text_invite_help:setVisible(true)
end
function WorldEscortBeginViewPanel:msgShowLoading(target, data)
	SoraDShowLoading(self)
end
function WorldEscortBeginViewPanel:msgCloseLoading(target, data)
	SoraDCloseLoading(self)
end
function WorldEscortBeginViewPanel:msgAllianceMemberSelected(target, data)
	print("")
end
function WorldEscortBeginViewPanel:sMsgCarDataBack(target, data)
	print("镖车数据回来了-----------------------xxxxxxx")
	dump(data, "镖车", 10)
	SoraDCloseLoading(self)
	local escortData = data.data
	self.escortDayMax = escortData.escortDayMax
	local carLv = escortCartCtrl.cartMgr:getCurrCartLv()
	self.carLv = carLv
	self:updateCar(self.carLv)
	print("carLv  = ", carLv)
	self:updateCarAddValue()
	self:updateRefreshGold()
	self:updateEscortCount()
	self:updateInvite()
end
function WorldEscortBeginViewPanel:sMsgCarAppointSuccess(target, data)
	print("车辆召唤成功 ----------------------")
	SoraDCloseLoading(self)
	local carLv = escortCartCtrl.cartMgr:getCurrCartLv()
	print("carLv  = ", carLv)
	self.carLv = carLv
	self:updateCar(self.carLv)
	self:showCarEffect()
	self:updateRefreshGold()
end
function WorldEscortBeginViewPanel:sMsgCarRefreshSuccess(target, data)
	print("车辆刷新成功----------------------")
	SoraDCloseLoading(self)
	local carLv = escortCartCtrl.cartMgr:getCurrCartLv()
	print("carLv  = ", carLv)
	self.carLv = carLv
	self:updateCar(self.carLv)
	self:showCarEffect()
	self:updateRefreshGold()
end
function WorldEscortBeginViewPanel:showCarEffect()
	local quality = self.carLv
	local upIndex = quality + 5
	if quality < gQualityDef.GREEN or quality > gQualityDef.GOLD then
		return
	end
	local et_node = self:getChildByName("et_node_car_" .. quality)
	if et_node then
		SoraDResetEffectNode(et_node)
	else
		_ENV, _ENV = et_node, SoraDResetEffectNode
		et_node.plist = "et_escort_carriage_0" .. quality .. ".plist"
		_ENV, et_node.scale = "et_escort_carriage_0" .. quality .. ".plist", 1.8
		;("et_escort_carriage_0" .. quality .. ".plist").x = self.img_car:getContentSize().width / 2
		_ENV, SoraDResetEffectNode[1], et_node.pos, ("et_escort_carriage_0" .. quality .. ".plist").y = et_node, et_node, "et_escort_carriage_0" .. quality .. ".plist", 50
		et_node.plist = "et_escort_carriage_0" .. upIndex .. ".plist"
		_ENV, et_node.scale = "et_escort_carriage_0" .. upIndex .. ".plist", 1.3
		;("et_escort_carriage_0" .. upIndex .. ".plist").x = self.img_car:getContentSize().width / 2
		SoraDResetEffectNode[2], et_node.pos, ("et_escort_carriage_0" .. upIndex .. ".plist").y = et_node, "et_escort_carriage_0" .. upIndex .. ".plist", self.img_car:getContentSize().height / 2
		local param = SoraDResetEffectNode
		local et_node = SoraDCreateEffectNode(param)
		et_node:setName("et_node_car_" .. quality)
		et_node:addTo(self.img_car, -1)
	end
end
function WorldEscortBeginViewPanel:sMsgInviteSuccess(target, data)
	SoraDCloseLoading(self)
	self:showWaitInvited(data)
end
function WorldEscortBeginViewPanel:sMsgInviteFailed(target, data)
	SoraDCloseLoading(self)
	local err = data.err
	if err == gErrDef.Err_ESCORT_OTHER_IN_ASSIST then
		SoraDShowMsgTip(i18n("common_text_2492"), "#icon_escort_convey.png")
	elseif err == gErrDef.Err_ESCORT_OTHER_REACH_ASSIST_LIMIT then
		SoraDShowMsgTip(i18n("common_text_2493"), "#icon_escort_convey.png")
	elseif err == gErrDef.Err_ESCORT_OTHER_CITYLEVEL_LIMIT then
		SoraDShowMsgTip(i18n("common_text_2495"), "#icon_escort_convey.png")
	elseif err == gErrDef.Err_ALLIANCE_NOT_IN_SAME_ALLIANCE then
		SoraDShowMsgTip(i18n("notice_0026"), "#icon_escort_convey.png")
	elseif err == gErrDef.Err_ESCORT_SELF_REACH_ESCORT_LIMIT then
		SoraDShowMsgTip(i18n("common_text_2490"), "#icon_escort_convey.png")
	elseif err == gErrDef.Err_ESCORT_NO_ONE_BEING_INVITED then
		SoraDShowMsgTip(i18n("common_text_3448"), "#icon_escort_convey.png")
	else
		SoraDShowMsgTip("invite error: code= " .. err, "#icon_escort_convey.png")
	end
end
function WorldEscortBeginViewPanel:sMsgSendInviteTimeOut(target, data)
	print("邀请别人倒计时结束，开始重置界面-------------------------")
	self:hideWaitInvited()
	self:updateInvite()
end
function WorldEscortBeginViewPanel:sMsgAssistInviteAccepted(target, data)
	self:showEscortMember(data)
end
function WorldEscortBeginViewPanel:sMsgAssistInviteRected(target, data)
	local inviteMap = escortAssistCtrl:getInviteSendMap()
	dump(inviteMap, "escortAssistCtrl:getInviteSendMap()", 10)
	if inviteMap == nil or next(inviteMap) == nil then
		self:hideWaitInvited()
	else
		escortAssistCtrl, escortAssistCtrl = 10, "escortAssistCtrl:getInviteSendMap()"
		;("escortAssistCtrl:getInviteSendMap()").data, (10).inviteMap = 10, inviteMap
		self:showWaitInvited("escortAssistCtrl:getInviteSendMap()")
	end
end
function WorldEscortBeginViewPanel:sMsgSelfEscortTimeOut(target, data)
	self:hideEscortMember()
	self:showNormalInvite()
end
function WorldEscortBeginViewPanel:sMsgReqCarDataFailed(target, data)
	SoraDCloseLoading(self)
	local err = data.err
	if err == gErrDef.Err_ESCORT_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"), "#icon_escort_convey.png")
	end
end
function WorldEscortBeginViewPanel:endShow()
	print("进入界面判断是否需要引导")
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	local isMoudleDone = guideCtrl:isGuideNotCompleted(gGuideModule.ESCORT)
	local step = guideCtrl:isStep(gGuideStep.ESCORT_STEP_2)
	print(isMoudleDone, step)
	if isMoudleDone and step then
		local View = include("gameGuideView").new()
		View:show()
		print("worldEscortBeginView", SoraDCurrentSceneShowView("worldMapView"))
		View:startGuideWithStep(67002)
		guideCtrl:CompleteGuideStep(67002)
	end
end
function WorldEscortBeginViewPanel:gameGuide_getTarget(itemName, parameters)
	return self.fields[itemName]
end
return WorldEscortBeginViewPanel
