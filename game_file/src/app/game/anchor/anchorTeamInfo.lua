local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local anchorCtrl = gametop.playertop_:getModule("anchorCtrl")
local remainsWarUtil = include("remainsWarUtil")
local RW_CAMP = _G.RW_CAMP
local anchorTeamInfo = class("anchorTeamInfo", function(target)
	if target == nil then
		return SoraDCreateBasePanel("anchorTeamInfo")
	end
	return target
end)
function anchorTeamInfo:ctor()
	self.isHideCurrentSceneView = true
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Image_event:loadTexture(SoraDCheckPNG("bg_activity_9001104.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("remains_title_05"))
	self.nodeScore = SoraDGetExtendChildFromCCSByName(self, "CCS_anchorSearchBase_title")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.nodeMemberLeft = SoraDGetExtendChildFromCCSByName(self, "CCS_anchorTeamInfoSingle_left")
	self.nodeMemberLeft:setScroll(self.scroll)
	self.nodeMemberLeft:setHandle(handler(self, self.queryPlayerInfo))
	self.nodeMemberRight = SoraDGetExtendChildFromCCSByName(self, "CCS_anchorTeamInfoSingle_right")
	self.nodeMemberRight:setScroll(self.scroll)
	self.nodeMemberRight:setHandle(handler(self, self.queryPlayerInfo))
	self.nodeAnchor = SoraDGetChildByName(self, "Node_anchor")
	self.nodeTeamOp = SoraDGetChildByName(self, "Node_team_operator")
	self.nodeTeamBg = SoraDGetChildByName(self, "Node_team_bg")
	self.btnRewardChoose = SoraDGetChildByName(self, "Button_reward")
	self.btnRewardChoose:addTouchEventListener(handler(self, self.btnRewardClickCallBack))
	self.btnRewardChoose:setTitleText(i18n("common_text_1235"))
	self.btnRefresh = SoraDGetChildByName(self, "Button_refresh")
	self.btnRefresh:addTouchEventListener(handler(self, self.btnRefreshClickCallBack))
	self.btnRefresh:setTitleText(i18n("common_text_911"))
	self.btnView = SoraDGetChildByName(self, "Button_view")
	self.btnView:addTouchEventListener(handler(self, self.btnViewClickCallBack))
	self.btnView:setTitleText(i18n("Anchor_btn_09"))
	self.txtInfoTitle = SoraDGetChildByName(self, "Text_info_title")
	self.txtInfoTitle:setString(i18n("Anchor_text_13"))
	self.nodeStatus = SoraDGetChildByName(self, "Node_Status")
	self.labelStatus = SoraDGetChildByName(self, "Text_status")
	self.labelStatus:setString(i18n("common_text_685"))
	self.checkBoxStatus = SoraDGetChildByName(self, "CheckBox_status")
	self.checkBoxStatus:ignoreContentAdaptWithSize(true)
	self.checkBoxStatus:addEventListener(handler(self, self.btnCheckClickCallBack))
	self:addFireEffect()
end
function anchorTeamInfo:addFireEffect()
	self.fireLeft = SoraDGetChildByName(self, "Sprite_fire_left")
	self.fireRight = SoraDGetChildByName(self, "Sprite_fire_right")
	local nodeFireL = _G.SoraDGetCommonJetFireNode(true)
	nodeFireL:setPosition(10, 55)
	nodeFireL:addTo(self.fireLeft)
	local nodeFireR = _G.SoraDGetCommonJetFireNode(true)
	nodeFireR:setPosition(10, 55)
	nodeFireR:addTo(self.fireRight)
	for i = 7, 9 do
		local particle = SoraDGetChildByName(self, "Particle_" .. i)
		if particle then
			particle:setAutoCull(false)
		end
	end
end
function anchorTeamInfo:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_TEAM_INFO_POINT_DATA", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_ANCHOR_SELECT_MAP", handler(self, self.selectWatchMap))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function anchorTeamInfo:initView(data)
	self.isWarStatue = false
	self.nodeScore:initInfoData(true, data)
	self.nodeAnchor:setVisible(true)
	self.nodeTeamOp:setVisible(false)
	self.nodeTeamBg:setVisible(true)
	self.nodeStatus:setVisible(false)
	self.mapId = data.mapId
	self:req4Data()
end
function anchorTeamInfo:initViewWar()
	self.isWarStatue = true
	self.mapId = worldMapDefine.currentMapKindomID or gametop.playertop_:getMapID()
	self.nodeScore:initInfoData(false)
	self.nodeAnchor:setVisible(false)
	self.nodeTeamOp:setVisible(true)
	self.nodeTeamBg:setVisible(false)
	self.nodeStatus:setVisible(true)
	_ENV = true
	;(true).byUID = true
	local showStatus = SoraDConfigGet("Game:anchorTeamInfo:checkBoxStatus~bool", true)
	self.checkBoxStatus:setSelected(showStatus)
	self.nodeMemberLeft:setShowStatus(showStatus)
	self.nodeMemberRight:setShowStatus(showStatus)
	self.nodeMemberLeft:setIsWar(true)
	self.nodeMemberRight:setIsWar(true)
	self:req4Data()
end
function anchorTeamInfo:req4Data()
	anchorCtrl:reqAnchorRwPlayerPointsList(self.mapId, self.isWarStatue)
	SoraDShowLoading(self)
end
function anchorTeamInfo:initData(target, data)
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
function anchorTeamInfo:updateScrollList()
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
function anchorTeamInfo:btnQuitClickCallBack(button, type)
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
function anchorTeamInfo:btnRewardClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("remainsWarReward")
		panel:show()
	end
end
function anchorTeamInfo:btnRefreshClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:req4Data()
	end
end
function anchorTeamInfo:btnViewClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local anchorUtil = include("anchorUtil")
		local err = anchorUtil.checkCanSwitchToAnchor()
		local errType = anchorUtil.errType
		if err == errType.ANCHOR_STATUS then
			SoraDShowMsgTip(i18n("Anchor_text_01"))
		elseif err == errType.ACTIVITY then
			SoraDShowMsgTip(i18n("Anchor_text_02"))
		elseif err == errType.NONE then
			local showMsg = i18n("Anchor_text_08")
			SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					local mapID = self.mapId
					if mapID and 0 < mapID then
						SoraDShowLoading(self)
						anchorCtrl:reqRemainsWarData(mapID)
					end
				end
			end)
		end
	end
end
function anchorTeamInfo:errHandle(err)
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
function anchorTeamInfo:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		local kid = data.fromKid
		self._queryInfo = true
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading(self)
	end
end
function anchorTeamInfo:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function anchorTeamInfo:btnCheckClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected or type == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		local showStatus = self.checkBoxStatus:isSelected()
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:anchorTeamInfo:checkBoxStatus~bool", showStatus, nil)
		self.nodeMemberLeft:setShowStatus(showStatus)
		self.nodeMemberRight:setShowStatus(showStatus)
	end
end
function anchorTeamInfo:selectWatchMap(target, data)
	SoraDCloseLoading(self)
	if data.warStatus and data.warStatus == gKingdomWarStatusType.inWar then
		local anchorUtil = include("anchorUtil")
		anchorUtil.selectWatchMap(self.mapId)
	else
		SoraDShowMsgTip(i18n("common_text_4309"))
	end
end
return anchorTeamInfo
