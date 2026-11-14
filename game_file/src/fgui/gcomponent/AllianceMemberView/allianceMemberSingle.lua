_ENV = nil
;(nil).gift_package = 1
;(nil).legend_official = 2
;(nil).hegemon_official = 3
;(nil).present = 4
;(nil).atlantis_official = 5
;(nil).nebula_official = 6
;(nil).kingStar_official = 7
local (nil).nebulaEmperor_official, SHOW_STATUS_TYPE = 8, nil
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceMemberSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMemberView/allianceMemberSingle", allianceMemberSingle)
function allianceMemberSingle:onInit()
	self.tableSingleData, _ENV = nil, nil
	self.aid = nil
	self.isAbbr = false
	self.rank = nil
	self.isOwnAlliance = nil
	self.handle = nil
	self.isInStatus = false
	self.fields.Text_state:setVisible(false)
	self.fields.Text_online:setString(i18n("common_text_224"))
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
	self.fields.Button_official:setVisible(false)
	self:setNodeNone(false)
	self:setNodeStaus(false)
	self.fields.Particle_1:setVisible(false)
	self.fields.Particle_2:setVisible(false)
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_official:addClickListener(handler(self, self.onBtnOfficialClick))
	self.fields.Button_apply:addClickListener(handler(self, self.onBtnApplyClick))
	self:fixChildrenPos()
	self.fields.Image_official:fix()
end
function allianceMemberSingle:onShow()
end
function allianceMemberSingle:setNodeStaus(ret, str)
	self.fields.bg_status:setVisible(ret)
	self.fields.lbl_status:setVisible(ret)
	self.fields.dark:setVisible(ret)
	if ret then
		self.fields.lbl_status:setString(str)
	end
end
function allianceMemberSingle:setNodeNone(ret)
	self.fields.Text_none:setVisible(ret)
	self.fields.Button_apply:setVisible(ret)
	self.fields.Text_applyed:setVisible(ret)
end
function allianceMemberSingle:setNodeHave(ret)
	self.fields.Image_portrait:setVisible(ret)
	self.fields.Text_state:setVisible(ret)
	self.fields.Image_flg:setVisible(ret)
	self.fields.Text_online:setVisible(ret)
	self.fields.Text_lastTime:setVisible(ret)
	self.fields.Text_powerLab:setVisible(ret)
	self.fields.Text_power:setVisible(ret)
	self.fields.Text_name:setVisible(ret)
	self.fields.Text_castleLv:setVisible(ret)
	self.fields.Sprite_castle:setVisible(ret)
	self.fields.starLvText:setVisible(ret)
	self.fields.starLvSprite:setVisible(ret)
end
function allianceMemberSingle:initData(rank, data, aid, otherData)
	self.tableSingleData = data
	self.aid = aid
	self.rank = rank
	self.otherData = otherData
	self.isInStatus = false
	if self.aid == nil or self.aid == 0 then
		self:showNoAllianceMember()
	else
		self:setOfficial()
	end
	self:showAbbr(self.isAbbr)
	self:showHonorBackNode()
end
function allianceMemberSingle:showNoAllianceMember()
	self.fields.Particle_1:setVisible(false)
	self.fields.Particle_2:setVisible(false)
	self.fields.Image_flg:setGrayed(false)
	self.fields.Image_flg:setSpriteFrame(allianceDesRead.getFlg(gAllianceRank.R2))
	self.fields.Sprite_crown:setVisible(false)
	self.fields.Image_portrait:setSpriteFrame(lordLocalData.getBust(self.tableSingleData.iconID))
	self.fields.Text_power:setString(string.formatnumberthousands(self.tableSingleData.totalFc))
	self:setCastleLv(self.tableSingleData.cityLevel)
	self:setBuildStarLv(self.tableSingleData.starLv)
	self.fields.Text_name:setString(self.tableSingleData.nickName)
	self.fields.Text_online:setVisible(false)
	self.fields.Text_lastTime:setVisible(true)
	self.fields.Text_lastTime:setString(allianceDesRead.getLanguageName(self.tableSingleData.language))
	if self.otherData then
		self:updateNodeStatus()
		if self.otherData.showKid then
			self.fields.Text_name:setString(_G.textParser.formatPlayerName(nil, self.tableSingleData.nickName, self.tableSingleData.partition))
		end
	end
end
function allianceMemberSingle:setOfficial()
	self.isOwnAlliance = allianceMgr:hasJoinAlliance() and allianceMgr:getOwnAid() == self.aid
	self.fields.Panel_touch:setTouchEnabled(true)
	if self.rank == gAllianceRank.OFFICIAL then
		self:setGeneralOfficial()
		if self.tableSingleData.minfo.uid > 0 then
			self:showPublic()
			self:setHaveOfficial()
		else
			self:setNoneOfficial()
		end
	else
		self:setNodeHave(true)
		self.fields.Image_official:setVisible(false)
		self:setNodeNone(false)
		self.fields.Button_official:setVisible(false)
		self:showPublic()
	end
	if self.isOwnAlliance then
		self:showOwnAlliance()
	elseif self.aid then
		self:showOtherAlliance()
	end
end
function allianceMemberSingle:showOwnAlliance()
	local isOnline = self.tableSingleData:getProperty("online") == 0
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local canShow = ownRank > gAllianceRank.R0 and permissionCtrl:hasPlayerPermission(gAPermission.VIEW_MEMBER_ONLINE_INFO)
	local sourceKid = self.tableSingleData:getProperty("sourceKid")
	local mapId = self.tableSingleData:getProperty("mapId")
	local ownMapId = ownmember:getProperty("mapId")
	if self.rank == gAllianceRank.OFFICIAL and self.tableSingleData.minfo.uid == 0 then
		self.fields.Text_online:setVisible(false)
		self.fields.Text_lastTime:setVisible(false)
	else
		self.fields.Text_online:setVisible(canShow and isOnline)
		self.fields.Text_lastTime:setVisible(canShow and not isOnline)
	end
	if not isOnline and canShow then
		self.fields.Image_flg:setGrayed(true)
		self.fields.Text_lastTime:setString(SoraDConverSecondToDate(self.tableSingleData:getProperty("online"), false, true))
	else
		self.fields.Image_flg:setGrayed(false)
	end
	local partition = self.tableSingleData:getProperty("partition")
	local rfKid = self.tableSingleData:getProperty("rfKid")
	self.isInStatus = false
	if sourceKid and 0 < sourceKid and ownmember:getProperty("sourceKid") ~= sourceKid and partition ~= rfKid then
		self.fields.Image_portrait:setGrayed(true)
		self.fields.Text_state:setString(i18n("common_text_3385"))
		self.fields.Text_state:setVisible(true)
		self.isInStatus = true
	elseif (self.otherData == nil or self.otherData.showStatusType ~= SHOW_STATUS_TYPE.present) and not ownMapId and mapId and not worldMapDefine.isGardenKingdomID(mapId) then
		self.fields.Image_portrait:setGrayed(true)
		self.fields.Text_state:setString(i18n("remains_text_172"))
		self.fields.Text_state:setVisible(true)
		self.isInStatus = true
	else
		self.fields.Image_portrait:setGrayed(false)
		self.fields.Text_state:setVisible(false)
	end
end
function allianceMemberSingle:showOtherAlliance()
	self.fields.Text_online:setVisible(false)
	self.fields.Text_lastTime:setVisible(false)
end
function allianceMemberSingle:setHaveOfficial()
	self.fields.Sprite_crown:setVisible(false)
	self:setNodeHave(true)
	self:setNodeNone(false)
end
function allianceMemberSingle:setNoneOfficial()
	self.fields.Sprite_crown:setVisible(false)
	self.fields.Panel_touch:setTouchEnabled(false)
	self:setNodeHave(false)
	self:setNodeNone(true)
	self.fields.Text_none:setString(i18n("alliance_office_text_15"))
	local official = self.tableSingleData.minfo.official
	if self.isOwnAlliance then
		local isLeader = allianceMgr:isLeader()
		if isLeader then
			self.fields.Button_apply:setString(i18n("common_text_687"))
			self.fields.Button_apply:setVisible(true)
			self.fields.Button_apply:setBright(not worldMapDefine.isInWarForbid(true))
			self.fields.Text_applyed:setVisible(false)
		else
			local isApplyedOfficial = memberMgr:isApplyedOfficial(official)
			local isOwnOfficial = memberMgr:isOwnOfficial()
			self.fields.Text_applyed:setVisible(isApplyedOfficial)
			if isApplyedOfficial then
				self.fields.Button_apply:setVisible(false)
				self.fields.Text_applyed:setVisible(true)
				self.fields.Text_applyed:setString(i18n("alliance_office_btn_02"))
			elseif isOwnOfficial then
				self.fields.Button_apply:setVisible(false)
			else
				self.fields.Button_apply:setVisible(true)
				self.fields.Button_apply:setBright(not worldMapDefine.isInWarForbid(true))
				self.fields.Button_apply:setString(i18n("common_text_182"))
			end
		end
	elseif self.aid then
		self.fields.Button_apply:setVisible(false)
		self.fields.Text_applyed:setVisible(false)
	end
end
function allianceMemberSingle:showPublic()
	self.fields.Image_flg:setSpriteFrame(allianceDesRead.getFlg(self.tableSingleData:getProperty("rank")))
	self.fields.Sprite_crown:setSpriteFrame(allianceDesRead.getCrown(self.tableSingleData:getProperty("rank")))
	self.fields.Sprite_crown:setVisible(self.tableSingleData:getProperty("rank") >= gAllianceRank.R2)
	self.fields.Image_portrait:setSpriteFrame(lordLocalData.getBust(self.tableSingleData:getProperty("iconID")))
	self.fields.Text_power:setString(string.formatnumberthousands(self.tableSingleData:getProperty("totalFc")))
	self:setCastleLv(self.tableSingleData:getProperty("cityLevel"))
	self:setBuildStarLv(self.tableSingleData:getProperty("starLv"))
	self.fields.Text_name:setString(self.tableSingleData:getProperty("nickName"))
	if self.tableSingleData:getProperty("rank") == gAllianceRank.R5 then
		self.fields.Particle_1:setVisible(true)
		self.fields.Particle_2:setVisible(true)
	else
		self.fields.Particle_1:setVisible(false)
		self.fields.Particle_2:setVisible(false)
	end
end
function allianceMemberSingle:setGeneralOfficial()
	self.fields.Image_official:setVisible(true)
	self.fields.Button_official:setVisible(true)
	self.fields.Sprite_crown:setVisible(false)
	local official = self.tableSingleData.minfo.official
	local img = allianceDesRead.getOfficialBg(official)
	local name = allianceDesRead.getOfficialName(official)
	self.fields.Button_official:setTag(official)
	self.fields.Image_official:setSpriteFrame(img)
	self.fields.Button_official:setString(name)
end
function allianceMemberSingle:setCastleLv(clv)
	local warLv = clv == nil and "" or buildLogic.transformBuildLvToWarLv(clv)
	local castleImg = "icon_castle.png"
	if type(warLv) == "number" and 1 <= warLv then
		clv = warLv
		castleImg = "301101.png"
	end
	self.fields.Sprite_castle:setSpriteFrame(castleImg)
	self.fields.Text_castleLv:setString(tostring(math.min(clv, CASTLE_MAXLV_NOWAR)))
end
function allianceMemberSingle:setBuildStarLv(slv)
	local enable = slv and 0 < slv
	self.fields.starLvText:setVisible(enable)
	self.fields.starLvSprite:setVisible(enable)
	if enable then
		self.fields.starLvSprite:setSpriteFrame(cityltCtrl.getBuildStarImage(slv))
		self.fields.starLvText:setString(tostring(slv))
	end
end
function allianceMemberSingle:showAbbr(isShow)
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
			self.fields.Text_name:setString(i18n("common_text_186", nil))
		end
	end
end
function allianceMemberSingle:updateNodeStatus()
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
		self:setNodeStaus(true, statusStr)
	else
		self:setNodeStaus(false)
	end
end
function allianceMemberSingle:onBtnOfficialClick(context)
	SoraDPlaySound()
	local official = context:getSender():getTag()
	SoraDShowHelpMsgTip(allianceDesRead.getOfficialDes(official))
end
function allianceMemberSingle:onBtnApplyClick()
	if worldMapDefine.isInWarForbid() then
		return
	end
	SoraDPlaySound()
	if self.isOwnAlliance then
		if allianceMgr:isLeader() then
			if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
				return
			end
			local official = self.tableSingleData.minfo.official
			local panel = SoraDCreatePanel("allianceOfficialAppointView")
			panel:show()
			panel:initOfficial(official)
		else
			local official = self.tableSingleData.minfo.official
			allianceMgr:reqApplyAllianceOfficial(official)
		end
	end
end
function allianceMemberSingle:btnClickCallBack()
	SoraDPlaySound()
	if self.handle then
		self.handle(self, self.tableSingleData)
		return
	end
	if self.aid ~= nil and self.aid ~= 0 then
		if self.isInStatus then
			SoraDShowMsgTip(i18n("common_text_3400"))
		else
			_ENV = i18n("common_text_3400")
			i18n("common_text_3400").singleData = self.tableSingleData
			i18n("common_text_3400").isOwnAlliance = self.isOwnAlliance
			uiManager:show("allianceMemberSetting", i18n("common_text_3400"))
		end
	end
end
function allianceMemberSingle:showHonorBackNode(...)
	if self.node_honorBack then
		self.node_honorBack:setVisible(false)
	end
end
return allianceMemberSingle
