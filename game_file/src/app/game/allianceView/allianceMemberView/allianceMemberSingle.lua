_ENV = nil
;(nil).gift_package = 1
;(nil).legend_official = 2
;(nil).hegemon_official = 3
;(nil).present = 4
;(nil).atlantis_official = 5
;(nil).nebula_official = 6
;(nil).kingStar_official = 7
local (nil).nebulaEmperor_official, SHOW_STATUS_TYPE = 8, nil
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local AllianceMemberSingle = class("allianceMemberSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMemberSingle")
	end
	return target
end)
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function AllianceMemberSingle:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.aid = nil
	self.isAbbr = false
	self.rank = nil
	self.isOwnAlliance = nil
	self.handle = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.singleOffIsMoved = false
	self.singleAppIsMoved = false
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgFlg = SoraDGetChildByName(self, "Image_flg")
	self.spriteCrown = SoraDGetChildByName(self, "Sprite_crown")
	self.imgPortrait = SoraDGetChildByName(self, "Image_portrait")
	self.spriteCastle = SoraDGetChildByName(self, "Sprite_castle")
	self.labelState = SoraDGetChildByName(self, "Text_state")
	self.labelState:setVisible(false)
	self.labelOnline = SoraDGetChildByName(self, "Text_online")
	self.labelOnline:setString(i18n("common_text_224"))
	self.labelLastTime = SoraDGetChildByName(self, "Text_lastTime")
	self.labelCastleLv = SoraDGetChildByName(self, "Text_castleLv")
	self.labelPowerTitle = SoraDGetChildByName(self, "Text_powerLab")
	self.labelPowerTitle:setString(i18n("common_text_090"))
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	SoraDSetTextWidthHeight(self.labelName, cc.size(180, 24))
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeTouch:setSwallowTouches(false)
	self.Panel_bg = SoraDGetChildByName(self, "Panel_bg")
	self.Panel_bg:setSwallowTouches(false)
	self.nodeStatus = SoraDGetChildByName(self, "node_status")
	self.lbl_status = SoraDGetChildByName(self.nodeStatus, "lbl_status")
	if self.nodeTouch then
		self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.Image_official = SoraDGetChildByName(self, "Image_official")
	self.Image_official:setVisible(false)
	self.Node_have = SoraDGetChildByName(self, "Node_have")
	self.Node_none = SoraDGetChildByName(self, "Node_none")
	self.Node_none:setVisible(false)
	self.Node_officialName = SoraDGetChildByName(self, "Node_officialName")
	self.Node_officialName:setVisible(false)
	self:initBuildStarLvUI()
end
function AllianceMemberSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceMemberSingle:setHandle(handle)
	self.handle = handle
end
function AllianceMemberSingle:initData(rank, singleData, aid, otherData)
	self.tableSingleData = singleData
	dump(self.tableSingleData, "tableSingleData")
	self.aid = aid
	self.rank = rank
	self.otherData = otherData
	self:unDark()
	self.nodeStatus:setVisible(false)
	if self.aid == nil or self.aid == 0 then
		self:showNoAllianceMember()
	else
		self:setOfficial()
	end
	self:showAbbr(self.isAbbr)
end
function AllianceMemberSingle:setOfficial()
	self.isOwnAlliance = allianceMgr:hasJoinAlliance() and allianceMgr:getOwnAid() == self.aid
	self.nodeTouch:setTouchEnabled(true)
	self.nodeTouch:setSwallowTouches(false)
	if self.rank == gAllianceRank.OFFICIAL then
		self:setGeneralOfficial()
		if self.tableSingleData.minfo.uid > 0 then
			self:showPublic()
			self:setHaveOfficial()
		else
			self:setNoneOfficial()
		end
	else
		self.Node_have:setVisible(true)
		self.Image_official:setVisible(false)
		self.Node_none:setVisible(false)
		self.Node_officialName:setVisible(false)
		self:showPublic()
	end
	if self.isOwnAlliance then
		self:showOwnAlliance()
	elseif self.aid then
		self:showOtherAlliance()
	end
end
function AllianceMemberSingle:setGeneralOfficial()
	self.Image_official:setVisible(true)
	self.Node_officialName:setVisible(true)
	self.spriteCrown:setVisible(false)
	local official = self.tableSingleData.minfo.official
	local img = allianceDesRead.getOfficialBg(official)
	local name = allianceDesRead.getOfficialName(official)
	local Button_official = SoraDGetChildByName(self.Node_officialName, "Button_official")
	Button_official:setSwallowTouches(false)
	if img and name then
		self.Image_official:loadTexture(img, ccui.TextureResType.plistType)
		local Text_officialName = SoraDGetChildByName(self.Node_officialName, "Text_officialName")
		Text_officialName:setString(name)
		Button_official:addTouchEventListener(function(button, event)
			if event == ccui.TouchEventType.ended then
				if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
					print("node is not on view")
					return
				end
				if self.singleOffIsMoved then
					self.singleOffIsMoved = false
					return
				end
				SoraDPlaySound()
				SoraDShowHelpMsgTip(allianceDesRead.getOfficialDes(official))
			elseif event == ccui.TouchEventType.moved then
				local touchBeganPoint = button:getTouchBeganPosition()
				local touchmovePoint = button:getTouchMovePosition()
				local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
				if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
					self.singleOffIsMoved = true
				end
			elseif event == ccui.TouchEventType.canceled then
				self.singleOffIsMoved = false
			end
		end)
	end
end
function AllianceMemberSingle:setHaveOfficial()
	self.spriteCrown:setVisible(false)
	self.Node_have:setVisible(true)
	self.Node_none:setVisible(false)
end
function AllianceMemberSingle:setNoneOfficial()
	self.spriteCrown:setVisible(false)
	self.nodeTouch:setTouchEnabled(false)
	self.nodeTouch:setSwallowTouches(false)
	self.Node_have:setVisible(false)
	self.Node_none:setVisible(true)
	local Text_none = SoraDGetChildByName(self.Node_none, "Text_none")
	Text_none:setString(i18n("alliance_office_text_15"))
	local Button_apply = SoraDGetChildByName(self.Node_none, "Button_apply")
	Button_apply:setSwallowTouches(false)
	local Text_applyed = SoraDGetChildByName(self.Node_none, "Text_applyed")
	local official = self.tableSingleData.minfo.official
	if self.isOwnAlliance then
		local isLeader = allianceMgr:isLeader()
		if isLeader then
			Button_apply:setVisible(true)
			Button_apply:setBright(not worldMapDefine.isInWarForbid(true))
			Text_applyed:setVisible(false)
			Button_apply:setTitleText(i18n("common_text_687"))
			Button_apply:addTouchEventListener(function(button, event)
				if event == ccui.TouchEventType.ended then
					if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
						print("node is not on view")
						return
					end
					if self.singleAppIsMoved then
						self.singleAppIsMoved = false
						return
					end
					if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
						return
					end
					if worldMapDefine.isInWarForbid() then
						return
					end
					SoraDPlaySound()
					local panel = SoraDCreatePanel("allianceOfficialAppointView")
					panel:show()
					panel:initOfficial(official)
				elseif event == ccui.TouchEventType.moved then
					local touchBeganPoint = button:getTouchBeganPosition()
					local touchmovePoint = button:getTouchMovePosition()
					local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
					if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
						self.singleAppIsMoved = true
					end
				elseif event == ccui.TouchEventType.canceled then
					self.singleAppIsMoved = false
				end
			end)
		else
			local isApplyedOfficial = memberMgr:isApplyedOfficial(official)
			local isOwnOfficial = memberMgr:isOwnOfficial()
			Text_applyed:setVisible(isApplyedOfficial)
			if isApplyedOfficial then
				Button_apply:setVisible(false)
				Text_applyed:setVisible(true)
				Text_applyed:setString(i18n("alliance_office_btn_02"))
			elseif isOwnOfficial then
				Button_apply:setVisible(false)
			else
				Button_apply:setVisible(true)
				Button_apply:setBright(not worldMapDefine.isInWarForbid(true))
				Button_apply:setTitleText(i18n("common_text_182"))
				Button_apply:addTouchEventListener(function(button, event)
					if event == ccui.TouchEventType.ended then
						if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
							print("node is not on view")
							return
						end
						if self.singleAppIsMoved then
							self.singleAppIsMoved = false
							return
						end
						SoraDPlaySound()
						if worldMapDefine.isInWarForbid() then
							return
						end
						local official = self.tableSingleData.minfo.official
						allianceMgr:reqApplyAllianceOfficial(official)
						SoraDShowLoading()
					elseif event == ccui.TouchEventType.moved then
						local touchBeganPoint = button:getTouchBeganPosition()
						local touchmovePoint = button:getTouchMovePosition()
						local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
						if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
							self.singleAppIsMoved = true
						end
					elseif event == ccui.TouchEventType.canceled then
						self.singleAppIsMoved = false
					end
				end)
			end
		end
	elseif self.aid then
		Button_apply:setVisible(false)
		Text_applyed:setVisible(false)
	end
end
function AllianceMemberSingle:showAbbr(isShow)
	if self.isAbbr ~= isShow then
		self.isAbbr = isShow
	end
	if self.isAbbr then
		local abbr = not self.tableSingleData.allianceAbbr and self.tableSingleData.getProperty and self.tableSingleData:getProperty("allianceAbbr")
		local name = self.tableSingleData.nickName or self.tableSingleData:getProperty("nickName")
		if abbr then
			_ENV = nil
			;(nil).abbr = abbr
			;(nil).name = name
			self.labelName:setString(i18n("common_text_186", nil))
		end
	end
end
function AllianceMemberSingle:initSearchData(singleData, otherData)
	self.tableSingleData = singleData
	self.otherData = otherData
	self:unDark()
	self:showNoAllianceMember()
	if self.tableSingleData.kid and self.tableSingleData.kid >= GAME_KINGDOM_ID_ASSIGN.LEGEND.START and self.tableSingleData.sourceKid and self.tableSingleData.sourceKid > 0 then
		_ENV = nil
		;(nil).kid = self.tableSingleData.sourceKid
		self.labelLastTime:setString(i18n("common_text_342", nil))
	elseif self.tableSingleData.kid then
		_ENV = i18n("common_text_342", nil)
		i18n("common_text_342", nil).kid = self.tableSingleData.kid
		self.labelLastTime:setString(i18n("common_text_342", i18n("common_text_342", nil)))
	end
end
function AllianceMemberSingle:showNoAllianceMember()
	if self.imgFlg:getChildByName("LeaderEffect") then
		self.imgFlg:removeChildByName("LeaderEffect", true)
	end
	self.imgFlg:getVirtualRenderer():setState(0)
	self.imgFlg:loadTexture(allianceDesRead.getFlg(gAllianceRank.R2), ccui.TextureResType.plistType)
	self.spriteCrown:setVisible(false)
	self.imgPortrait:loadTexture(lordLocalData.getBust(self.tableSingleData.iconID), ccui.TextureResType.plistType)
	self.labelPower:setColor(cc.c3b(247, 216, 71))
	self.labelPower:setString(string.formatnumberthousands(self.tableSingleData.totalFc))
	self.labelCastleLv:setColor(cc.c3b(255, 210, 138))
	self:setCastleLv(self.tableSingleData.cityLevel)
	self.starLvText:setColor(cc.c3b(255, 210, 138))
	self:setBuildStarLv(self.tableSingleData.starLv)
	self.labelName:setString(self.tableSingleData.nickName)
	self.labelOnline:setVisible(false)
	self.labelLastTime:setVisible(true)
	self.labelLastTime:setColor(cc.c3b(0, 190, 30))
	self.labelLastTime:setString(allianceDesRead.getLanguageName(self.tableSingleData.language))
	if self.otherData then
		self:updateNodeStatus()
		if self.otherData.showKid then
			self.labelName:setString(_G.textParser.formatPlayerName(nil, self.tableSingleData.nickName, self.tableSingleData.partition))
		end
	end
end
function AllianceMemberSingle:showPublic()
	self.imgFlg:loadTexture(allianceDesRead.getFlg(self.tableSingleData:getProperty("rank")), ccui.TextureResType.plistType)
	self.spriteCrown:setSpriteFrame(allianceDesRead.getCrown(self.tableSingleData:getProperty("rank")))
	self.imgPortrait:loadTexture(lordLocalData.getBust(self.tableSingleData:getProperty("iconID")), ccui.TextureResType.plistType)
	self.labelPower:setString(string.formatnumberthousands(self.tableSingleData:getProperty("totalFc")))
	self:setCastleLv(self.tableSingleData:getProperty("cityLevel"))
	self:setBuildStarLv(self.tableSingleData:getProperty("starLv"))
	self.labelName:setString(self.tableSingleData:getProperty("nickName"))
	self.spriteCrown:setVisible(self.tableSingleData:getProperty("rank") >= gAllianceRank.R2)
	if self.tableSingleData:getProperty("rank") == gAllianceRank.R5 then
		self:addLeaderEffect()
	elseif self.imgFlg:getChildByName("LeaderEffect") then
		self.imgFlg:removeChildByName("LeaderEffect", true)
	end
end
function AllianceMemberSingle:setCastleLv(clv)
	local warLv = clv == nil and "" or buildLogic.transformBuildLvToWarLv(clv)
	local castleImg = "icon_castle.png"
	if type(warLv) == "number" and 1 <= warLv then
		clv = warLv
		castleImg = "301101.png"
	end
	self.spriteCastle:setSpriteFrame(castleImg)
	self.spriteCastle:setScale(35 / self.spriteCastle:getContentSize().width)
	self.labelCastleLv:setString(tostring(math.min(clv, 30)))
end
function AllianceMemberSingle:addLeaderEffect(...)
	if self.imgFlg:getChildByName("LeaderEffect") then
		self.imgFlg:removeChildByName("LeaderEffect", true)
	end
	_ENV, _ENV = self.imgFlg, self.imgFlg.removeChildByName
	_ENV, self.imgFlg.removeChildByName[1], self.imgFlg.plist = self.imgFlg, self.imgFlg, "et_alliance_leader_01.plist"
	self.imgFlg.removeChildByName[2], self.imgFlg.plist = self.imgFlg, "et_alliance_leader_02.plist"
	local param = self.imgFlg.removeChildByName
	local parNode = SoraDCreateEffectNode(param)
	parNode:setName("LeaderEffect")
	parNode:setPosition(cc.p(70, 140))
	parNode:addTo(self.imgFlg, 2)
end
function AllianceMemberSingle:showOwnAlliance()
	local isOnline = self.tableSingleData:getProperty("online") == 0
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local canShow = ownRank > gAllianceRank.R0 and permissionCtrl:hasPlayerPermission(gAPermission.VIEW_MEMBER_ONLINE_INFO)
	local sourceKid = self.tableSingleData:getProperty("sourceKid")
	local mapId = self.tableSingleData:getProperty("mapId")
	local ownMapId = ownmember:getProperty("mapId")
	self.labelOnline:setVisible(canShow and isOnline)
	self.labelLastTime:setVisible(canShow and not isOnline)
	if not isOnline and canShow then
		self.imgFlg:getVirtualRenderer():setState(1)
		self.labelPower:setColor(cc.c3b(145, 145, 145))
		self.labelCastleLv:setColor(cc.c3b(145, 145, 145))
		self.starLvText:setColor(cc.c3b(145, 145, 145))
		self.labelLastTime:setString(SoraDConverSecondToDate(self.tableSingleData:getProperty("online"), false, true))
	else
		self.imgFlg:getVirtualRenderer():setState(0)
		self.labelPower:setColor(cc.c3b(247, 216, 71))
		self.labelCastleLv:setColor(cc.c3b(255, 210, 138))
		self.starLvText:setColor(cc.c3b(255, 210, 138))
	end
	if SoraDGetDefaultLanguage() == "nl" then
		SoraDSetTextWidthHeight(self.labelLastTime, cc.size(100, 60))
	end
	local partition = self.tableSingleData:getProperty("partition")
	local rfKid = self.tableSingleData:getProperty("rfKid")
	print("partition", partition, rfKid)
	if sourceKid and 0 < sourceKid and ownmember:getProperty("sourceKid") ~= sourceKid and partition ~= rfKid then
		self.imgPortrait:getVirtualRenderer():setState(1)
		self.labelState:setString(i18n("common_text_3385"))
		self.labelState:setVisible(true)
	elseif (self.otherData == nil or self.otherData.showStatusType ~= SHOW_STATUS_TYPE.present) and not ownMapId and mapId then
		self.imgPortrait:getVirtualRenderer():setState(1)
		self.labelState:setString(i18n("remains_text_172"))
		self.labelState:setVisible(true)
	else
		self.imgPortrait:getVirtualRenderer():setState(0)
		self.labelState:setVisible(false)
	end
end
function AllianceMemberSingle:showOtherAlliance()
	self.labelOnline:setVisible(false)
	self.labelLastTime:setVisible(false)
end
function AllianceMemberSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(self, self.tableSingleData)
			return
		end
		dump(self.tableSingleData, "tableSingleData")
		if self.aid ~= nil and self.aid ~= 0 then
			if self.labelState:isVisible() then
				SoraDShowMsgTip(i18n("common_text_3400"))
			else
				local panel = SoraDCreatePanel("allianceMemberSetting")
				panel:initData(self.tableSingleData, self.isOwnAlliance)
				panel:show()
			end
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function AllianceMemberSingle:dark()
	SoraDSetGray(self.nodeTouch, true, true)
	self.nodeStatus:setCascadeColorEnabled(false)
	self.starLvNode:setCascadeColorEnabled(true)
end
function AllianceMemberSingle:unDark()
	SoraDSetGray(self.nodeTouch, false, true)
end
function AllianceMemberSingle:initBuildStarLvUI(...)
	local node = display.newNode()
	node:addTo(self.Node_have)
	node:setPosition(SoraDFSign(115), 41)
	node:setVisible(false)
	self.starLvNode = node
	local sprite = display.newSprite("#icon_build_star_01.png")
	sprite:addTo(node)
	sprite:setPosition(0, 0)
	sprite:setScale(0.45)
	self.starLvSprite = sprite
	local text = self.labelCastleLv:clone()
	text:addTo(node)
	text:setPosition(SoraDFSign(-15), 0)
	text:setString(1)
	text:setColor(cc.c3b(255, 210, 138))
	self.starLvText = text
end
function AllianceMemberSingle:setBuildStarLv(slv)
	local enable = slv and 0 < slv
	self.starLvNode:setVisible(enable)
	if enable then
		self.starLvSprite:setSpriteFrame(cityltCtrl.getBuildStarImage(slv))
		self.starLvText:setString(tostring(slv))
	end
end
function AllianceMemberSingle:updateNodeStatus(...)
	local limitData = self.otherData.limitListMap and self.otherData.limitListMap[self.tableSingleData.uid]
	local statusStr
	if limitData then
		local lordOfficialRead = include("lordOfficialRead")
		local getOfficialName = lordOfficialRead.getOfficialName
		local showStatusType = self.otherData.showStatusType
		if showStatusType == SHOW_STATUS_TYPE.gift_package then
			statusStr = i18n("legendaryking_text_09")
		elseif showStatusType == SHOW_STATUS_TYPE.legend_official then
			statusStr = getOfficialName(gShowOfficialType.LEGEND, limitData.titleID)
		elseif showStatusType == SHOW_STATUS_TYPE.kingStar_official then
			statusStr = getOfficialName(gShowOfficialType.KINGSTAR, limitData.titleID)
		elseif showStatusType == SHOW_STATUS_TYPE.hegemon_official then
			statusStr = getOfficialName(gShowOfficialType.HEGEMON, limitData.titleID)
		elseif showStatusType == SHOW_STATUS_TYPE.atlantis_official then
			statusStr = getOfficialName(gShowOfficialType.ATLANTIS, limitData.type)
		elseif showStatusType == SHOW_STATUS_TYPE.nebula_official then
			statusStr = getOfficialName(gShowOfficialType.NEBULA, limitData.officerID)
		elseif showStatusType == SHOW_STATUS_TYPE.nebulaEmperor_official then
			statusStr = getOfficialName(gShowOfficialType.NEBULA_EMPEROR, limitData)
		end
	end
	if statusStr then
		self.nodeStatus:setVisible(true)
		self.lbl_status:setString(statusStr)
		self:dark()
	else
		self.nodeStatus:setVisible(false)
	end
end
return AllianceMemberSingle
