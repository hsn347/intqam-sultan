local gametop = gModuleMgr.getObject("gametop")
local heroFestivalCtrl = gametop.playertop_:getModule("heroFestivalCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local heroFestivalCtrl = gametop.playertop_:getModule("heroFestivalCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local eventQuestRead = include("eventQuestRead")
local heroFestivalRead = include("heroFestivalRead")
local publicRead = include("publicRead")
local heroFestivalView = class("heroFestivalView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroFestivalView")
	end
	return target
end)
_ENV, _UPVALUE12_ = function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroFestivalView")
	end
	return target
end, "heroFestivalView"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroFestivalView")
	end
	return target
end).angle = 150
_ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroFestivalView")
	end
	return target
end).pos = cc.p(237, 312), cc.p(237, 312)
cc.p(237, 312).angle = 120
_ENV, cc.p(237, 312).pos = cc.p(216, 292), cc.p(216, 292)
cc.p(216, 292).angle = 90
_ENV, cc.p(216, 292).pos = cc.p(209, 263), cc.p(209, 263)
cc.p(209, 263).angle = 60
_ENV, cc.p(209, 263).pos = cc.p(218, 235), cc.p(218, 235)
cc.p(218, 235).angle = 30
_ENV, cc.p(218, 235).pos = cc.p(240, 215), cc.p(240, 215)
cc.p(240, 215).angle = 0
_ENV, cc.p(240, 215).pos = cc.p(264, 210), cc.p(264, 210)
cc.p(264, 210).angle = -30
_ENV, cc.p(264, 210).pos = cc.p(290, 215), cc.p(290, 215)
cc.p(290, 215).angle = -60
_ENV, cc.p(290, 215).pos = cc.p(310, 235), cc.p(310, 235)
cc.p(310, 235).angle = -90
_ENV, cc.p(310, 235).pos = cc.p(318, 263), cc.p(318, 263)
cc.p(318, 263).angle = -120
_ENV, cc.p(318, 263).pos = cc.p(310, 290), cc.p(310, 290)
cc.p(310, 290).angle = -150
_ENV, cc.p(310, 290).pos = cc.p(291, 310), cc.p(291, 310)
cc.p(291, 310).angle = -180
cc.p(291, 310).pos = cc.p(265, 320)
;("heroFestivalView")[1] = function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroFestivalView")
	end
	return target
end
;("heroFestivalView")[2] = cc.p(237, 312)
;("heroFestivalView")[3] = cc.p(216, 292)
;("heroFestivalView")[4] = cc.p(209, 263)
;("heroFestivalView")[5] = cc.p(218, 235)
;("heroFestivalView")[6] = cc.p(240, 215)
;("heroFestivalView")[7] = cc.p(264, 210)
;("heroFestivalView")[8] = cc.p(290, 215)
;("heroFestivalView")[9] = cc.p(310, 235)
;("heroFestivalView")[10] = cc.p(318, 263)
;("heroFestivalView")[11] = cc.p(310, 290)
local ("heroFestivalView")[12], selectAngleAndPos = cc.p(291, 310), "heroFestivalView"
function heroFestivalView:ctor()
	self:initControls()
	self:fitDevice()
	self:initEffect(false)
	self:initSelectEffect()
	self:initData()
end
function heroFestivalView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_HERO_FESTIVAL_DRAW_REFRESH", function(target, data)
		if data.reward then
			if self.isSkip then
				if table.nums(data.reward) == 1 then
					SoraDPopGainItem(data.reward[1].id, data.reward[1].count)
				else
					local rewardPanel = SoraDSearchPanelFromManagerByName("heroFestivalPopRewardView")
					if rewardPanel then
						rewardPanel:showRewardList()
						rewardPanel:initData(data.reward, self)
					else
						rewardPanel = SoraDCreatePanel("heroFestivalPopRewardView")
						rewardPanel:show()
					end
					rewardPanel:initData(data.reward, self)
				end
			else
				self:hideSelectEffect()
				if table.nums(data.reward) == 1 then
					local drawId = self:getDrawRewardId(data.reward[1].id, data.reward[1].count)
					self:startTurnTableDraw(drawId, data.reward[1].id, data.reward[1].count)
				else
					self.imgBgTurnTable:setRotation(0)
					local rewardPanel = SoraDSearchPanelFromManagerByName("heroFestivalPopRewardView")
					if rewardPanel then
						rewardPanel:removeFromParent()
					end
					local drawId = self:getDrawRewardIdForTen(data.reward[1].id)
					self:startTurnTableDraw(drawId, data.reward[1].id, data.reward[1].count, true)
					_UPVALUE3_ = self
					self[1] = cca.delay(11.0)
					self[2] = cca.callFunc(function()
						for i, v in ipairs(data.reward) do
							for j, m in ipairs(self.tableSelectEffect) do
								if m.id == v.id then
									m:setVisible(true)
								end
							end
						end
					end)
					self[3] = cca.delay(1.5)
					self[4] = cca.callFunc(function()
						local panel = SoraDCreatePanel("heroFestivalPopRewardView")
						panel:initData(data.reward, self)
						panel:show()
					end)
					self[5] = cca.callFunc(function()
						local panel = SoraDCreatePanel("heroFestivalPopRewardView")
						panel:initData(data.reward, self)
						panel:show()
					end)
					local seq = cca.seq(self)
					self:runAction(seq)
				end
			end
			self:initData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function heroFestivalView:initControls()
	self.nodeTurnTable = SoraDGetChildByName(self, "node_turntable")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgBg2 = SoraDGetChildByName(self, "Size_bg")
	self.panelBg = SoraDGetChildByName(self, "Panel_1")
	self.imgBg:setFillType(1)
	self.panelBg:setContentSize(cc.size(display.width, display.height))
	self.spPointer = SoraDGetChildByName(self, "frame_yxsd_zz_1")
	self.imgTimeBg = SoraDGetChildByName(self, "Image_140")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_bg")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	self.btnHelpTip = SoraDGetChildByName(self, "Button_help")
	self.btnOne = SoraDGetChildByName(self, "btn_one")
	self.btnTen = SoraDGetChildByName(self, "btn_ten")
	self.sprIcon = SoraDGetChildByName(self, "sprite_icon")
	self.txtNum = SoraDGetChildByName(self, "text_num")
	self.sprFrame1 = SoraDGetChildByName(self, "frame_ygg_line_01_1")
	self.sprFrame2 = SoraDGetChildByName(self, "frame_ygg_line_01_1_0")
	self.scroll = SoraDGetChildByName(self, "Top_Size_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("starRhapsodyTaskSingle")
	self.node_tp = SoraDGetChildByName(self, "Top_Node")
	self.imgBgTurnTable = SoraDGetChildByName(self, "frame_yxsd_zp2_224")
	self.txtOneGold = SoraDGetChildByName(self, "text_oneGold")
	self.txtTenGold = SoraDGetChildByName(self, "text_tenGold")
	self.txtOneIns = SoraDGetChildByName(self, "text_oneIns")
	self.txtTenIns = SoraDGetChildByName(self, "text_tenIns")
	self.imgGoldLeft = SoraDGetChildByName(self, "Image_gold_0")
	self.imgGoldRight = SoraDGetChildByName(self, "Image_gold")
	self.spGoldUp = SoraDGetChildByName(self, "sprite_icon")
	self.txtTime = SoraDGetChildByName(self, "text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeEndListener(function(...)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.txtTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	if SoraDGetDefaultLanguage() == "ru" then
		self.txtOneIns:setFontSize(18)
		self.txtTenIns:setFontSize(18)
	end
	self.txtResetTime = SoraDGetChildByName(self, "text_resetTime")
	self.txtResetTime = SoraDCreateTimerLabel(self, self.txtResetTime)
	self.txtResetTime:setTimeEndListener(function(...)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.txtResetTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("hero_ceremony_text_07", nil)
	end)
	self.panelTouch = SoraDGetChildByName(self, "Panel_touch")
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.HERO_FESTIVAL)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txtTime:setString(SoraDConvertSecondToString(leftTime))
		self.txtTime:beginTime(leftTime)
	end
	local remainTime = serviceFunctions.getTodayRemainTime()
	self.txtResetTime:setString(SoraDConvertSecondToString(remainTime))
	self.txtResetTime:beginTime(remainTime)
	self.ccs_title:setTitle(i18n("activity_name_175"))
	_ENV = i18n("activity_name_175")
	_ENV, _ENV, i18n("activity_name_175").tabNum = i18n("activity_name_175")
	i18n("activity_name_175").title = i18n("hero_ceremony_btn_01")
	_ENV, i18n("activity_name_175")[1], i18n("activity_name_175").handle = i18n("activity_name_175")
	i18n("activity_name_175").title = i18n("hero_ceremony_btn_02")
	i18n("activity_name_175").tabsetArray, i18n("activity_name_175")[2], i18n("activity_name_175").handle = i18n("activity_name_175")
	self.ccs_tab:initView(i18n("activity_name_175"))
	self.btnHelpTip:addTouchEventListener(handler(self, self.buttonHelpCallBack))
	self.btnOne:addTouchEventListener(handler(self, self.buttonOneCallBack))
	self.btnTen:addTouchEventListener(handler(self, self.buttonTenCallBack))
	math.randomseed(os.time())
	self.oneGold = heroFestivalRead:getSingleCost()
	self.tenGold = heroFestivalRead:getTenCost()
	self.txtOneGold:setString(self.oneGold)
	self.txtTenGold:setString(self.tenGold)
	_ENV = os.time()
	os.time().num = 1
	self.txtOneIns:setString(i18n("hero_ceremony_btn_03", os.time()))
	_ENV = i18n("hero_ceremony_btn_03", os.time())
	i18n("hero_ceremony_btn_03", os.time()).num = 10
	self.txtTenIns:setString(i18n("hero_ceremony_btn_03", i18n("hero_ceremony_btn_03", os.time())))
	self.imgGoldLeft:loadTexture("8203.png", ccui.TextureResType.plistType)
	self.imgGoldRight:loadTexture("8203.png", ccui.TextureResType.plistType)
	self.spGoldUp:setSpriteFrame("8203.png")
	self.spGoldUp:setScale(0.3)
	self.rewards = heroFestivalRead:getRewardsInfo()
	for i, v in ipairs(self.rewards) do
		SoraDGetChildByName(self, "icon_hero_" .. i):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
		SoraDGetChildByName(self, "icon_hero_" .. i):setScale(2.0)
		SoraDGetChildByName(self, "icon_hero_" .. i):addTouchEventListener(function(btn, eventType)
			if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
				SoraDCloseCommonTips()
			elseif eventType == ccui.TouchEventType.began then
				SoraDPlaySound()
				SoraDShowCommonTips(btn, v.id)
			end
		end)
		local text = SoraDGetChildByName(self, "text_turnTable_" .. i)
		text:setString(v.count)
		SoraDGetChildByName(self, "icon_hero_" .. i):setRotation(text:getRotation())
	end
	self.tableSelectEffect, _ENV, self.activityID = gActivityTimeActivityID.HERO_FESTIVAL, gActivityTimeActivityID.HERO_FESTIVAL, gActivityTimeActivityID.HERO_FESTIVAL
	self.Com_skip = fguiHelper.createObject("CommonUI", "UI_Com_skip")
	self.Com_skip:setPosition(cc.p(-300, 310))
	self.Com_skip:addTo(self.nodeTurnTable, 9)
	_ENV = self.nodeTurnTable
	self.nodeTurnTable.byUID = true
	self.isSkip = SoraDConfigGet("Game:heroFestival:switch~bool", self.nodeTurnTable) or false
	self.Com_skip:initData(self.isSkip, nil, handler(self, self.onClickSkip))
end
function heroFestivalView:onClickSkip(ret)
	self.isSkip = ret
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:heroFestival:switch~bool", self.isSkip, nil)
end
function heroFestivalView:fitDevice()
	print("wjkebrewrfewmb", display.height)
	local offset = 0
	if display.height > 960 then
		self.nodeTurnTable:setPositionY(-530)
	elseif math.floor(display.height) == 853 then
		self.nodeTurnTable:setScale(0.85)
		self.effectHeroFestival:setScale(0.85)
		self.effectHeroFestival2:setScale(0.85)
		self.nodeTurnTable:setPositionY(-430)
		offset = 10
		self.imgBg2:setPositionY(-150)
	end
	if math.floor(display.height) > 1200 and math.floor(display.height) < 1300 then
		self.nodeTurnTable:setPositionY(-580)
	end
	if math.floor(display.height) == 1315 then
		self.nodeTurnTable:setPositionY(-650)
	end
	if device.isIphoneXMode() then
		self.nodeTurnTable:setPositionY(-650)
	end
	self.effectHeroFestival:setPosition(self.nodeTurnTable:getPositionX(), self.nodeTurnTable:getPositionY() - 55 + offset)
	self.effectHeroFestival2:setPosition(self.nodeTurnTable:getPositionX(), self.nodeTurnTable:getPositionY() - 55 + offset)
end
function heroFestivalView:startSwingEffect()
	_UPVALUE15_ = nil
	;(nil)[1] = cca.rotateBy(0.1, 35)
	;(nil)[2] = cca.rotateBy(0.1, -35)
	;(nil)[3] = cca.rotateBy(0.1, 35)
	;(nil)[4] = cca.rotateBy(0.1, -35)
	;(nil)[5] = cca.rotateBy(0.1, 35)
	;(nil)[6] = cca.rotateBy(0.1, -35)
	;(nil)[7] = cca.rotateBy(0.1, 35)
	;(nil)[8] = cca.rotateBy(0.1, -35)
	;(nil)[9] = cca.rotateBy(0.1, 35)
	;(nil)[10] = cca.rotateBy(0.1, -35)
	;(nil)[11] = cca.rotateBy(0.2, 35)
	;(nil)[12] = cca.rotateBy(0.2, -35)
	;(nil)[13] = cca.rotateBy(0.2, 35)
	;(nil)[14] = cca.rotateBy(0.2, -35)
	;(nil)[15] = cca.rotateBy(0.3, 35)
	;(nil)[16] = cca.rotateBy(0.4, -35)
	;(nil)[17] = cca.rotateBy(0.4, -35)
	;(nil)[18] = cca.rotateBy(0.4, -35)
	local seq = cca.seq(nil)
	self.spPointer:runAction(seq)
end
function heroFestivalView:initEffect(isHide)
	if not isHide then
		if self.effectHeroFestival then
			SoraDResetEffectNode(self.effectHeroFestival)
			self.effectHeroFestival.action:gotoFrameAndPlay(0, 104, true)
		else
			self.effectHeroFestival = SoraDCreatAnimationEx("Node_Effect_yxsd", nil, true)
			self.effectHeroFestival:setPosition(self.nodeTurnTable:getPositionX(), self.nodeTurnTable:getPositionY() - 55)
			self.effectHeroFestival:addTo(self.node_tp, -1)
		end
		if self.effectHeroFestival2 then
			SoraDResetEffectNode(self.effectHeroFestival2)
			self.effectHeroFestival2.action:gotoFrameAndPlay(0, 104, true)
		else
			self.effectHeroFestival2 = SoraDCreatAnimationEx("Node_Effect_yxsd2", nil, true)
			local img1 = SoraDGetChildByName(self.effectHeroFestival2, "dh_Tex_yxsd_002_01")
			local img2 = SoraDGetChildByName(self.effectHeroFestival2, "dh_Tex_yxsd_002_02")
			SoraDMixtureGLONE(img1)
			SoraDMixtureGLONE(img2)
			self.effectHeroFestival2:setPosition(self.nodeTurnTable:getPositionX(), self.nodeTurnTable:getPositionY() - 55)
			self.effectHeroFestival2:addTo(self.node_tp)
		end
	else
		if self.effectHeroFestival then
			self.effectHeroFestival:removeFromParent()
			self.effectHeroFestival = nil
		end
		if self.effectHeroFestival2 then
			self.effectHeroFestival2:removeFromParent()
			self.effectHeroFestival2 = nil
		end
	end
end
function heroFestivalView:initSelectEffect()
	for i, v in ipairs(self.rewards) do
		local selectEffect = SoraDCreatAnimationEx("Node_Effect_yxsd3", nil, true)
		local img1 = SoraDGetChildByName(selectEffect, "dh_Tex_yxsd_006_01")
		local img2 = SoraDGetChildByName(selectEffect, "dh_Tex_yxsd_006_02")
		local img3 = SoraDGetChildByName(selectEffect, "dh_Tex_yxsd_007")
		SoraDMixtureGLONE(img1)
		SoraDMixtureGLONE(img2)
		SoraDMixtureGLONE(img3)
		selectEffect:setPosition(selectAngleAndPos[i].pos)
		selectEffect:setRotation(selectAngleAndPos[i].angle)
		selectEffect:addTo(self.imgBgTurnTable, 10)
		selectEffect:setVisible(false)
		table.insert(self.tableSelectEffect, selectEffect)
		self.tableSelectEffect[i].id = v.id
	end
end
function heroFestivalView:hideSelectEffect()
	for i, v in ipairs(self.tableSelectEffect) do
		v:setVisible(false)
	end
end
function heroFestivalView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function heroFestivalView:initData(target, data)
	SoraDCloseLoading(self)
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).activityID = self.activityID
	;(nil).mainView = self
	self.scroll:updateScrollView(cc.size(640, 170), self.taskList, 1, nil)
	local ticketCount = backpackCtrl:getItemCount(HERO_FESTIVAL_TICKET)
	_ENV = nil
	;(nil).num = string.formatnumberthousands(ticketCount)
	self.txtNum:setString(i18n("hero_ceremony_text_05", nil))
	self.txtOneGold:setColor(ticketCount < self.oneGold and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 0))
	self.txtTenGold:setColor(ticketCount < self.tenGold and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 0))
	local canGet = false
	local redNum = 0
	for i, v in ipairs(self.taskList) do
		if v.taskStatus == gBtnTargetStatusDef.GET then
			canGet = true
			redNum = redNum + 1
		end
	end
	self.ccs_tab:setRedPointState(2, canGet)
	self.ccs_tab:setBigRedPointCount(2, redNum)
end
function heroFestivalView:getDrawRewardId(id, count)
	local drawIndex = 1
	for i, v in ipairs(self.rewards) do
		if id == v.id and count == v.count then
			drawIndex = i
			break
		end
	end
	return drawIndex
end
function heroFestivalView:getDrawRewardIdForTen(id)
	local drawIndex = 1
	for i, v in ipairs(self.rewards) do
		if id == v.id then
			drawIndex = i
			break
		end
	end
	return drawIndex
end
function heroFestivalView:switchButton(isFestival)
	self.nodeTurnTable:setVisible(isFestival)
	self.btnOne:setVisible(isFestival)
	self.btnTen:setVisible(isFestival)
	self.sprIcon:setVisible(isFestival)
	self.txtNum:setVisible(isFestival)
	self.sprFrame1:setVisible(isFestival)
	self.sprFrame2:setVisible(isFestival)
	self:initEffect(not isFestival)
	self.scroll:setVisible(not isFestival)
	self.txtTime:setVisible(isFestival)
	self.txtResetTime:setVisible(not isFestival)
	self.imgBg2:setVisible(isFestival)
	if isFestival then
		self:fitDevice()
	end
end
function heroFestivalView:startTurnTableDraw(stopId, itemID, itemCount, isTen)
	local totalCount = 12
	local roundCountMin = 5
	local roundCountMax = 8
	local singleAngle = 360 / totalCount
	local offsetAngle = 5
	if stopId == nil or stopId > totalCount then
		stopId = math.random(1, totalCount)
	end
	local angleMin = (stopId - 1) * singleAngle
	local roundCount = math.random(roundCountMin, roundCountMax)
	local angleTotal = -360 * roundCount + angleMin + math.random(offsetAngle, singleAngle - offsetAngle)
	print("stopId:", stopId)
	print("angleMin:", angleMin)
	print("roundCount:", roundCount)
	print("angleTotal:", angleTotal)
	self.imgBgTurnTable:setRotation(0)
	self.btnOne:setEnabled(false)
	self.btnTen:setEnabled(false)
	_UPVALUE5_ = self.btnTen
	self.btnTen[1] = cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))
	self.btnTen[2] = cca.callFunc(function()
		self.spPointer:stopAllActions()
		self.spPointer:setRotation(0)
		self.tableSelectEffect[stopId]:setVisible(true)
	end)
	self.btnTen[3] = cca.delay(0.7)
	self.btnTen[4] = cca.callFunc(function()
		SoraDPopGainItem(itemID, itemCount)
	end)
	self.btnTen[5] = cca.delay(1.0)
	self.btnTen[6] = cca.callFunc(function()
		self.btnOne:setEnabled(true)
		self.btnTen:setEnabled(true)
	end)
	self.btnTen[7] = cca.callFunc(function()
		self.btnOne:setEnabled(true)
		self.btnTen:setEnabled(true)
	end)
	local seq = cca.seq(self.btnTen)
	if isTen then
		_UPVALUE3_ = cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))
		cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))[1] = cc.EaseExponentialOut:create(cc.RotateBy:create(11.0, angleTotal))
		cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))[2] = cca.callFunc(function()
			self.spPointer:stopAllActions()
			self.spPointer:setRotation(0)
		end)
		cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))[3] = cca.delay(1.5)
		cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))[4] = cca.callFunc(function()
			self.btnOne:setEnabled(true)
			self.btnTen:setEnabled(true)
		end)
		cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))[5] = cca.callFunc(function()
			self.btnOne:setEnabled(true)
			self.btnTen:setEnabled(true)
		end)
		cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))[6] = cca.callFunc(function()
			self.btnOne:setEnabled(true)
			self.btnTen:setEnabled(true)
		end)
		seq = cca.seq((cc.EaseExponentialOut:create(cc.RotateBy:create(3.2, angleTotal))))
	end
	self.imgBgTurnTable:runAction(seq)
	self:startSwingEffect()
	if self.tips then
		self.tips:setRotation(-angleTotal)
	end
end
function heroFestivalView:isTasksAllFinished()
	local isFinished = true
	for i, v in ipairs(self.taskList) do
		if v.taskStatus == gBtnTargetStatusDef.GO then
			isFinished = false
			break
		end
	end
	return isFinished
end
function heroFestivalView:onFestivalClick(tag, name)
	self:switchButton(true)
end
function heroFestivalView:onTaskClick(tag, name)
	self:switchButton(false)
end
function heroFestivalView:buttonOneCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.spPointer:setVisible(true)
		local ticketCount = backpackCtrl:getItemCount(HERO_FESTIVAL_TICKET)
		if ticketCount >= self.oneGold then
			heroFestivalCtrl:sendReqturnTableDrawTimesMsg(1)
			SoraDPlaySound("heroFestival", "FeastofHeroes_danci")
		elseif self:isTasksAllFinished() then
			SoraDShowMsgTip(i18n("hero_ceremony_text_02"))
		else
			SoraDShowMsgBox(i18n("hero_ceremony_text_03"), i18n("common_text_477"), i18n("common_text_185"), function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					self.ccs_tab:switchTab(2)
					self:switchButton(false)
				end
			end)
		end
	end
end
function heroFestivalView:buttonTenCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.spPointer:setVisible(false)
		local ticketCount = backpackCtrl:getItemCount(HERO_FESTIVAL_TICKET)
		if ticketCount >= self.tenGold then
			heroFestivalCtrl:sendReqturnTableDrawTimesMsg(10)
			SoraDPlaySound("heroFestival", "FeastofHeroes_duoci")
		elseif ticketCount >= self.oneGold then
			local multiTimes = math.floor(ticketCount / self.oneGold)
			_ENV = nil
			;(nil).num1 = ticketCount
			;(nil).num2 = multiTimes
			SoraDShowMsgBox(i18n("hero_ceremony_text_04", nil), i18n("common_text_204"), i18n("common_text_185"), function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					heroFestivalCtrl:sendReqturnTableDrawTimesMsg(multiTimes)
					SoraDPlaySound("heroFestival", "FeastofHeroes_duoci")
				end
			end)
		elseif self:isTasksAllFinished() then
			SoraDShowMsgTip(i18n("hero_ceremony_text_02"))
		else
			SoraDShowMsgBox(i18n("hero_ceremony_text_03"), i18n("common_text_477"), i18n("common_text_185"), function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					self.ccs_tab:switchTab(2)
					self:switchButton(false)
				end
			end)
		end
	end
end
function heroFestivalView:buttonHelpCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("hero_ceremony_text_01", nil))
	end
end
return heroFestivalView
