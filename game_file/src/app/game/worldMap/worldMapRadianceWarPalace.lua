local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapDefine = include("worldMapDefine")
local worldMapInstance = include("worldMapInstance")
local worldMapRadianceWarPalace = class("worldMapRadianceWarPalace", function()
	local target = worldMapInstance.new("worldMapRadianceWarPalace")
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end)
function worldMapRadianceWarPalace:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapRadianceWarPalace:_initData()
	self.playerID = 0
	self.playerName = nil
	self.sourceID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warStatus = gKingdomWarStatusType.close
	self.buildState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self:_initBuildConnect()
	self.finishOccupy = false
	self.finishOccupyTime = 0
	self.histKingdomOccupySecs = 0
	self.timeNumber = 0
	self:_initProtectData()
end
function worldMapRadianceWarPalace:_initBuildBg()
	self.bgImage = display.newNode()
	self.bgImage:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y))
	self:addChild(self.bgImage, -1)
	self.image_bg = display.newSpriteNoChild("#Map_build_radiance_palace.png")
	self.image_bg:setPosition(cc.p(-65, 31))
	self.image_bg:addTo(self.bgImage, 1)
end
function worldMapRadianceWarPalace:_initUI()
	self:_initBuildBg()
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(2.25)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 220))
	self.image_Protect:addTo(self, 1)
	self.image_LeagueFlag = display.newSpriteNoChild(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 147, self.centerPoint.y + 30))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 1)
	self.image_LeagueFlag:setGroupID(worldMapDefine.GROU_ID.group_flag)
	self.image_build_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_build_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_build_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 150))
	self.image_build_name:addTo(self, 1)
	self.image_build_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	worldMapDefine = self.image_build_name
	self.image_build_name.UILabelType = 2
	self.image_build_name.text = ""
	self.image_build_name.size = 20
	self.text_build_name = SoraDCreateLabelNoChild(self.image_build_name)
	self.text_build_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_build_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 150))
	self.text_build_name:addTo(self, 1)
	self.text_build_name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.text_build_name:setString(i18n("brightWar_build_10"))
	self.image_player_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 90))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	worldMapDefine = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = ""
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabelNoChild(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 90))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_State = display.newSprite("#frame_map_07.png")
	self.image_State:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_State:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 30))
	self.image_State:setVisible(false)
	self.image_State:addTo(self, 1)
	self.image_State:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	local size_State = self.image_State:getContentSize()
	worldMapDefine = worldMapDefine.GROU_ID.group_level_build
	worldMapDefine.GROU_ID.group_level_build.UILabelType = 2
	worldMapDefine.GROU_ID.group_level_build.text = "00:00:00"
	worldMapDefine.GROU_ID.group_level_build.size = 20
	self.text_StateTime = cc.ui.UILabel.new(worldMapDefine.GROU_ID.group_level_build)
	self.text_StateTime:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_StateTime:setPosition(cc.p(size_State.width / 2, size_State.height / 2 - 2))
	self.text_StateTime:addTo(self.image_State, 1)
	self.text_StateTime:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.text_StateTime = SoraDCreateTimerLabel(self, self.text_StateTime)
	self.text_StateTime:setTimeEndListener(function(...)
	end)
	self.text_StateTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("brightWar_text_36", nil)
	end)
end
function worldMapRadianceWarPalace:getSiteClassID()
	return self.siteClassID
end
function worldMapRadianceWarPalace:addCacheBefore()
	self.image_Protect:setVisible(false)
	self:resetProtectime()
end
function worldMapRadianceWarPalace:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
	self.bgImage:setGroupAuto(true)
end
function worldMapRadianceWarPalace:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = objId
	if self.siteClassID then
	end
	self:updateData(siteData)
end
function worldMapRadianceWarPalace:updateData(data)
	if not data then
		return
	end
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.headid then
		self.headid = data.headid
	end
	if data.avatar then
		self.avatar = data.avatar
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.leagueAbbrName then
		self.leagueAbbrName = data.leagueAbbrName
	end
	if data.leagueFlag then
		self.leagueFlag = data.leagueFlag
	end
	if data.sourceKid then
		self.sourceID = data.sourceKid
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.status then
		self.buildState = data.status
	end
	if data.finishOccupy ~= nil then
		self.finishOccupy = data.finishOccupy
	end
	if data.finishOccupyTime ~= nil then
		self.finishOccupyTime = data.finishOccupyTime
	end
	if data.histKingdomOccupySecs ~= nil then
		self.histKingdomOccupySecs = data.histKingdomOccupySecs
	end
	self:updateDataProtectime(data)
	self:updateBuildConnect(data)
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	self:updateSafeState()
	self:updateStatus()
	_ENV = self
	self.msg = "MESSAGE_SERVER_RADIANCE_WAR_BUILD_UPDATE"
	self.siteClassID = self:getSiteClassID()
	SoraDSendMessage(self)
end
function worldMapRadianceWarPalace:updateTimeTipsPalace(show)
	local finishOccupy = self.finishOccupy or false
	if show and finishOccupy then
		self.image_State:setVisible(true)
		local finishOccupyTime = self.finishOccupyTime or 0
		local sysTime = serviceFunctions.systemTime()
		self.timeNumber = sysTime - finishOccupyTime
		if 0 > self.timeNumber then
			self.timeNumber = 0
		end
		local histKingdomOccupySecs = self.histKingdomOccupySecs or 0
		self.timeNumber = self.timeNumber + histKingdomOccupySecs
		self.text_StateTime:beginTimeNode(function()
			self.timeNumber = self.timeNumber + 1
			return self.timeNumber
		end)
	else
		self.image_State:setVisible(false)
		self.text_StateTime:endTime()
	end
end
function worldMapRadianceWarPalace:updatePlayerInfo()
	if self.leagueID and self.leagueID > 0 then
		self:updateTimeTipsPalace(true)
		local selfLeagueID = allianceMgr:getOwnTeamID()
		if self.leagueID == selfLeagueID then
			local nameColor = worldMapDefine.getLeagueManorLineColor(true)
			self.text_player_Name:setColor(nameColor)
		else
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
			local nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			self.text_player_Name:setColor(nameColor)
		end
		self.image_LeagueFlag:setVisible(true)
		self.image_player_name:setVisible(true)
		self.text_player_Name:setVisible(true)
		if allianceDesRead.getFlagIcon(self.leagueFlag) then
			self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(self.leagueFlag))
			self.image_LeagueFlag:setScale(0.3)
		end
		local textName = self.playerName
		if self.leagueID and self.leagueID > 0 and self.leagueAbbrName then
			allianceMgr = allianceDesRead.getFlagIcon(self.leagueFlag)
			allianceDesRead.getFlagIcon(self.leagueFlag).abbr = self.leagueAbbrName
			allianceDesRead.getFlagIcon(self.leagueFlag).name = textName
			textName = i18n("common_text_186", allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		if 0 < self.sourceID then
			textName = textName .. "#" .. tostring(self.sourceID)
		end
		self.text_player_Name:setString(textName)
	else
		self:updateTimeTipsPalace(false)
		self.image_LeagueFlag:setVisible(false)
		self.image_player_name:setVisible(false)
		self.text_player_Name:setVisible(false)
	end
end
function worldMapRadianceWarPalace:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
		self:setProtectimeShow(false)
	else
		self.image_Protect:setVisible(true)
		self:setProtectimeShow(true, true)
	end
end
function worldMapRadianceWarPalace:updateStatus()
	self:updateFireEffect(self.buildState)
end
function worldMapRadianceWarPalace:addFireEffect(fightTime, data)
	worldMapInstance.addFireEffect(self, fightTime, data)
	if self.fireNode then
		local GROU_ID = worldMapDefine.GROU_ID
		self.fireNode:setGroupID(GROU_ID.group_flag)
		self.fireNode:setGroupAuto(true)
	end
end
function worldMapRadianceWarPalace:playClickSound()
	SoraDPlaySound("innerbuildsound", 101)
end
function worldMapRadianceWarPalace:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom then
		if self.warStatus == gKingdomWarStatusType.inWar then
			if 0 < selfLeagueID then
				if self.leagueID == 0 then
					local isConnected = self:isConnected()
					allianceMgr = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
					;(nil).isButtonEnabled = isConnected
					table.insert(buttonTypeArray, nil)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						allianceMgr = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
						;(0).isButtonEnabled = isConnected
						table.insert(buttonTypeArray, 0)
					end
				elseif selfLeagueID == self.leagueID then
					if self:checkHasArmy() then
						allianceMgr = table.insert
						table.insert.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
						table.insert(buttonTypeArray, table.insert)
					end
					allianceMgr = table.insert
					table.insert.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
					table.insert(buttonTypeArray, table.insert)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						allianceMgr = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
						table.insert(buttonTypeArray, 0)
					end
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
					table.insert(buttonTypeArray, 0)
				else
					local isEnable
					local isEnableZhenCha = true
					local msgTipsKey
					local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
					local selfSourceID = lordInfoCtrl:getMapSourceKid()
					if 0 < self.sourceID and selfSourceID == self.sourceID then
						isEnable = false
						isEnableZhenCha = false
						allianceMgr = nil
						;(nil).buildname = self:getFavoriteName()
						msgTipsKey = i18n("brightWar_text_131", nil)
					else
						isEnable = self:isConnected()
					end
					allianceMgr = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
					;(nil).isButtonEnabled = isEnable
					;(nil).msgTipsKey = msgTipsKey
					table.insert(buttonTypeArray, nil)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						allianceMgr = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
						;(0).isButtonEnabled = isEnable
						;(0).msgTipsKey = msgTipsKey
						table.insert(buttonTypeArray, 0)
					end
					local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
					if 1 < towerLv then
						allianceMgr = worldMapDefine.worldMapTipButtonType_xuanZhan
						worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
						worldMapDefine.worldMapTipButtonType_xuanZhan.isButtonEnabled = isEnableZhenCha
						worldMapDefine.worldMapTipButtonType_xuanZhan.msgTipsKey = msgTipsKey
						table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
					end
				end
			end
		else
			if self.warStatus == gKingdomWarStatusType.rule then
			else
			end
		end
	end
	allianceMgr = i18n("brightWar_text_131", nil)
	i18n("brightWar_text_131", nil).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, (i18n("brightWar_text_131", nil)))
	return buttonTypeArray
end
return worldMapRadianceWarPalace
