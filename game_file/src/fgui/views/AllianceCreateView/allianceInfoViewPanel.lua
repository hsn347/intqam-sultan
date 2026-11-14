local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceBWList = SoraDGetCtrl("allianceBWList")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceInfoViewPanel = class("allianceInfoViewPanel", baseFguiPanel)
function allianceInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceInfoViewPanel:ctor", self.viewName)
end
function allianceInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceInfoViewPanel:onInit()
	print("=======allianceInfoViewPanel:onInit")
	self.needCallBack2SDK = true
	self.isHideCurrentSceneView = true
	self.tableAlliacnePoint = nil
	self.canApplyRelation = false
	self.kid = nil
	self.joinType = gAJoinBtnType.JOIN
	self.leftTime = 0
	self.fields.Com_title:initData(i18n("common_text_183"), handler(self, self.onClickClose))
	self.fields.Button_postSeasonBg:addClickListener(handler(self, self.btnPostSeasonClick))
	self.fields.Button_message:setString(i18n("common_text_181"))
	self.fields.Button_message:addClickListener(handler(self, self.btnMessageClick))
	self.fields.Button_leader:setString(i18n("common_text_179"))
	self.fields.Button_leader:addClickListener(handler(self, self.btnLeaderClick))
	self.fields.Button_member:setString(i18n("common_text_180"))
	self.fields.Button_member:addClickListener(handler(self, self.btnMemberClick))
	self.fields.Button_join:addClickListener(handler(self, self.btnApplyClickCallBack))
	self.fields.Button_bList:setTag(gAllianceBWListType.BLACK)
	self.fields.Button_bList:addClickListener(handler(self, self.btnBWListClick))
	self.fields.Button_wList:setTag(gAllianceBWListType.WHITE)
	self.fields.Button_wList:addClickListener(handler(self, self.btnBWListClick))
	self.fields.Sprite_bwIcon:fixPos()
	self.fields.Text_language:fixPos()
	self.fields.Text_language:setAlign(SoraDFIsRA() and 0 or 2)
	self.fields.Image_lang:fixPos()
	self.fields.Button_postSeasonBg:fixPos()
	self.fields.Text_member:fixPos()
	self.fields.Text_power:fixPos()
	self.fields.Text_areaCount:fixPos()
	self.fields.Button_message:fixPos()
	self.fields.Button_leader:fixPos()
	self.fields.Button_member:fixPos()
	self.fields.Button_bList:fixPos()
	self.fields.Button_wList:fixPos()
end
function allianceInfoViewPanel:onShow()
	print("=======allianceInfoViewPanel:onShow")
	self.tableAlliacnePoint = self.param and self.param.alliance or allianceMgr:getAlliance()
	self.kid = self.param and self.param.kid
	self:initData(self.tableAlliacnePoint, self.kid)
end
function allianceInfoViewPanel:initData(alliance, kid)
	self.tableAlliacnePoint = alliance
	self.kid = kid and kid or self.tableAlliacnePoint:getProperty("sourceKid")
	self:initPublicView()
	self:initApplyBtn()
end
function allianceInfoViewPanel:initPublicView()
	_ENV = nil
	;(nil).abbr = self.tableAlliacnePoint:getProperty("abbr")
	;(nil).name = self.tableAlliacnePoint:getProperty("name")
	self.fields.Text_name:setString(i18n("common_text_186", nil))
	_ENV = i18n("common_text_186", nil)
	i18n("common_text_186", nil).name = self.tableAlliacnePoint:getProperty("leaderName")
	self.fields.Text_leader:setString(i18n("common_text_170", i18n("common_text_186", nil)))
	self.fields.Text_power:setString(string.formatnumberthousands(self.tableAlliacnePoint:getProperty("totalBattle")))
	self.fields.Text_areaCount:setString(string.formatnumberthousands(self.tableAlliacnePoint:getProperty("terrScore")))
	self.fields.Text_member:setString(self.tableAlliacnePoint:getMemberCount() .. "/" .. self.tableAlliacnePoint:getProperty("limitCount"))
	self.fields.Text_language:setString(allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language")))
	local flagNode = allianceDesRead.getFlagNode(self.tableAlliacnePoint:getProperty("flag"))
	flagNode:setPosition(5, 5)
	self.fields.Node_flag:clearContent()
	self.fields.Node_flag:setContent(flagNode)
	local rank = pyramidWarCtrl:getPostSeasonTop3Rank(self.tableAlliacnePoint:getProperty("aid"))
	if 0 < rank and rank <= RANK_TOP_SPECIAL then
		_ENV = RANK_TOP_SPECIAL
		RANK_TOP_SPECIAL[1] = "icon_battlefield_playoff_gold.png"
		RANK_TOP_SPECIAL[2] = "icon_battlefield_playoff_silver.png"
		local RANK_TOP_SPECIAL[3], tableIcon = "icon_battlefield_playoff_cuprum.png", RANK_TOP_SPECIAL
		self.fields.Button_postSeasonBg:setVisible(true)
		self.fields.Button_postSeasonBg:setIcon(tableIcon[rank])
	else
		self.fields.Button_postSeasonBg:setVisible(false)
	end
	local uid = lordInfoCtrl:getLordInfo().base.uid
	self.isOwnLeader = self.tableAlliacnePoint:getProperty("leader") == uid
	self.fields.Button_leader:setEnabled(not self.isOwnLeader)
	local notice = self.tableAlliacnePoint:getProperty("notice")
	local lv = self.tableAlliacnePoint:getProperty("joinLevel")
	local power = self.tableAlliacnePoint:getProperty("joinPower")
	if lv <= 0 and power <= 0 or self.tableAlliacnePoint:hasInvitation(uid) then
		self.fields.Label_notice:setString(notice)
	else
		_ENV = self.tableAlliacnePoint:getProperty("aid")
		self.tableAlliacnePoint:getProperty("aid").value = lv
		_ENV = i18n("common_text_1155", self.tableAlliacnePoint:getProperty("aid"))
		i18n("common_text_1155", self.tableAlliacnePoint:getProperty("aid")).value = string.formatnumberthousands(power)
		local needNotice = [[


]] .. i18n("common_text_1160") .. "\n" .. fguiHelper.getColorString("#F0E6D2", i18n("common_text_1155", self.tableAlliacnePoint:getProperty("aid"))) .. "\n" .. fguiHelper.getColorString("#F0E6D2", i18n("common_text_1156", i18n("common_text_1155", self.tableAlliacnePoint:getProperty("aid"))))
		self.fields.Label_notice:setString(notice .. needNotice)
	end
end
function allianceInfoViewPanel:initApplyBtn()
	local isOwnKid = true
	local member = memberMgr:getOwnMember()
	local isOwnAid = member:getProperty("aid") == self.tableAlliacnePoint:getProperty("aid")
	if self.kid then
		isOwnKid = self.kid == lordInfoCtrl:getLordInfo().base.partition
	end
	local isJoin = not allianceMgr:hasJoinAlliance() and isOwnKid
	local isBWList = allianceMgr:hasJoinAlliance() and isOwnKid and not isOwnAid
	local isShow = isJoin or isBWList
	self.controllers.c1:setSelectedIndex(isShow and 0 or 1)
	if isShow then
		if isBWList then
			self.fields.Button_join:setVisible(false)
			self:updateBWBtn()
		else
			self.fields.Button_wList:setVisible(false)
			self.fields.Button_bList:setVisible(false)
			self:updateApplyBtn()
		end
	end
	if worldMapDefine.isInWarForbid(true) then
		self.fields.Button_wList:setBright(false)
		self.fields.Button_bList:setBright(false)
	end
	if isBWList and allianceDesRead.checkRank(gAllianceRank.R4) then
		self.fields.Button_leader:setString(i18n("common_text_3075"))
		self.canApplyRelation = true
	else
		self.fields.Button_leader:setString(i18n("common_text_179"))
		self.canApplyRelation = false
	end
	local enableTeam = isOwnKid and not worldMapDefine.isInTeamWarForbid()
	self.fields.Button_message:setEnabled(isOwnKid)
	self.fields.Button_member:setEnabled(enableTeam)
	self.fields.Button_leader:setEnabled(isOwnKid and not self.isOwnLeader)
end
function allianceInfoViewPanel:updateBWBtn()
	local bwType = allianceBWList:isInBWList(self.tableAlliacnePoint:getProperty("aid"))
	self.fields.Sprite_bwIcon:setVisible(bwType ~= nil)
	self.controllers.c1:setSelectedIndex(bwType == nil and 0 or 1)
	if bwType == nil then
		allianceBWList = self.tableAlliacnePoint:getProperty("aid")
		self.tableAlliacnePoint:getProperty("aid").list = i18n("common_text_1679")
		self.fields.Button_bList:setString(i18n("common_text_1687", self.tableAlliacnePoint:getProperty("aid")))
		self.fields.Button_bList:setCostTitle(string.formatnumberthousands(allianceBWList:getScoreCost(gAllianceBWListType.BLACK)))
		allianceBWList = string.formatnumberthousands(allianceBWList:getScoreCost(gAllianceBWListType.BLACK))
		string.formatnumberthousands(allianceBWList:getScoreCost(gAllianceBWListType.BLACK)).list = i18n("common_text_1680")
		self.fields.Button_wList:setString(i18n("common_text_1687", string.formatnumberthousands(allianceBWList:getScoreCost(gAllianceBWListType.BLACK))))
		self.fields.Button_wList:setCostTitle(string.formatnumberthousands(allianceBWList:getScoreCost(gAllianceBWListType.WHITE)))
	else
		self.fields.Sprite_bwIcon:setSpriteFrame(bwType == gAllianceBWListType.BLACK and "icon_alliance_blacklist.png" or "icon_alliance_whitelist.png")
	end
end
function allianceInfoViewPanel:updateApplyBtn()
	SoraDCloseLoading(self)
	local uid = lordInfoCtrl:getLordInfo().base.uid
	local member = memberMgr:getOwnMember()
	if member:getProperty("curApplyAid") == self.tableAlliacnePoint:getProperty("aid") then
		self.joinType = gAJoinBtnType.CANCEL
		_ENV = self.tableAlliacnePoint
		self.tableAlliacnePoint.byUID = true
		local applyTime = SoraDConfigGet("Game:allianceInfoView:applyTime~integer", self.tableAlliacnePoint) or 0
		if 0 < applyTime then
			self.leftTime = math.max(30 - (os.time() - applyTime), 0)
		end
		if 0 < self.leftTime then
			self.fields.Button_join:setStatus(1, nil, self.leftTime)
		else
			self.fields.Button_join:setStatus(2, i18n("common_text_184"))
		end
	elseif self.tableAlliacnePoint:getProperty("recruitType") == gARecruit.private and not self.tableAlliacnePoint:hasInvitation(uid) then
		self.joinType = gAJoinBtnType.APPLY
		self.fields.Button_join:setStatus(0, i18n("common_text_182"))
	else
		self.joinType = gAJoinBtnType.JOIN
		self.fields.Button_join:setStatus(0, i18n("common_text_068"))
	end
end
function allianceInfoViewPanel:memberUpdate()
	SoraDCloseLoading(self)
	local member = memberMgr:getOwnMember()
	if member:getProperty("aid") == self.tableAlliacnePoint:getProperty("aid") then
		self:initData(allianceMgr:getAlliance())
	end
end
function allianceInfoViewPanel:bwlistUpdate(target, data)
	SoraDCloseLoading(self)
	if data.aid == self.tableAlliacnePoint:getProperty("aid") then
		self:updateBWBtn()
	end
end
function allianceInfoViewPanel:btnPostSeasonClick()
	SoraDPlaySound()
	SoraDCreatePanel("pyramidBattleHonourBoard"):show()
end
function allianceInfoViewPanel:btnMessageClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).allianceId = self.tableAlliacnePoint:getProperty("aid")
	SoraDCreateAllianceChatView(nil)
end
function allianceInfoViewPanel:btnLeaderClick()
	SoraDPlaySound()
	if self.canApplyRelation then
		_ENV = nil
		;(nil).data = self.tableAlliacnePoint
		uiManager:show("allianceRelationApplyView", nil)
	else
		local playerId = self.tableAlliacnePoint:getProperty("leader")
		local nickName = self.tableAlliacnePoint:getProperty("leaderName")
		local allianceAbbr = self.tableAlliacnePoint:getProperty("abbr")
		local chatFunctions = include("chatFunctions")
		if playerId == chatFunctions:getSelfId() then
			SoraDShowMsgTip(i18n("common_text_4265"))
			return
		end
		_ENV = SoraDShowMsgTip
		SoraDShowMsgTip.targetType = gMailType.CHAT
		SoraDShowMsgTip.target = playerId
		SoraDShowMsgTip.nickName = nickName
		local SoraDShowMsgTip.allianceAbbr, data = allianceAbbr, SoraDShowMsgTip
		SoraDCreateChatView(data)
	end
end
function allianceInfoViewPanel:btnMemberClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).aid = self.tableAlliacnePoint:getProperty("aid")
	uiManager:show("allianceMemberList", nil)
end
function allianceInfoViewPanel:btnApplyClickCallBack()
	SoraDPlaySound()
	local aid = self.tableAlliacnePoint:getProperty("aid")
	local ownClv = SoraDGetCastleLv()
	local ownPower = lordInfoCtrl:getLordInfo().fcInfo.totalFc
	local needClv = self.tableAlliacnePoint:getProperty("joinLevel")
	local needPower = self.tableAlliacnePoint:getProperty("joinPower")
	local uid = lordInfoCtrl:getLordInfo().base.uid
	if self.tableAlliacnePoint:getProperty("isMigration") then
		SoraDShowMsgBox(i18n("common_text_2168"), i18n("common_text_204"))
	elseif self.joinType == gAJoinBtnType.CANCEL then
		allianceMgr:reqCancelApplyJoin(aid)
	elseif (ownClv < needClv or ownPower < needPower) and not self.tableAlliacnePoint:hasInvitation(uid) then
		SoraDShowMsgTip(i18n("common_text_1159"), "#icon_alliance_no.png")
	elseif self.joinType == gAJoinBtnType.APPLY then
		allianceMgr:reqApplyJion(aid)
	else
		allianceMgr:reqJoinAlliance(aid)
	end
	self:updateApplyBtn()
end
function allianceInfoViewPanel:btnBWListClick(eventContext)
	SoraDPlaySound()
	if worldMapDefine.isInWarForbid() then
		return
	end
	local curBWType = eventContext:getSender():getTag()
	local member = memberMgr:getOwnMember()
	local rank = member:getProperty("rank")
	local needPoint = allianceBWList:getScoreCost(curBWType)
	if rank < gAllianceRank.R4 then
		SoraDShowMsgTip(i18n("common_text_203"), curBWType == gAllianceBWListType.BLACK and "#icon_alliance_blacklist.png" or "#icon_alliance_whitelist.png")
	elseif needPoint > allianceMgr:getAllianceProperty("bonus") then
		SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("AllianceScience")
				else
					SoraDCreatePanel("allianceScienceView"):show()
				end
			end
		end)
	else
		local notice = curBWType == gAllianceBWListType.BLACK and i18n("common_text_1679") or i18n("common_text_1680")
		_ENV = nil
		;(nil).alliance = self.fields.Text_leader:getText()
		;(nil).list = notice
		notice = i18n("common_text_1855", nil) .. (curBWType == gAllianceBWListType.BLACK and i18n("common_text_1685") or i18n("common_text_1686"))
		SoraDShowMsgBox(notice, i18n("common_text_054"), nil, function(backType)
			if backType == MSGBOX_CALLBACK_YES then
				allianceBWList:addAllianceBWList(self.tableAlliacnePoint:getProperty("aid"), curBWType)
				SoraDShowLoading(self)
			end
		end)
	end
end
return allianceInfoViewPanel
