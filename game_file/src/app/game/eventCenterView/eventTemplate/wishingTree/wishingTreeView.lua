local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local wishingTreeRead = include("wishingTreeRead")
local constantRead = include("constantRead")
local wishingTreeCtrl = SoraDGetCtrl("wishingTreeCtrl")
local wishingTreeView = class("wishingTreeView", function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end)
_ENV = "wishingTreeView"
;("wishingTreeView").Rebate = 0
;("wishingTreeView").WishingDay = 1
local _ENV, _UPVALUE7_, ("wishingTreeView").Explosion, sessionType = nil, function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end, 2, "wishingTreeView"
;(nil).x = -199.6
_ENV, (nil).y = nil, -405.63
;(nil).x = -117.65
_ENV, (nil).y = nil, -337.86
;(nil).x = -2.43
_ENV, (nil).y = nil, -243.67
;(nil).x = 40.13
_ENV, (nil).y = nil, -363.45
;(nil).x = 123.62
_ENV, (nil).y = nil, -270.18
;(nil).x = 209.9
_ENV, (nil).y = nil, -389.96
;(nil).x = 234.79
;(nil).y = -205.53
;(function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end)[1] = nil
;(function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end)[2] = nil
;(function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end)[3] = nil
;(function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end)[4] = nil
;(function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end)[5] = nil
;(function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end)[6] = nil
local (function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end)[7], packetPos = nil, function(target)
	return target and target or SoraDCreateBasePanel("wishingTreeView")
end
function wishingTreeView:ctor()
	self.packetList, _ENV = nil, nil
	self.activityId = gActivityTimeActivityID.WISH_TREE_ACTIVITY
	self.group = activityShowCtrl:getParamByID(gActivityTimeActivityID.WISH_TREE_ACTIVITY).classtype or 1
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.activityTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.activityTitle:setTitle(i18n("activity_name_9001198"))
	self.activityTitle:setBtnHelpClickCallBack(handler(self, self.btnClickHelp))
	self.scrollFitView = SoraDGetChildByName(self, "Size_ScrollView_FitView")
	self.scrollTask = SoraDGetChildByName(self, "Size_ScrollView_Task")
	self.scrollTask = include("commonAutoScrollList").new(self.scrollTask)
	self.taskSingle = SoraDGetChildByName(self, "node_cell")
	self.scrollTask:setSingleCreate(handler(self, self.createTaskSingle))
	self.topTaskNode = SoraDGetChildByName(self, "Top_Node_Task")
	self.textTaskReset = SoraDGetChildByName(self.topTaskNode, "Text_TaskReset")
	self.topNode = SoraDGetChildByName(self.scrollFitView, "Top_Node")
	self.topImageBg = SoraDGetChildByName(self.scrollFitView, "Top_Image_Bg")
	self.topImageBg:ignoreContentAdaptWithSize(true)
	self.topImageBg:loadTexture("bg_xys_dyj_dbj.png", ccui.TextureResType.plistType)
	self.bottomNode = SoraDGetChildByName(self.scrollFitView, "Node_Bottom")
	self.btnBox = SoraDGetChildByName(self.bottomNode, "Button_Box")
	self.btnBox:addTouchEventListener(handler(self, self.btnClickBox))
	self.textGoldExplo = SoraDGetChildByName(self.btnBox, "Text_GodExplosion")
	self.textGoldExplo:setString(i18n("wish_text_02"))
	self.nodeGetTime = SoraDGetChildByName(self.bottomNode, "Node_GetTime")
	self.textGetLeftTime = SoraDGetChildByName(self.nodeGetTime, "Text_GetLeftTime")
	self.textGetLeftTime = SoraDCreateTimerLabel(self, self.textGetLeftTime)
	self.textGetLeftTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n_html("common_text_3722", nil)
	end)
	self.btnGetGold = SoraDGetChildByName(self, "Button_1")
	self.btnGetGold:addTouchEventListener(handler(self, self.btnClickGetGold))
	self.btnGetGold:setTitleText(i18n("common_text_1146"))
	self.sessionNode_1 = SoraDGetChildByName(self.topNode, "Node_SessionOne")
	self.sessionNode_2 = SoraDGetChildByName(self.topNode, "Node_SessionTwo")
	self.goldUpNode = SoraDGetChildByName(self.topNode, "Node_GoldUp")
	self.textGolUpTips = SoraDGetChildByName(self.goldUpNode, "Text_GoldUpTips")
	self.btnGoldUp = SoraDGetChildByName(self.goldUpNode, "Button_GoldUp")
	self.btnGoldUp:addTouchEventListener(handler(self, self.btnClickOpenGoldUp))
	self.packetSingle = SoraDGetChildByName(self.sessionNode_1, "Node_Packet")
	self.packetSingle:setVisible(false)
	self.timeNode = SoraDGetChildByName(self.topNode, "Node_rTime")
	self.activityDay = SoraDGetChildByName(self.timeNode, "Text_remainDay")
	self.activityTime = SoraDGetChildByName(self.timeNode, "Text_remainTime")
	self.activityTime = SoraDChangeTextToHtml(self.activityTime)
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.textGoldUsed = SoraDGetChildByName(self.timeNode, "Text_GoldUse")
	self.textGoldUsed = SoraDChangeTextToHtml(self.textGoldUsed)
	self.imageFont_1 = SoraDGetChildByName(self.sessionNode_1, "Image_Tips")
	self.imageFont_1:ignoreContentAdaptWithSize(true)
	self.textTips = SoraDGetChildByName(self.sessionNode_1, "Text_Tips")
	self.bmfNumer = SoraDGetChildByName(self.bottomNode, "BMF_Number")
	self.imageFont_2 = SoraDGetChildByName(self.sessionNode_2, "Image_Title")
	self.imageFont_2:ignoreContentAdaptWithSize(true)
	self.textNowDay = SoraDGetChildByName(self.sessionNode_2, "Text_FromDay")
	self.textExplain = SoraDGetChildByName(self.sessionNode_2, "Text_Explain")
	self.animationNode = SoraDGetChildByName(self, "Animation_wishExplosionEffect")
	self.animationSessionOneUp = SoraDGetChildByName(self, "Animation_SessionOne")
	self.animationSessionOneDown = SoraDGetChildByName(self, "Animation_SessionOneDown")
	self.animationSessionOneDown:setPositionY(570)
	self.animationUpBox = SoraDGetChildByName(self, "AnimationGold")
	self.animationCamel_1 = SoraDGetChildByName(self, "Animation_Camel_1")
	self.animationCamel_2 = SoraDGetChildByName(self, "Animation_Camel_2")
	self.btnTab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	_ENV = "Top_CCS_commonTabBtn"
	;("Top_CCS_commonTabBtn").tabNum = 2
	_ENV, _ENV, ("Top_CCS_commonTabBtn").defaultClick = handler(self, self.btnClickOpenGoldUp)
	handler(self, self.btnClickOpenGoldUp).title = i18n("activity_name_9001198")
	handler(self, self.btnClickOpenGoldUp).handle = handler(self, self.btnClickTab)
	handler(self, self.btnClickOpenGoldUp).fontSize = 22
	_ENV, handler(self, self.btnClickOpenGoldUp)[1], handler(self, self.btnClickOpenGoldUp).tag = handler(self, self.btnClickOpenGoldUp)
	handler(self, self.btnClickOpenGoldUp).title = i18n("wish_title_01")
	handler(self, self.btnClickOpenGoldUp).handle = handler(self, self.btnClickTab)
	handler(self, self.btnClickOpenGoldUp).fontSize = 22
	;("Top_CCS_commonTabBtn").tabsetArray, handler(self, self.btnClickOpenGoldUp)[2], handler(self, self.btnClickOpenGoldUp).tag = handler(self, self.btnClickOpenGoldUp)
	self.btnTab:initView("Top_CCS_commonTabBtn")
	self.textTaskReset:setString(i18n("task_text_02"))
	self:initViewAndCreateAction()
	_ENV = i18n("task_text_02")
	i18n("task_text_02").activityID = self.activityId
	self:initScrollTask(self, i18n("task_text_02"))
	SoraDShowLoading(self)
	activityTaskComponentCtrl:sendReqInit()
end
function wishingTreeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.updataInfoData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initScrollTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initScrollTask))
end
function wishingTreeView:initViewAndCreateAction()
	if self:getPanelOffsetHeight() < 1136 then
		self.scrollFitView:setInnerContainerSize(cc.size(640, 987))
	elseif self:getPanelOffsetHeight() > 1200 then
		self.topImageBg:loadTexture("bg_xys_dyj_dbj_2.png", ccui.TextureResType.plistType)
		self.topImageBg:setContentSize(cc.size(640, 1237))
		self.animationSessionOneDown:setPositionY(996)
	end
	self:updataActivityStage()
	self.camelAction = sp.SkeletonAnimation:create("spine/xuyuanshu.skel", "spine/xuyuanshu.atlas", 1)
	self.camelAction:setPosition(0, 0)
	SoraDGetChildByName(self.bottomNode, "Node_Animation"):addChild(self.camelAction)
	self.camelAction:setAnimation(0, "animation", true)
	self.leafAction = sp.SkeletonAnimation:create("spine/xuyuanshu_02.skel", "spine/xuyuanshu_02.atlas", 1)
	self.leafAction:setPosition(0, -430)
	self.topNode:addChild(self.leafAction)
	self.leafAction:setAnimation(0, "animation", true)
	self.leafAction:setLocalZOrder(1)
	self.timeNode:setLocalZOrder(2)
	self.treeAction = sp.SkeletonAnimation:create("spine/xuyuanshu_01.skel", "spine/xuyuanshu_01.atlas", 1)
	self.treeAction:setPosition(0, 0)
	SoraDGetChildByName(self.sessionNode_1, "Node_Animation"):addChild(self.treeAction)
	self.treeAction:setAnimation(0, "animation", true)
	SoraDGetChildByName(self.sessionNode_1, "Node_Animation"):setRotation3D(cc.vec3(0, SoraDFIsRA() and 180 or 0, 0))
	self.branchActionUp = sp.SkeletonAnimation:create("spine/xuyuanshu_03_01.skel", "spine/xuyuanshu_03_01.atlas", 1)
	self.branchActionUp:setPosition(0, -130)
	self.sessionNode_2:addChild(self.branchActionUp)
	self.branchActionUp:setAnimation(0, "animation", true)
	self.branchActionDown = sp.SkeletonAnimation:create("spine/xuyuanshu_03_02.skel", "spine/xuyuanshu_03_02.atlas", 1)
	self.branchActionDown:setPosition(0, -480)
	self.sessionNode_2:addChild(self.branchActionDown)
	self.branchActionDown:setAnimation(0, "animation", true)
	self.animationNode = SoraDCreatAnimation("wishExplosionEffect", self.animationNode, true)
	SoraDMixtureGLONEByParent(self.animationNode)
	self.animationCamel_1 = SoraDCreatAnimation("wishCamelEffect_1", self.animationCamel_1, true)
	SoraDMixtureGLONEByParent(self.animationCamel_1)
	self.animationSessionOneUp = SoraDCreatAnimation("wishingTreeEffectUp", self.animationSessionOneUp, true)
	SoraDMixtureGLONEByParent(self.animationSessionOneUp)
	self.animationCamel_2 = SoraDCreatAnimation("wishCamelEffect_2", self.animationCamel_2, true)
	SoraDMixtureGLONEByParent(self.animationCamel_2)
	self.animationSessionOneDown = SoraDCreatAnimation("wishingTreeEffectDown", self.animationSessionOneDown, true)
	SoraDGetChildByName(self, "G_Particle_2"):setAutoCull(false)
	SoraDMixtureGLONEByParent(self.animationSessionOneDown)
	self.animationUpBox = SoraDCreatAnimationEx("wishUpBoxEffect", self.animationUpBox, false)
	SoraDMixtureGLONEByParent(self.animationUpBox)
	self.animationUpBox:setVisible(false)
end
function wishingTreeView:initScrollTask(target, data)
	if data.activityID == self.activityId then
		SoraDCloseLoading(self)
		local serverData = activityTaskComponentCtrl:getQuestData(self.activityId)
		self.taskInfoData = eventQuestRead.getSortList(self.activityId, serverData)
		_ENV = nil
		;(nil).scroll = self.scrollTask
		;(nil).view = self
		;(nil).activityID = self.activityId
		self.scrollTask:updateScrollView(cc.size(640, 150), self.taskInfoData, 1, nil)
		local state, totalNum, pageOneNum = wishingTreeCtrl:getReceiveStatusAndNum(self.activityId)
		self.btnTab:setBigRedPointCount(2, totalNum - pageOneNum)
		self.btnTab:setBigRedPointCount(1, pageOneNum)
	end
end
function wishingTreeView:createTaskSingle()
	local single = self.taskSingle:clone()
	single = include("wishingTaskSingleView").new(single)
	return single
end
function wishingTreeView:updataActivityStage()
	local stageInfo = activityShowCtrl:getShowDataByID(self.activityId)
	self.sessionType = stageInfo and stageInfo.doStage or sessionType.Rebate
	self.animationNode:setVisible(self.sessionType == sessionType.Explosion)
	self.animationCamel_1:setVisible(self.sessionType == sessionType.Explosion)
	self.animationSessionOneUp:setVisible(self.sessionType ~= sessionType.Explosion)
	self.animationCamel_2:setVisible(self.sessionType ~= sessionType.Explosion)
	self.animationSessionOneDown:setVisible(self.sessionType ~= sessionType.Explosion)
	self.sessionNode_1:setVisible(self.sessionType ~= sessionType.Explosion)
	self.sessionNode_2:setVisible(self.sessionType == sessionType.Explosion)
	self.btnBox:setVisible(self.sessionType ~= sessionType.Explosion)
	self.btnGetGold:setVisible(self.sessionType ~= sessionType.Rebate)
	self.btnBox:setBright(self.sessionType == sessionType.WishingDay)
	self.goldUpNode:setVisible(self.sessionType == sessionType.Explosion)
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityId)
	self.activityTime:setTimeLast(function(ticket)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, ticket
		_ENV, (nil).time, (nil).color = nil, nil, "#ffffff"
		;(nil).__default, (nil).color = nil, "#5AA30D"
		return i18n_html("common_text_766", nil, nil)
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
		dump(self.eventTime, "eventTime", 20)
		self.activityDay:setString(os.date("%Y.%m.%d", activityShowCtrl:getBeginTimeSecond(self.activityId)) .. "-" .. os.date("%Y.%m.%d", activityShowCtrl:getEndTimeSecond(self.activityId)))
	end
end
function wishingTreeView:updataInfoData(target, data)
	SoraDCloseLoading(self)
	if data.activityID == self.activityId then
		if data.initData then
			self.infoData = data.initData
		elseif data.updateData then
			if self.infoData == nil then
				return
			end
			for key, value in pairs(data.updateData) do
				if key == "buyList" and next(value) then
					self.animationUpBox:setVisible(true)
					self.animationUpBox.action:gotoFrameAndPlay(0, false)
				end
				self.infoData[key] = value
			end
		end
		self.consumeGold = self.infoData.consumeGold or 0
		self.stageNow = wishingTreeRead.getNowStage(self.group, self.consumeGold)
		if not self.infoData.buyList then
			_ENV = self.infoData.buyList
		end
		self.isPrivilege = next(self.infoData.buyList) and true or false
		self.wishRewardFlag = self.infoData.wishRewardFlag
		self.exGoldRewardTime = self.infoData.exGoldRewardTime
		dump(self.infoData, "self.infoData", 10)
		self:refreshView()
	end
end
function wishingTreeView:refreshView()
	if self.consumeGold == nil then
		return
	end
	_ENV = nil
	_ENV, _ENV, (nil).num = self.consumeGold, string.formatnumberthousands(self.consumeGold), string.formatnumberthousands(self.consumeGold)
	_ENV, string.formatnumberthousands(self.consumeGold).num, self.consumeGold.color = self.consumeGold, self.consumeGold, "#ffffff"
	string.formatnumberthousands(self.consumeGold).__default, self.consumeGold.color = self.consumeGold, "#ffdf4b"
	_ENV = nil
	;(nil).param = "#icon_main_gold.png"
	;(nil).name = "image_Gold"
	;(nil).width = 42
	;(nil).height = 42
	;(nil).custom = "Sprite"
	;(nil).offsety = 21
	local strGoldUse = i18n_html("wish_text_07", nil, (string.formatnumberthousands(self.consumeGold))) .. SoraDWrapReplaceTag(nil)
	self.textGoldUsed:setString(strGoldUse)
	local lang = SoraDGetDefaultLanguage()
	if lang ~= "ar" and lang ~= "en" and lang ~= "ko" then
		lang = "en"
	end
	self.imageFont_1:loadTexture("font_wishing_lucky_" .. lang .. ".png", ccui.TextureResType.plistType)
	_ENV = ".png"
	;(".png").time = os.date("%Y.%m.%d", activityShowCtrl:getEndTimeSession(self.activityId, 1))
	;(".png").num = string.formatnumberthousands(constantRead.getConstValue("WISHING_TREE_MAX_REBATE_GOLD") or 0)
	self.textTips:setString(i18n("wish_text_08", ".png"))
	self.btnGoldUp:setTouchEnabled(not self.isPrivilege)
	self.textGolUpTips:setString(i18n(self.isPrivilege and "wish_text_20" or "wish_text_19"))
	if self.sessionType == sessionType.Rebate then
		self:initPacket()
		local goldCanGet = math.floor(self.consumeGold * 0.1)
		self.bmfNumer:setString(100000 < goldCanGet and 100000 or goldCanGet)
		self.textGetLeftTime:beginTime(self.eventTime and self.eventTime.timerNode.timer:getRemainTime() or 1)
	elseif self.sessionType == sessionType.WishingDay then
		self:hideBtnTab()
		if self.wishRewardFlag then
			self.goldUpNode:setVisible(true)
			self.nodeGetTime:setVisible(true)
			self.textGetLeftTime:beginTime(self.eventTime and self.eventTime.timerNode.timer:getRemainTime() or 1)
			self.btnGetGold:setVisible(false)
			self.btnBox:setVisible(false)
			self.sessionNode_1:setVisible(false)
			self.sessionNode_2:setVisible(true)
			self.animationNode:setVisible(true)
			self.animationCamel_1:setVisible(true)
			self.animationSessionOneUp:setVisible(false)
			self.animationCamel_2:setVisible(false)
			self.animationSessionOneDown:setVisible(false)
			self.imageFont_2:loadTexture("fong_wishing_coinbroke_" .. lang .. ".png", ccui.TextureResType.plistType)
			self.textNowDay:setString(i18n("wish_text_16"))
			local numGoldCanGet = wishingTreeRead.getStageCoin(self.group, self.stageNow, self.isPrivilege)
			if numGoldCanGet == 0 then
				self.textExplain:setString(i18n("wish_text_22"))
			else
				_ENV = i18n("wish_text_22")
				i18n("wish_text_22").num = string.formatnumberthousands(numGoldCanGet)
				i18n("wish_text_22").num1 = string.formatnumberthousands(numGoldCanGet * 5)
				self.textExplain:setString(i18n("wish_text_14", i18n("wish_text_22")))
			end
			self.bmfNumer:setString(goldCanGet)
		else
			self:initPacket()
			local goldCanGet = math.floor(self.consumeGold * 0.1)
			self.bmfNumer:setString(100000 < goldCanGet and 100000 or goldCanGet)
			self.btnGetGold:setBright(goldCanGet ~= 0)
			self.btnGetGold:setTouchEnabled(goldCanGet ~= 0)
			self.nodeGetTime:setVisible(false)
		end
	else
		self:hideBtnTab()
		local nowDay, leftTimeCanGetNext = self:calculateDay()
		self.imageFont_2:loadTexture("fong_wishing_coinbroke_" .. lang .. ".png", ccui.TextureResType.plistType)
		_ENV = ".png"
		;(".png").num = nowDay
		self.textNowDay:setString(i18n("wish_text_15", ".png"))
		local numGoldCanGet = wishingTreeRead.getStageCoin(self.group, self.stageNow, self.isPrivilege)
		self.textGetLeftTime:beginTime(leftTimeCanGetNext)
		self.bmfNumer:setString(numGoldCanGet)
		_ENV = i18n("wish_text_15", ".png")
		i18n("wish_text_15", ".png").num = string.formatnumberthousands(numGoldCanGet)
		i18n("wish_text_15", ".png").num1 = string.formatnumberthousands(numGoldCanGet * 5)
		self.textExplain:setString(i18n("wish_text_14", i18n("wish_text_15", ".png")))
		local isGetAwardToday = serviceFunctions.isSameDay(self.exGoldRewardTime, serviceFunctions.systemTime())
		self.btnGetGold:setBright(not isGetAwardToday)
		self.btnGetGold:setTouchEnabled(not isGetAwardToday)
		self.nodeGetTime:setVisible(isGetAwardToday)
	end
	self.topNode:setPositionY(self.scrollFitView:getInnerContainerSize().height + 3)
	self.topImageBg:setPositionY(self.scrollFitView:getInnerContainerSize().height + 3)
	local stateOne, pageOneNum = activityTaskComponentCtrl:getWishTreeRedPointAndNum(0)
	self.btnTab:setBigRedPointCount(1, pageOneNum)
end
function wishingTreeView:initPacket()
	local packetInfo = wishingTreeRead.getTaskInfo(self.group)
	for key, value in ipairs(packetInfo) do
		local single = self.packetList[key] or self.packetSingle:clone()
		if not self.packetList[key] then
			single:addTo(self.sessionNode_1)
			single:setPosition((SoraDFIsRA() and -1 or 1) * packetPos[key].x, packetPos[key].y)
			single:setVisible(true)
		end
		value.consumeGold = self.consumeGold or 0
		value.status = self.infoData and self.infoData.stageReward and self.infoData.stageReward[tostring(key)]
		self:initPacketSingleData(single, value)
		self.packetList[key] = single
	end
end
function wishingTreeView:initPacketSingleData(parent, info)
	local iconPacket = SoraDGetChildByName(parent, "icon_redpacket")
	local button = SoraDGetChildByName(parent, "Button_Packet")
	local textNum = SoraDGetChildByName(parent, "Text_Target")
	local effctLight = SoraDGetChildByName(parent, "G_Light")
	button:addTouchEventListener(handlerEx(self, self.btnClickPacket, info))
	SoraDMixtureGLONE(effctLight)
	textNum:setString(string.formatnumberthousands(info.num))
	if info.status then
		effctLight:setVisible(false)
		iconPacket:getVirtualRenderer():setState(1)
	else
		iconPacket:getVirtualRenderer():setState(0)
		if info.consumeGold >= info.num then
			effctLight:setVisible(true)
			local normal = math.random(32, 40) * 0.01
			local normalSpeed = math.random(76, 100) * 0.01
			effctLight:setOpacity(255 * normal)
			_UPVALUE1_ = 255 * normal
			;(255 * normal)[1] = cca.fadeTo(normalSpeed, math.random(84, 92) * 0.01)
			;(255 * normal)[2] = cca.fadeTo(normalSpeed, normal)
			;(255 * normal)[3] = cca.fadeTo(normalSpeed, normal)
			;(255 * normal)[4] = cca.fadeTo(normalSpeed, normal)
			;(255 * normal)[5] = cca.fadeTo(normalSpeed, normal)
			local action = cca.repeatForever(cca.seq(255 * normal))
			effctLight:runAction(action)
		else
			effctLight:setVisible(false)
		end
	end
end
function wishingTreeView:btnClickTab(tag, name)
	self.scrollTask:setVisible(tag ~= 1)
	self.topTaskNode:setVisible(tag ~= 1)
	self.scrollFitView:setVisible(tag == 1)
end
function wishingTreeView:btnClickBox(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("wishExplosionPopView")
		_ENV = nil
		;(nil).stage = self.stageNow
		;(nil).consumeGold = self.consumeGold
		;(nil).isPrivilege = false
		;(nil).sessionType = self.sessionType
		panel:initData(nil)
		panel:show()
	end
end
function wishingTreeView:btnClickGetGold(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.sessionType == sessionType.Rebate then
		elseif self.sessionType == sessionType.WishingDay then
			if self.wishRewardFlag then
			else
				SoraDShowLoading(self)
				activityTaskComponentCtrl:sendReqGetWishReward()
			end
		elseif serviceFunctions.isSameDay(self.exGoldRewardTime, serviceFunctions.systemTime()) then
		else
			activityTaskComponentCtrl:sendReqGetExplosiveReward(data)
		end
	end
end
function wishingTreeView:btnClickHelp(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("wish_text_21"))
	end
end
function wishingTreeView:btnClickPacket(info, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("wishSessionAwardView")
		panel:initData(info)
		panel:show()
	end
end
function wishingTreeView:btnClickOpenGoldUp(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isPrivilege then
			SoraDShowMsgTip(i18n("wish_text_20"))
		else
			local panel = SoraDCreatePanel("wishingUpPopView")
			local numGoldCanGet = wishingTreeRead.getStageCoin(self.group, self.stageNow, true)
			local nowDay, leftTimeCanGetNext = self:calculateDay()
			local isGetAwardToday = serviceFunctions.isSameDay(self.exGoldRewardTime, serviceFunctions.systemTime())
			local leftDay = isGetAwardToday and 5 - nowDay or 6 - nowDay
			panel:initData(numGoldCanGet * leftDay)
			panel:show()
		end
	end
end
function wishingTreeView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityId) then
		self:removeFromParent()
	else
		self:updataActivityStage()
		if self.sessionType == sessionType.Explosion and wishingTreeRead.getNowStage(self.group, self.consumeGold or 0) < 1 then
			SoraDRemoveAllAfterPanelFromManager(self)
		else
			self:refreshView()
		end
	end
end
function wishingTreeView:hideBtnTab()
	self.btnTab:setVisible(false)
	self.btnTab:clickByIndex(1)
	self.scrollFitView:setContentSize(cc.size(640, self:getPanelOffsetHeight() - 74))
end
function wishingTreeView:calculateDay()
	local beginTime = self.eventTime and self.eventTime.starttime or serviceFunctions.systemTime()
	local beginDayZeroTime = serviceFunctions.getTodayZeroHourUTC(beginTime)
	local todayZeroTime = serviceFunctions.getTodayZeroHourUTC()
	local passDay = (todayZeroTime - beginDayZeroTime) / 86400
	print("···", beginTime, beginDayZeroTime, todayZeroTime, passDay)
	return passDay + 1, serviceFunctions.getTodayRemainTime()
end
return wishingTreeView
