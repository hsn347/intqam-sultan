local baseComponent = require("fgui.base.baseComponent")
local Com_WHV_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWarHall/Com_WHV_single", Com_WHV_single)
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceDesRead = include("allianceDesRead")
local kingdomMapUtil = include("kingdomMapUtil")
local socket = require("socket")
function Com_WHV_single:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
	self.indexID = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.isFilter = false
	self.timer = nil
	self.haveOwn = false
	self.tableShowData, _ENV, self.tableSingleData, _ENV, self.ownUid = lordInfoCtrl:getLordInfo().base.uid, lordInfoCtrl:getLordInfo().base.uid, lordInfoCtrl:getLordInfo().base.uid, lordInfoCtrl:getLordInfo().base.uid, lordInfoCtrl:getLordInfo().base.uid
	self.is_delay = false
	self.delay_time = 0
	self.fields.imgWarnning = nil
	self.fields.btnRightPos:addEventListener(fgui.UIEventType.Click, handler(self, self.onCoordinate))
	self.fields.btnLeftPos:addEventListener(fgui.UIEventType.Click, handler(self, self.onCoordinate))
	self.fields.touch_panel:addEventListener(fgui.UIEventType.Click, handler(self, self.btnClickCallBack))
end
function Com_WHV_single:onShow()
	print("Com_WHV_single:onHide")
	if self.timer then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
end
function Com_WHV_single:onHide()
	print("Com_WHV_single:onHide")
end
function Com_WHV_single:updateData(indexID, warMainData, isFilter)
	if self:needRefresh() then
		self:dataSort()
	end
end
function Com_WHV_single:initData(indexID, warMainData, isFilter)
	self.indexID = indexID
	self.isFilter = isFilter
	if self:dataSort() then
		self:showQueue()
	end
end
function Com_WHV_single:initView()
	local targetData = self:getShowTarget()
	local fromAid = self.tableShowData:getAid()
	local selfAid = self.queueRoot:getOwnTeamID()
	local toAid = kingdomMapUtil.getTargetAid(targetData, fromAid, selfAid)
	if fromAid == toAid then
		self.fields.labelState:setColor(cc.c3b(50, 180, 0))
		self:showLeft(targetData, self.tableShowData.to, gAWarViewMemberType.DEFENDER)
		self:showRight(self.tableShowData.from, self.tableShowData.from, gAWarViewMemberType.HELPER)
	elseif fromAid == selfAid then
		self.fields.labelState:setColor(cc.c3b(216, 8, 8))
		self:showLeft(targetData, self.tableShowData.to, gAWarViewMemberType.DEFENDER)
		self:showRight(self.tableShowData.from, self.tableShowData.from, gAWarViewMemberType.ATTACKER)
	elseif toAid == selfAid then
		self.fields.labelState:setColor(cc.c3b(55, 180, 190))
		self:showLeft(self.tableShowData.from, self.tableShowData.from, gAWarViewMemberType.ATTACKER)
		self:showRight(targetData, self.tableShowData.to, gAWarViewMemberType.DEFENDER)
	else
		dump(self.tableShowData, "Com_WHV_single 数据不全", 10)
	end
	local isBlack = self.queueRoot:isBlock(self.tableShowData)
	self:showBlackWarnning(isBlack)
	self:updateFilter()
end
function Com_WHV_single:dataSort()
	self.tableSingleData = self.queueRoot:getSortWarHallQueues(self.indexID)
	local showData = self.tableSingleData and self.tableSingleData[1]
	if not showData or not next(showData) then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		return false
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
	return true
end
function Com_WHV_single:showBlackWarnning(show)
	if show then
		local actionTintTo1 = ffa.tintBy(1, -1, -1, -1)
		local actionTintTo2 = ffa.tintBy(1, 0, 0, 0)
		local actionDelay = ffa.delay(0.5)
		local actionTinBack = ffa.tintBy(1, 1, 1, 1)
		_UPVALUE5_ = 1
		;(1)[1] = actionTintTo1
		;(1)[2] = actionTintTo2
		;(1)[3] = actionDelay
		;(1)[4] = actionTinBack
		;(1)[5] = actionTintTo2
		local actionRepeat = ffa.repeatForever(ffa.seq(1))
		self.fields.imgWarnning:setVisible(true)
		self.fields.imgWarnning:stopAllActions()
		self.fields.imgWarnning:runAction(actionRepeat)
	elseif self.fields.imgWarnning then
		self.fields.imgWarnning:setVisible(false)
		self.fields.imgWarnning:stopAllActions()
	end
end
function Com_WHV_single:showQueue()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function Com_WHV_single:isTabelFull(data)
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
function Com_WHV_single:openTimeUp(dt)
	if self.tableShowData == nil or next(self.tableShowData) == nil then
		self:resetData()
		return
	end
	local leftTime = self.tableShowData:getStatusRemainTime()
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.fields.labelState:setString(i18n("common_text_295", nil))
	if leftTime <= 0 then
		self.fields.labelState:setString(i18n("Battlefield_queue_text_006"))
		_ENV = self.fields.labelState
		self.fields.labelState.msg = "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH"
		SoraDSendMessage(self.fields.labelState)
	end
	if self.is_delay then
		self.delay_time = self.delay_time - dt
		if 0 >= self.delay_time then
			self.is_delay = false
			self:dataSort()
		end
	end
end
function Com_WHV_single:showPVE(memberData, attackType)
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
function Com_WHV_single:showLeft(memberData, memberPosData, attackType)
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
		self.fields.imgLeftMember:setVisible(true)
		self.fields.labelLeftMember:setString(tostring(showMemberCount))
		self.fields.spriteLeftOwn:setVisible(self.haveOwn)
	else
		self.fields.imgLeftMember:setVisible(false)
	end
	self.fields.spriteLeftState:setURL(spriteState)
	local isPVE, nameStr, headImg, memberCount = self:showPVE(memberData, attackType)
	if isPVE then
		self.fields.imgLeftHead:setImage(headImg, false)
		self.fields.labelLeftName:setString(nameStr)
		if memberCount then
			self.fields.imgLeftMember:setVisible(true)
			self.fields.labelLeftMember:setString(tostring(memberCount))
			self.fields.spriteLeftOwn:setVisible(false)
		end
	elseif self:isTabelFull(memberData) then
		self.fields.imgLeftHead:setHeadSprite(memberData.headid, memberData.avatar)
		if memberData.allianceAbb then
			_ENV = tostring(memberCount)
			tostring(memberCount).abbr = memberData.allianceAbb
			tostring(memberCount).name = memberData.name
			self.fields.labelLeftName:setString(i18n("common_text_186", tostring(memberCount)))
		else
			self.fields.labelLeftName:setString(memberData.name)
		end
	end
	if memberPosData.x and memberPosData.y then
		self.fields.btnLeftPos:setTouchEnabled(true)
		self.fields.labelLeftPos:setString(tostring(memberPosData.x) .. "," .. tostring(memberPosData.y))
		self.leftPoint = cc.p(memberPosData.x, memberPosData.y)
	else
		self.fields.btnLeftPos:setTouchEnabled(false)
	end
end
function Com_WHV_single:showRight(memberData, memberPosData, attackType)
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
		self.fields.imgRightMember:setVisible(true)
		self.fields.labelRightMember:setString(tostring(showMemberCount))
		self.fields.spriteRightOwn:setVisible(self.haveOwn)
	else
		self.fields.imgRightMember:setVisible(false)
	end
	self.fields.spriteRightState:setURL(spriteState)
	local isPVE, nameStr, headImg, memberCount = self:showPVE(memberData, attackType)
	if isPVE then
		self.fields.imgRightHead:setHeadSprite(headImg, ccui.TextureResType.plistType)
		self.fields.labelRightName:setString(nameStr)
		if memberCount then
			self.fields.imgRightMember:setVisible(true)
			self.fields.labelRightMember:setString(tostring(memberCount))
			self.fields.spriteRightOwn:setVisible(false)
		end
	elseif self:isTabelFull(memberData) then
		self.fields.imgRightHead:setHeadSprite(memberData.headid, memberData.avatar)
		if memberData.allianceAbb then
			_ENV = tostring(memberCount)
			tostring(memberCount).abbr = memberData.allianceAbb
			tostring(memberCount).name = memberData.name
			self.fields.labelRightName:setString(i18n("common_text_186", tostring(memberCount)))
		else
			self.fields.labelRightName:setString(memberData.name)
		end
	end
	if memberPosData.x and memberPosData.y then
		self.fields.btnRightPos:setTouchEnabled(true)
		self.fields.labelRightPos:setString(tostring(memberPosData.x) .. "," .. tostring(memberPosData.y))
		self.rightPoint = cc.p(memberPosData.x, memberPosData.y)
	else
		self.fields.btnRightPos:setTouchEnabled(false)
	end
end
function Com_WHV_single:setScroll(scroll, queueRoot)
	self.scroll = scroll
	self.queueRoot = queueRoot
end
function Com_WHV_single:btnClickCallBack(button, type)
	SoraDPlaySound()
	self:openInfoPanel()
end
function Com_WHV_single:openInfoPanel()
	local panel = SoraDCreatePanel("allianceWarListInfoView")
	if panel:initData(self.indexID, self.tableSingleData, self.queueRoot) then
		panel:show()
	end
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function Com_WHV_single:updateFilter()
	self.fields.panelMask:setVisible(self.isFilter)
end
function Com_WHV_single:onCoordinate(target, event)
	SoraDPlaySound()
	local pos
	if target == self.fields.btnRightPos then
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
end
function Com_WHV_single:getShowTarget()
	if self.tableShowData:isTargetCapture() then
		local queuesFix = self.queueRoot:getWorkingCaptainQueue(self.tableShowData)
		if queuesFix then
			return queuesFix:getFrom()
		end
	end
	return self.tableShowData.to
end
local MIN_TIME = 2.0
function Com_WHV_single:needRefresh()
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
function Com_WHV_single:resetData()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.tableShowData, _ENV, self.tableSingleData, _ENV = SoraDManagerRemoveTimer, SoraDManagerRemoveTimer, SoraDManagerRemoveTimer, SoraDManagerRemoveTimer
end
return Com_WHV_single
