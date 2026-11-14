local wrathBeastRecordSingle = include("wrathBeastRecordSingle")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local mailFunctions = include("mailFunctions")
local wrathBeastMainView = class("wrathBeastMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("wrathBeastMainView")
	end
	return target
end)
_ENV = "wrathBeastMainView"
;("wrathBeastMainView").ACTIVITY_DETAIL = 1
local ("wrathBeastMainView").EXCHANGE, TabType = 2, "wrathBeastMainView"
function wrathBeastMainView:ctor()
	_UPVALUE4_, self.isHideCurrentSceneView = nil, true
	self.boxImgs, (nil)[1] = nil, "icon_KingGroupbuy_lv1_small.png"
	self.boxImgs, (nil)[2] = nil, "icon_KingGroupbuy_lv2_small.png"
	self.boxImgs, (nil)[3] = nil, "icon_KingGroupbuy_lv3_small.png"
	self.boxImgs, (nil)[4] = nil, "icon_KingGroupbuy_lv4_small.png"
	self.activityID = gActivityTimeActivityID.WRATH_BEAST_ACTIVITY
	self.activityState = activityShowCtrl:getStateByID(self.activityID)
	self:initWidget()
	self:initData()
	wrathBeastCtrl:sendReqInitMsg()
	SoraDPlaySound("worldMapMonster", "drq")
end
function wrathBeastMainView:initWidget()
	local root = self._ccsView
	TabType = nil
	;(nil)[1] = "Top_Node"
	local Top_Node = SoraDGetChildByFullPath(root, nil)
	local ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_bg")
	ccs_title:setTitle(i18n("activity_name_9001168"))
	TabType = i18n("activity_name_9001168")
	i18n("activity_name_9001168")[1] = "Button_help"
	local Button_help = SoraDGetChildByFullPath(ccs_title, i18n("activity_name_9001168"))
	Button_help:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.WRATH_BEAST)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.WRATH_BEAST)
			end
		end
	end)
	function TabType(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.WRATH_BEAST)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.WRATH_BEAST)
			end
		end
	end
	;(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.WRATH_BEAST)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.WRATH_BEAST)
			end
		end
	end)[1] = "Top_Node_1"
	self.Top_Node_1 = SoraDGetChildByFullPath(root, function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.WRATH_BEAST)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.WRATH_BEAST)
			end
		end
	end)
	function TabType(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.WRATH_BEAST)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.WRATH_BEAST)
			end
		end
	end
	;(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.WRATH_BEAST)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.WRATH_BEAST)
			end
		end
	end)[1] = "ScrollView_info"
	self.scroll_info = SoraDGetChildByFullPath(self.Top_Node_1, function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.WRATH_BEAST)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.WRATH_BEAST)
			end
		end
	end)
	local size = self.scroll_info:getContentSize()
	local offsetH = math.min(0, display.height - 960)
	self.scroll_info:setContentSize(cc.size(size.width, size.height + offsetH))
	self.scroll_info:setBounceEnabled(offsetH < 0)
	TabType = offsetH < 0
	;(offsetH < 0)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.scroll_info, offsetH < 0)
	_UPVALUE2_ = offsetH < 0
	;(offsetH < 0)[1] = "Node_title"
	;(offsetH < 0)[2] = "Text_eventTitle"
	SoraDGetChildByFullPath(self.Node_info, offsetH < 0):setString(i18n("activity_name_9001168"))
	TabType = i18n("activity_name_9001168")
	i18n("activity_name_9001168")[1] = "Text_contextTitle"
	SoraDGetChildByFullPath(self.Node_info, i18n("activity_name_9001168")):setString(i18n("god_beast_text_01"))
	TabType = i18n("god_beast_text_01")
	i18n("god_beast_text_01")[1] = "Text_context"
	SoraDGetChildByFullPath(self.Node_info, i18n("god_beast_text_01")):setString(i18n("god_beast_text_02"))
	_UPVALUE2_ = i18n("god_beast_text_02")
	i18n("god_beast_text_02")[1] = "Panel_next"
	i18n("god_beast_text_02")[2] = "Text_next"
	self.Text_next = SoraDGetChildByFullPath(self.Node_info, i18n("god_beast_text_02"))
	_UPVALUE2_ = i18n("god_beast_text_02")
	i18n("god_beast_text_02")[1] = "Node_rewards_title"
	i18n("god_beast_text_02")[2] = "Text_fightNum"
	SoraDGetChildByFullPath(self.Node_info, i18n("god_beast_text_02")):setString(i18n("god_beast_text_03"))
	TabType = i18n("god_beast_text_03")
	i18n("god_beast_text_03")[1] = "Text_tip"
	SoraDGetChildByFullPath(self.Node_info, i18n("god_beast_text_03")):setString(i18n("god_beast_text_37"))
	TabType = i18n("god_beast_text_37")
	i18n("god_beast_text_37")[1] = "Node_rewards"
	self.Node_rewards = SoraDGetChildByFullPath(self.Node_info, i18n("god_beast_text_37"))
	TabType = i18n("god_beast_text_37")
	i18n("god_beast_text_37")[1] = "Top_Node_2"
	self.Top_Node_2 = SoraDGetChildByFullPath(root, i18n("god_beast_text_37"))
	TabType = i18n("god_beast_text_37")
	i18n("god_beast_text_37")[1] = "Node_info"
	local Node_info = SoraDGetChildByFullPath(self.Top_Node_2, i18n("god_beast_text_37"))
	TabType = "Node_info"
	;("Node_info")[1] = "Text_title"
	self.Text_title = SoraDGetChildByFullPath(Node_info, "Node_info")
	TabType = "Node_info"
	;("Node_info")[1] = "Button_kill"
	local Button_kill = SoraDGetChildByFullPath(Node_info, "Node_info")
	TabType = "Button_kill"
	;("Button_kill")[1] = "Text_kill"
	SoraDGetChildByFullPath(Button_kill, "Button_kill"):setString(i18n("god_beast_btn_01"))
	Button_kill:addTouchEventListener(handler(self, self.btnKillClick))
	_UPVALUE2_ = handler(self, self.btnKillClick)
	handler(self, self.btnKillClick)[1] = "Node_fightNum"
	handler(self, self.btnKillClick)[2] = "Text_fightNum"
	self.txtFightNum = SoraDGetChildByFullPath(Node_info, handler(self, self.btnKillClick))
	TabType = handler(self, self.btnKillClick)
	handler(self, self.btnKillClick)[1] = "Node_progress"
	self.nodeProgress = SoraDGetChildByFullPath(Node_info, handler(self, self.btnKillClick))
	TabType = handler(self, self.btnKillClick)
	handler(self, self.btnKillClick)[1] = "LoadingBar_progress"
	self.loadBar = SoraDGetChildByFullPath(self.nodeProgress, handler(self, self.btnKillClick))
	TabType = handler(self, self.btnKillClick)
	handler(self, self.btnKillClick)[1] = "Button_box"
	self.btnBox = SoraDGetChildByFullPath(self.nodeProgress, handler(self, self.btnKillClick))
	TabType = handler(self, self.btnKillClick)
	handler(self, self.btnKillClick)[1] = "Node_record"
	self.Node_record = SoraDGetChildByFullPath(self.Top_Node_2, handler(self, self.btnKillClick))
	TabType = handler(self, self.btnKillClick)
	handler(self, self.btnKillClick)[1] = "Text_title"
	SoraDGetChildByFullPath(self.Node_record, handler(self, self.btnKillClick)):setString(i18n("god_beast_text_31"))
	TabType = i18n("god_beast_text_31")
	i18n("god_beast_text_31")[1] = "Button_more"
	local Button_more = SoraDGetChildByFullPath(self.Node_record, i18n("god_beast_text_31"))
	TabType = "Button_more"
	;("Button_more")[1] = "Text_more"
	SoraDGetChildByFullPath(Button_more, "Button_more"):setString(i18n("common_text_3825"))
	Button_more:addTouchEventListener(handler(self, self.btnMoreClick))
	TabType = handler(self, self.btnMoreClick)
	handler(self, self.btnMoreClick)[1] = "Text_noRecord"
	self.Text_noRecord = SoraDGetChildByFullPath(self.Node_record, handler(self, self.btnMoreClick))
	self.Text_noRecord:setString(i18n("god_beast_text_16"))
	TabType = i18n("god_beast_text_16")
	i18n("god_beast_text_16")[1] = "Node_single"
	self.Node_single = SoraDGetChildByFullPath(self.Node_record, i18n("god_beast_text_16"))
	self.Node_single:setVisible(false)
	TabType = false
	;(false)[1] = "Top_Size_ScrollView_items"
	self.scroll = SoraDGetChildByFullPath(root, false)
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("wrathBeastExchangeSingle")
	TabType = "wrathBeastExchangeSingle"
	;("wrathBeastExchangeSingle")[1] = "Bottom_Node"
	self.Bottom_Node = SoraDGetChildByFullPath(root, "wrathBeastExchangeSingle")
	TabType = "wrathBeastExchangeSingle"
	;("wrathBeastExchangeSingle")[1] = "Button_rank"
	self.Button_rank = SoraDGetChildByFullPath(self.Bottom_Node, "wrathBeastExchangeSingle")
	TabType = "wrathBeastExchangeSingle"
	;("wrathBeastExchangeSingle")[1] = "Text_rank"
	SoraDGetChildByFullPath(self.Button_rank, "wrathBeastExchangeSingle"):setString(i18n("god_beast_text_38"))
	self.Button_rank:addTouchEventListener(handler(self, self.btnRankClick))
	TabType = handler(self, self.btnRankClick)
	handler(self, self.btnRankClick)[1] = "Button_detail"
	self.Button_detail = SoraDGetChildByFullPath(self.Bottom_Node, handler(self, self.btnRankClick))
	TabType = handler(self, self.btnRankClick)
	handler(self, self.btnRankClick)[1] = "Text_detail"
	SoraDGetChildByFullPath(self.Button_detail, handler(self, self.btnRankClick)):setString(i18n("god_beast_text_04"))
	self.Button_detail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	_ENV = "CCS_commonTabBtn_btns"
	;("CCS_commonTabBtn_btns").tabNum = table.nums(TabType)
	_ENV, ("CCS_commonTabBtn_btns").defaultClick = TabType.ACTIVITY_DETAIL, TabType.ACTIVITY_DETAIL
	_ENV = handler(self, self.btnDetailClick)
	handler(self, self.btnDetailClick).title = i18n("common_text_779")
	TabType.ACTIVITY_DETAIL[TabType.ACTIVITY_DETAIL], handler(self, self.btnDetailClick).handle = handler(self, self.btnDetailClick)
	_ENV = handler(self, self.btnDetailClick)
	handler(self, self.btnDetailClick).title = i18n("alliance_hunt_btn_01")
	;("CCS_commonTabBtn_btns").tabsetArray, TabType.ACTIVITY_DETAIL[TabType.EXCHANGE], handler(self, self.btnDetailClick).handle = TabType.ACTIVITY_DETAIL, handler(self, self.btnDetailClick)
	self.ccs_tab:initView("CCS_commonTabBtn_btns")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self.Node_time, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local Image_banner = SoraDGetChildByName(self, "Image_banner")
	Image_banner:setTouchEnabled(true)
	Image_banner:setSwallowTouches(true)
end
function wrathBeastMainView:initData(...)
	self:refreshKillerArmy()
	local reward = worldMapDefine.getWorldBossReward(gBossType.wrathBeastDrq, 1)
	for k, v in ipairs(reward) do
		local item = include("commonItemAward").new()
		item:setScale(0.8)
		item:setBaseScale(1.0)
		item:setPosition(0, 0)
		item:setOwnScroll(self.scroll_info)
		item:setOwnView(self)
		item:addTo(self.Node_rewards)
		item:setVisible(true)
		item:initData(v)
	end
	SoraDToCenter(self.Node_rewards, 95, SoraDFIsRA())
	self:refreshTabBtn(TabType.EXCHANGE)
	self:setTime()
end
function wrathBeastMainView:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		local timerLast = clientEventMgr.judgeIsOnShow(self.activityState) or ""
		self.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n(timerLast, nil)
		end)
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		self.Node_time:setVisible(true)
		SoraDToCenter(self.Node_time)
	end
end
function wrathBeastMainView:refreshKillerArmy(...)
	local armyType = wrathBeastCtrl:getKillerArmyType()
	wrathBeastCtrl = nil
	;(nil).army = mailFunctions:getSoldierName(armyType)
	self.Text_title:setString(i18n("god_beast_text_14", nil))
	wrathBeastCtrl = i18n("god_beast_text_14", nil)
	i18n("god_beast_text_14", nil).army = mailFunctions:getSoldierName(armyType)
	self.Text_next:setString(i18n("god_beast_text_14", i18n("god_beast_text_14", nil)))
end
function wrathBeastMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_WRATH_BEAST_REFRESH", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", function(target, data)
		self:refreshTabBtn(TabType.EXCHANGE)
		if not data.name or data.name ~= "remind" then
			self:initExchangeData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function(target, data)
		SoraDCloseLoading(self)
	end)
end
function wrathBeastMainView:judgeClose()
	local state = activityShowCtrl:getStateByID(self.activityID)
	if state == gActivityState.CLOSE then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	if self.activityState == state then
		return
	end
	self.activityState = state
	local curTab = self.ccs_tab:getCurTab()
	if curTab and curTab:getTag() == TabType.ACTIVITY_DETAIL then
		self:btn_onClick_btns(TabType.ACTIVITY_DETAIL)
	end
	self:setTime()
	self:refreshTabBtn(TabType.ACTIVITY_DETAIL)
end
function wrathBeastMainView:refreshData(target, data)
	if data.name == "record" then
		self:initRecord()
	elseif data.name == "reward" then
		self:refreshBoxState()
		self:refreshTabBtn(TabType.ACTIVITY_DETAIL)
	elseif data.name == "init" then
		self:initProgressBar()
		self:initRecord()
		self:refreshTabBtn(TabType.ACTIVITY_DETAIL)
	elseif data.name == "notify" then
		self:initProgressBar()
		self:refreshKillerArmy()
	end
end
function wrathBeastMainView:refreshTabBtn(tag)
	local ret, redNum = false, 0
	if tag == TabType.ACTIVITY_DETAIL then
		if self.activityState == gActivityState.OPEN then
			ret, redNum = wrathBeastCtrl:getCanReceiveBoxNum(self.activityID)
		end
	else
		local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
		ret, redNum = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	end
	self.ccs_tab:setRedPointState(tag, ret)
end
function wrathBeastMainView:btn_onClick_btns(tag, name)
	if tag == TabType.ACTIVITY_DETAIL then
		local isOpen = self.activityState == gActivityState.OPEN
		self.Top_Node_1:setVisible(not isOpen)
		self.Top_Node_2:setVisible(isOpen)
		self.Button_rank:setVisible(isOpen)
		self.Button_detail:setPositionX(isOpen and SoraDFPosX(178) or 320)
		self.scroll:setVisible(false)
		self.Bottom_Node:setVisible(true)
		wrathBeastCtrl:sendReqRecordLogMsg()
	else
		self.Top_Node_1:setVisible(false)
		self.Top_Node_2:setVisible(false)
		self.scroll:setVisible(true)
		self.Bottom_Node:setVisible(false)
		self:initExchangeData()
	end
end
function wrathBeastMainView:initProgressBar(...)
	local cur = wrathBeastCtrl:getActivityData("totalDamage")
	wrathBeastCtrl = nil
	;(nil).num = string.formatnumberthousands(cur)
	self.txtFightNum:setString(i18n("god_beast_text_15", nil))
	self.boxData = wrathBeastCtrl:getBoxRewardConfig()
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
		self.ocxBoxs, wrathBeastCtrl = self.ocxBoxs, self.ocxBoxs
		for i, v in ipairs(self.boxData) do
			local single
			if i == 1 then
				single = self.btnBox
			else
				single = self.btnBox:clone()
				single:addTo(self.nodeProgress)
			end
			single:getChildByName("Sprite_box"):setSpriteFrame(self.boxImgs[i] or self.boxImgs[1])
			single:getChildByName("Text_price"):setString(string.formatnumberthousands(v.num))
			single:getChildByName("Sprite_get"):setVisible(false)
			single:setTag(i)
			single:setPosition(caculatePosX(i), 0)
			single:addTouchEventListener(handler(self, self.boxClick))
			table.insert(self.ocxBoxs, single)
		end
	end
	self:refreshBoxState()
end
function wrathBeastMainView:refreshBoxState(...)
	local cur = wrathBeastCtrl:getActivityData("totalDamage")
	local receivedReward = wrathBeastCtrl:getActivityData("receivedReward")
	if not self.boxData then
		wrathBeastCtrl = self.boxData
	end
	self.boxData = self.boxData
	for i, v in ipairs(self.boxData) do
		if cur >= v.num then
			if receivedReward[tostring(i)] then
				self:showRoundEffect(self.ocxBoxs[i], 3)
			else
				self:showRoundEffect(self.ocxBoxs[i], 1)
			end
		else
			self:showRoundEffect(self.ocxBoxs[i], 2)
		end
	end
end
function wrathBeastMainView:boxClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local idx = button:getTag()
		local panel = SoraDCreatePanel("wrathBeastRewardPop")
		panel:initData(idx)
		panel:show()
	end
end
function wrathBeastMainView:showRoundEffect(pNode, state)
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
			roundNode:setScale(0.28)
		else
			pNode:getChildByName("effect_node"):setVisible(true)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(255, 255, 255))
		pNode:getChildByName("Sprite_get"):setVisible(false)
	elseif state == 2 then
		if pNode:getChildByName("effect_node") then
			pNode:getChildByName("effect_node"):setVisible(false)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(255, 255, 255))
		pNode:getChildByName("Sprite_get"):setVisible(false)
	elseif state == 3 then
		if pNode:getChildByName("effect_node") then
			pNode:getChildByName("effect_node"):setVisible(false)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(125, 125, 125))
		pNode:getChildByName("Sprite_get"):setVisible(true)
	end
end
function wrathBeastMainView:btnKillClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		;(nil).chooseIndex = 11
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER, nil)
	end
end
function wrathBeastMainView:initExchangeData(...)
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local activityExchangeMallRead = include("activityExchangeMallRead")
	self.tableData = activityExchangeMallRead:getShopItemList(self.activityID)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).activityID = self.activityID
	self.scroll:updateScrollView(cc.size(624, 162), self.tableData, 1, nil)
end
function wrathBeastMainView:btnMoreClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("wrathBeastRecordView"):show()
	end
end
function wrathBeastMainView:btnRankClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("wrathBeastRankView"):show()
	end
end
function wrathBeastMainView:btnDetailClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("wrathBeastAwardView"):show()
	end
end
function wrathBeastMainView:initRecord(...)
	self.records = wrathBeastCtrl:getActivityData("records")
	self.Text_noRecord:setVisible(not self.records or not next(self.records))
	local maxHeight = 195 + display.height - 960
	self.Text_noRecord:setPositionY(-maxHeight / 2 - 31)
	local totalHeight = 0
	if not self.ocxRecords then
		wrathBeastCtrl = self.ocxRecords
	end
	self.ocxRecords = self.ocxRecords
	local wrathBeastCtrl, ocxRecords = self.ocxRecords, self.ocxRecords
	for i, v in ipairs(self.ocxRecords) do
		v:setVisible(false)
		table.insert(ocxRecords, v)
	end
	for i, v in ipairs(self.records) do
		local single
		local isNew = false
		if ocxRecords and next(ocxRecords) then
			single = table.remove(ocxRecords, 1)
		else
			single = wrathBeastRecordSingle.new(self.Node_single:clone())
			isNew = true
		end
		single:initData(v)
		totalHeight = totalHeight + single:getNodeHeight()
		if maxHeight < totalHeight then
			break
		end
		single:setVisible(true)
		single:setPosition(cc.p(0, -totalHeight - 31))
		if isNew then
			single:addTo(self.Node_record)
			if not self.ocxRecords then
				wrathBeastCtrl = self.ocxRecords
			end
			self.ocxRecords = self.ocxRecords
			table.insert(self.ocxRecords, single)
		end
	end
end
function wrathBeastMainView:onExitPanel(...)
	local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
	activityCenterUICtrl:sendClearNewMsg(self.activityID)
end
return wrathBeastMainView
