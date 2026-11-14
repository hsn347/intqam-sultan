local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local cityltCtrl = include("cityltCtrl")
local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local constantRead = include("constantRead")
local buildLogic = include("buildLogic")
local militaryRankRead = include("militaryRankRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_userRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_userRankSingle", Com_userRankSingle)
function Com_userRankSingle:onInit()
	self.fields.icon_ex:setVisible(false)
	self.fields.Com_head:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
	self.fields.selfBg:fix()
	self.fields.bg1:fix()
	self.fields.bg2:fix()
	self.fields.bg3:fix()
end
function Com_userRankSingle:onShow()
end
function Com_userRankSingle:initSelfData(data, enum, league)
	self.controllers.c1:setSelectedIndex(0)
	local ownInfo = lordInfoCtrl:getLordInfo()
	local maxCount = (enum == lordRankingsDef.alliancePower or enum == lordRankingsDef.allianceKill or enum == lordRankingsDef.allianceTerrScore) and RANK_ALLIANCE_MAX_SHOW or RANK_MAX_SHOW
	if enum == lordRankingsDef.militaryRank then
		maxCount = RANK_MILITARY_MAX_SHOW
	end
	self.fields.Text_index:setVisible(true)
	local rankMsg = league
	if league <= 0 or league > maxCount then
		rankMsg = i18n("common_text_827")
		if (enum == lordRankingsDef.alliancePower or enum == lordRankingsDef.allianceKill or enum == lordRankingsDef.allianceTerrScore) and not allianceMgr:hasJoinAlliance() then
			rankMsg = i18n("common_text_826")
		end
	end
	self.fields.Text_index:setString(rankMsg)
	local ownAlliance = allianceMgr:getAlliance()
	if (enum == lordRankingsDef.alliancePower or enum == lordRankingsDef.allianceKill or enum == lordRankingsDef.allianceTerrScore) and ownAlliance ~= nil then
		self.fields.Com_head:setVisible(false)
		self.fields.flag:setVisible(true)
		local flagNode = allianceDesRead.getFlagNode(data.flag)
		flagNode:setScale(0.48)
		flagNode:setPosition(50, 50)
		self.fields.flag:setContent(flagNode)
		lordInfoCtrl = nil
		;(nil).abbr = ownAlliance:getProperty("abbr")
		;(nil).name = ownAlliance:getProperty("name")
		self.fields.Text_name:setString(i18n("common_text_186", nil))
		lordInfoCtrl = i18n("common_text_186", nil)
		i18n("common_text_186", nil).name = ownAlliance:getProperty("leaderName")
		self.fields.Text_alliance:setString(i18n("common_text_170", i18n("common_text_186", nil)))
		self.fields.Text_name:setPositionY(35)
		self.fields.Text_alliance:setVisible(true)
	else
		self.fields.Com_head:setVisible(true)
		self.fields.flag:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.imageId, data.avatar)
		self.fields.Text_name:setString(ownInfo.base.nickName)
		self.fields.Text_name:setPositionY(55)
		self.fields.Text_alliance:setVisible(false)
	end
	self.fields.icon_ex:setVisible(false)
	if enum == lordRankingsDef.achieveDoneRatio then
		self.fields.Text_score:setString(string.format("%.2f%%", ownInfo.achieveInfo.doneRatio))
	elseif enum == lordRankingsDef.lordCastle then
		local warLv = buildLogic.transformBuildLvToWarLv(data.ranking)
		self.fields.icon_ex:setVisible(warLv >= CASTLE_MIN_WARLV)
		self.fields.icon_ex:setSpriteFrame("icon_main_honourgrade.png")
		if 0 <= warLv then
			if warLv == 0 then
				warLv = CASTLE_MAXLV_NOWAR
			end
			self.fields.Text_score:setString(string.formatnumberthousands(warLv))
		else
			self.fields.Text_score:setString(string.formatnumberthousands(data.ranking))
		end
	elseif enum == lordRankingsDef.flowerNum then
		self.fields.icon_ex:setVisible(true)
		self.fields.icon_ex:setSpriteFrame("8029.png")
		self.fields.Text_score:setString(string.formatnumberthousands(data.ranking))
	elseif enum == lordRankingsDef.militaryRank then
		self.fields.icon_ex:setVisible(true)
		local level = data.level
		local ranking = data.ranking or 0
		if ranking <= 0 and ownInfo.militaryRankInfo then
			level = ownInfo.militaryRankInfo.level
		end
		self.fields.icon_ex:setSpriteFrame(militaryRankRead.getRankIconByLv(level))
		self.fields.Text_score:setString(militaryRankRead.getRankNameByLv(level))
	elseif enum == lordRankingsDef.lordCastleStarLamp then
		local starLv = data.ranking
		self.fields.Text_score:setString(starLv)
		self.fields.icon_ex:setVisible(true)
		local image = cityltCtrl.getBuildStarImage(starLv)
		self.fields.icon_ex:setSpriteFrame(image)
	elseif enum == lordRankingsDef.htStage then
		self.fields.icon_ex:setVisible(false)
		local heroTrialCommon = include("heroTrialCommon")
		self.fields.Text_score:setString(data.ranking ~= 0 and heroTrialCommon.convertLevelToNum(data.ranking) or 0)
	else
		self.fields.icon_ex:setVisible(false)
		self.fields.Text_score:setString(string.formatnumberthousands(data.ranking))
	end
end
function Com_userRankSingle:initData(data, rank, enum, league, isKingdomBattle)
	self.data = data
	self.rank = rank
	self.enum = enum
	self.league = league
	self.isKingdomBattle = isKingdomBattle
	self.fields.icon_ex:setVisible(false)
	if self.rank <= RANK_TOP_SPECIAL then
		self.controllers.c1:setSelectedIndex(self.rank)
	else
		if self.rank == self.league then
			self.controllers.c1:setSelectedIndex(4)
		else
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.Text_index:setString(self.rank)
	end
	if self.enum == lordRankingsDef.alliancePower or self.enum == lordRankingsDef.allianceKill or self.enum == lordRankingsDef.allianceTerrScore then
		self.fields.Com_head:setVisible(false)
		self.fields.flag:setVisible(true)
		local flagNode = allianceDesRead.getFlagNode(self.data.flag)
		flagNode:setScale(0.48)
		flagNode:setPosition(50, 50)
		self.fields.flag:setContent(flagNode)
		_ENV = nil
		;(nil).abbr = self.data.allianceAbbr
		;(nil).name = self.data.allianceName
		self.fields.Text_name:setString(i18n("common_text_186", nil))
		_ENV = i18n("common_text_186", nil)
		i18n("common_text_186", nil).name = self.data.leaderName
		self.fields.Text_alliance:setString(i18n("common_text_170", i18n("common_text_186", nil)))
	else
		self.fields.Com_head:setVisible(true)
		self.fields.flag:setVisible(false)
		self.fields.Com_head:setHeadSprite(self.data.imageId, self.data.avatar)
		local name = self.data.nickName
		if self.data.allianceAbbr then
			_ENV = self.data.avatar
			self.data.avatar.abbr = self.data.allianceAbbr
			self.data.avatar.name = self.data.nickName
			name = i18n("common_text_186", self.data.avatar)
		end
		if lordRankingsDef.eidTycoonGlobalStage == self.enum then
			name = name .. " " .. "#" .. self.data.kid
		end
		self.fields.Text_name:setString(name)
		local alliance = ""
		if self.data.allianceName then
			_ENV = self.data.kid
			self.data.kid.conten = self.data.allianceName
			alliance = i18n("common_text_925", self.data.kid)
		else
			_ENV = self.data.kid
			self.data.kid.conten = i18n("common_text_826")
			alliance = i18n("common_text_925", self.data.kid)
		end
		self.fields.Text_alliance:setString(alliance)
	end
	if self.enum == lordRankingsDef.achieveDoneRatio then
		local maxStar = constantRead.getConstValue("ACHIEVE_SHOW_PERCENTAGE_MAX_STAR", MEDAL_TOTAL_STAR)
		local pCount = SoraDPreciseDecimal(self.data.ranking / maxStar * 100, 2)
		self.fields.Text_score:setString(string.format("%.2f%%", pCount))
	elseif self.enum == lordRankingsDef.lordPower or self.enum == lordRankingsDef.lordKill then
		self.fields.Text_score:setString(string.formatnumberthousands(self.data.ranking))
	elseif self.enum == lordRankingsDef.lordCastle then
		self.fields.icon_ex:setVisible(true)
		local warLv = buildLogic.transformBuildLvToWarLv(self.data.ranking)
		self.fields.icon_ex:setVisible(warLv >= CASTLE_MIN_WARLV)
		if 0 <= warLv then
			if warLv == 0 then
				warLv = CASTLE_MAXLV_NOWAR
			end
			self.fields.Text_score:setString(string.formatnumberthousands(warLv))
		else
			self.fields.Text_score:setString(string.formatnumberthousands(self.data.ranking))
		end
		self.fields.icon_ex:setSpriteFrame("icon_main_honourgrade.png")
	elseif self.enum == lordRankingsDef.flowerNum then
		self.fields.icon_ex:setVisible(true)
		self.fields.icon_ex:setSpriteFrame("8029.png")
		self.fields.Text_score:setString(string.formatnumberthousands(self.data.ranking))
	elseif self.enum == lordRankingsDef.militaryRank then
		self.fields.icon_ex:setVisible(true)
		self.fields.Text_score:setString(militaryRankRead.getRankNameByLv(self.data.level))
		self.fields.icon_ex:setSpriteFrame(militaryRankRead.getRankIconByLv(self.data.level))
		local name = self.data.nickName
		if self.data.allianceName then
			_ENV = militaryRankRead.getRankIconByLv(self.data.level)
			militaryRankRead.getRankIconByLv(self.data.level).abbr = self.data.allianceName
			militaryRankRead.getRankIconByLv(self.data.level).name = self.data.nickName
			name = i18n("common_text_186", militaryRankRead.getRankIconByLv(self.data.level))
		end
		self.fields.Text_name:setString(name)
		_ENV = militaryRankRead.getRankIconByLv(self.data.level)
		militaryRankRead.getRankIconByLv(self.data.level).kid = self.data.kid
		self.fields.Text_alliance:setString(i18n("common_text_342", militaryRankRead.getRankIconByLv(self.data.level)))
	elseif self.enum == lordRankingsDef.partyRank then
		self.fields.Com_head:setVisible(true)
		self.fields.flag:setVisible(false)
		self.fields.Com_head:setHeadSprite(self.data.headid, self.data.avatar)
		local name = self.data.nickName
		if self.data.allianceAbbr and self.data.allianceAbbr ~= "" then
			_ENV = self.data.avatar
			self.data.avatar.abbr = self.data.allianceAbbr
			self.data.avatar.name = self.data.nickName
			name = i18n("common_text_186", self.data.avatar)
		end
		self.fields.Text_name:setString(string.format("%s#%d", name, self.data.kid))
		self.fields.Text_score:setString(string.formatnumberthousands(self.data.score))
		self.fields.Text_alliance:setVisible(false)
	elseif self.enum == lordRankingsDef.lordCastleStarLamp then
		self.fields.icon_ex:setVisible(true)
		local starLv = self.data.ranking
		self.fields.Text_score:setString(starLv)
		self.fields.icon_ex:setSpriteFrame(cityltCtrl.getBuildStarImage(starLv))
	elseif enum == lordRankingsDef.htStage then
		local heroTrialCommon = include("heroTrialCommon")
		self.fields.Text_score:setString(self.data.ranking ~= 0 and heroTrialCommon.convertLevelToNum(self.data.ranking) or 0)
	else
		self.fields.Text_score:setString(string.formatnumberthousands(self.data.ranking))
	end
end
function Com_userRankSingle:btnClick()
	SoraDPlaySound()
	if self.enum == lordRankingsDef.alliancePower or self.enum == lordRankingsDef.allianceKill or self.enum == lordRankingsDef.allianceTerrScore then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		_ENV = nil
		_ENV, (nil).aid = self.data.aid, self.data.aid
		self.data.aid.from = "rankings"
		allianceQuery:reqAllianceByID(nil, self.data.aid)
	elseif self.enum == lordRankingsDef.alibabaTreasureRank then
		local kid = gametop.playertop_:getKingdomID()
		_ENV = allianceQuery.reqAllianceByID
		allianceQuery.reqAllianceByID.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		allianceQuery.reqAllianceByID.playerID = self.data.uid
		allianceQuery.reqAllianceByID.kid = kid
		SoraDSendMessage(allianceQuery.reqAllianceByID)
	elseif self.data and not self.data.isOwn then
		if self.isKingdomBattle then
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			SoraDSendMessage.playerID = self.data.uid
			SoraDSendMessage.kid = self.data.kid
			SoraDSendMessage.isKingdomBattle = self.isKingdomBattle
			SoraDSendMessage(SoraDSendMessage)
		else
			local chatConst = include("chatConst")
			_UPVALUE3_ = "chatConst"
			;("chatConst")[1] = chatConst.OpId.OpSendEmail
			;("chatConst")[2] = chatConst.OpId.OpViewInfo
			local ("chatConst")[3], menuData = chatConst.OpId.OpShield, "chatConst"
			if SoraDGetCastleLv() >= CASTLE_LV10_LIMITED then
				table.insert(menuData, chatConst.OpId.OpSendFlower)
			end
			_ENV = self.data.aid
			self.data.aid.kid = self.data.kid
			self.data.aid.playerId = self.data.uid
			self.data.aid.nickName = self.data.nickName
			self.data.aid.allianceAbbr = self.data.allianceAbbr
			SoraDShowPlayerOperatePanel(self.data.nickName, menuData, self.data.aid)
		end
	else
		SoraDOpenLordView(lordInfoCtrl:getLordInfo())
	end
end
return Com_userRankSingle
