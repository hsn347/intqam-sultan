local gametop = gModuleMgr.getObject("gametop")
local knightsChargeCtrl = gametop.playertop_:getModule("knightsChargeCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local knightsChargeMainView = class("knightsChargeMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("knightsChargeMainView")
	end
	return target
end)
function knightsChargeMainView:ctor()
	_UPVALUE3_, self.isHideCurrentSceneView = nil, true
	_UPVALUE4_, self.ocxNum, (nil)[1] = nil, nil, "icon_ranking_1.png"
	_UPVALUE4_, self.ocxNum, (nil)[2] = nil, nil, "icon_ranking_2.png"
	_UPVALUE4_, self.ocxNum, (nil)[3] = nil, nil, "icon_ranking_3.png"
	self.boxImgs, (nil)[1] = nil, "icon_KingGroupbuy_lv1_small.png"
	self.boxImgs, (nil)[2] = nil, "icon_KingGroupbuy_lv2_small.png"
	self.boxImgs, (nil)[3] = nil, "icon_KingGroupbuy_lv3_small.png"
	self.boxImgs, (nil)[4] = nil, "icon_KingGroupbuy_lv4_small.png"
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_bg")
	self.commonFramTitle_node:setTitle(i18n("mail_title_40"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.nodeLoad = SoraDGetChildByName(self, "Top_Node_load")
	self.nodePerson = SoraDGetChildByName(self, "Top_Node_person")
	self.nodeAlliance = SoraDGetChildByName(self, "Top_Node_alliance")
	self.btnBox = SoraDGetChildByName(self, "Button_price")
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.nodeProgress = SoraDGetChildByName(self, "Node_progress")
	self.txtQuestProgress = SoraDGetChildByName(self, "Text_questProgress")
	self.panelLordSingle = SoraDGetChildByName(self, "Panel_lordSingle")
	self.panelAllianceSingle = SoraDGetChildByName(self, "Panel_allianceSingle")
	self.imgBanner = SoraDGetChildByName(self, "Image_banner")
	self.imgBanner:loadTexture("bg_activity_9001126.png", ccui.TextureResType.plistType)
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.scrollPerson = SoraDGetChildByName(self, "ScrollView_person")
	self.scrollAlliance = SoraDGetChildByName(self, "ScrollView_alliance")
	self.nodeSelfPerson = SoraDGetChildByName(self, "Node_selfPerson")
	self.nodeSelfAlliance = SoraDGetChildByName(self, "Node_selfAlliance")
	local nodeHeight = self.nodePerson:getPositionY()
	self.scrollProgress = SoraDGetChildByName(self, "ScrollView_load")
	self.scrollPerson = include("dynamicScroll").new(self.scrollPerson)
	self.scrollAlliance = include("dynamicScroll").new(self.scrollAlliance)
	self.scrollPerson:setContentSize(cc.size(display.width, nodeHeight - 190))
	self.scrollAlliance:setContentSize(cc.size(display.width, nodeHeight - 190))
	self.scrollProgress:setContentSize(cc.size(display.width, nodeHeight))
	self.scrollAlliance:setPositionY(-25)
	self.scrollPerson:setPositionY(-25)
	self.btnPersonPrice = SoraDGetChildByName(self, "Button_personPrice")
	self.btnAlliancePrice = SoraDGetChildByName(self, "Button_alliancePrice")
	self.btnPersonPrice:setPositionY(-(nodeHeight - 40))
	self.btnAlliancePrice:setPositionY(-(nodeHeight - 40))
	self.btnPersonPrice:addTouchEventListener(handler(self, self.btnPersonPriceClick))
	self.btnAlliancePrice:addTouchEventListener(handler(self, self.btnAlliancePriceClick))
	self.btnPersonPrice:setTitleText(i18n("common_text_2194"))
	self.btnAlliancePrice:setTitleText(i18n("common_text_2194"))
	self.nodeSelfPerson:setPositionY(-nodeHeight + 80)
	self.nodeSelfAlliance:setPositionY(-nodeHeight + 80)
	self.txtNoPersonalRecord = SoraDGetChildByName(self, "Text_noPersonalRecord")
	self.txtNnoAllianceRecord = SoraDGetChildByName(self, "Text_noAllianceRecord")
	self.txtNoPersonalRecord:setPositionY(-nodeHeight / 2 + 80)
	self.txtNnoAllianceRecord:setPositionY(-nodeHeight / 2 + 80)
	self.txtNoPersonalRecord:setString(i18n("common_text_1464"))
	self.txtNnoAllianceRecord:setString(i18n("common_text_1464"))
	if not allianceMgr:hasJoinAlliance() then
		self.nodeSelfAlliance:setVisible(false)
		self.scrollAlliance:setContentSize(cc.size(display.width, nodeHeight - 110))
		self.txtNnoAllianceRecord:setPositionY(-nodeHeight / 2)
	end
	self.nodeProgressContent = SoraDGetChildByName(self, "Node_progressContent")
	local sH = math.max(590, nodeHeight)
	self.scrollProgress:setInnerContainerSize(cc.size(display.width, sH))
	self.nodeProgressContent:setPositionY(sH)
	self.btnGoto = SoraDGetChildByName(self, "Button_goto")
	self.btnGoto:addTouchEventListener(handler(self, self.btnGotoClick))
	self.btnGoto:setTitleText(i18n("common_btn_19"))
	self.txtFightNum = SoraDGetChildByName(self, "Text_fightNum")
	SoraDGetChildByName(self, "Text_eventTitle"):setString(i18n("mail_title_40"))
	SoraDGetChildByName(self, "Text_contextTitle"):setString(i18n("rides_text_10"))
	SoraDGetChildByName(self, "Text_context"):setString(i18n("rides_text_11"))
	SoraDGetChildByName(self, "Text_eventTip"):setString(i18n("rides_text_13"))
	SoraDGetChildByName(self, "Text_questTitle"):setString(i18n("task_name_01"))
	SoraDGetChildByName(self, "Text_allianceint"):setString(i18n("common_text_032"))
	SoraDGetChildByName(self, "Text_alliancename"):setString(i18n("common_text_171"))
	SoraDGetChildByName(self, "Text_alliancerank"):setString(i18n("common_text_3054"))
	SoraDGetChildByName(self, "Text_personint"):setString(i18n("common_text_2195"))
	SoraDGetChildByName(self, "Text_personname"):setString(i18n("common_text_2037"))
	SoraDGetChildByName(self, "Text_personrank"):setString(i18n("common_text_3053"))
	self.btns = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	_ENV = "CCS_commonTabBtn_btns"
	;("CCS_commonTabBtn_btns").tabNum = 3
	_ENV, _ENV, ("CCS_commonTabBtn_btns").defaultClick = i18n("common_text_3053")
	i18n("common_text_3053").title = i18n("mail_title_40")
	i18n("common_text_3053").handle = handler(self, self.btnClickCallBack)
	i18n("common_text_3053").fontSize = 22
	i18n("common_text_3053").tag = 1
	_ENV, i18n("common_text_3053")[1], i18n("common_text_3053").name = i18n("common_text_3053")
	i18n("common_text_3053").title = i18n("rides_title_01")
	i18n("common_text_3053").handle = handler(self, self.btnClickCallBack)
	i18n("common_text_3053").fontSize = 22
	i18n("common_text_3053").tag = 2
	_ENV, i18n("common_text_3053")[2], i18n("common_text_3053").name = i18n("common_text_3053")
	i18n("common_text_3053").title = i18n("rides_title_02")
	i18n("common_text_3053").handle = handler(self, self.btnClickCallBack)
	i18n("common_text_3053").fontSize = 22
	i18n("common_text_3053").tag = 3
	;("CCS_commonTabBtn_btns").tabsetArray, i18n("common_text_3053")[3], i18n("common_text_3053").name = i18n("common_text_3053")
	self.btns:initView("CCS_commonTabBtn_btns")
	_ENV = i18n("common_text_3053")
	i18n("common_text_3053").delay = 0.0
	i18n("common_text_3053").onComplete = function()
		self:initData()
	end
	transition.execute(self, nil, i18n("common_text_3053"))
end
function knightsChargeMainView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_KNIGHTSCHARGE_ALLREFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KNIGHTSCHARGE_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KNIGHTSCHARGE_PERSONALRANK", handler(self, self.initScrollPerson))
	SoraDAddMessage(self, "MESSAGE_SERVER_KNIGHTSCHARGE_ALLIANCERANK", handler(self, self.initScrollAlliance))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
end
function knightsChargeMainView:initData(...)
	self.myData = knightsChargeCtrl:getKnightsChargeData()
	self.boxData = knightsChargeCtrl.localClass.getBoxData()
	self:initView()
end
function knightsChargeMainView:initView(...)
	self:initTimer()
	self:initProgressBar()
	self:initTabPoint()
end
function knightsChargeMainView:initTabPoint(...)
	self.btns:setRedPointState(1, knightsChargeCtrl:isAnyBoxCanReceive())
end
function knightsChargeMainView:initTimer(...)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local eventTimer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.KNIGHTS_CHARGE)
	local stime = activityShowCtrl:getBeginTimeSecond(gActivityTimeActivityID.KNIGHTS_CHARGE)
	local etime = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.KNIGHTS_CHARGE)
	local timeTick = eventTimer.timerNode.timer:getRemainTime()
	self.txtTime:setTimeLast(function(str)
		_ENV = nil
		;(nil).time = str
		local ret = os.date("%Y.%m.%d", stime) .. "-" .. os.date("%Y.%m.%d", etime) .. "\n" .. i18n("common_text_607", nil)
		return ret
	end)
	self.txtTime:beginTime(timeTick)
end
function knightsChargeMainView:initScrollPerson(target, redata)
	SoraDCloseLoading(self.scrollPerson)
	local list = redata.rankList
	self.personalData = redata.myRank
	self:doPersonSingle(-1, self.personalData, self.nodeSelfPerson)
	if not self.firstInitScrollPerson then
		self.scrollPerson:init(list, handler(self, self.doPersonSingle), self.panelLordSingle:getContentSize())
		self.firstInitScrollPerson = true
	else
		self.scrollPerson:setList(list)
	end
	self.txtNoPersonalRecord:setVisible(not next(list))
end
function knightsChargeMainView:initScrollAlliance(target, redata)
	SoraDCloseLoading(self.scrollAlliance)
	local list = redata.rankList
	self.alliancelData = redata.myRank
	self:doAllianceSingle(-1, self.alliancelData, self.nodeSelfAlliance)
	if not self.firstInitScrollAlliance then
		self.scrollAlliance:init(list, handler(self, self.doAllianceSingle), self.panelAllianceSingle:getContentSize())
		self.firstInitScrollAlliance = true
	else
		self.scrollAlliance:setList(list)
	end
	self.txtNnoAllianceRecord:setVisible(not next(list))
end
function knightsChargeMainView:doPersonSingle(idx, info, ocx)
	ocx = ocx or self.panelLordSingle:clone()
	local head = ocx:getChildByName("Sprite_head")
	local headBg = ocx:getChildByName("Image_headBg")
	local imgNum = ocx:getChildByName("Image_lordNum")
	local txtNum = ocx:getChildByName("Text_lordNum")
	local txtLordInt = ocx:getChildByName("Text_int")
	local txtLordName = ocx:getChildByName("Text_name")
	headBg:setTouchEnabled(true)
	headBg:setSwallowTouches(false)
	headBg:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local playerID = tonumber(info.uid)
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			_ENV = nil
			;(nil).targetName = self.__cname
			local playerData = lordInfoCtrl:getLordInfoByUid(playerID, nil, nil)
			SoraDShowLoading(self)
		end
	end)
	local switchNum = function(num)
		num = tonumber(num)
		print("num=", num)
		if 1 <= num and num <= RANK_TOP_SPECIAL then
			txtNum:setVisible(false)
			imgNum:setVisible(true)
			imgNum:loadTexture(self.ocxNum[num], ccui.TextureResType.plistType)
		elseif num <= 0 then
			imgNum:setVisible(false)
			txtNum:setVisible(true)
			txtNum:setString(i18n("herobattle_text_05"))
		else
			imgNum:setVisible(false)
			txtNum:setVisible(true)
			txtNum:setString(num)
		end
	end
	local rank = info.rank
	switchNum(rank)
	if 0 <= idx then
		if idx % 2 == 0 then
			ocx:setBackGroundColorOpacity(0)
		else
			ocx:setBackGroundColorOpacity(25.5)
		end
	end
	txtLordInt:setString(string.formatnumberthousands(info.score))
	SoraDGetHeadFromManager(head, info.iconID, info.avatar)
	if info.abbr ~= "" then
		txtLordName:setString("(" .. info.abbr .. ")" .. info.nickName)
	else
		txtLordName:setString(info.nickName)
	end
	return ocx
end
function knightsChargeMainView:doAllianceSingle(idx, info, ocx)
	ocx = ocx or self.panelAllianceSingle:clone()
	local imgNum = ocx:getChildByName("Image_lordNum")
	local txtNum = ocx:getChildByName("Text_lordNum")
	local txtLordInt = ocx:getChildByName("Text_int")
	local txtLordName = ocx:getChildByName("Text_name")
	local imgFlag = ocx:getChildByName("Image_flag")
	imgFlag:setTouchEnabled(true)
	imgFlag:setSwallowTouches(false)
	imgFlag:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			local kid = gametop.playertop_:getKingdomID()
			_ENV = nil
			;(nil).from = "knightsChargeMainView"
			allianceQuery:reqAllianceInfo(kid, info.aid, nil)
			SoraDShowLoading(self)
		end
	end)
	local switchNum = function(num)
		num = tonumber(num)
		print("num=", num)
		if 1 <= num and num <= RANK_TOP_SPECIAL then
			txtNum:setVisible(false)
			imgNum:setVisible(true)
			imgNum:loadTexture(self.ocxNum[num], ccui.TextureResType.plistType)
		elseif num <= 0 then
			imgNum:setVisible(false)
			txtNum:setVisible(true)
			txtNum:setString(i18n("herobattle_text_05"))
		else
			imgNum:setVisible(false)
			txtNum:setVisible(true)
			txtNum:setString(num)
		end
	end
	local rank = info.rank
	switchNum(rank)
	if 0 <= idx then
		if idx % 2 == 0 then
			ocx:setBackGroundColorOpacity(0)
		else
			ocx:setBackGroundColorOpacity(25.5)
		end
	end
	txtLordInt:setString(string.formatnumberthousands(info.score))
	imgFlag:loadTexture(allianceDesRead.getFlagIcon(info.flag or 1), ccui.TextureResType.plistType)
	if info.abbr and info.abbr ~= "" then
		_ENV = allianceDesRead.getFlagIcon(info.flag or 1)
		allianceDesRead.getFlagIcon(info.flag or 1).abbr = info.abbr
		allianceDesRead.getFlagIcon(info.flag or 1).name = info.name
		if i18n("common_text_186", (allianceDesRead.getFlagIcon(info.flag or 1))) then
			goto lbl_82
		end
	end
	local allianceName = info.name
	::lbl_82::
	txtLordName:setString(allianceName)
	return ocx
end
function knightsChargeMainView:initProgressBar(...)
	local cur = self.myData.killNum
	_ENV = nil
	;(nil).num = cur
	self.txtFightNum:setString(i18n("rides_text_12", nil))
	local belongNum = 0
	for i, v in ipairs(self.boxData) do
		if cur >= v.num then
			belongNum = i
		end
	end
	if 1 <= belongNum then
		local perDis = math.ceil(100 / (#self.boxData - 1))
		local baseDis = (belongNum - 1) * perDis
		local preTaskNum = self.boxData[belongNum] and self.boxData[belongNum].num or 0
		local afterTaskNum = self.boxData[belongNum + 1] and self.boxData[belongNum + 1].num or self.boxData[#self.boxData].num + 1
		local curDis = (cur - preTaskNum) / (afterTaskNum - preTaskNum) * perDis
		local totalDis = baseDis + curDis
		self.loadBar:setPercent(totalDis)
	else
		self.loadBar:setPercent(0)
	end
	local caculatePosX = function(num)
		local totalWidth = self.loadBar:getContentSize().width
		local perDis = totalWidth / (#self.boxData - 1)
		if SoraDFIsRA() then
			return totalWidth / 2 - (num - 1) * perDis
		else
			return (num - 1) * perDis - totalWidth / 2
		end
	end
	if not self.ocxBoxs then
		self.ocxBoxs, _ENV = self.ocxBoxs, self.ocxBoxs
		for i, v in ipairs(self.boxData) do
			local single = self.btnBox:clone()
			single:getChildByName("Sprite_box"):setSpriteFrame(self.boxImgs[i] or self.boxImgs[1])
			single:setTag(i)
			single:setPosition(caculatePosX(i), -95)
			single:addTouchEventListener(handler(self, self.boxClick))
			single:addTo(self.nodeProgress)
			table.insert(self.ocxBoxs, single)
		end
	end
	for i, v in ipairs(self.boxData) do
		self.ocxBoxs[i]:getChildByName("Text_price"):setString(v.num)
		self:stateFun(cur, v, function(...)
			self:showRoundEffect(self.ocxBoxs[i], 1)
		end, function(...)
			self:showRoundEffect(self.ocxBoxs[i], 3)
		end, function(...)
			self:showRoundEffect(self.ocxBoxs[i], 2)
		end)
	end
	local hunPercent = self.boxData[#self.boxData].num
	_ENV = self.stateFun
	self.stateFun.num = math.floor(math.min(cur / hunPercent * 100, 100))
	self.txtQuestProgress:setString(i18n("common_text_4424", self.stateFun))
end
function knightsChargeMainView:stateFun(num, info, fun1, fun2, fun3)
	if num >= info.num and not self.myData.rewardFlag[tostring(info.num)] then
		fun1()
	elseif num >= info.num and self.myData.rewardFlag[tostring(info.num)] then
		fun2()
	else
		fun3()
	end
end
function knightsChargeMainView:boxClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local idx = button:getTag()
		local panel = SoraDCreatePanel("knightsChargeRewardPop")
		panel:initData(idx)
		panel:show()
	end
end
function knightsChargeMainView:btnPersonPriceClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDCreatePanel("knightsChargePricePop"):firstClick(1):show()
	end
end
function knightsChargeMainView:btnAlliancePriceClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDCreatePanel("knightsChargePricePop"):firstClick(2):show()
	end
end
function knightsChargeMainView:btnGotoClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		local panel = SoraDCreatePanel("worldMapMonsterSearch")
		panel:show()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD, nil)
	end
end
function knightsChargeMainView:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "knightsChargeMainView" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
function knightsChargeMainView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "rides_text_04"
		;("rides_text_04")[1] = i18n("rides_text_06")
		;("rides_text_04")[2] = i18n("rides_text_06")
		SoraDShowFixWindow(i18n("rides_text_04"), "rides_text_04")
	end
end
function knightsChargeMainView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function knightsChargeMainView:showRoundEffect(pNode, state)
	if state == 1 then
		if not pNode:getChildByName("effect_node") then
			local _ENV, _ENV, _ENV, param = "effect_node", pNode, pNode:getChildByName("effect_node"), pNode:getChildByName("effect_node")
			;("effect_node").png = "dh_xsyd_01.png"
			;("effect_node").scale = 2.75
			;("effect_node").opacity = 178.5
			_UPVALUE1_ = nil
			;(nil)[1] = cca.fadeTo(0.55, 0.2)
			;(nil)[2] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[3] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[4] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[5] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[6] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[7] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[8] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[9] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[10] = cca.fadeTo(0.5333333333333333, 0.7)
			_ENV, pNode[1], ("effect_node").seq = "effect_node", "effect_node", cca.seq(nil)
			;("effect_node").png = "dh_xsyd_07.png"
			_ENV, pNode[2], ("effect_node").scale = "effect_node", "effect_node", 2
			;("effect_node").png = "dh_xsyd_02.png"
			;("effect_node").scale = 2.4
			_ENV = nil
			;(nil)[1] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[2] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[3] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[4] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[5] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[6] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[7] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[8] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[9] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[10] = cca.rotateBy(1.0833333333333333, 540)
			pNode[3], ("effect_node").seq = "effect_node", cca.seq(nil)
			local actionConfig = pNode
			local roundNode = display.newNode()
			roundNode:setName("effect_node")
			local nSize = pNode:getContentSize()
			roundNode:setPosition(nSize.width / 2, nSize.height / 2)
			roundNode:addTo(pNode, 1)
			for k, v in ipairs(actionConfig) do
				if v.png then
					local sprite = display.newSprite("#" .. v.png)
					if v.scale then
						sprite:setScale(v.scale)
					end
					if v.opacity then
						sprite:setOpacity(v.opacity)
					end
					if v.rotation then
						sprite:setRotation(v.rotation)
					end
					if v.seq then
						sprite:runAction(cc.RepeatForever:create(v.seq))
					end
					sprite:addTo(roundNode, k)
				end
			end
			roundNode:setScale(0.35)
		else
			pNode:getChildByName("effect_node"):setVisible(true)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(255, 255, 255))
	elseif state == 2 then
		if pNode:getChildByName("effect_node") then
			pNode:getChildByName("effect_node"):setVisible(false)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(255, 255, 255))
	elseif state == 3 then
		if pNode:getChildByName("effect_node") then
			pNode:getChildByName("effect_node"):setVisible(false)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(125, 125, 125))
	end
end
function knightsChargeMainView:btnClickCallBack(tag, name)
	if 1 == tag then
		self.nodeLoad:setVisible(true)
		self.nodePerson:setVisible(false)
		self.nodeAlliance:setVisible(false)
	elseif 2 == tag then
		SoraDShowLoading(self.scrollPerson)
		knightsChargeCtrl:reqPersonalRankinfo()
		self.nodeLoad:setVisible(false)
		self.nodePerson:setVisible(true)
		self.nodeAlliance:setVisible(false)
	elseif 3 == tag then
		SoraDShowLoading(self.scrollAlliance)
		knightsChargeCtrl:reqAllianceRankinfo()
		self.nodeLoad:setVisible(false)
		self.nodePerson:setVisible(false)
		self.nodeAlliance:setVisible(true)
	end
end
function knightsChargeMainView:judgeEventClose(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.KNIGHTS_CHARGE)
	if gActivityState.CLOSE == state then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return knightsChargeMainView
