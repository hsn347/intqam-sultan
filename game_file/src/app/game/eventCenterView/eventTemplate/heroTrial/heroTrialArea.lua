local ActionLayer = include("ActionLayer")
local heroTrialltCtrl = include("heroTrialltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local heroTrialCtrl = gametop.playertop_:getModule("heroTrialCtrl")
local htMapMgr = include("htMapMgr")
local htBattleMgr = include("htBattleMgr")
local heroTrialCommon = include("heroTrialCommon")
local heroTrialArea = class("heroTrialArea", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroTrialArea")
	end
	return target
end)
function heroTrialArea:ctor()
	self.minAreaId = 1
	self.maxAreaId = 7
	self.curAreaId = 1
	self.showIndex = 4
	self.curMapPage = 1
	self.pointList, _ENV, self.mapList, _ENV, self.classCount = nil, nil, nil, nil, 5
	self.isClass = 0
	local title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.pageLeft = SoraDGetChildByName(self, "pageLeft")
	self.pageRight = SoraDGetChildByName(self, "pageRight")
	self.pageBg = SoraDGetChildByName(self, "pageBg")
	self.mapBg = SoraDGetChildByName(self, "mapBg")
	self.btnClass0 = SoraDGetChildByName(self, "Button_class_0")
	self.btnClass1 = SoraDGetChildByName(self, "Button_class_1")
	self.btnClass0:setPressedActionEnabled(true)
	self.btnClass1:setPressedActionEnabled(true)
	self.btnClass0:setLocalZOrder(2)
	self.btnClass1:setLocalZOrder(1)
	self.btnClass1:setColor(cc.c3b(75, 75, 75))
	self.btnClass0:setTouchEnabled(false)
	self.labelClass0 = SoraDGetChildByName(self, "Text_class_0")
	self.labelClass1 = SoraDGetChildByName(self, "Text_class_1")
	self.labelClass0:setString(i18n("common_text_2697"))
	self.labelClass1:setString(i18n("common_text_2698"))
	self.mapContainer = SoraDGetChildByName(self, "mapContainer")
	self.mapContainer:addEventListener(handler(self, self.scrollEventCallBack))
	self.flag = cc.uiloader:load(getCCSPath("heroTrialFlag"))
	self.flagSprite = SoraDGetChildByName(self.flag, "flag")
	self.flag:setVisible(false)
	self.flagSprite:setTouchEnabled(true)
	self.flagSprite:addTouchEventListener(handler(self, self.onMap))
	self.flagSprite:setSwallowTouches(true)
	self.mapBg:addChild(self.flag, 99)
	self.newEffectPos = cc.p(0, 0)
	self.isShowNewEffect = false
	self.newEffect = self:createNewEffect()
	self:addChild(self.newEffect, 99)
	self.pageLeft:setPressedActionEnabled(true)
	self.pageRight:setPressedActionEnabled(true)
	self.pageLeft:addTouchEventListener(handler(self, self.onPageLeft))
	self.pageRight:addTouchEventListener(handler(self, self.onPageRight))
	self.btnClass0:addTouchEventListener(handler(self, self.onClassChange))
	self.btnClass1:addTouchEventListener(handler(self, self.onClassChange))
	title:setTitle(i18n("common_text_1697"))
	self.layer = SoraDGetChildByName(self, "panel")
	self.layer = ActionLayer.new(self.layer)
	self.layer:init(ActionLayer.Style.cardMove, 7, self.classCount, handler(self, self.createCell), handler(self, self.updateCell))
	self.layer:bindDataToShow(self.showIndex)
	self.layer:reverseMoveDirection()
	self.layer:updateNode(0)
	self.layer:setCellBounceThreshold(0.5)
	self.layer:setCellBounceRatio(1)
	self.layer:setCellBounceCb(function()
		local curAreaId = self.layer.actionsList[self.showIndex].cell.idx + self.classCount * self.isClass
		self:setCurArea(curAreaId)
	end)
	self.layer:addTouchEventListener(handler(self, self.onArea))
	self.decorateList, _ENV = self.layer.addTouchEventListener, self.layer.addTouchEventListener
	for i = 1, 3 do
		self.decorateList[i] = SoraDGetChildByName(self, "decorate" .. i)
	end
	self:turnToDefault()
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_UPDATE_AREA", self.updateArea)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_END_BATTLE", self.updateArea)
end
function heroTrialArea:showCurMap()
	if htBattleMgr.curTrialMap then
		local mapId = htBattleMgr.curTrialMap:getMapID()
		local mapView = SoraDCreatePanel("heroTrialMapView")
		mapView:initData(mapId)
		mapView:show()
	end
end
function heroTrialArea:turnToDefault()
	local defaultArea, defaultPage, defaultMapId
	if htBattleMgr.curTrialMap then
		defaultMapId = tonumber(htBattleMgr.curTrialMap:getMapID())
	else
		defaultMapId = tonumber(htMapMgr.getLastUnlockMap())
	end
	defaultArea = math.floor((defaultMapId - 401) / 20) + 1
	defaultPage = 1
	if defaultMapId % 20 > 10 or defaultMapId % 20 == 0 then
		defaultPage = 2
	end
	if defaultArea > self.classCount then
		self:onClassChange(self.btnClass1, ccui.TouchEventType.ended, true)
	end
	self:setCurArea(defaultArea, true)
	self:turnPage(defaultPage, true)
end
function heroTrialArea:turnPage(pageNum, immediately)
	self.curMapPage = util.clampf(pageNum, 1, 2)
	self.pageRight:setVisible(true)
	self.pageLeft:setVisible(true)
	if pageNum == 1 then
		self.pageLeft:setVisible(false)
		if immediately then
			self.mapContainer:scrollToLeft(0.05, true)
		else
			self.mapContainer:scrollToLeft(0.5, true)
		end
	else
		self.pageRight:setVisible(false)
		if immediately then
			self.mapContainer:scrollToRight(0.05, true)
		else
			self.mapContainer:scrollToRight(0.5, true)
		end
	end
end
function heroTrialArea:updateArea()
	self:initMapList()
	self.layer:refreshData()
end
function heroTrialArea:initMapList()
	self.flag:setVisible(false)
	self.flagSprite:setVisible(false)
	_UPVALUE3_, _UPVALUE10_, self.isShowNewEffect = self.flagSprite, self.flagSprite.setVisible, false
	_UPVALUE3_, self.flagSprite[1] = 1, 1
	_UPVALUE3_, self.flagSprite[2] = 1, 3
	_UPVALUE3_, self.flagSprite[3] = 1, 2
	_UPVALUE3_, (1)[1] = 1, 1
	_UPVALUE3_, (1)[2] = 1, 8
	_UPVALUE3_, (1)[3] = 1, 4
	_UPVALUE3_, (1)[1] = 1, 1
	_UPVALUE3_, (1)[2] = 1, 11
	_UPVALUE3_, (1)[3] = 1, 10
	_UPVALUE3_, (1)[1] = 1, 1
	_UPVALUE3_, (1)[2] = 1, 6
	_UPVALUE3_, (1)[3] = 1, 9
	_UPVALUE3_, (1)[1] = 1, 1
	_UPVALUE3_, (1)[2] = 1, 5
	_UPVALUE3_, (1)[3] = 1, 7
	_UPVALUE3_, (1)[1] = 1, 1
	_UPVALUE3_, (1)[2] = 1, 3
	_UPVALUE3_, (1)[3] = 1, 2
	_UPVALUE3_, (1)[1] = 1, 1
	_UPVALUE3_, (1)[2] = 1, 8
	_UPVALUE3_, (1)[3] = 1, 4
	_UPVALUE3_, (1)[1] = 1, 1
	_UPVALUE3_, (1)[2] = 1, 11
	_UPVALUE3_, (1)[3] = 1, 10
	_UPVALUE3_, (1)[1] = 1, 1
	_UPVALUE3_, (1)[2] = 1, 6
	_UPVALUE3_, (1)[3] = 1, 9
	;(1)[1] = 1
	;(1)[2] = 5
	;(1)[3] = 7
	_UPVALUE10_, self.flagSprite.setVisible[1] = self.flagSprite, self.flagSprite
	_UPVALUE10_, self.flagSprite.setVisible[2] = self.flagSprite, 1
	_UPVALUE10_, self.flagSprite.setVisible[3] = self.flagSprite, 1
	_UPVALUE10_, self.flagSprite.setVisible[4] = self.flagSprite, 1
	_UPVALUE10_, self.flagSprite.setVisible[5] = self.flagSprite, 1
	_UPVALUE10_, self.flagSprite.setVisible[6] = self.flagSprite, 1
	_UPVALUE10_, self.flagSprite.setVisible[7] = self.flagSprite, 1
	_UPVALUE10_, self.flagSprite.setVisible[8] = self.flagSprite, 1
	_UPVALUE10_, self.flagSprite.setVisible[9] = self.flagSprite, 1
	local _UPVALUE10_, self.flagSprite.setVisible[10], areaDecorates = self.flagSprite, 1, self.flagSprite.setVisible
	self.flagSprite[1] = "icon_herotrial_flag_04.png"
	self.flagSprite[2] = "icon_herotrial_flag_03.png"
	self.flagSprite[3] = "icon_herotrial_flag_05.png"
	self.flagSprite[4] = "icon_herotrial_flag_01.png"
	self.flagSprite[5] = "icon_herotrial_flag_02.png"
	self.flagSprite[6] = "icon_hero_trial_orange.png"
	self.flagSprite[7] = "icon_hero_trial_green.png"
	self.flagSprite[8] = "icon_hero_trial_deepBlue.png"
	self.flagSprite[9] = "icon_hero_trial_red.png"
	local self.flagSprite[10], flagPath = "icon_hero_trial_blue.png", self.flagSprite
	for i = 1, 3 do
		local decorateName = string.format("frame_herotrial_lace_%02d.png", areaDecorates[self.curAreaId][i])
		self.decorateList[i]:loadTexture(decorateName, ccui.TextureResType.plistType)
	end
	local roadInfo = require("app." .. LocalTblPath .. ".config_client.heroTrialRoadInfo")
	local flagInfo = require("app." .. LocalTblPath .. ".config_client.heroTrialFlagInfo")
	for i, v in ipairs(self.pointList) do
		v:setVisible(false)
	end
	for i, v in ipairs(roadInfo[self.curAreaId]) do
		if not self.pointList[i] then
			self.pointList[i] = display.newSprite("#frame_herotrial_point_1.png")
			self.mapBg:addChild(self.pointList[i], 1)
		end
		self.pointList[i]:setPosition(v.pos)
		self.pointList[i]:setRotation(v.angle)
		self.pointList[i]:setVisible(true)
	end
	for i, v in ipairs(flagInfo[self.curAreaId]) do
		if not self.mapList[i] then
			self.mapList[i] = display.newSprite("#icon_herotrial_flag_01.png")
			self.mapBg:addChild(self.mapList[i], 2)
		end
		self.mapList[i]:setPosition(v.pos)
	end
	local latestMapId = tonumber(htMapMgr.getLastUnlockMap())
	for i, v in ipairs(self.mapList) do
		v.mapId = self.curMapList[i]
		v:setVisible(true)
		util.delTouch(v)
		if latestMapId == v.mapId then
			local x, y = v:getPosition()
			self.newEffectPos = cc.p(x - 10, y + 10)
			local pos = util.switchSpacePos(self, self.mapBg, self.newEffectPos)
			self.newEffect:setPosition(pos)
			self.isShowNewEffect = true
		end
		local spriteName = flagPath[self.curAreaId]
		v:setSpriteFrame(spriteName)
		if not htMapMgr.whetherMapUnlock(v.mapId) then
			SoraDCreateGraySprite(v)
		else
			SoraDNormalSprite(v)
			v:setTouchEnabled(true)
			v:addTouchEventListener(handler(self, self.onMap))
			v:setSwallowTouches(true)
			if heroTrialCommon.isTrialStarted(v.mapId) then
				v:setVisible(false)
				self.flagSprite.mapId = v.mapId
				self.flagSprite:setSpriteFrame(spriteName)
				self.flagSprite:setVisible(true)
				self.flag:setVisible(true)
				self.flag:setPosition(cc.p(v:getPosition()))
			end
		end
		local passBg = v:getChildByName("passBg")
		local gate = v.mapId % 100
		if gate == 0 then
			gate = 100
		end
		if not passBg then
			passBg = display.newSprite("#frame_round_15.png")
			passBg:setName("passBg")
			passBg:addTo(v, 9)
			local labPass = ccui.Text:create(gate, "", 18)
			labPass:setName("labPass")
			labPass:setColor(cc.c3b(255, 255, 223))
			labPass:setPosition(cc.p(20, 20))
			labPass:addTo(passBg)
		else
			passBg:getChildByName("labPass"):setString(gate)
		end
		if 6 > self.curAreaId then
			passBg:setPosition(cc.p(v:getContentSize().width / 2, 120))
		else
			passBg:setPosition(cc.p(v:getContentSize().width / 2 - 7, 114))
		end
	end
	if latestMapId == heroTrialCommon:getLastMapId() then
		self.isShowNewEffect = false
	end
	self.newEffect:setVisible(self.isShowNewEffect)
end
function heroTrialArea:isAreaUnlock(areaId)
	local lastUnlockMap = htMapMgr.getLastUnlockMap()
	local unlockArea = lastUnlockMap and math.ceil((tonumber(lastUnlockMap) - 400) / 20) or 0
	return areaId <= unlockArea
end
function heroTrialArea:createCell()
	local cell = display.newSprite("#frame_herotrial_paper_01.png")
	local gateBg = display.newSprite("#title_baozang.png")
	gateBg:setName("gateBg")
	gateBg:setVisible(false)
	gateBg:setPosition(cc.p(cell:getContentSize().width / 2, 100))
	gateBg:setScale(0.7)
	gateBg:addTo(cell)
	local labGate = ccui.Text:create("", "", 18)
	labGate:setName("labGate")
	labGate:setColor(cc.c3b(255, 255, 255))
	labGate:setPosition(cc.p(gateBg:getContentSize().width / 2, gateBg:getContentSize().height / 2))
	labGate:addTo(gateBg)
	return cell
end
function heroTrialArea:updateCell(cell, index)
	local _index = index + self.isClass * 5
	_UPVALUE10_ = nil
	;(nil)[1] = "frame_herotrial_paper_11.png"
	;(nil)[2] = "frame_herotrial_paper_09.png"
	;(nil)[3] = "frame_herotrial_paper_07.png"
	;(nil)[4] = "frame_herotrial_paper_01.png"
	;(nil)[5] = "frame_herotrial_paper_05.png"
	;(nil)[6] = "frame_herotrial_paper_11.png"
	;(nil)[7] = "frame_herotrial_paper_09.png"
	;(nil)[8] = "frame_herotrial_paper_07.png"
	;(nil)[9] = "frame_herotrial_paper_01.png"
	local (nil)[10], paperList = "frame_herotrial_paper_05.png", nil
	cell:setSpriteFrame(paperList[_index])
	local gateBg = cell:getChildByName("gateBg")
	gateBg:setVisible(true)
	_ENV = "frame_herotrial_paper_11.png"
	;("frame_herotrial_paper_11.png").num = index
	gateBg:getChildByName("labGate"):setString(i18n("common_text_3162", "frame_herotrial_paper_11.png"))
	if self:isAreaUnlock(_index) then
		SoraDNormalSprite(cell)
	else
		SoraDCreateGraySprite(cell)
	end
end
function heroTrialArea:onMap(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mapView = SoraDCreatePanel("heroTrialMapView")
		mapView:initData(sender.mapId)
		mapView:show()
	end
end
function heroTrialArea:setCurArea(areaId, isTurnToDefault)
	if areaId < self.isClass * self.classCount then
		areaId = areaId + self.isClass * self.classCount
	end
	if areaId > self.maxAreaId then
		SoraDShowMsgTip(i18n("common_text_2695"))
		areaId = self.maxAreaId
	end
	self.curAreaId = util.clampf(areaId, self.minAreaId, self.maxAreaId)
	self.curMapList = heroTrialltCtrl.getMapListOfArea(self.curAreaId)
	self.layer:scrollToIndex(self.curAreaId - self.isClass * 5, self.showIndex)
	if not isTurnToDefault then
		self:turnPage(1)
	end
	self:initMapList()
end
function heroTrialArea:onArea(sender, type)
	if type == ccui.TouchEventType.began then
		self.isMoved = false
	elseif type == ccui.TouchEventType.moved then
		local beganPos = sender:getTouchBeganPosition()
		local movePos = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(beganPos, movePos)
		if distance > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.isMoved and self.layer:isActionFinish() then
			SoraDPlaySound()
			local endPos = sender:getTouchEndPosition()
			local showCell = self.layer.actionsList[self.showIndex].cell
			if not util.hitTest(showCell, endPos) then
				if endPos.x > showCell:getPositionX() then
					self:setCurArea(self.curAreaId + 1)
				elseif endPos.x < showCell:getPositionX() then
					self:setCurArea(self.curAreaId - 1)
				end
			end
		end
	end
end
function heroTrialArea:onPageLeft(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:turnPage(1)
	end
end
function heroTrialArea:onPageRight(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:turnPage(2)
	end
end
function heroTrialArea:onClassChange(sender, type, dontJump)
	sender:setLocalZOrder(3)
	sender:setColor(cc.c3b(255, 255, 255))
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if sender == self.btnClass0 then
			self.isClass = 0
			self.btnClass0:setTouchEnabled(false)
			self.btnClass1:setTouchEnabled(true)
			self.btnClass1:setColor(cc.c3b(75, 75, 75))
			self.btnClass0:runAction(cc.EaseBounceOut:create(cca.moveTo(0.5, 275, 270)))
			self.btnClass1:runAction(cc.EaseBounceOut:create(cca.moveTo(0.5, 290, 154)))
		elseif htMapMgr.whetherMapUnlock(501) then
			self.isClass = 1
			self.btnClass0:setTouchEnabled(true)
			self.btnClass0:setColor(cc.c3b(75, 75, 75))
			self.btnClass1:setTouchEnabled(false)
			self.btnClass0:runAction(cc.EaseBounceOut:create(cca.moveTo(0.5, 290, 270)))
			self.btnClass1:runAction(cc.EaseBounceOut:create(cca.moveTo(0.5, 275, 154)))
		else
			sender:setLocalZOrder(1)
			sender:setColor(cc.c3b(75, 75, 75))
			SoraDShowMsgTip(i18n("common_text_2696"), "#icon_hero_trial_hard.png")
			return
		end
		sender:setLocalZOrder(2)
		sender:setColor(cc.c3b(255, 255, 255))
		if dontJump == nil then
			self:setCurArea(1)
		end
		self.layer:refreshData()
	elseif type == ccui.TouchEventType.canceled then
		sender:setLocalZOrder(1)
		sender:setColor(cc.c3b(75, 75, 75))
	end
end
function heroTrialArea:createNewEffect()
	local node = cc.Node:create()
	local bg = display.newSprite("#icon_herotrial_new.png")
	_ENV = nil
	_ENV, (nil).plist = nil, "Particle/et_new_01.plist"
	;(nil).x = 0
	_ENV, (nil).pos, (nil).y = nil, nil, -15
	;(nil).x = 0.82
	;(nil).scale, (nil).y = nil, 0.82
	local particle1 = util.createParticle(nil)
	_ENV = nil
	_ENV, (nil).plist = nil, "Particle/et_new_02.plist"
	;(nil).x = 0
	_ENV, (nil).pos, (nil).y = nil, nil, -6
	;(nil).x = 1
	;(nil).scale, (nil).y = nil, 1
	local particle2 = util.createParticle(nil)
	node:addChild(bg)
	node:addChild(particle1)
	node:addChild(particle2)
	return node
end
function heroTrialArea:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved and self.isShowNewEffect then
		local pos = util.switchSpacePos(self, self.mapBg, self.newEffectPos)
		local containerPos = util.switchSpacePos(self, self.mapContainer:getParent(), cc.p(self.mapContainer:getPosition()))
		local containerSize = self.mapContainer:getContentSize()
		if pos.x <= containerPos.x or pos.x >= containerPos.x + containerSize.width then
			self.newEffect:setVisible(false)
		else
			self.newEffect:setVisible(true)
		end
		self.newEffect:setPosition(pos)
	end
end
function heroTrialArea:gameGuide_getTarget(itemName, parameters)
	if itemName == "challenge" then
		local single
		local latestMapId = tonumber(htMapMgr.getLastUnlockMap())
		for i, v in ipairs(self.mapList) do
			if v.mapId == latestMapId then
				single = v
				break
			end
		end
		return single
	end
	return SoraDGetChildByName(self, itemName)
end
return heroTrialArea
