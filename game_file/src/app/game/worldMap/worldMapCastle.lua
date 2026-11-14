local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapUtil = include("worldMapUtil")
local worldMapCastle = class("worldMapCastle", function(target)
	local target = include("worldMapInstance").new("worldMapCastle")
	return target
end)
local castleModelCfg = worldMapUtil.castleModelCfg
function worldMapCastle:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapCastle:_initData()
	self.playerID = 0
	self.playerName = nil
	self.rfKid = 0
	self.sourceID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.isSelfIn = false
	self.warStatus = gKingdomWarStatusType.close
	self.kingStatus = gKingStatus.none
	self.castleState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.castleModel = 1
	self.warStatusTime = 0
	self.showWarStatusTime = false
	self.emojiID = nil
end
function worldMapCastle:_initUI()
	self.bgImage = display.newSprite("#Map_King_castle_01.png")
	self.bgImage:setAnchorPoint(cc.p(0.52, 0.39))
	self:addChild(self.bgImage, -1)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(1.8)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
	self.image_Protect:addTo(self, 1)
	self.image_State = display.newScale9Sprite("#frame_protect_bubble_01.png", 0, 0, cc.size(200, 120), cc.rect(50, 20, 3, 3))
	self.image_State:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 325))
	self.image_State:addTo(self, 1)
	self.image_State:setVisible(false)
	local size_State = self.image_State:getContentSize()
	local image_line = display.newSprite("#frame_protect_line_01.png")
	image_line:setAnchorPoint(cc.p(0.5, 0.5))
	image_line:setPosition(cc.p(size_State.width / 2, size_State.height / 2 + 15))
	image_line:setScaleX(2.0)
	image_line:addTo(self.image_State)
	self.text_StateTiTle = ccui.Text:create()
	self.text_StateTiTle:setFontSize(20)
	self.text_StateTiTle:setColor(cc.c3b(200, 0, 0))
	self.text_StateTiTle:addTo(self.image_State, 1)
	self.text_StateTiTle:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_StateTiTle:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.text_StateTiTle:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.text_StateTiTle:setPosition(cc.p(size_State.width / 2, size_State.height / 2 + 35))
	self.text_StateTiTle:setTextAreaSize(cc.size(160, 40))
	self.text_StateTiTle:setContentSize(cc.size(160, 40))
	self.text_StateTiTle:ignoreContentAdaptWithSize(false)
	_ENV = self.text_StateTiTle
	self.text_StateTiTle.UILabelType = 2
	self.text_StateTiTle.text = "00:00:00"
	self.text_StateTiTle.size = 20
	self.text_StateTime = cc.ui.UILabel.new(self.text_StateTiTle)
	self.text_StateTime:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_StateTime:setPosition(cc.p(size_State.width / 2, size_State.height / 2 - 10))
	self.text_StateTime:addTo(self.image_State, 1)
	self.text_StateTime = SoraDCreateTimerLabel(self, self.text_StateTime)
	self.text_StateTime:setTimeEndListener(function(...)
	end)
	self.image_Ready = display.newScale9Sprite("#title_main_build.png", 0, 0, cc.size(450, 45))
	self.image_Ready:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y - 250))
	self.image_Ready:addTo(self, 1)
	self.image_Ready:setVisible(false)
	local size_ready = self.image_Ready:getContentSize()
	_ENV = false
	;(false).UILabelType = 2
	;(false).text = i18n("common_text_1445")
	;(false).size = 16
	self.text_Ready = cc.ui.UILabel.new(false)
	self.text_Ready:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Ready:setPosition(cc.p(size_ready.width / 2, size_ready.height / 2))
	self.text_Ready:setColor(cc.c3b(200, 200, 0))
	self.text_Ready:addTo(self.image_Ready, 1)
	self.image_LeagueFlag = display.newSprite(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 147, self.centerPoint.y - 10))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 1)
	self.image_LeagueFlag:setGroupID(worldMapDefine.GROU_ID.group_flag)
	self.image_league_name = display.newSprite("#frame_map_07.png")
	self.image_league_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_league_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 35))
	self.image_league_name:setVisible(false)
	self.image_league_name:addTo(self, 1)
	self.image_league_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_league_name
	self.image_league_name.UILabelType = 2
	self.image_league_name.text = "leagueName"
	self.image_league_name.size = 20
	self.text_league_Name = SoraDCreateLabel(self.image_league_name)
	self.text_league_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_league_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 35))
	self.text_league_Name:setVisible(false)
	self.text_league_Name:addTo(self, 1)
	self.text_league_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_player_name = display.newSprite("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = "playerName"
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabel(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapCastle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.onKingdomUsrChanged))
end
function worldMapCastle:onKingdomUsrChanged(data)
	local worldMapView = worldMapDefine.getWorldMapView()
	local worldMapCell = worldMapView:getCurrentInMapViewCell()
	local kid = worldMapCell:getKingdomID()
	local isSelfKindom = kid == gametop.playertop_:getMapID()
	if isSelfKindom then
		self.kingStatus = worldMapDefine.kingdomStatus
	end
end
function worldMapCastle:addCacheBefore()
	self.image_Protect:setVisible(false)
	self.text_StateTime:removeTime()
	self:removeSkinEffect()
	self.bgImage:setSpriteFrame("Map_King_castle_01.png")
end
function worldMapCastle:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
end
function worldMapCastle:initInstanceData(castleData)
	self:updateData(castleData)
end
function worldMapCastle:getCastleModel()
	return self.castleModel
end
function worldMapCastle:updateData(data)
	if not data then
		return
	end
	self.bgImage:setPositionX(0)
	if data.model then
		self.castleModel = data.model
		local palaceInfoRead = include("palaceInfoRead")
		local castleImg = palaceInfoRead.getImg(tonumber(data.model))
		if castleImg then
			self.bgImage:setSpriteFrame(castleImg)
			if castleModelCfg[data.model] then
				self.bgImage:setPositionX(castleModelCfg[data.model].offsetx)
			end
			if tonumber(data.model) == 7 then
				self:addSkinEffect()
			else
				self:removeSkinEffect()
			end
		end
	end
	dump(data, "worldMapCastle:updateDa")
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.isSelfIn ~= nil then
		self.isSelfIn = data.isSelfIn
	end
	if data.sourceKid then
		self.sourceID = data.sourceKid
	end
	if data.rfKid then
		self.rfKid = data.rfKid
	end
	if data.leagueName then
		self.leagueName = data.leagueName
	end
	if data.leagueAbbrName then
		self.leagueAbbrName = data.leagueAbbrName
	end
	if data.leagueFlag then
		self.leagueFlag = data.leagueFlag
	end
	local bUpdateStatue = false
	if data.warStatus then
		bUpdateStatue = true
		self.warStatus = data.warStatus
	end
	if data.kingStatus then
		self.kingStatus = data.kingStatus
	end
	if data.showWarStatusTime ~= nil then
		bUpdateStatue = true
		self.showWarStatusTime = data.showWarStatusTime
	end
	if data.warStatusEndTime then
		bUpdateStatue = true
		self.warStatusTime = worldMapUtil.getWarStatusTime(data)
	end
	if data.status then
		self.castleState = data.status
	end
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	if bUpdateStatue then
		self:updateSafeState()
	end
	self:updateCastleState()
end
function worldMapCastle:updatePlayerInfo()
	local selfLeagueID = allianceMgr:getOwnTeamID()
	if self.warStatus == gKingdomWarStatusType.inWar and self.leagueID and self.leagueID > 0 then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local selfSourceID = lordInfoCtrl:getMapSourceKid()
		local leaderSourceID = gametop.playertop_:getKingdomID()
		if SoraDGetCtrl("conquestWarCtrl"):isHelper() then
			local _
			selfSourceID, _ = SoraDGetCtrl("conquestWarReinforcementsCtrl"):getAgreeKindom()
		end
		if 0 < self.rfKid then
			leaderSourceID = self.rfKid
		elseif 0 < self.sourceID then
			leaderSourceID = self.sourceID
		end
		if selfSourceID ~= leaderSourceID then
			self.text_league_Name:setColor(cc.c3b(200, 0, 0))
			self.text_player_Name:setColor(cc.c3b(200, 0, 0))
		elseif self.leagueID == selfLeagueID then
			local nameColor = worldMapDefine.getLeagueManorLineColor(true)
			self.text_league_Name:setColor(nameColor)
			self.text_player_Name:setColor(nameColor)
		else
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
			local nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			self.text_league_Name:setColor(nameColor)
			self.text_player_Name:setColor(nameColor)
		end
		self.image_LeagueFlag:setVisible(true)
		self.image_league_name:setVisible(true)
		self.text_league_Name:setVisible(true)
		self.image_player_name:setVisible(true)
		self.text_player_Name:setVisible(true)
		if allianceDesRead.getFlagIcon(self.leagueFlag) then
			self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		self.text_league_Name:setString(self.leagueName)
		local textName = self.playerName
		if self.leagueID and self.leagueID > 0 and self.leagueAbbrName then
			allianceMgr = allianceDesRead.getFlagIcon(self.leagueFlag)
			allianceDesRead.getFlagIcon(self.leagueFlag).abbr = self.leagueAbbrName
			allianceDesRead.getFlagIcon(self.leagueFlag).name = self.playerName
			textName = i18n("common_text_186", allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		if 0 < self.sourceID and selfSourceID ~= self.sourceID then
			textName = textName .. "#" .. tostring(self.sourceID)
		end
		self.text_player_Name:setString(textName)
	else
		self.image_LeagueFlag:setVisible(false)
		self.image_league_name:setVisible(false)
		self.text_league_Name:setVisible(false)
		self.image_player_name:setVisible(false)
		self.text_player_Name:setVisible(false)
	end
end
function worldMapCastle:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.close then
		self.image_Ready:setVisible(true)
	else
		self.image_Ready:setVisible(false)
	end
	if self.showWarStatusTime then
		if self.warStatus == gKingdomWarStatusType.inWar then
			self.text_StateTiTle:setString(i18n("common_text_1446"))
			self.text_StateTiTle:setColor(cc.c3b(200, 0, 0))
		elseif self.warStatus == gKingdomWarStatusType.rule then
			self.text_StateTiTle:setString(i18n("common_text_690"))
			self.text_StateTiTle:setColor(cc.c3b(0, 200, 0))
		elseif self.warStatus == gKingdomWarStatusType.close then
			self.text_StateTiTle:setString(i18n("common_text_1215"))
			self.text_StateTiTle:setColor(cc.c3b(0, 200, 0))
		end
		self.image_State:setVisible(true)
		self.text_StateTime:beginTime(self.warStatusTime)
	else
		self.image_State:setVisible(false)
	end
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapCastle:updateCastleState()
	self:updateFireEffect(self.castleState)
end
function worldMapCastle:addSkinEffect()
	local et_node = self:getChildByName("skinBgEffectNode")
	if not et_node then
		et_node = display.newNode()
		et_node:setName("skinBgEffectNode")
		et_node:setPosition(cc.p(self.centerPoint.x - 16.5, self.centerPoint.y + 78.5))
		et_node:addTo(self)
		_ENV, _ENV = et_node, et_node.addTo
		_ENV, et_node.plist = self, "et_wjcz_01.plist"
		self.x = -211.17
		et_node.pos, self.y = self, -67.99
		et_node.scale = 0.77
		_ENV, et_node.addTo[1], et_node.rotate = et_node, et_node, 30.34
		_ENV, et_node.plist = self, "et_wjcz_01.plist"
		self.x = 78.45
		et_node.pos, self.y = self, 105.31
		et_node.scale = 0.65
		_ENV, et_node.addTo[2], et_node.rotate = et_node, et_node, 30.32
		_ENV, et_node.plist = self, "et_wjcz_01.plist"
		self.x = 199.11
		et_node.pos, self.y = self, 53.21
		et_node.scale = 0.65
		_ENV, et_node.addTo[3], et_node.rotate = et_node, et_node, 30.32
		_ENV, et_node.plist = self, "et_wjcz_02.plist"
		self.x = -42.61
		et_node.pos, self.y = self, -40.76
		_ENV, et_node.addTo[4], et_node.rotate = et_node, et_node, -22.85
		_ENV, et_node.plist = self, "et_wjcz_03.plist"
		self.x = -138.56
		_ENV, et_node.pos, self.y = self, self, 267.45
		self.x = 1.05
		et_node.addTo[5], et_node.scale, self.y = et_node, self, 1.1
		local param = et_node.addTo
		local par_node = SoraDCreateEffectNode(param)
		par_node:setPosition(cc.p(20.2, -13.83))
		par_node:addTo(et_node)
		local _ENV, dh_sprites = par_node.addTo, par_node.addTo
		local _ENV, _ENV, _ENV, actions = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = 70
		_ENV, et_node[1], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = -36
		_ENV, et_node[2], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = -114.5
		_ENV, et_node[3], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = 224.3
		_ENV, et_node[4], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = -266.5
		_ENV, et_node[5], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = 63.4
		_ENV, et_node[6], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = 94.25
		_ENV, et_node[7], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = 221.7
		_ENV, et_node[8], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		_ENV, cc.p(20.2, -13.83).sprite = cc.p(20.2, -13.83)
		cc.p(20.2, -13.83).x = 218.8
		et_node[9], cc.p(20.2, -13.83).pos, cc.p(20.2, -13.83).y = cc.p(20.2, -13.83)
		local dh_config = et_node
		for i = 1, #dh_config do
			dh_sprites[i] = display.newSprite(dh_config[i].sprite)
			dh_sprites[i]:setPosition(cc.p(dh_config[i].pos.x, dh_config[i].pos.y))
			dh_sprites[i]:addTo(et_node)
			_UPVALUE3_ = dh_sprites[i]
			dh_sprites[i][1] = cca.fadeOut(1)
			dh_sprites[i][2] = cca.delay(0.2)
			dh_sprites[i][3] = cca.fadeIn(1)
			dh_sprites[i][4] = cca.delay(0.2)
			dh_sprites[i][5] = cca.delay(0.2)
			local seq = cca.seq(dh_sprites[i])
			actions[i] = cc.RepeatForever:create(seq)
			dh_sprites[i]:runAction(actions[i])
		end
	end
end
function worldMapCastle:removeSkinEffect()
	if self:getChildByName("skinBgEffectNode") then
		self:removeChildByName("skinBgEffectNode", true)
	end
end
function worldMapCastle:onClickInstance(onShowView)
	self:playClickSound()
	if self.warStatus == gKingdomWarStatusType.close then
		local showRolygon = false
		print("弹出王国城堡界面")
		local panel = SoraDCreatePanel("worldMapKingdomCityStateView")
		panel:initView(self.warStatusTime)
		panel:show()
		return nil, showRolygon
	end
	return self:onShowWorldMapTip(onShowView)
end
function worldMapCastle:playClickSound()
	SoraDPlaySound("worldmap", 18)
end
function worldMapCastle:isInSelfKid()
	local worldMapView = worldMapDefine.getWorldMapView()
	local worldMapCell = worldMapView:getCurrentInMapViewCell()
	local kid = worldMapCell:getKingdomID()
	local sourceKid = SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid()
	return kid == sourceKid
end
function worldMapCastle:getInstanceOp(isSelfKindom)
	print("点击王国")
	local _ENV, buttonTypeArray = print, print
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom then
		if self.warStatus == gKingdomWarStatusType.inWar then
			if 0 < selfLeagueID then
				if self.leagueID == 0 then
					_ENV = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
					table.insert(buttonTypeArray, nil)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						_ENV = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
						table.insert(buttonTypeArray, 0)
					end
				elseif selfLeagueID == self.leagueID then
					if self.isSelfIn and self:checkHasArmy() then
						_ENV = buttonTypeArray
						buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
						table.insert(buttonTypeArray, buttonTypeArray)
					end
					if self:canHasEmojiOperator() then
						_ENV = buttonTypeArray
						buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
						table.insert(buttonTypeArray, buttonTypeArray)
					end
					_ENV = buttonTypeArray
					buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
					table.insert(buttonTypeArray, buttonTypeArray)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						_ENV = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
						table.insert(buttonTypeArray, 0)
					end
					_ENV = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
					table.insert(buttonTypeArray, 0)
				else
					_ENV = buttonTypeArray
					buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
					table.insert(buttonTypeArray, buttonTypeArray)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						_ENV = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
						table.insert(buttonTypeArray, 0)
					end
					local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
					if 1 < towerLv then
						_ENV = worldMapDefine.worldMapTipButtonType_xuanZhan
						worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
						table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
					end
				end
			end
		elseif self.warStatus == gKingdomWarStatusType.rule then
			if self.kingStatus == gKingStatus.king then
				_ENV = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_guanliWangguo
				table.insert(buttonTypeArray, table.insert)
				if self:canHasEmojiOperator() then
					_ENV = table.insert
					table.insert.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
					table.insert(buttonTypeArray, table.insert)
				end
			else
				_ENV = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_guanZhi
				table.insert(buttonTypeArray, table.insert)
			end
			_ENV = table.insert
			table.insert.buttonType = worldMapDefine.worldMapTipButtonType_intetior
			table.insert(buttonTypeArray, table.insert)
		end
	else
		_ENV = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_guanZhi
		table.insert(buttonTypeArray, table.insert)
		_ENV = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_intetior
		table.insert(buttonTypeArray, table.insert)
	end
	if not self:isInSelfKid() and SoraDGetCtrl("conquestWarCtrl"):getConquestWarState() == gConquestWarState.OPENING then
		_ENV = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_war_status
		table.insert(buttonTypeArray, table.insert)
	end
	_ENV = table.insert
	table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, table.insert)
	return buttonTypeArray
end
return worldMapCastle
