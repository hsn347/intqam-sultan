local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local allianceBWList = gametop.playertop_:getModule("allianceBWList")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local AllianceInfoView = class("allianceInfoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceInfoView")
	end
	return target
end)
function AllianceInfoView:ctor()
	self.needCallBack2SDK = true
	self.isHideCurrentSceneView = true
	self.tableAlliacnePoint = nil
	self.canApplyRelation = false
	self.kid = nil
	self.joinType = gAJoinBtnType.JOIN
	self.leftTime = 0
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_183"))
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_notice")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelLanguage = SoraDGetChildByName(self, "Text_language")
	self.imgLang = SoraDGetChildByName(self, "Image_lang")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelLeader = SoraDGetChildByName(self, "Text_leader")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelAreaCount = SoraDGetChildByName(self, "Text_areaCount")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.nodeInfo = SoraDGetChildByName(self, "Node_info")
	self.btnMember = SoraDGetChildByName(self, "Button_member")
	self.btnMember:setTitleText(i18n("common_text_180"))
	self.btnLeader = SoraDGetChildByName(self, "Button_leader")
	self.btnLeader:setTitleText(i18n("common_text_179"))
	self.btnMessage = SoraDGetChildByName(self, "Button_message")
	self.btnMessage:setTitleText(i18n("common_text_181"))
	self.btnJoin = SoraDGetChildByName(self, "Button_join")
	self.Node_applyed = SoraDGetChildByName(self.btnJoin, "Node_applyed")
	self.Node_applyed:setVisible(false)
	self.Node_effect = SoraDGetChildByName(self.btnJoin, "Node_effect")
	self.labelApplyed = SoraDGetChildByName(self.Node_applyed, "Text_applyed")
	self.labelLeftTime = SoraDGetChildByName(self.Node_applyed, "Text_leftTime")
	self.btnBList = SoraDGetChildByName(self, "Button_bList")
	self.labelBList = SoraDGetChildByName(self, "Text_bList")
	self.labelBPoint = SoraDGetChildByName(self, "Text_bPoint")
	self.btnWList = SoraDGetChildByName(self, "Button_wList")
	self.labelWList = SoraDGetChildByName(self, "Text_wList")
	self.labelWPoint = SoraDGetChildByName(self, "Text_wPoint")
	self.spriteBWIcon = SoraDGetChildByName(self, "Sprite_bwIcon")
	self.spriteBWIcon:setVisible(false)
	self.btnWList:addTouchEventListener(handler(self, self.btnAddClickCallBack))
	self.btnBList:addTouchEventListener(handler(self, self.btnAddClickCallBack))
	self.btnJoin:addTouchEventListener(handler(self, self.btnApplyClickCallBack))
	self.btnMember:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnLeader:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnMessage:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_APPLY_JOIN", function(...)
		self:updateApplyBtn()
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_APPLY_REJECT", function(...)
		self:updateApplyBtn()
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CANCEL_APPLY_JOIN", function(...)
		self:updateApplyBtn()
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", function(...)
		local member = memberMgr:getOwnMember()
		if member:getProperty("aid") == self.tableAlliacnePoint:getProperty("aid") then
			self:initData(allianceMgr:getAlliance())
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_ADD_BWLIST_SUCCESS", function(target, data)
		if data.aid == self.tableAlliacnePoint:getProperty("aid") then
			self:updateBWBtn()
			self:updateBottomHeight()
		end
		SoraDCloseLoading(self.btnBList)
		SoraDCloseLoading(self.btnWList)
	end)
end
function AllianceInfoView:initData(alliance, kid)
	self.tableAlliacnePoint = alliance
	self.kid = kid and kid or self.tableAlliacnePoint:getProperty("sourceKid")
	self:initPublicView()
	self:initApplyBtn()
end
function AllianceInfoView:updateApplyBtn()
	local uid = lordInfoCtrl:getLordInfo().base.uid
	local member = memberMgr:getOwnMember()
	local toCancel = function()
		if self.leftTimer then
			SoraDManagerRemoveTimer(self, self.leftTimer)
			self.leftTimer = nil
		end
		self.Node_effect:setVisible(true)
		self.btnJoin:setTouchEnabled(true)
		self.btnJoin:setBright(true)
		self.btnJoin:loadTextures("btn_red_normal_01.png", "btn_red_normal_02.png", "btn_gray_normal.png", ccui.TextureResType.plistType)
		self.btnJoin:setTitleText(i18n("common_text_184"))
		self.Node_applyed:setVisible(false)
	end
	if member:getProperty("curApplyAid") == self.tableAlliacnePoint:getProperty("aid") then
		self.joinType = gAJoinBtnType.CANCEL
		lordInfoCtrl = self.tableAlliacnePoint
		self.tableAlliacnePoint.byUID = true
		local applyTime = SoraDConfigGet("Game:allianceInfoView:applyTime~integer", self.tableAlliacnePoint) or 0
		if 0 < applyTime then
			self.leftTime = math.max(30 - (os.time() - applyTime), 0)
		end
		if 0 < self.leftTime then
			self.Node_effect:setVisible(false)
			self.btnJoin:setTouchEnabled(false)
			self.btnJoin:setBright(false)
			self.btnJoin:setTitleText("")
			self.Node_applyed:setVisible(true)
			self.labelApplyed:setString(i18n("alliance_office_btn_02"))
			self.labelLeftTime:setString(self.leftTime .. "s")
			if not self.leftTimer then
				self.leftTimer = SoradCreateTimer(self, function()
					if self.leftTime <= 0 then
						toCancel()
					else
						self.labelLeftTime:setString(self.leftTime .. "s")
						self.leftTime = self.leftTime - 1
					end
				end)
			end
		else
			toCancel()
		end
	elseif self.tableAlliacnePoint:getProperty("recruitType") == gARecruit.private and not self.tableAlliacnePoint:hasInvitation(uid) then
		self.joinType = gAJoinBtnType.APPLY
		self.Node_applyed:setVisible(false)
		self.btnJoin:loadTextures("btn_yellow_normal_01.png", "btn_yellow_normal_02.png", "btn_gray_normal.png", ccui.TextureResType.plistType)
		self.btnJoin:setBright(true)
		self.btnJoin:setTouchEnabled(true)
		self.btnJoin:setTitleText(i18n("common_text_182"))
	else
		self.joinType = gAJoinBtnType.JOIN
		self.Node_applyed:setVisible(false)
		self.btnJoin:loadTextures("btn_yellow_normal_01.png", "btn_yellow_normal_02.png", "btn_gray_normal.png", ccui.TextureResType.plistType)
		self.btnJoin:setBright(true)
		self.btnJoin:setTouchEnabled(true)
		self.btnJoin:setTitleText(i18n("common_text_068"))
	end
end
function AllianceInfoView:updateBWBtn()
	local bwType = allianceBWList:isInBWList(self.tableAlliacnePoint:getProperty("aid"))
	self.spriteBWIcon:setVisible(bwType ~= nil)
	self.nodeBottom:setVisible(bwType == nil)
	if self.nodeBottom:isVisible() then
		allianceBWList = self.tableAlliacnePoint:getProperty("aid")
		self.tableAlliacnePoint:getProperty("aid").list = i18n("common_text_1679")
		self.labelBList:setString(i18n("common_text_1687", self.tableAlliacnePoint:getProperty("aid")))
		allianceBWList = i18n("common_text_1687", self.tableAlliacnePoint:getProperty("aid"))
		i18n("common_text_1687", self.tableAlliacnePoint:getProperty("aid")).list = i18n("common_text_1680")
		self.labelWList:setString(i18n("common_text_1687", i18n("common_text_1687", self.tableAlliacnePoint:getProperty("aid"))))
		self.labelBPoint:setString(string.formatnumberthousands(allianceBWList:getScoreCost(gAllianceBWListType.BLACK)))
		self.labelWPoint:setString(string.formatnumberthousands(allianceBWList:getScoreCost(gAllianceBWListType.WHITE)))
	else
		self.spriteBWIcon:setSpriteFrame(bwType == gAllianceBWListType.BLACK and "icon_alliance_blacklist.png" or "icon_alliance_whitelist.png")
	end
end
function AllianceInfoView:initPublicView()
	_ENV = nil
	;(nil).abbr = self.tableAlliacnePoint:getProperty("abbr")
	;(nil).name = self.tableAlliacnePoint:getProperty("name")
	self.labelName:setString(i18n("common_text_186", nil))
	_ENV = i18n("common_text_186", nil)
	i18n("common_text_186", nil).name = self.tableAlliacnePoint:getProperty("leaderName")
	self.labelLeader:setString(i18n("common_text_170", i18n("common_text_186", nil)))
	self.labelPower:setString(string.formatnumberthousands(self.tableAlliacnePoint:getProperty("totalBattle")))
	self.labelAreaCount:setString(string.formatnumberthousands(self.tableAlliacnePoint:getProperty("terrScore")))
	self.labelMember:setString(self.tableAlliacnePoint:getMemberCount() .. "/" .. self.tableAlliacnePoint:getProperty("limitCount"))
	self.labelLanguage:setString(allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language")))
	if SoraDFIsRA() then
		self.imgLang:setPositionX(self.labelLanguage:getPositionX() + self.labelLanguage:getContentSize().width + 10)
	else
		self.imgLang:setPositionX(self.labelLanguage:getPositionX() - self.labelLanguage:getContentSize().width - 10)
	end
	self.nodeFlag:removeAllChildren()
	SoraDToCenter(self.nodeInfo)
	allianceDesRead.getFlagWithParticle(self.tableAlliacnePoint:getProperty("flag"), self.nodeFlag)
	allianceDesRead.showPyramidPlayoffsTop3(self.tableAlliacnePoint:getProperty("aid"), self)
	local isOwnAlliance = self.tableAlliacnePoint:getProperty("leader") == lordInfoCtrl:getLordInfo().base.uid
	self.btnLeader:setTouchEnabled(not isOwnAlliance)
	self.btnLeader:setBright(not isOwnAlliance)
	local uid = lordInfoCtrl:getLordInfo().base.uid
	local notice = self.tableAlliacnePoint:getProperty("manifesto")
	local lv = self.tableAlliacnePoint:getProperty("joinLevel")
	local power = self.tableAlliacnePoint:getProperty("joinPower")
	if lv <= 0 and power <= 0 or self.tableAlliacnePoint:hasInvitation(uid) then
		self.labelNotice:setString(notice)
	else
		_ENV = allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language"))
		allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language")).value = lv
		_ENV = allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language"))
		allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language")).value = string.formatnumberthousands(power)
		local needNotice = [[


]] .. i18n("common_text_1160") .. "\n" .. i18n("common_text_1155", allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language"))) .. "\n" .. i18n("common_text_1156", allianceDesRead.getLanguageName(self.tableAlliacnePoint:getProperty("language")))
		self.labelNotice:setString(notice .. needNotice)
	end
end
function AllianceInfoView:initApplyBtn()
	local isOwnKid = true
	local member = memberMgr:getOwnMember()
	local isOwnAid = member:getProperty("aid") == self.tableAlliacnePoint:getProperty("aid")
	if self.kid then
		isOwnKid = self.kid == lordInfoCtrl:getLordInfo().base.partition
	end
	local isJoin = not allianceMgr:hasJoinAlliance() and isOwnKid
	local isBWList = allianceMgr:hasJoinAlliance() and isOwnKid and not isOwnAid
	local isShow = isJoin or isBWList
	self.nodeBottom:setVisible(isShow)
	if isShow then
		if isBWList then
			self.btnJoin:setVisible(false)
			self:updateBWBtn()
		else
			self.btnWList:setVisible(false)
			self.btnBList:setVisible(false)
			self:updateApplyBtn()
		end
	end
	if worldMapDefine.isInWarForbid(true) then
		self.btnWList:setBright(false)
		self.btnBList:setBright(false)
	end
	if isBWList and allianceDesRead.checkRank(gAllianceRank.R4) then
		self.btnLeader:setTitleText(i18n("common_text_3075"))
		self.canApplyRelation = true
	else
		self.btnLeader:setTitleText(i18n("common_text_179"))
		self.canApplyRelation = false
	end
	local enableTeam = isOwnKid and not worldMapDefine.isInTeamWarForbid()
	self.btnMessage:setTouchEnabled(isOwnKid)
	self.btnMessage:setBright(isOwnKid)
	self.btnMember:setTouchEnabled(enableTeam)
	self.btnMember:setBright(enableTeam)
	self.btnLeader:setTouchEnabled(isOwnKid)
	self.btnLeader:setBright(isOwnKid)
	self:updateBottomHeight()
end
function AllianceInfoView:updateBottomHeight()
	local scrollH = self.nodeBottom:isVisible() and display.height - 624 or display.height - 700
	self.scroll:setContentSize(cc.size(600, scrollH))
	local labelH = math.max(SoraDGetAutoHeightLabel(self.labelNotice) + 10, scrollH)
	self.scroll:setInnerContainerSize(cc.size(600, labelH))
	self.labelNotice:setPositionY(labelH - 8)
end
function AllianceInfoView:btnApplyClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local aid = self.tableAlliacnePoint:getProperty("aid")
		local ownClv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		local ownPower = lordInfoCtrl:getLordInfo().fcInfo.totalFc
		local needClv = self.tableAlliacnePoint:getProperty("joinLevel")
		local needPower = self.tableAlliacnePoint:getProperty("joinPower")
		local uid = lordInfoCtrl:getLordInfo().base.uid
		if self.tableAlliacnePoint:getProperty("isMigration") then
			SoraDShowMsgBox(i18n("common_text_2168"), i18n("common_text_204"))
		elseif self.joinType == gAJoinBtnType.CANCEL then
			allianceMgr:reqCancelApplyJoin(aid)
		elseif (ownClv < needClv or ownPower < needPower) and not self.tableAlliacnePoint:hasInvitation(uid) then
			SoraDShowMsgTip(i18n("common_text_1159"), "#icon_alliance_no.png", button)
		elseif self.joinType == gAJoinBtnType.APPLY then
			allianceMgr:reqApplyJion(aid)
		else
			allianceMgr:reqJoinAlliance(aid)
		end
		self:updateApplyBtn()
	end
end
function AllianceInfoView:btnAddClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInWarForbid() then
			return
		end
		local curBWType = button == self.btnBList and gAllianceBWListType.BLACK or gAllianceBWListType.WHITE
		local member = memberMgr:getOwnMember()
		local rank = member:getProperty("rank")
		local needPoint = allianceBWList:getScoreCost(curBWType)
		if rank < gAllianceRank.R4 then
			SoraDShowMsgTip(i18n("common_text_203"), button == self.btnBList and "#icon_alliance_blacklist.png" or "#icon_alliance_whitelist.png", button)
		elseif needPoint > allianceMgr:getAllianceProperty("bonus") then
			SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					SoraDCreatePanel("allianceScienceView"):show()
				end
			end)
		else
			do
				local notice = curBWType == gAllianceBWListType.BLACK and i18n("common_text_1679") or i18n("common_text_1680")
				_ENV = nil
				;(nil).alliance = self.labelName:getString()
				;(nil).list = notice
				notice = i18n("common_text_1855", nil) .. (curBWType == gAllianceBWListType.BLACK and i18n("common_text_1685") or i18n("common_text_1686"))
				SoraDShowMsgBox(notice, i18n("common_text_054"), nil, function(backType)
					if backType == MSGBOX_CALLBACK_YES then
						allianceBWList:addAllianceBWList(self.tableAlliacnePoint:getProperty("aid"), curBWType)
						local loading = SoraDShowLoading(self.btnBList, cc.size(40, 40))
						loading:setPosition(cc.p(108, 36))
						loading = SoraDShowLoading(self.btnWList, cc.size(40, 40))
						loading:setPosition(cc.p(108, 36))
					end
				end)
			end
		end
	end
end
function AllianceInfoView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel
		if self.btnMember == button then
			if GLOBAL_GAME_ALLIANCE_MODE then
				_ENV = nil
				;(nil).aid = self.tableAlliacnePoint:getProperty("aid")
				uiManager:show("allianceMemberList", nil)
			else
				panel = SoraDCreatePanel("allianceMemberList")
				panel:initData(self.tableAlliacnePoint:getProperty("aid"))
			end
		elseif self.btnMessage == button then
			local allianceId = self.tableAlliacnePoint:getProperty("aid")
			_ENV = "aid"
			;("aid").allianceId = allianceId
			SoraDCreateAllianceChatView("aid")
			return
		elseif self.canApplyRelation then
			panel = SoraDCreatePanel("allianceRelationApplyView")
			panel:initData(self.tableAlliacnePoint)
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
			local panel = SoraDCreateChatView(data)
		end
		if panel then
			panel:show()
		end
	end
end
return AllianceInfoView
