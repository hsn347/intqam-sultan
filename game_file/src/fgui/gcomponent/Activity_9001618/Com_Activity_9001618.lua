local activity_9001618_Ctrl = SoraDGetCtrl("activity_9001618_Ctrl")
local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local buildLogic = include("buildLogic")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local memberMgr = SoraDGetCtrl("memberMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001618 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001618/Com_Activity_9001618", Com_Activity_9001618)
function Com_Activity_9001618:onInit()
	self.allianceList, _ENV, self.activityID = gActivityTimeActivityID.HONOR_BACK_ALLIANCE_RECOMMEND, gActivityTimeActivityID.HONOR_BACK_ALLIANCE_RECOMMEND, gActivityTimeActivityID.HONOR_BACK_ALLIANCE_RECOMMEND
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.Button_alliance:setString(i18n("recommended_alliance_text5"))
	self.fields.Button_alliance:addClickListener(handler(self, self.onClickBtnAlliance))
end
function Com_Activity_9001618:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001618_UPDATE", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_APPLY_REJECT", handler(self, self.onMsgUpdateApplyBtn))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CANCEL_APPLY_JOIN", handler(self, self.onMsgUpdateApplyBtn))
end
function Com_Activity_9001618:onShow()
	activity_9001618_Ctrl:reqRecommendData()
end
function Com_Activity_9001618:onClickBtnAlliance()
	SoraDPlaySound()
	if allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("alliance_join_tips_01"))
		return
	end
	uiManager:show("AllianceJoinView")
end
function Com_Activity_9001618:updateAlliance(...)
	for i = 1, 3 do
		local Com_alliance = self.fields["Com_alliance" .. i]
		self:updateAllianceSingle(i, Com_alliance)
	end
end
function Com_Activity_9001618:updateAllianceSingle(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local c1 = obj:getController("c1")
	local alliance = self.allianceList[index]
	if not alliance then
		_fields.Text_noData:setString(i18n("recommended_alliance_text4"))
		c1:setSelectedIndex(1)
		return
	end
	c1:setSelectedIndex(0)
	_ENV = c1.setSelectedIndex
	c1.setSelectedIndex[1] = i18n("recommended_alliance_text1")
	c1.setSelectedIndex[2] = i18n("recommended_alliance_text3")
	local c1.setSelectedIndex[3], config = i18n("recommended_alliance_text2"), c1.setSelectedIndex
	_fields.Text_label:setString(config[index])
	_ENV = i18n("recommended_alliance_text4")
	i18n("recommended_alliance_text4").abbr = alliance:getProperty("abbr")
	i18n("recommended_alliance_text4").name = alliance:getProperty("name")
	_fields.Text_name:setString(i18n("common_text_186", i18n("recommended_alliance_text4")))
	_ENV = i18n("common_text_186", i18n("recommended_alliance_text4"))
	i18n("common_text_186", i18n("recommended_alliance_text4")).name = alliance:getProperty("leaderName")
	_fields.Text_leader:setString(i18n("common_text_170", i18n("common_text_186", i18n("recommended_alliance_text4"))))
	_fields.Text_power:setString(SoraDConvertNumberWithUnit(alliance:getProperty("totalBattle")))
	_fields.Text_member:setString(alliance:getMemberCount() .. "/" .. alliance:getProperty("limitCount"))
	_fields.Text_language:setString(allianceDesRead.getLanguageName(alliance:getProperty("language")))
	_fields.Load_flag:setVisible(false)
	local flag = alliance:getProperty("flag")
	local nodeFlag = display.newNode()
	nodeFlag:setScale(0.54)
	nodeFlag:setName("Node_flag")
	nodeFlag:addTo(_fields.Com_flag)
	allianceDesRead.getFlagWithParticle(flag, nodeFlag)
	local str = i18n("common_text_1160")
	if alliance:getProperty("recruitType") == gARecruit.public then
		_ENV = "notice_0206"
		;("notice_0206").color = "#F3CB3B"
		str = string.format("%s(%s)", str, SoraDWrapHtmlTagByStyle(i18n("notice_0206"), "notice_0206"))
	end
	_fields.Text_join:setString(str)
	local castleLv = alliance:getProperty("joinLevel")
	local warLv = buildLogic.transformBuildLvToWarLv(castleLv)
	local castleImg = "icon_castle.png"
	if 1 <= warLv then
		castleLv = warLv
		castleImg = "icon_warlevel.png"
	end
	_fields.Com_castleLv:setString(castleLv)
	_fields.Com_castleLv:setIcon(castleImg)
	local joinPower = alliance:getProperty("joinPower")
	_fields.Text_joinPower:setString(string.formatnumberthousands(joinPower))
	_fields.Button_chat:setTag(index)
	_fields.Button_chat:setString(i18n("common_text_179"))
	_fields.Button_chat:addClickListener(handler(self, self.onClickBtnChat))
	_fields.Button_join:setTag(index)
	_fields.Button_join:addClickListener(handler(self, self.onClickBtnJoin))
	_fields.Button_join = SoraDCreateTimerLabel(self, _fields.Button_join)
	_fields.Button_join:setTimeLast(function(timeStr)
		return i18n("alliance_office_btn_02") .. "\n" .. timeStr .. "s"
	end)
	_fields.Button_join:setTimeEndListener(function()
		self:updateApplyBtn(index)
	end)
	self:updateApplyBtn(index)
	if not SoraDFIsRA() then
		_UPVALUE7_ = self
		self[1] = _fields.Image_language
		self[2] = _fields.Text_language
		self[3] = _fields.Text_power
		self[4] = _fields.Text_member
		self[5] = _fields.Com_castleLv
		self[6] = _fields.Image_joinPower
		self[7] = _fields.Text_joinPower
		for __, v in ipairs(self) do
			v:fixPos()
		end
		_UPVALUE3_ = ipairs(self)
		ipairs(self)[1] = _fields.Text_power
		ipairs(self)[2] = _fields.Text_member
		ipairs(self)[3] = _fields.Com_castleLv
		for __, v in ipairs(ipairs(self)) do
			v:fixChildrenPos()
		end
	end
end
function Com_Activity_9001618:onClickBtnChat(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	local alliance = self.allianceList[index]
	local playerId = alliance:getProperty("leader")
	local nickName = alliance:getProperty("leaderName")
	local allianceAbbr = alliance:getProperty("abbr")
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
function Com_Activity_9001618:onClickBtnJoin(EventContext)
	SoraDPlaySound()
	if allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("alliance_join_tips_01"))
		return
	end
	local Button_join = EventContext:getSender()
	local index = Button_join:getTag()
	local joinType = Button_join.joinType
	local alliance = self.allianceList[index]
	local aid = alliance:getProperty("aid")
	local ownClv = SoraDGetCastleLv()
	local ownPower = lordInfoCtrl:getBaseInfo().totalFc
	local needClv = alliance:getProperty("joinLevel")
	local needPower = alliance:getProperty("joinPower")
	local uid = lordInfoCtrl:getLordInfo().base.uid
	if alliance:getProperty("isMigration") then
		SoraDShowMsgBox(i18n("common_text_2168"), i18n("common_text_204"))
	elseif joinType == gAJoinBtnType.CANCEL then
		allianceMgr:reqCancelApplyJoin(aid)
	elseif (ownClv < needClv or ownPower < needPower) and not alliance:hasInvitation(uid) then
		SoraDShowMsgTip(i18n("common_text_1159"), "#icon_alliance_no.png")
	elseif joinType == gAJoinBtnType.APPLY then
		allianceMgr:reqApplyJion(aid)
	else
		allianceMgr:reqJoinAlliance(aid)
	end
end
function Com_Activity_9001618:onMsgUpdateData(target, event)
	SoraDCloseLoading(self)
	if not event.recommend then
		local _ENV, recommend = event.recommend, event.recommend
	end
	_ENV = self
	if not recommend.top then
		_ENV = recommend.top
	end
	self[1] = recommend.top
	if not recommend.match then
		_ENV = recommend.match
	end
	self[2] = recommend.match
	if not recommend.history then
		_ENV = recommend.history
	end
	local self[3], ret = recommend.history, self
	for i, v in ipairs(ret) do
		if v.allianceinfo then
			local alliance = allianceMgr:createAlliance(v.allianceinfo)
			alliance.leaderName = v.leadername
			alliance.totalBattle = v.totalpower
			self.allianceList[i] = alliance
		end
	end
	self:updateAlliance()
end
function Com_Activity_9001618:updateApplyBtn(index)
	local obj = self.fields["Com_alliance" .. index]
	if not obj then
		return
	end
	local _fields = fguiHelper.get_fields(obj)
	_fields.Button_join:endTimeNoCauseEndCallBack()
	_fields.Image_apply:setVisible(false)
	_fields.Text_apply:setVisible(false)
	local alliance = self.allianceList[index]
	local c1 = _fields.Button_join:getController("c1")
	local uid = lordInfoCtrl:getLordInfo().base.uid
	local member = memberMgr:getOwnMember()
	local joinType
	if member:getProperty("curApplyAid") == alliance:getProperty("aid") then
		joinType = gAJoinBtnType.CANCEL
		local leftTime = 0
		_ENV = "aid"
		;("aid").byUID = true
		local applyTime = SoraDConfigGet("Game:allianceInfoView:applyTime~integer", "aid") or 0
		if 0 < applyTime then
			leftTime = math.max(30 - (os.time() - applyTime), 0)
		end
		if 0 < leftTime then
			_fields.Button_join:setEnabled(false)
			_fields.Button_join:beginTime(leftTime, false, true)
		else
			c1:setSelectedIndex(1)
			_fields.Button_join:setEnabled(true)
			_fields.Button_join:setString(i18n("common_text_184"))
		end
		_fields.Image_apply:setVisible(true)
		_fields.Text_apply:setVisible(true)
		_fields.Text_apply:setString(i18n("common_text_1051"))
	elseif alliance:getProperty("recruitType") == gARecruit.private and not alliance:hasInvitation(uid) then
		joinType = gAJoinBtnType.APPLY
		c1:setSelectedIndex(2)
		_fields.Button_join:setEnabled(true)
		_fields.Button_join:setString(i18n("common_text_182"))
	else
		joinType = gAJoinBtnType.JOIN
		c1:setSelectedIndex(2)
		_fields.Button_join:setEnabled(true)
		_fields.Button_join:setString(i18n("common_text_068"))
		if alliance:hasInvitation(uid) then
			_fields.Image_apply:setVisible(true)
			_fields.Text_apply:setVisible(true)
			_fields.Text_apply:setString(i18n("notice_0207"))
		end
	end
	_fields.Button_join.joinType = joinType
end
function Com_Activity_9001618:onMsgUpdateApplyBtn(target, event)
	for k, alliance in pairs(self.allianceList) do
		self:updateApplyBtn(k)
	end
end
return Com_Activity_9001618
