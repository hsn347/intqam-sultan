local gametop = gModuleMgr.getObject("gametop")
local GridScrollView = include("GridScrollView")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local newTrialRead = include("newTrialRead")
local newTrialMyTeamView = class("newTrialMyTeamView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newTrialMyTeamView")
	end
	return target
end)
function newTrialMyTeamView:ctor()
	self.teams, devilValleyCtrl = nil, nil
	self.isCaptain = false
	self:initWidget()
	devilValleyCtrl:sendReqInitInfo()
end
function newTrialMyTeamView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_TEAM_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		if not devilValleyCtrl:hasTeams() then
			SoraDRemoveAllAfterPanelFromManager(self)
		else
			self:initData()
		end
	end)
end
function newTrialMyTeamView:initWidget(...)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("devilvalley_text_01"))
	_UPVALUE1_ = i18n("devilvalley_text_01")
	i18n("devilvalley_text_01")[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("devilvalley_text_01"))
	self.Button_help:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE1_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Button_1"
	self.Button_1 = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_1:setTitleText(i18n("devilvalley_btn_15"))
	self.Button_1:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Node_Item = SoraDGetChildByName(self, "Node_Item")
	self.Node_Item:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_scroll_teams")
	_UPVALUE1_ = "Top_Size_scroll_teams"
	;("Top_Size_scroll_teams")[1] = "Node_myTeam"
	self.Node_myTeam = SoraDGetChildByFullPath(self.scroll, "Top_Size_scroll_teams")
	self.Image_bg = SoraDGetChildByName(self, "Image_7")
	self.Image_1 = SoraDGetChildByName(self, "Image_1")
	self.Image_1:setFillType(1)
	self.Text_typename = SoraDGetChildByName(self, "Text_typename")
	self.Text_title = SoraDGetChildByName(SoraDGetChildByName(self, "Panel_1"), "Text_title")
	self.Button_break = SoraDGetChildByName(self, "Button_break")
	self.Button_break:setTitleText(i18n("devilvalley_btn_16"))
	self.Button_break:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Button_break:setButtonType(ccui.ButtonType.TRISTATE)
	SoraDAutoSizeButtonText(self.Button_break)
	self.txtInfo = SoraDGetChildByName(self, "text_start")
	self.txtInfo:setString(i18n("devilvalley_text_59"))
	self:addDoubleFireEffect()
	self.Button_help:setVisible(IsArClient)
end
function newTrialMyTeamView:initData(...)
	if not devilValleyCtrl:getMyTeams() then
		devilValleyCtrl:getMyTeams().challengeMember, devilValleyCtrl, devilValleyCtrl = devilValleyCtrl, devilValleyCtrl, devilValleyCtrl:getMyTeams()
	end
	self.teams = devilValleyCtrl:getMyTeams()
	if not self.teams.challengeMember then
		devilValleyCtrl = self.teams.challengeMember
	end
	self.teams.challengeMember = self.teams.challengeMember
	local playerID = gametop.playertop_:getPlayerID()
	self.isCaptain = playerID == tonumber(self.teams.leaderUid)
	local mtype = self.teams.challengeLv
	local info = newTrialRead.getChallengeInfo(mtype)
	if info then
		SoraChangeSpriteImage(self.Image_bg, info.bg)
		self.Text_typename:setString(i18n(info.name))
		self.Text_typename:setColor(info.color)
	end
	local teamName = i18n("remains_title_01")
	local count = #self.teams.challengeMember
	self.Text_title:setString(string.format("%s（%d/4）", teamName, count))
	_ENV = self.Text_title
	self.Text_title[1] = self.Text_typename
	self.Text_title[2] = self.Text_title
	gametop = self.Text_title
	self.Text_title[1] = 10
	SoraDAlignNodeArray(self.Text_title, SoraDFIsRA(), self.Text_title)
	for i = 1, 4 do
		local item = self.Node_myTeam:getChildByName("Node_item_" .. i)
		if not item then
			item = self:createItem()
			item:addTo(self.Node_myTeam)
			item:setName("Node_item_" .. i)
			item:setPosition(cc.p(0, 0 - (i - 1) * 115))
		end
		item.initData(i)
	end
	self.Node_myTeam:setPosition(cc.p(0, self.scroll:getInnerContainerSize().height - 120))
	self.scroll:setBounceEnabled(self.scroll:getInnerContainerSize().height > self.scroll:getContentSize().height)
	self.txtInfo:setVisible(false)
	if self.isCaptain then
		self.Button_break:setVisible(true)
		if self.isCaptain and #self.teams.challengeMember < 2 then
			self.Button_1:setBright(false)
		else
			self.Button_1:setBright(true)
		end
	else
		self.Button_break:setVisible(false)
		if self.teams.start then
			self.Button_1:setVisible(true)
		else
			self.Button_1:setVisible(false)
			if #self.teams.challengeMember >= 4 then
				self.txtInfo:setVisible(true)
			end
		end
	end
end
function newTrialMyTeamView:btnClickCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if button == self.Button_help then
		self:btnHelpCallback()
	elseif button == self.Button_1 then
		self:btnBeginWar()
	elseif button == self.Button_break then
		self:btnBreakTeam()
	end
end
function newTrialMyTeamView:btnHelpCallback()
	if IsArClient then
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEW_TRIAL)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSingleType.NEW_TRIAL_EN)
	end
end
function newTrialMyTeamView:btnBeginWar()
	if not self.Button_1:isBright() then
		SoraDShowMsgTip(i18n("devilvalley_tips_19"))
		return
	end
	if SoraDGetCtrl("devilValleyCtrl"):checkEnterCondition() then
		SoraDShowMsgBox(i18n("devilvalley_tips_13"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				devilValleyCtrl:sendReqStartChallenge()
			end
		end)
	end
end
function newTrialMyTeamView:btnBreakTeam()
	SoraDShowMsgBox(i18n("devilvalley_text_16"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
		if eventType == MSGBOX_CALLBACK_YES then
			devilValleyCtrl:sendReqDissolveTeam(self.teams.teamIdEx)
		end
	end)
end
function newTrialMyTeamView:addDoubleFireEffect()
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
function newTrialMyTeamView:createItem()
	local item = self.Node_Item:clone()
	item:setVisible(true)
	devilValleyCtrl = true
	;(true)[1] = "Image_head"
	item.Image_head = SoraDGetChildByFullPath(item, true)
	devilValleyCtrl = true
	;(true)[1] = "Text_name"
	item.Text_name = SoraDGetChildByFullPath(item, true)
	devilValleyCtrl = true
	;(true)[1] = "Text_power"
	item.Text_power = SoraDGetChildByFullPath(item, true)
	devilValleyCtrl = true
	;(true)[1] = "Text_des"
	item.Text_des = SoraDGetChildByFullPath(item, true)
	devilValleyCtrl = true
	;(true)[1] = "Button_join"
	item.Button_join = SoraDGetChildByFullPath(item, true)
	SoraDAutoSizeButtonText(item.Button_join, cc.size(140, 52))
	devilValleyCtrl = cc.size(140, 52)
	cc.size(140, 52)[1] = "Image_flag"
	item.Image_flag = SoraDGetChildByFullPath(item.Image_head, cc.size(140, 52))
	devilValleyCtrl = cc.size(140, 52)
	cc.size(140, 52)[1] = "Image_out"
	item.Image_out = SoraDGetChildByFullPath(item.Image_head, cc.size(140, 52))
	item.Image_out:setTouchEnabled(true)
	item.Image_out:addTouchEventListener(function(ref, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("devilvalley_text_17"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				local kickOutUid = self.teams.challengeMember[item.index]
				devilValleyCtrl:sendReqKickoutTeam(kickOutUid)
			end
		end)
	end)
	function item.initData(index)
		item.index = index
		local count = #self.teams.challengeMember
		if index > count then
			item.Image_head:setVisible(false)
			item.Text_name:setVisible(false)
			item.Text_power:setVisible(false)
			item.Text_des:setVisible(true)
			if index == count + 1 then
				item.Button_join:loadTextures("btn_blue_normal_01.png", "", "", ccui.TextureResType.plistType)
				item.Button_join:setTitleText(i18n("remains_btn_10"))
				if self.teams.start then
					item.Button_join:setVisible(false)
					item.Text_des:setVisible(false)
				else
					item.Button_join:setVisible(true)
					item.Text_des:setString(i18n("devilvalley_text_15"))
					item.Button_join:addTouchEventListener(function(ref, type)
						if type ~= ccui.TouchEventType.ended then
							return
						end
						SoraDPlaySound()
						if item.Button_join:isBright() then
							devilValleyCtrl:sendReqShareChat()
						else
							SoraDShowMsgTip(i18n("devilvalley_tips_12"))
						end
					end)
				end
				function item(ref, type)
					if type ~= ccui.TouchEventType.ended then
						return
					end
					SoraDPlaySound()
					if item.Button_join:isBright() then
						devilValleyCtrl:sendReqShareChat()
					else
						SoraDShowMsgTip(i18n("devilvalley_tips_12"))
					end
				end
				;(function(ref, type)
					if type ~= ccui.TouchEventType.ended then
						return
					end
					SoraDPlaySound()
					if item.Button_join:isBright() then
						devilValleyCtrl:sendReqShareChat()
					else
						SoraDShowMsgTip(i18n("devilvalley_tips_12"))
					end
				end).byUID = true
				local shareTime = SoraDConfigGet("Game:newTrialMyTeamView:shareTime~integer", function(ref, type)
					if type ~= ccui.TouchEventType.ended then
						return
					end
					SoraDPlaySound()
					if item.Button_join:isBright() then
						devilValleyCtrl:sendReqShareChat()
					else
						SoraDShowMsgTip(i18n("devilvalley_tips_12"))
					end
				end) or 0
				self.leftTime = self.leftTime or 0
				if 0 < shareTime then
					self.leftTime = math.max(60 - (os.time() - shareTime), 0)
				end
				if 0 < self.leftTime then
					item.Button_join:setBright(false)
					if not self.timeHandler then
						self.timeHandler = SoradCreateTimer(self, function(dt)
							if self.leftTime > 0 then
								self.leftTime = self.leftTime - 1
							else
								item.Button_join:setBright(true)
								SoraDManagerRemoveTimer(self, self.timeHandler)
								self.timeHandler = nil
							end
						end)
					end
				else
					item.Button_join:setBright(true)
				end
			else
				item.Button_join:setVisible(false)
				item.Text_des:setVisible(not self.teams.start)
				item.Text_des:setString(i18n("devilvalley_text_14"))
			end
		else
			item.Image_head:setVisible(true)
			item.Text_name:setVisible(true)
			item.Text_power:setVisible(true)
			item.Text_des:setVisible(false)
			item.Button_join:loadTextures("btn_red_normal_01.png", "", "", ccui.TextureResType.plistType)
			item.Button_join:setTitleText(i18n("remains_btn_09"))
			item.Button_join:addTouchEventListener(function(ref, type)
				if type ~= ccui.TouchEventType.ended then
					return
				end
				SoraDPlaySound()
				SoraDShowMsgBox(i18n("devilvalley_text_18"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						self:removeFromParent()
						devilValleyCtrl:sendReqLeaveTeam()
					end
				end)
			end)
			local uid = self.teams.challengeMember[index]
			if index == 1 then
				item.Button_join:setVisible(false)
				item.Image_flag:setVisible(true)
				item.Image_out:setVisible(false)
			else
				item.Image_flag:setVisible(false)
				if self.isCaptain then
					item.Image_out:setVisible(true)
				else
					item.Image_out:setVisible(false)
				end
				local playerID = gametop.playertop_:getPlayerID()
				if playerID == uid then
					item.Button_join:setVisible(true)
				else
					item.Button_join:setVisible(false)
				end
			end
			local data = self.teams.playerInfo[tostring(uid)]
			item.Text_name:setString(data.nickname)
			item = i18n("remains_btn_09")
			i18n("remains_btn_09").power = string.formatnumberthousands(data.totalFc)
			item.Text_power:setString(i18n("common_text_710", i18n("remains_btn_09")))
			SoraDGetHeadFromManager(item.Image_head, data.iconID, data.avatar)
		end
	end
	return item
end
return newTrialMyTeamView
