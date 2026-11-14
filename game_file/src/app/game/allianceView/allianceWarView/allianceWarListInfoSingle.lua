local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceDesRead = include("allianceDesRead")
local queueTimeUtil = include("queueTimeUtil")
local AllianceWarListInfoSingle = class("allianceWarListInfoSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceWarListInfoSingle")
	end
	return target
end)
function AllianceWarListInfoSingle:ctor()
	self.toPos, _ENV, self.tableShowData, _ENV, self.curType = gAWarViewMemberType.DEFENDER, gAWarViewMemberType.DEFENDER, gAWarViewMemberType.DEFENDER, gAWarViewMemberType.DEFENDER, gAWarViewMemberType.DEFENDER
	self.scroll = nil
	self.singleIsMoved = false
	self.timer = nil
	self.ownUid = lordInfoCtrl:getLordInfo().base.uid
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.imgIcon = SoraDGetChildByName(self, "Image_icon")
	self.imgFrame = SoraDGetChildByName(self, "Image_frame")
	self.labelDef = SoraDGetChildByName(self, "Text_def")
	self.labelDef:setString(i18n("common_text_306"))
	self.nodeAtk = SoraDGetChildByName(self, "Node_atk")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTime:setVisible(false)
	self.labelArmyCount = SoraDGetChildByName(self, "Text_armyCount")
	self.labelHeroCount = SoraDGetChildByName(self, "Text_heroCount")
	self.imgOpenTime = SoraDGetChildByName(self, "Image_openTime")
	self.btnSpeedUp = SoraDGetChildByName(self, "Button_speedUp")
	self.textSpeedUp = SoraDGetChildByName(self, "Text_speedup")
	self.textSpeedUp:setString(i18n("common_text_018"))
	self.textTimeSelf = SoraDGetChildByName(self, "Text_time_self")
	self.btnSpeedUp:setVisible(false)
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelPos = SoraDGetChildByName(self, "Text_pos")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.btnJump:setSwallowTouches(false)
	self.textTime = self.labelTime
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.btnSpeedUp:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function AllianceWarListInfoSingle:initData(data, dataType, queueRoot)
	self.curType = dataType
	self.tableShowData = data
	self.queueRoot = queueRoot
	if self.curType == gAWarViewMemberType.DEFENDER then
		self.nodeAtk:setVisible(false)
		self.labelDef:setVisible(true)
		local targetData = self:getShowTarget()
		self:showMember(targetData, self.tableShowData.to)
	else
		self.nodeAtk:setVisible(true)
		self.labelDef:setVisible(false)
		if self.tableShowData.from.uid == self.ownUid and not worldMapDefine.isInWarForbidSpeed(self.tableShowData, true) then
			self.btnSpeedUp:setVisible(true)
			self.nodeTime:setVisible(false)
			self.textTime = self.textTimeSelf
		else
			self.nodeTime:setVisible(true)
			self.btnSpeedUp:setVisible(false)
			self.textTime = self.labelTime
		end
		local armyCount = 0
		if self.tableShowData.from.army then
			for _, v in ipairs(self.tableShowData.from.army) do
				armyCount = armyCount + v.num
			end
		end
		self.labelArmyCount:setString(string.formatnumberthousands(armyCount))
		local heroCount = 0
		if self.tableShowData.from.heroInfo then
			heroCount = #self.tableShowData.from.heroInfo
		end
		self.labelHeroCount:setString(heroCount)
		self:showMember(self.tableShowData.from, self.tableShowData.from)
		self:showQueue()
	end
end
function AllianceWarListInfoSingle:showQueue()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function AllianceWarListInfoSingle:openTimeUp(dt)
	local leftTime = queueTimeUtil.getRemainTime(self.tableShowData)
	if leftTime <= 0 then
		self.textTime:setString(i18n("Battlefield_queue_text_006"))
	else
		self.textTime:setString(SoraDConvertSecondToString(leftTime))
	end
end
function AllianceWarListInfoSingle:isTabelFull(data)
	local isFull = true
	_UPVALUE4_ = nil
	;(nil)[1] = "x"
	;(nil)[2] = "y"
	;(nil)[3] = "headid"
	local (nil)[4], tableKey = "name", nil
	for _, v in ipairs(tableKey) do
		if data[v] == nil then
			isFull = false
			print("the null key is " .. v)
		end
	end
	return isFull
end
function AllianceWarListInfoSingle:showMember(memberData, memberPosData)
	local isPVE, nameStr, headImg = self:showPVE(memberData)
	if isPVE then
		self.imgIcon:loadTexture(headImg, ccui.TextureResType.plistType)
		self.labelName:setString(nameStr)
	elseif self:isTabelFull(memberData) then
		SoraDGetHeadFromManager(self.imgIcon, memberData.headid, memberData.avatar)
		if memberData.allianceAbb then
			_ENV = nil
			;(nil).abbr = memberData.allianceAbb
			;(nil).name = memberData.name
			self.labelName:setString(i18n("common_text_186", nil))
		else
			self.labelName:setString(memberData.name)
		end
	end
	if memberPosData.x and memberPosData.y then
		self.labelPos:setString(tostring(memberPosData.x) .. "," .. tostring(memberPosData.y))
		self.toPos = cc.p(memberPosData.x, memberPosData.y)
	end
end
function AllianceWarListInfoSingle:showPVE(memberData, attackType)
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
		if self.curType ~= gAWarViewMemberType.DEFENDER then
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
function AllianceWarListInfoSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceWarListInfoSingle:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local mapID = self.tableShowData.getMapID and self.tableShowData:getMapID() or nil
		if SoraDGotoWorldMapPoint(self.toPos, true, mapID) then
			SoraDRemoveAllPanelFromManager()
		end
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
function AllianceWarListInfoSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if queueTimeUtil.getRemainTime(self.tableShowData) <= 0 then
			SoraDShowMsgTip(i18n("Battlefield_queue_text_002"))
			return
		end
		_ENV = i18n("Battlefield_queue_text_002")
		_ENV, i18n("Battlefield_queue_text_002").itemType = gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP
		i18n("Battlefield_queue_text_002").troopData, gItemType.MARCH_SPEED_UP.troopsID = gItemType.MARCH_SPEED_UP, self.tableShowData.id
		uiManager:show("speedUpReCallBuyView", i18n("Battlefield_queue_text_002"))
	end
end
function AllianceWarListInfoSingle:getShowTarget()
	if self.tableShowData:isTargetCapture() then
		local queuesFix = self.queueRoot:getWorkingCaptainQueue(self.tableShowData)
		if queuesFix then
			return queuesFix:getFrom()
		end
	end
	return self.tableShowData.to
end
function AllianceWarListInfoSingle:resetData()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.tableShowData, _ENV = SoraDManagerRemoveTimer, SoraDManagerRemoveTimer
end
return AllianceWarListInfoSingle
