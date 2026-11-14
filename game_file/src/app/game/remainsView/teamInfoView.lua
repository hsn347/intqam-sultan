local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local remainsWarUtil = include("remainsWarUtil")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local RW_CAMP = _G.RW_CAMP
local teamInfoView = class("teamInfoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamInfoView")
	end
	return target
end)
function teamInfoView:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("remains_title_05"))
	self.nodeScore = SoraDGetExtendChildFromCCSByName(self, "CCS_teamInfoScore_title")
	self.nodeScore:initViewWar()
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.nodeMemberLeft = SoraDGetExtendChildFromCCSByName(self, "CCS_teamInfoSingle_left")
	self.nodeMemberLeft:setScroll(self.scroll)
	self.nodeMemberLeft:setHandle(handler(self, self.queryPlayerInfo))
	self.nodeMemberRight = SoraDGetExtendChildFromCCSByName(self, "CCS_teamInfoSingle_right")
	self.nodeMemberRight:setScroll(self.scroll)
	self.nodeMemberRight:setHandle(handler(self, self.queryPlayerInfo))
	self.btnRewardChoose = SoraDGetChildByName(self, "Button_reward")
	self.btnRewardChoose:setTitleText(i18n("common_text_1235"))
	self.btnRewardChoose:addTouchEventListener(handler(self, self.btnRewardClickCallBack))
	self.btnQuitChoose = SoraDGetChildByName(self, "Button_quit")
	self.btnQuitChoose:setTitleText(i18n("common_text_3351"))
	self.btnQuitChoose:addTouchEventListener(handler(self, self.btnQuitClickCallBack))
	local isXianXia = remainsWarUtil.checkIsInRemainsXianXia()
	local enable = not isXianXia and worldMapDefine.isInRemains()
	self.btnQuitChoose:setBright(enable)
	self.btnQuitChoose:setTouchEnabled(enable)
	self:initView()
end
function teamInfoView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_TEAM_INFO_POINT_DATA", handler(self, self.initData))
end
function teamInfoView:initView()
	self:req4Data()
end
function teamInfoView:req4Data()
	local mapId = worldMapDefine.currentMapKindomID or gametop.playertop_:getMapID()
	remainsWarCtrl:reqRemainsWarPlayerPointsList(mapId)
	SoraDShowLoading(self)
end
function teamInfoView:initData(target, data)
	SoraDCloseLoading(self)
	if not data or not data.playerPointsList then
		_ENV = data.playerPointsList
	end
	self.tableSingleData = data.playerPointsList
	if not self.tableSingleData[RW_CAMP.SOUTH_KEY] then
		local _ENV, southData = self.tableSingleData[RW_CAMP.SOUTH_KEY], self.tableSingleData[RW_CAMP.SOUTH_KEY]
	end
	if not self.tableSingleData[RW_CAMP.NORTH_KEY] then
		local _ENV, northData = self.tableSingleData[RW_CAMP.NORTH_KEY], self.tableSingleData[RW_CAMP.NORTH_KEY]
	end
	self.southData = southData
	self.northData = northData
	self:updateScrollList()
end
function teamInfoView:updateScrollList()
	if not self.southData then
		local _ENV, data_left = self.southData, self.southData
	end
	if not self.northData then
		local _ENV, data_right = self.northData, self.northData
	end
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
function teamInfoView:btnQuitClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local err = remainsWarUtil.checkQutiBattleField()
		if gErrDef.Err_None == err then
			local showMsg = i18n("remains_text_75")
			SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					remainsTeamCtrl:reqQuitBattlefield()
					SoraDShowLoading(self, nil, nil, nil, 5)
				end
			end)
		else
			self:errHandle(err)
		end
	end
end
function teamInfoView:btnRewardClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("remainsWarReward")
		panel:show()
	end
end
function teamInfoView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = remainsWarUtil.getErrType(err)
	if errType == remainsWarUtil.errType.TIPS then
		if err == gErrDef.Err_RUINS_WAR_HAS_MASS_QUEUE then
			SoraDShowMsgTip(i18n("remains_text_76"))
		else
			remainsWarUtil.errShowTips(err)
		end
	elseif errType == remainsWarUtil.errType.CLOSE then
		remainsWarUtil.errShowTips(err)
		self:removeFromParent()
	end
end
function teamInfoView:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		local kid = data.fromKid
		self._queryInfo = true
		local selfPlayerID = gametop.playertop_:getPlayerID() or 0
		if selfPlayerID == data.uid then
			self._queryInfo = false
			SoraDOpenLordView(lordInfoCtrl:getLordInfo())
			return
		end
		local chatConst = include("chatConst")
		lordInfoCtrl = "chatConst"
		;("chatConst")[1] = chatConst.OpId.OpViewInfo
		local ("chatConst")[2], menuData = chatConst.OpId.OpSendEmail, "chatConst"
		local __, camp1 = self:getPlayerData(selfPlayerID)
		local player2, camp2 = self:getPlayerData(data.uid)
		if camp1 and camp1 == camp2 then
			table.insert(menuData, chatConst.OpId.OpRemainsReport)
		end
		gametop = lordInfoCtrl:getLordInfo()
		lordInfoCtrl:getLordInfo().playerId = data.uid
		lordInfoCtrl:getLordInfo().nickName = data.nickName
		lordInfoCtrl:getLordInfo().allianceAbbr = data.allianceAbb
		lordInfoCtrl:getLordInfo().kid = data.fromKid
		local panel = SoraDShowPlayerOperatePanel(data.nickName, menuData, lordInfoCtrl:getLordInfo())
		local hasReport = false
		if not player2.reporters then
			gametop = player2.reporters
		end
		for i, v in ipairs(player2.reporters) do
			if v == selfPlayerID then
				hasReport = true
				break
			end
		end
		if hasReport then
			local btn = panel:getBtnByTag(chatConst.OpId.OpRemainsReport)
			if btn then
				btn:setTouchEnabled(false)
				btn:setBright(false)
				if btn.setTitleText then
					btn:setTitleText(i18n("common_text_4150"))
				else
					btn:setTitle(i18n("common_text_4150"))
				end
			end
		end
	end
end
function teamInfoView:getPlayerData(uid)
	if not self.southData then
		_ENV = self.southData
	end
	for i, v in ipairs(self.southData) do
		if v.uid == uid then
			return v, _G.RW_CAMP.SOUTH
		end
	end
	if not self.northData then
		_ENV = self.northData
	end
	for i, v in ipairs(self.northData) do
		if v.uid == uid then
			return v, _G.RW_CAMP.NORTH
		end
	end
end
function teamInfoView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function teamInfoView:requestLordData(target, data)
	SoraDShowLoading(self)
	local playerID = data.playerID
	local kid = data.kid or gametop.playertop_:getKingdomID()
	_ENV = nil
	;(nil).targetName = self.__cname
	lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
end
return teamInfoView
