local gametop = gModuleMgr.getObject("gametop")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local palaceInfoRead = include("palaceInfoRead")
local radianceWarUtil = include("radianceWarUtil")
local radianceWarDef = include("radianceWarDef")
local RADIANCE_WAR_STATE = radianceWarDef.RADIANCE_WAR_STATE
local radianceWarMainView = class("radianceWarMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarMainView")
	end
	return target
end)
function handlerCheckAlliance(obj, method)
	return function(button, type)
		if type == ccui.TouchEventType.ended and not allianceMgr:hasJoinAlliance() then
			SoraDShowMsgTip(i18n("notice_0066"))
			return
		end
		return method(obj, button, type)
	end
end
function radianceWarMainView:ctor()
	self.tableCastle, RADIANCE_WAR_STATE, self.curState = RADIANCE_WAR_STATE.NONE, RADIANCE_WAR_STATE.NONE, RADIANCE_WAR_STATE.NONE
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeTitle:setTitle(i18n("brightWar_text_21"))
	self.imgBig = SoraDGetChildByName(self, "Image_big")
	self.nodeMatch = SoraDGetChildByName(self, "Node_match")
	self.btnStarShop = SoraDGetChildByName(self, "Button_starShop")
	self.btnPrize = SoraDGetChildByName(self, "Button_prize")
	self.nodeInWar = SoraDGetChildByName(self, "Node_inWar")
	self.btnExploitShop = SoraDGetChildByName(self, "Button_exploitShop")
	self.btnHospital = SoraDGetChildByName(self, "Button_hospital")
	self.nodeHospital = SoraDGetChildByName(self, "Node_hospital")
	self.btnPrize2 = SoraDGetChildByName(self, "Button_prize2")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.nodeBtn = SoraDGetChildByName(self, "Node_btn")
	self.btnEnter = SoraDGetChildByName(self, "Button_enter")
	self.btnMap = SoraDGetChildByName(self, "Button_map")
	self.btnSituation = SoraDGetChildByName(self, "Button_situation")
	self.centerNode = SoraDGetChildByName(self, "Center_node")
	self.situationRedIcon = SoraDGetChildByName(self.btnSituation, "red_Icon")
	self.nodeRank = SoraDGetChildByName(self, "Top_nodeRank")
	self.nodeBuff = SoraDGetChildByName(self, "Top_nodeBuff")
	self.btnTask = SoraDGetChildByName(self, "Button_task")
	self.taskRedIcon = SoraDGetChildByName(self.btnTask, "red_Icon")
	self.labelTask = SoraDGetChildByName(self, "Text_task")
	self.btnRank = SoraDGetChildByName(self, "Button_rank")
	self.btnRank:setTag(2)
	self.labelLog = SoraDGetChildByName(self, "Text_log")
	self.btnLog = SoraDGetChildByName(self, "Button_log")
	self.labelLog:setString(i18n("common_text_285"))
	self.labelRes = SoraDGetChildByName(self, "Text_res")
	self.btnRes = SoraDGetChildByName(self, "Button_res")
	self.labelRes:setString(i18n("brightWar_text_163"))
	self.btnBuff = SoraDGetChildByName(self, "Button_buff")
	self.labeBuff = SoraDGetChildByName(self, "Text_buff")
	self.labeBuff:setString(i18n("activity_name_9001263"))
	self.imgRed = SoraDGetChildByName(self.btnBuff, "Image_redPoint")
	self.labBuffNum = SoraDGetChildByName(self.btnBuff, "Text_redPointInt")
	self.labelRank = SoraDGetChildByName(self, "Text_rank")
	self.topNode = SoraDGetChildByName(self, "Top_node")
	self.btnHistory = SoraDGetChildByName(self, "Top_Button_history")
	self.spriteState = SoraDGetChildByName(self, "Sprite_state")
	self.spriteStateWar = SoraDGetChildByName(self, "Sprite_state_war")
	self.labelState = SoraDGetChildByName(self, "Text_state")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	SoraDChangeTextToHtml(self.labelTime)
	self.labelTime:setTextColor(cc.c3b(255, 200, 100))
	self.labelTime:setColor(cc.c3b(255, 255, 255))
	self.btnStarShop:setTitleText(i18n("brightWar_title_09"))
	self.startShopRedIcon = SoraDGetChildByName(self.btnStarShop, "red_Icon")
	self.btnPrize:setTitleText(i18n("common_text_1235"))
	self.btnExploitShop:setTitleText(i18n("brightWar_title_09"))
	self.exploitShopRedIcon = SoraDGetChildByName(self.btnExploitShop, "red_Icon")
	self.btnPrize2:setTitleText(i18n("common_text_1235"))
	self.btnMap:setTitleText(i18n("brightWar_text_22"))
	self.btnSituation:setTitleText(i18n("brightWar_title_11"))
	self.labelTask:setString(i18n("brightWar_title_12"))
	self.labelRank:setString(i18n("brightWar_title_13"))
	self.btnHistory:setTitleText(i18n("common_text_3032"))
	if display.height < 1000 then
		self.centerNode:setScale(display.height / 1200)
		self.nodeBtn:setScale(display.height / 1200)
		if display.height < 860 then
			self.centerNode:setScale(display.height / 1400)
			self.centerNode:setPositionY(self.centerNode:getPositionY() - 10)
		end
	else
		self.centerNode:setScale(display.height > 1200 and 0.95 or 0.8)
	end
	self.btnEnter:addTouchEventListener(handlerCheckAlliance(self, self.btnEnterCickCallBack))
	self.btnRank:addTouchEventListener(handlerCheckAlliance(self, self.btnEnterCickCallBack))
	self.btnTask:addTouchEventListener(handlerCheckAlliance(self, self.btnTaskCickCallBack))
	self.btnLog:addTouchEventListener(handlerCheckAlliance(self, self.btnLogCickCallBack))
	self.btnRes:addTouchEventListener(handlerCheckAlliance(self, self.btnResCickCallBack))
	self.btnBuff:addTouchEventListener(handlerCheckAlliance(self, self.btnBuffCickCallBack))
	self.btnHistory:addTouchEventListener(handlerCheckAlliance(self, self.btnHistoryCickCallBack))
	self.btnSituation:addTouchEventListener(handler(self, self.btnSituationCickCallBack))
	self.btnMap:addTouchEventListener(handler(self, self.btnMapCickCallBack))
	self.btnExploitShop:addTouchEventListener(handler(self, self.btnExploitShopCickCallBack))
	self.btnPrize:addTouchEventListener(handler(self, self.btnPrizeCickCallBack))
	self.btnPrize2:addTouchEventListener(handler(self, self.btnPrizeCickCallBack))
	self.btnStarShop:addTouchEventListener(handler(self, self.btnStarShopCickCallBack))
	self.btnHospital:addTouchEventListener(handler(self, self.btnHospitalCickCallBack))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpCickCallBack))
	SoraDAutoSizeButtonText(self.btnStarShop)
	SoraDAutoSizeButtonText(self.btnPrize)
	SoraDAutoSizeButtonText(self.btnPrize2)
	SoraDAutoSizeButtonText(self.btnExploitShop)
	SoraDAutoSizeButtonText(self.btnHospital)
	SoraDAutoSizeButtonText(self.btnHelp)
	SoraDAutoSizeButtonText(self.btnSituation)
	SoraDAutoSizeButtonText(self.btnEnter)
	SoraDAutoSizeButtonText(self.btnRank)
	SoraDAutoSizeButtonText(self.btnMap)
	SoraDAutoSizeButtonText(self.btnTask)
	SoraDAutoSizeButtonText(self.btnRes)
	SoraDAutoSizeButtonText(self.btnHistory)
	self.btnReward = SoraDGetChildByName(self.nodeBuff, "Button_reward")
	SoraDGetChildByName(self.btnReward, "Text_reward"):setString(i18n("brightWar_text_226"))
	self.btnReward:addTouchEventListener(handler(self, self.btnRewardCallBack))
	self:initCastleNode()
	self:initEffect()
	self:updateData()
	self:updateRedPoint()
	self:updateBtnBuff()
end
function radianceWarMainView:initCastleNode()
	_ENV = nil
	;(nil)[1] = cc.p(160, 160)
	;(nil)[2] = cc.p(-160, 160)
	;(nil)[3] = cc.p(160, -160)
	local (nil)[4], pos = cc.p(-160, -160), nil
	for i = 1, 4 do
		local single = SoraDCreatAnimationEx("radianceWarMainCitySingle", nil, false, nil, 0, 35)
		self.tableCastle[i] = single
		single:addTo(self.centerNode)
		single.btnCityBg = SoraDGetChildByName(single, "Button_cityBg")
		single.btnCityBg:setTouchEnabled(false)
		single.nodeCity = SoraDGetChildByName(single, "Node_city")
		single.imgCity = SoraDGetChildByName(single, "Image_city")
		self:addClip(single)
		single.nodeKindom = SoraDGetChildByName(single, "Node_kindom")
		single.labelKindom = SoraDGetChildByName(single, "Text_kindom")
		single.imgMine = SoraDGetChildByName(single, "Sprite_mine")
		single.nodeMine = SoraDGetChildByName(single, "Node_mine")
		single.imgOther = SoraDGetChildByName(single, "Image_other")
		single.imgWait = SoraDGetChildByName(single, "Image_wait")
		single.labelWait = SoraDGetChildByName(single, "Text_wait")
		single.spriteWin = SoraDGetChildByName(single, "Sprite_win")
		single.nodeLost = SoraDGetChildByName(single, "Node_lost")
		single.imgCity:setScale(1.53)
		single.labelWait:setString(i18n("remains_btn_08"))
		single:setPosition(pos[i])
	end
end
function radianceWarMainView:addClip(node)
	local clip = cc.ClippingNode:create()
	clip:setAnchorPoint(cc.p(0.5, 0.5))
	local stencil = display.newSprite("#frame_gmzz_yhyk_black.png")
	stencil:setContentSize(stencil:getContentSize().width * 1.88, stencil:getContentSize().height * 1.88)
	clip:setStencil(stencil)
	clip:setInverted(false)
	clip:setAlphaThreshold(0)
	node.imgCity:removeFromParent()
	clip:addChild(node.imgCity)
	clip:addTo(node.nodeCity)
end
function radianceWarMainView:initEffect()
	self:updateStateInfo()
end
function radianceWarMainView:updateData()
	self.preState = self.curState
	self.curState = radianceActivityCtrl:getWarStatus()
	self:updateView()
end
function radianceWarMainView:updateView()
	self:hiddleAll()
	self.btnReward:setVisible(false)
	self.btnReward:setPositionY(830)
	if self.curState == RADIANCE_WAR_STATE.MATCH then
		print("radianceWarMainView--状态----匹配中")
		self:waitMatch()
	elseif self.curState == RADIANCE_WAR_STATE.RESULT then
		print("radianceWarMainView--状态----匹配后")
		radianceWarCtrl:radianceWarMatchResult()
		self:result()
	elseif self.curState == RADIANCE_WAR_STATE.BATTLE then
		print("radianceWarMainView--状态----比赛阶段")
		radianceWarCtrl:radianceWarMatchResult()
		self:battle()
	elseif self.curState == RADIANCE_WAR_STATE.FINISH then
		print("radianceWarMainView--状态----赛季结束")
		radianceWarCtrl:radianceWarMatchResult()
		self:finish()
	end
	if self.preState == RADIANCE_WAR_STATE.MATCH and self.curState == RADIANCE_WAR_STATE.RESULT then
		self:addVSEffectFirst()
	else
		self:addVSEffect()
	end
	self:updateStateInfo()
end
function radianceWarMainView:updateRedPoint()
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local retShop = activityExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
	self.exploitShopRedIcon:setVisible(retShop)
	self.startShopRedIcon:setVisible(retShop)
	local retTask_1 = radianceActivityCtrl:getTaskReceiveStatusAndNum(1)
	local retTask_2 = radianceActivityCtrl:getTaskReceiveStatusAndNum(2)
	self.taskRedIcon:setVisible(retTask_1 or retTask_2)
	local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
	local ret, num = lightShiningCtrl:getReceiveStatusAndNum()
	self.imgRed:setVisible(ret)
	self.labBuffNum:setVisible(0 < num)
	self.labBuffNum:setString(num)
	local hasUnReadResWarLog = radianceWarCtrl:isHasUnReadResWarLog()
	self.situationRedIcon:setVisible(hasUnReadResWarLog)
end
function radianceWarMainView:updateHospital()
	local isInCure = radianceWarUtil.isWarHospitalCureing()
	if isInCure then
		self.btnHospital:setTitleText("")
		if not self.txtHospital then
			self.txtHospital = SoraDGetChildByName(self, "Text_hospital_time")
			self.txtHospital = SoraDCreateTimerLabel(self, self.txtHospital)
			local txtHospitalTitle = SoraDGetChildByName(self, "Text_hospital_title")
			txtHospitalTitle:setString(i18n("brightWar_text_81"))
		end
		self.nodeHospital:setVisible(true)
		local lefttime = radianceWarUtil.getWarHospitalCureTime()
		self.txtHospital:beginTime(lefttime)
	else
		self.btnHospital:setTitleText(i18n("brightWar_title_14"))
		self.nodeHospital:setVisible(false)
		if self.txtHospital then
			self.txtHospital:endTime()
		end
	end
end
function radianceWarMainView:updateHospitalQueue(target, data)
	if data.qtype and data.qtype == gQueueTypeDef.radiance_war_hostpital_queue then
		self:updateHospital()
	end
end
function radianceWarMainView:hiddleAll()
	self.nodeMatch:setVisible(false)
	self.nodeInWar:setVisible(false)
	self.nodeRank:setVisible(false)
	self.btnBuff:setPositionY(830)
	self.btnEnter:setVisible(false)
	self.btnMap:setVisible(false)
	self.btnHistory:setVisible(false)
	self.btnSituation:setVisible(false)
end
function radianceWarMainView:openTimeUp()
	local lefttime = radianceWarUtil.getWarStatusTime(self.curState)
	local numColor = cc.c3b(255, 255, 255)
	radianceWarUtil = self
	radianceWarUtil, radianceWarUtil, self.time = lefttime, SoraDConvertSecondToString(lefttime), SoraDConvertSecondToString(lefttime)
	SoraDConvertSecondToString(lefttime).time, lefttime.color = lefttime, numColor
	local strScore = i18n_html(self:getStateTimeStr(), self, (SoraDConvertSecondToString(lefttime)))
	self.labelTime:setString(strScore)
end
function radianceWarMainView:getStateTimeStr()
	local str = radianceWarUtil.getWarStatusTimeStr(self.curState)
	return str
end
function radianceWarMainView:updateCastleNode(i, data)
	local single = self.tableCastle[i]
	single.spriteWin:setVisible(false)
	single.nodeLost:setVisible(false)
	single.imgWait:setVisible(false)
	single.nodeKindom:setVisible(false)
	single.imgCity:setVisible(false)
	single.imgMine:setVisible(false)
	single.nodeMine:setVisible(false)
	single.imgOther:setVisible(true)
	single.imgCity:getVirtualRenderer():setState(0)
	single.btnCityBg:getVirtualRenderer():setState(0)
	self:stopActionByTag(9999 + i)
	self:setAllEffectVisibleFalse(single)
	local action
	local delayTime = 0
	local baseScale = 1.53
	if self.preState == RADIANCE_WAR_STATE.NONE then
		delayTime = 0.4166666666666667
	end
	if data.isMine then
		single.imgCity:setVisible(true)
		single.nodeKindom:setVisible(true)
		single.imgMine:setVisible(true)
		single.nodeMine:setVisible(true)
		single.labelKindom:setColor(cc.c3b(255, 212, 11))
		single.labelKindom:setString(worldMapDefine.getKingdomName(true))
		local offsetdata = palaceInfoRead.getImgOffset(KWKingdomCtrl:getKingdomCastaleModel())
		single.imgCity:loadTexture(palaceInfoRead.getImg(KWKingdomCtrl:getKingdomCastaleModel()), ccui.TextureResType.plistType)
		single.imgCity:setPosition(offsetdata.pos.x + 120, offsetdata.pos.y + 160)
		single.imgCity:setScale(offsetdata.scale * baseScale)
		_ENV = single.imgCity
		single.imgCity[1] = cca.delay(delayTime)
		single.imgCity[2] = cca.callFunc(function()
			self:runActionMatchFinishMine(single)
		end)
		single.imgCity[3] = cca.callFunc(function()
			self:runActionMatchFinishMine(single)
		end)
		action = cca.seq(single.imgCity)
	elseif data.data then
		single.imgCity:setVisible(true)
		single.nodeKindom:setVisible(true)
		single.labelKindom:setString(data.data.kingdomName)
		single.labelKindom:setColor(data.data.kid == gametop.playertop_:getKingdomID() and cc.c3b(255, 212, 11) or cc.c3b(186, 169, 129))
		single.imgMine:setVisible(data.data.kid == gametop.playertop_:getKingdomID())
		single.nodeMine:setVisible(data.data.kid == gametop.playertop_:getKingdomID())
		local offsetdata = palaceInfoRead.getImgOffset(data.data.kingdomPlace)
		single.imgCity:loadTexture(palaceInfoRead.getImg(data.data.kingdomPlace), ccui.TextureResType.plistType)
		single.imgCity:setPosition(offsetdata.pos.x + 120, offsetdata.pos.y + 160)
		single.imgCity:setScale(offsetdata.scale * baseScale)
		if data.data.isWin ~= nil then
			if data.data.isWin then
				_ENV = single.imgCity
				single.imgCity[1] = cca.delay(delayTime)
				single.imgCity[2] = cca.callFunc(function()
					print("播放获胜者特效")
					self:runActionWinner(single)
				end)
				single.imgCity[3] = cca.callFunc(function()
					print("播放获胜者特效")
					self:runActionWinner(single)
				end)
				action = cca.seq(single.imgCity)
				single:setLocalZOrder(999)
			else
				single:setLocalZOrder(99)
				single.btnCityBg:getVirtualRenderer():setState(1)
				single.imgCity:getVirtualRenderer():setState(1)
			end
			single.spriteWin:setVisible(data.data.isWin)
			single.nodeLost:setVisible(not data.data.isWin)
		else
			_ENV = single.nodeLost
			single.nodeLost[1] = cca.delay(delayTime)
			single.nodeLost[2] = cca.callFunc(function()
				print("播放匹配结束特效")
				self:runActionMatchFinish(single)
			end)
			single.nodeLost[3] = cca.callFunc(function()
				print("播放匹配结束特效")
				self:runActionMatchFinish(single)
			end)
			action = cca.seq(single.nodeLost)
		end
	else
		single.imgWait:setVisible(true)
		_ENV = single.imgWait
		single.imgWait[1] = cca.delay(0.4166666666666667)
		single.imgWait[2] = cca.callFunc(function()
			print("播放等待匹配特效")
			self:runActionWaitMatch(single)
		end)
		single.imgWait[3] = cca.callFunc(function()
			print("播放等待匹配特效")
			self:runActionWaitMatch(single)
		end)
		single.imgWait[4] = cca.callFunc(function()
			print("播放等待匹配特效")
			self:runActionWaitMatch(single)
		end)
		action = cca.seq(single.imgWait)
	end
	if action then
		action:setTag(9999 + i)
		self:runAction(action)
	end
end
function radianceWarMainView:waitMatch()
	self.btnHistory:setVisible(true)
	self.nodeMatch:setVisible(true)
	self.btnMap:setVisible(true)
	self.btnMap:setPositionY(self.btnEnter:getPositionY())
	self:updateCastleNodes()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function radianceWarMainView:result()
	self.btnHistory:setVisible(true)
	self.nodeMatch:setVisible(true)
	self.btnMap:setVisible(true)
	self.btnMap:setPositionY(self.btnEnter:getPositionY())
	self:updateCastleNodes()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function radianceWarMainView:battle()
	self.btnHistory:setVisible(true)
	self.nodeInWar:setVisible(true)
	self.btnMap:setVisible(true)
	self.btnMap:setPositionY(115)
	self.btnSituation:setVisible(true)
	self.btnEnter:setVisible(true)
	self.btnEnter:setTag(1)
	self.nodeRank:setVisible(true)
	self.btnBuff:setPositionY(630)
	if worldMapDefine.isInRadiance() then
		self.btnEnter:setTitleText(i18n("common_text_4256"))
		self.btnEnter:setBright(true)
	else
		local isEnter = radianceWarUtil.checkEnterWarByTime()
		self.btnEnter:setBright(isEnter)
		self.btnEnter:setTitleText(i18n("common_text_3318"))
	end
	self.btnReward:setVisible(true)
	self.btnReward:setPositionY(630)
	self:updateCastleNodes()
	self:updateHospital()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function radianceWarMainView:updateStateInfo()
	if self.initState then
		self.spriteState:setVisible(self.curState ~= RADIANCE_WAR_STATE.BATTLE)
		self.spriteStateWar:setVisible(self.curState == RADIANCE_WAR_STATE.BATTLE)
	else
		self.spriteState:setVisible(false)
		self.spriteStateWar:setVisible(false)
	end
	if self.curState == RADIANCE_WAR_STATE.BATTLE then
		if radianceWarUtil.checkEnterWarByTime() then
			self.labelState:setString(i18n("common_text_1446"))
			self.labelState:setColor(cc.c3b(239, 1, 1))
		elseif not radianceWarUtil.getWarBattleEnd() then
			self.labelState:setString(i18n("common_text_4210"))
			self.labelState:setColor(cc.c3b(94, 235, 61))
		else
			self.labelState:setString(i18n("brightWar_text_124"))
			self.labelState:setColor(cc.c3b(94, 235, 61))
		end
	else
		self.labelState:setString(i18n("common_text_4210"))
		self.labelState:setColor(cc.c3b(94, 235, 61))
	end
	self.spriteState:setPositionX(self.labelState:getPositionX() + SoraDFSign(0.5 * self.labelState:getContentSize().width + 30))
	self.spriteStateWar:setPositionX(self.labelState:getPositionX() + SoraDFSign(0.5 * self.labelState:getContentSize().width + 30))
end
function radianceWarMainView:finish()
	self.btnMap:setVisible(true)
	self.btnMap:setPositionY(115)
	self.btnEnter:setVisible(true)
	self.btnEnter:setTitleText(i18n("brightWar_title_13"))
	self.btnEnter:setTag(2)
	self.btnEnter:setBright(true)
	self.nodeMatch:setVisible(true)
	self.btnHistory:setVisible(true)
	self.btnReward:setVisible(true)
	self:updateCastleNodes()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function radianceWarMainView:updateCastleNodes()
	if self.curState == RADIANCE_WAR_STATE.MATCH then
		for i, v in ipairs(self.tableCastle) do
			if i == 1 then
				RADIANCE_WAR_STATE = nil
				;(nil).isMine = true
				if nil then
					goto lbl_18
				end
			end
			RADIANCE_WAR_STATE = nil
			::lbl_18::
			self:updateCastleNode(i, nil)
		end
	elseif self.curState == RADIANCE_WAR_STATE.FINISH then
		local matchData = radianceWarCtrl:getMatchData()
		for i, v in ipairs(self.tableCastle) do
			RADIANCE_WAR_STATE = nil
			;(nil).data = matchData[i]
			self:updateCastleNode(i, nil)
		end
	else
		local matchData = radianceWarCtrl:getMatchData()
		for i, v in ipairs(self.tableCastle) do
			RADIANCE_WAR_STATE = nil
			;(nil).data = matchData[i]
			self:updateCastleNode(i, nil)
		end
	end
end
function radianceWarMainView:btnStarShopCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarShopView"):show()
	end
end
function radianceWarMainView:btnPrizeCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarAwardView"):show()
	end
end
function radianceWarMainView:btnExploitShopCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarShopView"):show()
	end
end
function radianceWarMainView:btnHospitalCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local isInCure = radianceWarUtil.isWarHospitalCureing()
		if isInCure then
			local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
			local speedUpItemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.CURE_WAR)
			if 0 < #speedUpItemList then
				SoraDShowSpeedUpByItemBox(gQueueTypeDef.radiance_war_hostpital_queue)
			else
				SoraDShowSpeedUpByItemBox(gQueueTypeDef.radiance_war_hostpital_queue)
				SoraDShowMsgTip(i18n("brightWar_text_48"))
			end
		else
			uiManager:show("HospitalView"):setLV(nil, gKingdomClassType.radiance)
		end
	end
end
function radianceWarMainView:btnHelpCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.RADIANCE_WAR)
	end
end
function radianceWarMainView:btnSituationCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarSituationView"):show()
	end
end
function radianceWarMainView:btnEnterCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:getTag() == 2 then
			SoraDCreatePanel("radianceWarIntegralView"):show()
		elseif worldMapDefine.isInRadiance() then
			radianceWarUtil.quitWar()
		else
			radianceWarUtil.enterWar()
		end
	end
end
function radianceWarMainView:btnMapCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curState == RADIANCE_WAR_STATE.BATTLE or self.curState == RADIANCE_WAR_STATE.FINISH then
			if allianceMgr:hasJoinAlliance() then
				local kingdomMapCtrl = _G.SoraDGetCtrl("kingdomMapCtrl")
				_ENV = nil
				;(nil).from = "radianceWarMainView"
				kingdomMapCtrl:reqAllianceMember(radianceActivityCtrl:getWarMapId(), nil, nil)
				SoraDShowLoading()
			else
				local radianceWarMapView = SoraDCreatePanelByFixName("radianceWarMapView")
				radianceWarMapView:show()
				radianceWarMapView:setEnterType("radianceWarMainView")
			end
		else
			local radianceWarInitMapView = SoraDCreatePanelByFixName("radianceWarInitMapView")
			radianceWarInitMapView:show()
		end
	end
end
function radianceWarMainView:btnLogCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		radianceWarUtil.openRadianceWarView()
	end
end
function radianceWarMainView:btnResCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarResAmberMine"):show()
	end
end
function radianceWarMainView:btnBuffCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDGetCastleLv() < CASTLE_LV40_LIMITED then
			_ENV = nil
			;(nil).lv = 1
			local lv = i18n("common_text_1948", nil)
			_ENV = nil
			;(nil).num = lv
			SoraDShowMsgTip(i18n("common_text_1795", nil))
		else
			local isOpen = clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, true)
			if isOpen then
				SoraDCreatePanel("eventLightShiningView"):show()
			end
		end
	end
end
function radianceWarMainView:btnTaskCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarTaskMainView"):show()
	end
end
function radianceWarMainView:btnHistoryCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarHistoryView"):show()
	end
end
function radianceWarMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_MATCH_BACK", handler(self, self.updateCastleNodes))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_STATUS_ACTIVITY", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW", handler(self, self.updateHospital))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateHospitalQueue))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateEventCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_RESOURCE_MAP_MEMBERS", handler(self, self.serverMessage_LeagueMembersInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(target, data)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
end
function radianceWarMainView:updateEventCenter()
	self:updateBtnBuff()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityShowCtrl:getStateByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY) == gActivityState.CLOSE then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function radianceWarMainView:updateBtnBuff()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local isOpen = clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY)
	self.btnBuff:setVisible(isOpen)
end
function radianceWarMainView:serverMessage_LeagueMembersInfo(target, data)
	if not data.clientData or data.clientData.from ~= "radianceWarMainView" then
		return
	end
	SoraDCloseLoading()
	local radianceWarMapView = SoraDCreatePanelByFixName("radianceWarMapView")
	radianceWarMapView:show()
	radianceWarMapView:setEnterType("radianceWarMainView")
	local _ENV, memberArray = radianceWarMapView.setEnterType, radianceWarMapView.setEnterType
	if data and data.data then
		memberArray = radianceWarMapView:computerMemberArray(data and data.data)
	end
	radianceWarMapView:setLeagueMembersInfo(memberArray)
end
function radianceWarMainView:setAllEffectVisibleFalse(target)
	_UPVALUE6_ = nil
	;(nil)[1] = "winner_One_Effect"
	;(nil)[2] = "winner_Repeat_Effect"
	;(nil)[3] = "match_Success_One_Effect"
	;(nil)[4] = "match_Finish_Effect"
	;(nil)[5] = "match_Wait_Effect"
	;(nil)[6] = "match_Finish_Mine"
	for i, v in ipairs(nil) do
		local tmp = SoraDGetChildByName(target, v)
		if tmp then
			tmp:stopAllActions()
			tmp:setVisible(false)
		end
	end
end
function radianceWarMainView:runActionWinner(target)
	if self.preState == RADIANCE_WAR_STATE.BATTLE and self.curState == RADIANCE_WAR_STATE.FINISH then
		_UPVALUE2_ = nil
		;(nil)[1] = cca.callFunc(function()
			self:runActionWinnerOnece(target)
		end)
		;(nil)[2] = cca.delay(0.3333333333333333)
		;(nil)[3] = cca.callFunc(function()
			local winnerRepeat = SoraDGetChildByName(target, "winner_Repeat_Effect")
			winnerRepeat:setVisible(true)
			self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_001"), 0, 1)
			self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_002"), 0, 1)
			self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Texture_xrqlfx_004"), 0.2, 0.7)
			self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_001_2"), 0.3, 1)
		end)
		;(nil)[4] = cca.callFunc(function()
			local winnerRepeat = SoraDGetChildByName(target, "winner_Repeat_Effect")
			winnerRepeat:setVisible(true)
			self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_001"), 0, 1)
			self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_002"), 0, 1)
			self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Texture_xrqlfx_004"), 0.2, 0.7)
			self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_001_2"), 0.3, 1)
		end)
		self:runAction(cca.seq(nil))
	else
		local winnerRepeat = SoraDGetChildByName(target, "winner_Repeat_Effect")
		winnerRepeat:setVisible(true)
		self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_001"), 0, 1)
		self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_002"), 0, 1)
		self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Texture_xrqlfx_004"), 0.2, 0.7)
		self:runActionFade(SoraDGetChildByName(winnerRepeat, "G_dh_Tex_gmzz_001_2"), 0.3, 1)
	end
end
function radianceWarMainView:runActionFade(target, from, to)
	target:setOpacity(255 * from)
	_UPVALUE1_ = target
	target[1] = cca.fadeTo(1, to)
	target[2] = cca.fadeTo(1, from)
	target[3] = cca.fadeTo(1, from)
	target[4] = cca.fadeTo(1, from)
	local action = cca.seq(target)
	target:runAction(cca.repeatForever(action))
end
function radianceWarMainView:runActionWinnerOnece(target)
	SoraDGetChildByName(target, "winner_One_Effect"):setVisible(true)
	target.action:gotoFrameAndPlay(40, 70, false)
end
function radianceWarMainView:runActionSuccessOnece(target)
	SoraDGetChildByName(target, "match_Success_One_Effect"):setVisible(true)
	target.action:gotoFrameAndPlay(40, 90, false)
end
function radianceWarMainView:runActionMatchFinish(target)
	if self.preState == RADIANCE_WAR_STATE.MATCH and self.curState == RADIANCE_WAR_STATE.RESULT and not target.imgMine:isVisible() then
		_UPVALUE2_ = nil
		;(nil)[1] = cca.callFunc(function()
			self:runActionSuccessOnece(target)
		end)
		;(nil)[2] = cca.delay(1)
		;(nil)[3] = cca.callFunc(function()
			local finishFrame = SoraDGetChildByName(target, "match_Finish_Effect")
			finishFrame:setVisible(true)
			finishFrame:setOpacity(0.2)
			target = nil
			;(nil)[1] = cca.fadeTo(0.8333333333333334, 0.5)
			;(nil)[2] = cca.fadeTo(0.8333333333333334, 0.2)
			;(nil)[3] = cca.fadeTo(0.8333333333333334, 0.2)
			;(nil)[4] = cca.fadeTo(0.8333333333333334, 0.2)
			finishFrame:runAction(cca.repeatForever(cca.seq(nil)))
		end)
		;(nil)[4] = cca.callFunc(function()
			local finishFrame = SoraDGetChildByName(target, "match_Finish_Effect")
			finishFrame:setVisible(true)
			finishFrame:setOpacity(0.2)
			target = nil
			;(nil)[1] = cca.fadeTo(0.8333333333333334, 0.5)
			;(nil)[2] = cca.fadeTo(0.8333333333333334, 0.2)
			;(nil)[3] = cca.fadeTo(0.8333333333333334, 0.2)
			;(nil)[4] = cca.fadeTo(0.8333333333333334, 0.2)
			finishFrame:runAction(cca.repeatForever(cca.seq(nil)))
		end)
		;(nil)[5] = cca.callFunc(function()
			local finishFrame = SoraDGetChildByName(target, "match_Finish_Effect")
			finishFrame:setVisible(true)
			finishFrame:setOpacity(0.2)
			target = nil
			;(nil)[1] = cca.fadeTo(0.8333333333333334, 0.5)
			;(nil)[2] = cca.fadeTo(0.8333333333333334, 0.2)
			;(nil)[3] = cca.fadeTo(0.8333333333333334, 0.2)
			;(nil)[4] = cca.fadeTo(0.8333333333333334, 0.2)
			finishFrame:runAction(cca.repeatForever(cca.seq(nil)))
		end)
		;(nil)[6] = cca.callFunc(function()
			local finishFrame = SoraDGetChildByName(target, "match_Finish_Effect")
			finishFrame:setVisible(true)
			finishFrame:setOpacity(0.2)
			target = nil
			;(nil)[1] = cca.fadeTo(0.8333333333333334, 0.5)
			;(nil)[2] = cca.fadeTo(0.8333333333333334, 0.2)
			;(nil)[3] = cca.fadeTo(0.8333333333333334, 0.2)
			;(nil)[4] = cca.fadeTo(0.8333333333333334, 0.2)
			finishFrame:runAction(cca.repeatForever(cca.seq(nil)))
		end)
		self:runAction(cca.seq(nil))
	elseif not target.imgMine:isVisible() then
		local finishFrame = SoraDGetChildByName(target, "match_Finish_Effect")
		finishFrame:setVisible(true)
		finishFrame:setOpacity(0.2)
		_ENV = cca.seq(nil)
		cca.seq(nil)[1] = cca.fadeTo(0.8333333333333334, 0.5)
		cca.seq(nil)[2] = cca.fadeTo(0.8333333333333334, 0.2)
		cca.seq(nil)[3] = cca.fadeTo(0.8333333333333334, 0.2)
		cca.seq(nil)[4] = cca.fadeTo(0.8333333333333334, 0.2)
		finishFrame:runAction(cca.repeatForever(cca.seq(cca.seq(nil))))
	else
		self:runActionMatchFinishMine(target)
	end
end
function radianceWarMainView:runActionMatchFinishMine(target)
	SoraDGetChildByName(target, "match_Finish_Mine"):setVisible(true)
	target.action:gotoFrameAndPlay(40, 240, true)
end
function radianceWarMainView:runActionWaitMatch(target)
	local matchWaitEffect = SoraDGetChildByName(target, "match_Wait_Effect")
	matchWaitEffect:setVisible(true)
	target.action:gotoFrameAndPlay(40, 140, true)
end
function radianceWarMainView:addVSEffectFirst()
	SoraDGetChildByName(self.centerNode, "Node_VS_Effect"):setLocalZOrder(99999)
	if not self.nodeVSEffect then
		self.nodeVSEffect = SoraDCreatAnimationEx("radianceWarEffectVS", nil, false)
		self.nodeVSEffect:addTo(SoraDGetChildByName(self.centerNode, "Node_VS_Effect"), 1)
	end
	self.nodeVSEffect:setVisible(true)
	SoraDGetChildByName(self.nodeVSEffect, "Node_Repeat"):setVisible(false)
	if self.nodeVSEffect.action and tolua.cast(self.nodeVSEffect.action, "cc.Action") then
		self.nodeVSEffect.action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			if frameEvent and frameEvent == "BEGINREPEAT" then
				self:addVSEffect()
			end
		end)
	end
	SoraDGetChildByName(self.nodeVSEffect, "et_Par_gmzz_003_01"):resetSystem()
	SoraDGetChildByName(self.nodeVSEffect, "et_Par_gmzz_003_02"):resetSystem()
	self.nodeVSEffect.action:gotoFrameAndPlay(0, 45, false)
end
function radianceWarMainView:addVSEffect()
	if not self.nodeVSEffect then
		self.nodeVSEffect = SoraDCreatAnimationEx("radianceWarEffectVS", nil, false)
		self.nodeVSEffect.action:gotoFrameAndPause(45)
		SoraDGetChildByName(self.nodeVSEffect, "et_Par_gmzz_003_01"):stopSystem()
		SoraDGetChildByName(self.nodeVSEffect, "et_Par_gmzz_003_02"):stopSystem()
		self.nodeVSEffect:addTo(SoraDGetChildByName(self.centerNode, "Node_VS_Effect"), 1)
	end
	SoraDGetChildByName(self.nodeVSEffect, "Node_Repeat"):setVisible(true)
	if self.vsShow then
		return
	end
	local frames = display.newFrames("dh_Tex_XL_gmzz06_0%.2d.png", 0, 15)
	local animation = display.newAnimation(frames, 1.5 / #frames)
	SoraDGetChildByName(self.nodeVSEffect, "G_dh_Tex_XL_gmzz06_01"):playAnimationForever(animation)
	local frameImage_1 = SoraDGetChildByName(self.nodeVSEffect, "G_dh_Tex_XL_gmzz06_02")
	_UPVALUE1_ = nil
	;(nil)[1] = cca.animate(animation)
	;(nil)[2] = cca.rotateBy(10, -360)
	;(nil)[3] = cca.rotateBy(10, -360)
	;(nil)[4] = cca.rotateBy(10, -360)
	;(nil)[5] = cca.rotateBy(10, -360)
	frameImage_1:runAction(cca.repeatForever(cca.seq(nil)))
	local frame_2 = SoraDGetChildByName(self.nodeVSEffect, "G_dh_Tex_gmzz_010")
	frame_2:setOpacity(51.0)
	_UPVALUE1_ = cca.repeatForever(cca.seq(nil))
	cca.repeatForever(cca.seq(nil))[1] = cca.fadeTo(0.8333333333333334, 1)
	cca.repeatForever(cca.seq(nil))[2] = cca.fadeTo(0.8333333333333334, 0.2)
	cca.repeatForever(cca.seq(nil))[3] = cca.fadeTo(0.8333333333333334, 0.2)
	cca.repeatForever(cca.seq(nil))[4] = cca.fadeTo(0.8333333333333334, 0.2)
	frame_2:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
	local frame_3 = SoraDGetChildByName(self.nodeVSEffect, "G_dh_Tex_XL_gmzz05")
	local frames_2 = display.newFrames("dh_Tex_XL_gmzz05_0%.2d.png", 0, 13)
	local animation_2 = display.newAnimation(frames_2, 1.5 / #frames_2)
	frame_3:playAnimationForever(animation_2, 2.25)
	self.vsShow = true
end
function radianceWarMainView:btnRewardCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendaryKingAwardView")
		panel:setWarType(gKingdomClassType.radiance)
		panel:show()
	end
end
return radianceWarMainView
