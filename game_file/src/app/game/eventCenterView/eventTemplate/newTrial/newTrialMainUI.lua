local newTrialMainUI = class("newTrialMainUI", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newTrialMainUI")
	end
	return target
end)
function newTrialMainUI:ctor()
	self:initControls()
end
function newTrialMainUI:initControls()
	self.image_singleBg = SoraDGetChildByName(self, "Image_bg")
	self.image_singleBg:setTouchEnabled(true)
	self.image_singleBg:setSwallowTouches(true)
	self.image_singleBg:addTouchEventListener(function(ref, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("newTrialMyTeamView")
		panel:initData()
		panel:show()
	end)
	self.frameBg = SoraDGetChildByName(self, "frame_bg")
	self.btn_enter = SoraDGetChildByName(self, "btn_enter")
	self.btn_enter:setTitleText(i18n("common_text_3318"))
	self.btn_enter:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		if SoraDGetCtrl("devilValleyCtrl"):checkEnterCondition() then
			SoraDShowMsgBox(i18n("devilvalley_tips_13"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					SoraDGetCtrl("devilValleyCtrl"):sendReqStartChallenge()
				end
			end)
		end
	end)
	self.Node_avatar = SoraDGetChildByName(self, "Node_avatar")
	_UPVALUE1_ = "Node_avatar"
	;("Node_avatar")[1] = "playerAvatarBox_1"
	self.avatarList, _ENV, self.playerAvatarBox_1 = SoraDGetChildByFullPath(self.Node_avatar, "Node_avatar"), SoraDGetChildByFullPath(self.Node_avatar, "Node_avatar"), SoraDGetChildByFullPath(self.Node_avatar, "Node_avatar")
	for i = 1, 4 do
		local avatar
		if i == 1 then
			avatar = self.playerAvatarBox_1
		else
			avatar = self.playerAvatarBox_1:clone()
			avatar:addTo(self.Node_avatar)
		end
		local posX = SoraDFPosX(105 - (i - 1) * 70, 0)
		avatar:setPositionX(posX)
		table.insert(self.avatarList, avatar)
	end
	self.txtState = SoraDGetChildByName(self, "text_state")
	self.Node_info = SoraDGetChildByName(self, "Node_info")
	self.Node_info:setVisible(false)
	self.txtInfo = SoraDGetChildByName(self, "text_start")
	self.btnStart = SoraDGetChildByName(self, "btn_start")
	self.btnStart:setTitleText(i18n("devilvalley_btn_15"))
	self.btnStart:addTouchEventListener(handler(self, self.btnBeginWar))
	self.heightWidget = false
end
function newTrialMainUI:initHeadData()
	local count = #self.teams.challengeMember
	for i, v in ipairs(self.avatarList) do
		local Image_head = SoraDGetChildByName(v, "Image_head")
		if i > count then
			Image_head:loadTexture("frame_LegendaryKing_green_add.png", ccui.TextureResType.plistType)
		else
			Image_head:setVisible(true)
			local player = self.teams.playerInfo[tostring(self.teams.challengeMember[i])]
			SoraDGetHeadFromManager(Image_head, player.iconID, player.avatar)
		end
	end
end
function newTrialMainUI:initData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
	self.teams = devilValleyCtrl:getMyTeams()
	local isBegin = self.teams.start
	if isBegin then
		self:setWidgetHeight(false)
		self.btn_enter:setVisible(true)
		self.Node_avatar:setVisible(false)
		self.Node_info:setVisible(false)
		self.image_singleBg:addTouchEventListener(function()
		end)
		local startTime = self.teams.startTime
		local time = serviceFunctions.systemTime() - startTime
		self.txtState:setVisible(true)
		self.txtState:setString(i18n("devilvalley_text_39") .. SoraDConvertSecondToStringNoDay(time))
		SoraDCreateTimerEx(self, function(dt)
			local time = serviceFunctions.systemTime() - startTime
			self.txtState:setString(i18n("devilvalley_text_39") .. SoraDConvertSecondToStringNoDay(time))
		end, 1.0)
	else
		self.btn_enter:setVisible(false)
		self.Node_avatar:setVisible(true)
		self:initHeadData()
		self.txtState:setString(i18n("devilvalley_text_38"))
		local playerID = gametop.playertop_:getPlayerID()
		self.isCaptain = playerID == tonumber(self.teams.leaderUid)
		if #self.teams.challengeMember >= 4 then
			self.Node_info:setVisible(true)
			self.txtState:setVisible(false)
			if self.isCaptain then
				self.btnStart:setVisible(true)
				self.txtInfo:setString(i18n("devilvalley_text_58"))
				self:setWidgetHeight(true)
			else
				self.txtInfo:setString(i18n("devilvalley_text_59"))
				self.btnStart:setVisible(false)
				self:setWidgetHeight(false)
			end
		else
			self.txtState:setVisible(true)
			self:setWidgetHeight(false)
			self.Node_info:setVisible(false)
		end
	end
end
function newTrialMainUI:setWidgetHeight(heightWidget)
	if self.heightWidget == heightWidget then
		return
	end
	self.heightWidget = heightWidget
	local cSize = self.image_singleBg:getContentSize()
	if self.heightWidget then
		self.image_singleBg:setContentSize(cc.size(cSize.width, 152))
		self.frameBg:setPositionY(-200)
	else
		self.image_singleBg:setContentSize(cc.size(cSize.width, 112))
		self.frameBg:setPositionY(-160)
	end
end
function newTrialMainUI:btnBeginWar(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if _G.SoraDGetCtrl("devilValleyCtrl"):checkEnterCondition() then
		SoraDShowMsgBox(i18n("devilvalley_tips_13"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				local gametop = gModuleMgr.getObject("gametop")
				local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
				devilValleyCtrl:sendReqStartChallenge()
			end
		end)
	end
end
return newTrialMainUI
