local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicBattleDef = include("epicBattleDef")
local worldMapDefine = include("worldMapDefine")
local epicWarltCtrl = include("epicWarltCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local epicWarMapView = class("epicWarMapView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarMapView")
	end
	return target
end)
function epicWarMapView:ctor()
	epicBattleDef.STRATEGYMODE = 0
	self.cloneSingles, epicBattleDef, self.areaInstanceArray, epicBattleDef, self.debugDetail, epicBattleDef, epicBattleDef.STRATEGYIDX = nil, nil, nil, nil, nil, nil, nil
	self.strategyIdx = 1
	self.useModel = false
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.windowTitle:setTitle(i18n("epicbattle_title_01"))
	self.windowTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Button_over = SoraDGetChildByName(self, "Button_over")
	self.Text_quit = SoraDGetChildByName(self, "Text_quit")
	self.Text_quit:setString(i18n("epic_war_endChallenge_btn"))
	self.Button_over:addTouchEventListener(handler(self, self.btnOverClick))
	self.nodeAction = SoraDGetExtendChildFromCCSByName(self, "CCS_epicBattleActionNode_action")
	self.nodeAction:openSwitch()
	self.Text_area = SoraDGetChildByName(self, "Text_area")
	self.LoadingBar_bar = SoraDGetChildByName(self, "LoadingBar_bar")
	self.LoadingBar_bar_act = SoraDGetChildByName(self, "LoadingBar_bar_act")
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
	self.Button_army = SoraDGetChildByName(self, "Button_army")
	self.Button_army:addTouchEventListener(handler(self, self.btnArmyDetailClick))
	self.Node_etCure = SoraDGetChildByName(self, "Node_etCure")
	self.Button_detail = SoraDGetChildByName(self, "Button_detail")
	self.Button_detail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.Node_buff = SoraDGetChildByName(self, "Node_buff")
	self.Button_buff = SoraDGetChildByName(self, "Button_buff")
	self.icon_red = SoraDGetChildByName(self, "icon_red")
	self.icon_red:setVisible(false)
	self.Text_bNum = SoraDGetChildByName(self, "Text_bNum")
	self.Button_buff:addTouchEventListener(handler(self, self.btnBuffClick))
	self.Button_silver = SoraDGetChildByName(self, "Button_silver")
	self.Button_silver:addTouchEventListener(handler(self, self.btnSilverClick))
	self.Node_boss = SoraDGetChildByName(self, "Node_boss")
	self.Button_boss = SoraDGetChildByName(self, "Button_boss")
	self.Button_boss:addTouchEventListener(handler(self, self.btnBossClick))
	self.boss_icon = SoraDGetChildByName(self, "boss_icon")
	self.Node_etDone = SoraDGetChildByName(self, "Node_etDone")
	self.Node_etDone:setVisible(false)
	self.Node_bossDetail = SoraDGetChildByName(self, "Node_bossDetail")
	self.Node_bossDetail:setVisible(false)
	self.Text_bossDetail = SoraDGetChildByName(self, "Text_bossDetail")
	self.Text_bossDetail:setString(i18n("epic_war_guard_desc"))
	self.Text_killStatus = SoraDGetChildByName(self, "Text_killStatus")
	self.Text_curSilver = SoraDGetChildByName(self, "Text_curSilver")
	self.Node_silverDetail = SoraDGetChildByName(self, "Node_silverDetail")
	self.Node_silverDetail:setVisible(false)
	self.icon_silver = SoraDGetChildByName(self, "icon_silver")
	self.Text_detail = SoraDGetChildByName(self, "Text_detail")
	self.Text_detail:setString(i18n("item_ancientSilverCoins_desc"))
	self.Node_selectTip = SoraDGetChildByName(self, "Node_selectTip")
	self.Node_selectTip:setVisible(false)
	self.Image_buffSelect = SoraDGetChildByName(self, "Image_buffSelect")
	self.Image_buffSelect:setVisible(false)
	self.Text_buffNum = SoraDGetChildByName(self, "Text_buffNum")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("epic_war_tactic_use_desc"))
	self.strategyArray = SoraDGetChildsArrayByName(self, "CCS_epicWarChooseBuffNode_", 8, 1, true, true)
	self.Button_use = SoraDGetChildByName(self, "Button_use")
	self.Button_use:setTitleText(i18n("common_text_314"))
	self.Button_use:addTouchEventListener(handler(self, self.btnUseClick))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Center_Node:setScale(display.height > 1136 and 1.2 or 1.0)
	self.Panel_use = SoraDGetChildByName(self, "Panel_use")
	self.Panel_use:setGroupID(epicBattleDef.groupDef.black)
	self.Panel_use:setVisible(false)
	self.Panel_use:setContentSize(cc.size(display.width, display.height))
	self.Panel_use:addTouchEventListener(handler(self, self.onTouchClick))
	self.Node_useModel = SoraDGetChildByName(self, "Node_useModel")
	self.Node_useModel:setVisible(false)
	self.Text_toolTip = SoraDGetChildByName(self.Node_useModel, "Text_toolTip")
	self.Text_toolTip:setString(i18n("epic_war_useTacticTips"))
	self.ccs_tool = SoraDGetExtendChildFromCCSByName(self, "CCS_epicWarChooseBuffNode_tool")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Node_noticeTarget = SoraDGetChildByName(self, "Node_noticeTarget")
	self:initMap()
	self:initAnimatonCache()
	self:checkGuide()
	self:updateArmyInfo()
	self:updateStrategy()
	epicBattleDef = i18n("epic_war_useTacticTips")
	i18n("epic_war_useTacticTips").isInit = true
	self:checkBossDropBless(self, i18n("epic_war_useTacticTips"))
	self:updateBossStatus()
	self:checkFinishChallenge()
	SoraDTestButton(self, function()
		guideCtrl:CompleteGuideStep(73006)
		guideCtrl:CompleteGuideStep(74001)
		guideCtrl:CompleteGuideStep(75001)
		guideCtrl:CompleteGuideStep(76001)
		guideCtrl:CompleteGuideStep(77004)
		guideCtrl:CompleteGuideStep(78002)
		guideCtrl:CompleteGuideStep(79003)
		guideCtrl:CompleteGuideStep(81003)
	end)
end
function epicWarMapView:resetModel()
	epicBattleDef.STRATEGYMODE = 0
	epicBattleDef.STRATEGYIDX = nil
end
function epicWarMapView:resetSelectTip(ret)
	self.Node_selectTip:setVisible(ret)
	self.Image_buffSelect:setVisible(ret)
end
function epicWarMapView:initGroupNode()
	local createGroupNode = function(groupID, zOrder)
		local node = display.newNode()
		node:setGroupID(groupID, true)
		node:addTo(self.Node_instance, zOrder)
	end
	createGroupNode(epicBattleDef.groupDef.black, 2)
	createGroupNode(epicBattleDef.groupDef.progressbg, 3)
	createGroupNode(epicBattleDef.groupDef.progress, 4)
	createGroupNode(epicBattleDef.groupDef.progersstext, 5)
end
function epicWarMapView:checkBossDropBless(target, data)
	local bless = epicWarCtrl:getBossDropBless()
	if next(bless) and data and data.isInit then
		_ENV = nil
		;(nil)[1] = cca.delay(0.016666666666666666)
		;(nil)[2] = cca.callFunc(function()
			local panel = SoraDCreatePanel("epicWarChooseBlessView")
			panel:initData()
			panel:show()
		end)
		;(nil)[3] = cca.callFunc(function()
			local panel = SoraDCreatePanel("epicWarChooseBlessView")
			panel:initData()
			panel:show()
		end)
		self:runAction(cca.seq(nil))
	end
	self:updateBossStatus(next(bless))
end
function epicWarMapView:runPassIconAction()
	local ret = epicWarCtrl:isBossKilled()
	if ret then
		self.Node_etDone:setVisible(true)
		self.boss_icon:setVisible(false)
		if self.et_done then
			self.et_done.action:gotoFrameAndPlay(0, false)
		else
			self.et_done = SoraDCreatAnimationEx("animationEpicWarKillBossIcon", nil, false)
			self.et_done:addTo(self.Node_etDone)
		end
	else
		self.Node_etDone:setVisible(false)
		self.boss_icon:setVisible(true)
	end
end
function epicWarMapView:updateBossStatus(isShowBless)
	local ret = epicWarCtrl:isBossKilled()
	if ret and not isShowBless then
		self:runPassIconAction()
	else
		self.Node_etDone:setVisible(false)
		self.boss_icon:setVisible(true)
	end
	self.Text_killStatus:setString(ret and i18n("epic_war_guard_notKilled_name") or i18n("epic_war_guard_killed_name"))
	self.Text_killStatus:setColor(ret and cc.c3b(190, 40, 40) or cc.c3b(200, 155, 100))
end
function epicWarMapView:checkGuide()
	local curStep = guideCtrl:getStepByGuideModule(gGuideModule.NEW_EPIC_WAR)
	print("curStep ========= ", curStep)
	if curStep then
		if epicWarCtrl:isBossKilled() or epicWarCtrl:getCurGateID() ~= 1500101 then
			return
		end
		if curStep == 77001 then
			local strategyList = epicWarCtrl:getCurStrategyList()
			guideCtrl = nil
			;(nil).x = 1
			;(nil).y = 3
			local spaceInfo = epicWarCtrl:getCurBoardInfoByPos(nil)
			if not (next(strategyList) and spaceInfo.isReal) or spaceInfo.isReal and spaceInfo.eventData.status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				print("不满足引导 直接跳过引导")
				return
			end
		end
		if curStep == 78001 then
			guideCtrl = print
			print.x = 1
			print.y = 3
			local spaceInfo = epicWarCtrl:getCurBoardInfoByPos(print)
			if not spaceInfo.isReal or spaceInfo.isReal and spaceInfo.eventData.status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
				print("不满足引导 直接跳过引导")
				return
			end
		end
		if curStep == 79001 then
			curStep = 79002
		end
		guideCtrl = print
		print.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		print.step = curStep
		SoraDSendMessage(print)
	end
end
function epicWarMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ENTER_STAGE", handler(self, self.updateArea))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_TO_NEXT_STAGE", handler(self, self.toNextGate))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_EXIT_STAGE", handler(self, self.exitChallenge))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_STAGE_EXPLORE", handler(self, self.updateArea))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_BUFF_CHOOSE", handler(self, self.showBuff))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_MITHRILCOUNT", handler(self, self.updateMithrilcount))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_ARMYLIST", handler(self, self.updateArmyInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_QUIT_CHAPTER", handler(self, self.exitChallenge))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_GET_STRATEGY_TOOL", handler(self, self.getStrategyTool))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_BOSS_DROP_BLESS", handler(self, self.checkBossDropBless))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_BLESSLIST", handler(self, self.updateBlessList))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_STRATEGYS", handler(self, self.updateStrategy))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_CURE_ARMY", handler(self, self.showCureArmyEffect))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_TO_NEXT_GATE", handler(self, self.showToNextGateEffect))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_FINISH_CHALLENGE", handler(self, self.checkFinishChallenge))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_TOWER_ATTACK", handler(self, self.showTowerAttackEffect))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_UPDATE_BOSS_ICON", handler(self, self.runPassIconAction))
end
function epicWarMapView:initAnimatonCache()
	local _ENV, imgArray
	_ENV = nil
	;(nil).name = "FrameAnimation/epicWarBoss"
	table.insert(imgArray, nil)
	_ENV = nil
	;(nil).name = "worldMap/worldMapBossIcon"
	table.insert(imgArray, nil)
	_ENV = nil
	;(nil).name = "SingleModule/epicWarCloud"
	table.insert(imgArray, nil)
	self:loadImages(imgArray, function()
		self:initData()
	end)
end
function epicWarMapView:initData()
	self:updateOtherData()
	self:initMapAreaData()
end
function epicWarMapView:showTowerAttackEffect()
	if not self.warnImg then
		self.warnImg = ccui.ImageView:create("frame_sheer_red_02.png", ccui.TextureResType.plistType)
		self.warnImg:setColor(cc.c3b(255, 129, 94))
		self.warnImg:ignoreContentAdaptWithSize(false)
		self.warnImg:setContentSize(display.realSize)
		self.warnImg:setAnchorPoint(cc.p(0.5, 0.5))
		self.warnImg:setPosition(cc.p(display.cx, display.rcy))
		self.warnImg:addTo(self, 999)
		self.warnImg:setVisible(false)
	end
	self.warnImg:setVisible(true)
	self.warnImg:stopAllActions()
	self.warnImg:setOpacity(0)
	_UPVALUE4_ = 999
	;(999)[1] = cca.delay(0.08333333333333333)
	;(999)[2] = cca.fadeTo(0.13333333333333333, 0.67)
	;(999)[3] = cca.fadeTo(0.25, 0)
	;(999)[4] = cca.delay(1.1166666666666667)
	;(999)[5] = cca.callFunc(function()
		self.warnImg:setVisible(false)
	end)
	;(999)[6] = cca.callFunc(function()
		self.warnImg:setVisible(false)
	end)
	self.warnImg:runAction(cca.seq(999))
end
function epicWarMapView:updateBlessList(target, data)
	local blessNum = epicWarCtrl:getBlessNum()
	self.icon_red:setVisible(0 < blessNum)
	self.Text_bNum:setString(blessNum)
	local blessId = data and data.blessId
	if blessId then
		local formPos = cc.p(SoraDFPosX(-260, 0), display.cy - 165)
		local toPos = cc.p(0, 0)
		local node = display.newNode()
		node:setScale(0.8)
		node:setPosition(formPos.x, formPos.y)
		node:addTo(self.Node_buff, 99)
		local iconPng = epicWarltCtrl.getBlessTacticsIcon(blessId)
		local iconBase = epicWarltCtrl.getBlessTacticsBase(blessId)
		local base = display.newSprite("#" .. iconBase)
		base:setPosition(0, 0)
		base:addTo(node, 0)
		local icon = display.newSprite("#" .. iconPng)
		icon:setPosition(0, 0)
		icon:addTo(node, 1)
		epicWarltCtrl = icon
		_ENV = 1
		;(1)[1] = cc.EaseExponentialIn:create(cca.moveTo(0.4, toPos.x, toPos.y))
		;(1)[2] = cca.scaleTo(0.4, 0.2, 0.2)
		;(1)[3] = cca.scaleTo(0.4, 0.2, 0.2)
		;(1)[4] = cca.scaleTo(0.4, 0.2, 0.2)
		;(1)[5] = cca.scaleTo(0.4, 0.2, 0.2)
		;(1)[6] = cca.scaleTo(0.4, 0.2, 0.2)
		icon[1] = cca.spawn(1)
		icon[2] = cca.delay(0.1)
		icon[3] = cca.callFunc(function()
			node:removeFromParent()
		end)
		icon[4] = cca.callFunc(function()
			node:removeFromParent()
		end)
		icon[5] = cca.callFunc(function()
			node:removeFromParent()
		end)
		icon[6] = cca.callFunc(function()
			node:removeFromParent()
		end)
		icon[7] = cca.callFunc(function()
			node:removeFromParent()
		end)
		icon[8] = cca.callFunc(function()
			node:removeFromParent()
		end)
		local seq_move = cca.seq(icon)
		node:runAction(seq_move)
	end
end
function epicWarMapView:noticeTarget()
	self.Node_noticeTarget:removeAllChildren()
	self.cloneSingles, epicBattleDef = self.Node_noticeTarget.removeAllChildren, self.Node_noticeTarget.removeAllChildren
	local ret = false
	local epicBattleDef, posArray = self.Node_noticeTarget, self.Node_noticeTarget
	if epicBattleDef.STRATEGYMODE == 1 then
		ret, posArray = epicWarCtrl:isHaveAliveBossNow()
	elseif epicBattleDef.STRATEGYMODE == 2 then
		ret, posArray = epicWarCtrl:isHaveTower()
	end
	for k, v in ipairs(self.areaInstanceArray) do
		local pos = v:getPos()
		for index, choosePos in ipairs(posArray) do
			if pos.x == choosePos.x and pos.y == choosePos.y then
				if self.useModel then
					local cloneSingle = v:copyMe()
					local formPos = self.Node_instance:convertToWorldSpace(self:getAreaRealPos(choosePos))
					cloneSingle:setPosition(formPos.x, formPos.y)
					cloneSingle:addTo(self.Node_noticeTarget)
					self.cloneSingles[index] = cloneSingle
				end
				v:setVisible(not self.useModel)
			end
		end
	end
end
function epicWarMapView:switchUseModel(ret)
	self.useModel = ret
	self.Panel_use:setVisible(ret)
	self.Node_useModel:setVisible(ret)
	self.Bottom_Node:setVisible(not ret)
	if ret then
		self.Panel_use:setOpacity(153.0)
		self.ccs_tool:initData(self.index, self.strategyIdx, self.strategyId)
	end
	self:noticeTarget()
end
function epicWarMapView:updateStrategy()
	self.strategyList = epicWarCtrl:getCurStrategyList()
	epicWarCtrl = nil
	;(nil).var1 = table.nums(self.strategyList)
	;(nil).var2 = 8
	self.Text_buffNum:setString(i18n("epic_war_tacticNum_name", nil))
	local epicWarCtrl, sortList = self.Text_buffNum.setString, self.Text_buffNum.setString
	for _index, _id in pairs(self.strategyList) do
		epicWarCtrl = i18n("epic_war_tacticNum_name", nil)
		i18n("epic_war_tacticNum_name", nil).index = tonumber(_index)
		i18n("epic_war_tacticNum_name", nil).id = _id
		i18n("epic_war_tacticNum_name", nil).useType = epicWarltCtrl.getTacticsUseType(_id)
		table.insert(sortList, i18n("epic_war_tacticNum_name", nil))
	end
	table.sort(sortList, function(a, b)
		if a.useType == b.useType then
			return a.id > b.id
		else
			return a.useType < b.useType
		end
	end)
	for k, v in ipairs(self.strategyArray) do
		if sortList[k] then
			v:initData(k, sortList[k].index, sortList[k].id)
		else
			v:initData(k)
		end
		if sortList[k] and sortList[k].id then
			v:setHandle(function(index, idx, strategyId)
				self.index = index
				self.strategyIdx = idx
				self.strategyId = strategyId
				epicBattleDef.STRATEGYIDX = self.strategyIdx
				self.Image_buffSelect:setPositionX(self.strategyArray[index]:getPositionX())
				self:resetSelectTip(true)
				self.Panel_use:setVisible(true)
				self.Panel_use:setOpacity(0)
				local tipPosX = self.strategyArray[index]:getPositionX()
				tipPosX = math.max(-132, tipPosX)
				tipPosX = math.min(tipPosX, 132)
				self.Node_selectTip:setPositionX(tipPosX)
				local Text_buffName = SoraDGetChildByName(self.Node_selectTip, "Text_buffName")
				local Text_buffDes = SoraDGetChildByName(self.Node_selectTip, "Text_buffDes")
				Text_buffName:setString(i18n(epicWarltCtrl.getTacticsName(strategyId)))
				Text_buffDes:setString(i18n(epicWarltCtrl.getTacticsDes(strategyId)))
			end)
		end
	end
end
function epicWarMapView:exitChallenge(target, data)
	SoraDCloseLoading(self)
	self:removeFromParent()
end
function epicWarMapView:updateArmyInfo(target, data)
	local _, curNum = epicWarCtrl:getCurArmyInfo()
	local _, oriNum = epicWarCtrl:getOriArmyInfo()
	local percent = math.min(100, curNum * 100 / oriNum)
	if self.barTimer then
		SoraDManagerRemoveTimer(self, self.barTimer)
		self.barTimer = nil
	end
	local prePercent = self.LoadingBar_bar:getPercent()
	if prePercent ~= percent then
		self.barTimer = SoradCreateTimer(self, function(...)
			if prePercent == percent then
				return
			end
			local preValue = (percent - prePercent) / 35
			if self.LoadingBar_bar_act then
				self.LoadingBar_bar_act:setPercent(prePercent)
			end
		end, true)
	else
		self.LoadingBar_bar_act:setPercent(percent)
	end
	self.LoadingBar_bar:setPercent(percent)
	self.Text_percent:setString(string.formatnumberthousands(curNum))
end
function epicWarMapView:showCureArmyEffect()
	SoraDPlaySound("epicWar", 5)
	if not self.et_cure then
		self.et_cure = SoraDCreatAnimationEx("animationEpicWarCure", nil, false)
		self.et_cure:addTo(self.Node_etCure)
	else
		self.et_cure.action:gotoFrameAndPlay(0, false)
	end
end
function epicWarMapView:showBuff(target, data)
end
function epicWarMapView:getFlyNode(buffType)
	local node = display.newNode()
	return node
end
function epicWarMapView:getAreaByPos(pos)
	local index = epicBattleDef.getAreaIndex(pos)
	local area = SoraDGetChildByName(self.mapView, "area_" .. index)
	return area
end
function epicWarMapView:initMapAreaData()
	self.areaData = epicWarCtrl:getCurBoardInfo()
	self.Node_instance = SoraDGetChildByName(self.mapView, "Node_instance")
	self.Node_instance:setLocalZOrder(35)
	self:initGroupNode()
	dump(self.areaData, "self.areaData===", 10)
	for h, data in ipairs(self.areaData) do
		for l, v in ipairs(data) do
			local index = (h - 1) * 5 + l
			local area = SoraDGetChildByName(self.mapView, "area_" .. index)
			local areaInstance = include("epicBattleMapSingle").new()
			areaInstance:initData(v, h, l)
			areaInstance:setPosition(area:getPositionX(), area:getPositionY())
			areaInstance:addTo(self.Node_instance, 1)
			self.areaInstanceArray[index] = areaInstance
		end
	end
end
function epicWarMapView:getAreaRealPos(pos)
	local realPos = cc.p(0, 0)
	for k, v in ipairs(self.areaInstanceArray) do
		local mPos = v:getPos()
		if mPos.x == pos.x and mPos.y == pos.y then
			realPos = cc.p(v:getPositionX(), v:getPositionY())
		end
	end
	return realPos
end
function epicWarMapView:updateOtherData()
	self.Text_area:setString(string.format("%d-%d", epicWarCtrl:getCurChapter(), epicWarCtrl:getCurGateIndex()))
	local blessNum = epicWarCtrl:getBlessNum()
	self.icon_red:setVisible(0 < blessNum)
	self.Text_bNum:setString(blessNum)
	self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
end
function epicWarMapView:toNextGate(target, data)
	SoraDCloseLoading()
	self:resetSelectTip(false)
	self:updateOtherData()
	self:updateBossStatus()
	self:resetModel()
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(function()
		self:mapToCenter()
		self:showToNextGateEffect()
	end)
	;(nil)[2] = cca.delay(1.5)
	;(nil)[3] = cca.callFunc(function()
		self.areaData = epicWarCtrl:getCurBoardInfo()
		for h, data in ipairs(self.areaData) do
			for l, v in ipairs(data) do
				local index = (h - 1) * 5 + l
				if self.areaInstanceArray[index] then
					self.areaInstanceArray[index]:initData(v, h, l, false, nil, true)
				end
			end
		end
	end)
	;(nil)[4] = cca.callFunc(function()
		self.areaData = epicWarCtrl:getCurBoardInfo()
		for h, data in ipairs(self.areaData) do
			for l, v in ipairs(data) do
				local index = (h - 1) * 5 + l
				if self.areaInstanceArray[index] then
					self.areaInstanceArray[index]:initData(v, h, l, false, nil, true)
				end
			end
		end
	end)
	self:runAction(cca.seq(nil))
end
function epicWarMapView:updateArea(target, data)
	SoraDCloseLoading()
	self:switchUseModel(false)
	self:resetSelectTip(false)
	if data and data.noRefresh then
		return
	end
	self:updateOtherData()
	self.areaData = epicWarCtrl:getCurBoardInfo()
	local isUnlock = data and data.isUnlock or false
	local unlockPos = data and data.pos or nil
	for h, data in ipairs(self.areaData) do
		for l, v in ipairs(data) do
			local index = (h - 1) * 5 + l
			if self.areaInstanceArray[index] then
				self.areaInstanceArray[index]:initData(v, h, l, isUnlock, unlockPos)
			end
		end
	end
	if isUnlock and unlockPos then
		print("1,2,3 ========== ", epicWarCtrl:getCurGateID() == 1500101, guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR), epicWarCtrl:isSecondMonster(unlockPos))
	end
	if isUnlock and unlockPos and epicWarCtrl:getCurGateID() == 1500101 and guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR) and epicWarCtrl:isSecondMonster(unlockPos) then
		_ENV = epicWarCtrl
		epicWarCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		epicWarCtrl.step = 80001
		SoraDSendMessage(epicWarCtrl)
	end
end
function epicWarMapView:updateMithrilcount(target, data)
	if data and data.isItem and data.pos then
		local targetPoint = self:getAreaRealPos(data.pos)
		local formPos = SoraDCoverToPoint(self.Node_instance, targetPoint, self.icon_silver:getParent())
		local toPos = cc.p(self.icon_silver:getPositionX(), self.icon_silver:getPositionY())
		local icon = display.newSprite("#icon_epicWar_sgyb.png")
		icon:setPosition(formPos.x, formPos.y)
		icon:setScale(0.5)
		icon:addTo(self.icon_silver:getParent())
		epicWarCtrl = icon
		epicWarCtrl = self.icon_silver:getParent()
		self.icon_silver:getParent()[1] = cc.EaseExponentialIn:create(cca.moveTo(0.4, toPos))
		self.icon_silver:getParent()[2] = cca.scaleTo(0.4, 0.3, 0.3)
		self.icon_silver:getParent()[3] = cca.scaleTo(0.4, 0.3, 0.3)
		self.icon_silver:getParent()[4] = cca.scaleTo(0.4, 0.3, 0.3)
		self.icon_silver:getParent()[5] = cca.scaleTo(0.4, 0.3, 0.3)
		icon[1] = cca.spawn(self.icon_silver:getParent())
		icon[2] = cca.callFunc(function()
			icon:removeFromParent()
			_UPVALUE6_ = nil
			;(nil)[1] = cca.scaleTo(0.2, 0.45)
			;(nil)[2] = cca.scaleTo(0.2, 0.2)
			;(nil)[3] = cca.scaleTo(0.15, 0.4)
			;(nil)[4] = cca.scaleTo(0.15, 0.25)
			;(nil)[5] = cca.scaleTo(0.1, 0.35)
			;(nil)[6] = cca.scaleTo(0.1, 0.3)
			;(nil)[7] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			;(nil)[8] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			self.icon_silver:runAction(cca.seq(nil))
		end)
		icon[3] = cca.callFunc(function()
			icon:removeFromParent()
			_UPVALUE6_ = nil
			;(nil)[1] = cca.scaleTo(0.2, 0.45)
			;(nil)[2] = cca.scaleTo(0.2, 0.2)
			;(nil)[3] = cca.scaleTo(0.15, 0.4)
			;(nil)[4] = cca.scaleTo(0.15, 0.25)
			;(nil)[5] = cca.scaleTo(0.1, 0.35)
			;(nil)[6] = cca.scaleTo(0.1, 0.3)
			;(nil)[7] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			;(nil)[8] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			self.icon_silver:runAction(cca.seq(nil))
		end)
		icon[4] = cca.callFunc(function()
			icon:removeFromParent()
			_UPVALUE6_ = nil
			;(nil)[1] = cca.scaleTo(0.2, 0.45)
			;(nil)[2] = cca.scaleTo(0.2, 0.2)
			;(nil)[3] = cca.scaleTo(0.15, 0.4)
			;(nil)[4] = cca.scaleTo(0.15, 0.25)
			;(nil)[5] = cca.scaleTo(0.1, 0.35)
			;(nil)[6] = cca.scaleTo(0.1, 0.3)
			;(nil)[7] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			;(nil)[8] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			self.icon_silver:runAction(cca.seq(nil))
		end)
		icon[5] = cca.callFunc(function()
			icon:removeFromParent()
			_UPVALUE6_ = nil
			;(nil)[1] = cca.scaleTo(0.2, 0.45)
			;(nil)[2] = cca.scaleTo(0.2, 0.2)
			;(nil)[3] = cca.scaleTo(0.15, 0.4)
			;(nil)[4] = cca.scaleTo(0.15, 0.25)
			;(nil)[5] = cca.scaleTo(0.1, 0.35)
			;(nil)[6] = cca.scaleTo(0.1, 0.3)
			;(nil)[7] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			;(nil)[8] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			self.icon_silver:runAction(cca.seq(nil))
		end)
		icon[6] = cca.callFunc(function()
			icon:removeFromParent()
			_UPVALUE6_ = nil
			;(nil)[1] = cca.scaleTo(0.2, 0.45)
			;(nil)[2] = cca.scaleTo(0.2, 0.2)
			;(nil)[3] = cca.scaleTo(0.15, 0.4)
			;(nil)[4] = cca.scaleTo(0.15, 0.25)
			;(nil)[5] = cca.scaleTo(0.1, 0.35)
			;(nil)[6] = cca.scaleTo(0.1, 0.3)
			;(nil)[7] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			;(nil)[8] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			self.icon_silver:runAction(cca.seq(nil))
		end)
		icon[7] = cca.callFunc(function()
			icon:removeFromParent()
			_UPVALUE6_ = nil
			;(nil)[1] = cca.scaleTo(0.2, 0.45)
			;(nil)[2] = cca.scaleTo(0.2, 0.2)
			;(nil)[3] = cca.scaleTo(0.15, 0.4)
			;(nil)[4] = cca.scaleTo(0.15, 0.25)
			;(nil)[5] = cca.scaleTo(0.1, 0.35)
			;(nil)[6] = cca.scaleTo(0.1, 0.3)
			;(nil)[7] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			;(nil)[8] = cca.callFunc(function()
				self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
			end)
			self.icon_silver:runAction(cca.seq(nil))
		end)
		local seq_move = cca.seq(icon)
		icon:runAction(seq_move)
	else
		self.Text_curSilver:setString(epicWarCtrl:getMithrilCount())
	end
end
function epicWarMapView:getStrategyTool(target, data)
	local pos = data.pos
	local idx = math.max(1, table.nums(epicWarCtrl:getCurStrategyList()))
	local strategyId = data.eventReport.strategyId
	local targetPoint = self:getAreaRealPos(pos)
	local formPos = SoraDCoverToPoint(self.Node_instance, targetPoint, self.strategyArray[idx]:getParent())
	local toPos = cc.p(self.strategyArray[idx]:getPositionX(), self.strategyArray[idx]:getPositionY())
	local node = SoraDCreatAnimation("animationEpicWarHDCLDJ", nil, false)
	node:setScale(1.1)
	node:setPosition(formPos.x, formPos.y)
	node:addTo(self.strategyArray[idx]:getParent(), 99)
	local iconPng = epicWarltCtrl.getTacticsIcon(strategyId)
	local iconBase = epicWarltCtrl.getTacticsIconBase(strategyId)
	local base = SoraDGetChildByName(node, "Image_quality")
	base:loadTexture(iconBase, ccui.TextureResType.plistType)
	local icon = SoraDGetChildByName(node, "Image_strategy")
	icon:loadTexture(iconPng, ccui.TextureResType.plistType)
	epicWarltCtrl = icon
	epicWarCtrl = ccui.TextureResType.plistType
	ccui.TextureResType.plistType[1] = cc.EaseExponentialIn:create(cca.moveTo(0.4, toPos))
	ccui.TextureResType.plistType[2] = cca.scaleTo(0.4, 1.0, 1.0)
	ccui.TextureResType.plistType[3] = cca.scaleTo(0.4, 1.0, 1.0)
	ccui.TextureResType.plistType[4] = cca.scaleTo(0.4, 1.0, 1.0)
	ccui.TextureResType.plistType[5] = cca.scaleTo(0.4, 1.0, 1.0)
	icon[1] = cca.spawn(ccui.TextureResType.plistType)
	icon[2] = cca.delay(0.4)
	icon[3] = cca.callFunc(function()
		self:updateStrategy()
		node:removeFromParent()
	end)
	icon[4] = cca.callFunc(function()
		self:updateStrategy()
		node:removeFromParent()
	end)
	icon[5] = cca.callFunc(function()
		self:updateStrategy()
		node:removeFromParent()
	end)
	icon[6] = cca.callFunc(function()
		self:updateStrategy()
		node:removeFromParent()
	end)
	icon[7] = cca.callFunc(function()
		self:updateStrategy()
		node:removeFromParent()
	end)
	local seq_move = cca.seq(icon)
	node:runAction(seq_move)
end
function epicWarMapView:showToNextGateEffect()
	SoraDPlaySound("epicWar", 2)
	if not self.et_cloud then
		self.et_cloud = SoraDCreatAnimationEx("animationEpicWarCloud", nil, false)
		self.et_cloud:addTo(self.Center_Node)
	else
		self.et_cloud.action:gotoFrameAndPlay(0, false)
	end
end
function epicWarMapView:checkFinishChallenge()
	if epicWarCtrl:isAllExplored() then
		_ENV = nil
		;(nil)[1] = cca.delay(0.016666666666666666)
		;(nil)[2] = cca.callFunc(function()
			SoraDShowMsgBox(i18n("epic_war_challengeComplete_desc"), i18n("epic_war_outChallenge_btn"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					epicWarCtrl:sendReqQuitChapter()
				end
			end)
		end)
		;(nil)[3] = cca.callFunc(function()
			SoraDShowMsgBox(i18n("epic_war_challengeComplete_desc"), i18n("epic_war_outChallenge_btn"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					epicWarCtrl:sendReqQuitChapter()
				end
			end)
		end)
		self:runAction(cca.seq(nil))
	end
end
function epicWarMapView:mapToCenter()
	local containerViewSize = self.mapView:getContentSize()
	self.viewScrollView:setContentOffsetInDuration(cc.p(display.cx - containerViewSize.width / 2, display.cy - containerViewSize.height / 2), 0)
end
function epicWarMapView:initMap()
	self.mapView = cc.CSLoader:createNode(getCCSPath("epicBattleMapInfoView"))
	local containerViewSize = self.mapView:getContentSize()
	self.containerView = ccui.Layout:create()
	self.containerView:setContentSize(containerViewSize)
	self.containerView:setSwallowTouches(false)
	self.bgArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, containerViewSize.width, containerViewSize.height))
	self.bgArea:ignoreAnchorPointForPosition(false)
	self.bgArea:setAnchorPoint(cc.p(0.0, 0.0))
	self.containerView:addChild(self.bgArea, 0)
	self.tiledBg = display.newTilesSprite("SinglePicture/tiledmap.png", cc.rect(0, 0, containerViewSize.width, containerViewSize.height))
	self.tiledBg:ignoreAnchorPointForPosition(false)
	self.tiledBg:setAnchorPoint(cc.p(0.0, 0.0))
	self.containerView:addChild(self.tiledBg, 1)
	self.mapView:setScale(1)
	self.mapView:ignoreAnchorPointForPosition(false)
	self.mapView:setAnchorPoint(cc.p(0.5, 0.5))
	self.mapView:setPosition(cc.p(containerViewSize.width / 2, containerViewSize.height / 2))
	self.containerView:addChild(self.mapView, 2)
	local viewSize = self:getContentSize()
	self.viewScrollView = cc.ScrollView:create(viewSize)
	self.viewScrollView:setContainer(self.containerView)
	self.viewScrollView:setMinScale(0.9)
	self.viewScrollView:setMaxScale(1.35)
	self.viewScrollView:setZoomScale(1.0)
	self.viewScrollView:setBounceable(false)
	self.viewScrollView:setInertiaValue(0.35)
	self.viewScrollView:setPosition(cc.p(0, 0))
	self:addChild(self.viewScrollView, 0)
	self.viewScrollView:setContentOffset(cc.p(display.cx - containerViewSize.width / 2, display.cy - containerViewSize.height / 2))
end
function epicWarMapView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("帮助FAQ===")
		if IsArClient then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.EPIC_WAR)
		else
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.EPIC_WAR)
		end
	end
end
function epicWarMapView:btnOverClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("epic_war_outChallengeSure_desc"), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				epicWarCtrl:sendReqQuitChapter()
			end
		end)
	end
end
function epicWarMapView:btnDetailClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("epicBattleAwardDetailView"):show()
	end
end
function epicWarMapView:btnBuffClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("epicWarBuffView"):show()
	end
end
function epicWarMapView:btnUseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local useType = epicWarltCtrl.getTacticsUseType(self.strategyList[tostring(self.strategyIdx)])
		if useType == epicBattleDef.gTacticsEffectType.SHOW_MONSTER and (epicWarCtrl:isAllMonsterFounded() or epicWarCtrl:isShowBMonsterPre()) then
			SoraDShowMsgTip(i18n("tips_insight_noGuard01"))
			self:resetModel()
			self:switchUseModel(false)
			self:resetSelectTip(false)
			return
		end
		if useType == epicBattleDef.gTacticsEffectType.SHOW_BOSS and (epicWarCtrl:isBossFounded() or epicWarCtrl:isShowBossPre()) then
			SoraDShowMsgTip(i18n("tips_insight_noGuard02"))
			self:resetModel()
			self:switchUseModel(false)
			self:resetSelectTip(false)
			return
		end
		if useType == epicBattleDef.gTacticsEffectType.DESTROY_BARTIZAN and not epicWarCtrl:isHaveTower() then
			SoraDShowMsgTip(i18n("tips_use_tactice04"))
			self:resetModel()
			self:switchUseModel(false)
			self:resetSelectTip(false)
			return
		end
		if (useType == epicBattleDef.gTacticsEffectType.BOSS_ARMY_REDUCE or useType == epicBattleDef.gTacticsEffectType.DAMAGE_REDUCE or useType == epicBattleDef.gTacticsEffectType.CHANGE_BOSS_POS or useType == epicBattleDef.gTacticsEffectType.RELEX_GUARD) and not epicWarCtrl:isHaveAliveBossNow() then
			SoraDShowMsgTip(i18n("tips_insight_noGuard03"))
			self:resetModel()
			self:switchUseModel(false)
			self:resetSelectTip(false)
			return
		end
		if not epicBattleDef.isNeedPos(useType) then
			epicWarCtrl:sendUseStrategy(self.strategyIdx)
			self:resetModel()
			self:switchUseModel(false)
			self:resetSelectTip(false)
			return
		end
		local isNeesChoose, isTower = epicBattleDef.isNeedPos(useType)
		if isNeesChoose then
			epicBattleDef.STRATEGYMODE = isTower and 2 or 1
		else
			epicBattleDef.STRATEGYMODE = 0
		end
		self:switchUseModel(true)
	end
end
function epicWarMapView:onTouchClick(target, event)
	if event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			return
		end
		self:switchUseModel(false)
		self:resetModel()
		self:resetSelectTip(false)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function epicWarMapView:btnSilverClick(target, event)
	if event == ccui.TouchEventType.began then
		self.Node_silverDetail:setVisible(true)
	elseif event == ccui.TouchEventType.ended then
		self.Node_silverDetail:setVisible(false)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.Node_silverDetail:setVisible(false)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.Node_silverDetail:setVisible(false)
	end
end
function epicWarMapView:btnBossClick(target, event)
	if event == ccui.TouchEventType.began then
		self.Node_bossDetail:setVisible(true)
	elseif event == ccui.TouchEventType.ended then
		self.Node_bossDetail:setVisible(false)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.Node_bossDetail:setVisible(false)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.Node_bossDetail:setVisible(false)
	end
end
function epicWarMapView:btnArmyDetailClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("epicBattleArmyInfoView"):show()
	end
end
function epicWarMapView:onExitPanel()
	print("释放动画=======")
	_ENV = "释放动画======="
	;("释放动画=======").msg = "MESSAGE_UI_EPICBATTLE_CHAPTER_SELECT"
	;("释放动画=======").chapter = epicWarCtrl:getCurChapter()
	SoraDSendMessage("释放动画=======")
end
function epicWarMapView:gameGuide_getTarget(itemName, parameters)
	if itemName == "index" then
		return self.areaInstanceArray[parameters.index].Panel_touch
	elseif itemName == "monster" then
		for k, v in ipairs(self.cloneSingles) do
			if v:getPos().x == parameters.pos.x and v:getPos().y == parameters.pos.y then
				return v.Panel_touch
			end
		end
	elseif itemName == "strategy" then
		return self.strategyArray[parameters.index].Button_touch
	else
		return SoraDGetChildByName(self, itemName)
	end
end
return epicWarMapView
