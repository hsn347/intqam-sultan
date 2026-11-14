local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local ctGridScroll = include("ctGridScroll")
local checknumber = _G.checknumber
local legendaryKingRank = class("legendaryKingRank", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendaryKingRank")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
local MAX_REQ_NUM = 10
function legendaryKingRank:ctor()
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_nodeBg_node", true)
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_node")
	self.commonFramTitle_node:setTitle(i18n("common_text_4232"))
	self.nodePhbTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_nodePhbTitle_node")
	self.nodePhbTitle_node:setType(1)
	self.nodewdpm_node = SoraDGetExtendChildFromCCSByName(self, "Bottom_CCS_nodewdpm_node")
	self.nodePhb_node = SoraDGetChildByName(self, "nodePhb_node")
	self.nodePhb_node:setVisible(false)
	self.text_tips = SoraDGetChildByName(self, "Center_Text_Tip")
	self.text_tips:setString(i18n("common_text_927"))
	self.text_tips:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_pm")
	self.scroll = ctGridScroll.new(self.scroll)
	self.rankList, _ENV, self.rankData, _ENV, self.myRankData, _ENV, self.myRank = ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), 0
	self.buildID = 0
	self.sIndex = 1
	self.wGet = false
	self.initScroll = false
end
function legendaryKingRank:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_OCCUPY_RANK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function legendaryKingRank:init(bid, mapid)
	self.mapid = mapid
	bid = bid or legendLordWarCtrl:getOpenBuildID(self.mapid)
	bid = bid or 0
	self.buildID = bid
	if self.mapid then
		self.activityID = worldMapDefine.getKingStarActivityID(self.mapid)
	end
	if self.activityID then
		legendLordWarCtrl = self.activityID
		self.activityID[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("common_text_4232")
		legendLordWarCtrl = nil
		;(nil).ranklist = i18n("remains_name_01")
		self.activityID[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text5", nil)
		legendLordWarCtrl = nil
		;(nil).ranklist = i18n("king_star_rank_text3")
		local self.activityID[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text5", nil), self.activityID
		self.commonFramTitle_node:setTitle(titleCfg[self.activityID] or i18n("common_text_4232"))
	end
	self:setSelfInfo()
	self:req4Data(self.sIndex)
end
function legendaryKingRank:setSelfInfo()
	self.nodewdpm_node:initData(self.myRankData)
end
function legendaryKingRank:req4Data(index)
	legendLordWarCtrl:getOccupyRankList(self.buildID, index, MAX_REQ_NUM, self.mapid)
	SoraDShowLoading(self)
end
function legendaryKingRank:initData(target, data)
	SoraDCloseLoading(self)
	if data.myInfo then
		local myInfo = data.myInfo
		if checknumber(myInfo.rank) > 0 then
			self.myRank = myInfo.rank
		end
		self.myRankData = data.myInfo
	end
	self.sIndex = data.idx
	self.wGet = data.wget
	self:setSelfInfo()
	if next(data.rankList) ~= nil then
		local cpyTbl = clone(data.rankList)
		for _, v in ipairs(cpyTbl) do
			table.insert(self.rankData, v)
		end
	end
	if 0 < #self.rankData then
		self.rankList, _ENV = #self.rankData, #self.rankData
		for i, v in ipairs(self.rankData) do
			v.rank = i
			_ENV = self.rankData
			self.rankData.index = i
			self.rankData.data = v
			table.insert(self.rankList, self.rankData)
		end
	end
	self:initView()
end
function legendaryKingRank:initView()
	if #self.rankList <= 0 then
		self.text_tips:setVisible(true)
		self.scroll:setVisible(false)
	else
		self.text_tips:setVisible(false)
		self.scroll:setVisible(true)
		if not self.initScroll then
			self.scroll:init(self.rankList, handler(self, self.createSingle), cc.size(640, 115))
			self.scroll:begin2Run()
			self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
			self.initScroll = true
		else
			self.scroll:setNewTable(self.rankList)
		end
	end
end
function legendaryKingRank:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.wGet then
		self:req4Data(self.sIndex)
	end
end
function legendaryKingRank:createSingle(info, index)
	local ocx = self.nodePhb_node:clone()
	local single = include("nodePhb").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setHandle(handler(self, self.queryPlayerInfo))
	info.rank = index
	single:initData(info, 2)
	return ocx
end
function legendaryKingRank:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function legendaryKingRank:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		local kid = data.sourceKid
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading(self)
	end
end
function legendaryKingRank:testAddData()
	local base = #self.rankList
	self.rankList, _ENV = nil, nil
	for i = 1, base + 10 do
		_ENV = nil
		;(nil).data, _ENV, (nil).index = base + i, base + i, base + i
		table.insert(self.rankList, nil)
	end
	self:initView()
end
return legendaryKingRank
