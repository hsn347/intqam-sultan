local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local legendLordWarCtrl = SoraDGetCtrl("legendLordWarCtrl")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local legendaryKingBeastRank = class("legendaryKingBeastRank", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("legendaryKingBeastRank")
end)
function legendaryKingBeastRank:ctor(properties)
	self.defaultClick = 1
	self.warType = gKingdomClassType.legendLord
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("legendaryking_text_46"))
	self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX")
	self.nodeCommonTabBtnEX:setNewStyle(true)
	self.nodeCommonTabBtnEX:setContentSize(cc.size(536, 48))
	self.scrollRank = SoraDGetChildByName(self, "ScrollView_rank")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCreate(handler(self, self.createSingle))
	self.textTip = SoraDGetChildByName(self, "Text_Tip")
	self.textTip:setString(i18n("legendaryking_text_47"))
	self.nodeTitle = SoraDGetChildByName(self, "node_title")
	self.textName = SoraDGetChildByName(self.nodeTitle, "Text_name")
	self.textName:setString(i18n("common_text_264"))
	self.textScore = SoraDGetChildByName(self.nodeTitle, "Text_score")
	self.textScore:setString(i18n("legendaryking_title_06"))
	self.textNoRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.textNoRecrod:setString(i18n("herobattle_text_05"))
	self.nodeMy = SoraDGetChildByName(self, "Node_my")
	self.labelIndex = SoraDGetChildByName(self.nodeMy, "Text_Rank")
	self.spriteIndex = SoraDGetChildByName(self.nodeMy, "icon_ranking")
	self.labelName = SoraDGetChildByName(self.nodeMy, "Text_Name")
	self.labelNum = SoraDGetChildByName(self.nodeMy, "Text_Num")
	self.head_icon = SoraDGetChildByName(self.nodeMy, "Image_Head")
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
end
function legendaryKingBeastRank:setWarType(warType, mapid)
	self.warType = warType
	self.mapid = mapid
	if self.warType == gKingdomClassType.radiance then
		self.nodeCommonPopBox:setTitleName(i18n("brightWar_text_232"))
		self.textTip:setVisible(false)
	end
	if worldMapDefine.isKingStarMapId(self.mapid) then
		self.nodeCommonPopBox:setTitleName(i18n("kingstarbattle_text_45"))
		self.textTip:setString(i18n("kingstarbattle_text_46"))
	end
	self:updateActivityStatu()
end
function legendaryKingBeastRank:initTab()
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("legendaryking_text_39")
	;(nil).handle = handler(self, self.btnTabClick)
	;(nil).tag = 1
	_ENV, (nil)[1], (nil).fontSize = nil, nil, 22
	;(nil).title = i18n("legendaryking_text_40")
	;(nil).handle = handler(self, self.btnTabClick)
	;(nil).tag = 2
	_ENV, (nil)[2], (nil).fontSize = nil, nil, 22
	;(nil).title = i18n("legendaryking_text_41")
	;(nil).handle = handler(self, self.btnTabClick)
	;(nil).tag = 3
	;(nil)[3], (nil).fontSize = nil, 22
	local tabsetArray
	if self.warType == gKingdomClassType.radiance then
		_ENV, _ENV = gKingdomClassType.radiance, self.warType
		gKingdomClassType.radiance.title = i18n("brightWar_text_228")
		gKingdomClassType.radiance.handle = handler(self, self.btnTabClick)
		gKingdomClassType.radiance.tag = 1
		_ENV, self.warType[1], gKingdomClassType.radiance.fontSize = gKingdomClassType.radiance, gKingdomClassType.radiance, 22
		gKingdomClassType.radiance.title = i18n("brightWar_text_229")
		gKingdomClassType.radiance.handle = handler(self, self.btnTabClick)
		gKingdomClassType.radiance.tag = 2
		tabsetArray, self.warType[2], gKingdomClassType.radiance.fontSize = self.warType, gKingdomClassType.radiance, 22
	end
	_ENV = self.warType
	self.warType.tabNum = #tabsetArray
	self.warType.defaultClick = self.defaultClick
	local self.warType.tabsetArray, param = tabsetArray, self.warType
	self.nodeCommonTabBtnEX:initView(param)
end
function legendaryKingBeastRank:onMessageListener()
	if self.warType == gKingdomClassType.legendLord then
		SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_ALLIANCE", handler(self, self.initData))
	elseif self.warType == gKingdomClassType.radiance then
		SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_PLAYER_RANK", handler(self, self.initData))
	end
end
function legendaryKingBeastRank:initData(target, data)
	if not data.myInfo then
		_ENV = data.myInfo
	end
	self.selfRank = data.myInfo
	local rankData = data.rankList
	self:initMyRank()
	if rankData and next(rankData) then
		self.rankData, _ENV = next(rankData), next(rankData)
		for i, v in ipairs(rankData) do
			local _ENV, singleData
			singleData.player, _ENV, singleData.rank = nil, nil, i
			singleData.player.flag = v.leagueFlag
			if v.leagueAbbrName then
				_ENV = nil
				;(nil).abbr = v.leagueAbbrName
				;(nil).name = v.playerName
			end
			local lineOneName = i18n("common_text_186", nil) or v.playerName or i18n("common_text_480")
			if self.warType == gKingdomClassType.radiance then
				singleData.lineOneName = lineOneName
			else
				singleData.lineOneName = lineOneName .. "#" .. v.sourceKid
			end
			singleData.player.aid = v.aid
			singleData.player.kid = v.sourceKid
			singleData.player.uid = v.uid
			singleData.player.iconID = v.headid
			singleData.player.avatar = v.avatar
			singleData.score = v.killFc
			singleData.model = 1
			singleData.nameShowType = 1
			singleData.btnClickType = 2
			singleData.notToCenter = true
			singleData.selfRank = self.selfRank.rank
			table.insert(self.rankData, singleData)
		end
		self.scrollRank:setVisible(true)
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scrollRank:updateScrollView(cc.size(544, 102), self.rankData, 1, nil)
		self.scrollRank:jumpToTop()
		self.textNoRecrod:setVisible(false)
	else
		self.scrollRank:setVisible(false)
		self.textNoRecrod:setVisible(true)
	end
end
function legendaryKingBeastRank:createSingle()
	local panel = include("commonRankingSingle").new(self.nodeSingle:clone())
	panel:setHandle(handler(self, self.btnClickHead))
	return panel
end
function legendaryKingBeastRank:btnClickHead(singleData)
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = singleData.player.uid
	;(nil).kid = singleData.player.kid
	SoraDSendMessage(nil)
end
function legendaryKingBeastRank:updateActivityStatu()
	if self.warType == gKingdomClassType.legendLord then
		local param = activityShowCtrl:getParamByID(worldMapDefine.isKingStarMapId(self.mapid) and gActivityTimeActivityID.KING_STAR_BATTLE or gActivityTimeActivityID.LEGEND_LORD)
		self.legendLordState = param.curState
	end
end
function legendaryKingBeastRank:initMyRank()
	local showRank = false
	if self.warType == gKingdomClassType.radiance then
		if self.selfRank.rank and self.selfRank.rank <= 10 then
			showRank = true
		end
	elseif self.selfRank.rank then
		showRank = true
	end
	if showRank then
		self.labelIndex:setVisible(self.selfRank.rank > RANK_TOP_SPECIAL)
		self.spriteIndex:setVisible(self.selfRank.rank <= RANK_TOP_SPECIAL)
		self.labelIndex:setString(tostring(self.selfRank.rank))
		if self.selfRank.rank <= RANK_TOP_SPECIAL then
			self.spriteIndex:setSpriteFrame("icon_ranking_" .. self.selfRank.rank .. ".png")
		end
	else
		self.spriteIndex:setVisible(false)
		local strRank = i18n("common_text_827")
		self.labelIndex:setString(strRank)
		self.labelIndex:setVisible(true)
	end
	local player = lordInfoCtrl:getBaseInfo()
	SoraDGetHeadFromManager(self.head_icon, player.imageId, player.avatar)
	if player.nickName then
		local name = player.nickName
		local leagueAbbrName = allianceMgr:getAllianceProperty("abbr")
		local leagueName = allianceMgr:getAllianceProperty("name")
		local allianceKey = "common_text_925"
		local alliance
		if leagueName then
			_ENV = tostring(self.selfRank.rank)
			tostring(self.selfRank.rank).conten = leagueName
			alliance = i18n(allianceKey, tostring(self.selfRank.rank))
		else
			_ENV = tostring(self.selfRank.rank)
			tostring(self.selfRank.rank).conten = i18n("common_text_826")
			alliance = i18n(allianceKey, tostring(self.selfRank.rank))
		end
		local sourceKid = gametop.playertop_:getKingdomID()
		gametop = tostring(self.selfRank.rank)
		tostring(self.selfRank.rank)[1] = self.warType
		tostring(self.selfRank.rank)[2] = gKingdomClassType.radiance
		tostring(self.selfRank.rank)[3] = sourceKid
		dump(tostring(self.selfRank.rank))
		if self.warType ~= gKingdomClassType.radiance and sourceKid then
			name = name .. "#" .. tostring(sourceKid)
		end
		if leagueAbbrName then
			_ENV = tostring(sourceKid)
			tostring(sourceKid).abbr = leagueAbbrName
			tostring(sourceKid).name = name
			name = i18n("common_text_186", (tostring(sourceKid)))
		end
		self.labelName:setString(name)
	end
	self.labelNum:setString(string.formatnumberthousands(self.selfRank.killFc or 0))
end
function legendaryKingBeastRank:btnTabClick(tag, name)
	print("legendaryKingBeastRank", tag, name)
	if self.warType == gKingdomClassType.radiance then
		radianceActivityCtrl:reqPlayerKillFcRank(tag)
		self.scrollRank:setPositionY(-267)
		self.scrollRank:setContentSize(cc.size(536, 492))
	elseif self.warType == gKingdomClassType.legendLord then
		self.textTip:setVisible(tag == 1)
		self.nodeMy:setVisible(tag ~= 1)
		if tag == 1 then
			self.scrollRank:setContentSize(cc.size(536, 551))
			self.scrollRank:setPositionY(-361)
			if self.legendLordState ~= ACTIVITY_STATE.SETTLE then
				SoraDShowMsgTip(i18n("legendaryking_text_45"))
				_ENV = i18n("legendaryking_text_45")
				self:initData(self, i18n("legendaryking_text_45"))
			else
				legendLordWarCtrl:getKingAlliance(gLegendBuildID, nil, self.mapid)
			end
		else
			self.scrollRank:setPositionY(-267)
			self.scrollRank:setContentSize(cc.size(536, 492))
			legendLordWarCtrl:reqBestRank(gLegendBuildID, tag == 2, self.mapid)
		end
	end
end
function legendaryKingBeastRank:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function legendaryKingBeastRank:setTabDefaultClick(type)
	self.defaultClick = type
end
return legendaryKingBeastRank
