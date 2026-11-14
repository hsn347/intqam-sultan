local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityltCtrl = include("cityltCtrl")
local RankingsScrollSingle = class("rankingsScrollSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rankingsScrollSingle")
	end
	return target
end)
function RankingsScrollSingle:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.handle = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.spriteIndex = SoraDGetChildByName(self, "Sprite_index")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.spriteWar = SoraDGetChildByName(self, "Sprite_war")
	self.spriteWar:setVisible(false)
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.labelIndex = SoraDGetChildByName(self, "Text_index")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.labelNum = SoraDGetChildByName(self, "Text_num")
	self.imgBarBg = SoraDGetChildByName(self, "Image_barBg")
	if self.layerTouch then
		self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function RankingsScrollSingle:setScroll(scroll)
	self.scroll = scroll
end
function RankingsScrollSingle:setHandle(handle)
	self.handle = handle
end
function RankingsScrollSingle:initData(singleData)
	if singleData == nil then
		return
	end
	self.tableSingleData = singleData
	local rank = self.tableSingleData.rank
	if self.tableSingleData.type == lordRankingsDef.partyRank then
		self.tableSingleData.rank = self.tableSingleData.data.rank
	end
	self.labelIndex:setVisible(self.tableSingleData.rank > RANK_TOP_SPECIAL)
	self.spriteIndex:setVisible(self.tableSingleData.rank <= RANK_TOP_SPECIAL)
	self.imgBarBg:setVisible(self.tableSingleData.rank <= RANK_TOP_SPECIAL or self.tableSingleData.isOwn)
	self.labelIndex:setString(tostring(self.tableSingleData.rank))
	if self.tableSingleData.rank <= RANK_TOP_SPECIAL then
		self.spriteIndex:setSpriteFrame("icon_ranking_" .. self.tableSingleData.rank .. ".png")
		self.imgBarBg:loadTexture("frame_alliance_pank_0" .. self.tableSingleData.rank .. ".png", ccui.TextureResType.plistType)
	end
	if self.tableSingleData.isOwn and self.tableSingleData.rank > RANK_TOP_SPECIAL then
		self.imgBarBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
	end
	if self.tableSingleData.type == lordRankingsDef.alliancePower or self.tableSingleData.type == lordRankingsDef.allianceKill or self.tableSingleData.type == lordRankingsDef.allianceTerrScore then
		local allianceDesRead = include("allianceDesRead")
		self.imgHead:setVisible(false)
		self.nodeFlag:setVisible(true)
		self.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(self.tableSingleData.data.flag, self.nodeFlag)
		_ENV = tostring(self.tableSingleData.rank)
		tostring(self.tableSingleData.rank).abbr = self.tableSingleData.data.allianceAbbr
		tostring(self.tableSingleData.rank).name = self.tableSingleData.data.allianceName
		self.labelName:setString(i18n("common_text_186", tostring(self.tableSingleData.rank)))
		_ENV = i18n("common_text_186", tostring(self.tableSingleData.rank))
		i18n("common_text_186", tostring(self.tableSingleData.rank)).name = self.tableSingleData.data.leaderName
		self.labelAlliance:setString(i18n("common_text_170", i18n("common_text_186", tostring(self.tableSingleData.rank))))
		self.labelNum:setPositionX(SoraDFPosX(200))
	else
		local lordLocalData = include("lordLocalData")
		self.imgHead:setVisible(true)
		self.nodeFlag:setVisible(false)
		SoraDGetHeadFromManager(self.imgHead, self.tableSingleData.data.imageId, self.tableSingleData.data.avatar)
		local name = self.tableSingleData.data.nickName
		if self.tableSingleData.data.allianceAbbr then
			_ENV = self.tableSingleData.data.avatar
			self.tableSingleData.data.avatar.abbr = self.tableSingleData.data.allianceAbbr
			self.tableSingleData.data.avatar.name = self.tableSingleData.data.nickName
			name = i18n("common_text_186", self.tableSingleData.data.avatar)
		end
		if lordRankingsDef.eidTycoonGlobalStage == self.tableSingleData.type then
			name = name .. " " .. "#" .. self.tableSingleData.data.kid
		end
		self.labelName:setString(name)
		local alliance = ""
		if self.tableSingleData.data.allianceName then
			_ENV = self.tableSingleData.data.kid
			self.tableSingleData.data.kid.conten = self.tableSingleData.data.allianceName
			alliance = i18n("common_text_925", self.tableSingleData.data.kid)
		else
			_ENV = self.tableSingleData.data.kid
			self.tableSingleData.data.kid.conten = i18n("common_text_826")
			alliance = i18n("common_text_925", self.tableSingleData.data.kid)
		end
		self.labelAlliance:setString(alliance)
	end
	if lordRankingsDef.achieveDoneRatio == self.tableSingleData.type then
		local constantRead = include("constantRead")
		local maxStar = constantRead.getConstValue("ACHIEVE_SHOW_PERCENTAGE_MAX_STAR", MEDAL_TOTAL_STAR)
		local pCount = SoraDPreciseDecimal(self.tableSingleData.data.ranking / maxStar * 100, 2)
		self.labelNum:setString(string.format("%.2f%%", pCount))
	elseif self.tableSingleData.type == lordRankingsDef.lordPower or self.tableSingleData.type == lordRankingsDef.lordKill then
		self.labelNum:setPositionX(SoraDFPosX(200))
		self.labelNum:setString(string.formatnumberthousands(self.tableSingleData.data.ranking))
	elseif self.tableSingleData.type == lordRankingsDef.lordCastle then
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(self.tableSingleData.data.ranking)
		self.spriteWar:setVisible(warLv >= CASTLE_MIN_WARLV)
		if 0 <= warLv then
			if warLv == 0 then
				warLv = CASTLE_MAXLV_NOWAR
			end
			self.labelNum:setString(string.formatnumberthousands(warLv))
		else
			self.labelNum:setString(string.formatnumberthousands(self.tableSingleData.data.ranking))
		end
		self.spriteWar:setSpriteFrame("icon_main_honourgrade.png")
		self.spriteWar:setScale(0.8)
		if SoraDFIsRA() then
			self.spriteWar:setPositionX(175)
		else
			self.spriteWar:setPositionX(470)
		end
	elseif self.tableSingleData.type == lordRankingsDef.flowerNum then
		self.spriteWar:setVisible(true)
		self.spriteWar:setSpriteFrame("8029.png")
		self.labelNum:setString(string.formatnumberthousands(self.tableSingleData.data.ranking))
		self.labelNum:setAnchorPoint(SoraDFAP(1, 0.5))
		self.labelNum:setPositionX(SoraDFPosX(175, self.labelNum))
		self.spriteWar:setPositionX(SoraDFPosX(205, self.spriteWar))
		if SoraDFIsRA() then
			self.labelNum:setPositionX(100)
			self.spriteWar:setPositionX(150)
		else
			self.labelNum:setPositionX(520)
			self.spriteWar:setPositionX(480)
		end
	elseif self.tableSingleData.type == lordRankingsDef.militaryRank then
		local militaryRankRead = include("militaryRankRead")
		self.labelNum:setString(militaryRankRead.getRankNameByLv(self.tableSingleData.data.level))
		self.labelNum:setAnchorPoint(SoraDFAP(1, 0.5))
		self.labelNum:setPositionX(SoraDFPosX(170, 620))
		self.labelNum:ignoreContentAdaptWithSize(false)
		self.labelNum:setTextAreaSize(cc.size(180, 50))
		self.spriteWar:setVisible(true)
		self.spriteWar:setScale(1)
		if SoraDFIsRA() then
			self.spriteWar:setPositionX(170)
		else
			self.spriteWar:setPositionX(430)
		end
		self.spriteWar:setSpriteFrame(militaryRankRead.getRankIconByLv(self.tableSingleData.data.level))
		local name = self.tableSingleData.data.nickName
		if self.tableSingleData.data.allianceName then
			_ENV = militaryRankRead.getRankIconByLv(self.tableSingleData.data.level)
			militaryRankRead.getRankIconByLv(self.tableSingleData.data.level).abbr = self.tableSingleData.data.allianceName
			militaryRankRead.getRankIconByLv(self.tableSingleData.data.level).name = self.tableSingleData.data.nickName
			name = i18n("common_text_186", militaryRankRead.getRankIconByLv(self.tableSingleData.data.level))
		end
		self.labelName:setString(name)
		_ENV = militaryRankRead.getRankIconByLv(self.tableSingleData.data.level)
		militaryRankRead.getRankIconByLv(self.tableSingleData.data.level).kid = self.tableSingleData.data.kid
		self.labelAlliance:setString(i18n("common_text_342", militaryRankRead.getRankIconByLv(self.tableSingleData.data.level)))
	elseif self.tableSingleData.type == lordRankingsDef.partyRank then
		self.imgHead:setVisible(true)
		self.nodeFlag:setVisible(false)
		SoraDGetHeadFromManager(self.imgHead, self.tableSingleData.data.headid, self.tableSingleData.data.avatar)
		local name = self.tableSingleData.data.nickName
		if self.tableSingleData.data.allianceAbbr and self.tableSingleData.data.allianceAbbr ~= "" then
			_ENV = self.tableSingleData.data.avatar
			self.tableSingleData.data.avatar.abbr = self.tableSingleData.data.allianceAbbr
			self.tableSingleData.data.avatar.name = self.tableSingleData.data.nickName
			name = i18n("common_text_186", self.tableSingleData.data.avatar)
		end
		self.labelName:setString(string.format("%s#%d", name, self.tableSingleData.data.kid))
		self.labelNum:setString(string.formatnumberthousands(self.tableSingleData.data.score))
		self.labelAlliance:setVisible(false)
		self.labelName:setPositionY(45)
	elseif self.tableSingleData.type == lordRankingsDef.lordCastleStarLamp then
		local starLv = self.tableSingleData.data.ranking
		self.labelNum:setString(starLv)
		self.spriteWar:setVisible(true)
		local image = cityltCtrl.getBuildStarImage(starLv)
		self.spriteWar:setSpriteFrame(image)
		self.spriteWar:setScale(0.8)
		self.spriteWar:setPositionX(SoraDFIsRA() and 175 or 470)
	else
		self.labelNum:setString(string.formatnumberthousands(self.tableSingleData.data.ranking))
	end
end
function RankingsScrollSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.tableSingleData.type == lordRankingsDef.alliancePower or self.tableSingleData.type == lordRankingsDef.allianceKill or self.tableSingleData.type == lordRankingsDef.allianceTerrScore then
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			SoraDShowLoading(SoraDSearchPanelFromManagerByName("rankingsView"))
			_ENV = SoraDSearchPanelFromManagerByName("rankingsView")
			_ENV, SoraDSearchPanelFromManagerByName("rankingsView").aid = self.tableSingleData.data.aid, self.tableSingleData.data.aid
			self.tableSingleData.data.aid.from = "rankings"
			allianceQuery:reqAllianceByID(SoraDSearchPanelFromManagerByName("rankingsView"))
		elseif self.tableSingleData.type == lordRankingsDef.alibabaTreasureRank then
			local kid = gametop.playertop_:getKingdomID()
			_ENV = allianceQuery.reqAllianceByID
			allianceQuery.reqAllianceByID.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			allianceQuery.reqAllianceByID.playerID = self.tableSingleData.data.uid
			allianceQuery.reqAllianceByID.kid = kid
			SoraDSendMessage(allianceQuery.reqAllianceByID)
		elseif not self.tableSingleData.isOwn then
			local chatConst = include("chatConst")
			_UPVALUE3_ = "chatConst"
			;("chatConst")[1] = chatConst.OpId.OpSendEmail
			;("chatConst")[2] = chatConst.OpId.OpViewInfo
			local ("chatConst")[3], menuData = chatConst.OpId.OpShield, "chatConst"
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if curLevel >= CASTLE_LV10_LIMITED then
				table.insert(menuData, chatConst.OpId.OpSendFlower)
			end
			_ENV = SoraDSearchPanelFromManagerByName("rankingsView")
			SoraDSearchPanelFromManagerByName("rankingsView").kid = self.tableSingleData.data.kid
			SoraDSearchPanelFromManagerByName("rankingsView").playerId = self.tableSingleData.data.uid
			SoraDSearchPanelFromManagerByName("rankingsView").nickName = self.tableSingleData.data.nickName
			SoraDSearchPanelFromManagerByName("rankingsView").allianceAbbr = self.tableSingleData.data.allianceAbbr
			SoraDShowPlayerOperatePanel(self.tableSingleData.data.nickName, menuData, SoraDSearchPanelFromManagerByName("rankingsView"))
		else
			SoraDOpenLordView(lordInfoCtrl:getLordInfo())
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function RankingsScrollSingle:showOtherInfoView(data)
	local chatConst = include("chatConst")
	_UPVALUE3_ = "chatConst"
	;("chatConst")[1] = chatConst.OpId.OpSendEmail
	;("chatConst")[2] = chatConst.OpId.OpViewInfo
	local ("chatConst")[3], menuData = chatConst.OpId.OpShield, "chatConst"
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if curLevel >= CASTLE_LV10_LIMITED then
		table.insert(menuData, chatConst.OpId.OpSendFlower)
	end
	_ENV = nil
	;(nil).kid = data.kid
	;(nil).playerId = data.uid
	;(nil).nickName = data.nickName
	;(nil).allianceAbbr = data.allianceAbbr
	SoraDShowPlayerOperatePanel(data.nickName, menuData, nil)
end
function RankingsScrollSingle:showSelfInfoView(...)
	SoraDOpenLordView(lordInfoCtrl:getLordInfo())
end
return RankingsScrollSingle
