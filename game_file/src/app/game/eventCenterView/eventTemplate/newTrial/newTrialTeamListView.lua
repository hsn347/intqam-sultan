local gametop = gModuleMgr.getObject("gametop")
local GridScrollView = include("GridScrollView")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local newTrialRead = include("newTrialRead")
local showCount = newTrialRead.showCount + 1
local newTrialTeamListView = class("newTrialTeamListView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newTrialTeamListView")
	end
	return target
end)
function newTrialTeamListView:ctor()
	self.showType = 0
	self:initWidget()
	self:addMessage()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.016666666666666666)
	;(nil)[2] = cca.callFunc(handler(self, self.initData))
	;(nil)[3] = cca.callFunc(handler(self, self.initData))
	;(nil)[4] = cca.callFunc(handler(self, self.initData))
	;(nil)[5] = cca.callFunc(handler(self, self.initData))
	self:runAction(cca.seq(nil))
end
function newTrialTeamListView:addMessage(...)
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_TEAM_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		if not devilValleyCtrl:hasTeams() then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_TEAMLIST_REFRESH", function(target, data)
		self:initData()
	end)
end
function newTrialTeamListView:initWidget(...)
	self:addTouchEventListener(function(ref, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		self:closeShow2()
	end)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("devilvalley_text_01"))
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Text_2 = SoraDGetChildByName(self, "Text_2")
	self.Text_2:setString(i18n("devilvalley_btn_03"))
	self.spArrow = SoraDGetChildByName(self, "Sprite_arrow_l")
	self.spArrow:setRotation(90)
	self.Image_touch = SoraDGetChildByName(self, "Image_touch")
	self.Image_touch:setTouchEnabled(true)
	self.Image_touch:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Image_choose = SoraDGetChildByName(self, "Image_choose")
	self.Image_choose:setScaleY(0)
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	GridScrollView = "Bottom_Node"
	;("Bottom_Node")[1] = "Button_1"
	self.Button_1 = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_1:setTitleText(i18n("devilvalley_btn_11"))
	self.Button_1:addTouchEventListener(handler(self, self.btnClickCallback))
	GridScrollView = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Button_2"
	self.Button_2 = SoraDGetChildByFullPath(self.Bottom_Node, handler(self, self.btnClickCallback))
	self.Button_2:setTitleText(i18n("devilvalley_btn_12"))
	self.Button_2:addTouchEventListener(handler(self, self.btnClickCallback))
	SoraDAutoSizeButtonText(self.Button_1)
	SoraDAutoSizeButtonText(self.Button_2)
	self.Node_Item = SoraDGetChildByName(self, "Node_Item")
	self.Node_Item:setVisible(false)
	self.Node_choose = SoraDGetChildByName(self, "Node_choose")
	self.Node_choose:setVisible(false)
	self:initChoosePanel()
	self.scroll = SoraDGetChildByName(self, "Top_Size_scroll_teams")
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = "Top_Size_scroll_teams"
	;("Top_Size_scroll_teams").col = 1
	;("Top_Size_scroll_teams").top = 30
	;("Top_Size_scroll_teams").left = 10
	;("Top_Size_scroll_teams").h = 15
	;("Top_Size_scroll_teams").isUseParent = true
	self.scroll:init("Top_Size_scroll_teams", 0, handler(self, self.createCell), handler(self, self.updateCell))
	self.scroll:addTouchEventListener(function(ref, type)
		if type ~= ccui.TouchEventType.began then
			return
		end
		self:closeShow2()
	end)
	self.Center_Text_noteam = SoraDGetChildByName(self, "Center_Text_noteam")
	self.Center_Text_noteam:setString(i18n("devilvalley_text_13"))
	self:addDoubleFireEffect()
	self.Button_help:setVisible(IsArClient)
	self.chooseScale = 1
	if display.height < 960 then
		self.chooseScale = 0.9
		SoraDGetChildByName(self, "Top_Node"):setLocalZOrder(1)
	end
end
function newTrialTeamListView:initData(...)
	self.teamsAll = devilValleyCtrl:getTeamListInfo()
	self.teams = self:getTeamsByType(self.showType)
	self:updateScroll()
	self.scroll:jumpToTop()
end
function newTrialTeamListView:updateScroll(...)
	self.scroll:updateNum(#self.teams)
	if #self.teams > 0 then
		self.Center_Text_noteam:setVisible(false)
	else
		self.Center_Text_noteam:setVisible(true)
	end
end
function newTrialTeamListView:btnClickCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if button == self.Button_help then
		self:btnHelpCallback()
	elseif button == self.Button_1 then
		self:btnCreateTeam()
	elseif button == self.Button_2 then
		self:btnQuickJoin()
	elseif button == self.Image_touch then
		self:btnChooseType()
	end
end
function newTrialTeamListView:btnHelpCallback()
	if IsArClient then
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEW_TRIAL)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSingleType.NEW_TRIAL_EN)
	end
end
function newTrialTeamListView:btnCreateTeam()
	self:closeShow2()
	local popView = SoraDCreatePanel("newTrialSelectView")
	popView:show()
end
function newTrialTeamListView:btnChooseType()
	if not self.isShow2 then
		self.isShow2 = true
		self.spArrow:runAction(cc.RotateTo:create(0.3, 0))
		self.Image_choose:runAction(cc.ScaleTo:create(0.3, self.chooseScale, self.chooseScale))
	else
		self:closeShow2()
	end
end
function newTrialTeamListView:closeShow2(...)
	if self.isShow2 then
		self.isShow2 = false
		self.spArrow:runAction(cc.RotateTo:create(0.3, 90))
		self.Image_choose:runAction(cc.ScaleTo:create(0.3, self.chooseScale, 0.0))
	end
end
function newTrialTeamListView:btnQuickJoin()
	self:closeShow2()
	if self.showType == 0 then
		devilValleyCtrl:sendReqFastJoin()
	else
		devilValleyCtrl:sendReqFastJoin(self.showType)
	end
end
function newTrialTeamListView:addDoubleFireEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 36
	_ENV, (nil).pos, (nil).y = nil, nil, 60
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 36
	_ENV, (nil).pos, (nil).y = nil, nil, 90
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 36
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 60
	local param
	local parNode1 = SoraDCreateEffectNode(param)
	parNode1:addTo(SoraDGetChildByName(self, "frame_lace_base_1"), -2)
	local parNode2 = SoraDCreateEffectNode(param)
	parNode2:addTo(SoraDGetChildByName(self, "frame_lace_base_2"), -2)
end
function newTrialTeamListView:createCell()
	local cell = self:createItem()
	return cell
end
function newTrialTeamListView:updateCell(panel, i)
	local index = i
	local data = self.teams[index]
	panel.initData(data)
end
function newTrialTeamListView:createItem()
	local item = self.Node_Item:clone()
	item:setVisible(true)
	newTrialRead = true
	;(true)[1] = "Panel_1"
	;(true)[2] = "Image_7"
	item.Image_bg = SoraDGetChildByFullPath(item, true)
	devilValleyCtrl = true
	;(true)[1] = "Text_typename"
	item.Text_typename = SoraDGetChildByFullPath(item, true)
	devilValleyCtrl = true
	;(true)[1] = "Text_team_name"
	item.Text_team_name = SoraDGetChildByFullPath(item, true)
	devilValleyCtrl = true
	;(true)[1] = "Button_join"
	item.Button_join = SoraDGetChildByFullPath(item, true)
	devilValleyCtrl = true
	;(true)[1] = "Image_head"
	item.Image_head = SoraDGetChildByFullPath(item, true)
	item.Image_head:setName("Image_head_1")
	item.teamInfo, _ENV = item.Image_head.setName, item.Image_head.setName
	item.Button_join:setTitleText(i18n("common_text_068"))
	item.Button_join:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		self:closeShow2()
		if not button:isBright() then
			local challengeLv = item.teamInfo.challengeLv
			if not devilValleyCtrl:checkChallengeLv(challengeLv) then
				SoraDShowMsgTip(i18n("devilvalley_text_51"))
			elseif not devilValleyCtrl:checkCastleCondition(challengeLv) then
				local lvLimit = newTrialRead.getCastleCondition(challengeLv)
				local transLevel = function(bLevel)
					local buildLogic = include("buildLogic")
					local warLv = buildLogic.transformBuildLvToWarLv(bLevel)
					if 0 < warLv then
						_ENV = nil
						;(nil).lv = warLv
						return i18n("common_text_1948", nil)
					else
						return math.min(bLevel, _G.CASTLE_MAXLV_NOWAR)
					end
				end
				local lv = transLevel(lvLimit)
				_ENV = i18n("devilvalley_text_51")
				i18n("devilvalley_text_51").lv = lv
				SoraDShowMsgTip(i18n("common_text_3868", i18n("devilvalley_text_51")))
			end
		else
			local teamIdEx = item.teamInfo.teamIdEx
			local challengeLv = item.teamInfo.challengeLv
			devilValleyCtrl:sendReqJoinTeam(teamIdEx, challengeLv)
		end
	end)
	function item.initData(data)
		item.teamInfo = data
		local mtype = data.challengeLv
		local info = newTrialRead.getChallengeInfo(mtype)
		if info then
			SoraChangeSpriteImage(item.Image_bg, info.bg)
			item.Text_typename:setString(i18n(info.name))
			item.Text_typename:setColor(info.color)
		end
		local tcount = #data.challengeMember
		local leaderName = data.playerInfo[tostring(data.leaderUid)].nickname
		item.Text_team_name:setString(string.format("%s(%d/4)", leaderName, tcount))
		for i = 1, tcount do
			local Image_head = item:getChildByName("Image_head_" .. i)
			if not Image_head then
				Image_head = item.Image_head:clone()
				Image_head:setName("Image_head_" .. i)
				Image_head:addTo(item)
				if SoraDFIsRA() then
					Image_head:setPositionX(item.Image_head:getPositionX() - (i - 1) * 90)
				else
					Image_head:setPositionX(item.Image_head:getPositionX() + (i - 1) * 90)
				end
			else
				Image_head:setVisible(true)
			end
			local player = data.playerInfo[tostring(data.challengeMember[i])]
			SoraDGetHeadFromManager(Image_head, player.iconID, player.avatar)
		end
		for i = tcount + 1, 4 do
			local Image_head = item:getChildByName("Image_head_" .. i)
			if Image_head then
				Image_head:setVisible(false)
			end
		end
		if devilValleyCtrl:checkIsUnLock(mtype) then
			item.Button_join:setBright(true)
		else
			item.Button_join:setBright(false)
		end
	end
	return item
end
function newTrialTeamListView:initChoosePanel(...)
	local itemHeight = self:getWidth() / self:getHeight() > 0.7 and 40 or 50
	local sH = showCount * itemHeight + 25
	self.Image_choose:setContentSize(cc.size(self.Image_choose:getContentSize().width, sH))
	for i = 1, showCount do
		local item = self:createChooseItem(self.Node_choose, i - 1, false, function(mtype, type)
			local info = newTrialRead.getChallengeInfo(mtype)
			if info then
				self.Text_2:setString(i18n(info.name))
				self.Text_2:setColor(info.color)
			end
			self:closeShow2()
			self.showType = mtype
			devilValleyCtrl:sendReqTeamInfo()
		end)
		item:addTo(self.Image_choose)
		item:setPosition(cc.p(self.Image_choose:getContentSize().width / 2, (showCount - i + 1) * itemHeight - 13))
	end
end
function newTrialTeamListView:createChooseItem(widget, mtype, showLock, handle)
	local item = widget:clone()
	item:setVisible(true)
	item.img_touch = SoraDGetChildByName(item, "img_touch")
	item.Sprite_lock = SoraDGetChildByName(item, "Sprite_lock")
	item.Image_line = SoraDGetChildByName(item, "Image_line")
	item.Text_name = SoraDGetChildByName(item, "Text_name")
	local info = newTrialRead.getChallengeInfo(mtype)
	if info then
		item.Text_name:setString(i18n(info.name))
		item.Text_name:setColor(info.color)
	end
	item.img_touch:setTouchEnabled(true)
	item.img_touch:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		if handle then
			handle(mtype, type)
		end
	end)
	if mtype == showCount - 1 then
		item.Image_line:setVisible(false)
	end
	if item.Sprite_lock then
		if showLock and not devilValleyCtrl:checkChallengeLv(mtype) then
			item.Sprite_lock:setVisible(true)
		else
			item.Sprite_lock:setVisible(false)
		end
	end
	return item
end
function newTrialTeamListView:getTeamsByType(stype)
	if not stype or stype == 0 then
		return self:sortData(self.teamsAll, true)
	end
	local _ENV, list = self.sortData, self.sortData
	for i, v in ipairs(self.teamsAll) do
		if v.challengeLv == stype then
			table.insert(list, v)
		end
	end
	return self:sortData(list, false)
end
function newTrialTeamListView:sortData(data, needCheckLv)
	local memberSort = function(a, b)
		local memberA = #a.challengeMember
		local memberB = #b.challengeMember
		if memberA == memberB then
			return a.challengeLv > b.challengeLv
		elseif memberA == 4 or memberB == 4 then
			return memberA ~= 4
		else
			return memberA > memberB
		end
	end
	if needCheckLv then
		table.sort(data, function(a, b)
			local unLockA = devilValleyCtrl:checkIsUnLock(a.challengeLv)
			local unLockB = devilValleyCtrl:checkIsUnLock(b.challengeLv)
			if unLockA ~= unLockB then
				return unLockA
			end
			return memberSort(a, b)
		end)
	else
		table.sort(data, function(a, b)
			return memberSort(a, b)
		end)
	end
	return data
end
function newTrialTeamListView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDGetCtrl("devilValleyCtrl"):sendReqTeamInfo()
		self:closePanel()
	end
end
return newTrialTeamListView
