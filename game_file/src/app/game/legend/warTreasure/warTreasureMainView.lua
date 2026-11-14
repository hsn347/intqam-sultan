local ctGridScroll = include("ctGridScroll")
local warTreasureRead = include("warTreasureRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local warTreasureCtrl = SoraDGetCtrl("warTreasureCtrl")
local warTreasureMainView = class("warTreasureMainView", function(target)
	return target or SoraDCreateBasePanel("warTreasureMainView")
end)
local MAX_REQ_NUM = 3
function warTreasureMainView:ctor()
	self.boxTbl, _ENV = nil, nil
	self.firstInit = false
	self.activityID = gActivityTimeActivityID.WAR_TREASURE_ACTIVITY
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.ccs_title:setTitle(i18n("activity_name_9001243"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnClickHelp))
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.singleLog = SoraDGetChildByName(self, "Node_score")
	self.singleBox = SoraDGetChildByName(self, "Node_Single")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.btnLogMore = SoraDGetChildByName(self, "Button_log_more")
	self.btnVulnera = SoraDGetChildByName(self, "Button_Vulnerary")
	self.btnWarDrum = SoraDGetChildByName(self, "Button_WarDrum")
	self.btnBuff = SoraDGetChildByName(self, "Button_Buff")
	self.textPointHave = SoraDGetChildByName(self, "Text_Point")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.nodeBox = SoraDGetChildByName(self, "Node_Box")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.scrollBg = SoraDGetChildByName(self, "Size_Tile_bg")
	self.scrollTopSheer = SoraDGetChildByName(self, "Top_Image")
	self.particalNode = SoraDGetChildByName(self, "Node_Center_P")
	self.nodeSword = SoraDGetChildByName(self, "Node_Sword")
	self:initData()
	self:fitView()
	warTreasureCtrl:reqWarTreasureData()
	_ENV = "Node_Sword"
	;("Node_Sword").iBegin = 1
	;("Node_Sword").nCount = 3
	warTreasureCtrl:reqWarTreasureDonateLog("Node_Sword")
end
function warTreasureMainView:fitView()
	if self:getPanelOffsetHeight() < 900 then
		self.topNode:setPositionY(self.topNode:getPositionY() + 95)
		self.scrollBg:setContentSize(cc.size(640, 110))
		self.scrollTopSheer:setPositionY(230)
		self.scroll:setContentSize(cc.size(630, 110))
		SoraDGetChildByName(self, "Size_Tile_bg"):setContentSize(cc.size(640, 115))
		SoraDGetChildByName(self, "Size_activity_bg"):setContentSize(cc.size(640, 115))
		self.scroll:setContentSize(cc.size(630, 110))
		self.nodeSword:setPosition(260, self.nodeSword:getPositionY() - 90)
		self.nodeBox:setPositionY(self.nodeBox:getPositionY() - 70)
		self.particalNode:setPositionY(self:getPanelOffsetHeight() / 2 - SoraDGetChildByName(self, "Top_bg"):getPositionY())
	end
end
function warTreasureMainView:initData()
	self.textTips:setString(i18n("warSecrit_text_02"))
	self.btnVulnera:setTitleText(i18n("warSecrit_btn_03"))
	self.btnWarDrum:setTitleText(i18n("warSecrit_btn_01"))
	self.btnLogMore:addTouchEventListener(handler(self, self.btnClickLogMore))
	self.btnVulnera:addTouchEventListener(handler(self, self.btnClickCheer))
	self.btnWarDrum:addTouchEventListener(handler(self, self.btnClickCheer))
	self.btnBuff:addTouchEventListener(handler(self, self.btnClickOpenBuff))
	self.textVHave = SoraDGetChildByName(self.btnVulnera, "Text_Have")
	self.textDHave = SoraDGetChildByName(self.btnWarDrum, "Text_Have")
	self.btnVulnera:setTag(827201)
	self.btnWarDrum:setTag(827101)
	self:refreshItemNum()
	local boxData = warTreasureRead.getRankAward(1)
	for i, v in ipairs(boxData) do
		local single = self.singleBox:clone()
		single:addTo(self.nodeBox)
		single:setVisible(true)
		local targetNum = v.rank[1]
		SoraDGetChildByName(single, "Button_Click"):addTouchEventListener(handlerEx(self, self.btnClickBox, targetNum))
		SoraDGetChildByName(single, "Text_Point"):setString(string.formatnumberthousands(targetNum))
		self.boxTbl[i] = single
	end
	SoraDautoSortPos(self.nodeBox, 3, 1, cc.size(160, 150), not SoraDFIsRA())
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	local eventState = activityShowCtrl:getStateByID(self.activityID)
	local timerLast = "common_text_606"
	if eventState ~= gActivityState.CLOSE and gActivityState.OPEN == eventState then
		timerLast = "common_text_607"
	end
	self.activityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n(timerLast, nil)
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
end
function warTreasureMainView:createSingle(info, index)
	local single = self.singleLog:clone()
	return single
end
function warTreasureMainView:refreshSingle(parent, data)
	dump(data, "warTreasureMainView:createSingle", 10)
	local bg = SoraDGetChildByName(parent, "Image_Bg")
	bg:setVisible(parent:getTag() % 2 == 0)
	local textDes = SoraDGetChildByName(parent, "Text_info")
	local textTime = SoraDGetChildByName(parent, "Text_time")
	textDes = SoraDChangeTextToHtml(textDes)
	textTime:setString(SoraDConverTimeStr(data.t))
	local allianceName = "(" .. (data and data.toAllianceAbb or "") .. ")" .. string.htmlspecialchars(data and data.toAllianceName or "")
	if data.allianceAbb then
		_ENV = string.htmlspecialchars(data and data.toAllianceName or "")
		string.htmlspecialchars(data and data.toAllianceName or "").abbr = data.allianceAbb
		string.htmlspecialchars(data and data.toAllianceName or "").name = data.name
		if i18n("common_text_186", (string.htmlspecialchars(data and data.toAllianceName or ""))) then
			goto lbl_68
		end
	end
	local name = data.name
	::lbl_68::
	_ENV = SoraDConverTimeStr(data.t)
	SoraDConverTimeStr(data.t).name = name
	SoraDConverTimeStr(data.t).alliance = allianceName
	_ENV, _ENV, SoraDConverTimeStr(data.t).num = SoraDConverTimeStr(data.t)
	_ENV, data.n.num, SoraDConverTimeStr(data.t).color = SoraDConverTimeStr(data.t)
	data.n.__default, SoraDConverTimeStr(data.t).color = SoraDConverTimeStr(data.t)
	textDes:setString(i18n_html(data.subType == 1 and "warSecrit_text_03" or "warSecrit_text_04", SoraDConverTimeStr(data.t)))
end
function warTreasureMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WAR_TREASURE_REFRESH", handler(self, self.updataDataLog))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshItemNum))
end
function warTreasureMainView:updataDataLog(target, data)
	if data.subMsg == "logList" then
		if data.iBegin ~= 1 then
			return
		end
		local MAX_REQ_NUM, showList = data.iBegin, data.iBegin
		for i = 1, MAX_REQ_NUM do
			local v = data.rankList[i]
			if v then
				showList[#showList + 1] = v
			else
				break
			end
		end
		MAX_REQ_NUM = #showList + 1
		;(#showList + 1).scroll = self.scroll
		;(#showList + 1).view = self
		self.scroll:updateScrollView(cc.size(630, 65), showList, 1, #showList + 1)
	elseif data.subMsg == "init" then
		self.havePoints = warTreasureCtrl:getAllianceWarTreasureScore()
		self.textPointHave:setString(i18n("common_text_448") .. string.formatnumberthousands(self.havePoints))
		for i, v in ipairs(self.boxTbl) do
			local targetNum = warTreasureRead.getPointByIndex(i)
			local boxIsOpen = targetNum <= self.havePoints
			SoraDGetChildByName(v, "icon_Box"):loadTexture(boxIsOpen and "icon_zzmb_lmjdbx_dk.png" or "icon_zzmb_lmjdbx_gb.png", ccui.TextureResType.plistType)
			SoraDGetChildByName(v, "Particle_Bg"):setVisible(boxIsOpen)
			SoraDGetChildByName(v, "Node_P"):setVisible(boxIsOpen)
			SoraDGetChildByName(v, "Button_Click"):setTouchEnabled(not boxIsOpen)
		end
	elseif data.subMsg == "refresh" then
		self:refreshItemNum()
		MAX_REQ_NUM = ipairs(self.boxTbl)
		ipairs(self.boxTbl).iBegin = 1
		ipairs(self.boxTbl).nCount = 3
		warTreasureCtrl:reqWarTreasureDonateLog(ipairs(self.boxTbl))
	end
end
function warTreasureMainView:refreshItemNum(target, data)
	self.haveDrum = backpackCtrl:getItemCount(827101)
	self.haveVuln = backpackCtrl:getItemCount(827201)
	self.textDHave:setString(string.formatnumberthousands(self.haveDrum))
	self.textVHave:setString(string.formatnumberthousands(self.haveVuln))
	SoraDGetChildByName(self.btnWarDrum, "Image_Icon"):setPositionX((SoraDFIsRA() and 1 or -1) * (self.textDHave:getContentSize().width / 2 + 10) + 120)
	SoraDGetChildByName(self.btnVulnera, "Image_Icon"):setPositionX((SoraDFIsRA() and 1 or -1) * self.textVHave:getContentSize().width / 2 + 120)
end
function warTreasureMainView:btnClickLogMore(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanelByFixName("warTreasureLog"):show()
	end
end
function warTreasureMainView:btnClickOpenBuff(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("warTreasureBuffPop"):show()
	end
end
function warTreasureMainView:btnClickCheer(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local viewType = button:getTag()
		local panel = SoraDCreatePanel("warTreasureCheerView")
		panel:initData(viewType)
		panel:show()
	end
end
function warTreasureMainView:btnClickHelp(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("warSecrit_text_01"))
	end
end
function warTreasureMainView:btnClickBox(index, button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("warTreasurePreAward")
		panel:setData(index)
		panel:show()
	end
end
function warTreasureMainView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return warTreasureMainView
