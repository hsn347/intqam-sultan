local ctGridScroll = include("ctGridScroll")
local allianceDesRead = include("allianceDesRead")
local PyramidBattleSearch = class("pyramidBattleSearch", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleSearch")
	end
	return target
end)
function PyramidBattleSearch:ctor()
	_UPVALUE4_, self.myListData, _ENV = nil, nil, nil
	_UPVALUE3_, self.ocxStyle, (nil)[1] = nil, nil, "frame_alliance_pank_01.png"
	_UPVALUE3_, self.ocxStyle, (nil)[2] = nil, nil, "frame_alliance_pank_02.png"
	_UPVALUE3_, self.ocxStyle, (nil)[3] = nil, nil, "frame_alliance_pank_03.png"
	_UPVALUE3_, self.ocxStyle, (nil)[4] = nil, nil, "frame_alliance_pank_05.png"
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_search")
	self.scroll = ctGridScroll.new(self.scroll)
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.copyItem = SoraDGetChildByName(self, "Panel_item")
	self.txtMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.txtFieldSearch = SoraDGetChildByName(self, "TextField_search")
	self.txtNoRecord = SoraDGetChildByName(self, "Center_Text_noRecord")
	_ENV = "frame_alliance_pank_05.png"
	;("frame_alliance_pank_05.png").num = PYRAMIDBATTLE_MAX_SHOW
	self.txtFieldSearch:setPlaceHolder(i18n("common_text_3419", "frame_alliance_pank_05.png"))
	self.txtFieldSearch:setPlaceHolderColor(cc.c4b(180, 180, 180, 255))
	self.txtFieldSearch:setColor(cc.c3b(255, 255, 255))
	self.txtFieldSearch:setTextColor(cc.c3b(0, 0, 0))
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidSearch"):setTitle(i18n("common_text_166"))
	SoraDGetChildByName(self, "Text_integral"):setString(i18n("common_text_3414"))
	SoraDGetChildByName(self, "Text_victory"):setString(i18n("common_text_3403"))
	SoraDGetChildByName(self, "Text_name"):setString(i18n("common_text_2037"))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	self.txtNoRecord:setString(i18n("common_text_1464"))
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClick))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_SEARCHINFOBACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_RANKINFOBACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_SEARCHINFOERR", function(...)
		SoraDCloseLoading(self)
	end)
	self:defaultReq4Info()
end
function PyramidBattleSearch:defaultReq4Info(...)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	SoraDShowLoading(self)
	_ENV = nil
	;(nil).startrank = 1
	_ENV, (nil).endrank = nil, 50
	;(nil).pyramidBattleSearch = true
	pyramidWarCtrl:regularSeasonGetRankReq(gRegularSeasonRankReqType.RANGE, nil, nil)
end
function PyramidBattleSearch:req4Info(content)
	content = string.trim(content)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	SoraDShowLoading(self)
	_ENV = nil
	;(nil).keyname = content
	pyramidWarCtrl:regularSeasonGetRankReq(gRegularSeasonRankReqType.SEARCH, nil)
end
function PyramidBattleSearch:initData(target, redata)
	SoraDCloseLoading(self)
	dump(redata.info, "redata.info")
	if not redata.info.rankData then
		_ENV = redata.info.rankData
	end
	self.myListData = redata.info.rankData
	dump(self.myListData, "self.myListData")
	if redata.msg == "MESSAGE_SERVER_PYRAMIDBATTLE_SEARCHINFOBACK" and next(self.myListData) == nil then
		SoraDShowMsgTip(i18n("common_text_1061"))
	end
	self:initView()
end
function PyramidBattleSearch:initView(...)
	local selfFactory = function(tbl)
		local _ENV, reTbl
		for _, v in ipairs(tbl) do
			_ENV = nil
			;(nil).data = v
			table.insert(reTbl, nil)
		end
		return reTbl
	end
	if not self.firstInit then
		self.scroll:init(selfFactory(self.myListData), handler(self, self.createSingle), cc.size(640, 130))
		self.scroll:begin2Run()
		self.firstInit = true
	else
		self.scroll:setNewTable(selfFactory(self.myListData))
	end
	self:checkNoRecord()
end
function PyramidBattleSearch:checkNoRecord(...)
	if next(self.myListData) then
		self.txtNoRecord:setVisible(false)
	else
		self.txtNoRecord:setVisible(true)
	end
end
function PyramidBattleSearch:createSingle(info)
	local ocx = self.copyItem:clone()
	local imgFlag = ocx:getChildByName("Image_alliance")
	local sheer = ocx:getChildByName("Image_itemBg")
	local imgNum = ocx:getChildByName("Image_num")
	local txtNum = ocx:getChildByName("Text_num")
	local txtHonourPoint = ocx:getChildByName("Text_rankIntegral")
	local txtName = ocx:getChildByName("Text_itemName")
	local txtVictory = ocx:getChildByName("Text_itemVictory")
	local txtKing = ocx:getChildByName("Text_itemKing")
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL then
			txtNum:setVisible(false)
			imgNum:loadTexture(self.ocxNum[num], ccui.TextureResType.plistType)
		else
			imgNum:setVisible(false)
			txtNum:setString(num)
		end
	end
	local rank = info.rank
	switchNum(rank)
	if rank <= RANK_TOP_SPECIAL then
		sheer:loadTexture(self.ocxStyle[rank], ccui.TextureResType.plistType)
	else
		sheer:setVisible(false)
	end
	txtVictory:setString(string.format("%.1f", info.winrate * 100) .. "%")
	_ENV = info.winrate * 100
	;(info.winrate * 100).name = info.kid
	txtKing:setString(i18n("common_text_971", info.winrate * 100))
	txtHonourPoint:setString(info.honor)
	_ENV = i18n("common_text_971", info.winrate * 100)
	i18n("common_text_971", info.winrate * 100).abbr = info.abbr
	i18n("common_text_971", info.winrate * 100).name = info.name
	txtName:setString(i18n("common_text_186", i18n("common_text_971", info.winrate * 100)))
	local spFlag = SoraDGetAllianceFlagByFid(info.flag or 1)
	spFlag:addTo(imgFlag)
	spFlag:setPosition(imgFlag:getContentSize().width / 2, imgFlag:getContentSize().height / 2)
	imgFlag:loadTexture("bg_transparent.png", ccui.TextureResType.plistType)
	imgFlag:setTouchEnabled(true)
	imgFlag:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = nil
			;(nil).from = "PyramidBattleSearch"
			allianceQuery:reqAllianceInfo(info.kid, info.aid, nil)
		end
	end)
	return ocx
end
function PyramidBattleSearch:btnSearchClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local content = self.txtFieldSearch:getString()
		content = string.trim(content)
		local checkCondition = function(...)
			if string.len(content) < SEARCH_MIN_LEN then
				SoraDShowMsgTip(i18n("common_text_962"))
				return false
			end
			return true
		end
		if checkCondition() then
			self:req4Info(content)
			self.txtFieldSearch:setString("")
		end
	end
end
function PyramidBattleSearch:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "PyramidBattleSearch" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
return PyramidBattleSearch
