local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local allianceDesRead = include("allianceDesRead")
local worldMapStronghold = class("worldMapStronghold", function()
	local target = include("worldMapInstance").new("worldMapStronghold")
	return target
end)
function worldMapStronghold:ctor()
	self:_initData()
	self:_initUI()
end
function worldMapStronghold:_initData()
	self.objId = nil
	self.status = gKingdomWarStatusType.close
	self.playerID = nil
	self.playerName = ""
	self.size = 2
	self.radioation = 4
end
function worldMapStronghold:_initUI()
	self.modelImage = display.newSpriteNoChild("#alliance_mineral_nongtian.png")
	self.modelImage:setPosition(cc.p(-70, 30))
	self:addChild(self.modelImage, -1)
	self.image_name_bg = display.newSpriteNoChild("#frame_map_07.png")
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 60))
	self.image_name_bg:addTo(self, 1)
	self.image_name_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name_bg
	self.image_name_bg.UILabelType = 2
	self.image_name_bg.text = ""
	self.image_name_bg.size = 20
	self.text_Name = SoraDCreateLabelNoChild(self.image_name_bg)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 62))
	self.text_Name:addTo(self, 1)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_zl_bg = display.newSpriteNoChild("#frame_map_07.png")
	self.image_zl_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_zl_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 98))
	self.image_zl_bg:addTo(self, 1)
	self.image_zl_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_zl_bg
	self.image_zl_bg.UILabelType = 2
	self.image_zl_bg.text = ""
	self.image_zl_bg.size = 20
	self.text_zl = SoraDCreateLabelNoChild(self.image_zl_bg)
	self.text_zl:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_zl:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 101))
	self.text_zl:addTo(self, 1)
	self.text_zl:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_lv_bg = display.newSpriteNoChild("#frame_rydt_lsxk_lv.png")
	self.image_lv_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_lv_bg:setPosition(cc.p(self.centerPoint.x - 130, self.centerPoint.y - 83))
	self.image_lv_bg:addTo(self, 1)
	self.image_lv_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_lv_bg
	self.image_lv_bg.UILabelType = 2
	self.image_lv_bg.text = ""
	self.image_lv_bg.size = 22
	self.text_level = SoraDCreateLabelNoChild(self.image_lv_bg)
	self.text_level:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_level:setPosition(cc.p(self.centerPoint.x - 130, self.centerPoint.y - 83))
	self.text_level:addTo(self, 1)
	self.text_level:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 70))
	self.image_Protect:addTo(self, 4)
	self.image_pt_bg = display.newSpriteNoChild("#frame_map_07.png")
	self.image_pt_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_pt_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 20))
	self.image_pt_bg:addTo(self, 1)
	self.image_pt_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_pt_bg
	self.image_pt_bg.UILabelType = 2
	self.image_pt_bg.text = "00:00:00"
	self.image_pt_bg.size = 20
	self.text_StateTime = cc.ui.UILabel.new(self.image_pt_bg)
	self.text_StateTime:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_StateTime:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 23))
	self.text_StateTime:addTo(self, 1)
	self.text_StateTime = SoraDCreateTimerLabel(self, self.text_StateTime)
	self.image_picon = display.newSpriteNoChild("#icon_ldjd_weikaiqi.png")
	self.image_picon:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_picon:setPosition(cc.p(self.centerPoint.x - 80, self.centerPoint.y - 23))
	self.image_picon:addTo(self, 1)
end
function worldMapStronghold:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
end
function worldMapStronghold:setBuildSize(size, radioation)
	self.size = size or 2
	self.radioation = radioation or 4
end
function worldMapStronghold:addCacheBefore()
	self.image_Protect:setVisible(false)
	self.text_StateTime:removeTime()
end
function worldMapStronghold:initInstanceData(objId, buildData)
	self.objId = objId
	self:initBuildInfo()
	self:updateData(buildData)
end
function worldMapStronghold:initBuildInfo(...)
	local buildInfo = allianceStrongholdMineRead.getGateClientCfg(self.objId)
	if buildInfo then
		self.modelImage:setSpriteFrame(buildInfo.image)
		self:setHoldEffect(buildInfo.effects)
		self.text_level:setString(allianceStrongholdMineRead.getGateLv(self.objId))
		self.text_Name:setString(i18n(buildInfo.name))
		self.text_Name:setColor(cc.c3b(255, 255, 255))
	end
end
function worldMapStronghold:setHoldEffect(effects)
	if self.holdEffect then
		if self.holdEffect.effects == effects then
			return
		end
		self.holdEffect:removeFromParent()
		self.holdEffect = nil
	end
	_ENV, _ENV = self.holdEffect, self.holdEffect.removeFromParent
	self.holdEffect.csb = "Node_hold_et1"
	_ENV, self.holdEffect.removeFromParent[1], self.holdEffect.offset = self.holdEffect, self.holdEffect, cc.p(0, 0)
	self.holdEffect.csb = "Node_hold_et3"
	_ENV, self.holdEffect.removeFromParent[3], self.holdEffect.offset = self.holdEffect, self.holdEffect, cc.p(0, 0)
	self.holdEffect.csb = "Node_hold_et2"
	self.holdEffect.removeFromParent[4], self.holdEffect.offset = self.holdEffect, cc.p(0, 0)
	local etCfg = self.holdEffect.removeFromParent
	local data = etCfg[effects]
	if data then
		local etHold = SoraDCreatAnimation(data.csb)
		etHold:addTo(self)
		local pos = cc.p(data.offset.x + self.modelImage:getPositionX(), data.offset.y + self.modelImage:getPositionY())
		etHold:setPosition(pos)
		etHold.effects = effects
		self.holdEffect = etHold
	end
end
function worldMapStronghold:getBuildClassID()
	return self.objId
end
function worldMapStronghold:updateData(data)
	dump(data, "worldMapStronghold data======")
	if not data or data and not next(data) then
		return
	end
	_ENV = data
	_UPVALUE1_, data.msg = "worldMapStronghold data======", "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	data.relatedTilePoints, ("worldMapStronghold data======")[1] = "worldMapStronghold data======", self.tilePoint
	SoraDSendMessage(data)
	if data.status then
		self.status = data.status
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.warStatusEndTime then
		self.warStatusEndTime = data.warStatusEndTime
		self.text_StateTime:removeTime()
		self.text_StateTime:setTimeLast(function(time)
			if self.warStatus == gKingdomWarStatusType.rule then
				self = nil
				;(nil).var = time
				return i18n("alliance_stronghold_text_040", nil)
			else
				self = nil
				;(nil).var = time
				return i18n("alliance_stronghold_text_042", nil)
			end
		end)
		self.text_StateTime:beginTime(self.warStatusEndTime - serviceFunctions.systemTime())
		self.image_picon:setPositionX(self.text_StateTime:getPositionX() - self.text_StateTime:getContentSize().width / 2 - 20)
	end
	self:setProtectTimeVisible(self.warStatusEndTime and self.warStatusEndTime > 0 and self.warStatus ~= gKingdomWarStatusType.close)
	self.npc = data.npc
	self.occupy = data.occupy
	if self.occupy then
		self.playerID = self.occupy.uid
		self.playerName = self.occupy.name
		self.colorId = self.occupy.colorId
	end
	self:updatePlayerInfo()
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_WORLDMAPHOLD_UPDATE"
	self.instance = self
	SoraDSendMessage(self)
end
function worldMapStronghold:setProtectTimeVisible(ret)
	self.image_pt_bg:setVisible(ret)
	self.text_StateTime:setVisible(ret)
	self.image_picon:setVisible(ret)
	_ENV = self.image_picon.setVisible
	_ENV = ret
	ret.png = "icon_ldjd_weikaiqi.png"
	self.image_picon.setVisible[gKingdomWarStatusType.close], ret.color = ret, cc.c3b(255, 255, 255)
	_ENV = ret
	ret.png = "icon_ldjd_kegongji_02.png"
	self.image_picon.setVisible[gKingdomWarStatusType.inWar], ret.color = ret, cc.c3b(230, 50, 50)
	_ENV = ret
	ret.png = "icon_ldjd_baohuzhong_02.png"
	self.image_picon.setVisible[gKingdomWarStatusType.rule], ret.color = ret, cc.c3b(255, 255, 255)
	local iconCfg = self.image_picon.setVisible
	self.image_picon:setSpriteFrame(iconCfg[self.warStatus].png)
	self.text_StateTime:setColor(iconCfg[self.warStatus].color)
end
function worldMapStronghold:updatePlayerInfo()
	local nameColor = cc.c3b(255, 255, 255)
	self.image_Protect:setVisible(self.warStatus ~= gKingdomWarStatusType.inWar)
	self.rolygonColor = nameColor
	if self.warStatus == gKingdomWarStatusType.close then
		self.text_zl:setString(i18n("alliance_stronghold_text_038"))
	elseif self.warStatus == gKingdomWarStatusType.inWar then
		self.text_zl:setString(i18n("alliance_stronghold_text_036"))
		if self.occupy and self.occupy.aid > 0 then
			_ENV = i18n("alliance_stronghold_text_036")
			i18n("alliance_stronghold_text_036").abbr = self.occupy.abbr
			i18n("alliance_stronghold_text_036").name = self.occupy.aName
			self.text_zl:setString(i18n("common_text_186", i18n("alliance_stronghold_text_036")))
			if self.occupy.aid == allianceMgr:getOwnAid() then
				self.text_zl:setColor(worldMapDefine.getLeagueManorLineColor(true))
				nameColor = worldMapDefine.getLeagueManorLineColor(true)
			else
				local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.occupy.aid) or gMapAllianceRelationType.NORMAL
				nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
				self.text_zl:setColor(nameColor)
			end
		else
			self.text_zl:setString(i18n("pyramid_text_02"))
			self.text_zl:setColor(cc.c3b(255, 255, 255))
		end
	elseif self.warStatus == gKingdomWarStatusType.rule then
		if self.occupy and self.occupy.aid > 0 then
			_ENV = cc.c3b(255, 255, 255)
			cc.c3b(255, 255, 255).abbr = self.occupy.abbr
			cc.c3b(255, 255, 255).name = self.occupy.aName
			self.text_zl:setString(i18n("common_text_186", cc.c3b(255, 255, 255)))
			if self.occupy.aid == allianceMgr:getOwnAid() then
				self.text_zl:setColor(worldMapDefine.getLeagueManorLineColor(true))
				nameColor = worldMapDefine.getLeagueManorLineColor(true)
				if self.colorId and 0 < self.colorId then
					self.rolygonColor = allianceDesRead.getTerritoryColor(self.colorId)
				else
					self.rolygonColor = nameColor
				end
			else
				local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.occupy.aid) or gMapAllianceRelationType.NORMAL
				nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
				self.text_zl:setColor(nameColor)
				if (allianceRelationType == gMapAllianceRelationType.SELF or allianceRelationType == gMapAllianceRelationType.NORMAL) and self.colorId and 0 < self.colorId then
					self.rolygonColor = allianceDesRead.getTerritoryColor(self.colorId)
				else
					self.rolygonColor = nameColor
				end
			end
		else
			self.text_zl:setString(i18n("pyramid_text_02"))
			self.text_zl:setColor(cc.c3b(255, 255, 255))
		end
	end
end
function worldMapStronghold:getFavoriteName()
	local favoriteName = ""
	if self.objId then
		local buildInfo = allianceStrongholdMineRead.getGateClientCfg(self.objId)
		allianceStrongholdMineRead = nil
		;(nil).lv = allianceStrongholdMineRead.getGateLv(self.objId)
		;(nil).name = i18n(buildInfo.name)
		favoriteName = i18n("LV%{lv} %{name}", nil)
	end
	return favoriteName
end
function worldMapStronghold:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapStronghold:onClickInstance(onShowView)
	self:playClickSound()
	local selectShowPanel = self:onShowWorldMapTip(onShowView)
	local tilesRolygon = include("worldMapTilesRolygon").new(self.size + 2 * self.radioation)
	tilesRolygon:setRolygonColor(self.rolygonColor)
	return selectShowPanel, true, tilesRolygon
end
function worldMapStronghold:isBeOccupied()
	local ret = true
	for k, v in ipairs(self.npc.normalNpcLifes) do
		if 0 < v then
			ret = false
			break
		end
	end
	return ret and 0 >= self.npc.leaderNpcLeftLife
end
function worldMapStronghold:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
	if isSelfKindom then
		if self.warStatus == gKingdomWarStatusType.close then
			allianceMgr = 0
			;(0).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
			table.insert(buttonTypeArray, 0)
		elseif self.warStatus == gKingdomWarStatusType.inWar then
			if self.npc and not self:isBeOccupied() then
				allianceMgr = 0
				;(0).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				table.insert(buttonTypeArray, 0)
			elseif self.occupy then
				if self.occupy.aid == allianceMgr:getOwnAid() then
					if self.occupy.isIn then
						if self:checkHasArmy() then
							allianceMgr = allianceMgr
							allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
							table.insert(buttonTypeArray, allianceMgr)
						end
						if self:canHasEmojiOperator() then
							allianceMgr = allianceMgr
							allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
							table.insert(buttonTypeArray, allianceMgr)
						end
						allianceMgr = allianceMgr
						allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
						table.insert(buttonTypeArray, allianceMgr)
						if haveHall and 0 < selfLeagueID then
							allianceMgr = allianceMgr
							allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
							table.insert(buttonTypeArray, allianceMgr)
						end
						allianceMgr = allianceMgr
						allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
						table.insert(buttonTypeArray, allianceMgr)
					else
						allianceMgr = allianceMgr
						allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
						table.insert(buttonTypeArray, allianceMgr)
						if haveHall and 0 < selfLeagueID then
							allianceMgr = allianceMgr
							allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
							table.insert(buttonTypeArray, allianceMgr)
						end
					end
				else
					allianceMgr = allianceMgr
					allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
					table.insert(buttonTypeArray, allianceMgr)
					if self.occupy.isIn and haveHall and 0 < selfLeagueID then
						allianceMgr = allianceMgr
						allianceMgr.buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
						table.insert(buttonTypeArray, allianceMgr)
					end
					local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
					if 1 < towerLv then
						allianceMgr = worldMapDefine.worldMapTipButtonType_xuanZhan
						worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
						table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
					end
				end
			else
				allianceMgr = buttonTypeArray
				buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				table.insert(buttonTypeArray, buttonTypeArray)
				if haveHall and 0 < selfLeagueID then
					allianceMgr = buttonTypeArray
					buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					table.insert(buttonTypeArray, buttonTypeArray)
				end
			end
			allianceMgr = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
			table.insert(buttonTypeArray, buttonTypeArray)
		else
			allianceMgr = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
			table.insert(buttonTypeArray, buttonTypeArray)
		end
	else
		allianceMgr = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	return buttonTypeArray
end
return worldMapStronghold
