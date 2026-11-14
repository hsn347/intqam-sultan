local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceDesRead = include("allianceDesRead")
local kingdomMapUtil = include("kingdomMapUtil")
local socket = require("socket")
local AllianceWarListSingle = class("allianceWarListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceWarListSingle")
	end
	return target
end)
function AllianceWarListSingle:ctor()
	self.indexID = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.isFilter = false
	self.timer = nil
	self.haveOwn = false
	self.tableShowData, lordInfoCtrl, self.tableSingleData, lordInfoCtrl, self.ownUid = lordInfoCtrl:getLordInfo().base.uid, lordInfoCtrl:getLordInfo().base.uid, lordInfoCtrl:getLordInfo().base.uid, lordInfoCtrl:getLordInfo().base.uid, lordInfoCtrl:getLordInfo().base.uid
	self.leftPoint = cc.p(0, 0)
	self.rightPoint = cc.p(0, 0)
	self.is_delay = false
	self.delay_time = 0
	self.imgWarnning = nil
	self.imgBg2 = SoraDGetChildByName(self, "Image_bg2")
	self.imgBg2:setFillType(1)
	self.spriteTimeL = SoraDGetChildByName(self, "Sprite_timeL")
	self.spriteTimeR = SoraDGetChildByName(self, "Sprite_timeR")
	self.spriteStateL = SoraDGetChildByName(self, "Sprite_stateL")
	self.spriteStateR = SoraDGetChildByName(self, "Sprite_stateR")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Panel_cut:setSwallowTouches(false)
	self.imgTitleBg = SoraDGetChildByName(self, "Image_title_bg")
	self.imgHeadBg = SoraDGetChildByName(self, "Image_headBg")
	self.labelState = SoraDGetChildByName(self, "Text_state")
	self.layerLeft = SoraDGetChildByName(self, "Panel_left")
	self.layerLeft:setSwallowTouches(false)
	self.imgLeftHead = SoraDGetChildByName(self, "Image_leftHead")
	self.spriteLeftState = SoraDGetChildByName(self, "Sprite_leftState")
	self.labelLeftPos = SoraDGetChildByName(self, "Text_leftPos")
	self.labelLeftName = SoraDGetChildByName(self, "Text_leftName")
	SoraDSetTextWidthHeight(self.labelLeftName, cc.size(180, 40))
	if not SoraDFIsRA() then
		self.labelLeftName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	end
	self.labelLeftPos:setSwallowTouches(false)
	self.labelLeftPos:addTouchEventListener(handler(self, self.onCoordinate))
	self.labelLeftPos:setTouchScaleChangeEnabled(true)
	self.layerRight = SoraDGetChildByName(self, "Panel_right")
	self.layerRight:setSwallowTouches(false)
	self.imgRightHead = SoraDGetChildByName(self, "Image_rightHead")
	self.spriteRightState = SoraDGetChildByName(self, "Sprite_rightState")
	self.labelRightPos = SoraDGetChildByName(self, "Text_rightPos")
	self.labelRightName = SoraDGetChildByName(self, "Text_rightName")
	SoraDSetTextWidthHeight(self.labelRightName, cc.size(180, 40))
	self.labelRightPos:setSwallowTouches(false)
	self.labelRightPos:addTouchEventListener(handler(self, self.onCoordinate))
	self.labelRightPos:setTouchScaleChangeEnabled(true)
	self.imgLeftMember = SoraDGetChildByName(self, "Image_leftMember")
	self.labelLeftMember = SoraDGetChildByName(self, "Text_leftMember")
	self.spriteLeftOwn = SoraDGetChildByName(self, "Sprite_leftOwn")
	self.imgLeftMember:setVisible(false)
	self.imgRightMember = SoraDGetChildByName(self, "Image_rightMember")
	self.spriteRightOwn = SoraDGetChildByName(self, "Sprite_rightOwn")
	self.labelRightMember = SoraDGetChildByName(self, "Text_rightMember")
	self.imgRightMember:setVisible(false)
	self.layerRight:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.layerLeft:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function AllianceWarListSingle:updateData(indexID, warMainData, isFilter)
	if self:needRefresh() then
		self:dataSort()
	end
end
function AllianceWarListSingle:initData(indexID, warMainData, isFilter)
	self.indexID = indexID
	self.isFilter = isFilter
	self:dataSort()
	self:showQueue()
end
function AllianceWarListSingle:initView()
	local targetData = self:getShowTarget()
	local fromAid = self.tableShowData:getAid()
	local selfAid = self.queueRoot:getOwnTeamID()
	local toAid = kingdomMapUtil.getTargetAid(targetData, fromAid, selfAid)
	if fromAid == toAid then
		self.labelState:setColor(cc.c3b(50, 180, 0))
		self.imgTitleBg:setColor(cc.c3b(50, 180, 0))
		self.imgHeadBg:setColor(cc.c3b(50, 180, 0))
		self:showLeft(targetData, self.tableShowData.to, gAWarViewMemberType.DEFENDER)
		self:showRight(self.tableShowData.from, self.tableShowData.from, gAWarViewMemberType.HELPER)
	elseif fromAid == selfAid then
		self.labelState:setColor(cc.c3b(216, 8, 8))
		self.imgTitleBg:setColor(cc.c3b(216, 8, 8))
		self.imgHeadBg:setColor(cc.c3b(216, 8, 8))
		self:showLeft(targetData, self.tableShowData.to, gAWarViewMemberType.DEFENDER)
		self:showRight(self.tableShowData.from, self.tableShowData.from, gAWarViewMemberType.ATTACKER)
	elseif toAid == selfAid then
		self.labelState:setColor(cc.c3b(55, 180, 190))
		self.imgTitleBg:setColor(cc.c3b(55, 180, 190))
		self.imgHeadBg:setColor(cc.c3b(55, 180, 190))
		self:showLeft(self.tableShowData.from, self.tableShowData.from, gAWarViewMemberType.ATTACKER)
		self:showRight(targetData, self.tableShowData.to, gAWarViewMemberType.DEFENDER)
	else
		dump(self.tableShowData, "AllianceWarListSingle 数据不全", 10)
	end
	local isBlack = self.queueRoot:isBlock(self.tableShowData)
	self:showBlackWarnning(isBlack)
	self:updateFilter()
end
function AllianceWarListSingle:dataSort()
	self.tableSingleData = self.queueRoot:getSortWarHallQueues(self.indexID)
	local showData = self.tableSingleData and self.tableSingleData[1]
	if not showData or not next(showData) then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		return
	end
	self.tableShowData = showData
	self.haveOwn = false
	if self.ownUid == showData.from.uid then
		self.haveOwn = true
	end
	self.is_delay = false
	local curTime = socket.gettime()
	self.preClockTime = curTime
	self:initView()
end
function AllianceWarListSingle:showBlackWarnning(show)
	if show then
		if self.imgWarnning == nil then
			self.imgWarnning = ccui.ImageView:create("frame_sheer_red_01.png", ccui.TextureResType.plistType)
			self.imgWarnning:ignoreContentAdaptWithSize(false)
			self.imgWarnning:setAnchorPoint(cc.p(0.5, 0.5))
			self.imgWarnning:setPosition(cc.p(320, 127))
			self.imgWarnning:setContentSize(cc.size(640, 217))
			self.imgWarnning:addTo(self.layerTouch, 1)
		end
		local actionTintTo1 = cca.tintBy(1, -1, -1, -1)
		local actionTintTo2 = cca.tintBy(1, 0, 0, 0)
		local actionDelay = cca.delay(0.5)
		local actionTinBack = cca.tintBy(1, 1, 1, 1)
		_UPVALUE5_ = 1
		;(1)[1] = actionTintTo1
		;(1)[2] = actionTintTo2
		;(1)[3] = actionDelay
		;(1)[4] = actionTinBack
		;(1)[5] = actionTintTo2
		local actionRepeat = cca.repeatForever(cca.seq(1))
		self.imgWarnning:setVisible(true)
		self.imgWarnning:stopAllActions()
		self.imgWarnning:runAction(actionRepeat)
	elseif self.imgWarnning then
		self.imgWarnning:setVisible(false)
		self.imgWarnning:stopAllActions()
	end
end
function AllianceWarListSingle:showQueue()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function AllianceWarListSingle:isTabelFull(data)
	local isFull = true
	_UPVALUE4_ = nil
	;(nil)[1] = "x"
	;(nil)[2] = "y"
	;(nil)[3] = "headid"
	local (nil)[4], tableKey = "name", nil
	for _, v in ipairs(tableKey) do
		if data[v] == nil then
			isFull = false
			dump(data, "isTabelFull")
		end
	end
	return isFull
end
function AllianceWarListSingle:openTimeUp(dt)
	local leftTime = self.tableShowData:getStatusRemainTime()
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.labelState:setString(i18n("common_text_295", nil))
	if leftTime <= 0 then
		self.labelState:setString(i18n("Battlefield_queue_text_006"))
	end
	if self.is_delay then
		self.delay_time = self.delay_time - dt
		if 0 >= self.delay_time then
			self.is_delay = false
			self:dataSort()
		end
	end
end
function AllianceWarListSingle:showPVE(memberData, attackType)
	local headImg, nameStr, memberCount
	local objType = memberData.objType
	if objType == gMapObjTypeDef.mapObjTypeRelics then
		nameStr = i18n("common_text_1222")
		headImg = "roman_full.png"
	elseif objType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		_ENV = nil
		;(nil).abbr = memberData.allianceAbb
		;(nil).name = allianceDesRead.getBuildName(memberData.objId)
		nameStr = i18n("common_text_186", nil)
		if memberData.objId == gAllianceBuilding.FLAG then
			headImg = allianceDesRead.getFlagIcon(memberData.allianceFlag)
		else
			headImg = allianceDesRead.getBuildIcon(memberData.objId)
		end
		memberCount = memberData.helpCount
	elseif objType == gMapObjTypeDef.mapObjTypeRemainsWar then
		nameStr = i18n("remains_text_157")
		headImg = "myzh_full.png"
	elseif objType == gMapObjTypeDef.mapTypeRadianceWarPalace or objType == gMapObjTypeDef.mapTypeRadianceWarGate or objType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
		local radianceWarRead = include("radianceWarRead")
		nameStr = radianceWarRead.getBuildName(objType, memberData.objId)
		headImg = radianceWarRead.getBuildIcon(objType)
	elseif objType == gMapObjTypeDef.mapObjNewTrialCity then
		if attackType ~= gAWarViewMemberType.DEFENDER then
			nameStr = i18n("devilvalley_text_20")
		else
			local member = self.tableShowData:getTo()
			local subMapType = member.subMapType
			if subMapType == _G.gMapNewTrialBuildType.subMapTypeDVWCastle then
				nameStr = i18n("devilvalley_text_22")
			else
				nameStr = i18n("devilvalley_text_20")
			end
		end
		headImg = "qlzjt_full.png"
	elseif objType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
		if memberData.objId == nil then
			nameStr = i18n("common_text_3387")
			headImg = "ygzh_full.png"
		else
			local buildType = memberData.subMapType
			nameStr = worldMapDefine.getPyramidbuildingName(buildType, memberData.objId)
			headImg = worldMapDefine.getPyramidbuildingImage(buildType)
		end
		if memberData.allianceAbb then
			_ENV = buildType
			buildType.abbr = memberData.allianceAbb
			buildType.name = nameStr
			nameStr = i18n("common_text_186", buildType)
		end
	else
		return false
	end
	return true, nameStr, headImg, memberCount
end
function AllianceWarListSingle:showLeft(memberData, memberPosData, attackType)
	local spriteState = "icon_alliancewar_defender.png"
	local showMemberCount = #self.tableSingleData
	if attackType == gAWarViewMemberType.ATTACKER then
		spriteState = "icon_alliancewar_attacker.png"
	elseif attackType == gAWarViewMemberType.HELPER then
		spriteState = "icon_king_support.png"
	else
		showMemberCount = false
	end
	if showMemberCount then
		self.imgLeftMember:setVisible(true)
		self.labelLeftMember:setString(tostring(showMemberCount))
		self.spriteLeftOwn:setVisible(self.haveOwn)
	else
		self.imgLeftMember:setVisible(false)
	end
	self.spriteLeftState:setSpriteFrame(spriteState)
	local isPVE, nameStr, headImg, memberCount = self:showPVE(memberData, attackType)
	if isPVE then
		self.imgLeftHead:loadTexture(headImg, ccui.TextureResType.plistType)
		self.labelLeftName:setString(nameStr)
		if memberCount then
			self.imgLeftMember:setVisible(true)
			self.labelLeftMember:setString(tostring(memberCount))
			self.spriteLeftOwn:setVisible(false)
		end
	elseif self:isTabelFull(memberData) then
		SoraDGetHeadFromManager(self.imgLeftHead, memberData.headid, memberData.avatar)
		if memberData.allianceAbb then
			_ENV = tostring(memberCount)
			tostring(memberCount).abbr = memberData.allianceAbb
			tostring(memberCount).name = memberData.name
			self.labelLeftName:setString(i18n("common_text_186", tostring(memberCount)))
		else
			self.labelLeftName:setString(memberData.name)
		end
	end
	if memberPosData.x and memberPosData.y then
		self.labelLeftPos:setTouchEnabled(true)
		self.labelLeftPos:setString(tostring(memberPosData.x) .. "," .. tostring(memberPosData.y))
		self.leftPoint = cc.p(memberPosData.x, memberPosData.y)
	else
		self.labelLeftPos:setTouchEnabled(false)
	end
end
function AllianceWarListSingle:showRight(memberData, memberPosData, attackType)
	local spriteState = "icon_alliancewar_defender.png"
	local showMemberCount = #self.tableSingleData
	if attackType == gAWarViewMemberType.ATTACKER then
		spriteState = "icon_alliancewar_attacker.png"
	elseif attackType == gAWarViewMemberType.HELPER then
		spriteState = "icon_king_support.png"
	else
		showMemberCount = false
	end
	if showMemberCount then
		self.imgRightMember:setVisible(true)
		self.labelRightMember:setString(tostring(showMemberCount))
		self.spriteRightOwn:setVisible(self.haveOwn)
	else
		self.imgRightMember:setVisible(false)
	end
	self.spriteRightState:setSpriteFrame(spriteState)
	local isPVE, nameStr, headImg, memberCount = self:showPVE(memberData, attackType)
	if isPVE then
		self.imgRightHead:loadTexture(headImg, ccui.TextureResType.plistType)
		self.labelRightName:setString(nameStr)
		if memberCount then
			self.imgRightMember:setVisible(true)
			self.labelRightMember:setString(tostring(memberCount))
			self.spriteRightOwn:setVisible(false)
		end
	elseif self:isTabelFull(memberData) then
		SoraDGetHeadFromManager(self.imgRightHead, memberData.headid, memberData.avatar)
		if memberData.allianceAbb then
			_ENV = tostring(memberCount)
			tostring(memberCount).abbr = memberData.allianceAbb
			tostring(memberCount).name = memberData.name
			self.labelRightName:setString(i18n("common_text_186", tostring(memberCount)))
		else
			self.labelRightName:setString(memberData.name)
		end
	end
	if memberPosData.x and memberPosData.y then
		self.labelRightPos:setTouchEnabled(true)
		self.labelRightPos:setString(tostring(memberPosData.x) .. "," .. tostring(memberPosData.y))
		self.rightPoint = cc.p(memberPosData.x, memberPosData.y)
	else
		self.labelRightPos:setTouchEnabled(false)
	end
end
function AllianceWarListSingle:setScroll(scroll, queueRoot)
	self.scroll = scroll
	self.queueRoot = queueRoot
end
function AllianceWarListSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self:openInfoPanel()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function AllianceWarListSingle:openInfoPanel()
	local panel = SoraDCreatePanel("allianceWarListInfoView")
	if panel:initData(self.indexID, self.tableSingleData, self.queueRoot) then
		panel:show()
	end
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function AllianceWarListSingle:updateFilter()
	if self.isFilter then
		self.layerTouch:setColor(colorGray)
	else
		self.layerTouch:setColor(colorNormal)
	end
end
function AllianceWarListSingle:onCoordinate(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local pos
		if target == self.labelRightPos then
			pos = self.rightPoint
		else
			pos = self.leftPoint
		end
		local mapId
		if self.tableShowData and self.tableShowData.getMapID then
			mapId = self.tableShowData:getMapID()
		end
		if SoraDGotoWorldMapPoint(pos, true, mapId) then
			SoraDRemoveAllPanelFromManager()
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function AllianceWarListSingle:getShowTarget()
	if self.tableShowData:isTargetCapture() then
		local queuesFix = self.queueRoot:getWorkingCaptainQueue(self.tableShowData)
		if queuesFix then
			return queuesFix:getFrom()
		end
	end
	return self.tableShowData.to
end
local MIN_TIME = 2.0
function AllianceWarListSingle:needRefresh()
	if self.is_delay then
		return false
	end
	local curTime = socket.gettime()
	if self.preClockTime then
		local time = curTime - self.preClockTime
		if time < MIN_TIME then
			self.is_delay = true
			self.delay_time = MIN_TIME
			return false
		end
	end
	self.preClockTime = curTime
	return true
end
function AllianceWarListSingle:resetData()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.tableShowData, _ENV, self.tableSingleData, _ENV = SoraDManagerRemoveTimer, SoraDManagerRemoveTimer, SoraDManagerRemoveTimer, SoraDManagerRemoveTimer
end
return AllianceWarListSingle
