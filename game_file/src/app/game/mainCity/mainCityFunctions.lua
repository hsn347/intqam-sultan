local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local cityBuildFunction = include("cityBuildFunction")
local cityltCtrl = include("cityltCtrl")
local cityBuildConstDef = include("cityBuildConstDef")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local cityBuildSpritePool = include("cityBuildSpritePool")
local mainCityDefine = include("mainCityDefine")
local _ENV, mainCityFunctions = "mainCityDefine", "mainCityDefine"
function mainCityFunctions.reArrangeZorder(mainCity)
	print("aaabbb mainCityFunctions.reArrangeZorder", RAMADAN_SWITCH)
	local self = mainCity
	local zOrderIndex = 0
	local BG_zhuangjing_ros = self:getBufferNodeByName("BG_zhuangjing_ros")
	if BG_zhuangjing_ros then
		BG_zhuangjing_ros:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.bg)
	end
	local Node_flag = self:getBufferNodeByName("Node_flag")
	if Node_flag then
		Node_flag:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.drill + 1)
		local spine_flag
		spine_flag = sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)
		spine_flag:setAnimation(0, "animation", true)
		spine_flag:addTo(Node_flag:getChildByName("Node_spine_flag"))
	end
	_UPVALUE11_ = spine_flag
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[1] = "mainCityBGDH_14"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[2] = "mainCityBGDH_1"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[3] = "mainCityBGDH_6_1"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[4] = "mainCityBGDH_18"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[5] = "mainCityBGDH_17"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[6] = "mainCityBGDH_17_1"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[7] = "mainCityBGDH_16"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[8] = "mainCityBGDH_15"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[9] = "mainCityBGDH_9"
	sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[10] = "mainCityBGDH_6"
	local sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)[11], downMaskArray = "mainCityBGDH_4", sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)
	for k, v in ipairs(downMaskArray) do
		local dh_target = self:getBufferNodeByName(v)
		if dh_target then
			dh_target:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.down_mask)
		end
	end
	zOrderIndex = mainCityDefine.CITY_TARGET_ZORDER.inner_build
	for i = 1051, 1067 do
		local buildName = "build_" .. i
		local buildButton = self:getBufferNodeByName(buildName)
		if buildButton then
			buildButton:setLocalZOrder(zOrderIndex)
			zOrderIndex = zOrderIndex + 2
		end
	end
	local buildButton1058 = self:getBufferNodeByName("build_1058")
	if buildButton1058 then
		buildButton1058:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.up_castle)
	end
	local bgDh13 = self:getBufferNodeByName("mainCityBGDH_13")
	if bgDh13 then
		bgDh13:setLocalZOrder(zOrderIndex)
		zOrderIndex = zOrderIndex + 2
	end
	for i = 1200, 1206 do
		local buildName = "build_" .. i
		local buildButton = self:getBufferNodeByName(buildName)
		if buildButton then
			buildButton:setLocalZOrder(zOrderIndex)
			zOrderIndex = zOrderIndex + 2
		end
	end
	for i = 30001, 30011 do
		local btnBuild = self:getBufferNodeByName("build_" .. i)
		if btnBuild then
			btnBuild:setLocalZOrder(zOrderIndex)
			zOrderIndex = zOrderIndex + 2
			if i == cityBuildConstDef.fixedBuildDef.EpicBattle then
				btnBuild:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.up_castle)
			end
		end
	end
	local img_merchant = self:getBufferNodeByName("Img_Lvxingshanren")
	if img_merchant then
		img_merchant:setLocalZOrder(zOrderIndex)
		zOrderIndex = zOrderIndex + 2
		local luotuoNpc = SoraDGetChildByName(img_merchant, "luotuo")
		if luotuoNpc == nil then
			luotuoNpc = display.newSprite("#zhucheng_luotuoNPC_01.png")
			luotuoNpc:setName("luotuo")
			luotuoNpc:addTo(img_merchant)
			luotuoNpc:setPosition(138, 56)
			local frames = display.newFrames("zhucheng_luotuoNPC_%02d.png", 1, 24)
			local animation = display.newAnimation(frames, 0.08333333333333333)
			luotuoNpc:playAnimationForever(animation)
		end
	end
	zOrderIndex = mainCityDefine.CITY_TARGET_ZORDER.outer_build
	for i = 1100, 1134 do
		local buildName = "build_" .. i
		local buildButton = self:getBufferNodeByName(buildName)
		if buildButton then
			buildButton:setLocalZOrder(zOrderIndex)
			zOrderIndex = zOrderIndex + 2
		end
	end
	for i = 1151, 1152 do
		local btnBuild = self:getBufferNodeByName("build_" .. i)
		if btnBuild then
			btnBuild:setLocalZOrder(zOrderIndex)
			zOrderIndex = zOrderIndex + 2
		end
	end
	local btnBuildCastle = self:getBufferNodeByName("build_1050")
	if btnBuildCastle then
		btnBuildCastle:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.castle)
	end
	local btnBuild1059 = self:getBufferNodeByName("build_1059")
	if btnBuild1059 then
		btnBuild1059:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.up_castle)
	end
	_UPVALUE11_, zOrderIndex = mainCityDefine.CITY_TARGET_ZORDER, mainCityDefine.CITY_TARGET_ZORDER.wall
	mainCityDefine.CITY_TARGET_ZORDER[1] = "Sprite_Jt_1"
	mainCityDefine.CITY_TARGET_ZORDER[2] = "Sprite_Cq_1"
	mainCityDefine.CITY_TARGET_ZORDER[3] = "Sprite_Jt_2"
	mainCityDefine.CITY_TARGET_ZORDER[4] = "build_1054"
	mainCityDefine.CITY_TARGET_ZORDER[5] = "Sprite_Cq_2"
	mainCityDefine.CITY_TARGET_ZORDER[6] = "build_1053"
	mainCityDefine.CITY_TARGET_ZORDER[7] = "Sprite_Cq_3"
	mainCityDefine.CITY_TARGET_ZORDER[8] = "Sprite_Jt_3"
	mainCityDefine.CITY_TARGET_ZORDER[9] = "build_1052"
	mainCityDefine.CITY_TARGET_ZORDER[10] = "Sprite_Cq_4"
	local mainCityDefine.CITY_TARGET_ZORDER[11], wallBtnArray = "Sprite_Jt_4", mainCityDefine.CITY_TARGET_ZORDER
	for k, v in ipairs(wallBtnArray) do
		local buildButton = self:getBufferNodeByName(v)
		if buildButton then
			buildButton:setLocalZOrder(zOrderIndex + 1)
			zOrderIndex = zOrderIndex + 2
		end
	end
	zOrderIndex = mainCityDefine.CITY_TARGET_ZORDER.outer_build
	for i = 1100, 1134 do
		local buildName = "build_" .. i
		local buildButton = self:getBufferNodeByName(buildName)
		if buildButton then
			buildButton:setLocalZOrder(zOrderIndex)
			zOrderIndex = zOrderIndex + 2
		end
	end
	for i = 1151, 1152 do
		local btnBuild = self:getBufferNodeByName("build_" .. i)
		if btnBuild then
			btnBuild:setLocalZOrder(zOrderIndex)
			zOrderIndex = zOrderIndex + 2
		end
	end
	for i = 1, 10 do
		local buildName = "kipchaks_" .. i
		local buildButton = self:getBufferNodeByName(buildName)
		if buildButton then
			buildButton:setLocalZOrder(zOrderIndex)
			zOrderIndex = zOrderIndex + 2
		end
	end
	local buttonConquer = SoraDGetChildByName(self.containerView, "Button_conquer")
	if buttonConquer then
		buttonConquer:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.npc)
	end
	local img_turret_lock_1052 = self:getBufferNodeByName("img_turret_lock_1052")
	local img_turret_lock_1054 = self:getBufferNodeByName("img_turret_lock_1054")
	if img_turret_lock_1054 then
		img_turret_lock_1054:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.drill)
	end
	if img_turret_lock_1052 then
		img_turret_lock_1052:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.drill)
	end
	local img_Activity = self:getBufferNodeByName("Img_Activity")
	if img_Activity then
		img_Activity:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.drill + 1)
	end
	_UPVALUE9_ = img_Activity.setLocalZOrder
	img_Activity.setLocalZOrder[1] = "mainCityBGDH_19"
	img_Activity.setLocalZOrder[2] = "mainCityBGDH_12"
	img_Activity.setLocalZOrder[3] = "mainCityBGDH_11"
	img_Activity.setLocalZOrder[4] = "mainCityBGDH_10"
	img_Activity.setLocalZOrder[5] = "mainCityBGDH_8"
	img_Activity.setLocalZOrder[6] = "mainCityBGDH_7"
	img_Activity.setLocalZOrder[7] = "mainCityBGDH_5"
	img_Activity.setLocalZOrder[8] = "mainCityBGDH_2"
	local img_Activity.setLocalZOrder[9], dhArray = "mainCityBGDH_3", img_Activity.setLocalZOrder
	for k, v in ipairs(dhArray) do
		local dh_target = self:getBufferNodeByName(v)
		if dh_target then
			dh_target:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.drill)
		end
	end
	local dh_huodong_ice = self:getBufferNodeByName("dh_huodong_ice")
	if dh_huodong_ice then
		dh_huodong_ice:setVisible(RAMADAN_SWITCH or false)
		dh_huodong_ice:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.drill)
	end
end
function mainCityFunctions.updateLockArea(mainCity)
	local self = mainCity
	local cityCell = cityCtrl:getCurCity()
	local openAreaList = cityCell.areaList
	for i, v in ipairs(openAreaList) do
		local lockAreaName = "Panel_Area_Lock_" .. v
		local panelLockArea = self:getBufferNodeByName(lockAreaName)
		panelLockArea:removeAllChildren()
		panelLockArea:setVisible(false)
		local openGroundInfo = cityltCtrl.getOpenGoundInfo(v)
		local minIndex = openGroundInfo.minIndex
		local maxIndex = openGroundInfo.maxIndex
		for i = minIndex, maxIndex do
			local buildName = "build_" .. i
			local build = self:getBufferNodeByName(buildName)
			if build then
				build:setVisible(true)
				local buildEntity = SoraDGetChildByName(build, "buildName")
				if buildEntity == nil then
					self:addBuildTile(build)
				end
			end
		end
	end
	local cityCtrl, unOpenAreaList = (for generator), ipairs(openAreaList)
	local opengroundinfo = require("app." .. LocalTblPath .. ".config_server.opengroundinfo")
	for i, v in ipairs(opengroundinfo) do
		local isOpened = false
		for j, k in ipairs(openAreaList) do
			if v.areaid == k then
				isOpened = true
			end
		end
		if isOpened == false then
			table.insert(unOpenAreaList, #unOpenAreaList + 1, v.areaid)
		end
	end
	for i, v in ipairs(unOpenAreaList) do
		local lockAreaName = "Panel_Area_Lock_" .. v
		local panelLockArea = self:getBufferNodeByName(lockAreaName)
		if not panelLockArea then
			break
		end
		panelLockArea:setVisible(true)
		local buildLockArea = SoraDGetChildByName(panelLockArea, "buildName")
		local openGroundInfo = cityltCtrl.getOpenGoundInfo(v)
		local minIndex = openGroundInfo.minIndex
		local maxIndex = openGroundInfo.maxIndex
		for i = minIndex, maxIndex do
			local buildName = "build_" .. i
			local build = self:getBufferNodeByName(buildName)
			if build then
				build:setVisible(false)
				self:delBuildTile(build)
			end
		end
		if buildLockArea ~= nil then
			cityCtrl = 1
			;(1).areaid = v
			buildLockArea:initWithData(1)
		else
			local buildLockArea = include("cityBuildLockArea")
			local ccsFileName = "cityBuildLockArea" .. v
			local buildContentNode = buildLockArea.new(getCCSPath(ccsFileName))
			buildContentNode:setSwallowTouches(false)
			panelLockArea:add(buildContentNode, 1)
			buildContentNode:setName("buildName")
			buildContentNode:setTag(v)
			cityCtrl = v
			v.areaid = v
			buildContentNode:initWithData(v)
			buildContentNode:setPosition(cc.p(0, 0))
		end
	end
end
function mainCityFunctions.addBuild(mainCity, buildBtnId, buildCfgId)
	local self = mainCity
	local buildButton = self:getBufferNodeByName("build_" .. buildBtnId)
	local buildTile = self:getBufferNodeByName("Build_Tile_" .. buildBtnId)
	if buildButton then
		local naitonCtrl = gametop.playertop_:getModule("factionCtrl")
		print("naitonCtrl", naitonCtrl)
		local baseBuildCfg = naitonCtrl:getCityBuildBaseTipsCfg(buildCfgId)
		gametop = naitonCtrl
		local naitonCtrl.BuildingCfgId, buildItemInfo = buildCfgId, naitonCtrl
		buildItemInfo.IsInnerBuild = baseBuildCfg.IsInnerBuild == 1
		local buildItem
		if buildItemInfo.IsInnerBuild == true then
			buildItemInfo.BuildingUId = CBGetNewUniqueId()
			buildItem = buildItemInfo
		elseif buildItemInfo.IsInnerBuild == false then
			buildItemInfo.BuildingUId = CBGetNewUniqueId()
			buildItem = buildItemInfo
		end
		if buildTile then
			buildTile:setVisible(false)
		end
		local buildContentNode = self:createBuildByCfgId(buildBtnId, buildItem)
		if buildItemInfo.IsInnerBuild == true then
		elseif buildItemInfo.IsInnerBuild == false then
		end
	end
end
function mainCityFunctions.doBuildOffset(mainCity, build)
	local self = mainCity
	self.preContainerOffsetTip = self.viewScrollView:getContentOffset()
	local zoomScale = self.viewScrollView:getZoomScale()
	local topPadding = 110
	local bottomPadding = 100
	local screenSizeWidth = display.size.width
	local screenSizeHeight = display.size.height - topPadding - bottomPadding
	local offsetX = 0
	local offsetY = 0
	local xBuildPos = build:getPositionX()
	local yBuildPos = build:getPositionY()
	local leftBottomTipPosX = xBuildPos - 240
	local leftBottomTipPosY = yBuildPos - 280
	local leftTopTipPosX = xBuildPos - 240
	local leftTopTipPosY = yBuildPos + 140
	local rightTopTipPosX = xBuildPos + 240
	local rightTopTipPosY = yBuildPos + 140
	local rightBottomTipPosX = xBuildPos + 240
	local rightBottomTipPosY = yBuildPos - 280
	local leftTopTipPosWorld = self.containerView:convertToWorldSpace(cc.p(leftTopTipPosX, leftTopTipPosY))
	if 0 > leftTopTipPosWorld.x then
		offsetX = -leftTopTipPosWorld.x
	end
	if leftTopTipPosWorld.y > bottomPadding + screenSizeHeight then
		offsetY = bottomPadding + screenSizeHeight - leftTopTipPosWorld.y
	end
	local rightBottomTipPosWorld = self.containerView:convertToWorldSpace(cc.p(rightBottomTipPosX, rightBottomTipPosY))
	if screenSizeWidth < rightBottomTipPosWorld.x then
		offsetX = screenSizeWidth - rightBottomTipPosWorld.x
	end
	if bottomPadding > rightBottomTipPosWorld.y then
		offsetY = -rightBottomTipPosWorld.y + bottomPadding
	end
	local oriOffset = self.viewScrollView:getContentOffset()
	local newOffsetX = oriOffset.x + offsetX
	local newOffsetY = oriOffset.y + offsetY
	local minContainerOffset = self.viewScrollView:minContainerOffset()
	local maxContainerOffset = self.viewScrollView:maxContainerOffset()
	newOffsetX = math.max(minContainerOffset.x, math.min(maxContainerOffset.x, newOffsetX))
	newOffsetY = math.max(minContainerOffset.y, math.min(maxContainerOffset.y, newOffsetY))
	self.viewScrollView:setContentOffset(cc.p(newOffsetX, newOffsetY), true)
end
function mainCityFunctions.doOffsetContainerWithSelectBuild(mainCity, build, scale, other)
	local self = mainCity
	self:stopScrollContainer()
	local scale = scale or 1.0
	self.preContainerOffset = self.viewScrollView:getContentOffset()
	if other == nil or not other.ignorePreZoomScale then
		local realZoomScale = self:getZoomScale()
		self.preZoomScale = realZoomScale
	end
	if other ~= nil and other.noScaleDuration then
		self:setZoomScale(scale, false, 0, true)
	else
		self:setZoomScale(scale, true, self.zoomScaleDuration, true)
	end
	local zoomScale = self:getZoomScale()
	local posX = SoraDFPosX(display.size.width - 165, display.size.width)
	local posY = display.height * 0.5 + self.hUIBottom + display.iPhoneXBottom + 30
	local offsetX = SoraDFIsRA() and -185 or -185
	local offsetY = 70
	posX = SoraDFPosX(display.size.width + offsetX, display.size.width)
	posY = display.rheight * 0.5 + 70 + display.iPhoneXBottom
	local buildIndex = build:getTag()
	if buildIndex == cityBuildConstDef.buildIndexDef.index_Material_WorkShop then
		local offsetX = 0
		local offsetY = 70
		posX = display.size.width * 0.5
		posY = display.rheight * 0.5 + 20 + display.iPhoneXBottom
	else
		posX = display.size.width * 0.5
		posY = display.rheight * 0.5 + 70 + display.iPhoneXBottom
	end
	if other ~= nil and other.xOffset ~= nil then
		posX = other.xOffset
	end
	if other ~= nil and other.yOffset ~= nil then
		posY = other.yOffset
	end
	local ignoreCheck = true
	if other ~= nil and other.skip then
		ignoreCheck = false
	end
	local scrollOffset = self:getContainerOffsetWhenPosTarget(build, cc.p(posX, posY), ignoreCheck, false)
	if other ~= nil and other.noOffsetDuration then
		self:runContainerViewMove(scrollOffset)
		self:disableMoveForDuration(0.1)
	else
		self:runContainerViewMove(scrollOffset, self.zoomScaleDuration)
		self:disableMoveForDuration(self.zoomScaleDuration)
	end
end
function mainCityFunctions.ShowNodeTint(mainCity, node)
	local self = mainCity
	if node then
		node:stopActionByTag(77)
		node:setColor(cc.c3b(100, 100, 100))
		local actionTintTo = cca.tintBy(0.5, 0.5, 0.5, 0.5)
		local actionDelay = cca.delay(0.3)
		local actionTinBack = cca.tintBy(0.5, -0.5, -0.5, -0.5)
		_UPVALUE3_ = -0.5
		;(-0.5)[1] = actionTintTo
		;(-0.5)[2] = actionDelay
		;(-0.5)[3] = actionTinBack
		local actionRepeat = cca.repeatForever(cca.seq(-0.5))
		actionRepeat:setTag(77)
		node:runAction(actionRepeat)
	end
end
function mainCityFunctions.ShowNodeTintOnce(mainCity, node)
	local self = mainCity
	if node then
		node:stopActionByTag(77)
		node:setColor(cc.c3b(100, 100, 100))
		local actionTintTo = cca.tintBy(0.2, 0.6078431372549019, 0.6078431372549019, 0.6078431372549019)
		actionTintTo:setTag(77)
		node:runAction(actionTintTo)
	end
end
function mainCityFunctions.CancelNodeTint(mainCity, node)
	local self = mainCity
	if node then
		node:stopActionByTag(77)
		local actionTintTo = cca.tintTo(0.6, 1, 1, 1)
		actionTintTo:setTag(77)
		node:runAction(actionTintTo)
	end
end
function mainCityFunctions.ShowBuildTint(mainCity, build, bShow)
	local self = mainCity
	local bNeedShow = false
	if nil == bShow then
		bNeedShow = true
	else
		bNeedShow = bShow
	end
	if build then
		local buildTag = build:getTag()
		if buildTag == 1053 then
			local buildJiantachengduoR = SoraDGetChildByName(self:getBufferNodeByName("build_1054"), "buildImg")
			local buildJiantachengduoL = SoraDGetChildByName(self:getBufferNodeByName("build_1052"), "buildImg")
			local buildImg = SoraDGetChildByName(build, "buildImg")
			local showFunc
			if true == bNeedShow then
				showFunc = "ShowNodeTint"
			else
				showFunc = "CancelNodeTint"
			end
			self[showFunc](self, buildJiantachengduoR)
			self[showFunc](self, buildJiantachengduoL)
			self[showFunc](self, buildImg)
			for i = 1, 4 do
				local buildCqItem = self:getBufferNodeByName("Sprite_Cq_" .. i)
				local buildJtItem = self:getBufferNodeByName("Sprite_Jt_" .. i)
				self[showFunc](self, buildCqItem)
				self[showFunc](self, buildJtItem)
			end
		elseif buildTag == 1050 then
			local dressCtrl = gametop.playertop_:getModule("dressCtrl")
			local skinID = dressCtrl:getDressOfCastle()
			local activityShowCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("activityShowCtrl")
			local skinCastleBg
			skinCastleBg = SoraDGetChildByName(build, "buildImg")
			local showFunc
			if true == bNeedShow then
				showFunc = "ShowNodeTint"
			else
				showFunc = "CancelNodeTint"
			end
			self[showFunc](self, skinCastleBg)
			if self.castleSkin then
				local skin, spine, crisp = self.castleSkin:getTintSkin()
				dump(crisp, "crisp")
				if skin then
					self[showFunc](self, skin)
				end
				if spine then
					self[showFunc](self, spine)
				end
				if crisp then
					self[showFunc](self, crisp)
				end
			end
			if self.castleNightSkin then
				local skin, crisp = self.castleNightSkin:getTintSkin()
				if skin then
					self[showFunc](self, skin)
				end
				if crisp then
					self[showFunc](self, crisp)
				end
			end
		else
			local buildImg = SoraDGetChildByName(build, "buildImg")
			local buildEntity = SoraDGetChildByName(build, "buildName")
			if buildEntity then
				local buildImg = buildEntity.buildImg
				if buildImg then
					if true == bNeedShow then
						self:ShowNodeTint(buildImg)
					else
						self:CancelNodeTint(buildImg)
					end
				end
				local iconMiracle = buildEntity.iconMiracle
				if iconMiracle then
					if true == bNeedShow then
						self:ShowNodeTint(iconMiracle)
					else
						self:CancelNodeTint(iconMiracle)
					end
				end
			end
		end
	end
end
function mainCityFunctions.updateMoveBtnArrayByType(mainCity, moveType)
	local self = mainCity
	if moveType == 0 then
		self:showBuildMoveTip(i18n("common_text_052"))
		self.currentMoveBtnArray, _ENV = self.showBuildMoveTip, self.showBuildMoveTip
		local _ENV, needMoveBtnArray = self.showBuildMoveTip, self.showBuildMoveTip
		local iIndex = 1
		if self:getHasBuildEntity(1051) then
			local buildEntity = self:getBuildByIndex(1051)
			if buildEntity:getIsCanMove() == true then
				table.insert(needMoveBtnArray, iIndex, 1051)
				iIndex = iIndex + 1
			end
		end
		for buildIndex = 1056, 1067 do
			local buildEntity = self:getBuildByIndex(buildIndex)
			if buildEntity and buildEntity:getIsCanMove() == true then
				table.insert(needMoveBtnArray, iIndex, buildIndex)
				iIndex = iIndex + 1
			end
		end
		for buildIndex = 1100, 1134 do
			local buildEntity = self:getBuildByIndex(buildIndex)
			if buildEntity and buildEntity:getIsCanMove() == true then
				table.insert(needMoveBtnArray, iIndex, buildIndex)
				iIndex = iIndex + 1
			end
		end
		for i = 1, #needMoveBtnArray do
			self:showBuildMoveEffect(needMoveBtnArray[i], true, true)
			local buildIndex = needMoveBtnArray[i]
			table.insert(self.currentMoveBtnArray, i, buildIndex)
		end
	elseif moveType == 1 then
		self:showBuildMoveTip(i18n("common_text_051"))
		self.currentMoveBtnArray, _ENV = self.showBuildMoveTip, self.showBuildMoveTip
		local _ENV, needMoveBtnArray = self.showBuildMoveTip, self.showBuildMoveTip
		local iIndex = 1
		if self:getHasBuildEntity(1051) then
			local buildEntity = self:getBuildByIndex(1051)
			if buildEntity:getIsCanMove() == true then
				table.insert(needMoveBtnArray, iIndex, 1051)
				iIndex = iIndex + 1
			end
		else
			table.insert(needMoveBtnArray, iIndex, 1051)
			iIndex = iIndex + 1
		end
		for buildIndex = 1056, 1067 do
			local buildEntity = self:getBuildByIndex(buildIndex)
			if buildEntity and buildEntity:getIsCanMove() == false then
			else
				table.insert(needMoveBtnArray, iIndex, buildIndex)
				iIndex = iIndex + 1
			end
		end
		for buildIndex = 1100, 1134 do
			self:hideBuildMoveEffect(buildIndex)
		end
		for i = 1, #needMoveBtnArray do
			self:showBuildMoveEffect(needMoveBtnArray[i], true, true)
			local buildIndex = needMoveBtnArray[i]
			table.insert(self.currentMoveBtnArray, i, buildIndex)
		end
		if self.currentSelectMoveModeIndex ~= 0 then
			self:showBuildMoveEffect(self.currentSelectMoveModeIndex, false, true)
		end
	elseif moveType == 2 then
		self.currentMoveBtnArray, _ENV = self.showBuildMoveTip, self.showBuildMoveTip
		local _ENV, needMoveBtnArray = self.showBuildMoveTip, self.showBuildMoveTip
		local iIndex = 1
		self:hideBuildMoveEffect(1051)
		for buildIndex = 1056, 1067 do
			self:hideBuildMoveEffect(buildIndex)
		end
		for buildIndex = 1100, 1134 do
			local buildEntity = self:getBuildByIndex(buildIndex)
			if buildEntity ~= nil and buildEntity:getIsCanMove() == false then
			elseif self:getIsOuterBuildUnLocked(buildIndex) then
				table.insert(needMoveBtnArray, iIndex, buildIndex)
				iIndex = iIndex + 1
			end
		end
		for i = 1, #needMoveBtnArray do
			self:showBuildMoveEffect(needMoveBtnArray[i], true, true)
			local buildIndex = needMoveBtnArray[i]
			table.insert(self.currentMoveBtnArray, i, buildIndex)
		end
		if self.currentSelectMoveModeIndex ~= 0 then
			self:showBuildMoveEffect(self.currentSelectMoveModeIndex, false, false)
		end
	end
end
function mainCityFunctions.showBuildMoveEffect(mainCity, buildIndex, isGreen, isNeedMove)
	local self = mainCity
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local bOriScale = 0.6
	if buildIndex < 1100 then
		bOriScale = 1.4
	end
	local buildBtnImgMoveName = "imgMove_" .. buildIndex
	local buildBtnImgMove = self.batchNodeCityOthers:getChildByName(buildBtnImgMoveName)
	if nil == buildBtnImgMove then
		buildBtnImgMove = display.newSprite("#tile_frame.png")
		buildBtnImgMove:addTo(self.batchNodeCityOthers, 1)
		buildBtnImgMove:setName(buildBtnImgMoveName)
		buildBtnImgMove:setVisible(true)
		buildBtnImgMove:setOpacity(255)
		buildBtnImgMove:setAnchorPoint(cc.p(0.5, 0.5))
		buildBtnImgMove:setPosition(cc.p(buildBtn:getPositionX(), buildBtn:getPositionY()))
	end
	if isNeedMove then
		buildBtnImgMove:stopAllActions()
		buildBtnImgMove:setScale(bOriScale)
		local actionScaleBy1 = cca.scaleBy(0.5, 1.07)
		local actionScaleBy2 = actionScaleBy1:reverse()
		_UPVALUE2_ = cc.p(buildBtn:getPositionX(), buildBtn:getPositionY())
		cc.p(buildBtn:getPositionX(), buildBtn:getPositionY())[1] = actionScaleBy1
		cc.p(buildBtn:getPositionX(), buildBtn:getPositionY())[2] = actionScaleBy2
		local actionSeq = cca.seq(cc.p(buildBtn:getPositionX(), buildBtn:getPositionY()))
		local actionRepeat = cca.repeatForever(actionSeq)
		buildBtnImgMove:runAction(actionRepeat)
	end
	if isGreen then
		buildBtnImgMove:setColor(cc.c3b(0, 255, 0))
	else
		buildBtnImgMove:setColor(cc.c3b(255, 0, 0))
	end
end
function mainCityFunctions.hideBuildMoveEffect(mainCity, buildIndex)
	local self = mainCity
	local bOriScale = 1.0
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local buildImgMoveName = "imgMove_" .. buildIndex
	local buildBtnImgMove = self.batchNodeCityOthers:getChildByName(buildImgMoveName)
	if nil == buildBtnImgMove then
		return
	end
	buildBtnImgMove:setVisible(false)
	buildBtnImgMove:stopAllActions()
	buildBtnImgMove:setScale(bOriScale)
	buildBtnImgMove:removeFromParent()
end
function mainCityFunctions.showBuildMoveTip(mainCity, strMoveTip)
	local self = mainCity
	local cityBuildMoveTipName = "cityBuildMoveTip"
	local cityBuildMoveNode = self.moveBuildTip
	if cityBuildMoveNode then
		cityBuildMoveNode:showTip(strMoveTip)
	else
		local msgTip = include("cityBuildMoveTip").new()
		msgTip:showTip(strMoveTip)
		msgTip:setName("cityBuildMoveTip")
		msgTip:setCallBackHandle(handler(self, self.onMoveTipClose))
		local size = display.size
		msgTip:setPosition(size.width / 2, 270)
		self.moveBuildTip = msgTip
	end
end
function mainCityFunctions.hideBuildMoveTip(mainCity)
	local self = mainCity
	if self.moveBuildTip and self.moveBuildTip.__cname then
		self.moveBuildTip:removeFromParent()
		self.moveBuildTip = nil
	else
		self.moveBuildTip = nil
	end
end
function mainCityFunctions.getIsTouchPointInTopTipNode(mainCity, touchPoint, nodeTopTip)
	local self = mainCity
	local bRet = false
	local btn = SoraDGetChildByName(nodeTopTip, "btn")
	if btn == nil then
		return false
	end
	local boundingBox = btn:getBoundingBox()
	local btnPosBL = cc.p(boundingBox.x, boundingBox.y)
	local posTouchToNode = self.containerView:convertToNodeSpace(touchPoint)
	local posBtn = self.containerView:convertToNodeSpace(nodeTopTip:convertToWorldSpace(btnPosBL))
	boundingBox.x = posBtn.x
	boundingBox.y = posBtn.y
	if cc.rectContainsPoint(boundingBox, posTouchToNode) then
		bRet = true
	end
	return bRet
end
function mainCityFunctions.addResCollectAnimation(mainCity, resId, buildIndex, buildEntity, numOfRes)
	local self = mainCity
	if resId == gIDDef.FOOD then
		if display.getAnimationCache("animation_food") ~= nil then
		else
			local frames = display.newFrames("food_%d.png", 1, 5)
			local animation = display.newAnimation(frames, 0.05)
			display.setAnimationCache("animation_food", animation)
		end
	elseif resId == gIDDef.WOOD then
		if display.getAnimationCache("animation_wood") ~= nil then
		else
			local frames = display.newFrames("wood_%d.png", 1, 5)
			local animation = display.newAnimation(frames, 0.05)
			display.setAnimationCache("animation_wood", animation)
		end
	elseif resId == gIDDef.IRON then
		if display.getAnimationCache("animation_iron") ~= nil then
		else
			local frames = display.newFrames("iron_%d.png", 1, 5)
			local animation = display.newAnimation(frames, 0.05)
			display.setAnimationCache("animation_iron", animation)
		end
	elseif resId == gIDDef.MITHRIL then
		if display.getAnimationCache("animation_steel") ~= nil then
		else
			local frames = display.newFrames("stone_%d.png", 1, 5)
			local animation = display.newAnimation(frames, 0.05)
			display.setAnimationCache("animation_steel", animation)
		end
	elseif resId ~= gIDDef.CRYSTAL_MINE or display.getAnimationCache("animation_crystal") ~= nil then
	else
		local frames = display.newFrames("shuijingkuang_%02d.png", 1, 5)
		local animation = display.newAnimation(frames, 0.05)
		display.setAnimationCache("animation_crystal", animation)
	end
	local posBtn = buildIndex
	if type(buildIndex) ~= "table" then
		local btnName = "build_" .. buildIndex
		local btn = self:getBufferNodeByName(btnName)
		posBtn = cc.p(btn:getPositionX(), btn:getPositionY())
	end
	local dir = 50
	local dr = 1
	do
		local numberOfSprite = numOfRes
		local actDelay = cca.delay(0.2)
		posBtn = self.containerView:convertToWorldSpace(posBtn)
		if posBtn.y < 157 then
			posBtn.y = 157
		end
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		local actCallfunc = cca.callFunc(function()
			local mainUI = SoraDCurrentMainUI()
			local spriteName = "#food_1.png"
			local leftTopDisplay = cc.p(display.size.width / 2, display.size.height)
			local targetScale = 1.0
			if resId == gIDDef.FOOD then
				spriteName = "#food_1.png"
				targetScale = 0.4
			elseif resId == gIDDef.WOOD then
				spriteName = "#wood_1.png"
				targetScale = 0.8
			elseif resId == gIDDef.IRON then
				spriteName = "#iron_1.png"
				targetScale = 1.0
			elseif resId == gIDDef.MITHRIL then
				spriteName = "#stone_1.png"
				targetScale = 0.6
			elseif resId == gIDDef.CRYSTAL then
				spriteName = "#shuijingkuang_01.png"
				targetScale = 0.6
			end
			local imgTopRes = mainUI:getResTarget(resId)
			local parentRes = imgTopRes:getParent()
			local imgTopResPos = cc.p(imgTopRes:getPosition())
			local imgTopResPosWorld = parentRes:convertToWorldSpace(imgTopResPos)
			leftTopDisplay.x = imgTopResPosWorld.x
			leftTopDisplay.y = imgTopResPosWorld.y
			local bid
			local spriteCollect, isNeedRelease = cityBuildSpritePool:getSprite(bid)
			local parent = self.batchNodeCollect
			spriteCollect:addTo(parent, 501)
			if isNeedRelease == true then
				spriteCollect:release()
			end
			spriteCollect:setPosition(posBtn.x + math.random(-20, 20), posBtn.y + math.random(-10, 20))
			spriteCollect:setAnchorPoint(cc.p(0.3, 0.5))
			local speed = 700
			local distance = cc.pGetDistance(posBtn, leftTopDisplay)
			local dt = distance / speed
			local controlLen = distance / 3
			local angle = math.deg(math.atan(math.abs(leftTopDisplay.y - posBtn.y) / math.abs(leftTopDisplay.x - posBtn.x)))
			local redian = angle * math.pi / 180
			local Q_center = cc.p(posBtn.x + controlLen * math.cos(redian), posBtn.y + controlLen * math.sin(redian))
			local Q1 = cc.p(Q_center.x - dir * math.sin(redian), Q_center.y + dir * math.cos(redian))
			local Q2 = cc.p(Q_center.x + dir * math.sin(redian), Q_center.y - dir * math.cos(redian))
			if leftTopDisplay.x < posBtn.x then
				Q1 = cc.p(2 * posBtn.x - Q1.x, Q1.y)
				Q2 = cc.p(2 * posBtn.x - Q2.x, Q2.y)
			end
			local Q_control = Q1
			if dr == -1 then
				Q_control = Q2
			end
			local beginPoint = cc.p(posBtn.x, posBtn.y)
			local controlPoint = cc.p(Q_control.x, Q_control.y)
			local endPoint = cc.p(leftTopDisplay.x, leftTopDisplay.y)
			resId = leftTopDisplay.x
			leftTopDisplay.x[1] = beginPoint
			leftTopDisplay.x[2] = controlPoint
			local leftTopDisplay.x[3], bezier = endPoint, leftTopDisplay.x
			local moveTo = cc.BezierTo:create(dt, bezier)
			local callFunc = cca.callFunc(function()
				cityBuildSpritePool:addToSpritePool(spriteCollect)
				spriteCollect:removeFromParent()
			end)
			_ENV = bezier
			bezier[1] = moveTo
			bezier[2] = callFunc
			local seq = cca.seq(bezier)
			if resId == gIDDef.IRON then
				spriteCollect:playAnimationForever(display.getAnimationCache("animation_iron"))
			elseif resId == gIDDef.MITHRIL then
				spriteCollect:playAnimationForever(display.getAnimationCache("animation_steel"))
			elseif resId == gIDDef.FOOD then
				spriteCollect:playAnimationForever(display.getAnimationCache("animation_food"))
			elseif resId == gIDDef.WOOD then
				spriteCollect:playAnimationForever(display.getAnimationCache("animation_wood"))
			elseif resId == gIDDef.CRYSTAL then
				spriteCollect:playAnimationForever(display.getAnimationCache("animation_crystal"))
			end
			spriteCollect:runAction(seq)
			if dt - 0.2 > 0 then
				local delayTime = cca.delay(dt - 0.2)
				local actionScaleTo = cca.scaleTo(0.2, targetScale)
				_ENV = targetScale
				targetScale[1] = delayTime
				targetScale[2] = actionScaleTo
				local seq2 = cca.seq(targetScale)
				spriteCollect:runAction(seq2)
			end
			spriteCollect:setGlobalZOrder(1000)
		end)
		if buildEntity then
			_UPVALUE2_ = tostring(os.time()):reverse():sub(1, 6)
			tostring(os.time()):reverse():sub(1, 6)[1] = actCallfunc
			tostring(os.time()):reverse():sub(1, 6)[2] = actDelay
			local actSeq = cca.seq(tostring(os.time()):reverse():sub(1, 6))
			local actRepeat = cca.rep(actSeq, math.max(numberOfSprite, 1))
			buildEntity:runAction(actRepeat)
		end
	end
end
function mainCityFunctions.addToTableIfNotExist(mainCity, valueTable, value)
	local self = mainCity
	local isExist = false
	for i = 1, #valueTable do
		if valueTable[i] == value then
			isExist = true
			break
		end
	end
	if isExist == false then
		valueTable[#valueTable + 1] = value
	end
end
function mainCityFunctions.getCanBuildIndexByBid(mainCity, bid)
	local self = mainCity
	local buildType = 1
	if bid ~= nil then
		buildType = SoraDGetBuildTypeByBid(bid)
	end
	local _ENV, buildIndexArray = SoraDGetBuildTypeByBid(bid), SoraDGetBuildTypeByBid(bid)
	local buildIndex = 0
	if bid == BUILDID.MIRACLE then
		return 1200
	end
	if buildType == 0 then
		for i, v in ipairs(cityBuildConstDef.preferInnerCityBuildIndex) do
			mainCityFunctions.addToTableIfNotExist(nil, buildIndexArray, v)
		end
		mainCityFunctions.addToTableIfNotExist(nil, buildIndexArray, 1051)
		for i = 1056, 1067 do
			mainCityFunctions.addToTableIfNotExist(nil, buildIndexArray, i)
		end
		mainCityFunctions.addToTableIfNotExist(nil, buildIndexArray, 1204)
		mainCityFunctions.addToTableIfNotExist(nil, buildIndexArray, 1200)
	elseif buildType == 1 then
		for i, v in ipairs(cityBuildConstDef.preferOuterCityBuildIndex) do
			mainCityFunctions.addToTableIfNotExist(nil, buildIndexArray, v)
		end
		for i = 1100, 1114 do
			mainCityFunctions.addToTableIfNotExist(nil, buildIndexArray, i)
		end
		local cityCell = cityCtrl:getCurCity()
		local openAreaList = cityCell.areaList
		for i, v in ipairs(openAreaList) do
			local openGroundInfo = cityltCtrl.getOpenGoundInfo(v)
			if openGroundInfo then
				local minIndex = openGroundInfo.minIndex
				local maxIndex = openGroundInfo.maxIndex
				for j = minIndex, maxIndex do
					buildIndexArray[#buildIndexArray + 1] = j
				end
			end
		end
	end
	for i = 1, #buildIndexArray do
		local index = buildIndexArray[i]
		local buildCell = cityCtrl:getBuildCellByIndex(index)
		if not buildCell then
			buildIndex = index
			break
		end
	end
	return buildIndex
end
function mainCityFunctions.getMainCityCanBuildIndex(bid)
	return mainCityFunctions.getCanBuildIndexByBid(nil, bid)
end
function mainCityFunctions.getMainCityView()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if currentView.__cname == "mainCityView" then
			return currentView
		end
	end
end
function mainCityFunctions.loadSoldiers(mainCity)
	local self = mainCity
	local cityBuildSoldiersMatrix = include("cityBuildSoldiersMatrix")
	local cityBuildSoldiersMatrixNode = cityBuildSoldiersMatrix.new()
	_ENV = nil
	;(nil).matrixType = cityBuildConstDef.matrixType.normal
	cityBuildSoldiersMatrixNode:initWithData(nil)
	cityBuildSoldiersMatrixNode:addTo(self.containerView)
	cityBuildSoldiersMatrixNode:setPosition(cc.p(1106, 740))
	cityBuildSoldiersMatrixNode:setName("cityBuildSoldiersMatrixNode")
	self.cityBuildSoldiersMatrixNode = cityBuildSoldiersMatrixNode
	self.cityBuildSoldiersMatrixNode:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.npc)
	local cityBuildEliteMatrixNode = cityBuildSoldiersMatrix.new()
	_ENV = cc.p(1106, 740)
	cc.p(1106, 740).matrixType = cityBuildConstDef.matrixType.elite
	cityBuildEliteMatrixNode:initWithData(cc.p(1106, 740))
	cityBuildEliteMatrixNode:addTo(self.containerView)
	cityBuildEliteMatrixNode:setPosition(cc.p(1410, 880))
	cityBuildEliteMatrixNode:setName("cityBuildEliteMatrixNode")
	self.cityBuildEliteMatrixNode = cityBuildEliteMatrixNode
	self.cityBuildEliteMatrixNode:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.npc)
end
function mainCityFunctions.updateLockTurret(mainCity)
end
function mainCityFunctions.delayUpdateMainCityPos(mainCity)
	local self = mainCity
	local retPos = self:getDefaultMainCityPos()
	local curZoomScale = self:getZoomScale(true)
	self:autoUpdateViewScrollViewPos()
	local hasGuideBuildLegendMonument = cityBuildFunction:getGuideBuildLegendMonument()
	local hasCargo = false
	local hasWuzi = false
	local hasLeisureFreeTimes = false
	if hasGuideBuildLegendMonument then
		if self.isLogin then
			self:setZoomScale(self.defaultScale, true, self.initZoomScaleDuration)
			local delayTime = cca.delay(self.initZoomScaleDuration + 0.2)
			local callFunc = cca.callFunc(function()
				local currentOffset = self.viewScrollView:getContentOffset()
				local duration = self:getAnimDuration(currentOffset, retPos, self.autoMoveSpeedSlow)
				self:disableMoveForDuration(duration)
				self.viewScrollView:setContentOffsetInDuration(retPos, duration)
			end)
			cityBuildConstDef = true
			;(true)[1] = delayTime
			;(true)[2] = callFunc
			local seq = cca.seq(true)
			seq:setTag(cityBuildConstDef.ActionTag.Tag_delayUpdateMainCityPos)
			self:runAction(seq)
		else
			self:disableMoveForDuration(self.initZoomScaleDuration)
			return
		end
	elseif hasCargo then
		if self.isLogin then
			self:setZoomScale(self.defaultScale, true, self.initZoomScaleDuration)
			local delayTime = cca.delay(self.initZoomScaleDuration + 0.2)
			local callFunc = cca.callFunc(function()
				local currentOffset = self.viewScrollView:getContentOffset()
				local duration = self:getAnimDuration(currentOffset, retPos, self.autoMoveSpeedSlow)
				self:disableMoveForDuration(duration)
				self.viewScrollView:setContentOffsetInDuration(retPos, duration)
			end)
			cityBuildConstDef = true
			;(true)[1] = delayTime
			;(true)[2] = callFunc
			local seq = cca.seq(true)
			seq:setTag(cityBuildConstDef.ActionTag.Tag_delayUpdateMainCityPos)
			self:runAction(seq)
		else
			self:disableMoveForDuration(self.initZoomScaleDuration)
			return
		end
	elseif hasWuzi then
		if self.isLogin then
			self:setZoomScale(self.defaultScale, true, self.initZoomScaleDuration)
			local delayTime = cca.delay(self.initZoomScaleDuration + 0.2)
			local callFunc = cca.callFunc(function()
				local currentOffset = self.viewScrollView:getContentOffset()
				local duration = self:getAnimDuration(currentOffset, retPos, self.autoMoveSpeedSlow)
				self:disableMoveForDuration(duration)
				self.viewScrollView:setContentOffsetInDuration(retPos, duration)
			end)
			cityBuildConstDef = true
			;(true)[1] = delayTime
			;(true)[2] = callFunc
			local seq = cca.seq(true)
			seq:setTag(cityBuildConstDef.ActionTag.Tag_delayUpdateMainCityPos)
			self:runAction(seq)
		else
			self:disableMoveForDuration(self.initZoomScaleDuration)
			return
		end
	elseif hasLeisureFreeTimes then
		if self.isLogin then
			self:setZoomScale(self.defaultScale, true, self.initZoomScaleDuration)
			local delayTime = cca.delay(self.initZoomScaleDuration + 0.2)
			local callFunc = cca.callFunc(function()
				local currentOffset = self.viewScrollView:getContentOffset()
				local duration = self:getAnimDuration(currentOffset, retPos, self.autoMoveSpeedSlow)
				self:disableMoveForDuration(duration)
				self.viewScrollView:setContentOffsetInDuration(retPos, duration)
			end)
			cityBuildConstDef = true
			;(true)[1] = delayTime
			;(true)[2] = callFunc
			local seq = cca.seq(true)
			seq:setTag(cityBuildConstDef.ActionTag.Tag_delayUpdateMainCityPos)
			self:runAction(seq)
		else
			self:disableMoveForDuration(self.initZoomScaleDuration)
			return
		end
	elseif self.isLogin then
		self:setZoomScale(self.defaultScale, true, self.initZoomScaleDuration)
		self:disableMoveForDuration(self.initZoomScaleDuration)
	else
		self:disableMoveForDuration(self.initZoomScaleDuration)
		return
	end
end
function mainCityFunctions.gotoLockArea(mainCity, delay)
	local self = mainCity
	local cityCell = cityCtrl:getCurCity()
	local openAreaList = cityCell.areaList
	local cityCtrl, unOpenAreaList
	local opengroundinfo = require("app." .. LocalTblPath .. ".config_server.opengroundinfo")
	for i, v in ipairs(opengroundinfo) do
		local isOpened = false
		for j, k in ipairs(openAreaList) do
			if v.areaid == k then
				isOpened = true
			end
		end
		if isOpened == false then
			table.insert(unOpenAreaList, #unOpenAreaList + 1, v.areaid)
		end
	end
	table.sort(unOpenAreaList)
	if #unOpenAreaList == 0 then
		self:gotoInnerCity()
		return
	end
	local buildIndex = unOpenAreaList[1]
	mainCityFunctions.gotoLockAreaByIndex(mainCity, buildIndex, delay, false)
end
function mainCityFunctions.gotoLockAreaByIndex(mainCity, buildIndex, delay, isShowHand)
	local self = mainCity
	local buildName = "Panel_Area_Lock_" .. buildIndex
	local build = self:getBufferNodeByName(buildName)
	local offset = self:getContainerOffsetWhenCenterTarget(build, true)
	local currentOffset = self.viewScrollView:getContentOffset()
	local duration = delay or self:getAnimDuration(currentOffset, offset)
	self.viewScrollView:setContentOffsetInDuration(offset, duration)
	if isShowHand == true then
		local buildTopTipHandNodeName = "build_topTipHand_lockarea_" .. buildIndex
		local buildTopTipHandNode = self.containerView:getChildByName(buildTopTipHandNodeName)
		if buildTopTipHandNode then
			buildTopTipHandNode:endTime()
		end
		local x, y = build:getPosition()
		local buildTopTipHand = include("cityBuildTopTipHand")
		local buildTopTipHandNode = buildTopTipHand.new(getCCSPath("cityBuildTopTipHand"))
		buildTopTipHandNode:setName(buildTopTipHandNodeName)
		buildTopTipHandNode:setPosition(cc.p(x + build:getContentSize().width / 2, y + build:getContentSize().height / 2 + 100))
		buildTopTipHandNode:addTo(self.containerView, 400)
	end
end
function mainCityFunctions.getIsOuterBuildUnLocked(mainCity, buildIndex)
	local self = mainCity
	local bRet = false
	local buildlist = cityCtrl:getBuildList()
	if buildlist == nil then
		return bRet
	end
	for k, buildcell in pairs(buildlist) do
		if tonumber(buildcell.info.index) == buildIndex then
			bRet = true
		end
	end
	if 1100 <= buildIndex and buildIndex <= 1114 then
		bRet = true
	end
	if bRet == false then
		local cityCell = cityCtrl:getCurCity()
		local openAreaList = cityCell.areaList
		for i, v in ipairs(openAreaList) do
			local lockAreaName = "Panel_Area_Lock_" .. v
			local panelLockArea = self:getBufferNodeByName(lockAreaName)
			panelLockArea:removeAllChildren()
			panelLockArea:setVisible(false)
			local openGroundInfo = cityltCtrl.getOpenGoundInfo(v)
			local minIndex = openGroundInfo.minIndex
			local maxIndex = openGroundInfo.maxIndex
			if buildIndex >= minIndex and buildIndex <= maxIndex then
				bRet = true
				break
			end
		end
	end
	return bRet
end
function mainCityFunctions.getOneActivityCenterDes(mainCity)
	local self = mainCity
	local des = i18n("common_text_608")
	local icon = ""
	local ret = false
	local eventList = clientEventMgr.nowEventStateList
	if eventList and next(eventList) ~= nil then
		local keys = table.keys(clientEventMgr.nowEventStateList)
		local selectEvent = clientEventMgr.nowEventStateList[keys[math.random(#keys)]]
		icon = selectEvent.flagIcon
		ret = true
	end
	return des, icon, ret
end
function mainCityFunctions.getOneGuardSoldierDes(mainCity)
	local self = mainCity
	local des = ""
	local _ENV, desTable
	local bit = require("bit32")
	local queryMask = cityBuildConstDef.guardMaskValue.normal
	local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
	if gRomeActivityState.OPEN == romeActivityCtrl.activityState then
		queryMask = bit.bor(queryMask, cityBuildConstDef.guardMaskValue.activity_rome)
	else
		queryMask = bit.bor(queryMask, cityBuildConstDef.guardMaskValue.not_rome)
		local kingsOrderTimer = activityCtrl:queryQueue(activityCtrl.activityState)
		local kingsOrderState = activityCtrl.activityState
		if not kingsOrderTimer or gActivityState.CLOSE == kingsOrderState then
		elseif gActivityState.PREPARE == kingsOrderState then
		elseif gActivityState.OPEN == kingsOrderState then
			queryMask = bit.bor(queryMask, cityBuildConstDef.guardMaskValue.king_order)
		end
	end
	local maincityDesRead = include("maincityDesRead")
	local desTable = maincityDesRead.getGuardSoldierCfgByMask(queryMask)
	local numOfDes = #desTable
	local randIndex = math.random(1, numOfDes)
	local des = desTable[randIndex]
	return des
end
function mainCityFunctions.getOnePetDes(mainCity)
	local des = ""
	local petDesRead = include("petDesRead")
	local talk = petDesRead.getPetTalk()
	local numOfDes = #talk
	local randIndex = math.random(1, numOfDes)
	local des = talk[randIndex].pet_talk
	if des ~= nil and des ~= "" then
		des = i18n(des)
	end
	return des
end
function mainCityFunctions.loadPathData(mainCity)
	local self = mainCity
	local _ENV, posTable
	for i = 3001, 3070 do
		local posBtn = self.containerView:getChildByTag(i)
		if posBtn then
			local title = posBtn:getTitleText()
			local strTable = string.split(title, "_")
			local strPath = string.format("%.2f, %.2f, %s", posBtn:getPositionX(), posBtn:getPositionY(), strTable[2] or "")
			_UPVALUE2_ = i
			posTable[tostring(i)], i[1] = i, posBtn:getPositionX()
			posTable[tostring(i)], i[2] = i, posBtn:getPositionY()
			posTable[tostring(i)], i[3] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[4] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[5] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[6] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[7] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[8] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[9] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[10] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[11] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[12] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[13] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[14] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[15] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[16] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[17] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[18] = i, tonumber(strTable[2])
			posTable[tostring(i)], i[19] = i, tonumber(strTable[2])
		end
	end
	local cityTroopMatrix = cityBuildFunction.GetTroopsMatrix()
	_UPVALUE21_ = 3070
	cityTroopMatrix["1051"], (3070)[1] = 3070, posTable["3001"]
	cityTroopMatrix["1051"], (3070)[2] = 3070, posTable["3003"]
	cityTroopMatrix["1051"], (3070)[3] = 3070, posTable["3004"]
	cityTroopMatrix["1051"], (3070)[4] = 3070, posTable["3005"]
	cityTroopMatrix["1051"], (3070)[5] = 3070, posTable["3006"]
	cityTroopMatrix["1051"], (3070)[6] = 3070, posTable["3007"]
	cityTroopMatrix["1051"], (3070)[7] = 3070, posTable["3008"]
	cityTroopMatrix["1051"], (3070)[8] = 3070, posTable["3009"]
	cityTroopMatrix["1051"], (3070)[9] = 3070, posTable["3010"]
	cityTroopMatrix["1051"], (3070)[10] = 3070, posTable["3011"]
	cityTroopMatrix["1051"], (3070)[11] = 3070, posTable["3012"]
	cityTroopMatrix["1051"], (3070)[12] = 3070, posTable["3013"]
	cityTroopMatrix["1051"], (3070)[13] = 3070, posTable["3014"]
	cityTroopMatrix["1051"], (3070)[14] = 3070, posTable["3015"]
	cityTroopMatrix["1051"], (3070)[15] = 3070, posTable["3016"]
	cityTroopMatrix["1051"], (3070)[16] = 3070, posTable["3017"]
	cityTroopMatrix["1051"], (3070)[17] = 3070, posTable["3018"]
	cityTroopMatrix["1051"], (3070)[18] = 3070, posTable["3019"]
	cityTroopMatrix["1051"], (3070)[19] = 3070, posTable["3020"]
	cityTroopMatrix["1051"], (3070)[20] = 3070, posTable["3021"]
	cityTroopMatrix["1051"], (3070)[21] = 3070, posTable["3022"]
	cityTroopMatrix["1051"], (3070)[22] = 3070, posTable["3023"]
	cityTroopMatrix["1051"], (3070)[23] = 3070, posTable["3024"]
	cityTroopMatrix["1051"], (3070)[24] = 3070, posTable["3025"]
	cityTroopMatrix["1051"], (3070)[25] = 3070, posTable["3026"]
	cityTroopMatrix["1051"], (3070)[26] = 3070, posTable["3027"]
	print("1051-----------------------")
	local strPosTotal = ""
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1051"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE21_ = print
	cityTroopMatrix["1056"], print[1] = print, posTable["3002"]
	cityTroopMatrix["1056"], print[2] = print, posTable["3003"]
	cityTroopMatrix["1056"], print[3] = print, posTable["3004"]
	cityTroopMatrix["1056"], print[4] = print, posTable["3005"]
	cityTroopMatrix["1056"], print[5] = print, posTable["3006"]
	cityTroopMatrix["1056"], print[6] = print, posTable["3007"]
	cityTroopMatrix["1056"], print[7] = print, posTable["3008"]
	cityTroopMatrix["1056"], print[8] = print, posTable["3009"]
	cityTroopMatrix["1056"], print[9] = print, posTable["3010"]
	cityTroopMatrix["1056"], print[10] = print, posTable["3011"]
	cityTroopMatrix["1056"], print[11] = print, posTable["3012"]
	cityTroopMatrix["1056"], print[12] = print, posTable["3013"]
	cityTroopMatrix["1056"], print[13] = print, posTable["3014"]
	cityTroopMatrix["1056"], print[14] = print, posTable["3015"]
	cityTroopMatrix["1056"], print[15] = print, posTable["3016"]
	cityTroopMatrix["1056"], print[16] = print, posTable["3017"]
	cityTroopMatrix["1056"], print[17] = print, posTable["3018"]
	cityTroopMatrix["1056"], print[18] = print, posTable["3019"]
	cityTroopMatrix["1056"], print[19] = print, posTable["3020"]
	cityTroopMatrix["1056"], print[20] = print, posTable["3021"]
	cityTroopMatrix["1056"], print[21] = print, posTable["3022"]
	cityTroopMatrix["1056"], print[22] = print, posTable["3023"]
	cityTroopMatrix["1056"], print[23] = print, posTable["3024"]
	cityTroopMatrix["1056"], print[24] = print, posTable["3025"]
	cityTroopMatrix["1056"], print[25] = print, posTable["3026"]
	cityTroopMatrix["1056"], print[26] = print, posTable["3027"]
	print("1056-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1056"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE20_ = print
	cityTroopMatrix["1057"], print[1] = print, posTable["3004"]
	cityTroopMatrix["1057"], print[2] = print, posTable["3005"]
	cityTroopMatrix["1057"], print[3] = print, posTable["3006"]
	cityTroopMatrix["1057"], print[4] = print, posTable["3007"]
	cityTroopMatrix["1057"], print[5] = print, posTable["3008"]
	cityTroopMatrix["1057"], print[6] = print, posTable["3009"]
	cityTroopMatrix["1057"], print[7] = print, posTable["3010"]
	cityTroopMatrix["1057"], print[8] = print, posTable["3011"]
	cityTroopMatrix["1057"], print[9] = print, posTable["3012"]
	cityTroopMatrix["1057"], print[10] = print, posTable["3013"]
	cityTroopMatrix["1057"], print[11] = print, posTable["3014"]
	cityTroopMatrix["1057"], print[12] = print, posTable["3015"]
	cityTroopMatrix["1057"], print[13] = print, posTable["3016"]
	cityTroopMatrix["1057"], print[14] = print, posTable["3017"]
	cityTroopMatrix["1057"], print[15] = print, posTable["3018"]
	cityTroopMatrix["1057"], print[16] = print, posTable["3019"]
	cityTroopMatrix["1057"], print[17] = print, posTable["3020"]
	cityTroopMatrix["1057"], print[18] = print, posTable["3021"]
	cityTroopMatrix["1057"], print[19] = print, posTable["3022"]
	cityTroopMatrix["1057"], print[20] = print, posTable["3023"]
	cityTroopMatrix["1057"], print[21] = print, posTable["3024"]
	cityTroopMatrix["1057"], print[22] = print, posTable["3025"]
	cityTroopMatrix["1057"], print[23] = print, posTable["3026"]
	cityTroopMatrix["1057"], print[24] = print, posTable["3027"]
	print("1057-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1057"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE20_ = print
	cityTroopMatrix["1063"], print[1] = print, posTable["3004"]
	cityTroopMatrix["1063"], print[2] = print, posTable["3005"]
	cityTroopMatrix["1063"], print[3] = print, posTable["3006"]
	cityTroopMatrix["1063"], print[4] = print, posTable["3007"]
	cityTroopMatrix["1063"], print[5] = print, posTable["3008"]
	cityTroopMatrix["1063"], print[6] = print, posTable["3009"]
	cityTroopMatrix["1063"], print[7] = print, posTable["3010"]
	cityTroopMatrix["1063"], print[8] = print, posTable["3011"]
	cityTroopMatrix["1063"], print[9] = print, posTable["3012"]
	cityTroopMatrix["1063"], print[10] = print, posTable["3013"]
	cityTroopMatrix["1063"], print[11] = print, posTable["3014"]
	cityTroopMatrix["1063"], print[12] = print, posTable["3015"]
	cityTroopMatrix["1063"], print[13] = print, posTable["3016"]
	cityTroopMatrix["1063"], print[14] = print, posTable["3017"]
	cityTroopMatrix["1063"], print[15] = print, posTable["3018"]
	cityTroopMatrix["1063"], print[16] = print, posTable["3019"]
	cityTroopMatrix["1063"], print[17] = print, posTable["3020"]
	cityTroopMatrix["1063"], print[18] = print, posTable["3021"]
	cityTroopMatrix["1063"], print[19] = print, posTable["3022"]
	cityTroopMatrix["1063"], print[20] = print, posTable["3023"]
	cityTroopMatrix["1063"], print[21] = print, posTable["3024"]
	cityTroopMatrix["1063"], print[22] = print, posTable["3025"]
	cityTroopMatrix["1063"], print[23] = print, posTable["3026"]
	cityTroopMatrix["1063"], print[24] = print, posTable["3027"]
	print("1063-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1063"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE16_ = print
	cityTroopMatrix["1064"], print[1] = print, posTable["3012"]
	cityTroopMatrix["1064"], print[2] = print, posTable["3013"]
	cityTroopMatrix["1064"], print[3] = print, posTable["3014"]
	cityTroopMatrix["1064"], print[4] = print, posTable["3015"]
	cityTroopMatrix["1064"], print[5] = print, posTable["3016"]
	cityTroopMatrix["1064"], print[6] = print, posTable["3017"]
	cityTroopMatrix["1064"], print[7] = print, posTable["3018"]
	cityTroopMatrix["1064"], print[8] = print, posTable["3019"]
	cityTroopMatrix["1064"], print[9] = print, posTable["3020"]
	cityTroopMatrix["1064"], print[10] = print, posTable["3021"]
	cityTroopMatrix["1064"], print[11] = print, posTable["3022"]
	cityTroopMatrix["1064"], print[12] = print, posTable["3023"]
	cityTroopMatrix["1064"], print[13] = print, posTable["3024"]
	cityTroopMatrix["1064"], print[14] = print, posTable["3025"]
	cityTroopMatrix["1064"], print[15] = print, posTable["3026"]
	cityTroopMatrix["1064"], print[16] = print, posTable["3027"]
	print("1064-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1064"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE10_ = print
	cityTroopMatrix["1061"], print[1] = print, posTable["3048"]
	cityTroopMatrix["1061"], print[2] = print, posTable["3019"]
	cityTroopMatrix["1061"], print[3] = print, posTable["3020"]
	cityTroopMatrix["1061"], print[4] = print, posTable["3021"]
	cityTroopMatrix["1061"], print[5] = print, posTable["3022"]
	cityTroopMatrix["1061"], print[6] = print, posTable["3023"]
	cityTroopMatrix["1061"], print[7] = print, posTable["3024"]
	cityTroopMatrix["1061"], print[8] = print, posTable["3025"]
	cityTroopMatrix["1061"], print[9] = print, posTable["3026"]
	cityTroopMatrix["1061"], print[10] = print, posTable["3027"]
	print("1061-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1061"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE5_ = print
	cityTroopMatrix["1062"], print[1] = print, posTable["3023"]
	cityTroopMatrix["1062"], print[2] = print, posTable["3024"]
	cityTroopMatrix["1062"], print[3] = print, posTable["3025"]
	cityTroopMatrix["1062"], print[4] = print, posTable["3026"]
	cityTroopMatrix["1062"], print[5] = print, posTable["3027"]
	print("1062-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1062"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE13_ = print
	cityTroopMatrix["1058"], print[1] = print, posTable["3047"]
	cityTroopMatrix["1058"], print[2] = print, posTable["3043"]
	cityTroopMatrix["1058"], print[3] = print, posTable["3044"]
	cityTroopMatrix["1058"], print[4] = print, posTable["3045"]
	cityTroopMatrix["1058"], print[5] = print, posTable["3046"]
	cityTroopMatrix["1058"], print[6] = print, posTable["3020"]
	cityTroopMatrix["1058"], print[7] = print, posTable["3021"]
	cityTroopMatrix["1058"], print[8] = print, posTable["3022"]
	cityTroopMatrix["1058"], print[9] = print, posTable["3023"]
	cityTroopMatrix["1058"], print[10] = print, posTable["3024"]
	cityTroopMatrix["1058"], print[11] = print, posTable["3025"]
	cityTroopMatrix["1058"], print[12] = print, posTable["3026"]
	cityTroopMatrix["1058"], print[13] = print, posTable["3027"]
	print("1058-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1058"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE13_ = print
	cityTroopMatrix["1059"], print[1] = print, posTable["3042"]
	cityTroopMatrix["1059"], print[2] = print, posTable["3043"]
	cityTroopMatrix["1059"], print[3] = print, posTable["3044"]
	cityTroopMatrix["1059"], print[4] = print, posTable["3045"]
	cityTroopMatrix["1059"], print[5] = print, posTable["3046"]
	cityTroopMatrix["1059"], print[6] = print, posTable["3020"]
	cityTroopMatrix["1059"], print[7] = print, posTable["3021"]
	cityTroopMatrix["1059"], print[8] = print, posTable["3022"]
	cityTroopMatrix["1059"], print[9] = print, posTable["3023"]
	cityTroopMatrix["1059"], print[10] = print, posTable["3024"]
	cityTroopMatrix["1059"], print[11] = print, posTable["3025"]
	cityTroopMatrix["1059"], print[12] = print, posTable["3026"]
	cityTroopMatrix["1059"], print[13] = print, posTable["3027"]
	print("1059-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1059"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE14_ = print
	cityTroopMatrix["1060"], print[1] = print, posTable["3040"]
	cityTroopMatrix["1060"], print[2] = print, posTable["3041"]
	cityTroopMatrix["1060"], print[3] = print, posTable["3043"]
	cityTroopMatrix["1060"], print[4] = print, posTable["3044"]
	cityTroopMatrix["1060"], print[5] = print, posTable["3045"]
	cityTroopMatrix["1060"], print[6] = print, posTable["3046"]
	cityTroopMatrix["1060"], print[7] = print, posTable["3020"]
	cityTroopMatrix["1060"], print[8] = print, posTable["3021"]
	cityTroopMatrix["1060"], print[9] = print, posTable["3022"]
	cityTroopMatrix["1060"], print[10] = print, posTable["3023"]
	cityTroopMatrix["1060"], print[11] = print, posTable["3024"]
	cityTroopMatrix["1060"], print[12] = print, posTable["3025"]
	cityTroopMatrix["1060"], print[13] = print, posTable["3026"]
	cityTroopMatrix["1060"], print[14] = print, posTable["3027"]
	print("1060-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1060"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE17_ = print
	cityTroopMatrix["1065"], print[1] = print, posTable["3066"]
	cityTroopMatrix["1065"], print[2] = print, posTable["3063"]
	cityTroopMatrix["1065"], print[3] = print, posTable["3064"]
	cityTroopMatrix["1065"], print[4] = print, posTable["3065"]
	cityTroopMatrix["1065"], print[5] = print, posTable["3014"]
	cityTroopMatrix["1065"], print[6] = print, posTable["3015"]
	cityTroopMatrix["1065"], print[7] = print, posTable["3016"]
	cityTroopMatrix["1065"], print[8] = print, posTable["3017"]
	cityTroopMatrix["1065"], print[9] = print, posTable["3018"]
	cityTroopMatrix["1065"], print[10] = print, posTable["3019"]
	cityTroopMatrix["1065"], print[11] = print, posTable["3020"]
	cityTroopMatrix["1065"], print[12] = print, posTable["3021"]
	cityTroopMatrix["1065"], print[13] = print, posTable["3022"]
	cityTroopMatrix["1065"], print[14] = print, posTable["3023"]
	cityTroopMatrix["1065"], print[15] = print, posTable["3024"]
	cityTroopMatrix["1065"], print[16] = print, posTable["3025"]
	cityTroopMatrix["1065"], print[17] = print, posTable["3026"]
	cityTroopMatrix["1065"], print[18] = print, posTable["3027"]
	print("1065-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1065"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE18_ = print
	cityTroopMatrix["1066"], print[1] = print, posTable["3061"]
	cityTroopMatrix["1066"], print[2] = print, posTable["3062"]
	cityTroopMatrix["1066"], print[3] = print, posTable["3063"]
	cityTroopMatrix["1066"], print[4] = print, posTable["3064"]
	cityTroopMatrix["1066"], print[5] = print, posTable["3065"]
	cityTroopMatrix["1066"], print[6] = print, posTable["3014"]
	cityTroopMatrix["1066"], print[7] = print, posTable["3015"]
	cityTroopMatrix["1066"], print[8] = print, posTable["3016"]
	cityTroopMatrix["1066"], print[9] = print, posTable["3017"]
	cityTroopMatrix["1066"], print[10] = print, posTable["3018"]
	cityTroopMatrix["1066"], print[11] = print, posTable["3019"]
	cityTroopMatrix["1066"], print[12] = print, posTable["3020"]
	cityTroopMatrix["1066"], print[13] = print, posTable["3021"]
	cityTroopMatrix["1066"], print[14] = print, posTable["3022"]
	cityTroopMatrix["1066"], print[15] = print, posTable["3023"]
	cityTroopMatrix["1066"], print[16] = print, posTable["3024"]
	cityTroopMatrix["1066"], print[17] = print, posTable["3025"]
	cityTroopMatrix["1066"], print[18] = print, posTable["3026"]
	cityTroopMatrix["1066"], print[19] = print, posTable["3027"]
	print("1066-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1066"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
	_UPVALUE18_ = print
	cityTroopMatrix["1067"], print[1] = print, posTable["3060"]
	cityTroopMatrix["1067"], print[2] = print, posTable["3061"]
	cityTroopMatrix["1067"], print[3] = print, posTable["3062"]
	cityTroopMatrix["1067"], print[4] = print, posTable["3063"]
	cityTroopMatrix["1067"], print[5] = print, posTable["3064"]
	cityTroopMatrix["1067"], print[6] = print, posTable["3065"]
	cityTroopMatrix["1067"], print[7] = print, posTable["3014"]
	cityTroopMatrix["1067"], print[8] = print, posTable["3015"]
	cityTroopMatrix["1067"], print[9] = print, posTable["3016"]
	cityTroopMatrix["1067"], print[10] = print, posTable["3017"]
	cityTroopMatrix["1067"], print[11] = print, posTable["3018"]
	cityTroopMatrix["1067"], print[12] = print, posTable["3019"]
	cityTroopMatrix["1067"], print[13] = print, posTable["3020"]
	cityTroopMatrix["1067"], print[14] = print, posTable["3021"]
	cityTroopMatrix["1067"], print[15] = print, posTable["3022"]
	cityTroopMatrix["1067"], print[16] = print, posTable["3023"]
	cityTroopMatrix["1067"], print[17] = print, posTable["3024"]
	cityTroopMatrix["1067"], print[18] = print, posTable["3025"]
	cityTroopMatrix["1067"], print[19] = print, posTable["3026"]
	cityTroopMatrix["1067"], print[20] = print, posTable["3027"]
	print("1067-----------------------")
	strPosTotal = ""
	for i, v in ipairs(cityTroopMatrix["1067"]) do
		local strPos = string.format("{%.2f, %.2f, %d}", v[1], v[2], v[3])
		strPosTotal = strPosTotal .. strPos .. ", "
	end
	print(strPosTotal)
end
function mainCityFunctions.showFadeInOut(mainCity, node)
	local self = mainCity
	if not node then
		return
	end
	local et_children = node:getChildren()
	for i = 1, #et_children do
		local cNameTb = SoraDStringSplit(et_children[i]:getName(), "_")
		if cNameTb and cNameTb[1] == "imagedcb" then
			et_children[i]:stopAllActions()
			SoraDFadeINOUT(et_children[i])
		end
	end
end
function mainCityFunctions:getNextPeroidDelay()
	local delay = 1
	local sysTime = serviceFunctions.systemTime()
	if sysTime == nil then
		sysTime = os.time()
	end
	local timeOfDay = os.date("*t", sysTime)
	local nextHour = timeOfDay.hour + 1
	local totalDelay = 0
	local opacityLightNight = cityBuildConstDef.opacityType.opacityLightNight
	local opacityDeepNight = cityBuildConstDef.opacityType.opacityDeepNight
	local currentOpacity = 0
	local GetDelay = function(nextHour, timeOfDay)
		return (nextHour - timeOfDay.hour - 1) * 3600 + (60 - timeOfDay.min - 1) * 60 + (60 - timeOfDay.sec)
	end
	if timeOfDay.hour >= 6 and timeOfDay.hour < 18 then
		nextHour = 18
		delay = GetDelay(nextHour, timeOfDay)
		currentOpacity = 0
	elseif timeOfDay.hour >= 18 and timeOfDay.hour < 20 then
		nextHour = 20
		delay = GetDelay(nextHour, timeOfDay)
		totalDelay = 7200
		currentOpacity = opacityLightNight + (opacityDeepNight - opacityLightNight) * (totalDelay - delay) / totalDelay
	elseif timeOfDay.hour >= 20 and timeOfDay.hour < 24 then
		nextHour = 24
		delay = GetDelay(nextHour, timeOfDay)
		currentOpacity = opacityDeepNight
	elseif 0 < timeOfDay.hour and timeOfDay.hour < 4 then
		nextHour = 4
		delay = GetDelay(nextHour, timeOfDay)
		currentOpacity = opacityDeepNight
	elseif timeOfDay.hour >= 4 and timeOfDay.hour < 6 then
		nextHour = 6
		delay = GetDelay(nextHour, timeOfDay)
		totalDelay = 7200
		currentOpacity = opacityLightNight + (opacityDeepNight - opacityLightNight) * delay / totalDelay
	end
	return delay, currentOpacity
end
function mainCityFunctions:getCastleLv()
	local castleLv = 1
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	if castleBcell then
		castleLv = tonumber(castleBcell.info.lv)
	end
	return castleLv
end
function mainCityFunctions.autoCollectRes(mainCity)
	local self = mainCity
	if self.collectBuilds == nil then
		self.collectBuilds, _ENV = self.collectBuilds, self.collectBuilds
	end
	if #self.collectBuilds > 0 then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildlist = cityCtrl:getBuildList()
	_UPVALUE5_ = cityCtrl
	cityCtrl[1] = BUILDID.FARM
	cityCtrl[2] = BUILDID.SAWMILL
	cityCtrl[3] = BUILDID.IRON_MINE
	cityCtrl[4] = BUILDID.STEEL
	local cityCtrl[5], checkTable = BUILDID.CRYSTAL_MINE, cityCtrl
	for k, buildcellItem in pairs(buildlist) do
		if buildcellItem.info and buildcellItem.info.index then
			local buildIndex = tonumber(buildcellItem.info.index)
			if 1100 <= buildIndex then
				local cellIndexName = "build_" .. buildIndex
				local buildBtn = self:getBufferNodeByName(cellIndexName)
				if buildBtn then
					local buildEntity = buildBtn:getChildByName("buildName")
					if nil ~= buildEntity then
						for i, v in ipairs(checkTable) do
							if buildEntity:getBuildBid() == v then
								table.insert(self.collectBuilds, #self.collectBuilds + 1, buildIndex)
							end
						end
					end
				end
			end
		end
	end
	if #self.collectBuilds > 0 then
		table.sort(self.collectBuilds, function(a, b)
			return a < b
		end)
		self:autoCollectBuildResSchedule()
		self:CollectBuildResUpdate()
	end
end
function mainCityFunctions.getBuildIndexByBid(bid, iid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildlist = cityCtrl:getBuildList()
	if buildlist == nil then
		return
	end
	for k, buildcell in pairs(buildlist) do
		if iid ~= nil then
			if tonumber(buildcell.info.bid) == bid and iid == tonumber(buildcell.info.iid) then
				local index = tonumber(buildcell.info.index)
				return index
			end
		elseif tonumber(buildcell.info.bid) == bid then
			local lv, iid = cityCtrl:getBuildMaxLv(bid)
			local maxLvBuildCell = cityCtrl:getBuildCell(bid, iid)
			local index = tonumber(maxLvBuildCell.info.index)
			return index
		end
	end
	return bid
end
function mainCityFunctions:getTargetPosByIndex(index)
	local mainCity = mainCityFunctions.getMainCityView()
	if mainCity and index and 0 < index then
		local cityBuildEntity
		local x, y = 0, 0
		if index >= cityBuildConstDef.buildIndexDef.index_lock_area_1 and index <= cityBuildConstDef.buildIndexDef.index_lock_area_4 then
			local buildBtnName = "Panel_Area_Lock_" .. index
			cityBuildEntity = mainCity:getBufferNodeByName(buildBtnName)
			x, y = cityBuildEntity:getPosition()
			x = x + 180
			y = y + 130
		else
			cityBuildEntity = mainCity:getBuildBtnByIndex(index)
			x, y = cityBuildEntity:getPosition()
		end
		return cc.p(x, y)
	end
end
function mainCityFunctions:jump(jumpData)
	local jumpCityInner = function(jumpData)
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_JUMP"
		;(nil).jumpType = jumpData.jumpType
		;(nil).bid = jumpData.bid
		;(nil).iid = jumpData.iid
		SoraDSendMessage(nil)
		if jumpData.view == "MainUIBottom" and jumpData.widget == "Button_alliance" then
			local mainUI = SoraDCurrentMainUI()
			local btnAlliance = mainUI:getBtnTarget("alliance")
			local x, y = btnAlliance:getPosition()
			local xOffset = 0
			local yOffset = 50
			local buildTopTipHand = include("cityBuildTopTipHand")
			local buildTopTipHandNode = buildTopTipHand.new(getCCSPath("cityBuildTopTipHand"))
			buildTopTipHandNode:setName(buildTopTipHandNodeName)
			buildTopTipHandNode:setPosition(cc.p(x + xOffset, y + yOffset))
			buildTopTipHandNode:addTo(btnAlliance:getParent(), 400)
			local mainUIDef = include("mainUIDef")
			buildTopTipHandNode:setGroupID(mainUIDef.uiGroupID.group_topText)
			buildTopTipHandNode:setGroupAuto(true)
		end
	end
	if jumpData.jumpType == "world" then
		SoraDGotoWorldMapPoint()
	elseif jumpData.jumpType == "city" then
		local bid = jumpData.bid
		local iid = jumpData.iid or 0
		local buildType = SoraDGetBuildTypeByBid(bid)
		if buildType == 0 then
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local buildCell = cityCtrl:getBuildCell(bid, 0)
			if buildCell == nil then
				if jumpData.other and jumpData.other.jumpType == "cityInner" then
					jumpCityInner(jumpData.other)
				end
				return
			end
		elseif buildType == 1 and iid == 0 then
			iid = nil
		end
		_ENV = gametop.playertop_:getModule("cityCtrl")
		gametop.playertop_:getModule("cityCtrl").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
		gametop.playertop_:getModule("cityCtrl").offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
		gametop.playertop_:getModule("cityCtrl").bid = bid
		local gametop.playertop_:getModule("cityCtrl").iid, data = iid, gametop.playertop_:getModule("cityCtrl")
		SoraDGotoCityBuild(data)
	elseif jumpData.jumpType == "cityOtherBuild" then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_JUMP"
		;(nil).jumpType = jumpData.jumpType
		;(nil).bid = jumpData.bid
		;(nil).iid = jumpData.iid
		SoraDSendMessage(nil)
	elseif jumpData.jumpType == "cityFixedBuild" then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_JUMP"
		;(nil).jumpType = jumpData.jumpType
		;(nil).bid = jumpData.bid
		;(nil).iid = jumpData.iid
		SoraDSendMessage(nil)
	elseif jumpData.jumpType == "cityInner" then
		jumpCityInner(jumpData)
	elseif jumpData.jumpType == "view" then
		SoraDCreatePanel(jumpData.view):show()
	end
end
function mainCityFunctions.isBuildIdleByBid(bid)
	local buildIndex = mainCityFunctions.getBuildIndexByBid(bid)
	return mainCityFunctions.isBuildIdleByIndex(buildIndex)
end
function mainCityFunctions.isBuildIdleByIndex(bIndex)
	print("mainCityFunctions.isBuildIdleByIndex(bIndex) = ", bIndex)
	local mainCity = mainCityFunctions.getMainCityView()
	if mainCity then
		local cityBuildEntity = mainCity:getBuildByIndex(bIndex)
		if cityBuildEntity then
			return cityBuildEntity:isIdle()
		end
	end
end
function mainCityFunctions.masteryJumpToBuildUpgrade(bid, iid)
	local buildIndex = mainCityFunctions.getBuildIndexByBid(bid, iid)
	local buildEntity = cityBuildMgr:getBuildByBid(bid)
	mainCityFunctions, mainCityFunctions = nil, nil
	;(nil).bid = bid
	;(nil).iid = iid
	;(nil).index = buildIndex
	;(nil).upgradeData, (nil).buildEntity = nil, buildEntity
	uiManager:show("BuildCreateInfo", nil)
	local city = SoraDCurrentSceneShowView("mainCityView")
	local buildType = SoraDGetBuildTypeByBid(bid)
	local yOffset
	if buildType == 1 then
		yOffset = 300
	end
	mainCityFunctions = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	;(nil).noScaleDuration = true
	;(nil).noOffsetDuration = true
	;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
	;(nil).buildIndex = buildIndex
	;(nil).scale = city.preZoomScale
	;(nil).yOffset = yOffset
	SoraDSendMessage(nil)
	mainCityFunctions = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
	;(nil).buildIndex = buildIndex
	SoraDSendMessage(nil)
end
function mainCityFunctions.masteryJumpToDetailView(bid, iid, needBack)
	local specializationRead = include("specializationRead")
	local buildIndex = mainCityFunctions.getBuildIndexByBid(bid, iid)
	local buildType = SoraDGetBuildTypeByBid(bid)
	local toScale = 1.0
	if buildType == 1 then
		toScale = 1.3
	end
	local yOffset = display.height - 280 + display.iPhoneXOffset / 2
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE and (bid == BUILDID.COLLEGE or bid == BUILDID.HALL_OF_WAR) then
		yOffset = yOffset - 30
	end
	_ENV = FACTION_TYPE.FACTION_BYZANTINE
	FACTION_TYPE.FACTION_BYZANTINE.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	FACTION_TYPE.FACTION_BYZANTINE.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
	FACTION_TYPE.FACTION_BYZANTINE.buildIndex = buildIndex
	FACTION_TYPE.FACTION_BYZANTINE.scale = toScale
	FACTION_TYPE.FACTION_BYZANTINE.yOffset = yOffset
	SoraDSendMessage(FACTION_TYPE.FACTION_BYZANTINE)
	local mid = specializationRead.getMasteryID(bid)
	local state = specializationRead.getMasteryState(bid, mid)
	local panel = SoraDCreatePanel("masteryDetailView")
	_ENV = nil
	;(nil).bid = bid
	;(nil).iid = iid
	;(nil).mid = mid
	;(nil).state = state
	;(nil).needBack = needBack
	panel:initData(nil)
	panel:show()
end
return mainCityFunctions
