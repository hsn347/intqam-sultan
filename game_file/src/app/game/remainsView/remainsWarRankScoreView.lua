local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local ctGridScroll = include("ctGridScroll")
local remainsWarRankScoreView = class("remainsWarRankScoreView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
local MAX_REQ_NUM = 10
function remainsWarRankScoreView:ctor()
	self.node_self = SoraDGetExtendChildFromCCSByName(self, "Bottom_CCS_remainsWarRankScoreSingle_node")
	self.node_self:setPositionY(-self:getPanelOffsetHeight() + 195)
	self.node_bottom = SoraDGetChildByName(self, "Bottom_Node")
	self.node_bottom:setPositionY(-self:getPanelOffsetHeight() + 190)
	self.single = SoraDGetChildByName(self, "Node_score")
	self.single:setVisible(false)
	self.textTitleScore = SoraDGetChildByName(self, "text_title_score")
	self.textTitleName = SoraDGetChildByName(self, "text_title_name")
	self.textTitleScore:setString(i18n("remains_text_94"))
	self.textTitleName:setString(i18n("common_text_264"))
	self.text_tips = SoraDGetChildByName(self, "Center_Text_Tip")
	self.text_tips:setString(i18n("common_text_927"))
	self.text_tips:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_pm")
	self.rankList, _ENV, self.rankData, _ENV, self.myRankData, _ENV, self.scroll = ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll), ctGridScroll.new(self.scroll)
	self.sIndex = 1
	self.wGet = false
	self.initScroll = false
end
function remainsWarRankScoreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_RANK_SCORE_LIST", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function remainsWarRankScoreView:init()
	self:setSelfInfo()
	self:req4Data(self.sIndex)
end
function remainsWarRankScoreView:setSelfInfo()
	self.node_self:initSelfData(self.myRankData)
end
function remainsWarRankScoreView:req4Data(index)
	remainsTeamCtrl:getRankScoreList(index, MAX_REQ_NUM)
	local loading = SoraDShowLoading(self)
	local x, y = self.text_tips:getPosition()
	loading:setPosition(cc.p(x, y))
end
function remainsWarRankScoreView:initData(target, data)
	SoraDCloseLoading(self)
	if data.myInfo and next(data.myInfo) then
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
	if #self.rankData > 0 then
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
function remainsWarRankScoreView:initView()
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
function remainsWarRankScoreView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.wGet then
		self:req4Data(self.sIndex)
	end
end
function remainsWarRankScoreView:createSingle(info, index)
	local ocx = self.single:clone()
	local single = include("remainsWarRankScoreSingle").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setHandle(handler(self, self.queryPlayerInfo))
	info.rank = index
	single:initData(info)
	return ocx
end
function remainsWarRankScoreView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function remainsWarRankScoreView:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		local kid = data.kid
		self._queryInfo = true
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading(self)
	end
end
function remainsWarRankScoreView:testAddData()
	local base = #self.rankList
	self.rankList, _ENV = nil, nil
	for i = 1, base + 10 do
		_ENV = nil
		_ENV, (nil).index = base + i, base + i
		;(base + i).uid = i
		;(base + i).rankScore = i * 10000 + i
		;(base + i).nickName = "playerName"
		;(base + i).allianceAbb = "tst"
		;(nil).data, (base + i).kid = base + i, 1
		table.insert(self.rankList, nil)
	end
	self:initView()
end
return remainsWarRankScoreView
