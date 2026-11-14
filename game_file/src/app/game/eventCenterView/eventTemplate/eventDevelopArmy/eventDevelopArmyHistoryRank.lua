local gametop = gModuleMgr.getObject("gametop")
local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
local lordLocalData = include("lordLocalData")
local eventDevelopArmyHistoryRank = class("eventDevelopArmyHistoryRank", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventDevelopArmyHistoryRank")
	end
	return target
end)
function eventDevelopArmyHistoryRank:ctor()
	self.history, _ENV, self.maxRound = nil, nil, 10
	self.lastRound = 0
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventPerson")
	self.ccs_title:setTitle(i18n("common_text_2713"))
	self.Image_eventBg = SoraDGetChildByName(self, "Image_eventBg")
	self.Image_eventBg:loadTexture(SoraDCheckPNG("bg_Development_army.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.text_myRank = SoraDGetChildByName(self, "Text_myRank")
	self.Text_none = SoraDGetChildByName(self, "Text_none")
	self.Text_none:setString(i18n("common_text_1464"))
	self.btn_help = SoraDGetChildByName(self, "Button_help")
	self.btn_help:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	SoraDGetChildByName(self, "Size_Tile_bg"):setFillType(1)
	self:initData()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_DEVELOP_ARMY_RANK_BACK", handler(self, self.initScroll))
	local data = newActivityCtrl:getDevelopArmamentInfo()
	self.lastRound = data.opencount
	if not newActivityCtrl:getDevelopArmyHistoryRank() then
		_ENV = newActivityCtrl:getDevelopArmyHistoryRank()
	end
	self.history = newActivityCtrl:getDevelopArmyHistoryRank()
	if not next(self.history) then
		local _ENV, roundArray = next(self.history), next(self.history)
		for i = self.lastRound - 1, self.lastRound - 2, -1 do
			if 0 < i then
				table.insert(roundArray, i)
			end
		end
		newActivityCtrl:sendGetDevelopArmamentRank(roundArray)
		if 0 < table.nums(roundArray) then
			SoraDShowLoading(self.scroll)
		end
	else
		self:initScroll()
	end
end
function eventDevelopArmyHistoryRank:initData()
	self.text_myRank:setString(i18n("common_text_2713") .. i18n("common_text_2715"))
end
function eventDevelopArmyHistoryRank:btnHelpClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_2727"))
	end
end
function eventDevelopArmyHistoryRank:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.maxRound > table.nums(self.history) then
		local reqIndex = self.lastRound - table.nums(newActivityCtrl:getDevelopArmyAllHistoryRank()) - 1
		local _ENV, roundArray = table.nums(newActivityCtrl:getDevelopArmyAllHistoryRank()), table.nums(newActivityCtrl:getDevelopArmyAllHistoryRank())
		for i = reqIndex, reqIndex - 1, -1 do
			if 0 < i then
				table.insert(roundArray, i)
			end
		end
		newActivityCtrl:sendGetDevelopArmamentRank(roundArray)
		if table.nums(roundArray) > 0 then
			SoraDShowLoading(self.scroll)
		end
	end
end
function eventDevelopArmyHistoryRank:initScroll(target, data)
	SoraDCloseLoading(self.scroll)
	if not newActivityCtrl:getDevelopArmyHistoryRank() then
		_ENV = newActivityCtrl:getDevelopArmyHistoryRank()
	end
	self.history = newActivityCtrl:getDevelopArmyHistoryRank()
	if table.nums(self.history) > 0 then
		self.Text_none:setVisible(false)
		local headNum = table.nums(self.history)
		local singleNum = 0
		for k, v in pairs(self.history) do
			singleNum = singleNum + table.nums(v.toptenInfo)
		end
		self.scroll:removeAllChildren()
		local scrollH = math.max(self.scroll:getContentSize().height, 40 * headNum + 60 * singleNum)
		self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
		local innerHeight = 0
		for k, v in ipairs(self.history) do
			local head = self:getPanelHead(v.beginTime, v.endTime)
			head:setPosition(cc.p(0, scrollH - 40 - innerHeight))
			head:addTo(self.scroll)
			innerHeight = innerHeight + 40
			for j = 1, table.nums(v.toptenInfo) do
				local single = self:getPanelSingle(v.toptenInfo[j])
				single:setPosition(cc.p(0, scrollH - 60 - innerHeight))
				single:addTo(self.scroll)
				innerHeight = innerHeight + 60
			end
		end
	end
end
function eventDevelopArmyHistoryRank:getPanelHead(beginTime, endTime)
	local single = SoraDGetChildByName(self, "Panel_head"):clone()
	local str = os.date("%Y-%m-%d %H:%M:%S", beginTime) .. "~" .. os.date("%Y-%m-%d %H:%M:%S", endTime)
	_ENV = nil
	;(nil).date = str
	SoraDGetChildByName(single, "Text_rank"):setString(i18n("common_text_2716", nil))
	return single
end
function eventDevelopArmyHistoryRank:getPanelSingle(data)
	local single = SoraDGetChildByName(self, "Panel_single"):clone()
	single:setTouchEnabled(true)
	single:setTag(data.uid)
	single:addTouchEventListener(handler(self, self.btnSingClickCallBack))
	local Image_flag = SoraDGetChildByName(single, "Image_flag")
	local Text_rankNum = SoraDGetChildByName(single, "Text_rankNum")
	local Image_rank = SoraDGetChildByName(single, "Image_rank")
	local Image_head = SoraDGetChildByName(single, "Image_head")
	local Text_name = SoraDGetChildByName(single, "Text_name")
	local line = SoraDGetChildByName(single, "Image_line")
	line:setOpacity(20)
	Text_rankNum:setString(data.rank)
	SoraDGetHeadFromManager(Image_head, data.headid, data.avatar)
	local name = data.nickName
	if data.allianceAbbr and string.len(data.allianceAbbr) > 0 then
		name = "(" .. data.allianceAbbr .. ")" .. name
	end
	Text_name:setString(name)
	if data.rank <= RANK_TOP_SPECIAL then
		Text_rankNum:setVisible(false)
		Image_rank:setVisible(true)
		Image_rank:loadTexture("icon_ranking_" .. data.rank .. ".png", ccui.TextureResType.plistType)
	else
		Text_rankNum:setVisible(true)
		Image_rank:setVisible(false)
	end
	return single
end
function eventDevelopArmyHistoryRank:btnSingClickCallBack(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.initPlayer))
		local kid = gametop.playertop_:getKingdomID()
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		_ENV = handler(self, self.initPlayer)
		handler(self, self.initPlayer).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(target:getTag(), kid, handler(self, self.initPlayer))
	end
end
function eventDevelopArmyHistoryRank:initPlayer(target, data)
	local lordInfo = data.lord
	if not lordInfo then
		return
	end
	SoraDOpenLordView(lordInfo)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
end
return eventDevelopArmyHistoryRank
