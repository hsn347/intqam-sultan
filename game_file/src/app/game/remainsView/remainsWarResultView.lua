local remainsWarRead = include("remainsWarRead")
local remainsWarUtil = include("remainsWarUtil")
local remainsWarResultView = class("remainsWarResultView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarResultView")
	end
	return target
end)
function remainsWarResultView:ctor()
	self:setBackGround(229.5)
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.nodeResutl = SoraDGetChildByName(self, "Top_Node_result")
	self.spFlagSuc = SoraDGetChildByName(self, "Sprite_flag_suc")
	self.spFlagFail = SoraDGetChildByName(self, "Sprite_flag_fail")
	self.txtScoreSouth = SoraDGetChildByName(self, "Text_score_south")
	self.txtScoreNorth = SoraDGetChildByName(self, "Text_score_north")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.nodeMemberLeft = SoraDGetExtendChildFromCCSByName(self, "CCS_remainsWarResultSingle_left")
	self.nodeMemberRight = SoraDGetExtendChildFromCCSByName(self, "CCS_remainsWarResultSingle_right")
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.onBtnOKClick))
	self.Button_share = SoraDGetChildByName(self, "Button_share")
	self.Button_share:addTouchEventListener(handler(self, self.onBtnShareClick))
	self:initEffect()
	self.isInRemains = true
end
function remainsWarResultView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_RESUT_SHARE", handler(self, self.updateShareStatus))
end
function remainsWarResultView:initEffect()
	self.nodeVS = SoraDGetChildByName(self, "Node_VS")
	remainsWarUtil.addVSEffect(self.nodeVS)
	self.spVSBG = SoraDGetChildByName(self, "Sprite_VS_BG")
	remainsWarUtil.addVSAnimation(self, self.spVSBG)
end
function remainsWarResultView:initData(data)
	dump(data, "data", 10)
	if not data.resultInfo then
		_ENV = data.resultInfo
	end
	self.tableSingleData = data.resultInfo
	if not self.tableSingleData.ruinsWarSettleData then
		local _ENV, ruinsWarSettleData = self.tableSingleData.ruinsWarSettleData, self.tableSingleData.ruinsWarSettleData
	end
	if not ruinsWarSettleData[_G.RW_CAMP.SOUTH] then
		local _ENV, southData = ruinsWarSettleData[_G.RW_CAMP.SOUTH], ruinsWarSettleData[_G.RW_CAMP.SOUTH]
	end
	if not ruinsWarSettleData[_G.RW_CAMP.NORTH] then
		local _ENV, northData = ruinsWarSettleData[_G.RW_CAMP.NORTH], ruinsWarSettleData[_G.RW_CAMP.NORTH]
	end
	self.southData = southData
	self.northData = northData
	if not southData.members then
		_ENV = southData.members
	end
	if not remainsWarUtil.isSelfIn(southData.members) then
		if not northData.members then
			_ENV = northData.members
		end
	end
	self.isInRemains = remainsWarUtil.isSelfIn(northData.members)
	self:setViewStatus()
	self:updateBaseInfo()
	self:updateScrollList()
	self:updateShareStatus()
end
function remainsWarResultView:updateBaseInfo()
	do
		local rankSouthScore = self.southData.points or 0
		self.txtScoreSouth:setString(string.formatnumberthousands(rankSouthScore))
	end
	do
		local rankSouthScore = self.northData.points or 0
		self.txtScoreNorth:setString(string.formatnumberthousands(rankSouthScore))
	end
	if self.southData.isWin then
		self.spFlagSuc:setPositionX(-280)
		self.spFlagFail:setPositionX(280)
	else
		self.spFlagSuc:setPositionX(280)
		self.spFlagFail:setPositionX(-280)
	end
end
function remainsWarResultView:setViewStatus()
	if not self.isInRemains then
		self.Text_tip:setVisible(false)
		self.Button_share:setVisible(false)
		self.Button_ok:setPositionX(320)
	else
		local tips_key, animateNmae
		local bSuc = self.tableSingleData.isWin
		if not bSuc then
			if SoraDFIsRA() then
				animateNmae = "heroTrialLoseAr"
			else
				animateNmae = "heroTrialLoseEn"
			end
			tips_key = "remains_text_91"
		else
			if SoraDFIsRA() then
				animateNmae = "heroTrialWinAr"
			else
				animateNmae = "heroTrialWinEn"
			end
			tips_key = "remains_text_90"
		end
		if animateNmae then
			local node = SoraDCreatAnimation(animateNmae, nil, false)
			self.nodeResutl:addChild(node)
		end
		if tips_key then
			local colorText = remainsWarRead.getWarStatusColor(bSuc)
			self.Text_tip:setString(i18n(tips_key))
			self.Text_tip:setColor(colorText)
		end
	end
end
function remainsWarResultView:updateScrollList()
	local data_left = self.southData
	local data_right = self.northData
	self.nodeMemberLeft:initData(data_left)
	self.nodeMemberRight:initData(data_right)
	local listHeightLeft = self.nodeMemberLeft:getHeight()
	local listHeightRight = self.nodeMemberRight:getHeight()
	local listHeight = math.max(listHeightLeft, listHeightRight)
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeMemberLeft:setPositionY(sH - 10)
	self.nodeMemberRight:setPositionY(sH - 10)
end
function remainsWarResultView:onBtnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(self, ccui.TouchEventType.ended)
	end
end
function remainsWarResultView:onBtnShareClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("remainsWarResultShareBox")
		panel:show()
	end
end
function remainsWarResultView:updateShareStatus()
	local remainsWarUtil = include("remainsWarUtil")
	local err = remainsWarUtil.checkResultShare()
	local enable = gErrDef.Err_None == err
	if enable then
		self.Button_share:setTitleText(i18n("common_text_533"))
	else
		self.Button_share:setTitleText(i18n("remains_text_198"))
	end
	self.Button_share:setTouchEnabled(enable)
	self.Button_share:setBright(enable)
end
function remainsWarResultView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		if remainsWarUtil.checkIsInRemainsXianXia() then
			if not self.isInRemains then
				_ENV = nil
				;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
				;(nil).viewType = VIEW_TYPE_CITY
				SoraDSendMessage(nil)
			end
			self:closePanel()
			if self.isInRemains and not worldMapDefine.isInRemains() then
				_G.SoraDQuickLogin()
			end
			return
		end
		local panel = SoraDCreatePanel("remainsWarResultTitleView")
		panel:show()
		_ENV = nil
		;(nil).resultInfo = self.tableSingleData
		panel:initData(nil)
		self:closePanel()
	end
end
return remainsWarResultView
