local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLHonorGroupInfoView = class("alliancePBLHonorGroupInfoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLHonorGroupInfoView")
	end
	return target
end)
function alliancePBLHonorGroupInfoView:ctor()
	self.top3, _ENV = nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	self.nodeTitle:setTitle(i18n("pyramid_title_14"))
	SoraDGetChildByName(self, "Button_help"):setVisible(false)
	self.imgBg = SoraDGetChildByName(self, "Image_bigBg")
	self.imgBg:setScale(math.max(1, display.height / self.imgBg:getContentSize().height))
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.btnGroupInfo = SoraDGetChildByName(self, "Button_groupInfo")
	self.btnGroupInfo:setTouchEnabled(false)
	self.btnGroupInfo:setBright(true)
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.labelName = SoraDGetChildByName(self.topNode, "Text_name")
	self.labelTitle = SoraDGetChildByName(self.topNode, "Text_title")
	self.nodeRound = SoraDGetChildByName(self, "Node_round")
	self.nodeRound.btnRound = SoraDGetChildByName(self, "Button_round")
	self.nodeRound.btnRound:setTouchEnabled(false)
	self.nodeRound.btnRound:setBright(true)
	self.nodeRound.bflRound = SoraDGetChildByName(self, "BitmapFontLabel_round")
	self.nodeRound.spriteS = SoraDGetChildByName(self, "Sprite_S")
	self.nodeEditBox = SoraDGetChildByName(self, "Node_editbox")
	self.labelTitle1 = SoraDGetChildByName(self, "Text_title_1")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.btnEdit = SoraDGetChildByName(self, "Button_edit")
	self.tfdSlogan = SoraDGetChildByName(self, "TextField_edit")
	_ENV = "TextField_edit"
	;("TextField_edit").func = handler(self, self.OnInputNotice)
	self.tfdSlogan = SoraDChangeToEditBox(self.tfdSlogan, "TextField_edit")
	self.tfdSlogan:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdSlogan:setFontSize(20)
	self.tfdSlogan:setPlaceHolder("")
	self.tfdSlogan:setFontColor(self.labelDes:getColor())
	self.tfdSlogan:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	self.labelTitle2 = SoraDGetChildByName(self, "Text_title_2")
	self.btnAll = SoraDGetChildByName(self, "Button_all")
	self.top3[1] = SoraDGetChildByName(self, "Node_clone_1")
	self.top3[2] = SoraDGetChildByName(self, "Node_clone_2")
	self.top3[3] = SoraDGetChildByName(self, "Node_clone_3")
	self.labelTitle1:setString(i18n("pyramid_text_98"))
	self.labelTitle2:setString(i18n("pyramid_text_112"))
	self.btnEdit:setTitleText(i18n("common_text_244"))
	self.btnAll:setTitleText(i18n("pyramid_text_113"))
	self.btnEdit:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnAll:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDCreatAnimationEx(self.__cname, self, true)
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	if display.height < 1125 then
		local scale1 = (display.height - 260 - 75) / 650
		local scale = (display.height - 650 * scale1 - 75) / 400
		self.nodeBottom:setScale(scale1)
		self.nodeEditBox:setScale(1 / scale1)
		self.topNode:setScale(scale)
		self.topNode:setPositionY(scale * 180 + 650 * scale1)
	else
		local scale = math.min((display.height - 650 - 75) / 400, 1.5)
		self.topNode:setScale(scale)
		self.topNode:setPositionY(0.5 * (display.height - 650 - 75) + 650)
	end
	SoraDAutoSizeButtonText(self.btnAll)
end
function alliancePBLHonorGroupInfoView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_HONOR_EDIT_BACK", function(target, data)
		if data.err ~= gErrDef.Err_None then
			pyramidWarCtrl:newGloryRankReq(self.rankType, self.season)
		else
			self:initData(self.curData, self.pinnacleRank, self.season, self.rankType, self.index)
		end
		SoraDCloseLoading(self)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_GET_RANK_BACK", function(target, data)
		if self.rankType == gGloryRankTypeDef.ADVANCE_16_LEGION then
			local allData = pyramidWarCtrl:getPBLHistoryTop16Group(self.season)
			self.curData = allData[self.index]
		else
			local allData = pyramidWarCtrl:getPBLHistoryRank(self.rankType, self.season)
			self.curData = allData[self.index]
		end
		self:initData(self.curData, self.pinnacleRank, self.season, self.rankType, self.index)
		SoraDCloseLoading(self)
	end)
end
function alliancePBLHonorGroupInfoView:initData(data, pinnacleRank, season, fromRankType, index)
	self.curData = data
	self.index = index
	self.pinnacleRank = pinnacleRank
	self.season = season
	self.rankType = fromRankType
	if self.curData == nil then
		return
	end
	_ENV = nil
	;(nil).num = self.pinnacleRank
	self.labelTitle:setString(i18n("pyramid_title_10", nil))
	_ENV = i18n("pyramid_title_10", nil)
	i18n("pyramid_title_10", nil).abbr = self.curData.abbr
	i18n("pyramid_title_10", nil).name = self.curData.legionName
	self.labelName:setString(i18n("common_text_186", i18n("pyramid_title_10", nil)) .. "#" .. tostring(self.curData.kid))
	allianceDesRead.getFlagWithParticle(self.curData.flag, self.nodeFlag)
	local selfContent = pyramidWarCtrl:checkContent(self.curData, self.season)
	if selfContent then
		self.labelDes:setString(selfContent)
		self.tfdSlogan:setVisible(false)
		self.labelDes:setVisible(true)
		self.btnEdit:setVisible(false)
	else
		self.labelDes:setString(i18n("pyramid_text_99"))
		self:checkRank()
	end
	self:updateSeasonIcon(self.nodeRound, self.season)
	local _ENV, members = self.updateSeasonIcon, self.updateSeasonIcon
	if not self.curData.top3Member then
		local _ENV, top3Member = self.curData.top3Member, self.curData.top3Member
	end
	for k, v in pairs(top3Member) do
		members[v.rank] = v
	end
	for i, v in ipairs(self.top3) do
		if members[i] then
			v:setVisible(true)
			SoraDGetChildByName(v, "Text_name"):setString(members[i].nickName)
			local head = SoraDGetExtendChildFromCCSByName(v, "CCS_commonHead_head")
			head:setHeadSprite(members[i].iconID, members[i].avatar)
			head:setPlayerID(members[i].uid)
			head:setTouchEnabled(true)
		else
			v:setVisible(false)
		end
	end
end
function alliancePBLHonorGroupInfoView:checkRank()
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local legion = pyramidWarCtrl:getOwnLegion()
	if (legion and legion.captainID == include("chatFunctions"):getSelfId() and legion.legionId == self.curData.legionId or ownRank == gAllianceRank.R5 and ownmember:getProperty("aid") == self.curData.aid) and (self.curData.editNum == nil or self.curData.editNum <= 0) then
		self.btnEdit:setVisible(true)
		self:changeBtn(true)
	else
		self.btnEdit:setVisible(false)
		self.tfdSlogan:setVisible(false)
		self.labelDes:setVisible(true)
	end
end
function alliancePBLHonorGroupInfoView:updateSeasonIcon(single, season)
	if 10 <= season then
		single.spriteS:setPositionX(-18.0)
		single.spriteS:setScale(0.69)
		single.bflRound:setPositionX(-5.8)
		single.bflRound:setScale(0.27)
	else
		single.spriteS:setPositionX(-16)
		single.spriteS:setScale(0.9)
		single.bflRound:setPositionX(1.2)
		single.bflRound:setScale(0.34)
	end
	single.bflRound:setString(season)
end
function alliancePBLHonorGroupInfoView:changeBtn(canEdit)
	self.btnEdit:setTouchEnabled(canEdit)
	self.btnEdit:setBright(canEdit)
	self.tfdSlogan:setVisible(not canEdit)
	self.labelDes:setVisible(canEdit)
	if canEdit then
		self.btnEdit:setTag(1)
		self.btnEdit:setTitleText(i18n("common_text_244"))
	else
		self.btnEdit:setTag(2)
		self.btnEdit:setTitleText(i18n("common_text_3628"))
	end
end
function alliancePBLHonorGroupInfoView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnEdit then
			if button:getTag() == 1 then
				self:changeBtn(false)
				self.tfdSlogan:setString("")
				self.tfdSlogan:closeIME()
				self:OnEditBoxTouch(self.tfdSlogan, ccui.TouchEventType.ended)
			else
				SoraDShowMsgBox(i18n("pyramid_text_100"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						self:changeBtn(true)
						self.labelDes:setString(self.tfdSlogan:getString())
						button:setVisible(false)
						pyramidWarCtrl:setLegionContentReq(self.season, self.tfdSlogan:getString(), self.curData.legionId)
						SoraDShowLoading(self)
					end
				end)
			end
		elseif self.curData ~= nil then
			local panel = SoraDCreatePanel("alliancePBLHonorMemberListView")
			panel:initData(self.season, self.curData.legionId, self.curData.kid)
			panel:show()
		end
	end
end
function alliancePBLHonorGroupInfoView:OnInputNotice(eventType, textField)
	if eventType == "began" then
	elseif eventType == "changed" then
	elseif eventType == "ended" then
	elseif eventType == "return" then
	end
	local str = textField:getString()
	self.btnEdit:setTouchEnabled(str ~= "")
	self.btnEdit:setBright(str ~= "")
end
function alliancePBLHonorGroupInfoView:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		target:touchDownAction(target, type)
	end
end
return alliancePBLHonorGroupInfoView
