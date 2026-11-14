local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicBattleDef = include("epicBattleDef")
local worldMapDefine = include("worldMapDefine")
local epicWarltCtrl = include("epicWarltCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local epicBattleMapView = class("epicBattleMapView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleMapView")
	end
	return target
end)
function epicBattleMapView:ctor()
	self.areaInstanceArray, _ENV, self.debugDetail, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.windowTitle:setTitle(i18n("epicbattle_title_01"))
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.btnHelpClick))
	self.Button_over = SoraDGetChildByName(self, "Button_over")
	self.Image_light = SoraDGetChildByName(self.Button_over, "Image_light")
	self.Image_light:setVisible(false)
	self.Button_over:setTitleText(i18n("common_text_1402"))
	self.Button_over:addTouchEventListener(handler(self, self.btnOverClick))
	self.nodeAction = SoraDGetExtendChildFromCCSByName(self, "CCS_epicBattleActionNode_action")
	self.nodeAction:openSwitch()
	self.Text_area = SoraDGetChildByName(self, "Text_area")
	self.Text_curArmy = SoraDGetChildByName(self, "Text_curArmy")
	self.Text_maxArmy = SoraDGetChildByName(self, "Text_maxArmy")
	self.Image_army = SoraDGetChildByName(self, "Image_army")
	self.Image_army:setTouchEnabled(true)
	self.Image_army:setSwallowTouches(false)
	self.Image_army:addTouchEventListener(handler(self, self.btnArmyDetailClick))
	self.Button_detail = SoraDGetChildByName(self, "Button_detail")
	self.Button_detail:setTitleText(i18n("hero_title_02"))
	self.Button_detail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.Node_boss = SoraDGetChildByName(self, "Node_boss")
	self:initMap()
	self:initAnimatonCache()
	self:checkGuide()
	self:updateBossInfo()
	self:updateArmyInfo()
end
function epicBattleMapView:checkGuide()
	local step = SoraDIsGameGuide()
	if step and 49001 < step and step <= 49004 then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
		SoraDSendMessage(nil)
	end
	_ENV, _ENV = nil, SoraDSendMessage
	;(nil).boss = 1
	_ENV, SoraDSendMessage[1], (nil).step = nil, nil, 50003
	;(nil).boss = 1
	_ENV, SoraDSendMessage[2], (nil).step = nil, nil, 50005
	;(nil).boss = 1
	_ENV, SoraDSendMessage[3], (nil).step = nil, nil, 50006
	;(nil).boss = 1
	_ENV, SoraDSendMessage[4], (nil).step = nil, nil, 50010
	;(nil).boss = 3
	_ENV, SoraDSendMessage[5], (nil).step = nil, nil, 50014
	;(nil).boss = 3
	SoraDSendMessage[6], (nil).step = nil, 50018
	local checkBoss = SoraDSendMessage
	local _ENV, arry
	local curStep = guideCtrl:getStepByGuideModule(gGuideModule.EPIC_WAR_2)
	if curStep then
		if curStep <= 50006 then
			table.insert(arry, cca.delay(0.5))
			table.insert(arry, cca.callFunc(function(...)
				guideCtrl:CompleteGuideStep(50003)
			end))
			table.insert(arry, cca.delay(0.5))
			table.insert(arry, cca.callFunc(function(...)
				guideCtrl:CompleteGuideStep(50005)
			end))
		end
		for i, v in ipairs(checkBoss) do
			if epicWarCtrl:isBossKilledByIndex(v.boss) and curStep <= v.step then
				table.insert(arry, cca.delay(0.5))
				table.insert(arry, cca.callFunc(function(...)
					guideCtrl:CompleteGuideStep(v.step)
				end))
			end
		end
	end
	if 0 < #arry then
		table.insert(arry, cca.callFunc(function(...)
			guideCtrl:updateGuideModule(gGuideModule.EPIC_WAR_2, true)
		end))
		self:runAction(cca.seq(arry))
	end
end
function epicBattleMapView:endShow()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		self:removeFromParent()
	else
		SoraDRemoveAllPrePanelFromManager(self, true)
		self.isKilledBoss = epicWarCtrl:isBossKilled()
		if self.isKilledBoss then
			_ENV = epicWarCtrl
			epicWarCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			epicWarCtrl.step = 50022
			SoraDSendMessage(epicWarCtrl)
			return
		end
		local step = guideCtrl:getStepByGuideModule(gGuideModule.EPIC_WAR_2)
		if step and step < 50014 then
			local areaType, status = epicWarCtrl:getAreaTypeByPos(cc.p(1, 2))
			if areaType == epicBattleDef.epicAreaDef.forest then
				_ENV = cc.p(1, 2)
				cc.p(1, 2).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
				cc.p(1, 2).step = 50003
				SoraDSendMessage(cc.p(1, 2))
			elseif areaType == epicBattleDef.epicAreaDef.box then
				_ENV = cc.p(1, 2)
				cc.p(1, 2).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
				cc.p(1, 2).step = 50004
				SoraDSendMessage(cc.p(1, 2))
			else
				guideCtrl:updateGuideModule(gGuideModule.EPIC_WAR_2, true)
			end
		else
			local curStage = epicWarCtrl:getCurGateID()
			local noticeData = epicWarltCtrl.getStageGuideInfo(curStage)
			if noticeData then
				_ENV = gGuideModule.EPIC_WAR_2
				gGuideModule.EPIC_WAR_2.byUID = true
				local guideData = SoraDConfigGet("Game:epicBattleMapView:guide~table", gGuideModule.EPIC_WAR_2)
				if guideData[tostring(curStage)] == nil then
					gModuleMgr.sharedMgr("mildGuideManager"):createNoticeLine(noticeData)
					guideData[tostring(curStage)] = true
					_ENV = cc.p(1, 2)
					cc.p(1, 2).byUID = true
					SoraDConfigSet("Game:epicBattleMapView:guide~table", guideData, cc.p(1, 2))
				end
			end
		end
	end
end
function epicBattleMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ENTER_STAGE", handler(self, self.refreshMap))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_EXIT_STAGE", handler(self, self.exitBattle))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_STAGE_BOSSINFO", handler(self, self.updateBossInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_STAGE_ARMYINFO", handler(self, self.updateArmyInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_STAGE_EXPLORE", handler(self, self.updateArea))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_BUFF_CHOOSE", handler(self, self.showBuff))
end
function epicBattleMapView:initAnimatonCache()
	local _ENV, imgArray
	local ret = _G.SoraDIsFileExistByKey("worldMapBossNormal")
	if ret then
		_ENV = nil
		;(nil).name = "worldMap/worldMapBossNormal"
		table.insert(imgArray, nil)
	else
		_ENV = nil
		;(nil).name = "worldMap/worldMapBossIcon"
		table.insert(imgArray, nil)
	end
	self:loadImages(imgArray, function()
		local hasHD = worldMapDefine.hasBossHdRes()
		if hasHD then
			local framesBoss = display.newFrames("pjys_dj_ws_%.2d.png", 1, 8)
			local animationBoss = display.newAnimation(framesBoss, 1.2 / #framesBoss)
			display.setAnimationCache("boss", animationBoss)
			local framesKing = display.newFrames("panjun_dj_ws_%.2d.png", 1, 8)
			local animationKing = display.newAnimation(framesKing, 1.2 / #framesKing)
			display.setAnimationCache("king", animationKing)
		end
		local framesBx = display.newFrames("zwbx_%.2d.png", 1, 6)
		framesBx[#framesBx + 1] = cc.SpriteFrameCache:getInstance():getSpriteFrame("zwbx_01.png")
		local animationBx = display.newAnimation(framesBx, 1.2 / #framesBx)
		display.setAnimationCache("box", animationBx)
		self:initData()
	end)
end
function epicBattleMapView:initData()
	local passAreaNum = epicWarCtrl:getRealedAreaCount()
	local maxAreaNum = AREA_BORDER_LEN * AREA_BORDER_LEN
	epicWarCtrl = nil
	;(nil).member = passAreaNum
	;(nil).total = maxAreaNum
	self.Text_area:setString(i18n("common_text_155", nil))
	self.isKilledBoss = epicWarCtrl:isBossKilled()
	self.isUnPassArea = epicWarCtrl:isHaveUnFinishArea()
	self.Image_light:setVisible(self.isKilledBoss and not self.isUnPassArea)
	self:initMapAreaData()
end
function epicBattleMapView:refreshMap(target, data)
	self:updateArea()
end
function epicBattleMapView:exitBattle(target, data)
	SoraDCloseLoading(self)
	local chapter, ret = epicWarCtrl:getNewestChapter()
	local panel = SoraDCreatePanel("epicWarChapterView")
	panel:show()
	panel:openLevelView(data.stageID, ret)
	self:removeFromParent()
end
function epicBattleMapView:updateArmyInfo()
	local _, curNum = epicWarCtrl:getCurArmyInfo()
	local _, oriNum = epicWarCtrl:getOriArmyInfo()
	self.Text_curArmy:setString(curNum)
	self.Text_maxArmy:setString("/" .. oriNum)
	self.Text_curArmy:setColor(0 < curNum and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
end
function epicBattleMapView:showBuff(target, data)
	local eType = data.eType
	local getFlickerNode = function(buffType)
		local node = display.newNode()
		local dhName1, color1, dhName2, color2, dhName3, color3, etName, dh1, dh2, dh3, et
		if buffType == epicBattleDef.epicFlyColor.orange then
			dhName1 = "dh_sszzorange_04.png"
			color1 = cc.c3b(255, 196, 89)
			dhName2 = "sdfa.png"
			color2 = cc.c3b(255, 200, 101)
			dhName3 = "dh_sszzorange_03.png"
			color3 = cc.c3b(255, 204, 111)
			etName = "et_sszzorange_02.plist"
		elseif buffType == epicBattleDef.epicFlyColor.green then
			dhName1 = "dh_sszzorange_04.png"
			color1 = cc.c3b(117, 255, 89)
			dhName2 = "sdfa.png"
			color2 = cc.c3b(140, 255, 101)
			dhName3 = "dh_sszzorange_03.png"
			color3 = cc.c3b(64, 203, 16)
			etName = "et_sszzgreen_02.plist"
		elseif buffType == epicBattleDef.epicFlyColor.black then
			dhName1 = "dh_sszzorange_04.png"
			color1 = cc.c3b(0, 0, 0)
			dhName2 = "sdfa.png"
			color2 = cc.c3b(0, 0, 0)
			dhName3 = "dh_sszzorange_03.png"
			color3 = cc.c3b(0, 0, 0)
			etName = "et_sszzblack_02.plist"
		end
		if dhName1 then
			dh1 = display.newSprite("#" .. dhName1)
			if color1 then
				dh1:setColor(color1)
			end
			SoraDMixtureGLONE(dh1)
			dh1:setOpacity(0)
			dh1:setScaleX(-0.805)
			dh1:setScaleY(0.1)
			dh1:addTo(node, 1)
		end
		if dhName2 then
			dh2 = display.newSprite("#" .. dhName2)
			if color2 then
				dh2:setColor(color2)
			end
			SoraDMixtureGLONE(dh2)
			dh2:setOpacity(0)
			dh2:setScaleX(4.115)
			dh2:setScaleY(2.52)
			dh2:addTo(node, 2)
		end
		if dhName3 then
			dh3 = display.newSprite("#" .. dhName3)
			if color3 then
				dh3:setColor(color3)
			end
			SoraDMixtureGLONE(dh3)
			dh3:setOpacity(0)
			dh3:setScaleX(2.865)
			dh3:setScaleY(0.846)
			dh3:addTo(node, 3)
		end
		if etName then
			et = cc.ParticleSystemQuad:create("Particle/" .. etName)
			et:setPosition(0, 0)
			et:setScale(1.6)
			et:stopSystem()
			et:addTo(node, 4)
		end
		function node.act()
			dh2 = nil
			;(nil)[1] = cca.callFunc(function()
				dh1 = nil
				dh1 = nil
				;(nil)[1] = cca.scaleTo(0.06666666666666667, -4.6, 0.48)
				;(nil)[2] = cca.fadeTo(0.06666666666666667, 1)
				;(nil)[3] = cca.fadeTo(0.06666666666666667, 1)
				;(nil)[4] = cca.fadeTo(0.06666666666666667, 1)
				;(nil)[1] = cca.spawn(nil)
				;(nil)[2] = cca.fadeTo(0.08333333333333333, 0)
				;(nil)[3] = cca.fadeTo(0.08333333333333333, 0)
				;(nil)[4] = cca.fadeTo(0.08333333333333333, 0)
				;(nil)[5] = cca.fadeTo(0.08333333333333333, 0)
				;(nil)[6] = cca.fadeTo(0.08333333333333333, 0)
				local seq1 = cca.seq(nil)
				dh1:runAction(seq1)
				dh2 = dh1
				dh1[1] = cca.fadeTo(0.06666666666666667, 0.38)
				dh1[2] = cca.fadeTo(0.03333333333333333, 0.35)
				dh1[3] = cca.fadeTo(0.11666666666666667, 0)
				dh1[4] = cca.fadeTo(0.11666666666666667, 0)
				dh1[5] = cca.fadeTo(0.11666666666666667, 0)
				local seq2 = cca.seq(dh1)
				dh2:runAction(seq2)
				dh1 = dh2
				dh2[1] = cca.fadeTo(0.06666666666666667, 1)
				dh2[2] = cca.fadeTo(0.11666666666666667, 0)
				dh2[3] = cca.fadeTo(0.11666666666666667, 0)
				dh2[4] = cca.fadeTo(0.11666666666666667, 0)
				local seq3 = cca.seq(dh2)
				dh3:runAction(seq3)
				et:resetSystem()
			end)
			;(nil)[2] = cca.delay(0.25)
			;(nil)[3] = cca.callFunc(function()
				node:removeFromParent()
			end)
			;(nil)[4] = cca.callFunc(function()
				node:removeFromParent()
			end)
			local seq = cca.seq(nil)
			node:runAction(seq)
		end
		return node
	end
	local curArea = self:getAreaByPos(epicWarCtrl:getCurStageTroopPos())
	local bPos = data.pos or curArea:convertToWorldSpace(cc.p(0, 0))
	local ePos = self.Image_army:convertToWorldSpace(cc.p(100, 20))
	local parent = display.getRunningScene().panelView
	local flyNode = self:getFlyNode(eType)
	flyNode:setPosition(bPos.x, bPos.y)
	flyNode:addTo(parent, 999)
	epicBattleDef = flyNode
	flyNode[1] = cca.moveTo(0.5, ePos.x, ePos.y)
	flyNode[2] = cca.callFunc(function()
		local flickerNode = getFlickerNode(eType)
		flickerNode:setPosition(100, 20)
		if self and not tolua.isnull(self) and not tolua.isnull(self.Image_army) then
			flickerNode:addTo(self.Image_army)
			flickerNode.act()
		end
		flyNode:removeFromParent()
	end)
	flyNode[3] = cca.callFunc(function()
		local flickerNode = getFlickerNode(eType)
		flickerNode:setPosition(100, 20)
		if self and not tolua.isnull(self) and not tolua.isnull(self.Image_army) then
			flickerNode:addTo(self.Image_army)
			flickerNode.act()
		end
		flyNode:removeFromParent()
	end)
	flyNode[4] = cca.callFunc(function()
		local flickerNode = getFlickerNode(eType)
		flickerNode:setPosition(100, 20)
		if self and not tolua.isnull(self) and not tolua.isnull(self.Image_army) then
			flickerNode:addTo(self.Image_army)
			flickerNode.act()
		end
		flyNode:removeFromParent()
	end)
	local seq = cca.seq(flyNode)
	flyNode:runAction(seq)
end
function epicBattleMapView:getFlyNode(buffType)
	local node = display.newNode()
	local dhName, etName, color
	if buffType == epicBattleDef.epicFlyColor.orange then
		dhName = "dh_sszzblack_02.png"
		etName = "et_sszzorange_01.plist"
	elseif buffType == epicBattleDef.epicFlyColor.green then
		dhName = "dh_sszzblack_03.png"
		etName = "et_sszzgreen_01.plist"
	elseif buffType == epicBattleDef.epicFlyColor.black then
		dhName = "dh_sszzblack_01.png"
		etName = "et_sszzblack_01.plist"
		color = cc.c3b(117, 117, 117)
	end
	if dhName then
		local dh = display.newSprite("#" .. dhName)
		if color then
			dh:setColor(color)
		end
		dh:addTo(node, 1)
	end
	if etName then
		local et = cc.ParticleSystemQuad:create("Particle/" .. etName)
		et:setPosition(0, 0)
		et:setPositionType(cc.POSITION_TYPE_FREE)
		et:addTo(node, 2)
	end
	return node
end
function epicBattleMapView:updateBossInfo(target, data)
	local bossInfo = epicWarCtrl:getBossInfo()
	local boss, bossHead, bossHeadBg
	for k, v in ipairs(bossInfo) do
		if v.areaType == epicBattleDef.epicAreaDef.boss then
			boss = SoraDGetChildByName(self.Node_boss, "Node_boss_" .. k)
		elseif v.areaType == epicBattleDef.epicAreaDef.king then
			boss = SoraDGetChildByName(self.Node_boss, "Node_boss_3")
			if v.status == epicBattleDef.epicBossStatusDef.killed then
				self:updateKingBossGuide(50016)
			elseif v.status == epicBattleDef.epicBossStatusDef.nokill then
				self:updateKingBossGuide(50014)
			end
		end
		local icon_g = SoraDGetChildByName(boss, "icon_g")
		local Image_shadow = SoraDGetChildByName(boss, "Image_shadow")
		Image_shadow:setVisible(false)
		bossHead = SoraDGetChildByName(boss, "bossHead")
		bossHeadBg = SoraDGetChildByName(boss, "Image_quality")
		boss:setColor(cc.c3b(255, 255, 255))
		if v.status == epicBattleDef.epicBossStatusDef.unfind then
			bossHead:ignoreContentAdaptWithSize(true)
			bossHead:loadTexture("icon_challenge_wh.png", ccui.TextureResType.plistType)
			bossHead:setScale(0.7)
			icon_g:setVisible(false)
			Image_shadow:setVisible(false)
		elseif v.status == epicBattleDef.epicBossStatusDef.nokill and v.heroIndex then
			local heroInfo = epicWarltCtrl.getBossHeroID(v.heroIndex)
			local heroHead = epicWarltCtrl.getBossHeroIcon(heroInfo.heroID)
			bossHead:ignoreContentAdaptWithSize(false)
			bossHead:setContentSize(cc.size(80, 80))
			bossHead:setScale(1.0)
			bossHead:loadTexture(heroHead, ccui.TextureResType.plistType)
			bossHeadBg:loadTexture(heroltCtrl.getCubeBg(heroInfo.quality), ccui.TextureResType.plistType)
			icon_g:setVisible(false)
			Image_shadow:setVisible(false)
		elseif v.status == epicBattleDef.epicBossStatusDef.killed and v.heroIndex then
			local heroInfo = epicWarltCtrl.getBossHeroID(v.heroIndex)
			local heroHead = epicWarltCtrl.getBossHeroIcon(heroInfo.heroID)
			bossHead:ignoreContentAdaptWithSize(false)
			bossHead:setContentSize(cc.size(80, 80))
			bossHead:setScale(1.0)
			bossHead:loadTexture(heroHead, ccui.TextureResType.plistType)
			bossHeadBg:loadTexture(heroltCtrl.getCubeBg(heroInfo.quality), ccui.TextureResType.plistType)
			boss:setColor(cc.c3b(120, 120, 120))
			icon_g:setVisible(true)
			Image_shadow:setVisible(true)
		end
	end
end
function epicBattleMapView:updateKingBossGuide(checkStep)
	self.isKilledBoss = epicWarCtrl:isBossKilled()
	if self.isKilledBoss then
		epicWarCtrl = epicWarCtrl
		epicWarCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		epicWarCtrl.step = 50022
		SoraDSendMessage(epicWarCtrl)
		return
	end
	local step = guideCtrl:getStepByGuideModule(gGuideModule.EPIC_WAR_2)
	print("step======", step, checkStep, guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR_2))
	if step and checkStep >= step then
		guideCtrl:updateGuideModule(gGuideModule.EPIC_WAR_2, true)
	end
end
function epicBattleMapView:getAreaByPos(pos)
	local index = epicBattleDef.getAreaIndex(pos)
	local area = SoraDGetChildByName(self.mapView, "area_" .. index)
	return area
end
function epicBattleMapView:initMapAreaData()
	self.areaData = epicWarCtrl:getStageMapData()
	self.Node_instance = SoraDGetChildByName(self.mapView, "Node_instance")
	self.Node_instance:setLocalZOrder(35)
	for k, v in ipairs(self.areaData) do
		local area = SoraDGetChildByName(self.mapView, "area_" .. k)
		local areaInstance = include("epicBattleMapSingle").new()
		areaInstance:initData(v)
		areaInstance:setPosition(area:getPositionX(), area:getPositionY())
		areaInstance:addTo(self.Node_instance)
		self.areaInstanceArray[k] = areaInstance
	end
end
function epicBattleMapView:updateArea(target, data)
	SoraDCloseLoading()
	if data and data.noRefresh then
		return
	end
	local passAreaNum = epicWarCtrl:getRealedAreaCount()
	local maxAreaNum = AREA_BORDER_LEN * AREA_BORDER_LEN
	_ENV = nil
	;(nil).member = passAreaNum
	;(nil).total = maxAreaNum
	self.Text_area:setString(i18n("common_text_155", nil))
	self.isKilledBoss, self.passScore = epicWarCtrl:isBossKilled()
	self.isUnPassArea = epicWarCtrl:isHaveUnFinishArea()
	self.Image_light:setVisible(self.isKilledBoss and not self.isUnPassArea)
	local curStep = guideCtrl:getStepByGuideModule(gGuideModule.EPIC_WAR_2)
	if self.isKilledBoss and not self.isUnPassArea and not guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR_2) and not curStep then
		local panel = SoraDCreatePanel("epicWarWinPopView")
		panel:initAllReceive(self.passScore)
		panel:show()
	end
	self.areaData = epicWarCtrl:getStageMapData()
	for k, v in ipairs(self.areaInstanceArray) do
		v:initData(self.areaData[k])
	end
end
function epicBattleMapView:initMap()
	self.mapView = cc.CSLoader:createNode(getCCSPath("epicBattleMapInfoView"))
	local containerViewSize = self.mapView:getContentSize()
	self.containerView = ccui.Layout:create()
	self.containerView:setContentSize(containerViewSize)
	self.containerView:setSwallowTouches(false)
	self.bgArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, containerViewSize.width, containerViewSize.height))
	self.bgArea:ignoreAnchorPointForPosition(false)
	self.bgArea:setAnchorPoint(cc.p(0.0, 0.0))
	self.containerView:addChild(self.bgArea, 0)
	self.tiledBg = display.newTilesSprite("SinglePicture/tiledmap.png", cc.rect(0, 0, containerViewSize.width, containerViewSize.height))
	self.tiledBg:ignoreAnchorPointForPosition(false)
	self.tiledBg:setAnchorPoint(cc.p(0.0, 0.0))
	self.containerView:addChild(self.tiledBg, 1)
	self.mapView:setScale(1)
	self.mapView:ignoreAnchorPointForPosition(false)
	self.mapView:setAnchorPoint(cc.p(0.5, 0.5))
	self.mapView:setPosition(cc.p(containerViewSize.width / 2, containerViewSize.height / 2))
	self.containerView:addChild(self.mapView, 2)
	local viewSize = self:getContentSize()
	self.viewScrollView = cc.ScrollView:create(viewSize)
	self.viewScrollView:setContainer(self.containerView)
	self.viewScrollView:setMinScale(0.9)
	self.viewScrollView:setMaxScale(1.35)
	self.viewScrollView:setZoomScale(1.0)
	self.viewScrollView:setBounceable(false)
	self.viewScrollView:setInertiaValue(0.35)
	self.viewScrollView:setPosition(cc.p(0, 0))
	self:addChild(self.viewScrollView, 0)
	self.viewScrollView:setContentOffset(cc.p(display.cx - containerViewSize.width / 2, display.cy - containerViewSize.height / 2))
end
function epicBattleMapView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("帮助FAQ===")
		if IsArClient then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.EPIC_WAR)
		else
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.EPIC_WAR)
		end
	end
end
function epicBattleMapView:btnOverClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if guideCtrl:isGuideNotCompleted(gGuideModule.EPIC_WAR_2) then
			SoraDShowMsgTip(i18n("common_text_4442"))
			return
		end
		if self.isKilledBoss then
			if self.isUnPassArea and SoraDIsGameGuide() == nil then
				SoraDShowMsgBox(i18n("epicbattle_text_10"), i18n("common_text_204"), i18n("common_text_185"), function(event)
					if event == MSGBOX_CALLBACK_YES then
						epicWarCtrl:sendReqQuitStage()
						SoraDShowLoading(self)
					end
				end)
			else
				epicWarCtrl:sendReqQuitStage()
				SoraDShowLoading(self)
			end
		else
			SoraDShowMsgBox(i18n("epicbattle_text_11"), i18n("common_text_204"), i18n("common_text_185"), function(event)
				if event == MSGBOX_CALLBACK_YES then
					epicWarCtrl:sendReqQuitStage()
					SoraDShowLoading(self)
				end
			end)
		end
	end
end
function epicBattleMapView:btnDetailClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("epicBattleAwardDetailView"):show()
	end
end
function epicBattleMapView:btnArmyDetailClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("epicBattleArmyInfoView"):show()
	end
end
function epicBattleMapView:closePanel()
	print("删除所有界面=======")
	SoraDRemoveAllPanelFromManager()
end
function epicBattleMapView:onExitPanel()
	print("释放动画=======")
	display.removeAnimationCache("box")
	display.removeAnimationCache("boss")
	display.removeAnimationCache("king")
end
function epicBattleMapView:gameGuide_getTarget(itemName, parameters)
	if itemName == "index" then
		return self.areaInstanceArray[parameters.index].Panel_touch
	else
		return SoraDGetChildByName(self, itemName)
	end
end
return epicBattleMapView
