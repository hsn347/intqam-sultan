_ENV = nil
;(nil).RECOMMEND = 1
;(nil).OPEN = 2
local (nil).LOCK, SingleDataType = 3, nil
local gametop = gModuleMgr.getObject("gametop")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
_ENV = gametop.playertop_
gametop.playertop_[1] = true
local gametop.playertop_[2], tableAllianceScienceListState = false, gametop.playertop_
local AllianceScienceView = class("allianceScienceView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceScienceView")
	end
	return target
end)
function AllianceScienceView:ctor()
	self.tableSingle, _ENV, self.tableScienceList, _ENV = nil, nil, nil, nil
	self.Node_point = SoraDGetChildByName(self, "Node_point")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.Node_score = SoraDGetChildByName(self, "Node_score")
	self.labelScore = SoraDGetChildByName(self, "Text_score")
	self.labelLv = SoraDGetChildByName(self, "Text_lv")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_sciencs")
	self.nodeTitle:setTitle(i18n("common_text_191"))
	self.scrollScience = SoraDGetChildByName(self, "Top_Size_ScrollView_science")
	self:updateData()
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	_ENV = "CCS_commonTabBtn_btns"
	;("CCS_commonTabBtn_btns").tabNum = 2
	_ENV, _ENV, ("CCS_commonTabBtn_btns").defaultClick = i18n("common_text_191")
	i18n("common_text_191").title = i18n("alliance_prosperity_text_23")
	_ENV, i18n("common_text_191")[1], i18n("common_text_191").handle = i18n("common_text_191")
	i18n("common_text_191").title = i18n("alliance_prosperity_text_12")
	;("CCS_commonTabBtn_btns").tabsetArray, i18n("common_text_191")[2], i18n("common_text_191").handle = i18n("common_text_191")
	self.ccs_tab:initView("CCS_commonTabBtn_btns")
	self:greenPointUpdate()
end
function AllianceScienceView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DONATE_SUCCESS", handler(self, self.updateNextGroup))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_ADD_RECOMMEND_SUCCESS", handler(self, self.updateAllData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_REMOVE_RECOMMEND_SUCCESS", handler(self, self.updateAllData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_DATA_BACK", handler(self, self.updateAllData))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE_BYTYPE", handler(self, self.greenPointUpdateByType))
end
function AllianceScienceView:greenPointUpdate(...)
	local rewardsCount = allianceScience:getProsperityRewardsCount()
	self.ccs_tab:setRedPointState(2, 0 < rewardsCount)
end
function AllianceScienceView:greenPointUpdateByType(target, data)
	if ALLIANCE_MAIN_MENU_TYPE.SCIENCE == data.type then
		self:greenPointUpdate()
	end
end
function AllianceScienceView:btn_onClick_btns(tag, name)
	if tag == 2 then
		if allianceScience:isProsperityUnlock() then
			SoraDRemoveAllAfterPanelFromManager(self)
			SoraDCreatePanel("allianceProsperityView"):show()
		else
			SoraDShowMsgTip(i18n("alliance_prosperity_text_21"))
			self.ccs_tab:clickByIndex(1)
		end
	end
end
function AllianceScienceView:updateAllData(target, data)
	self:updateData()
end
function AllianceScienceView:updateNextGroup(target, data)
	local sciid = data.sciid
	if sciid ~= nil then
		for i, v in ipairs(self.tableScienceList) do
			if v.singleDataType == SingleDataType.RECOMMEND or v.singleDataType == SingleDataType.OPEN then
				for si, sv in ipairs(v.data) do
					print(si, sv.id, type(sv.id), type(sciid))
					if sv.id == sciid then
						v.data[si] = allianceScience:getScienceData(sciid)
					end
				end
			end
		end
	end
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local tableOpenList = allianceScience:getScienceGroup()
	local tableNextList, needlv = allianceScience:getNextGroupSciIDList()
	if tableNextList and next(tableNextList) then
		if table.nums(tableOpenList) > #self.tableSingle then
			self:updateData()
		elseif table.nums(tableOpenList) == #self.tableSingle then
			self.tableSingle[#self.tableSingle]:updateNextGroup(false)
		end
	elseif tableNextList == nil and table.nums(tableOpenList) > #self.tableSingle then
		self.tableSingle[#self.tableSingle]:updateNextGroup(true)
	end
	local curPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	self.labelPoint:setString(string.formatnumberthousands(curPoint))
	SoraDToCenter(self.Node_point)
	self.labelScore:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
	SoraDToCenter(self.Node_score)
	_ENV = string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus"))
	string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")).lv = allianceScience:getCurSciTotalLv()
	self.labelLv:setString(i18n("common_text_2474", string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus"))))
end
function AllianceScienceView:jumpToSicence(sid)
	local allianceltCtrl = include("allianceltCtrl")
	local id = tonumber(allianceltCtrl.scienceAttr(sid, gAScienceInfo.GROUP))
	local tbIndex = 1
	for i, v in ipairs(self.tableSingle) do
		local isLaunch = v.tableSingleData.index == id
		v:setState(isLaunch)
		if isLaunch then
			tbIndex = i
		end
		tableAllianceScienceListState[i] = isLaunch
	end
	if not self.tableSingle[tbIndex]:jumpToSicence(sid) then
		self:updateScrollView()
	end
end
function AllianceScienceView:updateData()
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	self.tableScienceList, gametop = gametop.playertop_, gametop.playertop_
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local tableRecommand = allianceScience:getRecommendList()
	local tableOpenList = allianceScience:getScienceGroup()
	local tableNextList, needlv = allianceScience:getNextGroupSciIDList()
	local tbIndex = 1
	gametop = nil
	;(nil).index = 0
	;(nil).data = tableRecommand
	;(nil).singleDataType = 1
	self.tableScienceList[tbIndex], (nil).isOpened = nil, true
	tbIndex = tbIndex + 1
	local lastOpenIndex = 1
	for k, v in pairs(tableOpenList) do
		gametop = k
		k.index = tonumber(k)
		k.data = v
		k.singleDataType = 2
		self.tableScienceList[tonumber(k) + 1], k.isOpened = k, true
		tbIndex = tbIndex + 1
		lastOpenIndex = math.max(tonumber(k), lastOpenIndex)
	end
	if tableNextList and next(tableNextList) then
		gametop = pairs(tableOpenList)
		pairs(tableOpenList).index = lastOpenIndex + 1
		pairs(tableOpenList).data = tableNextList
		pairs(tableOpenList).singleDataType = 3
		pairs(tableOpenList).isOpened = false
		pairs(tableOpenList).needLv = needlv
		table.insert(self.tableScienceList, pairs(tableOpenList))
		tbIndex = tbIndex + 1
	end
	local curPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	self.labelPoint:setString(string.formatnumberthousands(curPoint))
	SoraDToCenter(self.Node_point)
	self.labelScore:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
	SoraDToCenter(self.Node_score)
	gametop = string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus"))
	string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")).lv = allianceScience:getCurSciTotalLv()
	self.labelLv:setString(i18n("common_text_2474", string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus"))))
	self:initScroll()
	self:updateScrollView()
end
function AllianceScienceView:initScroll()
	for i, v in ipairs(self.tableScienceList) do
		local single = self.tableSingle[i]
		if single == nil then
			single = SoraDCreatePanel("allianceScienceMenuSingle")
			single:setClickCallBack(handler(self, self.updateScrollView))
			single:setScroll(self.scrollScience)
			single:addTo(self.scrollScience)
			table.insert(self.tableSingle, single)
		end
		if tableAllianceScienceListState[i] == nil then
			table.insert(tableAllianceScienceListState, false)
		end
		single:initData(v)
		single:setState(tableAllianceScienceListState[i])
	end
end
function AllianceScienceView:updateScrollView(target, state)
	if target then
		tableAllianceScienceListState[target:getTag()] = state
	end
	local scrollInner = self.scrollScience:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 0
	for i = 1, #self.tableSingle do
		local single = self.tableSingle[#self.tableSingle - i + 1]
		scrollInnerNewH = scrollInnerNewH + single:getSingleH()
		single:setPosition(cc.p(320, scrollInnerNewH))
	end
	if scrollInnerNewH < self.scrollScience:getContentSize().height then
		local upto = self.scrollScience:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			v:setPositionY(v:getPositionY() + upto)
		end
		scrollInnerNewH = self.scrollScience:getContentSize().height
	end
	offsetY = math.max(self.scrollScience:getContentSize().height - scrollInnerNewH, math.min(0, offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)))
	self.scrollScience:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function AllianceScienceView:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
	end
end
return AllianceScienceView
