local gametop = gModuleMgr.getObject("gametop")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local lordSpineDef = include("lordSpineDef")
local AllianceMemberSetting = class("allianceMemberSetting", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMemberSetting")
	end
	return target
end)
function AllianceMemberSetting:ctor()
	self.isHidePrePanel = false
	self:setBackGround(204.0)
	self.tableSingleData, _ENV = self.setBackGround, self.setBackGround
	self.isOwnAlliance = nil
	self.tableBtnRightSingle, _ENV, self.tableBtnLeftSingle, _ENV, self.official = gAllianceOfficial.NONE, gAllianceOfficial.NONE, gAllianceOfficial.NONE, gAllianceOfficial.NONE, gAllianceOfficial.NONE
	self.tableBtnLeftSingle = SoraDGetChildsArrayByName(self, "CCS_allianceSettingIcon_left_", 4, 1, false, true)
	self.tableBtnRightSingle = SoraDGetChildsArrayByName(self, "CCS_allianceSettingIcon_right_", 4, 1, false, true)
	self.tableBtnMiddleSingle = SoraDGetExtendChildFromCCSByName(self, "CCS_allianceKingSettingIcon_middle")
	self.tableBtnMiddleSingle:setVisible(false)
	self.spriteTitle = SoraDGetChildByName(self, "Sprite_title")
	self.spriteBust = SoraDGetChildByName(self, "Sprite_portrait")
	self.lableName = SoraDGetChildByName(self, "Text_name")
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.Node_officialName = SoraDGetChildByName(self, "Node_officialName")
	self.Node_officialName:setVisible(false)
	self.Text_officialName = SoraDGetChildByName(self, "Text_officialName")
	self.nodeTouch:setTouchEnabled(false)
	self:addTouchEventListener(handler(self, self.layerClickCallBack))
end
function AllianceMemberSetting:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_FIRE_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_APPOINT_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_SETTING_CLOSE", function(target, data)
		if data.uid == self.tableSingleData:getProperty("uid") then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", function(target, data)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
end
function AllianceMemberSetting:initData(singleData, isOwnAlliance)
	self.isOwnAlliance = isOwnAlliance
	self.tableSingleData = singleData
	self.official = self.tableSingleData:getProperty("official") or gAllianceOfficial.NONE
	self.rank = self.tableSingleData:getProperty("rank")
	self:initView()
end
function AllianceMemberSetting:initView()
	local allianceDesRead = include("allianceDesRead")
	if self.official >= gAllianceOfficial.COMMANDER and self.official <= gAllianceOfficial.RECRUITER then
		self.spriteTitle:setVisible(false)
		self.Node_officialName:setVisible(true)
		self.Text_officialName:setString(allianceDesRead.getOfficialName(self.official))
	else
		self.spriteTitle:setVisible(true)
		self.Node_officialName:setVisible(false)
		self.spriteTitle:setSpriteFrame(allianceDesRead.getCrown(self.tableSingleData:getProperty("rank")))
	end
	self:refreshLordSpine(self.tableSingleData:getProperty("iconID"))
	self.lableName:setString(self.tableSingleData:getProperty("nickName"))
	self:initMenu()
end
function AllianceMemberSetting:refreshLordSpine(iconID)
	local info = lordSpineDef.getLordSpineInfo(iconID)
	if info then
		if self.spine then
			self.spine:removeFromParent()
			self.spine = nil
		end
		self.spriteBust:setVisible(false)
		self.spine = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
		local offset = info.offset or cc.p(0, 0)
		self.spine:setPosition(cc.p(210 + offset.x, offset.y))
		self.spine:setAnimation(0, "animation", true)
		self.spine:addTo(self.nodeTouch, 9)
	else
		self.spriteBust:setVisible(true)
		local lordLocalData = include("lordLocalData")
		self.spriteBust:setSpriteFrame(lordLocalData.getPortrait(iconID))
	end
end
function AllianceMemberSetting:updateData()
	self.tableSingleData = memberMgr:getMember(self.tableSingleData:getProperty("uid"))
	if self.tableSingleData == nil then
		self:closePanel()
		return
	end
	local rank = self.tableSingleData:getProperty("rank")
	if rank > self.rank then
		self:addUpRankEffect()
	elseif rank < self.rank then
		self:addDownRankEffect()
	end
	self.official = self.tableSingleData:getProperty("official") or gAllianceOfficial.NONE
	self.rank = rank
	self:initView()
end
function AllianceMemberSetting:initMenu()
	;(nil).left, memberMgr, (nil).right, memberMgr, (nil).right, memberMgr, (nil).left, memberMgr, memberMgr = nil, nil, nil, nil, nil, nil, nil, nil, nil
	local menuList
	if self.isOwnAlliance then
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		local ownMapId = ownmember:getProperty("mapId")
		if ownMapId and self.tableSingleData:getProperty("mapId") == nil then
			menuList.right[1] = gAPermission.MAIL_ALL
		else
			local rank = self.tableSingleData:getProperty("rank")
			local rfKid = self.tableSingleData:getProperty("rfKid")
			if self.tableSingleData:getProperty("uid") ~= lordInfoCtrl:getLordInfo().base.uid then
				if rank == gAllianceRank.R0 then
					menuList = permissionCtrl:getNewMemberMenu()
				else
					menuList = permissionCtrl:getMemberMenu(rank, rfKid)
				end
			end
			if ownRank == gAllianceRank.R5 and KWKingdomCtrl:isProxyKing() then
				self.tableBtnMiddleSingle:initData(gAPermission.APPOINT_KING, self.tableSingleData)
				self.tableBtnMiddleSingle:setVisible(true)
			else
				self.tableBtnMiddleSingle:setVisible(false)
			end
		end
	else
		menuList.right[1] = gAPermission.MAIL_ALL
	end
	self:refreshMenuBtn(menuList)
end
function AllianceMemberSetting:refreshMenuBtn(menuList)
	for i, v in ipairs(self.tableBtnLeftSingle) do
		if menuList.right[i] then
			v:setVisible(true)
			v:initData(menuList.right[i], self.tableSingleData)
		else
			v:setVisible(false)
		end
	end
	for i, v in ipairs(self.tableBtnRightSingle) do
		if menuList.left[i] then
			v:setVisible(true)
			v:initData(menuList.left[i], self.tableSingleData)
		else
			v:setVisible(false)
		end
	end
end
function AllianceMemberSetting:layerClickCallBack(layer, type)
	if type == ccui.TouchEventType.ended then
		local touchEndPoint = layer:getTouchEndPosition()
		local touchRect = self.nodeTouch:getBoundingBox()
		local touchPanelPoint = self.nodeTouch:getParent():convertToWorldSpace(cc.p(touchRect.x, touchRect.y))
		touchRect.x = touchPanelPoint.x
		touchRect.y = touchPanelPoint.y
		if not cc.rectContainsPoint(touchRect, touchEndPoint) then
			self:close(panel, type)
		else
			SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
			local playerID = self.tableSingleData:getProperty("uid")
			local kid = gametop.playertop_:getKingdomID()
			_ENV = handler(self, self.serverMessageGetLordInfo)
			handler(self, self.serverMessageGetLordInfo).targetName = self.__cname
			local playerData = lordInfoCtrl:getLordInfoByUid(playerID, kid, handler(self, self.serverMessageGetLordInfo))
		end
	end
end
function AllianceMemberSetting:serverMessageGetLordInfo(target, data)
	if data.clientData then
		local targetName = data.clientData.targetName
		if targetName == self.__cname and data.lord then
			SoraDOpenLordView(data.lord)
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
		end
	end
end
function AllianceMemberSetting:addUpRankEffect(...)
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_alliance_step_promote_01.plist"
	;(nil).x = 331.94
	_ENV, (nil)[1], (nil).pos, (nil).y = nil, nil, nil, 443.14
	_ENV, (nil).plist = nil, "et_alliance_step_promote_02.plist"
	;(nil).x = 288.11
	_ENV, (nil)[2], (nil).pos, (nil).y = nil, nil, nil, 868.87
	_ENV, (nil).plist = nil, "et_alliance_step_promote_02.plist"
	;(nil).x = 134.79
	_ENV, (nil)[3], (nil).pos, (nil).y = nil, nil, nil, 615.34
	_ENV, (nil).plist = nil, "et_alliance_step_promote_02.plist"
	;(nil).x = 448.29
	;(nil)[4], (nil).pos, (nil).y = nil, nil, 713.55
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:addTo(self, 2)
end
function AllianceMemberSetting:addDownRankEffect(...)
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_alliance_step_reduce_01.plist"
	;(nil).x = 329.18
	_ENV, (nil).pos, (nil).y = nil, nil, 565.27
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_alliance_step_reduce_02.plist"
	;(nil).x = 330.41
	;(nil)[2], (nil).pos, (nil).y = nil, nil, 596.19
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:addTo(self, 2)
end
return AllianceMemberSetting
