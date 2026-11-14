local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local collectMapCtrl = gametop.playertop_:getModule("collectMapCtrl")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local instanceFactory = include("instanceFactory")
local worldMapDefine = include("worldMapDefine")
local autokillCtrl = gametop.playertop_:getModule("autokillCtrl")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local atlantisWarUtil = include("atlantisWarUtil")
local worldMapWarDef = include("worldMapWarDef")
local worldMapTip = class("worldMapTip", function()
	return SoraDCreateBasePanel("worldMapTip")
end)
_ENV = "worldMapTip"
local ("worldMapTip")[gMapObjTypeDef.mapObjTypeKingdomLevelBuild], _WaitingDataObjs = true, "worldMapTip"
function worldMapTip:ctor(kingdomID)
	self.tilePoint = nil
	self.tilePointShow = nil
	self.worldMapCell = nil
	self.tilePointText = SoraDGetChildByName(self, "Text_point")
	self.tilePointText:setTouchEnabled(false)
	self.tilePointText:setPositionY(-140)
	self.tilePointText:setTouchScaleChangeEnabled(true)
	self.tilePointText:addTouchEventListener(handler(self, self.buttonTilePointCall))
	self.tilePointImage = SoraDGetChildByName(self, "Image_textPoint_bottom")
	self.tilePointImage:setVisible(false)
	self.collectTimer = nil
	self.collectSpanArray, _ENV, self.wajueTimer = self.tilePointImage.setVisible, self.tilePointImage.setVisible, nil
	self.collectSpanTime = 0
	self.collectSpanIndex = 0
	self.resourceCount = 0
	self.collectSpeed = 0
	self.wajueCount = 0
	self.wajueSpeed = 0
	self.resourceCountText = SoraDGetChildByName(self, "Text_resourceNum")
	self.resourceCountText:setVisible(false)
	self.resourceIconImg = SoraDGetChildByName(self, "Image_resourceIcon")
	self.resourceIconImg:setScale(0.7)
	self.resourceIconImg:setVisible(false)
	self.playerNameBg = SoraDGetChildByName(self, "Image_NameBg")
	self.playerNameBg:setVisible(false)
	self.playerNameLable = SoraDGetChildByName(self, "Text_Name")
	self.playerNameLable:setVisible(false)
	self.moveTypeNameLable = SoraDGetChildByName(self, "Text_type")
	self.moveTypeNameLable:setVisible(false)
	self.frameProtectTime = SoraDGetChildByName(self, "frame_map_pTime")
	self.frameProtectTime:setVisible(false)
	self.tipButtonsArray, _ENV = self.frameProtectTime.setVisible, self.frameProtectTime.setVisible
	self.favoriteName = ""
	self.isCanZhanling = true
	self.msgTipsKey = nil
	self.buttonFavorites1 = SoraDGetChildByName(self, "Button_favorite1")
	self.buttonFavorites3 = SoraDGetChildByName(self, "Button_favorite3")
	if self.buttonFavorites1 and self.buttonFavorites3 then
		self.buttonFavorites1:setVisible(false)
		self.buttonFavorites3:setVisible(false)
		self.buttonFavorites1:addTouchEventListener(handler(self, self.buttonFavoritesCall))
		self.buttonFavorites3:addTouchEventListener(handler(self, self.buttonFavoritesCall))
	end
	local inPyramidWar = worldMapDefine.isInWar()
	if inPyramidWar then
		self.buttonFavorites1:loadTextures("btn_comon_collect.png", "btn_comon_collect.png", "btn_comon_collect.png", ccui.TextureResType.plistType)
	end
	self.buttonCopy = SoraDGetChildByName(self, "Button_copy")
	self.imgCopyBg = SoraDGetChildByName(self, "Image_copyBg")
	if self.buttonCopy then
		self.buttonCopy:setVisible(false)
		self.imgCopyBg:setVisible(false)
		self.buttonCopy:addTouchEventListener(handler(self, self.buttonCopyCall))
	end
	self.btn_share = SoraDGetChildByName(self, "btn_share")
	self.btn_share:addTouchEventListener(handler(self, self.buttonShareCall))
	self.Node_1 = SoraDGetChildByName(self, "Node_1")
	self.mapInstance = nil
	self.kingdomID = kingdomID or gametop.playertop_:getMapID()
	self.isSelfKindom = self.kingdomID == gametop.playertop_:getMapID()
	self.isInWar = self.kingdomID ~= gametop.playertop_:getKingdomID()
	self.instanceKID = self.kingdomID
end
function worldMapTip:initMoveLineData(mapInstance)
	print(debug.traceback(10), "worldMapTip:initMoveLineData")
	_ENV, self.mapInstance = print, mapInstance
	print.moveLineID = self.mapInstance:getMoveLineID()
	local print.armyData, moveLineData = self.mapInstance:getArmyData(), print
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local moveTypeName = i18n("common_text_006")
	local _ENV, buttonTypeArray = "common_text_006", "common_text_006"
	local instanceName = self.mapInstance.__cname
	allianceMgr = nil
	;(nil)[1] = self.mapInstance.userData
	;(nil)[2] = instanceName
	dump(nil, "instanceName===", 10)
	if selfPlayerID == self.mapInstance.playerID then
		if instanceName ~= "escortSolider" and instanceName ~= "troopsMatrix" then
			local queue = kingdomMapCtrl:getQueueByID(self.mapInstance.moveLineID)
			if queue and not worldMapDefine.isInWarForbidSpeed(queue, true) then
				_ENV = true
				;(true).buttonType = worldMapDefine.worldMapTipButtonType_jiaSu
				;(true).data = moveLineData
				table.insert(buttonTypeArray, true)
			end
		end
		if instanceName == "troopsMatrix" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_481")
				if not autokillCtrl:isAutoKillQueueId(self.mapInstance) then
					local queue = kingdomMapCtrl:getQueueByID(self.mapInstance.moveLineID)
					if queue and not worldMapDefine.isInWarForbidSpeed(queue, true) then
						_ENV = true
						;(true).buttonType = worldMapDefine.worldMapTipButtonType_jiaSu
						;(true).data = moveLineData
						table.insert(buttonTypeArray, true)
					end
					if self.mapInstance.moveLineType == gMapMoveLineType.moveLineTypeMass then
						if self.mapInstance.isMainQueue then
							_ENV = true
							;(true).buttonType = worldMapDefine.worldMapTipButtonType_jiesan
							;(true).data = moveLineData
							table.insert(buttonTypeArray, true)
						else
							local isRecall = self.mapInstance.isRecall
							_ENV = worldMapDefine.worldMapTipButtonType_jiesan
							worldMapDefine.worldMapTipButtonType_jiesan.buttonType = worldMapDefine.worldMapTipButtonType_zhaoHui
							worldMapDefine.worldMapTipButtonType_jiesan.data = moveLineData
							worldMapDefine.worldMapTipButtonType_jiesan.isRecall = isRecall
							table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_jiesan)
						end
					else
						_ENV = buttonTypeArray
						buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_zhaoHui
						buttonTypeArray.data = moveLineData
						table.insert(buttonTypeArray, buttonTypeArray)
					end
				end
			end
			local taskType = self.mapInstance.userData and self.mapInstance.userData.commandHallTaskType
			if taskType then
				self.btn_share:setVisible(false)
				local commandHallUtil = include("commandHallUtil")
				if commandHallUtil.checkTaskTypeNeedArmy(taskType) then
					_ENV = worldMapDefine.worldMapTipButtonType_zhaoHui
					worldMapDefine.worldMapTipButtonType_zhaoHui.buttonType = worldMapDefine.worldMapTipButtonType_buDui
					worldMapDefine.worldMapTipButtonType_zhaoHui.data = moveLineData
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_zhaoHui)
				end
			elseif self.mapInstance.isMainQueue then
				_ENV = buttonTypeArray
				buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_buDui
				buttonTypeArray.data = moveLineData
				table.insert(buttonTypeArray, buttonTypeArray)
			end
			if self.mapInstance:canHasEmojiOperator(selfPlayerID) then
				_ENV = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				selfPlayerID.data = moveLineData
				table.insert(buttonTypeArray, selfPlayerID)
			end
			local queue = kingdomMapCtrl:getQueueByID(self.mapInstance.moveLineID)
			if queue and queue:getStatusRemainTime() <= 0 then
				buttonTypeArray, _ENV = queue:getStatusRemainTime(), queue:getStatusRemainTime()
				if self.mapInstance.isMainQueue then
					_ENV = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
					worldMapDefine.worldMapTipButtonType_biaoqingyinzhang.buttonType = worldMapDefine.worldMapTipButtonType_buDui
					worldMapDefine.worldMapTipButtonType_biaoqingyinzhang.data = moveLineData
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_biaoqingyinzhang)
				end
			end
		elseif instanceName == "collectSolider" then
			local isATbuilding = self.mapInstance.userData.toObjectType == gMapObjTypeDef.mapTypeATBuilding
			dump(self.mapInstance.userData, "self.mapInstance", 10)
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_482")
				if isATbuilding and self.mapInstance.moveLineType == gMapMoveLineType.moveLineTypeMass then
					if self.mapInstance.isMainQueue then
						_ENV = "self.mapInstance"
						;("self.mapInstance").buttonType = worldMapDefine.worldMapTipButtonType_jiesan
						;("self.mapInstance").data = moveLineData
						table.insert(buttonTypeArray, "self.mapInstance")
					elseif self.mapInstance.isRecall then
						_ENV = "self.mapInstance"
						;("self.mapInstance").buttonType = worldMapDefine.worldMapTipButtonType_zhaoHui
						;("self.mapInstance").data = moveLineData
						table.insert(buttonTypeArray, "self.mapInstance")
					end
				else
					_ENV = "self.mapInstance"
					;("self.mapInstance").buttonType = worldMapDefine.worldMapTipButtonType_zhaoHui
					;("self.mapInstance").data = moveLineData
					table.insert(buttonTypeArray, "self.mapInstance")
				end
			end
			if isATbuilding then
				moveTypeName = i18n("allitreas_btn_05")
			end
			if self.mapInstance:canHasEmojiOperator(selfPlayerID) then
				_ENV = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				selfPlayerID.data = moveLineData
				table.insert(buttonTypeArray, selfPlayerID)
			end
		elseif instanceName == "detectionSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_007")
				_ENV = buttonTypeArray
				buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_zhaoHui
				buttonTypeArray.data = moveLineData
				table.insert(buttonTypeArray, buttonTypeArray)
			end
			if self.mapInstance:canHasEmojiOperator(selfPlayerID) then
				_ENV = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				selfPlayerID.data = moveLineData
				table.insert(buttonTypeArray, selfPlayerID)
			end
		elseif instanceName == "tradeSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_044")
				_ENV = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_zhaoHui
				selfPlayerID.data = moveLineData
				table.insert(buttonTypeArray, selfPlayerID)
			end
			if self.mapInstance:canHasEmojiOperator(selfPlayerID) then
				_ENV = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				selfPlayerID.data = moveLineData
				table.insert(buttonTypeArray, selfPlayerID)
			end
		elseif instanceName == "romanSoulSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_481")
			end
		elseif instanceName == "getChestSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_677")
				_ENV = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_zhaoHui
				selfPlayerID.data = moveLineData
				table.insert(buttonTypeArray, selfPlayerID)
			end
			if self.mapInstance.toObjectType == gWorldTypeServerDef.mapTypeLostRuins or self.mapInstance.toObjectType == gWorldTypeServerDef.mapTypeWindTower or self.mapInstance.toObjectType == gWorldTypeServerDef.mapTypeIceDragonLost or self.mapInstance.toObjectType == gWorldTypeServerDef.mapTypeSnowWolfLost then
				moveTypeName = i18n("lost_ruins_text_24")
			end
			if self.mapInstance:canHasEmojiOperator(selfPlayerID) then
				_ENV = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				selfPlayerID.data = moveLineData
				table.insert(buttonTypeArray, selfPlayerID)
			end
		elseif instanceName == "escortSolider" then
			if self.mapInstance.userData.fromObjectType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
				buttonTypeArray, _ENV = self.mapInstance.userData.fromObjectType, self.mapInstance.userData.fromObjectType
			else
				if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
					moveTypeName = i18n("common_text_2322")
					_ENV = selfPlayerID
					selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_yuanzhujiacheng
					selfPlayerID.data = moveLineData
					table.insert(buttonTypeArray, selfPlayerID)
					_ENV = selfPlayerID
					selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_buDui
					selfPlayerID.data = moveLineData
					table.insert(buttonTypeArray, selfPlayerID)
					_ENV = selfPlayerID
					selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
					selfPlayerID.data = moveLineData
					table.insert(buttonTypeArray, selfPlayerID)
				else
					_ENV = selfPlayerID
					selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_jiaSu
					selfPlayerID.data = moveLineData
					table.insert(buttonTypeArray, selfPlayerID)
					_ENV = selfPlayerID
					selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_buDui
					selfPlayerID.data = moveLineData
					table.insert(buttonTypeArray, selfPlayerID)
				end
				if self.mapInstance:canHasEmojiOperator(selfPlayerID) then
					_ENV = selfPlayerID
					selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
					selfPlayerID.data = moveLineData
					table.insert(buttonTypeArray, selfPlayerID)
				end
			end
		end
		self:updateTilePoint(true)
		if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
			self.tilePointText:setTouchEnabled(true)
			self.tilePointImage:setVisible(true)
		end
	else
		if instanceName == "troopsMatrix" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_481")
			end
			if self.mapInstance and self.mapInstance.hasJoin == true then
				local queue = kingdomMapCtrl:getQueueByID(self.mapInstance.moveLineID)
				if queue and not worldMapDefine.isInWarForbidSpeed(queue, true) then
					_ENV = true
					;(true).buttonType = worldMapDefine.worldMapTipButtonType_jiaSu
					;(true).data = moveLineData
					table.insert(buttonTypeArray, true)
				end
			end
			if worldMapDefine.isInNewTrial() then
				moveTypeName = i18n("common_text_008")
				if self.mapInstance.playerID <= 0 then
					self.mapInstance.playerName = i18n("devilvalley_text_20")
				end
			end
		elseif instanceName == "collectSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_482")
			end
			local isATbuilding = self.mapInstance.userData.toObjectType == gMapObjTypeDef.mapTypeATBuilding
			if isATbuilding then
				moveTypeName = i18n("allitreas_btn_05")
			end
		elseif instanceName == "detectionSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_007")
			end
		elseif instanceName == "tradeSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_483")
			end
		elseif instanceName == "romanSoulSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_481")
			end
		elseif instanceName == "getChestSolider" then
			if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_677")
			end
		elseif instanceName == "escortSolider" then
			if self.mapInstance.userData.fromObjectType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
				buttonTypeArray, _ENV = self.mapInstance.userData.fromObjectType, self.mapInstance.userData.fromObjectType
			elseif selfLeagueID == self.mapInstance.leagueID then
				if self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
					moveTypeName = i18n("common_text_677")
					if self.isSelfKindom then
						_ENV = "allitreas_btn_05"
						;("allitreas_btn_05").buttonType = worldMapDefine.worldMapTipButtonType_yuanzhujiacheng
						;("allitreas_btn_05").data = moveLineData
						table.insert(buttonTypeArray, "allitreas_btn_05")
					end
					_ENV = "allitreas_btn_05"
					;("allitreas_btn_05").buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
					;("allitreas_btn_05").data = moveLineData
					table.insert(buttonTypeArray, "allitreas_btn_05")
					if self.isSelfKindom then
						_ENV = "allitreas_btn_05"
						;("allitreas_btn_05").buttonType = worldMapDefine.worldMapTipButtonType_buDui
						;("allitreas_btn_05").data = moveLineData
						table.insert(buttonTypeArray, "allitreas_btn_05")
					end
				end
			elseif self.mapInstance.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
				moveTypeName = i18n("common_text_677")
				moveLineData.leagueID = self.mapInstance.leagueID
				if self.isSelfKindom then
					_ENV = "allitreas_btn_05"
					;("allitreas_btn_05").buttonType = worldMapDefine.worldMapTipButtonType_lueduo
					;("allitreas_btn_05").data = moveLineData
					table.insert(buttonTypeArray, "allitreas_btn_05")
				end
				_ENV = "allitreas_btn_05"
				;("allitreas_btn_05").buttonType = worldMapDefine.worldMapTipButtonType_yuanzhujiacheng
				;("allitreas_btn_05").data = moveLineData
				table.insert(buttonTypeArray, "allitreas_btn_05")
				if self.isSelfKindom then
					_ENV = "allitreas_btn_05"
					;("allitreas_btn_05").buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
					;("allitreas_btn_05").data = moveLineData
					table.insert(buttonTypeArray, "allitreas_btn_05")
					_ENV = "allitreas_btn_05"
					;("allitreas_btn_05").buttonType = worldMapDefine.worldMapTipButtonType_buDui
					;("allitreas_btn_05").data = moveLineData
					table.insert(buttonTypeArray, "allitreas_btn_05")
				end
			end
		end
		local _, leftTime = self.mapInstance:getMapMoveDataArray()
		local timerLabel = include("timerLabel").new(self.tilePointText)
		timerLabel:beginTime(leftTime)
	end
	if instanceName == "romanSoulSolider" then
		if worldMapDefine.isRemainsKingdomID(self.kingdomID) then
			self.playerNameLable:setString(i18n("remains_text_157"))
		elseif worldMapDefine.isNewTrialKingdomID(self.kingdomID) then
			self.playerNameLable:setString(i18n("devilvalley_text_20"))
		elseif worldMapDefine.isInWar() then
			self.playerNameLable:setString(i18n("common_text_3387"))
		else
			self.playerNameLable:setString(i18n("common_text_1222"))
		end
		self.playerNameLable:setVisible(true)
		self.playerNameBg:setVisible(true)
	elseif instanceName == "commandHallSolider" then
		moveTypeName = i18n("common_text_481")
		local commandHallRead = include("commandHallRead")
		local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
		local task = commandHallCtrl:getArmyGroupTaskData()
		if task ~= nil then
			local taskName = commandHallRead.getTaskName(task.taskID)
			self.playerNameLable:setString(taskName)
			self.playerNameLable:setVisible(true)
			self.playerNameBg:setVisible(true)
		else
			self.playerNameLable:setVisible(false)
			self.playerNameBg:setVisible(false)
		end
		self.btn_share:setVisible(false)
	elseif instanceName == "escortSolider" then
		if self.mapInstance.userData.fromObjectType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
			buttonTypeArray, _ENV = self.mapInstance.userData.fromObjectType, self.mapInstance.userData.fromObjectType
			local pyramidBuildingRead = include("pyramidBuildingRead")
			self.playerNameBg:setVisible(true)
			local camp = self.mapInstance.userData.camp
			self.playerNameLable:setString(pyramidBuildingRead.getWarCampName(camp))
			self.playerNameLable:setVisible(true)
			moveTypeName = ""
			self.tilePointText:endTime()
			self.tilePointText:setPositionY(-142)
			self:updateTilePoint(true)
			self.frameProtectTime:setVisible(true)
			local label_pTime = self.frameProtectTime:getChildByName("Text_pTime")
			_ENV = pyramidBuildingRead.getWarCampName(camp)
			pyramidBuildingRead.getWarCampName(camp).time = ""
			label_pTime:setString(i18n("pyramid_text_128", pyramidBuildingRead.getWarCampName(camp)))
			local label_remainTime = self.frameProtectTime:getChildByName("Text_remainTime")
			label_remainTime = SoraDCreateTimerLabel(self, label_remainTime)
			local leftTime = self.mapInstance.userData.statusEndTime - serviceFunctions.systemTime()
			if 0 < leftTime then
				label_remainTime:beginTime(leftTime)
			end
			local len = label_pTime:getContentSize().width + label_remainTime:getContentSize().width
			local centerX = self.frameProtectTime:getContentSize().width / 2
			if SoraDFIsRA() then
				label_remainTime:setPositionX(centerX + (label_remainTime:getContentSize().width - len / 2) - 10)
				label_pTime:setPositionX(label_remainTime:getPositionX() + 20)
			else
				label_pTime:setPositionX(centerX + (label_pTime:getContentSize().width - len / 2) - 10)
				label_remainTime:setPositionX(label_pTime:getPositionX() + 20)
			end
		elseif self.mapInstance.moveLineType == gMapMoveLineType.moveLineTypeNebulaWarMineScore then
			buttonTypeArray, _ENV = self.mapInstance.moveLineType, self.mapInstance.moveLineType
			moveTypeName = i18n("nebula_war_text_0538")
			self.playerNameBg:setVisible(true)
			self.tilePointText:endTime()
			self:updateTilePoint(true)
			local timeLabel = SoraDCreateTimerLabel(self, self.playerNameLable)
			timeLabel:setVisible(true)
			timeLabel:setTimeLast(function(ticket)
				return i18n("nebula_war_text_0561") .. ticket
			end)
			local _, leftTime = self.mapInstance:getMapMoveDataArray()
			timeLabel:beginTime(leftTime)
			local bgSize = self.playerNameBg:getContentSize()
			local bgWidth = math.max(timeLabel:getContentSize().width + 50, bgSize.width)
			self.playerNameBg:setContentSize(cc.size(bgWidth, bgSize.height))
		elseif not self:setMovePlayerName() then
			self:addMovelineMessage()
			self:requestMovelineInfo()
		end
	elseif instanceName == "nebulaDefenceSolider" then
		print("nebulaDefenceSolider ===== ")
		moveTypeName = i18n("Celestial_defense_text_076")
		self.btn_share:setVisible(false)
	elseif instanceName == "nebulaAllStarSpoil" then
		print("nebulaDefenceSolider ===== ")
		moveTypeName = ""
		self.tilePointText:setPositionY(-142)
	elseif not self:setMovePlayerName() then
		self:addMovelineMessage()
		self:requestMovelineInfo()
	end
	if moveTypeName ~= "" then
		self.tilePointText:setPositionY(-152)
	end
	self.moveTypeNameLable:setVisible(true)
	self.moveTypeNameLable:setString(moveTypeName)
	self:createButtons(buttonTypeArray)
end
function worldMapTip:setMovePlayerName()
	local bRet = false
	if self.mapInstance.playerName then
		local textName = self.mapInstance.playerName
		local leagueName = self.mapInstance.leagueName
		if leagueName then
			textName = "(" .. leagueName .. ")" .. textName
		end
		if self.mapInstance.sourceID > 0 then
			textName = textName .. "#" .. self.mapInstance.sourceID
		end
		self.playerNameLable:setVisible(true)
		self.playerNameBg:setVisible(true)
		self.playerNameLable:setString(textName)
		bRet = true
	else
		self.playerNameLable:setVisible(false)
		self.playerNameBg:setVisible(false)
	end
	return bRet
end
function worldMapTip:createInstanceTipButtons()
	self:updateFavoriteInfo()
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local instanceType = self.mapInstance:getInstanceType()
	if instanceType == gMapObjTypeDef.mapObjTypeResource then
		local playerID = self.mapInstance.playerID or 0
		self.tilePointText:setPositionY(-152)
		self.resourceIconImg:setVisible(true)
		local iconName = worldMapDefine.getResourceIconName(self.mapInstance.resourceClassID)
		self.resourceIconImg:setSpriteFrame(iconName)
		self.resourceCountText:setVisible(true)
		self.resourceCount = self.mapInstance.currentSourceNum or 0
		self.resourceCountText:setString(string.formatnumberthousands(math.ceil(self.resourceCount)))
		if playerID <= 0 then
			local curInstanceType = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("worldMapTip", "instanceType")
			if curInstanceType and curInstanceType == instanceType then
				gametop = string.formatnumberthousands(math.ceil(self.resourceCount))
				string.formatnumberthousands(math.ceil(self.resourceCount)).isTrue = true
				gModuleMgr.sharedMgr("mildGuideManager"):setVariate("worldMapView", string.formatnumberthousands(math.ceil(self.resourceCount)))
			end
		elseif self.isSelfKindom then
			self.playerNameBg:setVisible(true)
			self.playerNameLable:setVisible(true)
			local textName = self.mapInstance.playerName
			local leagueName = self.mapInstance.leagueName
			if leagueName then
				textName = "(" .. leagueName .. ")" .. textName
			end
			self.playerNameLable:setString(textName)
			if playerID == selfPlayerID then
				self.playerNameBg:setVisible(false)
				self.playerNameLable:setVisible(false)
			end
		end
		local resType = worldMapDefine.getResourceType(self.mapInstance.resourceClassID)
		if resType <= 5 then
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			if 0 < playerID and playerID ~= selfPlayerID and guideCtrl:isGuideNotCompleted(gGuideModule.WORLD_GATHER) then
				guideCtrl:updateGuideModule(gGuideModule.WORLD_GATHER)
			end
			if playerID <= 0 and guideCtrl:isGuideNotCompleted(gGuideModule.WORLD_GATHER2) then
				guideCtrl:updateGuideModule(gGuideModule.WORLD_GATHER2)
			end
		end
	elseif instanceType == gMapObjTypeDef.mapObjTypeSuperResource then
		if self.mapInstance.allianceResourceState == gMapObjStateTypeDef.gMapObjStateTypeFree then
			self.resourceCountText:setAnchorPoint(cc.p(0.5, 0.5))
			self.resourceCountText:setPositionX(0)
			local timeCount = self.mapInstance.leftTime - serviceFunctions.systemTime()
			self.tilePointText:setPositionY(-152)
			self.resourceCountText:setVisible(true)
			self.resourceCountText = SoraDCreateTimerLabel(self, self.resourceCountText)
			self.resourceCountText:beginTime(timeCount)
		end
		if self.mapInstance.allianceResourceState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
			self.tilePointText:setPositionY(-152)
			self.resourceIconImg:setVisible(true)
			self.resourceIconImg:setSpriteFrame("icon_alliance_mineral_chuizi.png")
			self.resourceCountText:setVisible(true)
			self.resourceCount = self.mapInstance:getBuildPoint()
			self.resourceCountText:setString(string.formatnumberthousands(math.ceil(self.resourceCount)))
		end
	elseif instanceType == gMapObjTypeDef.mapObjTypeCampsite or instanceType == gMapObjTypeDef.mapObjTypeTreasure then
		local playerID = self.mapInstance.playerID or 0
		if playerID ~= selfPlayerID and self.isSelfKindom then
			self.playerNameBg:setVisible(true)
			self.playerNameLable:setVisible(true)
			local leagueName = self.mapInstance.leagueName
			if leagueName then
				self.playerNameLable:setString("(" .. leagueName .. ")" .. self.mapInstance.playerName)
			else
				self.playerNameLable:setString(self.mapInstance.playerName)
			end
		end
	elseif instanceType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		local selfLeagueID = allianceMgr:getOwnTeamID() or 0
		if gMapAllianceBuildType.subTypeAllianceAltar == self.mapInstance:getBuildClassID() and selfLeagueID == self.mapInstance.leagueID then
			local timeCD = 0
			local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
			local timeCD = alliancePetCtrl:getAlliancePetTimeCD()
			if 0 < timeCD then
				self.tilePointText:setPositionY(-152)
				self.resourceCountText:setAnchorPoint(cc.p(0.5, 0.5))
				self.resourceCountText:setPositionX(0)
				self.resourceCountText:setVisible(true)
				self.resourceCountText = SoraDCreateTimerLabel(self, self.resourceCountText)
				self.resourceCountText:beginTime(timeCD)
				self.resourceCountText:setTimeEndListener(function()
					self.tilePointText:setPositionY(-140)
					self.resourceCountText:setVisible(false)
				end)
			end
		end
	elseif instanceType == gMapObjTypeDef.mapObjTypePlayer then
		local instanceKID = self.mapInstance:getSourceKingdomID()
		if instanceKID and 0 < instanceKID then
			self.instanceKID = instanceKID
		end
	elseif instanceType == gMapObjTypeDef.roaringFlameWarBuilding then
		self:initRoaringFlameWarBuilding()
	end
	if not _WaitingDataObjs[instanceType] then
		local buttonTypeArray = self.mapInstance:getInstanceOp(self.isSelfKindom, self.isInWar)
		if buttonTypeArray and 0 < #buttonTypeArray then
			self:createButtons(buttonTypeArray)
		end
	end
end
function worldMapTip:requestInstanceInfo()
	if self.mapInstance and not self.mapInstance.ignoreRequest then
		local tilePoint = self.mapInstance:getTilePoint()
		local instanceID = self.mapInstance:getInstanceID()
		local kingdomID = self.mapInstance:getWorldMapCell().kingdomID
		kingdomMapCtrl:reqMapObjInfo(tilePoint.x, tilePoint.y, instanceID, kingdomID)
	end
	if self.mapInstance then
		print("==worldMapTip:requestInstanceInfo=instanceID= \n", self.mapInstance:getInstanceID())
	end
end
function worldMapTip:serverMessage_RequestMapInstaceInfo(target, data)
	dump(data, "worldMapTip:serverMessage_RequestMapInstaceInfo===", 10)
	if not (data and data.data) or not next(data.data) then
		return
	end
	if not self.mapInstance or not self.mapInstance.__cname then
		return
	end
	local instanceType = self.mapInstance:getInstanceType()
	if _WaitingDataObjs[instanceType] then
		local buttonTypeArray = self.mapInstance:getInstanceOp(self.isSelfKindom, self.isInWar, data)
		if buttonTypeArray and 0 < #buttonTypeArray then
			self:createButtons(buttonTypeArray)
		end
	end
	local _ENV, tipButtonData = buttonTypeArray, self.mapInstance:getInstanceOp(self.isSelfKindom, self.isInWar, data)
	local dataKey = instanceFactory.getInstanceDataKey(instanceType)
	if dataKey then
		tipButtonData, _ENV = data.data[dataKey], data.data[dataKey]
		tipButtonData = data.data[dataKey] or self.mapInstance:getInstanceOp(self.isSelfKindom, self.isInWar, data)
	end
	if tipButtonData.antiDuelTime then
		tipButtonData.antiDuelTimeFin = serviceFunctions.systemTime() + tipButtonData.antiDuelTime
	end
	if instanceType == gMapObjTypeDef.mapObjTypeResource then
		if tipButtonData then
			self.resourceCountText:setVisible(true)
			self.resourceCount = tipButtonData.currentSourceNum or 0
			self.resourceCountText:setString(string.formatnumberthousands(math.ceil(self.resourceCount)))
			if tipButtonData.collectData then
				self.collectSpanArray = tipButtonData.collectData
				self.collectTimer = SoradCreateTimer(self, handler(self, self.updateResourceCount), true)
			end
		end
		self.mapInstance.currentSourceNum = self.resourceCount
	elseif instanceType == gMapObjTypeDef.mapObjTypeSuperResource then
		self.resourceCountText:setVisible(true)
		self.resourceCount = tipButtonData.buildPoint or 0
		self.resourceCountText:setString(string.formatnumberthousands(math.ceil(self.resourceCount)))
	elseif instanceType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		local selfLeagueID = allianceMgr:getOwnTeamID() or 0
		if self.mapInstance.battleState == gMapObjStateTypeDef.gMapObjStateTypeWorking and selfLeagueID == self.mapInstance.leagueID then
			self.tilePointText:setPositionY(-152)
			self.resourceIconImg:setVisible(true)
			self.resourceCountText:setVisible(true)
			if tipButtonData.buildSpeed and 0 < tipButtonData.buildSpeed then
				self.resourceIconImg:setSpriteFrame("icon_alliance_mineral_chuizi.png")
				self.resourceCountText = SoraDCreateTimerLabel(self, self.resourceCountText)
				self.resourceCountText:setTimeUpdateListener(function(time)
					self.resourceCountText:setString(string.formatnumberthousands(math.floor(tipButtonData.totalPoint - time * tipButtonData.buildSpeed)))
				end)
				self.resourceCountText:beginTime(tipButtonData.buildFinishTime - serviceFunctions.systemTime())
			else
				self.resourceIconImg:setSpriteFrame("icon_alliance_mineral_chuizi.png")
				if tipButtonData.totalPoint then
					self.resourceCountText:setString(string.formatnumberthousands(math.floor(tipButtonData.totalPoint - tipButtonData.surplusPoint)))
				end
			end
		end
	elseif instanceType == gMapObjTypeDef.mapTypeATBuilding then
		if self.mapInstance.treasureState == gATBuildingStatus.AT_MINNING then
			self.tilePointText:setPositionY(-152)
			self.resourceCountText:setVisible(true)
			self.resourceIconImg:setVisible(true)
			self.resourceIconImg:setSpriteFrame("8218.png")
			self.resourceIconImg:setScale(0.2)
			self.wajueCount, self.wajueSpeed, self.wajueLeftTime = ancientTreasureCtrl:getWajueValue(data.data.data)
			if 0 < self.wajueCount and 0 < self.wajueSpeed and 0 < self.wajueLeftTime then
				self.resourceCountText:setString(string.formatnumberthousands(self.wajueCount))
				self.wajueTimer = SoradCreateTimer(self, handler(self, self.updateWajueCount), true)
			else
				self.resourceCountText:setString(string.formatnumberthousands(self.wajueCount))
			end
		else
			self.resourceCountText:setVisible(false)
		end
	elseif instanceType == gMapObjTypeDef.mapTypeFireTreasure then
		self.playerNameLable:setVisible(true)
		self.playerNameBg:setVisible(true)
		self.resourceCountText:setVisible(true)
		self.resourceCount = tipButtonData.remainNum or 0
		self.resourceCountText:setString(string.formatnumberthousands(math.ceil(self.resourceCount)))
		self.resourceIconImg:setVisible(true)
		self.resourceIconImg:setSpriteFrame("8265.png")
		self.resourceIconImg:setScale(0.2)
		self.tilePointText:setPositionY(-152)
		self.playerNameBg_Tmp = self.playerNameBg:clone()
		self.playerNameBg_Tmp:setPosition(cc.p(0, -37))
		self:addChild(self.playerNameBg_Tmp, 999)
		self.playerNameLable_Tmp = self.playerNameLable:clone()
		self:addChild(self.playerNameLable_Tmp, 999)
		self.playerNameLable_Tmp:setPosition(cc.p(0, -39))
		self.playerNameBg_Tmp:setVisible(true)
		self.playerNameLable_Tmp:setVisible(true)
		local textName = self.mapInstance.playerName
		local leagueName = self.mapInstance.leagueName
		if leagueName then
			textName = "(" .. leagueName .. ")" .. textName
		end
		self.playerNameLable_Tmp:setString(textName)
		if self.mapInstance.treasureState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
			self.playerNameLable = SoraDCreateTimerLabel(self, self.playerNameLable)
			dump(self.mapInstance, "worldmaptip -- self.mapInstance", 20)
			local timeCount = self.mapInstance.digEndTime - serviceFunctions.systemTime()
			self.playerNameLable:beginTime(timeCount)
			self.playerNameLable:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n("common_text_766", nil)
			end)
		else
			_ENV = cc.p(0, -39)
			cc.p(0, -39).time = os.date("00:%M:%S", self.mapInstance.digTime)
			self.playerNameLable:setString(i18n("common_text_766", cc.p(0, -39)))
		end
	elseif instanceType == gMapObjTypeDef.mapTypeWarTreasure then
		self.resourceCountText:setVisible(true)
		self.resourceIconImg:setVisible(true)
		self.resourceIconImg:setSpriteFrame((worldMapDefine.getWarTreasureBuildingIcon(self.mapInstance.resourceClassID)))
		self.resourceIconImg:setScale(0.27)
		self.tilePointText:setPositionY(-152)
		if tipButtonData and tipButtonData.outputSpeed then
			self.wajueSpeed = tipButtonData.outputSpeed / 60
			local beginTime = tipButtonData.collStartTime or serviceFunctions.systemTime()
			self.wajueCount = tipButtonData.remainNum - (serviceFunctions.systemTime() - beginTime) * self.wajueSpeed
		end
		if self.mapInstance.playerName then
			self.playerNameBg:setVisible(true)
			self.playerNameLable:setVisible(true)
			self.resourceCountText:setString(string.formatnumberthousands(self.wajueCount))
			self.wajueTimer = SoradCreateTimer(self, handler(self, self.updateWajueCount), true)
		else
			self.resourceCountText:setString(string.formatnumberthousands(self.wajueCount))
		end
		local textName = self.mapInstance.playerName
		local leagueName = self.mapInstance.leagueName
		if leagueName then
			textName = "(" .. leagueName .. ")" .. textName
		end
		self.playerNameLable:setString(textName)
	elseif instanceType == gMapObjTypeDef.stronghold then
		if tipButtonData and data.data and data.data.data then
			tipButtonData.leftAttackNpcCount = data.data.data.leftAttackNpcCount
			tipButtonData.attackNpcCountRecoverTime = data.data.data.attackNpcCountRecoverTime
		end
	elseif instanceType == gMapObjTypeDef.mapObjTypeBoss then
		local timeCount = (data.data.boss and data.data.boss.leftTime or 0) - serviceFunctions.systemTime()
		if 0 < timeCount then
			local label_pTime = self.frameProtectTime:getChildByName("Text_pTime")
			label_pTime:setVisible(false)
			local label_remainTime = self.frameProtectTime:getChildByName("Text_remainTime")
			label_remainTime:setAnchorPoint(cc.p(0.5, 0.5))
			label_remainTime:setPosition(cc.p(self.frameProtectTime:getContentSize().width / 2, 20))
			label_remainTime = SoraDCreateTimerLabel(self, label_remainTime)
			label_remainTime:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n("Phonex_Challenge_text_23", nil)
			end)
			label_remainTime:beginTime(timeCount)
			self.frameProtectTime:setVisible(true)
		else
			self.frameProtectTime:setVisible(false)
		end
	end
	for _, v in pairs(self.tipButtonsArray) do
		v.tipButtonData = tipButtonData
	end
end
function worldMapTip:createButtons(buttonsArray)
	if not buttonsArray or #buttonsArray < 1 then
		SoraDGetChildByName(self, "Image_circle"):setVisible(false)
		return
	end
	local tilePoint = self.tilePoint
	if self.mapInstance and self.mapInstance.tilesArray then
		tilePoint = self.mapInstance:getTilePoint()
	end
	if buttonsArray[1].buttonType == worldMapDefine.worldMapTipButtonType_renMing or buttonsArray[1].buttonType == worldMapDefine.worldMapTipButtonType_lianmengqizhi then
		local buttonData = buttonsArray[1]
		local tipButtonCell = include("worldMapTipButton").new()
		tipButtonCell:initData(buttonData, self.mapInstance, tilePoint, self.instanceKID)
		tipButtonCell:setPosition(cc.p(0, 0))
		self:addChild(tipButtonCell, 1)
		table.remove(buttonsArray, 1)
	end
	local buttonCount = #buttonsArray
	local zOrderRaw = math.floor(buttonCount * 0.5)
	local beginAngle = 0
	local radius = 165
	if 6 <= buttonCount then
		beginAngle = -22.5
		radius = 175
	elseif 5 <= buttonCount then
		beginAngle = 0
		radius = 170
	end
	for i = 0, buttonCount - 1 do
		local angle = beginAngle + i * (180 - 2 * beginAngle) / (buttonCount - 1)
		if buttonCount == 1 then
			angle = 90 - beginAngle
		end
		local radian = math.angle2radian(angle)
		local pointX = radius * math.cos(radian)
		local pointY = radius * math.sin(radian)
		local buttonData = buttonsArray[i + 1]
		local tipButtonCell = include("worldMapTipButton").new()
		tipButtonCell:initData(buttonData, self.mapInstance, tilePoint, self.instanceKID)
		tipButtonCell:setPosition(cc.p(0, 0))
		local zOrder = math.abs(pointY / 10 - zOrderRaw)
		self:addChild(tipButtonCell, math.abs(zOrder) + 1)
		self.tipButtonsArray[#self.tipButtonsArray + 1] = tipButtonCell
		local easeAction = cc.EaseBackOut:create(cc.MoveTo:create(0.25, cc.p(pointX, pointY)))
		tipButtonCell:runAction(easeAction)
	end
	self:endShow()
end
function worldMapTip:updateWajueCount(dt)
	self.wajueCount = self.wajueCount - self.wajueSpeed * dt
	if self.wajueCount < 0 then
		self.wajueCount = 0
		SoraDManagerRemoveTimer(self, self.wajueTimer)
	end
	self.resourceCountText:setString(string.formatnumberthousands(math.ceil(self.wajueCount)))
end
function worldMapTip:updateResourceCount(dt)
	self.resourceCount = self.resourceCount - self.collectSpeed * dt
	if self.resourceCount < 0 then
		self.resourceCount = 0
		SoraDManagerRemoveTimer(self, self.collectTimer)
	end
	self.collectSpanTime = self.collectSpanTime - dt
	if 0 > self.collectSpanTime then
		self.collectSpanIndex = self.collectSpanIndex + 1
		if self.collectSpanIndex <= #self.collectSpanArray then
			local collectSpanData = self.collectSpanArray[self.collectSpanIndex]
			self.collectSpanTime = collectSpanData.costTime
			self.resourceCount = collectSpanData.currentSourceNum
			self.collectSpeed = collectSpanData.currentCollectSpeed / 3600
		else
			SoraDManagerRemoveTimer(self, self.collectTimer)
		end
	end
	self.resourceCountText:setString(string.formatnumberthousands(math.ceil(self.resourceCount)))
end
function worldMapTip:setWorldMapCell(worldMapCell)
	self.worldMapCell = worldMapCell
end
function worldMapTip:getWorldMapCell()
	return self.worldMapCell
end
function worldMapTip:setTilePoint(tilePoint, tilePointShow)
	self.tilePoint = tilePoint
	if tilePointShow then
		self.tilePointShow = tilePointShow
	else
		self.tilePointShow = self.tilePoint
	end
end
function worldMapTip:getTilePoint()
	return self.tilePoint
end
function worldMapTip:setFavoriteName(favoriteName)
	local tilePointString = "X:" .. math.floor(tonumber(self.tilePointShow.x)) .. ",Y:" .. math.floor(tonumber(self.tilePointShow.y))
	self.favoriteName = favoriteName or tilePointString
end
function worldMapTip:setIsCanZhanling(isCanZhanling, msgTipsKey)
	self.isCanZhanling = isCanZhanling
	self.msgTipsKey = msgTipsKey
end
function worldMapTip:updateFavoriteInfo()
	if worldMapDefine.isInNewTrial() or worldMapDefine.isNebulaAllStarViewer(self.kingdomID) then
		self.buttonFavorites1:setVisible(false)
		self.buttonFavorites3:setVisible(false)
		self.buttonCopy:setVisible(false)
		self.imgCopyBg:setVisible(false)
		return
	end
	if worldMapDefine.isGardenKingdomID(self.kingdomID) then
		self.buttonFavorites1:setVisible(false)
		self.buttonFavorites3:setVisible(false)
		self.buttonCopy:setVisible(true)
		self.imgCopyBg:setVisible(true)
		return
	end
	if worldMapDefine.isInRoaringFlame() and self.mapInstance then
		local instanceType = self.mapInstance.instanceType
		if instanceType == gMapObjTypeDef.roaringFlameWarBox or instanceType == gMapObjTypeDef.roaringFlameWarCave then
			self.buttonFavorites1:setVisible(false)
			self.buttonFavorites3:setVisible(false)
			self.buttonCopy:setVisible(true)
			self.imgCopyBg:setVisible(true)
			return
		end
	end
	if collectMapCtrl:showAllianceMark(true) then
		self.buttonFavorites1:setVisible(true)
		local textureName = "btn_comon_coordinate.png"
		self.buttonFavorites1:loadTextures(textureName, textureName, textureName, ccui.TextureResType.plistType)
		self.buttonFavorites3:setVisible(false)
	else
		local isCollect = collectMapCtrl:isCollect(self.kingdomID, math.floor(tonumber(self.tilePointShow.x)), math.floor(tonumber(self.tilePointShow.y)))
		if isCollect then
			self.buttonFavorites1:setVisible(false)
			self.buttonFavorites3:setVisible(true)
		else
			self.buttonFavorites1:setVisible(true)
			self.buttonFavorites3:setVisible(false)
		end
	end
	self.buttonCopy:setVisible(true)
	self.imgCopyBg:setVisible(true)
end
function worldMapTip:buttonFavoritesCall(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV, _ENV = nil, nil
		;(nil).type = gCollectType.favorite
		_ENV, (nil).name = self.favoriteName, self.favoriteName
		self.favoriteName.x = math.floor(tonumber(self.tilePointShow.x))
		self.favoriteName.y = math.floor(tonumber(self.tilePointShow.y))
		;(nil).pos, self.favoriteName.k = self.favoriteName, self.kingdomID
		;(nil).markData, (nil).showAllianceMark = nil, collectMapCtrl:showAllianceMark(true)
		;(nil).title = i18n("common_text_641")
		uiManager:show("WorldMapBookMarkPop", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(uiManager)
	end
end
function worldMapTip:buttonCopyCall(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tilePointString
		if worldMapDefine.isWarKingdomID(self.kingdomID) then
			tilePointString = "X:" .. math.floor(tonumber(self.tilePointShow.x)) .. ",Y:" .. math.floor(tonumber(self.tilePointShow.y))
		else
			tilePointString = "K:" .. self.kingdomID .. ",X:" .. math.floor(tonumber(self.tilePointShow.x)) .. ",Y:" .. math.floor(tonumber(self.tilePointShow.y))
		end
		SoraDCopyText(tilePointString)
		SoraDShowMsgTip(i18n("common_text_2085"))
	end
end
function worldMapTip:buttonShareCall(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV, _ENV = nil, nil
		;(nil).x = math.floor(tonumber(self.tilePointShow.x))
		;(nil).y = math.floor(tonumber(self.tilePointShow.y))
		;(nil).mapInstance = self.mapInstance
		;(nil).mapData, (nil).kingdomID = nil, self.kingdomID
		uiManager:show("worldMapCordinateShareView", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(uiManager)
	end
end
function worldMapTip:buttonTilePointCall(button, type)
	if type == ccui.TouchEventType.ended then
		if not self.mapInstance or not self.mapInstance.getMoveLineID then
			return
		end
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPTIP"
		;(nil).moveLineID = self.mapInstance:getMoveLineID()
		SoraDSendMessage(nil)
		SoraDGotoWorldMapPoint(self.tilePoint, false)
	end
end
function worldMapTip:showProtectionTime(target, data)
	if not self.mapInstance then
		return
	end
	if worldMapDefine.isInNewTrial() or worldMapWarDef.isInWarForbidShowSafe() then
		return
	end
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffData = buffCtrl:queryCityBuff(gBuffEffect.PEACE_SHIELD)
	local playerID = self.mapInstance.playerID or 0
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local protectTime = kingdomMapCtrl:getMaintProtectTime()
	if buffData then
		protectTime = buffData:getRemainTime()
	end
	if (buffData or 0 < protectTime) and playerID == selfPlayerID and "worldMapBuilding" == self.mapInstance.__cname then
		self.frameProtectTime:setVisible(true)
		local label_pTime = self.frameProtectTime:getChildByName("Text_pTime")
		label_pTime:setString(i18n("common_text_2030") .. ":")
		local label_remainTime = self.frameProtectTime:getChildByName("Text_remainTime")
		label_remainTime = SoraDCreateTimerLabel(self, label_remainTime)
		label_remainTime:beginTime(protectTime)
		local len = label_pTime:getContentSize().width + label_remainTime:getContentSize().width
		local centerX = self.frameProtectTime:getContentSize().width / 2
		if SoraDFIsRA() then
			label_remainTime:setPositionX(centerX + (label_remainTime:getContentSize().width - len / 2) - 10)
			label_pTime:setPositionX(label_remainTime:getPositionX() + 20)
		else
			label_pTime:setPositionX(centerX + (label_pTime:getContentSize().width - len / 2) - 10)
			label_remainTime:setPositionX(label_pTime:getPositionX() + 20)
		end
		if self.mapInstance.fireWorkTimeNode then
			self.mapInstance.fireWorkTimeNode:setPositionY(-240)
		end
	else
		self.frameProtectTime:setVisible(false)
	end
end
function worldMapTip:onExitPanel()
	if self.mapInstance and self.mapInstance.fireWorkTimeNode then
		self.mapInstance.fireWorkTimeNode:setPositionY(-120)
	end
	if self.mapInstance and self.mapInstance.setIsOnClick then
		self.mapInstance:setIsOnClick(false)
	end
end
function worldMapTip:initInstanceData(mapInstance)
	self.mapInstance = mapInstance
	self:updateTilePoint()
	self:showProtectionTime()
	self:showAtlantisWarState()
	self:showNebulaAllStarState()
	self:createInstanceTipButtons()
	self:addMessage()
	self:requestInstanceInfo()
	if worldMapDefine.isNebulaAllStarViewer(self.kingdomID) then
		local instanceType = self.mapInstance.instanceType
		local subType = self.mapInstance.subType
		if instanceType == gMapObjTypeDef.nebulaAllStarWarBuilding and subType == gWorldTypeServerDef.subTypeNebulaAllStarViewerSpoil then
			self.btn_share:setVisible(true)
		else
			self.btn_share:setVisible(false)
		end
	end
end
function worldMapTip:initMapData(mapInstance)
	self.mapInstance = mapInstance
	self:updateTilePoint()
	self:updateFavoriteInfo()
	local worldMapDefine, buttonTypeArray = self.updateFavoriteInfo, self.updateFavoriteInfo
	local worldMapDefine, atlantis = self, self
	if worldMapDefine.isInAtlantis() then
		atlantis = atlantisWarUtil.checkAreaState(self.tilePoint)
	end
	if self.isSelfKindom then
		if worldMapDefine.isInAtlantis() then
			local msgTipsKey = atlantis.clickZhanlingTips or atlantis.clickTips
			worldMapDefine = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhanLing
			;(nil).isButtonEnabled = atlantis.isCanZhanling
			;(nil).msgTipsKey = msgTipsKey
			table.insert(buttonTypeArray, nil)
		elseif worldMapWarDef.isInWarShowZhanLing() then
			worldMapDefine = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_zhanLing
			buttonTypeArray.isButtonEnabled = self.isCanZhanling
			buttonTypeArray.msgTipsKey = self.msgTipsKey
			table.insert(buttonTypeArray, buttonTypeArray)
		end
		local soruceKid = lordInfoCtrl:getSourceKid()
		local isPyramidMap = worldMapDefine.isInWar()
		if soruceKid == 0 and not isPyramidMap then
			local uid = gametop.playertop_:getPlayerID()
			local isPermission = permissionCtrl:hasPlayerPermission(gAPermission.SET_BUILDING, uid)
			if isPermission then
				worldMapDefine = permissionCtrl
				local permissionCtrl.tilePoint, spaceData = self.tilePoint, permissionCtrl
				worldMapDefine = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fangzhi
				;(nil).data = spaceData
				table.insert(buttonTypeArray, nil)
			end
			local selfLeagueID = allianceMgr:getOwnTeamID() or 0
			if 0 < selfLeagueID then
				worldMapDefine = worldMapDefine.worldMapTipButtonType_fangzhi
				worldMapDefine.worldMapTipButtonType_fangzhi.buttonType = worldMapDefine.worldMapTipButtonType_lianmengqizhi
				table.insert(buttonTypeArray, 1, worldMapDefine.worldMapTipButtonType_fangzhi)
				local isCanLeagueTransfer = true
				local currentScene = display.getRunningScene()
				if currentScene.name == "MainScene" then
					local currentView = currentScene:currentSceneShowView()
					local isInLeagueManor = currentView:isInselfOrAllyLeagueManor(self.tilePoint, true)
					isCanLeagueTransfer = isInLeagueManor
				end
				worldMapDefine = currentView
				currentView.buttonType = worldMapDefine.worldMapTipButtonType_lingdiqianCheng
				currentView.isButtonEnabled = isCanLeagueTransfer
				table.insert(buttonTypeArray, currentView)
			end
			if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597) then
				local activity_9001597_Ctrl = SoraDGetCtrl("activity_9001597_Ctrl")
				dump(activity_9001597_Ctrl:getBuildData(), "activity_9001597_Ctrl:getBuildData()")
				if activity_9001597_Ctrl:getBuildData() == nil and activity_9001597_Ctrl:getIsCanBuildLand(self.tilePoint.x, self.tilePoint.y) and self.isCanZhanling then
					worldMapDefine = self.tilePoint.x
					self.tilePoint.x.buttonType = worldMapDefine.worldMapTipButtonType_activity_9001597_create
					table.insert(buttonTypeArray, self.tilePoint.x)
				end
			end
		end
	end
	if not worldMapDefine.isPyramidViewer(self.kingdomID) and not worldMapDefine.isNebulaAllStarViewer(self.kingdomID) and not worldMapDefine.isGardenViewer(self.kingdomID) then
		if worldMapDefine.isInAtlantis() then
			local ret = atlantisWarUtil.checkAreaState(self.tilePoint)
			worldMapDefine = permissionCtrl:hasPlayerPermission(gAPermission.SET_BUILDING, uid)
			permissionCtrl:hasPlayerPermission(gAPermission.SET_BUILDING, uid).buttonType = worldMapDefine.worldMapTipButtonType_qianCheng
			permissionCtrl:hasPlayerPermission(gAPermission.SET_BUILDING, uid).isButtonEnabled = ret.isCanQiancheng
			permissionCtrl:hasPlayerPermission(gAPermission.SET_BUILDING, uid).msgTipsKey = ret.clickTips
			table.insert(buttonTypeArray, (permissionCtrl:hasPlayerPermission(gAPermission.SET_BUILDING, uid)))
		elseif worldMapDefine.isInNebulaAllStar() then
			local nebulaAllStarUtil = include("nebulaAllStarUtil")
			local isButtonEnabled, msgTipsKey
			local ok, err = nebulaAllStarUtil.checkIsCanTransfer(self.tilePoint)
			if not ok then
				isButtonEnabled = false
				msgTipsKey = nebulaAllStarUtil.getTransferErrorTip(err)
			end
			worldMapDefine = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_qianCheng
			buttonTypeArray.isButtonEnabled = isButtonEnabled
			buttonTypeArray.msgTipsKey = msgTipsKey
			table.insert(buttonTypeArray, buttonTypeArray)
		elseif worldMapDefine.isInGarden() and worldMapDefine.isGardenKingdomID(self.kingdomID) then
			local manorCityUtil = include("manorCityUtil")
			local ok, noShowTransfer = manorCityUtil.checkIsCanTransfer(self.tilePoint)
			if not noShowTransfer then
				worldMapDefine = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_garden_qianCheng
				table.insert(buttonTypeArray, table.insert)
			end
		elseif worldMapWarDef.isInWarShowQianCheng() then
			worldMapDefine = manorCityUtil.checkIsCanTransfer(self.tilePoint)
			manorCityUtil.checkIsCanTransfer(self.tilePoint).buttonType = worldMapDefine.worldMapTipButtonType_qianCheng
			table.insert(buttonTypeArray, manorCityUtil.checkIsCanTransfer(self.tilePoint))
		end
	end
	self:createButtons(buttonTypeArray)
	self:checkShowRemainsWarTip()
	self:checkShowAtlantisWarArea()
	self:checkShowRoaringFlameArea()
	if worldMapDefine.isNebulaAllStarViewer(self.kingdomID) then
		self.btn_share:setVisible(false)
	end
end
function worldMapTip:updateTilePoint(moveLine)
	local tilePointString
	if self.tilePointShow then
		tilePointString = math.floor(tonumber(self.tilePointShow.x)) .. " :X , " .. math.floor(tonumber(self.tilePointShow.y)) .. " :Y"
		if not SoraDFIsRA() then
			tilePointString = "X: " .. math.floor(tonumber(self.tilePointShow.x)) .. ",Y: " .. math.floor(tonumber(self.tilePointShow.y))
		end
		if moveLine then
			self.tilePointText:setString("To " .. tilePointString)
		else
			self.tilePointText:setString(tilePointString)
		end
	end
end
function worldMapTip:addMessage()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR", handler(self, self.showProtectionTime))
end
function worldMapTip:addMovelineMessage()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_MOVELINE_INFO", handler(self, self.serverMessage_RequestMoveLineInfo))
end
function worldMapTip:requestMovelineInfo()
	if self.mapInstance and not self.mapInstance.ignoreRequest then
		local kingdomID = self.kingdomID
		local queueId = self.mapInstance:getMoveLineID()
		local queue = kingdomMapCtrl.kingdomMapCell.localQueueMgr:getQueue(queueId)
		if queue and queue:getQueueType() == gMapMoveLineServerType.moveLineTypeEscortAssist and queue.data and queue.data.massId then
			queueId = queue.data.massId
		end
		kingdomMapCtrl:reqQueueMapData(kingdomID, queueId)
	end
end
function worldMapTip:serverMessage_RequestMoveLineInfo(target, data)
	if not (data and data.data) or not next(data.data) then
		return
	end
	if not self.mapInstance or not self.mapInstance.__cname then
		return
	end
	local moveLineData = data.data
	self.mapInstance.playerName = moveLineData.playerName or i18n("common_text_480")
	self.mapInstance.sourceID = moveLineData.sourceKid or 0
	self.mapInstance.leagueName = moveLineData.leagueName
	self.mapInstance.playerID = moveLineData.playerID
	local fromData = moveLineData.from
	if fromData then
		self.mapInstance.armyData = fromData.army
		if fromData.assistArmy then
			self.mapInstance.assistArmy = fromData.assistArmy
		end
	end
	if self.mapInstance.__cname == "tradeSolider" and self.mapInstance.userData and self.mapInstance.userData.fromObjectType == gMapObjTypeDef.mapTypeMine then
		self.mapInstance.playerName = nil
	end
	self:setMovePlayerName()
	_ENV = self.setMovePlayerName
	self.setMovePlayerName.moveLineID = self.mapInstance:getMoveLineID()
	local self.setMovePlayerName.armyData, tipButtonData = self.mapInstance:getArmyData(), self.setMovePlayerName
	if fromData.armyNum then
		tipButtonData.armyNum = fromData.armyNum
	end
	for _, v in pairs(self.tipButtonsArray) do
		v.tipButtonData = tipButtonData
	end
end
function worldMapTip:updateMapPos()
	if self.worldMapCell and self:getParent() then
		local partent = self:getParent()
		local showPoint = self.worldMapCell:getPointWithTile(self.tilePoint)
		local screenPoint = SoraDConvertoScreenPos2DOr3D(self.worldMapCell, showPoint)
		local coverShowPoint = partent:convertToNodeSpace(screenPoint)
		self:setPosition(coverShowPoint)
	end
end
function worldMapTip:checkShowRemainsWarTip()
	if not worldMapDefine.isInRemains() then
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	local bossID = remainsWarUtil.checkIsInMonsterBuffAddArea(self.tilePointShow)
	if bossID and 0 < bossID then
		self:createRemainsWarTip(bossID)
	end
end
function worldMapTip:createRemainsWarTip(bossID)
	local remainsWarUtil = include("remainsWarUtil")
	local buffValue = remainsWarUtil.getBossBuffByID(bossID)
	local bossName = worldMapDefine.getWorldBossName(bossID)
	bossName = i18n(bossName)
	_ENV = nil
	;(nil).title = i18n("common_text_319")
	;(nil).value = buffValue
	local buffStr1 = i18n("common_text_1298", nil)
	_ENV = i18n("common_text_319")
	i18n("common_text_319").title = i18n("common_text_321")
	i18n("common_text_319").value = buffValue
	local buffStr2 = i18n("common_text_1298", (i18n("common_text_319")))
	local buffStr = buffStr1 .. "\n" .. buffStr2
	_ENV = "common_text_321"
	;("common_text_321").name = "BOSS"
	;("common_text_321").buffname = buffStr
	local name = i18n("remains_text_159", "common_text_321")
	local node = display.newNode()
	node:setPositionY(self.frameProtectTime:getPositionY())
	node:addTo(self)
	local image_name_bg = display.newSprite("#frame_map_18.png")
	image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	image_name_bg:setScaleY(1.5)
	image_name_bg:addTo(node)
	_ENV = image_name_bg
	image_name_bg.UILabelType = 2
	image_name_bg.text = name
	image_name_bg.size = 20
	local text_Name = cc.ui.UILabel.new(image_name_bg)
	text_Name:setHorizontalAlignment(SoraDFLabelR())
	text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	text_Name:addTo(node)
end
function worldMapTip:checkShowAtlantisWarArea(...)
	if not worldMapDefine.isInAtlantis() then
		return
	end
	local ret = atlantisWarUtil.checkAreaState(self.tilePoint)
	if not ret.isCanZhanling and ret.tipTips then
		local tipLabel = self.playerNameLable
		tipLabel:setVisible(true)
		tipLabel:setPositionY(-200)
		SoraDSetTextWidthHeight(tipLabel, cc.size(400, 50))
		tipLabel:setString(ret.tipTips)
		tipLabel:setColor(cc.c3b(200, 0, 0))
	end
end
function worldMapTip:showAtlantisWarState(...)
	if not self.mapInstance then
		return
	end
	if not worldMapDefine.isInAtlantis() then
		return
	end
	local instanceType = self.mapInstance:getInstanceType()
	if instanceType ~= gMapObjTypeDef.mapTypeAtlantisWarBuilding then
		return
	end
	local subType = self.mapInstance:getSubType()
	if subType ~= gWorldTypeServerDef.subMapTypeAtlantisWarBattery then
		return
	end
	local siteClassID = self.mapInstance:getSiteClassID()
	local tSubType = atlantisWarUtil.getTargetSubType(siteClassID)
	local stage
	if tSubType == gBossType.atlantisWarWlyn then
		stage = gAtlantisWarStageType.wlynReady
	elseif tSubType == gBossType.atlantisWarSd then
		stage = gAtlantisWarStageType.sdReady
	end
	local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
	local time = atlantisWarCtrl:getWarStageRemainTime(stage)
	if time <= 0 then
		return
	end
	local timeLabel = SoraDCreateTimerLabel(self, self.playerNameLable)
	timeLabel:setVisible(true)
	timeLabel:setPositionY(-200)
	SoraDSetTextWidthHeight(timeLabel, cc.size(400, 50))
	worldMapDefine = SoraDSetTextWidthHeight
	SoraDSetTextWidthHeight[gAtlantisWarStageType.wlynReady] = "atlantiswar_text_0065"
	local SoraDSetTextWidthHeight[gAtlantisWarStageType.sdReady], config = "atlantiswar_text_0081", SoraDSetTextWidthHeight
	local tipkey = stage and config[stage] or "atlantiswar_text_0068"
	timeLabel:setTimeLast(function(time)
		_ENV = nil
		;(nil).var = time
		return i18n(tipkey, nil)
	end)
	timeLabel:setTimeEndListener(function()
		timeLabel:setVisible(false)
	end)
	timeLabel:beginTime(time)
end
function worldMapTip:showNebulaAllStarState(...)
	if self.nebulaAllStarState then
		return
	end
	if not self.mapInstance then
		return
	end
	if not worldMapDefine.isInNebulaAllStar() then
		return
	end
	local instanceType = self.mapInstance:getInstanceType()
	if instanceType ~= gMapObjTypeDef.mapObjTypePlayer then
		return
	end
	local selfPlayerID = gametop.playertop_:getPlayerID()
	if selfPlayerID == self.mapInstance.playerID then
		return
	end
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	local remainTime = nebulaAllStarUtil.getAttackRemainTime(self.mapInstance.leagueID)
	if remainTime <= 0 then
		return
	end
	self.Node_1:setPositionY(-30)
	local node = self:createNodeLabel()
	node:setPositionY(-130)
	node:addTo(self)
	self.nebulaAllStarState = node
	local timeLabel = SoraDCreateTimerLabel(node, node.Text_name)
	timeLabel:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("NebulaAllstar_159", nil)
	end)
	timeLabel:setTimeEndListener(function()
		node:setVisible(false)
		self.Node_1:setPositionY(-4)
	end)
	timeLabel:beginTime(remainTime)
end
function worldMapTip:createNodeLabel(...)
	local node = display.newNode()
	local Image_bg = display.newSprite("#frame_SJDT_mingpai.png")
	node.Image_bg = Image_bg
	Image_bg:addTo(node)
	Image_bg:setContentSize(cc.size(240, 26))
	Image_bg:setOpacity(178.5)
	local Text_name = self.playerNameLable:clone()
	node.Text_name = Text_name
	Text_name:addTo(node)
	Text_name:setVisible(true)
	Text_name:setPosition(cc.p(0, 0))
	SoraDSetTextWidthHeight(Text_name, cc.size(240, 26))
	return node
end
function worldMapTip:initRoaringFlameWarBuilding(...)
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	local objId = self.mapInstance:getObjId()
	if roaringFlameWarUtil.checkIsMineBuild(nil, objId) then
		return
	end
	local _ENV, config = roaringFlameWarUtil.checkIsMineBuild(nil, objId), roaringFlameWarUtil.checkIsMineBuild(nil, objId)
	local fromTilePos = roaringFlameWarRead.getBuildCoord(objId)
	local fromPos = self.worldMapCell:getPointWithTile(fromTilePos)
	local binding = roaringFlameWarRead.getBuildBinding(objId)
	for i, toObjId in ipairs(binding) do
		if not roaringFlameWarUtil.checkIsMineBuild(nil, toObjId) then
			_ENV = roaringFlameWarUtil.checkIsMineBuild(nil, toObjId)
			roaringFlameWarUtil.checkIsMineBuild(nil, toObjId).toObjId = toObjId
			local roaringFlameWarUtil.checkIsMineBuild(nil, toObjId).connect, cfg = self.mapInstance:getConnect(), roaringFlameWarUtil.checkIsMineBuild(nil, toObjId)
			local toTilePos = roaringFlameWarRead.getBuildCoord(toObjId)
			local distance = cc.pGetDistance(fromTilePos, toTilePos)
			distance = math.ceil(distance)
			cfg.distance = distance
			local toPos = self.worldMapCell:getPointWithTile(toTilePos)
			local rotation = -SoraDGetAngleByPos(fromPos, toPos) + 90
			rotation = rotation % 360
			cfg.rotation = rotation
			table.insert(config, cfg)
		end
	end
	table.sort(config, function(a, b)
		return a.rotation > b.rotation
	end)
	local count = #config
	for i, cfg in ipairs(config) do
		local obj = fgui.UIPackage:createObject("RoaringFlameWorldMap", "worldMapFaceToDistance")
		obj:addTo(self)
		obj:setPosition(100 * (i - count * 0.5 - 0.5), 220)
		obj:initData(cfg)
	end
end
function worldMapTip:checkShowRoaringFlameArea(...)
	if not worldMapDefine.isInRoaringFlame() then
		return
	end
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	local selfManorRect = cc.rect(self.tilePoint.x, self.tilePoint.y, 0, 0)
	local ok, err = roaringFlameWarUtil.checkIsCanTransfer(selfManorRect)
	if not ok and err == worldMapLayInstanceTypeErrorDef.roaringFlameError then
		local tipLabel = self.playerNameLable
		tipLabel:setVisible(true)
		tipLabel:setPositionY(-200)
		SoraDSetTextWidthHeight(tipLabel, cc.size(400, 50))
		tipLabel:setString(i18n("flames_dunes_text155"))
		tipLabel:setColor(cc.c3b(200, 0, 0))
	end
end
function worldMapTip:endShow()
	gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow("worldMapTip")
end
function worldMapTip:gameGuide_getTarget(itemName, parameters)
	print("查找gameGuide_getTarget")
	if itemName == "ESCORT" then
		for k, v in ipairs(self.tipButtonsArray) do
			print("worldMapTip", v.tipButtonType)
			if v.tipButtonType == worldMapDefine.worldMapTipButtonType_yayun then
				return v
			end
		end
	end
	return SoraDGetChildByName(self, itemName)
end
return worldMapTip
