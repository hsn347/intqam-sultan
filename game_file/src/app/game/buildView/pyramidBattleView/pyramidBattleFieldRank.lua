local ctGridScroll = include("ctGridScroll")
local allianceDesRead = include("allianceDesRead")
local PyramidBattleFieldRank = class("pyramidBattleFieldRank", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleFieldRank")
	end
	return target
end)
function PyramidBattleFieldRank:ctor()
	self.insertDataDirection2Big = true
	self.ready2Jump = -1
	_ENV, self.myListData, _ENV, self.topIndex = nil, nil, nil, 2000
	;(nil).startrank = 1
	_UPVALUE4_, self.defaultRangTbl, (nil).endrank = nil, nil, 1
	_UPVALUE3_, self.ocxStyle, (nil)[1] = nil, nil, "frame_alliance_pank_01.png"
	_UPVALUE3_, self.ocxStyle, (nil)[2] = nil, nil, "frame_alliance_pank_02.png"
	_UPVALUE3_, self.ocxStyle, (nil)[3] = nil, nil, "frame_alliance_pank_03.png"
	_UPVALUE3_, self.ocxStyle, (nil)[4] = nil, nil, "frame_alliance_pank_05.png"
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_rank"):setTitle(i18n("common_text_851"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.scroll = ctGridScroll.new(self.scroll)
	self.copyItem = SoraDGetChildByName(self, "Panel_item")
	self.btnJump = SoraDGetChildByName(self, "Button_page")
	self.btnKing = SoraDGetChildByName(self, "Button_myKing")
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.btnMyRank = SoraDGetChildByName(self, "Button_jump")
	self.txtFieldRank = SoraDGetChildByName(self, "TextField_page")
	self.txtMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.nodeJump = SoraDGetChildByName(self, "Node_jump")
	self.txtNoRecord = SoraDGetChildByName(self, "Center_Text_noRecord")
	self.btnJump:setTitleText(i18n("common_text_382"))
	self.btnKing:setTitleText(i18n("common_text_3413"))
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.txtNoRecord:setString(i18n("common_text_1464"))
	SoraDGetChildByName(self, "Text_integral"):setString(i18n("common_text_3414"))
	SoraDGetChildByName(self, "Text_victory"):setString(i18n("common_text_3403"))
	SoraDGetChildByName(self, "Text_name"):setString(i18n("common_text_2037"))
	SoraDAutoSizeButtonText(self.btnJump, cc.size(140, 60))
	SoraDAutoSizeButtonText(self.btnKing, cc.size(140, 60))
	SoraDAutoSizeButtonText(self.btnSearch, cc.size(140, 60))
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClick))
	self.btnKing:addTouchEventListener(handler(self, self.btnKingClick))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClick))
	self.btnMyRank:addTouchEventListener(handler(self, self.btnMyRankClick))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_RANKINFOBACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_SEARCHINFOERR", function(...)
		SoraDCloseLoading(self)
	end)
	self:req4Info(self:rangFactory(25))
end
function PyramidBattleFieldRank:rangFactory(mIdx)
	local clamp = function(value, min, max)
		return math.max(math.min(value, max), min)
	end
	local sIdx = clamp(mIdx - 24, 1, self.topIndex)
	local eIdx = clamp(mIdx + 25, 1, self.topIndex)
	if mIdx - 24 <= 1 then
		sIdx = 1
		eIdx = 50
	elseif mIdx + 25 >= self.topIndex then
		sIdx = self.topIndex - 50 + 1
		eIdx = self.topIndex
	end
	_ENV = self.topIndex - 50
	;(self.topIndex - 50).startrank = sIdx
	self.defaultRangTbl, (self.topIndex - 50).endrank = self.topIndex - 50, eIdx
	return self.defaultRangTbl
end
function PyramidBattleFieldRank:rangForward(isForward)
	local clamp = function(value, min, max)
		return math.max(math.min(value, max), min)
	end
	dump(self.defaultRangTbl, "原范围")
	if not isForward and self.defaultRangTbl.startrank <= 1 then
		return false
	elseif isForward and self.defaultRangTbl.endrank >= self.topIndex then
		SoraDShowMsgTip(i18n("common_text_3416"))
		return false
	else
		print("开始计算")
		if isForward then
			local tmpEndRang = self.defaultRangTbl.endrank
			self.defaultRangTbl.endrank = clamp(self.defaultRangTbl.endrank + 50, 1, self.topIndex)
			if self.defaultRangTbl.endrank >= self.topIndex then
				self.defaultRangTbl.startrank = tmpEndRang + 1
			else
				self.defaultRangTbl.startrank = clamp(self.defaultRangTbl.startrank + 50, 1, self.topIndex)
			end
		else
			local tmpStartRang = self.defaultRangTbl.startrank
			self.defaultRangTbl.startrank = clamp(self.defaultRangTbl.startrank - 50, 1, self.topIndex)
			if self.defaultRangTbl.startrank <= 1 then
				self.defaultRangTbl.endrank = tmpStartRang - 1
			else
				self.defaultRangTbl.endrank = clamp(self.defaultRangTbl.endrank - 50, 1, self.topIndex)
			end
		end
		dump(self.defaultRangTbl, "后范围")
		return self.defaultRangTbl
	end
end
function PyramidBattleFieldRank:req4Info(rangTbl)
	dump(rangTbl, "rangTbl")
	if rangTbl.startrank and rangTbl.endrank then
		local gametop = gModuleMgr.getObject("gametop")
		local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
		SoraDShowLoading(self)
		pyramidWarCtrl:regularSeasonGetRankReq(gRegularSeasonRankReqType.RANGE, rangTbl)
	end
end
function PyramidBattleFieldRank:initData(target, redata)
	if redata.addData and redata.addData.pyramidBattleSearch then
		print("return 掉了")
		return
	end
	SoraDCloseLoading(self)
	local judge2Insert = function(tbl)
		if next(self.myListData) then
			if self.insertDataDirection2Big then
				for _, v in ipairs(tbl) do
					table.insert(self.myListData, v)
				end
			else
				for _, v in ipairs(self.myListData) do
					table.insert(tbl, v)
				end
				self.myListData = tbl
			end
		else
			self.myListData = tbl
		end
	end
	dump(redata.info, "redata.info")
	self.myRank = redata.info.myRank
	self.topIndex = redata.info.totalRank
	judge2Insert(redata.info.rankData)
	self:initView()
end
function PyramidBattleFieldRank:initView(...)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		if self.myRank > 0 then
			_ENV = nil
			;(nil).rank = self.myRank
			self.txtMyRank:setString(i18n("common_text_3342", nil))
		else
			_ENV = i18n("common_text_3342", nil)
			i18n("common_text_3342", nil).rank = i18n("common_text_827")
			self.txtMyRank:setString(i18n("common_text_3342", i18n("common_text_3342", nil)))
		end
	else
		self.txtMyRank:setString(i18n("common_text_826"))
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
		self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
		self.firstInit = true
	else
		self.scroll:setNewTable(selfFactory(self.myListData))
	end
	if 0 < self.ready2Jump then
		self.scroll:ctJumpToByRule(function(single)
			if single.data.rank == self.ready2Jump then
				return true
			else
				return false
			end
		end)
		self.ready2Jump = -1
	end
	self:checkNoRecord()
end
function PyramidBattleFieldRank:addNotice(...)
	local sSize = self.scroll:getContentSize()
	local warningTxt = ccui.Text:create(i18n("common_text_074"), "", 22)
	warningTxt:setAnchorPoint(cc.p(0.5, 0.5))
	warningTxt:setPosition(sSize.width / 2, -20)
	warningTxt:addTo(self.scroll)
end
function PyramidBattleFieldRank:checkNoRecord(...)
	if next(self.myListData) then
		self.txtNoRecord:setVisible(false)
		self:addNotice()
	else
		self.txtNoRecord:setVisible(true)
	end
end
function PyramidBattleFieldRank:scrollEventCallBack(scroll, eventType)
	if not next(self.myListData) then
		return
	end
	if eventType == ccui.ScrollviewEventType.scrolling then
	elseif eventType == ccui.ScrollviewEventType.bounceBottom then
		print("脱到底")
		self.insertDataDirection2Big = true
		local rangeTbl = self:rangForward(true)
		if rangeTbl then
			self:req4Info(rangeTbl)
		end
	elseif eventType == ccui.ScrollviewEventType.bounceTop then
		print("拖到顶")
		self.insertDataDirection2Big = false
		local rangeTbl = self:rangForward(false)
		if rangeTbl then
			self:req4Info(rangeTbl)
		end
	end
end
function PyramidBattleFieldRank:createSingle(info)
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
	print("rank=", rank)
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
	;(info.winrate * 100).name = info.kid
	txtKing:setString(i18n("common_text_971", info.winrate * 100))
	txtHonourPoint:setString(info.honor)
	_ENV = i18n("common_text_971", info.winrate * 100)
	i18n("common_text_971", info.winrate * 100).abbr = info.abbr
	i18n("common_text_971", info.winrate * 100).name = info.name
	txtName:setString(i18n("common_text_186", i18n("common_text_971", info.winrate * 100)))
	local spFlag = SoraDGetAllianceFlagByFid(info.flag and info.flag > 0 and info.flag or 1)
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
			;(nil).from = "PyramidBattleFieldRank"
			allianceQuery:reqAllianceInfo(info.kid, info.aid, nil)
		end
	end)
	return ocx
end
function PyramidBattleFieldRank:btnJumpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local oriNum = self.txtFieldRank:getString()
		local realNum = tonumber(oriNum)
		if realNum then
			if realNum <= self.topIndex and 0 < realNum then
				realNum = math.ceil(realNum)
				self:gotoRank(realNum)
				self.txtFieldRank:setString(realNum)
			else
				SoraDShowMsgTip(i18n("common_text_3417"))
			end
		else
			SoraDShowMsgTip(i18n("common_text_3417"))
		end
	end
end
function PyramidBattleFieldRank:btnKingClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidBattleMyRank"):show()
	end
end
function PyramidBattleFieldRank:btnMyRankClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self.txtMyRank:setScale(1.0)
		SoraDPlaySound()
		if self.myRank > 0 and self.myRank <= self.topIndex then
			SoraDPlaySound()
			self:gotoRank(self.myRank)
		elseif self.myRank <= 0 then
		else
			SoraDPlaySound()
			_ENV = nil
			;(nil).num = self.topIndex
			SoraDShowMsgTip(i18n("common_text_3415", nil))
		end
	elseif eventType == ccui.TouchEventType.began then
		self.txtMyRank:setScale(1.1)
	elseif eventType == ccui.TouchEventType.canceled then
		self.txtMyRank:setScale(1.0)
	end
end
function PyramidBattleFieldRank:gotoRank(rank)
	self.myListData, _UPVALUE0_ = nil, nil
	self.ready2Jump = rank
	self:req4Info(self:rangFactory(rank))
end
function PyramidBattleFieldRank:btnSearchClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidBattleSearch"):show()
	end
end
function PyramidBattleFieldRank:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "PyramidBattleFieldRank" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
return PyramidBattleFieldRank
