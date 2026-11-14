local nebulaWarRead = include("nebulaWarRead")
local lordLocalData = include("lordLocalData")
local nebulaAllStarRead = include("nebulaAllStarRead")
local RANK_TYPE = nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE
local roaringFlameWarRead = include("roaringFlameWarRead")
local mailNebulaAllStarRank = class("mailNebulaAllStarRank", function(target)
	if target == nil then
		return ccui.Layout:create()
	end
	return target
end)
function mailNebulaAllStarRank:ctor()
	self.totalH = 0
end
function mailNebulaAllStarRank:initWithData(contentData)
	self.contentData = contentData
	if not contentData.content then
		local _ENV, content = contentData.content, contentData.content
	end
	local contentType = contentData.contentType
	if contentType == gMailNPCContentType.Content_Nebula_AllStar_War_Win_War then
		self:initWinWar()
	elseif contentType == gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward then
		self:initCampOccupyRank()
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Win_War then
		self:initWinWar_RF()
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Score then
		if not content.rankData then
			local _ENV, rankData = content.rankData, content.rankData
		end
		self:initCampScoreRank_RF(rankData)
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Honor then
		_ENV = self
		if not content.rankData then
			_ENV = content.rankData
		end
		self.rankList = content.rankData
		self.title = i18n("flames_dunes_push47")
		self:initPersonRank_RF(self)
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Kill_Score then
		_ENV = self
		if not content.rankData then
			_ENV = content.rankData
		end
		self.rankList = content.rankData
		self.title = i18n("flames_dunes_push56")
		self:initPersonRank_RF(self)
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Phoenix_Damage then
		_ENV = self
		if not content.rankData then
			_ENV = content.rankData
		end
		self.rankList = content.rankData
		self.title = i18n("flames_dunes_text34")
		self:initPersonRank_RF(self)
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Honor then
		_ENV = self
		if not content.rankData then
			_ENV = content.rankData
		end
		self.rankList = content.rankData
		self.title = i18n("flames_dunes_push48")
		self:initPersonRank_RF(self)
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Camp_Score then
		if not content.rankData then
			local _ENV, rankData = content.rankData, content.rankData
		end
		self:initCampScoreRank_RF(rankData)
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Honor then
		_ENV = self
		if not content.rankData then
			_ENV = content.rankData
		end
		self.rankList = content.rankData
		self.title = i18n("flames_dunes_push39")
		self:initPersonRank_RF(self)
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Kill_Score then
		_ENV = self
		if not content.rankData then
			_ENV = content.rankData
		end
		self.rankList = content.rankData
		self.title = i18n("flames_dunes_text35")
		self:initPersonRank_RF(self)
	elseif contentType == gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Phoenix_Damage then
		_ENV = self
		if not content.rankData then
			_ENV = content.rankData
		end
		self.rankList = content.rankData
		self.title = i18n("flames_dunes_text34")
		self:initPersonRank_RF(self)
	elseif contentType == gMailNPCContentType.Content_RoaringFlame_Occupy_Palace then
		if not content.occupyPalaceRank then
			local _ENV, occupyPalaceRank = content.occupyPalaceRank, content.occupyPalaceRank
		end
		self:initCampOccupyRank_RF(occupyPalaceRank)
	else
		self:initPersonRank()
	end
	self:setContentSize(0, self.totalH)
end
function mailNebulaAllStarRank:initWinWar(...)
	if not self.contentData.content then
		local RANK_TYPE, content = self.contentData.content, self.contentData.content
	end
	if not content.supportPlayerValueRank then
		local RANK_TYPE, supportPlayerValueRank = content.supportPlayerValueRank, content.supportPlayerValueRank
	end
	self:initPersonRankData(supportPlayerValueRank, RANK_TYPE.SUPPORT_VALUE)
	if not content.starPlayerValueRank then
		local RANK_TYPE, starPlayerValueRank = content.starPlayerValueRank, content.starPlayerValueRank
	end
	self:initPersonRankData(starPlayerValueRank, RANK_TYPE.STAR_VALUE)
	if not content.playerCharmRank then
		local RANK_TYPE, playerCharmRank = content.playerCharmRank, content.playerCharmRank
	end
	self:initPersonRankData(playerCharmRank, RANK_TYPE.CHARM)
	if not content.campOccupyRank then
		local RANK_TYPE, campOccupyRank = content.campOccupyRank, content.campOccupyRank
	end
	self:initCampOccupyRankData(campOccupyRank)
end
function mailNebulaAllStarRank:initCampOccupyRank(...)
	if not self.contentData.content then
		local _UPVALUE0_, content = self.contentData.content, self.contentData.content
	end
	if not content.rankList then
		local _UPVALUE0_, rankList = content.rankList, content.rankList
	end
	self:initCampOccupyRankData(rankList)
end
function mailNebulaAllStarRank:initCampOccupyRankData(rankList, params)
	_ENV = nil
	;(nil).rankList = rankList
	;(nil).title = i18n("NebulaAllstar_356")
	;(nil).text1 = i18n("common_text_3154")
	;(nil).text2 = i18n("nebulaemperor_text_96")
	;(nil).text3 = i18n("legendaryking_title_01")
	;(nil).text2Func = function(data)
		return nebulaWarRead.getAreaName(data.camp)
	end
	;(nil).text3Func = function(data)
		return SoraDConvertSecondToString(data.occupyPalaceSecs or 0)
	end
	self:initMailNebulaAllStarRank1(nil)
end
function mailNebulaAllStarRank:initPersonRank(...)
	if not self.contentData.content then
		local _UPVALUE0_, content = self.contentData.content, self.contentData.content
	end
	if not content.rankList then
		local _UPVALUE0_, rankList = content.rankList, content.rankList
	end
	local rankType = self:getRankTypeByContentType(self.contentData.contentType)
	self:initPersonRankData(rankList, rankType)
end
function mailNebulaAllStarRank:initPersonRankData(rankList, rankType)
	local cfg = nebulaAllStarRead.getRankTypeConfig(rankType)
	local key = cfg.key or "value"
	local showTitle2 = cfg.showTitle2
	nebulaAllStarRead = nil
	;(nil).rankList = rankList
	;(nil).title = i18n(cfg.showTitle)
	;(nil).valueFunc = function(data)
		local value = data[key] or 0
		key = nil
		;(nil).num = string.formatnumberthousands(value)
		return i18n(showTitle2, nil)
	end
	;(nil).nameFunc = function(data)
		local areaAbbr = nebulaWarRead.getAreaAbbr(data.camp)
		nebulaWarRead = nil
		;(nil).abbr = areaAbbr
		;(nil).name = data.nickName
		return i18n("common_text_186", nil)
	end
	self:initMailNebulaAllStarRank2(nil)
end
function mailNebulaAllStarRank:getRankTypeByContentType(contentType)
	_ENV = nil
	;(nil)[gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward] = RANK_TYPE.CAMP_OCCUPY
	;(nil)[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Kill_Score_Rank_Reward] = RANK_TYPE.STAR_KILL_ARMY_SCORE
	;(nil)[gMailNPCContentType.Content_Nebula_AllStar_War_Support_Player_Kill_Score_Rank_Reward] = RANK_TYPE.SUPPORT_KILL_ARMY_SCORE
	;(nil)[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Rob_Value_Rank_Reward] = RANK_TYPE.STAR_ROB_VALUE
	;(nil)[gMailNPCContentType.Content_Nebula_AllStar_War_Support_Player_Rob_Value_Rank_Reward] = RANK_TYPE.SUPPORT_ROB_VALUE
	local (nil)[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Charm_Rank_Reward], config = RANK_TYPE.CHARM, nil
	return config[contentType]
end
function mailNebulaAllStarRank:initMailNebulaAllStarRank1(params)
	local node = SoraDCreateCSBNode("mailNebulaAllStarRank1")
	node:addTo(self)
	if not params.rankList then
		local _ENV, rankList = params.rankList, params.rankList
	end
	local singleH = 36
	local bgH = 62 - singleH / 2 + #rankList * singleH
	local totalH = bgH + 44 + 40
	self.totalH = self.totalH + totalH
	node:setPosition(0, self.totalH - 20)
	SoraDGetAllChildFromWidget(node, node)
	node.Image_bg:setContentSize(cc.size(node.Image_bg:getContentSize().width, bgH))
	node.Text_title:setString(params.title)
	local _ENV, _fields = node.Text_title.setString, node.Text_title.setString
	SoraDGetAllChildFromWidget(node.Node_rankTitle, _fields)
	_fields.Text_rank:setString(params.text1)
	_fields.Text_camp:setString(params.text2)
	_fields.Text_time:setString(params.text3)
	node.Node_rankSingle:setVisible(false)
	for rank, data in ipairs(rankList) do
		local single = node.Node_rankSingle:clone()
		single:addTo(node)
		single:setVisible(true)
		local beginPosY = node.Node_rankTitle:getPositionY() - 4
		single:setPosition(0, beginPosY - singleH * rank)
		SoraDGetAllChildFromWidget(single, single)
		local text1Value = tostring(rank)
		single.Text_rank:setString(text1Value)
		local text2Func = params.text2Func
		if text2Func then
			local text2Value = text2Func(data, single.Text_camp)
			single.Text_camp:setString(text2Value)
		end
		local text3Func = params.text3Func
		if text3Func then
			local text3Value = text3Func(data)
			single.Text_time:setString(text3Value)
		end
	end
end
function mailNebulaAllStarRank:initMailNebulaAllStarRank2(params)
	local node = SoraDCreateCSBNode("mailNebulaAllStarRank2")
	node:addTo(self)
	local rankList = params.rankList
	local totalH = 447
	self.totalH = self.totalH + totalH
	node:setPosition(0, self.totalH - 20)
	SoraDGetAllChildFromWidget(node, node)
	node.Text_title:setString(params.title)
	if params.imageBg then
		node.Sprite_bg:setSpriteFrame(params.imageBg)
	end
	for i = 1, 3 do
		local single = node["Node_rankSingle" .. i]
		SoraDGetAllChildFromWidget(single, single)
		local data = rankList[i]
		if not data then
			single.Sprite_bust:setSpriteFrame("frame_qmx_zanwu.png")
			single.Text_noData:setString(i18n("hero_text_84"))
		else
			single.Sprite_bust:setSpriteFrame(lordLocalData.getBust(data.headid or data.iconID))
			local valueFunc = params.valueFunc
			if valueFunc then
				local valueValue = valueFunc(data)
				single.Text_value:setString(valueValue)
			end
			local nameFunc = params.nameFunc
			if nameFunc then
				local nameValue = nameFunc(data, single.Text_name)
				single.Text_name:setString(nameValue)
			end
		end
	end
end
function mailNebulaAllStarRank:initWinWar_RF(...)
	if not self.contentData.content then
		local _ENV, content = self.contentData.content, self.contentData.content
	end
	if not content.seasonPhoenixRank then
		local _ENV, seasonPhoenixRank = content.seasonPhoenixRank, content.seasonPhoenixRank
	end
	_ENV = nil
	;(nil).rankList = seasonPhoenixRank
	;(nil).title = i18n("flames_dunes_text306")
	self:initPersonRank_RF(nil)
	if not content.seasonKillRank then
		local _ENV, seasonKillRank = content.seasonKillRank, content.seasonKillRank
	end
	_ENV = i18n("flames_dunes_text306")
	i18n("flames_dunes_text306").rankList = seasonKillRank
	i18n("flames_dunes_text306").title = i18n("flames_dunes_text305")
	self:initPersonRank_RF((i18n("flames_dunes_text306")))
	if not content.seasonHonorRank then
		local _ENV, seasonHonorRank = content.seasonHonorRank, content.seasonHonorRank
	end
	_ENV = i18n("flames_dunes_text305")
	i18n("flames_dunes_text305").rankList = seasonHonorRank
	i18n("flames_dunes_text305").title = i18n("flames_dunes_text304")
	self:initPersonRank_RF((i18n("flames_dunes_text305")))
	if not content.occupyPalaceRank then
		local _ENV, occupyPalaceRank = content.occupyPalaceRank, content.occupyPalaceRank
	end
	self:initCampOccupyRank_RF(occupyPalaceRank)
	if not content.seasonCampScoreRank then
		local _ENV, seasonCampScoreRank = content.seasonCampScoreRank, content.seasonCampScoreRank
	end
	self:initCampScoreRank_RF(seasonCampScoreRank)
end
function mailNebulaAllStarRank:initPersonRank_RF(params)
	_ENV = nil
	if not params.rankList then
		_ENV = params.rankList
	end
	;(nil).rankList = params.rankList
	;(nil).title = params.title
	;(nil).imageBg = "frame_9001674_mailgraph.png"
	;(nil).valueFunc = function(data)
		local value = data.score or 0
		return string.formatnumberthousands(value)
	end
	;(nil).nameFunc = function(data, widget)
		widget:setIsHtml(true)
		local campName = roaringFlameWarRead.getCampName(data.campId)
		local campColor = roaringFlameWarRead.getCampHtmlColor(data.campId)
		roaringFlameWarRead = nil
		;(nil).color = campColor
		local campStr = SoraDWrapHtmlTagByStyle(campName, nil)
		roaringFlameWarRead = nil
		;(nil).abbr = campStr
		;(nil).name = data.name
		return i18n("common_text_186", nil)
	end
	self:initMailNebulaAllStarRank2(nil)
end
function mailNebulaAllStarRank:initCampScoreRank_RF(rankList)
