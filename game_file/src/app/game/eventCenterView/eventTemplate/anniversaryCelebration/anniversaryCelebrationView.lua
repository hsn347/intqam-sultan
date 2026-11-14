local celebrationActivenessTable = require_data("celebration_activeness", true)
local celebrationTaskTable = require_data("celebration_task", true)
local celebrationTaskDesTable = require_data("celebration_task_des")
local gametop = gModuleMgr.getObject("gametop")
local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local anniversaryCtrl = gametop.playertop_:getModule("anniversaryCtrl")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local rechargeRead = include("rechargeRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local anniversaryCelebrationView = class("anniversaryCelebrationView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("anniversaryCelebrationView")
	end
	return target
end)
local PANEL_HEIGHT = 140
local totalShowNum = #rechargeActivityCtrl:getAnniversaryPackageList()
_ENV, _UPVALUE3_ = nil, rechargeActivityCtrl
_ENV, (nil).posX = nil, -214
_ENV, (nil).posX = nil, -203
;(nil).posX = -195
_ENV, rechargeActivityCtrl[1] = nil, nil
_ENV, rechargeActivityCtrl[2] = nil, nil
local _ENV, rechargeActivityCtrl[3], tabPos = nil, nil, rechargeActivityCtrl
;(nil)[1] = 1
;(nil)[2] = 25
;(nil)[3] = 50
;(nil)[4] = 75
local _ENV, (nil)[5], graduation = nil, 100, nil
;(nil).LOGIN_DAY = 1
;(nil).COLLECT_FOOD = 2
;(nil).COLLECT_WOOD = 3
;(nil).COLLECT_IRON = 4
;(nil).COLLECT_MITHRIL = 5
;(nil).KILL_MOSTER = 6
;(nil).ALLIANCE_DONATE = 7
;(nil).DISCOUNT_STORE = 8
;(nil).HARVEST_RESOURCE = 9
;(nil).USE_SPEED_UP = 10
;(nil).BUILD_UPGRADE = 11
;(nil).MONSTERPALACE_HORN = 12
;(nil).TECHNOLOGY_UPGRADE = 13
;(nil).MAKE_WISH = 14
;(nil).PYRAMID = 15
;(nil).EPIC_WAR = 16
;(nil).RECRUIT_SOLDIERS = 17
;(nil).ESCORT_TIMES = 18
;(nil).ESCORT_ADVANCED_TIMES = 19
;(nil).ESCORT_LUXURY_TIMES = 20
local _ENV, (nil).ESCORT_ROYAL_TIMES, anniversaryMissionType = nil, 21, nil
;(nil)[anniversaryMissionType.COLLECT_FOOD] = gNewPLayerTaskType.COLLECT_RESOURCE
;(nil)[anniversaryMissionType.COLLECT_WOOD] = gNewPLayerTaskType.COLLECT_RESOURCE
;(nil)[anniversaryMissionType.COLLECT_IRON] = gNewPLayerTaskType.COLLECT_RESOURCE
;(nil)[anniversaryMissionType.COLLECT_MITHRIL] = gNewPLayerTaskType.COLLECT_RESOURCE
;(nil)[anniversaryMissionType.KILL_MOSTER] = gNewPLayerTaskType.KILL_MONSTER
;(nil)[anniversaryMissionType.ALLIANCE_DONATE] = gNewPLayerTaskType.ALLIANCE_DONATE
;(nil)[anniversaryMissionType.DISCOUNT_STORE] = gNewPLayerTaskType.MYSTICAL_STORE
;(nil)[anniversaryMissionType.HARVEST_RESOURCE] = gNewPLayerTaskType.HARVEST_RESOURCE
;(nil)[anniversaryMissionType.BUILD_UPGRADE] = gNewPLayerTaskType.BUILD_UPGRADE
;(nil)[anniversaryMissionType.TECHNOLOGY_UPGRADE] = gNewPLayerTaskType.RESEARCH_TECHNOLOGY
;(nil)[anniversaryMissionType.MAKE_WISH] = gNewPLayerTaskType.MAKE_A_WISH
;(nil)[anniversaryMissionType.PYRAMID] = gNewPLayerTaskType.PYRAMID
;(nil)[anniversaryMissionType.EPIC_WAR] = gNewPLayerTaskType.EPIC_WAR
;(nil)[anniversaryMissionType.RECRUIT_SOLDIERS] = gNewPLayerTaskType.TRAIN_SOLDIERS
;(nil)[anniversaryMissionType.ESCORT_TIMES] = gNewPLayerTaskType.ESCORT
;(nil)[anniversaryMissionType.ESCORT_ADVANCED_TIMES] = gNewPLayerTaskType.ESCORT
;(nil)[anniversaryMissionType.ESCORT_LUXURY_TIMES] = gNewPLayerTaskType.ESCORT
local (nil)[anniversaryMissionType.ESCORT_ROYAL_TIMES], missionTypeToNewPlayerType = gNewPLayerTaskType.ESCORT, nil
function anniversaryCelebrationView:ctor()
	self:initControls()
	anniversaryCtrl:sendAnniversaryInitMsg()
	SoraDShowLoading(self)
end
function anniversaryCelebrationView:initControls()
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.btnQuest = SoraDGetChildByName(self, "btn_questA")
	self.downScroll = SoraDGetChildByName(self, "Top_Size_ScrollEvents")
	self.btnThreeTabs = SoraDGetChildByName(self, "btn_tab_1")
	self.btnFiveTabs = SoraDGetChildByName(self, "btn_day_1")
	self.nodeTabs = SoraDGetChildByName(self, "node_tab")
	self.nodeLine1 = SoraDGetChildByName(self, "frame_tab_line1")
	self.nodeLine2 = SoraDGetChildByName(self, "frame_tab_line2")
	self.panelContent = SoraDGetChildByName(self, "panel_content")
	self.itemSingle = SoraDGetChildByName(self, "item_single")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.imageShadow = SoraDGetChildByName(self, "Image_3")
	self.btnOperate = SoraDGetChildByName(self, "btn_operate")
	self.btnAllGet = SoraDGetChildByName(self, "btn_allGet")
	self.panelPad = SoraDGetChildByName(self, "Center_Size_Panel_touchPad")
	self.txtActiveValue = SoraDGetChildByName(self, "text_activeValue")
	self.txtActiveMax = SoraDGetChildByName(self, "text_activeMax")
	self.txtTitle = SoraDGetChildByName(self, "text_title")
	self.txtActiveTitle = SoraDGetChildByName(self, "text_activeTitle")
	self.imgBox = SoraDGetChildByName(self, "frame_xxwjq_box_134")
	self.imgDiscount = SoraDGetChildByName(self, "frame_anniversarycelebration_02_136")
	self.imgGold = SoraDGetChildByName(self, "frame_xxwjq_pz_135")
	self.btnLeft = SoraDGetChildByName(self, "btn_left")
	self.btnRight = SoraDGetChildByName(self, "btn_right")
	self.btnLook = SoraDGetChildByName(self, "btn_look")
	self.txtDiscount = SoraDGetChildByName(self, "Text_discount")
	self.txtGold = SoraDGetChildByName(self, "Text_gold")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_1")
	self.spriteGraduation = SoraDGetChildByName(self, "Image_9")
	self.spriteLoadingBar = SoraDGetChildByName(self, "frame_xxwjq_jdt2_20")
	self.spritePointer = SoraDGetChildByName(self, "frame_xxwjq_jdtd_jt_21")
	self.txtChance = SoraDGetChildByName(self, "text_chance")
	self.txtEndTime = SoraDGetChildByName(self, "text_time")
	self.txtEndTime = SoraDCreateTimerLabel(self, self.txtEndTime)
	self.txtEndTime:setTimeEndListener(function()
		self.txtEndTime:setVisible(false)
	end)
	self.bg:setFillType(1)
	self.nodeTabs:setLocalZOrder(2)
	self.nodeTitle:setTitle(i18n("celebration_text_01"))
	self.btnAllGet:setTitleText(i18n("common_text_3681"))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.btnThreeTabs:addTouchEventListener(handler(self, self.switchTabsClickCallBack))
	self.btnFiveTabs:addTouchEventListener(handler(self, self.switchButtonsClickCallBack))
	self.btnOperate:addTouchEventListener(handler(self, self.operateClickCallBack))
	self.btnAllGet:addTouchEventListener(handler(self, self.allGetClickCallBack))
	self.panelPad:addTouchEventListener(handler(self, self.panelTouchPadClick))
	self.btnLeft:addTouchEventListener(handler(self, self.btnPreCallback))
	self.btnRight:addTouchEventListener(handler(self, self.btnNextCallback))
	self.btnLook:addTouchEventListener(handler(self, self.jumpCallback))
end
function anniversaryCelebrationView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_REFRESH_BACK", handler(self, self.initDownScroll))
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_BUY_PACKAGE_BACK", handler(self, self.refreshBuyState))
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_INIT_BACK", function(target, data)
		SoraDCloseLoading(self)
		self:initEnterData()
		self:initThreeTaskTabs()
		self:initFiveDaysTabs()
		self:initGraduation()
		self:initDownScroll()
	end)
end
function anniversaryCelebrationView:initEnterData()
	self.txtEventTable, anniversaryCtrl, self.imgEventTable, anniversaryCtrl, self.txtThreeTable, anniversaryCtrl, self.imgThreeTable, anniversaryCtrl, self.btnThreeTable, anniversaryCtrl = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.day = anniversaryCtrl:getCurrentDayByLoginTime()
	if self.day > 5 then
		self.day = 5
	end
	local remainTime = anniversaryCtrl:getRemainTimesToDoTask()
	if 0 < remainTime then
		self.txtEndTime:setVisible(true)
		self.txtEndTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("celebration_text_13", nil)
		end)
		self.txtEndTime:beginTime(remainTime)
	else
		self.txtEndTime:setVisible(false)
	end
	local missionSet = anniversaryCtrl:getMissionSetData(self.day)
	local anniversaryCtrl, tempKeyTable = anniversaryCtrl, anniversaryCtrl
	for k, v in pairs(missionSet) do
		table.insert(tempKeyTable, k)
	end
	table.sort(tempKeyTable, function(l, r)
		return l < r
	end)
	self.switchKey = tempKeyTable[1]
	self.nodeLine1:setPositionX(109)
	self.nodeLine2:setPositionX(-105)
	self.activenessIndex = 1
	local maxValue = self:getCelebrationActivenessMaxByIndex(self.activenessIndex)
	self.btnLook:setTag(self.activenessIndex)
	self.txtActiveValue:setString(anniversaryCtrl:getPlayerActiveness())
	self.txtTitle:setString(self:getCelebrationPackageNameByIndex(self.activenessIndex))
	self.txtActiveTitle:setString(i18n("celebration_text_07"))
	self.txtActiveMax:setString("/" .. maxValue)
	self.txtActiveMax:setPositionX(self.txtActiveValue:getPositionX() + self.txtActiveValue:getContentSize().width + 5)
	if maxValue > anniversaryCtrl:getPlayerActiveness() then
		self.txtChance:setString(i18n("celebration_text_06"))
	else
		self.txtChance:setString(i18n("celebration_text_02"))
	end
	local totalData = self:getRechargeListDataByIndex(self.activenessIndex)
	if totalData then
		self.txtDiscount:setString(totalData.discount[2] .. "%")
		self.txtGold:setString("$" .. totalData.price)
		if not totalData.isCantBuy then
			self.btnLook:setTitleText(i18n("common_text_829"))
			self.btnLook:getVirtualRenderer():setState(0)
			self.btnLook:setEnabled(true)
		else
			self.btnLook:setTitleText(i18n("common_text_3833"))
			self.btnLook:setEnabled(false)
			self.btnLook:getVirtualRenderer():setState(1)
			self.txtChance:setString(i18n("celebration_text_05"))
		end
	end
	local pbSize = self.spriteLoadingBar:getContentSize()
	self.loadingBar:setPercent(anniversaryCtrl:getPlayerActiveness() / 100 * 100)
	self.spritePointer:setPositionX(graduation[self.activenessIndex] / 100 * pbSize.width + 5)
end
function anniversaryCelebrationView:initThreeTaskTabs()
	local missionSet = anniversaryCtrl:getMissionSetData(self.day)
	local anniversaryCtrl, tempKeyTable = anniversaryCtrl, anniversaryCtrl
	for k, v in pairs(missionSet) do
		table.insert(tempKeyTable, k)
	end
	table.sort(tempKeyTable, function(l, r)
		return l < r
	end)
	for i, v in ipairs(tempKeyTable) do
		if i < 4 then
			local btnTaskTabs = self.btnThreeTabs:clone()
			btnTaskTabs:setPosition(cc.p((i - 1) * 205 + tabPos[i].posX, -1))
			btnTaskTabs:setPressedActionEnabled(false)
			btnTaskTabs:setTag(v)
			btnTaskTabs:addTo(self.nodeTabs)
			local imgSelect = SoraDGetChildByName(btnTaskTabs, "img_sel")
			imgSelect:setTag(i)
			imgSelect:setVisible(i == 1)
			if i == 1 then
				btnTaskTabs:setEnabled(false)
			end
			local txtTab = SoraDGetChildByName(btnTaskTabs, "text_tab")
			txtTab:setString(self:getCelebrationTaskDesByID(v))
			local imgEvent = SoraDGetChildByName(btnTaskTabs, "img_event_number1")
			imgEvent:setTag(v)
			imgEvent:setVisible(anniversaryCtrl:getMissionCompleteNumsByMissionSet(v) ~= 0)
			local txtEvent = SoraDGetChildByName(btnTaskTabs, "text_event_number")
			txtEvent:setString(anniversaryCtrl:getMissionCompleteNumsByMissionSet(v))
			table.insert(self.btnThreeTable, btnTaskTabs)
			table.insert(self.imgThreeTable, imgSelect)
			table.insert(self.txtThreeTable, txtTab)
			table.insert(self.txtEventTable, txtEvent)
			table.insert(self.imgEventTable, imgEvent)
		end
	end
end
function anniversaryCelebrationView:initFiveDaysTabs()
	self.txtDayTable, _ENV, self.imgDayTable, _ENV, self.btnFiveTable, _ENV = nil, nil, nil, nil, nil, nil
	for i = 1, 5 do
		local btnDaysTabs = self.btnFiveTabs:clone()
		btnDaysTabs:setPosition(cc.p((i - 1) * 128 + 63.5, self.nodeTabs:getPositionY() + 76))
		btnDaysTabs:setPressedActionEnabled(false)
		btnDaysTabs:setTag(i)
		btnDaysTabs:addTo(self.topNode, 5 - i + 1)
		local txtDays = SoraDGetChildByName(btnDaysTabs, "text_day")
		_ENV = cc.p((i - 1) * 128 + 63.5, self.nodeTabs:getPositionY() + 76)
		cc.p((i - 1) * 128 + 63.5, self.nodeTabs:getPositionY() + 76).count = i
		txtDays:setString(i18n("common_text_523", cc.p((i - 1) * 128 + 63.5, self.nodeTabs:getPositionY() + 76)))
		local spriteLock = SoraDGetChildByName(btnDaysTabs, "img_lock")
		if i <= self.day then
			spriteLock:setVisible(false)
			txtDays:setPositionX(65)
			if i == self.day then
				btnDaysTabs:loadTextureNormal("btn_alliance_choose.png", ccui.TextureResType.plistType)
				btnDaysTabs:setEnabled(false)
			end
		end
		local imgDay = SoraDGetChildByName(btnDaysTabs, "img_day_number1")
		imgDay:setVisible(anniversaryCtrl:getMissionCompleteNumsByDay(i) ~= 0)
		local txtDay = SoraDGetChildByName(btnDaysTabs, "text_day_num")
		txtDay:setString(anniversaryCtrl:getMissionCompleteNumsByDay(i))
		table.insert(self.imgDayTable, imgDay)
		table.insert(self.txtDayTable, txtDay)
		table.insert(self.btnFiveTable, btnDaysTabs)
	end
	local imageLine1 = ccui.ImageView:create("frame_queue_wordmap.png", ccui.TextureResType.plistType)
	imageLine1:setAnchorPoint(1, 0.5)
	imageLine1:setPosition(cc.p(320, self.nodeTabs:getPositionY() + 112))
	imageLine1:addTo(self.topNode)
	local imageLine2 = ccui.ImageView:create("frame_queue_wordmap.png", ccui.TextureResType.plistType)
	imageLine2:setAnchorPoint(1, 0.5)
	imageLine2:setPosition(cc.p(320, self.nodeTabs:getPositionY() + 112))
	imageLine2:setFlippedX(true)
	imageLine2:addTo(self.topNode)
	self.imageShadow:setPositionY(imageLine2:getPositionY() + 5)
end
function anniversaryCelebrationView:initGraduation()
	local pbSize = self.spriteLoadingBar:getContentSize()
	for i = 1, #graduation do
		local graduationCell = self.spriteGraduation:clone()
		graduationCell:setScale(0.8)
		graduationCell:setPosition(cc.p(graduation[i] / 100 * pbSize.width, 10))
		graduationCell:addTo(self.spriteLoadingBar)
		local txtNum = SoraDGetChildByName(graduationCell, "text_percent")
		txtNum:setString(graduation[i])
	end
end
function anniversaryCelebrationView:initDownScroll()
	self.downScroll:removeAllChildren()
	local missionSet = anniversaryCtrl:getMissionSetData(self.day)
	local scrollH = math.max(#missionSet[self.switchKey] * PANEL_HEIGHT, self.downScroll:getContentSize().height)
	self.downScroll:setInnerContainerSize(cc.size(self.downScroll:getContentSize().width, scrollH))
	for i = 1, #missionSet[self.switchKey] do
		local cell = self.panelContent:clone()
		cell:setPosition(cc.p(self.downScroll:getContentSize().width / 2, scrollH - (i - 1) * PANEL_HEIGHT))
		cell:addTo(self.downScroll)
		local txtTitle = SoraDGetChildByName(cell, "text_title")
		txtTitle:setString(self:getCelebrationTaskDesByID(missionSet[self.switchKey][i].taskID))
		local txtProgress = SoraDGetChildByName(cell, "text_progress_title")
		txtProgress:setString(i18n("common_text_3780"))
		local txtProgressVal = SoraDGetChildByName(cell, "text_progress_value")
		local strVal = string.format("%s/%s", SoraDConvertNumberWithUnit(missionSet[self.switchKey][i].curNum), SoraDConvertNumberWithUnit(missionSet[self.switchKey][i].conditionNum))
		txtProgressVal:setString(strVal)
		local rewards = self:getCelebrationTaskRewardByID(missionSet[self.switchKey][i].taskID)
		for k, v in pairs(rewards) do
			local single = SoraDCreatePanel("eventGeocentricCell")
			single:initData(rewards[k].rewardId, rewards[k].rewardNum)
			single:setClickDelegate(handler(self, self.singleCellClick))
			single:setPosition(cc.p((k - 1) * 85, 90))
			single:sendParentToButton(self)
			single:setScale(0.7)
			single:addTo(cell)
		end
		local btnOperate = SoraDGetChildByName(cell, "btn_operate")
		btnOperate:setTag(missionSet[self.switchKey][i].taskID * 100 + missionSet[self.switchKey][i].taskStatus)
		if missionSet[self.switchKey][i].taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_DOING then
			btnOperate:setTitleText(i18n("common_text_477"))
			btnOperate:loadTextureNormal("btn_yellow_small_01.png", ccui.TextureResType.plistType)
			btnOperate:loadTexturePressed("btn_yellow_small_02.png", ccui.TextureResType.plistType)
			btnOperate:setVisible(missionSet[self.switchKey][i].conditionType ~= anniversaryMissionType.LOGIN_DAY and missionSet[self.switchKey][i].conditionType ~= anniversaryMissionType.USE_SPEED_UP and missionSet[self.switchKey][i].conditionType ~= anniversaryMissionType.HARVEST_RESOURCE)
		elseif missionSet[self.switchKey][i].taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_COMPLETE then
			btnOperate:setTitleText(i18n("common_text_1146"))
		elseif missionSet[self.switchKey][i].taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_COMPLETE_DONE then
			btnOperate:setTitleText(i18n("common_text_1892"))
			btnOperate:setEnabled(false)
			btnOperate:getVirtualRenderer():setState(1)
		elseif missionSet[self.switchKey][i].taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_TIME_OUT then
			btnOperate:setVisible(false)
		end
	end
	self.downScroll:jumpToTop()
	self.txtActiveValue:setString(anniversaryCtrl:getPlayerActiveness())
	for i, v in ipairs(self.imgDayTable) do
		v:setVisible(anniversaryCtrl:getMissionCompleteNumsByDay(i) ~= 0)
		self.txtDayTable[i]:setString(anniversaryCtrl:getMissionCompleteNumsByDay(i))
	end
	for i, v in ipairs(self.imgEventTable) do
		v:setVisible(anniversaryCtrl:getMissionCompleteNumsByMissionSet(v:getTag()) ~= 0)
		self.txtEventTable[i]:setString(anniversaryCtrl:getMissionCompleteNumsByMissionSet(v:getTag()))
	end
end
function anniversaryCelebrationView:singleCellClick(pItem)
end
function anniversaryCelebrationView:jumpCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("anniversaryPackagePopView")
		panel:initData(self:getRechargeListDataByIndex(button:getTag()), button:getTag())
		panel:show()
	end
end
function anniversaryCelebrationView:btnPreCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:turnPage(false)
	end
end
function anniversaryCelebrationView:btnNextCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:turnPage(true)
	end
end
function anniversaryCelebrationView:panelTouchPadClick(panel, eventType)
	if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		local touchBeganPoint = panel:getTouchBeganPosition()
		local touchmovePoint = panel:getTouchEndPosition()
		if touchBeganPoint.x - touchmovePoint.x < -30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 100 then
			print("向右边滑动，-1")
			self:turnPage(false)
		elseif touchBeganPoint.x - touchmovePoint.x > 30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 100 then
			print("向左边滑动，+1")
			self:turnPage(true)
		end
	end
end
function anniversaryCelebrationView:runImageToTurnPage(target, actionForward)
	if not target then
		return
	end
	local posX = target:getPositionX()
	local posY = target:getPositionY()
	local seq
	if actionForward then
		_UPVALUE4_ = nil
		;(nil)[1] = cca.callFunc(function()
			self.panelPad:setEnabled(false)
			self.btnRight:setEnabled(false)
			self.btnLeft:setEnabled(false)
		end)
		;(nil)[2] = cca.moveTo(0.2, -320, posY)
		;(nil)[3] = cca.callFunc(function()
			target:setPositionX(960)
		end)
		;(nil)[4] = cca.moveTo(0.2, posX, posY)
		;(nil)[5] = cca.callFunc(function()
			self.panelPad:setEnabled(true)
			self.btnRight:setEnabled(true)
			self.btnLeft:setEnabled(true)
		end)
		;(nil)[6] = cca.callFunc(function()
			self.panelPad:setEnabled(true)
			self.btnRight:setEnabled(true)
			self.btnLeft:setEnabled(true)
		end)
		;(nil)[7] = cca.callFunc(function()
			self.panelPad:setEnabled(true)
			self.btnRight:setEnabled(true)
			self.btnLeft:setEnabled(true)
		end)
		seq = cca.seq(nil)
	else
		_UPVALUE4_ = nil
		;(nil)[1] = cca.callFunc(function()
			self.panelPad:setEnabled(false)
			self.btnRight:setEnabled(false)
			self.btnLeft:setEnabled(false)
		end)
		;(nil)[2] = cca.moveTo(0.2, 960, posY)
		;(nil)[3] = cca.callFunc(function()
			target:setPositionX(-320)
		end)
		;(nil)[4] = cca.moveTo(0.2, posX, posY)
		;(nil)[5] = cca.callFunc(function()
			self.panelPad:setEnabled(true)
			self.btnRight:setEnabled(true)
			self.btnLeft:setEnabled(true)
		end)
		;(nil)[6] = cca.callFunc(function()
			self.panelPad:setEnabled(true)
			self.btnRight:setEnabled(true)
			self.btnLeft:setEnabled(true)
		end)
		;(nil)[7] = cca.callFunc(function()
			self.panelPad:setEnabled(true)
			self.btnRight:setEnabled(true)
			self.btnLeft:setEnabled(true)
		end)
		seq = cca.seq(nil)
	end
	target:runAction(seq)
end
function anniversaryCelebrationView:turnPage(actionForward)
	if actionForward then
		self.activenessIndex = self.activenessIndex + 1
	else
		self.activenessIndex = self.activenessIndex - 1
	end
	if self.activenessIndex < 6 and self.activenessIndex > 0 then
		self:runImageToTurnPage(self.imgBox, actionForward)
		self:runImageToTurnPage(self.imgDiscount, actionForward)
		self:runImageToTurnPage(self.imgGold, actionForward)
	end
	if self.activenessIndex > totalShowNum then
		self.activenessIndex = totalShowNum
	elseif self.activenessIndex < 1 then
		self.activenessIndex = 1
	end
	if self.activenessIndex == 1 or self.activenessIndex == 2 then
		self.imgBox:setSpriteFrame("frame_xxwjq_box.png")
	elseif self.activenessIndex == 3 or self.activenessIndex == 4 then
		self.imgBox:setSpriteFrame("frame_xxwjq_bx_01.png")
	elseif self.activenessIndex == 5 then
		self.imgBox:setSpriteFrame("frame_xxwjq_bx_03.png")
	end
	local pbSize = self.spriteLoadingBar:getContentSize()
	print("wekjfwkjfwkjfe", self.activenessIndex, graduation[self.activenessIndex])
	self.spritePointer:setPositionX(graduation[self.activenessIndex] / 100 * pbSize.width + 5)
	self.btnLook:setTag(self.activenessIndex)
	self.txtActiveValue:setString(anniversaryCtrl:getPlayerActiveness())
	self.txtActiveMax:setString("/" .. self:getCelebrationActivenessMaxByIndex(self.activenessIndex))
	self.txtActiveMax:setPositionX(self.txtActiveValue:getPositionX() + self.txtActiveValue:getContentSize().width + 5)
	self.txtTitle:setString(self:getCelebrationPackageNameByIndex(self.activenessIndex))
	local maxValue = self:getCelebrationActivenessMaxByIndex(self.activenessIndex)
	if maxValue > anniversaryCtrl:getPlayerActiveness() then
		self.txtChance:setString(i18n("celebration_text_06"))
	else
		self.txtChance:setString(i18n("celebration_text_02"))
	end
	local totalData = self:getRechargeListDataByIndex(self.activenessIndex)
	if totalData then
		self.txtDiscount:setString(totalData.discount[2] .. "%")
		self.txtGold:setString("$" .. totalData.price)
		if not totalData.isCantBuy then
			self.btnLook:setTitleText(i18n("common_text_829"))
			self.btnLook:getVirtualRenderer():setState(0)
			self.btnLook:setEnabled(true)
		else
			self.btnLook:setTitleText(i18n("common_text_3833"))
			self.btnLook:setEnabled(false)
			self.btnLook:getVirtualRenderer():setState(1)
			self.txtChance:setString(i18n("celebration_text_05"))
		end
	end
end
function anniversaryCelebrationView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.ANNIVERSARY_CELEBRATION)
	end
end
function anniversaryCelebrationView:switchTabsClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		for i, v in ipairs(self.btnThreeTable) do
			self.imgThreeTable[i]:setVisible(v:getTag() == button:getTag())
			v:setEnabled(not self.imgThreeTable[i]:isVisible())
		end
		self.switchKey = button:getTag()
		self:initDownScroll()
	end
end
function anniversaryCelebrationView:switchButtonsClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:getTag() > anniversaryCtrl:getCurrentDayByLoginTime() then
			SoraDShowMsgTip(i18n("common_text_2274"))
		else
			for i, v in ipairs(self.btnFiveTable) do
				if i == button:getTag() then
					v:loadTextureNormal("btn_alliance_choose.png", ccui.TextureResType.plistType)
				else
					v:loadTextureNormal("btn_alliance_unchoose.png", ccui.TextureResType.plistType)
				end
				v:setEnabled(i ~= button:getTag())
			end
			for i, v in ipairs(self.btnThreeTable) do
				v:setVisible(false)
				self.imgThreeTable[i]:setVisible(false)
				self.txtThreeTable[i]:setString("")
				self.imgEventTable[i]:setVisible(false)
				self.txtEventTable[i]:setString("")
			end
			self.txtEventTable, _ENV, self.imgEventTable, _ENV, self.txtThreeTable, _ENV, self.imgThreeTable, _ENV, self.btnThreeTable, _ENV = ipairs(self.btnThreeTable)
			self.day = button:getTag()
			self:initThreeTaskTabs()
			for i, v in ipairs(self.btnThreeTable) do
				self.imgThreeTable[i]:setVisible(i == 1)
				if i == 1 then
					self.switchKey = v:getTag()
				end
			end
			self:initDownScroll()
		end
	end
end
function anniversaryCelebrationView:operateClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local taskStatus = button:getTag() % 100
		local taskID = math.floor(button:getTag() / 100)
		local conditionType = self:getCelebrationTaskConditionType(taskID)
		if taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_DOING then
			self:commonJumpToWeakGuide(conditionType)
		elseif taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_COMPLETE then
			anniversaryCtrl:sendCommitTaskMsg(taskID)
		elseif taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_COMPLETE_DONE then
		elseif taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_TIME_OUT then
		end
	end
end
function anniversaryCelebrationView:allGetClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		anniversaryCtrl:sendGetRewardsMsg()
	end
end
function anniversaryCelebrationView:refreshBuyState(target, data)
	local rechargeIndex = 1
	for i, v in ipairs(rechargeActivityCtrl:getAnniversaryPackageList()) do
		if data.rid == v.ID then
			rechargeIndex = i
			break
		end
	end
	local totalData = self:getRechargeListDataByIndex(rechargeIndex)
	if totalData and self.btnLook:getTag() == rechargeIndex then
		local maxValue = self:getCelebrationActivenessMaxByIndex(rechargeIndex)
		if maxValue > anniversaryCtrl:getPlayerActiveness() then
			self.txtChance:setString(i18n("celebration_text_06"))
		else
			self.txtChance:setString(i18n("celebration_text_02"))
		end
		if not totalData.extraData.isCantBuy then
			self.btnLook:setTitleText(i18n("common_text_829"))
			self.btnLook:getVirtualRenderer():setState(0)
			self.btnLook:setEnabled(true)
		else
			self.btnLook:setTitleText(i18n("common_text_3833"))
			self.btnLook:setEnabled(false)
			self.btnLook:getVirtualRenderer():setState(1)
			self.txtChance:setString(i18n("celebration_text_05"))
		end
	end
end
function anniversaryCelebrationView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIVERSARY_CELEBRATION) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function anniversaryCelebrationView:getCelebrationTaskRewardByID(taskID)
	local _ENV, rewardList
	for i, v in ipairs(celebrationTaskTable.data) do
		if taskID == v.taskID then
			_UPVALUE2_ = nil
			;(nil)[1] = "rewardId"
			;(nil)[2] = "rewardNum"
			rewardList = serviceFunctions.tableFormat(v.reward, nil)
			break
		end
	end
	return rewardList
end
function anniversaryCelebrationView:getCelebrationTaskDesByID(taskID)
	if celebrationTaskDesTable.data[taskID] then
		return i18n(celebrationTaskDesTable.data[taskID].TaskDes)
	else
		return "NA"
	end
end
function anniversaryCelebrationView:getCelebrationTaskConditionType(taskID)
	local conditionType = 1
	for i, v in ipairs(celebrationTaskTable.data) do
		if taskID == v.taskID then
			conditionType = v.conditionType
			break
		end
	end
	return conditionType
end
function anniversaryCelebrationView:getCelebrationActivenessMaxByIndex(index)
	if celebrationActivenessTable.data[index] then
		return celebrationActivenessTable.data[index].Unlockpoint
	else
		return 0
	end
end
function anniversaryCelebrationView:getCelebrationPackageNameByIndex(index)
	local rechargeID = 0
	if celebrationActivenessTable.data[index] then
		rechargeID = celebrationActivenessTable.data[index].RechargeID
	end
	local info = rechargeRead.getPageViewData(rechargeID)
	if info then
		return i18n(info.activeName)
	end
	return "NA"
end
function anniversaryCelebrationView:getRechargeListDataByIndex(index)
	local list = rechargeActivityCtrl:getAnniversaryPackageList()
	return list[index]
end
function anniversaryCelebrationView:commonJumpToWeakGuide(conditionType)
	SoraDRemoveAllPanelFromManager()
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	if conditionType == anniversaryMissionType.BUILD_UPGRADE then
		_ENV = nil
		;(nil).bid = BUILDID.CASTLE
		;(nil).lv = tonumber(castleBcell.info.lv)
		mildGuideManager:starMildByNewPlayerQuestID(missionTypeToNewPlayerType[conditionType], nil)
	elseif conditionType == anniversaryMissionType.MONSTERPALACE_HORN then
		uiManager:show("evilPalaceReadyView")
	elseif conditionType == anniversaryMissionType.RECRUIT_SOLDIERS then
		_ENV = nil
		;(nil).bid = BUILDID.CHARIOT_PLANT
		mildGuideManager:starMildByNewPlayerQuestID(missionTypeToNewPlayerType[conditionType], nil)
	else
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(missionTypeToNewPlayerType[conditionType], nil)
	end
end
return anniversaryCelebrationView
