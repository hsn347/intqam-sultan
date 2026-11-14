local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local cityBuildFunction = include("cityBuildFunction")
local cityltCtrl = include("cityltCtrl")
local cityHorseCtrl = gametop.playertop_:getModule("cityHorseCtrl")
local maincityDesRead = include("maincityDesRead")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildCreator = include("cityBuildCreator")
local cityBuildViewDef = include("cityBuildViewDef")
local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
local timeRewardCtrl = gametop.playertop_:getModule("timeRewardCtrl")
local loginRewardCtrl = gametop.playertop_:getModule("loginRewardCtrl")
local kingdomWeatherCtrl = gametop.playertop_:getModule("kingdomWeatherCtrl")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityBuildSpritePool = include("cityBuildSpritePool")
local cityBuildMgr = include("cityBuildMgr")
local mainCityBuildingMove = include("mainCityBuildingMove")
local funUnlockRead = include("funUnlockRead")
local _ENV, mainCityHandler = "funUnlockRead", "funUnlockRead"
function mainCityHandler.btnLockAreaCallFunc(mainCity, btnLockArea, ref, event)
	local self = mainCity
	if event == ccui.TouchEventType.moved then
		self.isMoveOnBuild = true
	elseif event == ccui.TouchEventType.ended then
		if self.isMoveOnBuild then
			self.isMoveOnBuild = false
			return
		end
		if btnLockArea then
			local btnTag = btnLockArea:getTag()
			local paneLockAreaName = "Panel_Area_Lock_Lv" .. btnTag
			local btnLockAreaName = "Button_Lock_Area_Lv" .. btnTag
			local panelLockArea = self:getBufferNodeByName(paneLockAreaName)
			local numberOfTree = OuterCityLockAreaList[tostring(btnTag)]
			if panelLockArea ~= nil then
				for i = 1, numberOfTree do
					local lockTreeItemName = "Lock_Tree_Lv" .. btnTag .. "_" .. i
					local lockTreeItem = self:getBufferNodeByName(lockTreeItemName)
					if lockTreeItem ~= nil then
						lockTreeItem:stopAllActions()
						lockTreeItem:setColor(cc.c3b(255, 255, 255))
						self:ShowNodeTintOnce(lockTreeItem)
					end
				end
			end
			local iconSprite = display.newSprite("#lock-trees_1.png")
			iconSprite:setScale(0.3)
		end
	end
end
function mainCityHandler.checkFinishGuide(buildIndex)
	_ENV = nil
	;(nil)[1102] = gGuideStep.BUILD_FARM_NEW_STEP_1
	local (nil)[1107], config = gGuideStep.BUILD_SAWMILL_NEW_STEP_1, nil
	local guideStep = config[buildIndex]
	if not guideStep then
		return
	end
	local stepIndex = SoraDIsGameGuide()
	if not stepIndex then
		return
	end
	local guideConfig = include("guideConfig")
	local viewStep = guideConfig.getViewStep(guideStep)
	if not viewStep then
		return
	end
	if stepIndex >= viewStep and stepIndex <= viewStep + 50 then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
		SoraDSendMessage(nil)
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		guideCtrl:CompleteGuideStep(nil, guideStep)
	end
end
function mainCityHandler.buildButtonCallFun(mainCity, build, ref, type, isSelected, buildID)
	if mainCityBuildingMove:buildButtonCallFun(build, ref, type, isSelected, buildID) then
		return
	end
	local self = mainCity
	if self.isNeedFirstFight == true then
		return
	end
	if type == ccui.TouchEventType.moved then
		local touchBeganPoint = ref:getTouchBeganPosition()
		local touchmovePoint = ref:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoveOnBuild = true
		end
	elseif type == ccui.TouchEventType.began then
		self.isMoveOnBuild = false
	elseif type == ccui.TouchEventType.canceled then
		self.isMoveOnBuild = false
	elseif type == ccui.TouchEventType.ended then
		if isSelected then
			if self.currentSelectTip then
				self:removeBuildTip()
			end
			if self.currentSelectBuild then
				self:CancelBuildTint(self.currentSelectBuild)
				self.currentSelectBuild = nil
			end
		end
		print("进入 mainCityView:buildButtonCallFun ended")
		if self.isMoveOnBuild and SoraDIsGameGuide() == nil then
			print("退出 mainCityView:buildButtonCallFun self.isMoveOnBuild = true")
			return
		end
		if self.isBuildBtnEnable == false then
			return
		end
		if self.curPlaySound == nil then
			print("播放默认声音")
			self:playSound("normalcontrol", 1, cityBuildConstDef.ActionTag.Tag_Play_Click_Default_Sound, 0.1)
		else
			print("检测到有在播放的建筑声音，不播放默认声音")
		end
		mainCityBuildingMove = "检测到有在播放的建筑声音，不播放默认声音"
		;("检测到有在播放的建筑声音，不播放默认声音").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP_HAND"
		SoraDSendMessage("检测到有在播放的建筑声音，不播放默认声音")
		local buildIndex = build:getTag()
		print("build zOrder=", build:getLocalZOrder(), ", buildIndex = ", buildIndex)
		local buildType = SoraDGetBuildTypeByIndex(buildIndex)
		if buildType == 1 and SoraDIsGameGuide() == nil and not isSelected then
			cityBuildConstDef = SoraDIsGameGuide()
			SoraDIsGameGuide()[1] = cityBuildConstDef.buildIndexDef.index_Material_WorkShop
			local SoraDIsGameGuide()[2], fileterTable = cityBuildConstDef.buildIndexDef.index_Crystal, SoraDIsGameGuide()
			local isNeedFilter = false
			for i, v in ipairs(fileterTable) do
				if v == buildIndex then
					isNeedFilter = true
				end
			end
			if not isNeedFilter then
				local touchPoint = ref:getTouchEndPosition()
				if false == cityBuildFunction:isTouchPointInBuildTile(touchPoint, build) then
					print("退出 mainCityView:buildButtonCallFun false == cityBuildFunction:isTouchPointInBuildTile(touchPoint, build)")
					return
				end
			end
		end
		if buildIndex == 1053 then
			local unlocklevel = cityltCtrl.buildAttr(BUILDID.WALLS, BUILD_ATTR.UNLOCKLEVEL)
			if unlocklevel > SoraDGetCastleLv() then
				mainCityBuildingMove = "退出 mainCityView:buildButtonCallFun false == cityBuildFunction:isTouchPointInBuildTile(touchPoint, build)"
				;("退出 mainCityView:buildButtonCallFun false == cityBuildFunction:isTouchPointInBuildTile(touchPoint, build)").name = i18n("buildDes_name_102")
				;("退出 mainCityView:buildButtonCallFun false == cityBuildFunction:isTouchPointInBuildTile(touchPoint, build)").lv = unlocklevel
				SoraDShowMsgTip(i18n("common_text_2122", "退出 mainCityView:buildButtonCallFun false == cityBuildFunction:isTouchPointInBuildTile(touchPoint, build)"))
				return
			else
				local touchPoint = ref:getTouchEndPosition()
				local tipBoxWall = self:getBufferNodeByName("wallTipBox")
				local jiantaBaseL = self:getBufferNodeByName("Button_Jiantachengduo_L")
				local jiantaBaseR = self:getBufferNodeByName("Button_Jiantachengduo_R")
				local build_1052 = self:getBufferNodeByName("build_1052")
				local build_1054 = self:getBufferNodeByName("build_1054")
				local build_1066 = self:getBufferNodeByName("build_1066")
				local buildJiantaL = SoraDGetChildByName(build_1052, "buildBtn")
				local buildJiantaR = SoraDGetChildByName(build_1054, "buildBtn")
				local buildTipBoxGuardSolider = self.tipBoxGuardSoldier
				buildLogic = "buildBtn"
				;("buildBtn")[1] = jiantaBaseL
				;("buildBtn")[2] = jiantaBaseR
				;("buildBtn")[3] = build_1052
				;("buildBtn")[4] = build_1054
				;("buildBtn")[5] = build_1066
				;("buildBtn")[6] = buildJiantaL
				;("buildBtn")[7] = buildJiantaR
				;("buildBtn")[8] = tipBoxWall
				local ("buildBtn")[9], checkTable = buildTipBoxGuardSolider, "buildBtn"
				for i = 1, #checkTable do
					if checkTable[i] then
						local ret = self:getIsTouchOnTarget(touchPoint, checkTable[i])
						if checkTable[i]:isVisible() == true and ret == true then
							print("退出 mainCityView:buildButtonCallFun checkTable[i]:isVisible() == true and ret == true")
							return
						end
					end
				end
			end
		end
		if buildIndex == 1065 then
			local touchPoint = ref:getTouchEndPosition()
			local btnMerchante = self.buttonMerchante
			_ENV = self:getBufferNodeByName("wallTipBox")
			local self:getBufferNodeByName("wallTipBox")[1], checkTable = btnMerchante, self:getBufferNodeByName("wallTipBox")
			for i = 1, #checkTable do
				if checkTable[i] then
					local ret = self:getIsTouchOnTarget(touchPoint, checkTable[i])
					if checkTable[i]:isVisible() == true and ret == true then
						return
					end
				end
			end
		end
		if true == self.isOnMoveMode then
			print("移动模式")
			local buildIndex = build:getTag()
			local isBuildInMoveBtnArray = self:isBuildInMoveBtnArray(buildIndex)
			local selCityBuild = self:getBuildByIndex(buildIndex)
			if true == isBuildInMoveBtnArray then
				if self.currentSelectMoveModeType == 0 then
					if nil ~= selCityBuild and false == selCityBuild:getIsCanMove() then
						print("退出 mainCityView:buildButtonCallFun nil ~= selCityBuild and false == selCityBuild:getIsCanMove()")
						return
					else
						self.currentSelectMoveModeIndex = buildIndex
						local moveType = self:getMoveTypeByBuildIndex(buildIndex)
						self.currentSelectMoveModeType = moveType
						self:updateMoveBtnArrayByType(moveType)
					end
				elseif self.currentSelectMoveModeType ~= 0 and self.currentSelectMoveModeIndex ~= 0 then
					if self.currentSelectMoveModeIndex == buildIndex then
						print("退出 mainCityView:buildButtonCallFun self.currentSelectMoveModeIndex == buildIndex")
						return
					elseif nil ~= selCityBuild and false == selCityBuild:getIsCanMove() then
						print("退出 mainCityView:buildButtonCallFun nil ~= selCityBuild and false == selCityBuild:getIsCanMove()")
						return
					else
						self.afterSelectMoveModeIndex = buildIndex
						self:showBuildMoveEffect(self.afterSelectMoveModeIndex, false, false)
					end
					local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
					local itemId = 500401
					local itemCount = backpackCtrl:getItemCount(itemId)
					if itemCount == 0 then
						local shopItemID = IsArClient and 1000058 or 1000150
						local needGold = gModuleMgr.sharedMgr("shopltCtrl"):getPrice(shopItemID)
						SoraDShowBuyBox(i18n("common_text_053"), needGold, i18n("item_name_500401"), handler(self, self.onPromptBoxCallBackUseGold), true)
					else
						mainCityBuildingMove = self.onPromptBoxCallBackUseItem
						self.onPromptBoxCallBackUseItem.itemID = 500401
						SoraDShowBuyBox(i18n("common_text_053"), 0, i18n("item_name_500401"), handler(self, self.onPromptBoxCallBackUseItem), true, self.onPromptBoxCallBackUseItem)
					end
				end
			end
			print("退出 mainCityView:buildButtonCallFun true == self.isOnMoveMode")
			return
		end
		if build and self.currentSelectBuild == build then
			print("重复点击")
			return
		elseif build and self.currentSelectBuild and self.currentSelectBuild ~= build then
			if self.currentSelectTip ~= nil then
				self:removeBuildTip()
				self.currentSelectTip = nil
			end
			self:CancelBuildTint(self.currentSelectBuild)
		end
		self.currentSelectBuild = build
		local panel
		local cityBuild = build:getChildByName("buildName")
		dump(cityBuild, "cityBuild========")
		if cityBuild then
			local bid = cityBuild:getBuildBid()
			print("有建筑bid=", bid, ", buildIndex = ", buildIndex, "getState", cityBuild:getState())
			mainCityHandler.checkFinishGuide(buildIndex)
			mainCityBuildingMove = mainCityHandler.checkFinishGuide
			mainCityHandler.checkFinishGuide[BUILDID.CHARIOT_PLANT] = true
			mainCityHandler.checkFinishGuide[BUILDID.STABLES] = true
			mainCityHandler.checkFinishGuide[BUILDID.RANGE] = true
			mainCityHandler.checkFinishGuide[BUILDID.BARRACKS] = true
			mainCityHandler.checkFinishGuide[BUILDID.FORTRESS] = true
			mainCityHandler.checkFinishGuide[BUILDID.ELITE_PALACE] = true
			mainCityHandler.checkFinishGuide[BUILDID.STAR_BRAVE_STATUE] = true
			mainCityHandler.checkFinishGuide[BUILDID.DRILL_GROUDS] = true
			mainCityHandler.checkFinishGuide[BUILDID.MONUMENT] = true
			mainCityHandler.checkFinishGuide[BUILDID.MARKET] = true
			local mainCityHandler.checkFinishGuide[cityBuildConstDef.fixedBuildDef.EpicBattle], config = true, mainCityHandler.checkFinishGuide
			if config[bid] and not include("pyramidWarltCtrl").checkPwXianXiaSai() then
				self.currentSelectBuild = nil
				return
			end
			if cityBuild:getIsOpening() then
				if bid == BUILDID.BLACK_SMITH then
				end
				print("退出 mainCityView:buildButtonCallFun cityBuild:getIsOpening()")
				return
			end
			if cityBuild:getBuildBid() == BUILDID.CRYSTAL_MINE then
				local isLockVisible = cityBuild:getIsLockVisible()
				if isLockVisible == true then
					return
				end
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					mainCityBuildingMove = cityBuild:getState()
					cityBuild:getState().lv = 3
					SoraDShowMsgTip(i18n("common_text_3970", cityBuild:getState()))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			end
			if cityBuild:getIsCanSpeedUpStrongFree() == true then
				cityBuild:doSpeedUpStrongFree()
				return
			end
			if (cityBuild:getState() == "building" or cityBuild:getState() == "demolishing") and cityBuild:getIsCanSpeedUpFree() == true then
				cityBuild:doSpeedUpFree()
				print("退出 mainCityView:buildButtonCallFun cityBuild:getIsCanSpeedUpFree() == true")
				return
			end
			if cityBuild:getState() == "harvesting" then
				if cityBuild:canHarvestBatchRes() then
					cityBuild:harvestBatchRes()
				else
					cityBuild:doHarvesting()
				end
				if not isSelected then
					self.currentSelectBuild = nil
					return
				end
			end
			if cityBuild:getBuildBid() == BUILDID.MATERIAL_WORKSHOP and cityBuild:getState() == "working" and cityBuild:getIsCanHarvestTrain() then
				print("----------材料工坊----------- 是工作状态，同时有物品没领取------")
				cityBuild:doHarvesting()
				self.currentSelectBuild = nil
				return
			end
			if cityBuild:getState() == "working" and cityBuild:getIsCanResearchFree() == true then
				cityBuild:doSpeedUpResearchFree()
				return
			end
			if (cityBuild:getState() == "building" or cityBuild:getState() == "idle" or cityBuild:getState() == "working") and cityBuild:getIsNeedReqHelp() == true then
				cityBuild:doReqHelp()
				print("退出 mainCityView:buildButtonCallFun cityBuild:getIsNeedReqHelp() == true")
				return
			end
			if cityBuild:getState() == "idle" and true == cityBuild:getHasAnyAllianceHelpList() then
				cityBuild:doAllianceHelpAll()
				print("退出 mainCityView:buildButtonCallFun cityBuild:getState() == idle and true == cityBuild:getHasAnyAllianceHelpList() ")
				return
			end
			if cityBuild:getBuildBid() == BUILDID.TURRET then
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					local msgNotice = include("msgNotice")
					msgNotice.notice("notice_0056")
					print("退出 mainCityView:buildButtonCallFun isLocked == true")
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			end
			if cityBuild:getBuildBid() == BUILDID.BLACK_SMITH then
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					local msgNotice = include("msgNotice")
					msgNotice.notice("common_text_796")
					print("退出 mainCityView:buildButtonCallFun isLocked == true")
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			end
			if cityBuild:getBuildBid() == BUILDID.MATERIAL_WORKSHOP then
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					mainCityBuildingMove = self
					self.name = i18n("common_text_2123")
					self.lv = 10
					local tipInfo = i18n("common_text_2122", self)
					local iconSprite = display.newSprite("#" .. "gongfang.png")
					SoraDShowMsgTip(tipInfo, iconSprite)
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			end
			if cityBuild:getBuildBid() == BUILDID.HALL_OF_WAR then
				local isFighting = cityBuild.getIsFighting and cityBuild:getIsFighting() or false
				if isFighting == true then
					uiManager:show("AllianceWarView")
					return
				end
			end
			if cityBuild:getBuildBid() == BUILDID.MATERIAL_WORKSHOP then
				uiManager:show("MaterialFactory")
				return
			end
			if cityBuild:getBuildBid() == cityBuildConstDef.fixedBuildDef.PetCenter then
				local isLocked, unlocklevel = cityBuild:getIsLocked()
				if isLocked then
					mainCityBuildingMove = SoraDGetChildByName(cityBuild, "buildImg")
					SoraDGetChildByName(cityBuild, "buildImg").name = i18n("common_text_2915")
					SoraDGetChildByName(cityBuild, "buildImg").lv = unlocklevel
					SoraDShowMsgTip(i18n("common_text_2122", SoraDGetChildByName(cityBuild, "buildImg")))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == cityBuildConstDef.fixedBuildDef.LeisureCenter then
				local isLocked, unlocklevel = cityBuild:getIsLocked()
				if isLocked then
					mainCityBuildingMove = SoraDGetChildByName(cityBuild, "buildImg")
					SoraDGetChildByName(cityBuild, "buildImg").name = i18n("common_text_1138")
					SoraDGetChildByName(cityBuild, "buildImg").lv = unlocklevel
					SoraDShowMsgTip(i18n("common_text_2122", SoraDGetChildByName(cityBuild, "buildImg")))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == cityBuildConstDef.fixedBuildDef.ResurrectionHall then
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					SoraDShowMsgTip(i18n("common_text_3499"))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == BUILDID.HERO_TRAIN_GROUND then
				local isLocked, unlocklevel = cityBuild:getIsLocked()
				if isLocked then
					mainCityBuildingMove = SoraDGetChildByName(cityBuild, "buildImg")
					SoraDGetChildByName(cityBuild, "buildImg").name = i18n("buildDes_name_123")
					SoraDGetChildByName(cityBuild, "buildImg").lv = unlocklevel
					SoraDShowMsgTip(i18n("common_text_2122", SoraDGetChildByName(cityBuild, "buildImg")))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == BUILDID.WATCH_TOWER then
				local isLocked, unlocklevel = cityBuild:getIsLocked()
				if isLocked then
					mainCityBuildingMove = SoraDGetChildByName(cityBuild, "buildImg")
					SoraDGetChildByName(cityBuild, "buildImg").name = i18n("buildDes_name_104")
					SoraDGetChildByName(cityBuild, "buildImg").lv = unlocklevel
					SoraDShowMsgTip(i18n("common_text_2122", SoraDGetChildByName(cityBuild, "buildImg")))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == BUILDID.HERO_PRISON then
				local isLocked, unlocklevel = cityBuild:getIsLocked()
				if isLocked then
					mainCityBuildingMove = SoraDGetChildByName(cityBuild, "buildImg")
					SoraDGetChildByName(cityBuild, "buildImg").name = i18n("buildDes_name_125")
					SoraDGetChildByName(cityBuild, "buildImg").lv = unlocklevel
					SoraDShowMsgTip(i18n("common_text_2122", SoraDGetChildByName(cityBuild, "buildImg")))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == BUILDID.EMBASSY then
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					local unlockLv = cityltCtrl.buildAttr(BUILDID.EMBASSY, BUILD_ATTR.UNLOCKLEVEL)
					mainCityBuildingMove = SoraDGetChildByName(cityBuild, "buildImg")
					SoraDGetChildByName(cityBuild, "buildImg").name = i18n("buildDes_name_111")
					SoraDGetChildByName(cityBuild, "buildImg").lv = unlockLv
					SoraDShowMsgTip(i18n("common_text_2122", SoraDGetChildByName(cityBuild, "buildImg")))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == cityBuildConstDef.fixedBuildDef.EpicBattle then
				local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.SOLDIER_GAME)
				if unlockLv > SoraDGetCastleLv() then
					mainCityBuildingMove = SoraDGetChildByName(cityBuild, "buildImg")
					SoraDGetChildByName(cityBuild, "buildImg").name = i18n("soldier_rush_text_01")
					SoraDGetChildByName(cityBuild, "buildImg").lv = unlockLv
					SoraDShowMsgTip(i18n("common_text_2122", SoraDGetChildByName(cityBuild, "buildImg")))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
				else
					cityltCtrl = self
					self[1] = cca.callFunc(function()
						self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
						self.buttonEpicBattle:setEnabled(false)
						self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					end)
					self[2] = cca.delay(0.3)
					self[3] = cca.callFunc(function()
						uiManager:show("SoldierRushChapter")
					end)
					self[4] = cca.delay(0.3)
					self[5] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[6] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[7] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[8] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[9] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[10] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[11] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[12] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[13] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[14] = cca.callFunc(function()
						self.buttonEpicBattle:setEnabled(true)
						self.buttonEpicBattle:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					local seqAct = cca.seq(self)
					mainCity:runAction(seqAct)
				end
				return
			elseif cityBuild:getBuildBid() == BUILDID.MONUMENT then
				local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.LEGEND_HISTORY)
				if unlockLv > SoraDGetCastleLv() then
					mainCityBuildingMove = seqAct
					seqAct.name = i18n("history_name_11")
					seqAct.lv = unlockLv
					SoraDShowMsgTip(i18n("common_text_2122", seqAct))
					return
				end
				if not commonCheck.LEGEND_M then
					return
				end
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					mainCityBuildingMove = i18n("common_text_2122", seqAct)
					i18n("common_text_2122", seqAct).name = i18n("history_name_11")
					i18n("common_text_2122", seqAct).lv = CASTLE_LV6_LIMITED
					SoraDShowMsgTip(i18n("common_text_2122", i18n("common_text_2122", seqAct)))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				else
					cityltCtrl = self
					self[1] = cca.callFunc(function()
						self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
						self.buttonMonument:setEnabled(false)
						self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					end)
					self[2] = cca.delay(0.3)
					self[3] = cca.callFunc(function()
						uiManager:show("LegendMain")
					end)
					self[4] = cca.delay(0.3)
					self[5] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[6] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[7] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[8] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[9] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[10] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[11] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[12] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					self[13] = cca.callFunc(function()
						self.buttonMonument:setEnabled(true)
						self.buttonMonument:setSwallowTouches(false)
						if self.currentSelectBuild == build then
							self.currentSelectBuild = nil
						end
					end)
					local seqAct = cca.seq(self)
					mainCity:runAction(seqAct)
				end
				return
			elseif cityBuild:getBuildBid() == cityBuildConstDef.fixedBuildDef.Mastery then
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					mainCityBuildingMove = mainCity
					mainCity.name = i18n("specialization_text_01")
					mainCity.lv = CASTLE_LV15_LIMITED
					SoraDShowMsgTip(i18n("common_text_2122", mainCity))
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == BUILDID.NEBULA_PALACE then
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
					if nebulaActivityCtrl:getActivityCurState() < NEBULA_REGION_STATE.REGION_SHOW or nebulaActivityCtrl:getActivityCurState() > NEBULA_REGION_STATE.SETTLE then
						SoraDShowMsgTip(i18n("nebula_war_text_0204"))
					else
						SoraDShowMsgTip(i18n("nebula_war_text_0243"))
					end
					gModuleMgr.sharedMgr("mildGuideManager"):clean()
					self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
					return
				end
			elseif cityBuild:getBuildBid() == BUILDID.MAGIC_LAMP then
				local isLocked = cityBuild:getIsLocked()
				if isLocked == true then
					local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
					if magicLampCtrl:getIsCanUnlock() then
						self:ShowNodeTintOnce(SoraDGetChildByName(cityBuild, "buildImg"))
						magicLampCtrl:reqMagicLampUnlock()
					else
						local constantRead = include("constantRead")
						local needCastleStarLv = math.floor(constantRead.getConstValue("UNLOCK_CONDITION"), 0)
						mainCityBuildingMove = SoraDGetChildByName(cityBuild, "buildImg")
						SoraDGetChildByName(cityBuild, "buildImg").num = needCastleStarLv
						SoraDShowMsgTip(i18n("magic_lamp_tips_013", SoraDGetChildByName(cityBuild, "buildImg")))
					end
					return
				end
			elseif cityBuild:getBuildBid() == BUILDID.NEWBORN_TREE then
				local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
				if not divineBeastCtrl:getIsUnlock() then
					local divineBeastRead = include("divineBeastRead")
					local defaultDivineID = divineBeastRead.getDefaultDivineID()
					local dbCfg = divineBeastRead.getDbCfg(defaultDivineID)
					mainCityBuildingMove = i18n("magic_lamp_tips_013", SoraDGetChildByName(cityBuild, "buildImg"))
					i18n("magic_lamp_tips_013", SoraDGetChildByName(cityBuild, "buildImg")).lv = dbCfg.unlock[2]
					SoraDShowMsgTip(i18n("common_text_4777", i18n("magic_lamp_tips_013", SoraDGetChildByName(cityBuild, "buildImg"))))
					return
				end
			elseif not cityBuild:checkBuildClick() then
				self.currentSelectBuild = nil
				return
			end
			if cityBuild:getBuildBid() == BUILDID.ELITE_PALACE then
				return
			end
			if cityBuild:getBuildBid() == BUILDID.MARKET then
				local gametop = gModuleMgr.getObject("gametop")
				local guideCtrl = gametop.playertop_:getModule("guideCtrl")
				local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
				local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
				local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
				local worldMapDefine = include("worldMapDefine")
				if worldMapDefine:isInWar() or conquestWarCtrl:isPlayerConquestWarMigration() and 0 < lordInfoCtrl:getSourceKid() or not activityShowCtrl:isActivityOpen(gActivityTimeActivityID.SALESROOM_ACTIVITY) then
				else
					local funUnlockRead = include("funUnlockRead")
					local unlockLv = funUnlockRead.getLvByOpName(BOP_NAME.BOP_AUCTION)
					local hasGuide = guideCtrl:isGuideNotCompleted(gGuideModule.AUCTION)
					if (unlockLv == nil or unlockLv <= SoraDGetCastleLv()) and hasGuide then
						if cityBuild.removeGuideEffect then
							cityBuild:removeGuideEffect()
						end
						guideCtrl:updateGuideModule(gGuideModule.AUCTION)
						gModuleMgr.sharedMgr("mildGuideManager"):clean()
					end
				end
			end
			if cityBuild:getBuildBid() == BUILDID.DRILL_GROUDS then
				local gametop = gModuleMgr.getObject("gametop")
				local guideCtrl = gametop.playertop_:getModule("guideCtrl")
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				local cLevel = cityCtrl:getBuildMaxLv(BUILDID.DRILL_GROUDS)
				local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
				local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
				local isOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.ARENA_ACTIVITY)
				local hasGuide = guideCtrl:isGuideNotCompleted(gGuideModule.ARENA)
				if hasGuide and cLevel >= CASTLE_LV16_LIMITED and isOpen and 0 >= lordInfoCtrl:getSourceKid() then
					cityBuild:removeGuideEffect()
					guideCtrl:updateGuideModule(gGuideModule.ARENA)
				end
			end
			if cityBuild:getBuildBid() == cityBuildConstDef.fixedBuildDef.LeisureCenter then
				local gametop = gModuleMgr.getObject("gametop")
				local guideCtrl = gametop.playertop_:getModule("guideCtrl")
				local hasGuide = guideCtrl:isGuideNotCompleted(gGuideModule.FRIEND)
				if hasGuide and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
					print("开始好友系统引导")
					guideCtrl:updateGuideModule(gGuideModule.FRIEND)
				end
			end
			if cityBuild:getBuildBid() == cityBuildConstDef.fixedBuildDef.HuoChuang then
				local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.CARGO_SHIP)
				if unlockLv > SoraDGetCastleLv() then
					mainCityBuildingMove = guideCtrl
					guideCtrl.name = i18n("common_text_2478")
					guideCtrl.lv = unlockLv
					SoraDShowMsgTip(i18n("common_text_2122", guideCtrl))
					return
				end
			end
			mainCityBuildingMove = SoraDShowMsgTip
			SoraDShowMsgTip.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP"
			SoraDShowMsgTip.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP
			SoraDSendMessage(SoraDShowMsgTip)
			local buidSize = build:getContentSize()
			if not self.cacheTip then
				local view = include("buildTipPanel")
				panel = view.new(getCCSPath("buildTip"))
				panel:addTo(self.containerView, 1000000)
				panel:setLocalZOrder(10000)
				panel:setGlobalZOrder(10000)
				self.cacheTip = panel
			else
			end
			panel = self.cacheTip
			panel:setVisible(true)
			panel:setRelyBuildBtnId(build:getTag())
			print("Button Index :" .. build:getTag())
			print("CityBuildUId:" .. cityBuild:getTag())
			panel:setRelyBuildUId(cityBuild:getTag())
			self.currentSelectTip = panel
			panel:setRelyBuildCfgId(cityBuild:getBuildBid())
			print("bid = " .. cityBuild:getBuildBid())
			panel:setRelyBuildIid(cityBuild:getIid())
			panel:setRelyBuildEntity(cityBuild)
			panel:initView(self:getZoomScale(true))
			local x, y = build:getPosition()
			local offset = cityBuildViewDef.getBuildTipOffset(bid)
			if bid == BUILDID.CASTLE then
				offset = cc.p(100, -190)
			end
			panel:setPosition(cc.p(x + offset.x, y + offset.y))
			self:ShowBuildTint(build)
			GameGuideLog("退出 mainCityView:buildButtonCallFun cityBuild")
			_ENV = cc.p(x + offset.x, y + offset.y)
			cc.p(x + offset.x, y + offset.y)[1] = cca.delay(0.001)
			cc.p(x + offset.x, y + offset.y)[2] = cca.callFunc(function()
				if gSoundDataList.innerbuildsound[cityBuild:getBuildBid()] then
					self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
				end
			end)
			cc.p(x + offset.x, y + offset.y)[3] = cca.callFunc(function()
				if gSoundDataList.innerbuildsound[cityBuild:getBuildBid()] then
					self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
				end
			end)
			cc.p(x + offset.x, y + offset.y)[4] = cca.callFunc(function()
				if gSoundDataList.innerbuildsound[cityBuild:getBuildBid()] then
					self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
				end
			end)
			cc.p(x + offset.x, y + offset.y)[5] = cca.callFunc(function()
				if gSoundDataList.innerbuildsound[cityBuild:getBuildBid()] then
					self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
				end
			end)
			cc.p(x + offset.x, y + offset.y)[6] = cca.callFunc(function()
				if gSoundDataList.innerbuildsound[cityBuild:getBuildBid()] then
					self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
				end
			end)
			cc.p(x + offset.x, y + offset.y)[7] = cca.callFunc(function()
				if gSoundDataList.innerbuildsound[cityBuild:getBuildBid()] then
					self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
				end
			end)
			cc.p(x + offset.x, y + offset.y)[8] = cca.callFunc(function()
				if gSoundDataList.innerbuildsound[cityBuild:getBuildBid()] then
					self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
				end
			end)
			cc.p(x + offset.x, y + offset.y)[9] = cca.callFunc(function()
				if gSoundDataList.innerbuildsound[cityBuild:getBuildBid()] then
					self:playSound("innerbuildsound", cityBuild:getBuildBid(), cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
				end
			end)
			cityBuild:runAction(cca.seq(cc.p(x + offset.x, y + offset.y)))
		else
			do
				local buildIndex = build:getTag()
				local buildType = SoraDGetBuildTypeByIndex(buildIndex)
				local isFixedBuild = SoraDIsFixedBuild(buildIndex)
				if isFixedBuild == true then
					SoraDShowMsgTip(i18n("notice_0026"))
					return
				end
				local callFuncCreate = cca.callFunc(function()
					print("打开 buildCreatePanel")
					local index = build:getTag()
					if index == cityBuildConstDef.buildIndexDef.index_Miracle then
						local _iscanbuild, retdata = buildLogic.isCanBuild(BUILDID.MIRACLE)
						_ENV = nil
						;(nil).bid = BUILDID.MIRACLE
						local (nil).iscanbuild, tableCurBuild = _iscanbuild, nil
						local tableCurRetdata = retdata
						_ENV, _ENV = nil, nil
						;(nil).buildID = tableCurBuild
						_ENV, (nil).buildData = nil, tableCurRetdata
						;(nil).buildType = buildType
						;(nil).buildData, (nil).buildType, (nil).buildIndex = nil, nil, index
						uiManager:show("BuildCreateInfo", nil)
					else
						if build:getTag() == 1202 then
							return
						end
						_ENV = build:getTag()
						build:getTag().buildType = buildType
						local build:getTag().buildIndex, param = build:getTag(), build:getTag()
						if buildID then
							param.buildID = buildID
						end
						uiManager:show("BuildCreate", param)
					end
					_ENV = uiManager.show
					uiManager.show.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
					uiManager.show.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
					uiManager.show.buildIndex = buildIndex
					SoraDSendMessage(uiManager.show)
				end)
				local spriteTile
				if buildType == 0 then
					if buildIndex == cityBuildConstDef.buildIndexDef.index_Miracle then
						spriteTile = display.newSprite("#" .. "BG_miracle_01.png")
					else
						spriteTile = display.newSprite("#" .. "inner_city_building_tile.png")
					end
					if spriteTile then
						build:addChild(spriteTile)
						if buildIndex == cityBuildConstDef.buildIndexDef.index_Miracle then
							print("到这里=====1")
							spriteTile:setPosition(cc.p(129, 51))
						else
							print("到这里=====2")
							spriteTile:setPosition(cc.p(153, 67))
						end
					end
				else
					local spriteTileName = "res_tile" .. buildIndex
					spriteTile = self.batchNodeOuterTiles:getChildByName(spriteTileName)
				end
				build:setTouchEnabled(false)
				local callFunc1 = cca.callFunc(function()
					if spriteTile then
						local actionTintTo = cca.tintBy(0.1, -0.5, -0.5, -0.5)
						spriteTile:runAction(actionTintTo)
					end
					SoraDShowLoading(nil, nil, 1000, true)
				end)
				local delay1 = cca.delay(0.2)
				local delay2 = cca.delay(0.1)
				local callFunc2 = cca.callFunc(function()
					SoraDCloseLoading(nil, 1000)
					if buildType == 0 and spriteTile ~= nil and spriteTile.removeFromParent then
						local callRemve = cca.callFunc(function()
							if spriteTile and spriteTile.removeFromParent then
								spriteTile:removeFromParent()
							end
						end)
						local fadeOut = cca.fadeOut(0.1)
						spriteTile = nil
						;(nil)[1] = fadeOut
						;(nil)[2] = callRemve
						spriteTile:runAction(cca.seq(nil))
					end
					build:setTouchEnabled(true)
					build:setSwallowTouches(false)
					self.isBuildBtnEnable = true
				end)
				self:buildCreatePanelShowBegin()
				self.isBuildBtnEnable = false
				gametop = "seq"
				;("seq")[1] = callFunc1
				;("seq")[2] = delay1
				;("seq")[3] = callFuncCreate
				;("seq")[4] = delay2
				;("seq")[5] = callFunc2
				build:runAction(cca.seq("seq"))
			end
		end
	end
end
function mainCityHandler.viewOnClick(mainCity, ref, event)
	local self = mainCity
	if event == ccui.TouchEventType.began then
		self.isShowBuildName = false
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_UPDATE_IDLE_GUIDE"
		SoraDSendMessage(nil)
		local touchBeganPoint = self.touchlayer:getTouchBeganPosition()
		local topTipNode = self:getTopTipOnTouch(touchBeganPoint)
		if nil ~= topTipNode then
			self.isOnCollectMode = true
			self.touchlayer:setSwallowTouches(true)
			local buildIndex = topTipNode:getTag()
			local buildBtnName = "build_" .. buildIndex
			local buildBtn = self:getBufferNodeByName(buildBtnName)
			if buildBtn then
				local buildEntity = SoraDGetChildByName(buildBtn, "buildName")
				if buildEntity and buildEntity:getState() == "harvesting" then
					buildEntity:harvestBatchRes()
					_ENV = buildEntity
					buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP_HAND"
					SoraDSendMessage(buildEntity)
				end
			end
		else
		end
	end
	if event == ccui.TouchEventType.ended then
		self.isShowBuildName = false
		_ENV = self:getTopTipOnTouch(touchBeganPoint)
		self:getTopTipOnTouch(touchBeganPoint).msg = "MESSAGE_HIDE_NAME_ON_TOUCH"
		SoraDSendMessage((self:getTopTipOnTouch(touchBeganPoint)))
		self:ResumeCastleCriSpriteOnScroll()
		if self.isOnCollectMode == true then
			self.isOnCollectMode = false
			self.touchlayer:setSwallowTouches(false)
			return
		end
		if not self.isMoved then
			if self.curPlaySound == nil then
				print("播放默认声音")
				self:playSound("normalcontrol", 1, cityBuildConstDef.ActionTag.Tag_Play_Click_Default_Sound, 0.1)
				if cityHorseCtrl:isCanClick() then
					cityHorseCtrl:sendClick()
				else
				end
			end
			local touchEndPoint = self.touchlayer:getTouchEndPosition()
			local effectPos = self.containerView:convertToNodeSpace(touchEndPoint)
			self:addTouchParticle(effectPos)
			if self.currentSelectTip then
				self:removeBuildTip()
			end
			if self.currentSelectBuild then
				self:CancelBuildTint(self.currentSelectBuild)
				self.currentSelectBuild = nil
			end
		end
		self.isMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = self.touchlayer:getTouchBeganPosition()
		local touchmovePoint = self.touchlayer:getTouchMovePosition()
		if self.isOnCollectMode == true then
			local topTipNode = self:getTopTipOnTouch(touchmovePoint)
			if nil ~= topTipNode then
				local buildIndex = topTipNode:getTag()
				local buildBtnName = "build_" .. buildIndex
				local buildBtn = self:getBufferNodeByName(buildBtnName)
				if buildBtn then
					local buildEntity = SoraDGetChildByName(buildBtn, "buildName")
					if buildEntity and buildEntity:getState() == "harvesting" then
						buildEntity:harvestBatchRes()
						_ENV = buildEntity
						buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP_HAND"
						SoraDSendMessage(buildEntity)
					end
				end
			end
			return
		end
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		local direction = touchmovePoint.x - touchBeganPoint.x
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
			if self.isShowBuildName == false then
				self.isShowBuildName = true
				if SoraDConfigGet("Game:GameOptionsView:showBuildName~bool") == true then
					_ENV = "Game:GameOptionsView:showBuildName~bool"
					;("Game:GameOptionsView:showBuildName~bool").msg = "MESSAGE_SHOW_NAME_ON_TOUCH"
					SoraDSendMessage("Game:GameOptionsView:showBuildName~bool")
				end
			end
		end
	elseif event == ccui.TouchEventType.canceled then
		self.isShowBuildName = false
		_ENV = self.touchlayer:getTouchMovePosition()
		self.touchlayer:getTouchMovePosition().msg = "MESSAGE_HIDE_NAME_ON_TOUCH"
		SoraDSendMessage((self.touchlayer:getTouchMovePosition()))
		self.isOnCollectMode = false
		self.touchlayer:setSwallowTouches(false)
		self:ResumeCastleCriSpriteOnScroll()
	end
end
function mainCityHandler.onTopTipCallBack(mainCity, btnTopTip, ref, event)
	local self = mainCity
	local btn = ref
	local btnIndex = btn:getTag()
	if event == ccui.TouchEventType.began then
		return false
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.ended then
		local buildBtnName = "build_" .. btnIndex
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		if nil == buildBtn then
			return
		end
		local buildEntity = SoraDGetChildByName(buildBtn, "buildName")
		if nil == buildEntity then
			return
		end
		local bid = buildEntity:getBuildBid()
		if bid == BUILDID.HALL_OF_WAR and buildEntity.getIsFighting and buildEntity:getIsFighting() == true then
			uiManager:show("AllianceWarView")
			return
		end
		if true == buildEntity:getIsCanSpeedUpStrongFree() then
			buildEntity:doSpeedUpStrongFree()
			return
		end
		if true == buildEntity:getIsCanSpeedUpFree() then
			buildEntity:doSpeedUpFree()
			return
		end
		if true == buildEntity:getIsCanResearchFree() then
			buildEntity:doSpeedUpResearchFree()
			return
		end
		if buildEntity:getIsNeedReqHelp() == true then
			buildEntity:doReqHelp()
			return
		end
		if buildEntity:getState() == "harvesting" then
			buildEntity:doHarvesting()
			_ENV = buildEntity
			buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP_HAND"
			SoraDSendMessage(buildEntity)
			return
		end
		if buildEntity:getBuildBid() == BUILDID.MATERIAL_WORKSHOP and buildEntity:getState() == "working" and buildEntity:getIsCanHarvestTrain() then
			print("----------材料工坊----------- 是工作状态，同时有物品没领取------")
			buildEntity:doHarvesting()
			_ENV = buildEntity
			buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP_HAND"
			SoraDSendMessage(buildEntity)
			return
		end
		if buildEntity:getState() == "idle" and buildEntity:getHasAnyAllianceHelpList() then
			buildEntity:doAllianceHelpAll()
			return
		end
		if buildEntity:getBuildBid() == BUILDID.MARKET then
			if buildEntity:hasGuide() then
				print("点击了市场的顶部提示 ----")
				self:buildButtonCallFun(buildBtn, buildBtn, ccui.TouchEventType.ended)
				return
			elseif SoraDGetCtrl("salesRoomAgCtrl"):getHint() then
				_ENV = buildBtn
				buildBtn.tag = 2
				uiManager:show("tradeBoardView", buildBtn)
			elseif buildEntity:hasAuctionGold() and SoraDGetCtrl("salesRoomAgCtrl"):checkOpenCond() then
				uiManager:show("tradeBoardView")
				SoraDPlaySound("buildopsound", "OpAuction")
			end
		elseif buildEntity:getBuildBid() == BUILDID.DRILL_GROUDS then
			if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
				return
			end
			if buildEntity:hasGuide() then
				print("点击了校场的顶部提示 ----")
				self:buildButtonCallFun(buildBtn, buildBtn, ccui.TouchEventType.ended)
				return
			end
		elseif buildEntity:getBuildBid() == BUILDID.BLACK_SMITH then
			print("点击了铁匠铺的顶部提示 ----")
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_GOD_UNLOCK then
				buildEntity:jumpToArtifact()
			end
			return
		elseif buildEntity:getBuildBid() == cityBuildConstDef.fixedBuildDef.PetCenter then
			print("这是宠物馆")
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_PET_UNLOCK then
				print("这是可解锁按钮")
				local hasCanUnlockPet, petIdList = buildEntity:hasCanUnlockPet()
				if hasCanUnlockPet then
					_ENV = nil
					;(nil).petid = petIdList[1]
					uiManager:show("PetFguiView", nil)
				end
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_PET_SKILL_SEND then
				print("这是主动技能按钮")
				if buildEntity:hasCanClaimGoodid() then
					local gametop = gModuleMgr.getObject("gametop")
					local petCtrl = gametop.playertop_:getModule("petCtrl")
					local from = "petCenter"
					petCtrl:reqOnkeyGetSpecialTool(from)
				else
					uiManager:show("PetFguiView")
				end
			end
		elseif buildEntity:getBuildBid() == BUILDID.WALLS then
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_DEFEND_EMPTYSITE then
				print("todo:caituo: 打开防御界面")
				uiManager:show("defendView")
				_ENV = uiManager
				uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
				SoraDSendMessage(uiManager)
			end
		elseif buildEntity:getBuildBid() == BUILDID.HERO_TRAIN_GROUND then
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_HERO_REWARD then
				print("有英雄奖励可以领取-----")
				local worldMapWarDef = include("worldMapWarDef")
				worldMapWarDef.openHeroTrainListView()
			end
		elseif buildEntity:getBuildBid() == BUILDID.HERO_PRISON then
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_HAS_PRISONER then
				print("监狱")
				uiManager:show("HeroJailList")
			end
		elseif buildEntity:getBuildBid() == BUILDID.MIRACLE then
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_GOD_EQUIP_PROMPT then
				print("神器")
				if SoraDGetCastleLv() < CASTLE_LV40_LIMITED then
					_ENV = petCtrl.reqOnkeyGetSpecialTool
					petCtrl.reqOnkeyGetSpecialTool.level = 1
					SoraDShowMsgTip(i18n("common_text_4094", petCtrl.reqOnkeyGetSpecialTool))
					return
				end
				local panel = SoraDCreatePanel("godEquipmentView")
				panel:show()
			end
		elseif buildEntity:getBuildBid() == BUILDID.MONUMENT then
			if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
				return
			end
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.LEGEND_HISTORY)
			if unlockLv > SoraDGetCastleLv() then
				_ENV = i18n("common_text_4094", petCtrl.reqOnkeyGetSpecialTool)
				i18n("common_text_4094", petCtrl.reqOnkeyGetSpecialTool).name = i18n("history_name_11")
				i18n("common_text_4094", petCtrl.reqOnkeyGetSpecialTool).lv = unlockLv
				SoraDShowMsgTip(i18n("common_text_2122", i18n("common_text_4094", petCtrl.reqOnkeyGetSpecialTool)))
				return
			end
			if commonCheck.LEGEND_M then
				uiManager:show("LegendMain")
			end
		elseif buildEntity:getBuildBid() == cityBuildConstDef.fixedBuildDef.LeisureCenter then
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_FRIEND_APPLY then
				uiManager:show("friendView")
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_PYRAMID_ACTIVITY then
				if SoraDGetCastleLv() < CASTLE_LV8_LIMITED then
					local spriteName = "#btn_pyramid.png"
					_ENV = i18n("common_text_2122", i18n("common_text_4094", petCtrl.reqOnkeyGetSpecialTool))
					i18n("common_text_2122", i18n("common_text_4094", petCtrl.reqOnkeyGetSpecialTool)).blv = CASTLE_LV8_LIMITED
					SoraDShowMsgTip(i18n("common_text_1151", i18n("common_text_2122", i18n("common_text_4094", petCtrl.reqOnkeyGetSpecialTool))), spriteName)
				else
					uiManager:show("pyramidMain")
				end
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_PAVILION_ACTIVITY then
				local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
				if exoticPavilionCtrl:getCurStage() == 1 and exoticPavilionCtrl:getCurStep() <= 3 then
					_ENV, funUnlockRead = exoticPavilionCtrl, exoticPavilionCtrl:getCurStep()
					exoticPavilionCtrl.img = "girl"
					_ENV, exoticPavilionCtrl.str = i18n("exitic_pavillion_text_0147"), i18n("exitic_pavillion_text_0147")
					i18n("exitic_pavillion_text_0147").callback = function()
						uiManager:show("ForeignPavilionActivity")
					end
					exoticPavilionCtrl:getCurStep()[1] = exoticPavilionCtrl
					local exoticPavilionCtrl:getCurStep()[2], noticeData = i18n("exitic_pavillion_text_0147"), exoticPavilionCtrl:getCurStep()
					gModuleMgr.sharedMgr("mildGuideManager"):createNoticeLine(noticeData)
				else
					uiManager:show("ForeignPavilionActivity")
				end
			end
		elseif buildEntity:getBuildBid() == BUILDID.NEBULA_PALACE then
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEBULA_TECH_REWARD then
				print("有奖励可以领取-----")
				local loginRewardCtrl = SoraDGetCtrl("loginRewardCtrl")
				local rewardType = loginRewardCtrl:getIsCanReceiveNebulaReward1() and 1 or loginRewardCtrl:getIsCanReceiveNebulaReward2() and 2 or 0
				if rewardType ~= 0 then
					local technologyCtrl = SoraDGetCtrl("technologyCtrl")
					local addV1 = technologyCtrl:getTechnologyPower(gTechnologyType.DAILY_RECEIVE_METEORITE_LV_ADD)
					local addV2 = technologyCtrl:getTechnologyPower(gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD)
					local technologyLocalData = include("technologyLocalData")
					local rewards = technologyLocalData.getNebulaTechReward(1, addV1)
					local rewards2 = technologyLocalData.getNebulaTechReward(2, addV2)
					for k, v in pairs(rewards2) do
						local isIn = false
						for k2, v2 in pairs(rewards) do
							if v.id == v2.id then
								v2.count = v2.count + v.count
								isIn = true
								break
							end
						end
						if not isIn then
							table.insert(rewards, v)
						end
					end
					SoraDMailGainItems(rewards, true)
					loginRewardCtrl:nebulaDailyReward(rewardType)
				end
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEBULA_TECH_UP then
				uiManager:show("NebulaAreaTech")
			end
		elseif buildEntity:getBuildBid() == BUILDID.NEWBORN_TREE then
			print("初生之树（神兽建筑)", btnTopTip.topType)
			local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
			local isShow, beastId = divineBeastCtrl:getIsShowBubble(btnTopTip.topType)
			print("debug btnTopTip.topType", btnTopTip.topType, isShow, beastId)
			if btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_CANYON then
				local activityID = gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
				clientEventMgr.singleClickEvent(activityID)
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_53 then
				local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
				clientEventMgr.singleClickEvent(activityID)
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_STARUP then
				_ENV = isShow
				isShow.page = 1
				isShow.beastId = beastId
				uiManager:show("MythicalCreaturesView", isShow)
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_STEPUP or btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_ATTUP then
				_ENV = isShow
				isShow.page = 2
				isShow.beastId = beastId
				uiManager:show("MythicalCreaturesView", isShow)
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_TREAT or btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_MARK then
				_ENV = isShow
				isShow.page = 3
				isShow.beastId = beastId
				uiManager:show("MythicalCreaturesView", isShow)
			elseif btnTopTip.topType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_TASK then
				_ENV = "MythicalCreaturesView"
				;("MythicalCreaturesView").scene = 1
				userSDKManager.logEvent(gSDKDef.TDonEvent.divine_beast_action_task, "MythicalCreaturesView")
				_ENV = isShow
				isShow.page = 3
				uiManager:show("MythicalCreaturesView", isShow)
				uiManager:show("MythicalCreaturesTask")
			end
		else
			buildEntity:onClickBuildTopTip(btnTopTip.topType)
		end
	elseif event == ccui.TouchEventType.canceled then
	end
end
function mainCityHandler.otherBuildButtonCallFun(mainCity, build, ref, type)
	local self = mainCity
	local safe_tint_call = function(data)
		if data.btnTarget then
			data.btnTarget:setEnabled(false)
		end
		if data.soundId then
			if data.classify then
				self:playSound(data.classify, data.soundId, cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
			else
				self:playSound("innerbuildsound", data.soundId, cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
			end
		else
		end
		if data.tintTarget then
			mainCity:ShowNodeTintOnce(data.tintTarget)
		end
		if data.tintTarget2 then
			mainCity:ShowNodeTintOnce(data.tintTarget2)
		end
		local actionDelay = cca.delay(0.3)
		local callFunc = cca.callFunc(function()
			if device.platform == "mac" or userSDKManager.isBeta() then
				data.callback()
			else
				xpcall(data.callback, function()
					print("Note!!!!Open View Error!! --- mainCityHandler.otherBuildButtonCallFun(mainCity, build,ref, type)")
				end)
			end
			if data.btnTarget then
				data.btnTarget:setEnabled(true)
				data.btnTarget:setSwallowTouches(false)
			end
		end)
		mainCity = data.soundId
		data.soundId[1] = actionDelay
		data.soundId[2] = callFunc
		local seqAct = cca.seq(data.soundId)
		mainCity:runAction(seqAct)
	end
	if self.isNeedFirstFight == true then
		return
	end
	if self.isBuildBtnEnable == false then
		return
	end
	if type == ccui.TouchEventType.moved then
		local touchBeganPoint = build:getTouchBeganPosition()
		local touchmovePoint = build:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoveOnBuild = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.isMoveOnBuild = false
	elseif type == ccui.TouchEventType.began then
		self.isMoveOnBuild = false
	elseif type == ccui.TouchEventType.ended then
		if self.isMoveOnBuild then
			self.isMoveOnBuild = false
			return
		end
		if self.isOnMoveMode == true then
			return
		end
		if self.buttonActivity == build then
			cityBuildConstDef = build:getTouchMovePosition()
			build:getTouchMovePosition().soundId = 106
			build:getTouchMovePosition().tintTarget = self:getBufferNodeByName("Img_Activity")
			build:getTouchMovePosition().btnTarget = self.buttonActivity
			build:getTouchMovePosition().callback = function()
				local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.EVENT_CENTER)
				if unlockLv > SoraDGetCastleLv() then
					funUnlockRead = nil
					;(nil).name = i18n("buildDes_name_106")
					;(nil).lv = unlockLv
					SoraDShowMsgTip(i18n("common_text_2122", nil))
				elseif worldMapDefine.isInNewTrial() then
					SoraDShowMsgTip(i18n("devilvalley_tips_08"))
				else
					uiManager:show("EventCenterView")
				end
			end
			safe_tint_call((build:getTouchMovePosition()))
		elseif self.buttonPyramidBattle == build then
			cityBuildConstDef = build:getTouchMovePosition()
			build:getTouchMovePosition().tintTarget = self:getBufferNodeByName("Img_pyramid_battle")
			build:getTouchMovePosition().btnTarget = self.buttonPyramidBattle
			build:getTouchMovePosition().callback = function()
				local pyramidClientModule = include("pyramidClientModule")
				pyramidClientModule.popSelectMenu()
			end
			safe_tint_call((build:getTouchMovePosition()))
		elseif self.buttonLion == build then
			cityBuildConstDef = build:getTouchMovePosition()
			build:getTouchMovePosition().soundId = 107
			build:getTouchMovePosition().tintTarget = self:getBufferNodeByName("BG_lion")
			build:getTouchMovePosition().btnTarget = self.buttonLion
			build:getTouchMovePosition().callback = function()
				local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
				local totalSeason = pyramidWarCtrl.peakSeasonNo - 1
				if pyramidWarCtrl.pinnacleSeasonState == gPinnacleSeasonState.NOT_OPEN then
					totalSeason = totalSeason + 1
				end
				if 1 <= totalSeason then
					SoraDCreatePanel("alliancePBLHonorView"):show()
				else
					SoraDShowMsgTip(i18n("common_text_1036"))
				end
			end
			safe_tint_call((build:getTouchMovePosition()))
		elseif self.buttonMerchante == build then
			cityBuildConstDef = build:getTouchMovePosition()
			build:getTouchMovePosition().soundId = 107
			build:getTouchMovePosition().tintTarget = self:getBufferNodeByName("Img_Lvxingshanren")
			build:getTouchMovePosition().btnTarget = self.buttonMerchante
			build:getTouchMovePosition().callback = function()
				local gametop = gModuleMgr.getObject("gametop")
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				local castleLV = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
				local unlockLv = cityltCtrl.buildAttr(107, BUILD_ATTR.UNLOCKLEVEL)
				if castleLV >= unlockLv then
					local worldMapDefine = include("worldMapDefine")
					if worldMapDefine.isInWar() then
						SoraDShowMsgTip(i18n("common_text_3302"))
					elseif include("pyramidWarltCtrl").checkPwXianXiaSai() then
						uiManager:show("merchanteView")
					end
					local gametop = gModuleMgr.getObject("gametop")
					local guideCtrl = gametop.playertop_:getModule("guideCtrl")
					guideCtrl:updateGuideModule(gGuideModule.DISCOUNT_STORE_GUIDE)
				else
					_ENV = guideCtrl.updateGuideModule
					guideCtrl.updateGuideModule.name = i18n("buildDes_name_107")
					guideCtrl.updateGuideModule.lv = unlockLv
					SoraDShowMsgTip(i18n("common_text_2122", guideCtrl.updateGuideModule))
				end
			end
			safe_tint_call((build:getTouchMovePosition()))
		elseif self.buttonMilitaryInfo == build then
			cityBuildConstDef = build:getTouchMovePosition()
			build:getTouchMovePosition().classify = "innercontrol"
			build:getTouchMovePosition().soundId = 11
			build:getTouchMovePosition().tintTarget = self:getBufferNodeByName("Node_flag")
			build:getTouchMovePosition().btnTarget = self.buttonMilitaryInfo
			build:getTouchMovePosition().callback = function()
				uiManager:show("troopFlagView")
			end
			safe_tint_call((build:getTouchMovePosition()))
		elseif self.buttonServiceCenter == build then
			if self.hasCommunityCenterMsg == true then
				cityBuildConstDef = build:getTouchMovePosition()
				build:getTouchMovePosition().msg = "MESSAGE_MAINCITYVIEW_HIDE_COMMUNITYCENTER_MSG"
				SoraDSendMessage((build:getTouchMovePosition()))
			end
			cityBuildConstDef = build:getTouchMovePosition()
			build:getTouchMovePosition().tintTarget = self:getBufferNodeByName("Img_Gonggaolan")
			build:getTouchMovePosition().btnTarget = self.buttonServiceCenter
			build:getTouchMovePosition().callback = function()
				userSDKManager.showSocial()
			end
			safe_tint_call((build:getTouchMovePosition()))
		elseif self.buttonMaTou == build then
			if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
				return
			end
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.PORT)
			if unlockLv > SoraDGetCastleLv() then
				cityBuildConstDef = "Img_Gonggaolan"
				;("Img_Gonggaolan").name = i18n("buildDes_name_108")
				;("Img_Gonggaolan").lv = unlockLv
				SoraDShowMsgTip(i18n("common_text_2122", "Img_Gonggaolan"))
				return
			end
			cityBuildConstDef = i18n("common_text_2122", "Img_Gonggaolan")
			i18n("common_text_2122", "Img_Gonggaolan").soundId = 108
			i18n("common_text_2122", "Img_Gonggaolan").tintTarget = self:getBufferNodeByName("Img_MaTou")
			i18n("common_text_2122", "Img_Gonggaolan").btnTarget = self.buttonMaTou
			i18n("common_text_2122", "Img_Gonggaolan").callback = function()
				if self.isCanGetReward == 1 then
					if self.isAllReceive == 1 then
						SoraDShowMsgTip(i18n("common_text_1165"))
					else
						self = i18n("common_text_1165")
						i18n("common_text_1165").itemID = self.rewardOnline[1]
						i18n("common_text_1165").num = self.rewardOnline[2]
						i18n("common_text_1165").isCanGetReward = self.isCanGetReward
						uiManager:show("timeRewardDetail", i18n("common_text_1165"))
					end
				else
					self = i18n("common_text_1165")
					i18n("common_text_1165").itemID = self.rewardOnline[1]
					i18n("common_text_1165").num = self.rewardOnline[2]
					i18n("common_text_1165").isCanGetReward = self.isCanGetReward
					uiManager:show("timeRewardDetail", i18n("common_text_1165"))
				end
			end
			safe_tint_call(i18n("common_text_2122", "Img_Gonggaolan"))
		elseif self.buttonConquer == build then
			print("王国征服战入口========", build:getLocalZOrder())
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			if conquestWarCtrl:getConquestWarState() ~= gConquestWarState.LOCK then
				uiManager:show("kingdomBattleReady")
			else
				SoraDShowMsgTip(i18n("common_text_2113"))
			end
		elseif self.buttonBulletInBoard == build then
			print("这是公告栏建筑---------------------TODO:打开公告栏界面")
			cityBuildConstDef = "这是公告栏建筑---------------------TODO:打开公告栏界面"
			;("这是公告栏建筑---------------------TODO:打开公告栏界面").msg = "MESSAGE_MAINCITYVIEW_HIDE_BULLETINBOARD_MSG"
			SoraDSendMessage("这是公告栏建筑---------------------TODO:打开公告栏界面")
			cityBuildConstDef = "这是公告栏建筑---------------------TODO:打开公告栏界面"
			;("这是公告栏建筑---------------------TODO:打开公告栏界面").tintTarget = self:getBufferNodeByName("BG_bulletin_board")
			;("这是公告栏建筑---------------------TODO:打开公告栏界面").tintTarget2 = self:getBufferNodeByName("dg_gongshipai")
			;("这是公告栏建筑---------------------TODO:打开公告栏界面").btnTarget = self.buttonBulletInBoard
			;("这是公告栏建筑---------------------TODO:打开公告栏界面").callback = function()
				userSDKManager.openNoticeBorad()
			end
			safe_tint_call("这是公告栏建筑---------------------TODO:打开公告栏界面")
		else
			local buildIndex = build:getTag()
			if buildIndex == cityBuildConstDef.buildIndexDef.index_CommandHall then
				clientEventMgr.singleClickEvent(gActivityTimeActivityID.COMMAND_HALL_ACTIVITY)
			end
		end
	end
end
function mainCityHandler.onOtherTopTipCallBack(mainCity, btnTopTip, ref, event)
	local self = mainCity
	local btn = ref
	local btnIndex = btn:getTag()
	if event == ccui.TouchEventType.began then
		return false
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage(nil)
		local topType = btn.topType
		local buildBtnName = "build_" .. btnIndex
		if btnIndex == cityBuildConstDef.buildIndexDef.index_HuoChuang then
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.CARGO_SHIP)
			if unlockLv > SoraDGetCastleLv() then
				_ENV = nil
				;(nil).name = i18n("common_text_2478")
				;(nil).lv = unlockLv
				SoraDShowMsgTip(i18n("common_text_2122", nil))
				return
			end
			print("===###tipName===", BUILD_HUOCHUAN_TYPE_DEFAULT)
			if BUILD_HUOCHUAN_TYPE_DEFAULT == BUILD_HUOCHUAN_TYPE.SIGN then
				uiManager:show("LuckyCard")
			elseif BUILD_HUOCHUAN_TYPE_DEFAULT == BUILD_HUOCHUAN_TYPE.REWARD then
				print("---------日常奖励---------")
				cityBuildConstDef = i18n("common_text_2122", nil)
				i18n("common_text_2122", nil)[1] = cca.delay(0.001)
				i18n("common_text_2122", nil)[2] = cca.callFunc(function()
					self:playSound("buildopsound", "OpDailyReward", cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound, 0.1)
				end)
				i18n("common_text_2122", nil)[3] = cca.callFunc(function()
					self:playSound("buildopsound", "OpDailyReward", cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound, 0.1)
				end)
				self:runAction(cca.seq(i18n("common_text_2122", nil)))
				_ENV = cca.seq(i18n("common_text_2122", nil))
				cca.seq(i18n("common_text_2122", nil)).tab = 2
				uiManager:show("questView", cca.seq(i18n("common_text_2122", nil)))
			elseif BUILD_HUOCHUAN_TYPE_DEFAULT == BUILD_HUOCHUAN_TYPE.MONTHLY then
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = cca.seq(i18n("common_text_2122", nil))
					cca.seq(i18n("common_text_2122", nil)).toCategory = gRechargeCenterCategory.MONTH
					cca.seq(i18n("common_text_2122", nil)).toNodeTag = 0
					uiManager:show("rechargeView", cca.seq(i18n("common_text_2122", nil)))
				else
					SoraDCreatePanel("rechargeMonthlyFrame"):show()
				end
			elseif BUILD_HUOCHUAN_TYPE_DEFAULT == BUILD_HUOCHUAN_TYPE.PREMIUM_VIP_MALL then
				uiManager:show("rechargeVipFrame")
				_ENV = "rechargeVipFrame"
				;("rechargeVipFrame").byUID = true
				local clickTime = SoraDConfigGet("Game:MainCityView:clickPremiumVipMall~integer", "rechargeVipFrame")
				if clickTime == 0 or not serviceFunctions.isSameDay(clickTime) then
					_ENV = gRechargeCenterCategory.MONTH
					gRechargeCenterCategory.MONTH.byUID = true
					SoraDConfigSet("Game:MainCityView:clickPremiumVipMall~integer", serviceFunctions.systemTime(), gRechargeCenterCategory.MONTH)
					_ENV = "Game:MainCityView:clickPremiumVipMall~integer"
					;("Game:MainCityView:clickPremiumVipMall~integer").msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
					SoraDSendMessage("Game:MainCityView:clickPremiumVipMall~integer")
				end
			elseif BUILD_HUOCHUAN_TYPE_DEFAULT == BUILD_HUOCHUAN_TYPE.EXCLUSIVE_VIP and include("pyramidWarltCtrl").checkPwXianXiaSai() then
				uiManager:show("exclusiveVipView")
			end
		elseif btnIndex == cityBuildConstDef.OtherBuildDef.Gangkou then
			if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
				return
			end
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.PORT)
			if unlockLv > SoraDGetCastleLv() then
				_ENV = serviceFunctions.systemTime()
				serviceFunctions.systemTime().name = i18n("buildDes_name_108")
				serviceFunctions.systemTime().lv = unlockLv
				SoraDShowMsgTip(i18n("common_text_2122", (serviceFunctions.systemTime())))
				return
			end
			if self.isCanGetReward == 2 then
				_ENV = i18n("common_text_2122", (serviceFunctions.systemTime()))
				i18n("common_text_2122", (serviceFunctions.systemTime())).itemID = self.rewardOnline[1]
				i18n("common_text_2122", (serviceFunctions.systemTime())).num = self.rewardOnline[2]
				uiManager:show("timeRewardDetail", i18n("common_text_2122", (serviceFunctions.systemTime())))
			end
		elseif btnIndex == cityBuildConstDef.OtherBuildDef.CommunityCenter then
			if self.hasCommunityCenterMsg == true then
				_ENV = uiManager.show
				uiManager.show.msg = "MESSAGE_MAINCITYVIEW_HIDE_COMMUNITYCENTER_MSG"
				SoraDSendMessage(uiManager.show)
			end
			self.buttonServiceCenter:setEnabled(false)
			local img_Gonggaolan = self:getBufferNodeByName("Img_Gonggaolan")
			if img_Gonggaolan then
				self:ShowNodeTintOnce(img_Gonggaolan)
			end
			local actionDelay = cca.delay(0.3)
			local callFunc = cca.callFunc(function()
				if cityBuildConstDef.topType.TOP_TYPE_COMMUNITY_BBS == topType then
					local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
					activityCenterUICtrl:sendClearNewMsg(gActivityCenterUIEnum.MAIN_CITY_BILLBOARD)
					userSDKManager.showSocial()
				elseif cityBuildConstDef.topType.TOP_TYPE_COMMUNITY_SERVICE == topType then
					userSDKManager.sdkMessageCount.serviceCount = 0
					userSDKManager_sdkMessageCallBack()
					userSDKManager.showFAQs()
				end
				self.buttonServiceCenter:setEnabled(true)
			end)
			funUnlockRead = i18n("common_text_2122", (serviceFunctions.systemTime()))
			i18n("common_text_2122", (serviceFunctions.systemTime()))[1] = actionDelay
			i18n("common_text_2122", (serviceFunctions.systemTime()))[2] = callFunc
			local seqAct = cca.seq(i18n("common_text_2122", (serviceFunctions.systemTime())))
			self:runAction(seqAct)
		elseif btnIndex == cityBuildConstDef.OtherBuildDef.ConquerGate then
			print("王国征服战入口========")
		elseif btnIndex == cityBuildConstDef.OtherBuildDef.BulletInBoard then
			print("TODO:--打开sdk的公告栏建筑的界面")
			userSDKManager.openNoticeBorad()
			_ENV = "TODO:--打开sdk的公告栏建筑的界面"
			;("TODO:--打开sdk的公告栏建筑的界面").msg = "MESSAGE_MAINCITYVIEW_HIDE_BULLETINBOARD_MSG"
			SoraDSendMessage("TODO:--打开sdk的公告栏建筑的界面")
		elseif btnIndex == cityBuildConstDef.OtherBuildDef.ActivityCenter then
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.EVENT_CENTER)
			if unlockLv <= SoraDGetCastleLv() then
				if worldMapDefine.isInNewTrial() then
					SoraDShowMsgTip(i18n("devilvalley_tips_08"))
				else
					uiManager:show("EventCenterView")
				end
			end
		elseif btnIndex == cityBuildConstDef.buildIndexDef.index_CommandHall then
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.COMMAND_HALL_ACTIVITY)
		end
		if topType and gSoundDataList.innercityTop[topType] then
			self:playSound("innercityTop", topType, cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound)
		end
	elseif event == ccui.TouchEventType.canceled then
	end
end
function mainCityHandler.onTipBoxCall(mainCity, tag, jumpData)
	local self = mainCity
	if tag == nil then
		return
	end
	if tag == cityBuildConstDef.OtherBuildDef.Wall then
		uiManager:show("defendView")
	elseif tag == cityBuildConstDef.OtherBuildDef.CommunityCenter then
		userSDKManager.showSocial()
		cityBuildConstDef = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_HIDE_COMMUNITYCENTER_MSG"
		SoraDSendMessage(uiManager)
	elseif tag == cityBuildConstDef.OtherBuildDef.GuardSolider then
		if jumpData ~= nil then
			local mainCityFunctions = include("mainCityFunctions")
			mainCityFunctions:jump(jumpData)
		else
			cityBuildConstDef = mainCityFunctions.jump
			mainCityFunctions.jump.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			mainCityFunctions.jump.buildIndex = cityBuildConstDef.OtherBuildDef.ActivityCenter
			SoraDSendMessage(mainCityFunctions.jump)
		end
	elseif tag == cityBuildConstDef.fixedBuildDef.LeisureCenter then
		local buildEntity = self:getBuildByIndex(tag)
		if buildEntity then
			buildEntity:showPyramid()
		end
	elseif tag == cityBuildConstDef.OtherBuildDef.ConquerGate then
		print("王国征服战入口========")
	end
end
function mainCityHandler.onNpcTopTipCallBack(mainCity, btnTopTip, ref, event)
	local self = mainCity
	local btn = ref
	local btnIndex = btn:getTag()
	if event == ccui.TouchEventType.began then
		return false
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.ended then
		print("点击了npc智能提示------")
		local npcTipClient = include("npcTipClient")
		local bid = npcTipClient:getTipInfo().bid
		local bIndex = npcTipClient:getTipInfo().bIndex
		local des = npcTipClient:getTipInfo().des
		if des and string.len(des) > 0 then
			local panel = SoraDCreatePanel("gameIdleGuideView")
			panel:setDelay(0.03)
			panel:setMsg(i18n(npcTipClient:getTipInfo().des))
			panel:setEndCallBack(function(...)
				print("请求领取奖励-----------------")
				local cityBuild = self:getBuildByIndex(bIndex)
				npcTipClient:reqTipReward(bid, cityBuild:getBuildLv())
				npcTipClient:cleanTipInfo()
				cityBuild:setHasNpcTip(false)
			end)
			panel:show()
		else
		end
		_ENV = panel.show
		panel.show.msg = "MESSAGE_MAINCITYVIEW_REMOVE_NPC_TOP_TIP"
		panel.show.bid = bid
		panel.show.bIndex = bIndex
		SoraDSendMessage(panel.show)
	elseif event == ccui.TouchEventType.canceled then
	end
end
return mainCityHandler
