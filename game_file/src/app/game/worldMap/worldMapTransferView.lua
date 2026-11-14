local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local worldMapDefine = include("worldMapDefine")
local castleSkinConfigRead = include("castleSkinConfigRead")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local radianceWarUtil = include("radianceWarUtil")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local worldMapDefine = include("worldMapDefine")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
local castleSkinRead = include("castleSkinRead")
local worldMapTransferView = class("worldMapTransferView", function()
	return SoraDCreateBasePanel("worldMapTransferView")
end)
function worldMapTransferView:ctor(mapViewCell, layInstanceData)
	self.worldMapCell = mapViewCell
	self.layInstanceData = layInstanceData
	self.layInstanceType = worldMapLayInstanceTypeDef.layInstanceCity
	if layInstanceData and layInstanceData.layInstanceType then
		self.layInstanceType = layInstanceData.layInstanceType
	end
	self.castleSkinID = nil
	if layInstanceData and layInstanceData.skinID then
		self.castleSkinID = layInstanceData.skinID
	end
	self.isButtonEnabled = true
	self.tanferTilePoint = nil
	self.isBeganTouchIn = false
	self.isInWarRange = false
	self.inMoveCityCDEnd = false
	if self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
		local allianceTerritoryAPI = include("allianceTerritoryAPI")
		if allianceTerritoryAPI:checkIsRecycleBuilding(self.layInstanceData.buildClassID) then
			self.isRecycle = true
		end
	end
	self:addTouchEventListener(function(ref, type)
		self:viewOnClick(ref, type)
	end)
	self.cityImage = display.newSprite("#Castle_lv1_base.png")
	self.cityImage:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
	self:addChild(self.cityImage, 0)
	self.buttonCancel = SoraDGetChildByName(self, "Button_cancel")
	if self.buttonCancel then
		self.buttonCancel:loadTextureNormal("btn_red_small_01.png", ccui.TextureResType.plistType)
		self.cancelButtonTitle = SoraDGetChildByName(self.buttonCancel, "Text_cancel")
		self.cancelButtonTitle:setColor(cc.c3b(255, 251, 213))
		self.buttonCancel:addTouchEventListener(function(ref, type)
			self:ButtonCancelCallFun(ref, type)
		end)
	end
	self.buttonMove = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_move")
	_ENV = "CCS_commonGoldSmallBtn_move"
	self.buttonMove:initData("CCS_commonGoldSmallBtn_move", 1)
	if self.buttonMove then
		self.buttonMove:setSwallowTouches(true)
		self.buttonMove:addTouchEventListener(function(ref, type)
			self:ButtonMoveCallFun(ref, type)
		end)
	end
	self.nodeTips = SoraDGetChildByName(self, "node_tip")
	if self.nodeTips then
		self.nodeTips:setVisible(false)
		local text_tip = SoraDGetChildByName(self.nodeTips, "Text_tip")
		text_tip:setString(i18n("common_text_3444"))
		self.text_tip = text_tip
	end
	self:initPyramid()
	self:initBtnStatus()
	self:initImageStatus()
end
function worldMapTransferView:initPyramid()
	if self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
		self.isInPyramid = kingdomMapCtrl:isPyramidMap()
		if self.isInPyramid then
			self.isShowTilesRolygon = self:isShowTilesRolygonStatus()
		end
	end
end
function worldMapTransferView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.initImageStatus))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", function(target, data)
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
		;(nil).buttonType = "cancel"
		;(nil).mapViewCell = self.worldMapCell
		SoraDSendMessage(nil)
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_DISMISS_SUCCESS", function(target, data)
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
		;(nil).buttonType = "cancel"
		;(nil).mapViewCell = self.worldMapCell
		SoraDSendMessage(nil)
	end)
end
function worldMapTransferView:initBtnStatus()
	if self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
		self.cancelButtonTitle:setString(i18n("common_text_184"))
		if worldMapDefine.isInGarden() then
			self.buttonMove:setTitleStr(i18n("garden_text_37"))
		else
			self.buttonMove:setTitleStr(i18n("common_text_003"))
		end
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceResource then
		_ENV = i18n("common_text_003")
		i18n("common_text_003").text = i18n("common_text_2132")
		self.buttonMove:initData(i18n("common_text_003"))
		self.buttonMove:setTitleColor(cc.c3b(255, 200, 100))
		self.cancelButtonTitle:setString(i18n("common_text_184"))
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
		_ENV = i18n("common_text_184")
		i18n("common_text_184").text = i18n("common_text_2132")
		self.buttonMove:initData(i18n("common_text_184"))
		self.buttonMove:setTitleColor(cc.c3b(255, 200, 100))
		self.cancelButtonTitle:setString(i18n("common_text_184"))
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceBoss then
		self.cancelButtonTitle:setString(i18n("common_text_184"))
		self.buttonMove:setTitleStr(i18n("common_text_2132"))
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
		self.cancelButtonTitle:setString(i18n("common_text_184"))
		self.buttonMove:setTitleStr(i18n("common_text_2132"))
	end
end
function worldMapTransferView:initImageStatus()
	if self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
		self.tranferItemID = 0
		self.tranferItemNum = 0
		self.tranferItemNeed = 1
		self.haveTranferItem = false
		local goldBuyTranferItemID
		if self.layInstanceData.isLeagueManorTransfer then
			local leagueManorTransferItermID = 301501
			local haveLeagueManorTranferItem, leagueManorTranferItemNum = backpackCtrl:isThereTheItem(leagueManorTransferItermID)
			if haveLeagueManorTranferItem then
				self.tranferItemID = leagueManorTransferItermID
				self.tranferItemNum = leagueManorTranferItemNum
				self.haveTranferItem = true
			end
			goldBuyTranferItemID = leagueManorTransferItermID
		elseif self.layInstanceData.isLegendLordWar then
			local legendLordTransferItermID = 302101
			if not legendLordWarCtrl:isHasTicket() then
				local haveLegendLordTranferItem, legendLordTranferItemNum = backpackCtrl:isThereTheItem(legendLordTransferItermID)
				if haveLegendLordTranferItem then
					self.tranferItemID = legendLordTransferItermID
					self.tranferItemNum = legendLordTranferItemNum
					self.haveTranferItem = true
				end
				goldBuyTranferItemID = legendLordTransferItermID
			else
				self.haveTranferItem = true
				self.tranferItemID = legendLordTransferItermID
			end
		elseif self.layInstanceData.isHegemonWar then
			local hegemonTransferItermID = 310101
			if not legendLordWarCtrl:isHasTicket() then
				local haveLegendLordTranferItem, hegemonTranferItemNum = backpackCtrl:isThereTheItem(hegemonTransferItermID)
				if haveLegendLordTranferItem then
					self.tranferItemID = hegemonTransferItermID
					self.tranferItemNum = hegemonTranferItemNum
					self.haveTranferItem = true
				end
				goldBuyTranferItemID = hegemonTransferItermID
			else
				self.haveTranferItem = true
				self.tranferItemID = hegemonTransferItermID
			end
		elseif worldMapDefine.isInGarden() then
			self:updateGardenTranferItem()
		else
			local heightTranferItemID = 300103
			local haveHeightTranferItem, heightTranferItemNum = backpackCtrl:isThereTheItem(heightTranferItemID)
			local playerLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if playerLevel <= 6 then
				local newcommerTranferItemID = 300101
				local haveNewcommerTranferItem, newcommerTranferItemNum = backpackCtrl:isThereTheItem(newcommerTranferItemID)
				if haveNewcommerTranferItem then
					self.tranferItemID = newcommerTranferItemID
					self.tranferItemNum = newcommerTranferItemNum
					self.haveTranferItem = true
				elseif haveHeightTranferItem then
					self.tranferItemID = heightTranferItemID
					self.tranferItemNum = heightTranferItemNum
					self.haveTranferItem = true
				end
			else
				if worldMapDefine.isInRemains() then
					local heightRemainsTranferItemID = 310801
					local haveHeightRemainsTranferItem, heightRemainsTranferItemNum = backpackCtrl:isThereTheItem(heightRemainsTranferItemID)
					if haveHeightRemainsTranferItem then
						self.tranferItemID = heightRemainsTranferItemID
						self.tranferItemNum = heightRemainsTranferItemNum
						self.haveTranferItem = true
				end
				else
					if worldMapDefine.isInAtlantis() then
						local tranferItemID = 311601
						local haveTranferItemID, tranferItemIDNum = backpackCtrl:isThereTheItem(tranferItemID)
						if haveTranferItemID then
							self.tranferItemID = tranferItemID
							self.tranferItemNum = tranferItemIDNum
							self.haveTranferItem = true
					end
					elseif haveHeightTranferItem then
						self.tranferItemID = heightTranferItemID
						self.tranferItemNum = heightTranferItemNum
						self.haveTranferItem = true
					end
				end
			end
			goldBuyTranferItemID = heightTranferItemID
		end
		if self.tranferItemID == 0 then
			self.tranferItemID = goldBuyTranferItemID
		end
		self.inMoveCityCDEnd = false
		self.tranferModel = BUILD_EXCHANGE_MODE.TOOLS
		if self.isShowTilesRolygon and self:isHasFreeTransfer() then
			self.tranferModel = BUILD_EXCHANGE_MODE.FREE
			self.buttonMove:setGoldText(i18n("common_text_049"))
			self.buttonMove:setTextGoldColor(cc.c3b(255, 255, 255))
		elseif self:isHaveFreeMoveCityBuff() then
			self.tranferModel = BUILD_EXCHANGE_MODE.FREE
			self.buttonMove:setGoldText(i18n("common_text_049"))
			self.buttonMove:setTextGoldColor(cc.c3b(255, 255, 255))
		elseif self.layInstanceData.isLegendLordWar and legendLordWarCtrl:isHasTicket() then
			self.tranferModel = BUILD_EXCHANGE_MODE.FREE
			_ENV = cc.c3b(255, 255, 255)
			cc.c3b(255, 255, 255).text = i18n("common_text_003")
			self.buttonMove:initData(cc.c3b(255, 255, 255))
		elseif self.layInstanceData.isHegemonWar and legendLordWarCtrl:isHasTicket() then
			self.tranferModel = BUILD_EXCHANGE_MODE.FREE
			_ENV = cc.c3b(255, 255, 255)
			cc.c3b(255, 255, 255).text = i18n("common_text_003")
			self.buttonMove:initData(cc.c3b(255, 255, 255))
		elseif radianceWarUtil.isRelease() and worldMapDefine.isInRadiance() and radianceWarCtrl:isMoveCityCDEndTime() then
			local time = radianceWarCtrl:getMoveCityCDEndTime()
			local _ENV, params = radianceWarCtrl, radianceWarCtrl
			function params.timeEndListener()
				self:initImageStatus()
				self:updateButtonStatues()
			end
			params.title = i18n("common_text_003")
			params.time = time
			self.buttonMove:initData(params, 3)
			self.inMoveCityCDEnd = true
			self.buttonMove:setTextGoldColor(cc.c3b(255, 255, 255))
			self.buttonMove:setIconTexture("icon_hourglass.png")
		elseif self.haveTranferItem then
			self.tranferModel = BUILD_EXCHANGE_MODE.TOOLS
			local itemDesRead = include("itemDesRead")
			local itemIconImagName = itemDesRead.getIcon(self.tranferItemID)
			self.buttonMove:setIconTexture(itemIconImagName)
			_ENV = cc.c3b(255, 255, 255)
			cc.c3b(255, 255, 255).member = self.tranferItemNum
			cc.c3b(255, 255, 255).total = self.tranferItemNeed
			self.buttonMove:setGoldText(i18n("common_text_155", cc.c3b(255, 255, 255)))
			self.buttonMove:setTextGoldColor(cc.c3b(255, 255, 255))
		else
			self.tranferModel = BUILD_EXCHANGE_MODE.GOLD
			local price = gModuleMgr.sharedMgr("shopltCtrl"):getPriceByItemID(self.tranferItemID)
			price = price * self.tranferItemNeed
			self.buttonMove:setGoldText(price)
			if not SoraDEnoughGold(tonumber(price), true) then
				self.buttonMove:setTextGoldColor(display.COLOR_RED)
			else
				self.buttonMove:setTextGoldColor(cc.c3b(255, 255, 0))
			end
			self.buttonMove:setIconTexture("icon_small_gold.png")
		end
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceBoss then
		local godLanterItemID = self.layInstanceData.itemID or 803901
		local haveGodLanterItem, godLanterNum = backpackCtrl:isThereTheItem(godLanterItemID)
		self.tranferItemID = godLanterItemID
		self.tranferItemNum = godLanterNum
		self.haveTranferItem = haveGodLanterItem
		self.tranferModel = BUILD_EXCHANGE_MODE.TOOLS
		local itemDesRead = include("itemDesRead")
		local itemIconImagName = itemDesRead.getIcon(self.tranferItemID)
		self.buttonMove:setIconTexture(itemIconImagName)
		self.buttonMove:setGoldText(self.tranferItemNum)
		self.buttonMove:setTextGoldColor(display.COLOR_WHITE)
		if not self.haveTranferItem then
			self.buttonMove:setTextGoldColor(display.COLOR_RED)
		end
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
		_ENV = backpackCtrl:isThereTheItem(godLanterItemID)
		self.buttonMove:initData(backpackCtrl:isThereTheItem(godLanterItemID))
		self.buttonMove:setTitleText(i18n("common_text_2132"))
	end
end
function worldMapTransferView:updateGardenTranferItem()
	local manorCityUtil = include("manorCityUtil")
	local tilePos = self.tanferTilePoint or cc.p(0, 0)
	local costItem = manorCityUtil.getTransferItemID(tilePos)
	local _itemID = costItem.id
	self.tranferItemID = _itemID
	self.tranferItemNeed = costItem.count
	local _haveItem, _itemNum = backpackCtrl:isThereTheItem(_itemID)
	if _haveItem and _itemNum >= self.tranferItemNeed then
		self.tranferItemNum = _itemNum
		self.haveTranferItem = true
		self.buttonMove:setEnabled(true)
	else
		local price = gModuleMgr.sharedMgr("shopltCtrl"):getPriceByItemID(_itemID)
		if not price then
			self.tranferItemNum = _itemNum
			self.haveTranferItem = true
			self.buttonMove:setEnabled(false)
		else
			self.buttonMove:setEnabled(true)
		end
	end
	self:updateButtonStatues()
end
function worldMapTransferView:updateButtonStatues()
	if worldMapDefine.isInGarden() then
		if self.haveTranferItem and self.tranferItemNeed and self.tranferItemNum and self.tranferItemNeed > self.tranferItemNum then
			self.isButtonEnabled = false
		else
			self.isButtonEnabled = self.isCanTranfer and not self.inMoveCityCDEnd
		end
	else
		self.isButtonEnabled = self.isCanTranfer and not self.inMoveCityCDEnd
	end
	self.buttonMove:setBright(self.isButtonEnabled)
end
function worldMapTransferView:updateData(tanferTilePoint, isCanTranfer, layInstanceError, isInWarRange)
	self.tanferTilePoint = tanferTilePoint
	self.isInWarRange = isInWarRange
	self.isCanTranfer = isCanTranfer
	self:updateButtonStatues()
	if self.isShowTilesRolygon then
		self:initImageStatus()
	end
	if worldMapDefine.isInGarden() then
		self:initImageStatus()
	end
	self.layInstanceError = layInstanceError
	if self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
		if layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorMax then
			self.text_tip:setString(i18n("common_text_3473"))
			self.text_tip:setColor(cc.c3b(190, 10, 0))
			self.nodeTips:setVisible(true)
		elseif layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorInSelf then
			self.text_tip:setString(i18n("common_text_3444"))
			self.text_tip:setColor(cc.c3b(190, 10, 0))
			self.nodeTips:setVisible(true)
		elseif layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorInOther then
			self.text_tip:setString(i18n("alliance_stronghold_text_098"))
			self.text_tip:setColor(cc.c3b(190, 10, 0))
			self.nodeTips:setVisible(true)
			if self.layInstanceData.buildClassID and (self.layInstanceData.buildClassID == gAllianceBuilding.PALACE or self.layInstanceData.buildClassID == gAllianceBuilding.PRIMARY_PALACE) then
				self.text_tip:setString(i18n("alliance_stronghold_text_090"))
			end
		elseif layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorInHold then
			self.text_tip:setString(i18n("alliance_stronghold_text_090"))
			self.text_tip:setColor(cc.c3b(190, 10, 0))
			self.nodeTips:setVisible(true)
		elseif layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorInSelfHold then
			self.text_tip:setString(i18n("alliance_stronghold_text_120"))
			self.text_tip:setColor(cc.c3b(190, 10, 0))
			self.nodeTips:setVisible(true)
		elseif layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorNearHold then
			self.text_tip:setString(i18n("alliance_stronghold_text_137"))
			self.text_tip:setColor(cc.c3b(190, 10, 0))
			self.nodeTips:setVisible(true)
		elseif self.isRecycle then
			self.text_tip:setString(i18n("alliance_stronghold_text_086"))
			self.text_tip:setColor(display.COLOR_WHITE)
			self.nodeTips:setVisible(true)
		else
			self.nodeTips:setVisible(false)
		end
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
		worldMapDefine = self.layInstanceType
		self.layInstanceType[worldMapLayInstanceTypeErrorDef.layInstanceErrorInSelf] = i18n("brightWar_text_80")
		self.layInstanceType[worldMapLayInstanceTypeErrorDef.nebulaWar_superWarArea] = i18n("nebula_war_text_0266")
		self.layInstanceType[worldMapLayInstanceTypeErrorDef.nebulaWar_warArea] = i18n("nebula_war_text_0356")
		self.layInstanceType[worldMapLayInstanceTypeErrorDef.nebulaEmperor_forbid] = i18n("nebulaemperor_text_232")
		self.layInstanceType[worldMapLayInstanceTypeErrorDef.nebulaEmperor_edge] = i18n("nebulaemperor_text_233")
		self.layInstanceType[worldMapLayInstanceTypeErrorDef.nebulaEmperor_born] = i18n("nebulaemperor_text_137")
		self.layInstanceType[worldMapLayInstanceTypeErrorDef.nebulaAllStar_allStar] = i18n("NebulaAllstar_258")
		self.layInstanceType[worldMapLayInstanceTypeErrorDef.nebulaAllStar_support] = i18n("NebulaAllstar_260")
		local self.layInstanceType[worldMapLayInstanceTypeErrorDef.roaringFlameError], config = i18n("flames_dunes_text155"), self.layInstanceType
		if config[layInstanceError] then
			self.text_tip:setString(config[layInstanceError])
			self.nodeTips:setVisible(true)
		else
			self.nodeTips:setVisible(false)
		end
	end
end
function worldMapTransferView:updateBuildingImg(level)
	self.cityImage:removeAllChildren()
	if self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
		if worldMapDefine.isNebulaAllStarKingdomID() then
			self.cityImage:setSpriteFrame("allstar_player_city.png")
			local posx, posy = self.cityImage:getPosition()
			self.cityImage:setPosition(cc.p(posx, posy + 70))
		elseif self.castleSkinID then
			self.cityImage:setVisible(false)
			_ENV = self.cityImage.setVisible
			self.cityImage.setVisible.isSafe = false
			self.cityImage.setVisible.playerID = SoraDGetPlayerID()
			local self.cityImage.setVisible.castleSkin, ownCityData = self.castleSkinID, self.cityImage.setVisible
			local castle = include("worldMapBuildingPreview").new()
			castle:setPosition(self:getContentSize().width / 2, 100)
			castle:addTo(self)
			castle:initCityData(ownCityData)
			if castle.image_level then
				castle.image_level:setVisible(false)
			end
			castle.image_name:setVisible(false)
			castle.image_level:setVisible(false)
			castle.text_Name:setVisible(false)
			if castle.warLvBaseNode then
				castle.warLvBaseNode:setVisible(false)
			end
			if castle.image_crown then
				castle.image_crown:setVisible(false)
			end
		else
			local cityLevel = self.layInstanceData.cityLevel
			worldMapDefine.createCityImageWithLevel(cityLevel, SoraDGetFactionType(), self.cityImage, true)
		end
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceResource then
		local imageName = worldMapDefine.getAllianceResourceImageName(self.layInstanceData.allianceResourceBid or 3721)
		self.cityImage:setSpriteFrame(imageName)
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
		local buildInfo = worldMapDefine.getAllianceBuildInfo(self.layInstanceData.buildClassID)
		if buildInfo then
			self.cityImage:setSpriteFrame(buildInfo.image)
			if self.layInstanceData.buildClassID == gMapAllianceBuildType.subTypeAllianceFlag then
				local image_LeagueFlag = display.newSprite(allianceDesRead.getFlagIcon(self.layInstanceData.leagueFlag, true))
				self:addChild(image_LeagueFlag, 1)
				self.cityImage:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2 + 0))
				image_LeagueFlag:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2 + 15))
				self.cityImage:setScale(1.5)
				image_LeagueFlag:setScale(0.5)
			end
		end
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceBoss then
		local bossData = worldMapDefine.getWorldBossShow(self.layInstanceData.bossid or 1)
		local imgName = bossData.effects
		if bossData.index ~= 6 then
			self.cityImage:stopAllActions()
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local needFlipX = math.random(1, 2) == 1
			local bossData = worldMapDefine.getWorldBossShow(self.layInstanceData.bossid)
			local hasHD = worldMapDefine.hasBossHdRes(self.layInstanceData.bossid)
			if hasHD then
				local frames = display.newFrames(imgName .. "_dj_ws_%02d.png", 1, bossData.frams)
				local time = bossData.frams == 8 and 0.15 or 0.08333333333333333
				local animation = display.newAnimation(frames, time)
				self.cityImage:playAnimationForever(animation)
			else
				self.cityImage:setSpriteFrame(imgName .. "_dj_ws.png")
			end
			self.cityImage:setScale(bossData.scale or 1.5)
			local offsety = bossData.offsety or 0
			self.cityImage:setPositionY(self:getContentSize().height / 2 + offsety)
			self.cityImage:setFlippedX(needFlipX)
		else
			self.cityImage:setSpriteFrame("sds_bust_outside.png")
		end
	elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
		local activityID = self.layInstanceData.activityID
		if activityID == gActivityTimeActivityID.FANTASY_LAND then
			self.cityImage:setSpriteFrame(IsArClient and "Map_castle_WaterPark.png" or "Map_castle_WaterPark_ros.png")
			local posx = self:getContentSize().width / 2 - 80
			local posy = self:getContentSize().height / 2 + 30
			self.cityImage:setPosition(posx, posy)
			self.cityImage:setScale(1.0)
		else
			self.cityImage:setSpriteFrame("shengyan_maotang.png")
		end
	end
end
function worldMapTransferView:viewOnClick(ref, type)
	if type == ccui.TouchEventType.began then
		self.isBeganTouchIn = true
	end
end
function worldMapTransferView:ButtonCancelCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
		;(nil).buttonType = "cancel"
		;(nil).mapViewCell = self.worldMapCell
		SoraDSendMessage(nil)
	end
end
function worldMapTransferView:ButtonMoveCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isButtonEnabled == false then
			if self.isInPyramid and allianceWarCtrl:getRemainMoveTimes4AllianceWar() <= 0 then
				SoraDShowMsgTip(i18n("common_text_3386"))
			end
			if worldMapDefine.isInRadiance() then
				if self.layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorInSelf then
					SoraDShowMsgTip(i18n("brightWar_text_80"))
				elseif self.inMoveCityCDEnd then
					SoraDShowMsgTip(i18n("brightWar_text_136"))
				end
			end
			return
		elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
			if self.tranferModel == BUILD_EXCHANGE_MODE.GOLD then
				local price = gModuleMgr.sharedMgr("shopltCtrl"):getPriceByItemID(self.tranferItemID)
				if not SoraDEnoughGold(tonumber(price), false) then
					return
				end
			end
			local gotoTranfer = function()
				local buffValue, leftTime = SoraDGetCtrl("remainsWarCtrl"):getRemainsWarPlayerBuffValue(gBuffEffect.RUINS_WAR_MOVE_CITY_LOCKED)
				if 0 < buffValue then
					_ENV = nil
					;(nil).time = SoraDConvertSecondToString(leftTime)
					SoraDShowMsgTip(i18n("remains_text_361", nil))
					return true
				end
				local buffValue, leftTime = SoraDGetCtrl("atlantisWarCtrl"):getPlayerBuffValue(gBuffEffect.RUINS_WAR_MOVE_CITY_LOCKED)
				if 0 < buffValue then
					_ENV = i18n("remains_text_361", nil)
					i18n("remains_text_361", nil).time = SoraDConvertSecondToString(leftTime)
					SoraDShowMsgTip(i18n("remains_text_361", i18n("remains_text_361", nil)))
					return true
				end
				local msgStr = i18n("common_text_2635")
				if worldMapDefine.isInRadiance() then
					msgStr = i18n("brightWar_text_137")
				elseif worldMapDefine.isInRoaringFlame() then
					local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
					local remain = roaringFlameWarCtrl:getMoveCityCDEndTime()
					local msgStr2 = ""
					if 0 < remain then
						_ENV = i18n("remains_text_361", i18n("remains_text_361", nil))
						i18n("remains_text_361", i18n("remains_text_361", nil)).val = remain
						msgStr2 = i18n("flames_dunes_text290", i18n("remains_text_361", i18n("remains_text_361", nil)))
					else
						local roaringFlameWarRead = include("roaringFlameWarRead")
						local moveCD = roaringFlameWarRead.getConstValue("FLAMES_DUNES_MOVE_CD", 300)
						_ENV = i18n("remains_text_361", i18n("remains_text_361", nil))
						i18n("remains_text_361", i18n("remains_text_361", nil)).val = math.ceil(moveCD / 60)
						msgStr2 = i18n("flames_dunes_text289", i18n("remains_text_361", i18n("remains_text_361", nil)))
					end
					msgStr = msgStr .. "\n" .. msgStr2
				elseif worldMapDefine.isInGarden() then
					local itemDesRead = include("itemDesRead")
					local itemName = itemDesRead.getName(self.tranferItemID)
					_ENV = "\n"
					;("\n").num = self.tranferItemNeed
					;("\n").item = itemName
					msgStr = i18n("garden_text_36", "\n")
				end
				SoraDShowMsgBox(msgStr, i18n("common_text_204"), nil, function(callBack)
					if callBack == MSGBOX_CALLBACK_YES then
						if worldMapDefine.isInRoaringFlame() then
							local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
							local remain = roaringFlameWarCtrl:getMoveCityCDEndTime()
							if 0 < remain then
								SoraDShowMsgTip(i18n("flames_dunes_text292"))
								return
							end
						end
						_ENV = roaringFlameWarCtrl:getMoveCityCDEndTime()
						roaringFlameWarCtrl:getMoveCityCDEndTime().msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
						roaringFlameWarCtrl:getMoveCityCDEndTime().buttonType = "move"
						roaringFlameWarCtrl:getMoveCityCDEndTime().layInstanceType = worldMapLayInstanceTypeDef.layInstanceCity
						roaringFlameWarCtrl:getMoveCityCDEndTime().tilePoint = self.tanferTilePoint
						roaringFlameWarCtrl:getMoveCityCDEndTime().mode = self.tranferModel
						roaringFlameWarCtrl:getMoveCityCDEndTime().itemId = self.tranferItemID
						roaringFlameWarCtrl:getMoveCityCDEndTime().mapViewCell = self.worldMapCell
						SoraDSendMessage((roaringFlameWarCtrl:getMoveCityCDEndTime()))
					end
				end)
			end
			if (worldMapDefine.isLegendLordKingdomID() or self.layInstanceData.isLegendLordWar or self.layInstanceData.isHegemonWar or worldMapDefine.isInNebula()) and self.isInWarRange then
				if worldMapDefine.isLegendLordKingdomID() and legendTeamCtrl:isTeamCommander() then
					_ENV = i18n("brightWar_text_136")
					i18n("brightWar_text_136").content = i18n("legendary_commander_text15")
					i18n("brightWar_text_136").confirmString = i18n("common_text_204")
					i18n("brightWar_text_136").confirmFunc = function()
						gotoTranfer()
					end
					uiManager:show("MessageBox", i18n("brightWar_text_136"))
				else
					local showMsg = i18n("common_text_4261")
					SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
						if callType == MSGBOX_CALLBACK_YES then
							gotoTranfer()
						end
					end)
				end
			else
				gotoTranfer()
			end
		elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceResource then
			print("放置联盟资源点操作")
			_ENV = "放置联盟资源点操作"
			;("放置联盟资源点操作").msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
			;("放置联盟资源点操作").buttonType = "move"
			;("放置联盟资源点操作").layInstanceType = worldMapLayInstanceTypeDef.layInstanceAllianceResource
			;("放置联盟资源点操作").allianceResourceBid = self.layInstanceData.allianceResourceBid
			;("放置联盟资源点操作").allianceResourceIiD = self.layInstanceData.allianceResourceIiD
			;("放置联盟资源点操作").tilePoint = self.tanferTilePoint
			;("放置联盟资源点操作").mapViewCell = self.worldMapCell
			SoraDSendMessage("放置联盟资源点操作")
		elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
			print("放置联盟建筑操作")
			if not allianceMgr:hasJoinAlliance() then
				SoraDShowMsgTip(i18n("common_text_814"))
				_ENV = i18n("common_text_814")
				i18n("common_text_814").msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
				i18n("common_text_814").buttonType = "cancel"
				i18n("common_text_814").mapViewCell = self.worldMapCell
				SoraDSendMessage(i18n("common_text_814"))
				return
			end
			local sendmsg = function(costType)
				_ENV = nil
				;(nil).msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
				;(nil).buttonType = "move"
				;(nil).layInstanceType = worldMapLayInstanceTypeDef.layInstanceAllianceManor
				;(nil).allianceBuildClassID = self.layInstanceData.buildClassID
				;(nil).tilePoint = self.tanferTilePoint
				;(nil).mapViewCell = self.worldMapCell
				;(nil).costType = costType
				SoraDSendMessage(nil)
			end
			if self.isRecycle then
				local allianceTerritoryAPI = include("allianceTerritoryAPI")
				local memberMgr = SoraDGetCtrl("memberMgr")
				local ownRank = memberMgr:getOwnMember():getProperty("rank")
				local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
				local allianceDesRead = include("allianceDesRead")
				if not allianceBuildingltCtrl:canRankMemberCreate(self.layInstanceData.buildClassID, ownRank, 1) then
					local needRank = allianceBuildingltCtrl:getRankMemberCreate(self.layInstanceData.buildClassID, 1)
					local showIcon = allianceDesRead.getIcon(needRank, true)
					SoraDShowMsgTip(i18n("common_text_203"), showIcon)
					_ENV = i18n("common_text_203")
					i18n("common_text_203").msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
					i18n("common_text_203").buttonType = "cancel"
					i18n("common_text_203").mapViewCell = self.worldMapCell
					SoraDSendMessage((i18n("common_text_203")))
					return
				end
				if not allianceTerritoryAPI:checkIsRecycleBuilding(self.layInstanceData.buildClassID) then
					SoraDShowMsgTip(i18n("alliance_stronghold_text_081"))
					_ENV = i18n("alliance_stronghold_text_081")
					i18n("alliance_stronghold_text_081").msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
					i18n("alliance_stronghold_text_081").buttonType = "cancel"
					i18n("alliance_stronghold_text_081").mapViewCell = self.worldMapCell
					SoraDSendMessage(i18n("alliance_stronghold_text_081"))
					return
				end
				sendmsg(gAllianceCreateBuildingCostType.RECYCLE)
				return
			end
			if GLOBAL_GAME_ALLIANCE_MODE then
				_ENV, _ENV = include("allianceDesRead"), include("allianceBuildingltCtrl")
				include("allianceDesRead").buildClassID = self.layInstanceData.buildClassID
				include("allianceBuildingltCtrl").initData, include("allianceDesRead").transferPoint = include("allianceDesRead"), self.tanferTilePoint
				uiManager:show("AllianceBuildMainPop", (include("allianceBuildingltCtrl")))
			else
				local panel = SoraDCreatePanel("allianceBuildMainPopView")
				panel:initData(self.layInstanceData.buildClassID, self.tanferTilePoint)
				panel:show()
			end
			_ENV = panel.show
			panel.show.msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
			panel.show.buttonType = "cancel"
			panel.show.mapViewCell = self.worldMapCell
			SoraDSendMessage(panel.show)
		elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceBoss then
			print("放置神灯Boss")
			local sendmsg = function()
				_ENV = nil
				;(nil).msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
				;(nil).buttonType = "move"
				;(nil).layInstanceType = worldMapLayInstanceTypeDef.layInstanceBoss
				;(nil).tilePoint = self.tanferTilePoint
				;(nil).itemID = self.layInstanceData.itemID
				;(nil).mapViewCell = self.worldMapCell
				SoraDSendMessage(nil)
			end
			if self.haveTranferItem then
				if allianceMgr:hasJoinAlliance() then
					sendmsg()
				else
					SoraDShowMsgBox(i18n("common_text_2886"), i18n("common_text_204"), nil, function(callBack)
						if callBack == MSGBOX_CALLBACK_YES then
							sendmsg()
						end
					end)
				end
			else
				SoraDShowMsgTip(i18n("common_text_2512"))
				_ENV = i18n("common_text_2512")
				i18n("common_text_2512").msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
				i18n("common_text_2512").buttonType = "cancel"
				i18n("common_text_2512").mapViewCell = self.worldMapCell
				SoraDSendMessage(i18n("common_text_2512"))
			end
		elseif self.layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
			local canPlace = true
			local activityID = self.layInstanceData.activityID
			if activityID == gActivityTimeActivityID.FANTASY_LAND then
				local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
				if not activity_9001717_Ctrl:checkCanPlaceFeast() then
					canPlace = false
				end
			else
				local activity_9001625_Ctrl = SoraDGetCtrl("activity_9001625_Ctrl")
				if not activity_9001625_Ctrl:checkCanPlaceFeast() then
					canPlace = false
				end
			end
			if not canPlace then
				_ENV = activity_9001625_Ctrl:checkCanPlaceFeast()
				activity_9001625_Ctrl:checkCanPlaceFeast().msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
				activity_9001625_Ctrl:checkCanPlaceFeast().buttonType = "cancel"
				activity_9001625_Ctrl:checkCanPlaceFeast().mapViewCell = self.worldMapCell
				SoraDSendMessage((activity_9001625_Ctrl:checkCanPlaceFeast()))
				return
			end
			_ENV = activity_9001625_Ctrl:checkCanPlaceFeast()
			activity_9001625_Ctrl:checkCanPlaceFeast().msg = "MESSAGE_WORLD_MAP_TRANSFER_BUILDING"
			activity_9001625_Ctrl:checkCanPlaceFeast().buttonType = "move"
			activity_9001625_Ctrl:checkCanPlaceFeast().layInstanceType = worldMapLayInstanceTypeDef.layInstanceFeast
			activity_9001625_Ctrl:checkCanPlaceFeast().tilePoint = self.tanferTilePoint
			activity_9001625_Ctrl:checkCanPlaceFeast().feastLv = self.layInstanceData.feastLv
			activity_9001625_Ctrl:checkCanPlaceFeast().mapViewCell = self.worldMapCell
			activity_9001625_Ctrl:checkCanPlaceFeast().activityID = self.layInstanceData.activityID
			SoraDSendMessage((activity_9001625_Ctrl:checkCanPlaceFeast()))
		end
	end
end
function worldMapTransferView:isShowTilesRolygonStatus()
	if allianceWarCtrl:getRemainFreeMoveTimesByTransPoints() <= 0 then
		return false
	end
	return true
end
function worldMapTransferView:isHasFreeTransfer()
	local bFree = false
	if self.tanferTilePoint then
		local info = kingdomMapCtrl:getAllianceWarBuildings()
		for k, v in pairs(info) do
			if v.type == gMapBattlefieldSiteTypeDef.subMapObjTypeTransport then
				local buildData = kingdomMapCtrl:getWarBuildingOwner(gametop.playertop_:getMapID(), v.id)
				if buildData and buildData.finishOccupy and buildData.aid == allianceMgr:getOwnTeamID() then
					local buildRect = cc.rect(v.x - 4, v.y - 4, 9, 9)
					local point = self.tanferTilePoint
					if cc.rectContainsPoint(buildRect, point) then
						gametop = cc.rectContainsPoint(buildRect, point)
						cc.rectContainsPoint(buildRect, point)[1] = cc.p(point.x, point.y + 1)
						cc.rectContainsPoint(buildRect, point)[2] = cc.p(point.x + 1, point.y + 1)
						cc.rectContainsPoint(buildRect, point)[3] = cc.p(point.x + 1, point.y)
						cc.rectContainsPoint(buildRect, point)[4] = cc.p(point.x + 1, point.y)
						cc.rectContainsPoint(buildRect, point)[5] = cc.p(point.x + 1, point.y)
						cc.rectContainsPoint(buildRect, point)[6] = cc.p(point.x + 1, point.y)
						cc.rectContainsPoint(buildRect, point)[7] = cc.p(point.x + 1, point.y)
						cc.rectContainsPoint(buildRect, point)[8] = cc.p(point.x + 1, point.y)
						local cc.rectContainsPoint(buildRect, point)[9], tilesArray = cc.p(point.x + 1, point.y)
						local notInRect = true
						for _, pos in pairs(tilesArray) do
							if not cc.rectContainsPoint(buildRect, pos) then
								notInRect = false
								break
							end
						end
						bFree = notInRect
					end
				end
			end
		end
	end
	return bFree
end
function worldMapTransferView:isHaveFreeMoveCityBuff()
	local value = SoraDGetCtrl("buffCtrl"):getBuffEffect(gBuffEffect.FREE_MOVE_CITY)
	return value ~= nil and 0 < value
end
return worldMapTransferView
