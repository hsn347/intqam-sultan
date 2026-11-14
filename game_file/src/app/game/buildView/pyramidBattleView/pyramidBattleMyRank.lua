local ctGridScroll = include("ctGridScroll")
local allianceDesRead = include("allianceDesRead")
local PyramidBattleMyRank = class("pyramidBattleMyRank", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleMyRank")
	end
	return target
end)
function PyramidBattleMyRank:ctor()
	_UPVALUE4_, self.myListData, _ENV, self.topIndex = PYRAMIDBATTLE_MAX_SHOW, PYRAMIDBATTLE_MAX_SHOW, PYRAMIDBATTLE_MAX_SHOW, PYRAMIDBATTLE_MAX_SHOW
	_UPVALUE3_, self.ocxStyle, PYRAMIDBATTLE_MAX_SHOW[1] = PYRAMIDBATTLE_MAX_SHOW, PYRAMIDBATTLE_MAX_SHOW, "frame_alliance_pank_01.png"
	_UPVALUE3_, self.ocxStyle, PYRAMIDBATTLE_MAX_SHOW[2] = PYRAMIDBATTLE_MAX_SHOW, PYRAMIDBATTLE_MAX_SHOW, "frame_alliance_pank_02.png"
	_UPVALUE3_, self.ocxStyle, PYRAMIDBATTLE_MAX_SHOW[3] = PYRAMIDBATTLE_MAX_SHOW, PYRAMIDBATTLE_MAX_SHOW, "frame_alliance_pank_03.png"
	_UPVALUE3_, self.ocxStyle, PYRAMIDBATTLE_MAX_SHOW[4] = PYRAMIDBATTLE_MAX_SHOW, PYRAMIDBATTLE_MAX_SHOW, "frame_alliance_pank_05.png"
	self.ocxNum, PYRAMIDBATTLE_MAX_SHOW[1] = PYRAMIDBATTLE_MAX_SHOW, "icon_ranking_1.png"
	self.ocxNum, PYRAMIDBATTLE_MAX_SHOW[2] = PYRAMIDBATTLE_MAX_SHOW, "icon_ranking_2.png"
	self.ocxNum, PYRAMIDBATTLE_MAX_SHOW[3] = PYRAMIDBATTLE_MAX_SHOW, "icon_ranking_3.png"
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_myRank")
	self.scroll = ctGridScroll.new(self.scroll)
	self.copyItem = SoraDGetChildByName(self, "Panel_item")
	self.txtNoRecord = SoraDGetChildByName(self, "Center_Text_noRecord")
	self.txtMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.nodeMyInfo = SoraDGetChildByName(self, "Node_myInfo")
	self.txtNoInfo = SoraDGetChildByName(self, "Text_noInfo")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_myRank"):setTitle(i18n("common_text_3413"))
	SoraDGetChildByName(self, "Text_integral"):setString(i18n("common_text_3414"))
	SoraDGetChildByName(self, "Text_victory"):setString(i18n("common_text_3403"))
	SoraDGetChildByName(self, "Text_name"):setString(i18n("common_text_2037"))
	_ENV = i18n("common_text_2037")
	i18n("common_text_2037").num = PYRAMIDBATTLE_MAX_SHOW
	SoraDGetChildByName(self, "Text_tip"):setString(i18n("common_text_3415", i18n("common_text_2037")))
	self.txtNoRecord:setString(i18n("common_text_1464"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MYKINGDOMRANKINFOBACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_SEARCHINFOERR", function(...)
		SoraDCloseLoading(self)
	end)
	self.btnJump:addTouchEventListener(handler(self, self.btnMyRankClick))
	self:req4Info()
end
function PyramidBattleMyRank:req4Info()
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	SoraDShowLoading(self)
	_ENV = nil
	pyramidWarCtrl:regularSeasonGetRankReq(gRegularSeasonRankReqType.SELF_KINGDOM, nil)
end
function PyramidBattleMyRank:initData(target, redata)
	SoraDCloseLoading(self)
	self.myRank = redata.info.myRank
	if not redata.info.rankData then
		_ENV = redata.info.rankData
	end
	self.myListData = redata.info.rankData
	self.myMyInfo = redata.info.myInfo
	dump(self.myListData, "self.myListData")
	self:initView()
end
function PyramidBattleMyRank:initView(...)
	local fillMyInfo = function(...)
		if self.myMyInfo and next(self.myMyInfo) then
			local imgFlag = self.nodeMyInfo:getChildByName("Image_myAlliance")
			local imgNum = self.nodeMyInfo:getChildByName("Image_myNum")
			local txtNum = self.nodeMyInfo:getChildByName("Text_myNum")
			local txtHonourPoint = self.nodeMyInfo:getChildByName("Text_myRankIntegral")
			local txtName = self.nodeMyInfo:getChildByName("Text_myItemName")
			local txtVictory = self.nodeMyInfo:getChildByName("Text_myItemVictory")
			local txtKing = self.nodeMyInfo:getChildByName("Text_myItemKing")
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
			switchNum(self.myMyInfo.rank)
			txtVictory:setString(string.format("%.1f", self.myMyInfo.winrate * 100) .. "%")
			self = self.myMyInfo.winrate * 100
			;(self.myMyInfo.winrate * 100).kid = self.myMyInfo.kid
			txtKing:setString(i18n("common_text_342", self.myMyInfo.winrate * 100))
			txtHonourPoint:setString(self.myMyInfo.honor)
			self = i18n("common_text_342", self.myMyInfo.winrate * 100)
			i18n("common_text_342", self.myMyInfo.winrate * 100).abbr = self.myMyInfo.abbr
			i18n("common_text_342", self.myMyInfo.winrate * 100).name = self.myMyInfo.name
			txtName:setString(i18n("common_text_186", i18n("common_text_342", self.myMyInfo.winrate * 100)))
			local spFlag = SoraDGetAllianceFlagByFid(self.myMyInfo.flag or 1)
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
					;(nil).from = "PyramidBattleMyRank"
					allianceQuery:reqAllianceInfo(self.myMyInfo.kid, self.myMyInfo.aid, nil)
				end
			end)
		end
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		if self.myRank > 0 then
			self.nodeMyInfo:setVisible(true)
			self.txtNoInfo:setVisible(false)
			fillMyInfo()
		else
			self.nodeMyInfo:setVisible(false)
			self.txtNoInfo:setVisible(true)
			self.txtNoInfo:setString(i18n("common_text_827"))
		end
	else
		self.nodeMyInfo:setVisible(false)
		self.txtNoInfo:setVisible(true)
		self.txtNoInfo:setString(i18n("common_text_826"))
	end
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
		self.scroll:init(selfFactory(self.myListData), handler(self, self.createSingle), cc.size(640, 125))
		self.scroll:begin2Run()
		self.firstInit = true
	else
		self.scroll:setNewTable(selfFactory(self.myListData))
	end
	self:checkNoRecord()
end
function PyramidBattleMyRank:checkNoRecord(...)
	if next(self.myListData) then
		self.txtNoRecord:setVisible(false)
	else
		self.txtNoRecord:setVisible(true)
	end
end
function PyramidBattleMyRank:createSingle(info)
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
	if rank == self.myRank then
		sheer:setVisible(true)
		sheer:loadTexture(self.ocxStyle[4], ccui.TextureResType.plistType)
	end
	txtVictory:setString(string.format("%.1f", info.winrate * 100) .. "%")
	_ENV = info.winrate * 100
	;(info.winrate * 100).kid = info.kid
	txtKing:setString(i18n("common_text_342", info.winrate * 100))
	txtHonourPoint:setString(info.honor)
	_ENV = i18n("common_text_342", info.winrate * 100)
	i18n("common_text_342", info.winrate * 100).abbr = info.abbr
	i18n("common_text_342", info.winrate * 100).name = info.name
	txtName:setString(i18n("common_text_186", i18n("common_text_342", info.winrate * 100)))
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
			;(nil).from = "PyramidBattleMyRank"
			allianceQuery:reqAllianceInfo(info.kid, info.aid, nil)
		end
	end)
	return ocx
end
function PyramidBattleMyRank:btnMyRankClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.myRank <= self.topIndex then
			self.scroll:ctJumpToByRule(function(single)
				if single.data.rank == self.myRank then
					return true
				else
					return false
				end
			end)
		elseif self.myRank <= 0 then
		else
			_ENV = nil
			;(nil).num = PYRAMIDBATTLE_MAX_SHOW
			SoraDShowMsgTip(i18n("common_text_3419", nil))
		end
	end
end
function PyramidBattleMyRank:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "PyramidBattleMyRank" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
return PyramidBattleMyRank
