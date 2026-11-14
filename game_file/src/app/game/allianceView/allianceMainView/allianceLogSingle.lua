local SingleHAdd = 10
local allianceDesRead = include("allianceDesRead")
local alliancePetRead = include("alliancePetRead")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local AllianceLogSingle = class("allianceLogSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceLogSingle")
	end
	return target
end)
function AllianceLogSingle:ctor()
	self.scroll = nil
	self.singleIsMoved = false
	self.tableSingleData, _ENV, self.handle = nil, nil, nil
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeTouch:setSwallowTouches(false)
	self.labelLog = SoraDGetChildByName(self, "Text_log")
	self.labelLog:setTextHorizontalAlignment(SoraDFLabelR())
	self.imgBg = SoraDGetChildByName(self, "Image_bg_noSize")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	if self.nodeTouch then
		self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceLogSingle:initData(singleData, isLast)
	self.tableSingleData = singleData.log
	local logNotice = ""
	local frameName = ""
	local bgName = ""
	local labelColor = cc.c3b(58, 122, 79)
	local logData = self.tableSingleData.data
	local isScale = false
	if self.tableSingleData.tp == gALogType.JOIN_ALLIANCE then
		_ENV = nil
		;(nil).name = logData.user
		logNotice = i18n("common_text_196", nil)
		frameName = "icon_alliance_join.png"
		labelColor = cc.c3b(58, 122, 79)
		bgName = "frame_square_25_green.png"
	elseif self.tableSingleData.tp == gALogType.AGREE_APPLY_JOIN_ALLIANCE then
		_ENV = 122
		;(122).cuser = logData.cuser
		;(122).uuser = logData.uuser
		logNotice = i18n("common_text_2049", 122)
		frameName = "icon_alliance_join.png"
		labelColor = cc.c3b(58, 122, 79)
		bgName = "frame_square_25_green.png"
	elseif self.tableSingleData.tp == gALogType.AGREE_INVITE_JOIN_ALLIANCE then
		_ENV = 122
		;(122).cuser = logData.cuser
		;(122).uuser = logData.uuser
		logNotice = i18n("common_text_2050", 122)
		frameName = "icon_alliance_join.png"
		labelColor = cc.c3b(58, 122, 79)
		bgName = "frame_square_25_green.png"
	elseif self.tableSingleData.tp == gALogType.QUIT_ALLIANCE then
		_ENV = 122
		;(122).name = logData.user
		logNotice = i18n("common_text_197", 122)
		frameName = "icon_alliance_leave.png"
		labelColor = cc.c3b(58, 122, 79)
		bgName = "frame_square_25_green.png"
	elseif self.tableSingleData.tp == gALogType.ALLIANCE_PLAYER_GIFT then
		local kingPacksRead = include("kingPacksRead")
		local aAbbr = logData.aAbbr or ""
		local bAbbr = logData.bAbbr or ""
		local aName = logData.aName or ""
		local bName = logData.bName or ""
		local packName = i18n(kingPacksRead.getItem(logData.type).name)
		_ENV = nil
		;(nil).aalliance = aAbbr
		;(nil).alord = aName
		;(nil).balliance = bAbbr
		;(nil).blord = bName
		;(nil).giftName = packName
		logNotice = i18n("common_text_2724", nil)
		frameName = "icon_mail_adjunct.png"
		labelColor = cc.c3b(58, 122, 79)
		bgName = "frame_square_25_green.png"
	elseif self.tableSingleData.tp == gALogType.CITY_PLUNDER then
		local atk = logData.atk
		if logData.abbr and logData.abbr ~= "" then
			_ENV = ""
			;("").abbr = logData.abbr
			;("").name = atk
			atk = i18n("common_text_186", "")
		end
		_ENV = ""
		;("").name = logData.user
		;("").x = logData.pos.x
		;("").y = logData.pos.y
		;("").atk = atk
		logNotice = i18n("common_text_198", "")
		bgName = "frame_square_25_red.png"
		labelColor = cc.c3b(149, 72, 72)
		frameName = "icon_alliance_war.png"
	elseif self.tableSingleData.tp == gALogType.RES_POINT_PLUNDER then
		local atk = logData.atk
		if logData.abbr and logData.abbr ~= "" then
			_ENV = 72
			;(72).abbr = logData.abbr
			;(72).name = atk
			atk = i18n("common_text_186", 72)
		end
		_ENV = 72
		;(72).name = logData.user
		;(72).x = logData.pos.x
		;(72).y = logData.pos.y
		;(72).atk = atk
		logNotice = i18n("common_text_199", 72)
		bgName = "frame_square_25_red.png"
		labelColor = cc.c3b(149, 72, 72)
		frameName = "icon_alliance_war.png"
	elseif self.tableSingleData.tp == gALogType.TECHNOLOGY_REACH then
		bgName = "frame_square_25_blue.png"
		_ENV = 149
		;(149).name = logData.user
		;(149).science = allianceDesRead.getScienceName(logData.tech)
		logNotice = i18n("common_text_200", 149)
		labelColor = cc.c3b(34, 107, 131)
		frameName = "icon_alliance_research.png"
	elseif self.tableSingleData.tp == gALogType.NOTICE then
		logNotice = logData.content
		if logNotice == "" then
			logNotice = i18n("common_text_194")
		end
		frameName = "icon_alliance_notice.png"
		labelColor = cc.c3b(58, 122, 79)
		bgName = "frame_square_25_green.png"
	elseif self.tableSingleData.tp == gALogType.ROME_ACTIVITY then
		bgName = "frame_square_25_red.png"
		_ENV = 122
		;(122).name = logData.user
		;(122).npc = i18n("common_text_1222")
		logNotice = i18n("common_text_1513", 122)
		labelColor = cc.c3b(149, 72, 72)
		frameName = "icon_alliance_roman.png"
	elseif self.tableSingleData.tp == gALogType.MODIFY_PERMISSION then
		bgName = "frame_square_25_blue.png"
		logNotice = i18n("common_text_2374")
		labelColor = cc.c3b(34, 107, 131)
		frameName = "btn_allance_power.png"
		isScale = true
	elseif self.tableSingleData.tp == gALogType.DEL_ALLIANE_BWLIST or self.tableSingleData.tp == gALogType.ADD_ALLIANCE_BWLIST then
		local isBlack = logData.bwtype == gAllianceBWListType.BLACK
		local listName = isBlack and i18n("common_text_1679") or i18n("common_text_1680")
		local aname = logData.aname
		if logData.abbr and logData.abbr ~= "" then
			_ENV = i18n(kingPacksRead.getItem(logData.type).name)
			i18n(kingPacksRead.getItem(logData.type).name).abbr = logData.abbr
			i18n(kingPacksRead.getItem(logData.type).name).name = logData.aname
			aname = i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name)))
		end
		bgName = isBlack and "frame_square_25_red.png" or "frame_square_25_green.png"
		labelColor = isBlack and cc.c3b(149, 72, 72) or cc.c3b(58, 122, 79)
		frameName = isBlack and "icon_alliance_blacklist.png" or "icon_alliance_whitelist.png"
		if self.tableSingleData.tp == gALogType.DEL_ALLIANE_BWLIST then
			_ENV = 122
			;(122).name = logData.user
			;(122).alliance = aname
			;(122).list = listName
		end
		_ENV = 122
		;(122).name = logData.user
		;(122).point = logData.score
		;(122).alliance = aname
		;(122).list = listName
		logNotice = i18n("common_text_1689", 122) or i18n("common_text_1688", 122)
		isScale = true
	elseif self.tableSingleData.tp == gALogType.SET_BUILDING then
		if logData.point then
			if logData.point > 0 then
				_ENV = i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name)))
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).name = logData.user
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).x = logData.pos.x
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).y = logData.pos.y
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).build = allianceDesRead.getBuildName(logData.bid)
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).point = logData.point
				logNotice = i18n("alliance_text_13", (i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name)))))
			else
				_ENV = i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name)))
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).name = logData.user
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).x = logData.pos.x
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).y = logData.pos.y
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).build = allianceDesRead.getBuildName(logData.bid)
				logNotice = i18n("alliance_text_17", (i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name)))))
			end
			labelColor = cc.c3b(58, 122, 79)
			frameName = "icon_alliance_territory_build.png"
			if logData.bid == 6 then
				frameName = "icon_alliance_territory_flag_03.png"
			elseif logData.bid == gAllianceBuilding.ALTAR then
				frameName = "icon_alliance_beast_jtrk.png"
			end
			isScale = true
		else
			_ENV = 122
			;(122).name = logData.user
			;(122).x = logData.pos.x
			;(122).y = logData.pos.y
			;(122).superRes = allianceDesRead.getBuildName(logData.bid)
			logNotice = i18n("common_text_2229", 122)
			labelColor = cc.c3b(58, 122, 79)
			frameName = "icon_alliance_mineral_enter.png"
			isScale = true
		end
	elseif self.tableSingleData.tp == gALogType.DEMOLISH_BUILDING then
		if logData.point then
			if logData.point > 0 then
				_ENV = 122
				;(122).name = logData.user
				;(122).x = logData.pos.x
				;(122).y = logData.pos.y
				;(122).build = allianceDesRead.getBuildName(logData.bid)
				;(122).point = logData.point
				logNotice = i18n("alliance_text_14", 122)
			else
				_ENV = 122
				;(122).name = logData.user
				;(122).x = logData.pos.x
				;(122).y = logData.pos.y
				;(122).build = allianceDesRead.getBuildName(logData.bid)
				logNotice = i18n("alliance_text_18", 122)
			end
			labelColor = cc.c3b(149, 72, 72)
			frameName = "icon_alliance_territory_build.png"
			if logData.bid == 6 then
				frameName = "icon_alliance_territory_flag_03.png"
			elseif logData.bid == gAllianceBuilding.ALTAR then
				frameName = "icon_alliance_beast_jtrk.png"
			end
			isScale = true
		else
			_ENV = 72
			;(72).name = logData.user
			;(72).superRes = allianceDesRead.getBuildName(logData.bid)
			logNotice = i18n("common_text_2230", 72)
			labelColor = cc.c3b(149, 72, 72)
			frameName = "icon_alliance_mineral_enter.png"
			isScale = true
		end
	elseif self.tableSingleData.tp == gALogType.RECYCLING_BUILDING then
		if logData.point then
			_ENV = 72
			;(72).x = logData.pos.x
			;(72).y = logData.pos.y
			;(72).build = allianceDesRead.getBuildName(logData.bid)
			;(72).point = logData.point
			logNotice = i18n("alliance_text_15", 72)
			labelColor = cc.c3b(34, 107, 131)
			frameName = "icon_alliance_territory_build.png"
			if logData.bid == 6 then
				frameName = "icon_alliance_territory_flag_03.png"
			elseif logData.bid == gAllianceBuilding.ALTAR then
				frameName = "icon_alliance_beast_jtrk.png"
			end
			isScale = true
		else
			_ENV = 107
			;(107).superRes = allianceDesRead.getBuildName(logData.bid)
			logNotice = i18n("common_text_2231", 107)
			labelColor = cc.c3b(34, 107, 131)
			frameName = "icon_alliance_mineral_enter.png"
			isScale = true
		end
	elseif self.tableSingleData.tp == gALogType.ALLIANCE_BUILD_BE_MASSED or self.tableSingleData.tp == gALogType.ALLIANCE_BUILD_BE_ATTACKED then
		labelColor = cc.c3b(149, 72, 72)
		frameName = "icon_alliance_territory_build.png"
		local mainKey = self.tableSingleData.tp == gALogType.ALLIANCE_BUILD_BE_MASSED and "common_text_3108" or "common_text_3107"
		_ENV = 72
		;(72).abbr = logData.defAbbr
		;(72).name = allianceDesRead.getBuildName(logData.objId)
		local buildName = i18n("common_text_186", 72)
		_ENV = allianceDesRead.getBuildName(logData.objId)
		allianceDesRead.getBuildName(logData.objId).abbr = logData.atkAbbr
		allianceDesRead.getBuildName(logData.objId).name = logData.atkUser
		local allianceName = i18n("common_text_186", (allianceDesRead.getBuildName(logData.objId)))
		local typeStr = logData.isAtkWin and i18n("common_text_291") or i18n("common_text_290")
		_ENV = logData.score
		logData.score.x = logData.pos.x
		logData.score.y = logData.pos.y
		logData.score.build = buildName
		logData.score.alliance = allianceName
		logData.score.type = typeStr
		logNotice = i18n(mainKey, logData.score)
		isScale = true
	elseif self.tableSingleData.tp == gALogType.ALLIANCE_BEAST_CALL then
		local petname = alliancePetRead.getName(logData.beastType)
		_ENV = i18n("common_text_290")
		i18n("common_text_290").name = logData.user
		i18n("common_text_290").petname = petname
		i18n("common_text_290").x = logData.pos.x
		i18n("common_text_290").y = logData.pos.y
		logNotice = i18n("alliance_beast_text_24", (i18n("common_text_290")))
		frameName = "icon_alliance_beast_jtrk.png"
	elseif self.tableSingleData.tp == gALogType.ALLIANCE_TRIAL_BEAST then
		local petname = alliancePetRead.getName(logData.beastType)
		_ENV = i18n("common_text_290")
		i18n("common_text_290").name = logData.user
		i18n("common_text_290").petname = petname
		i18n("common_text_290").Lvl = logData.beastLv
		i18n("common_text_290").x = logData.pos.x
		i18n("common_text_290").y = logData.pos.y
		logNotice = i18n("alliance_beast_text_25", (i18n("common_text_290")))
		frameName = "icon_alliance_beast_jtrk.png"
	elseif self.tableSingleData.tp == gALogType.ALLIANCE_KILL_BEAST then
		local petname = alliancePetRead.getName(logData.beastType)
		_ENV = i18n("common_text_290")
		i18n("common_text_290").name = logData.user
		i18n("common_text_290").petname = petname
		logNotice = i18n("alliance_beast_text_26", (i18n("common_text_290")))
		frameName = "icon_alliance_beast_jtrk.png"
	else
		_ENV = "alliance_beast_text_26"
		;("alliance_beast_text_26").des = i18n("common_text_259")
		logNotice = i18n("common_text_1437", "alliance_beast_text_26")
		labelColor = cc.c3b(58, 122, 79)
		frameName = "icon_item_common.png"
		isScale = true
	end
	if isLast then
		local retString, label = SoraDConvertOmissionText(420, logNotice, 20)
		self.labelLog:setString(retString)
	else
		self.labelLog:setString(logNotice)
	end
	local labelH = 0
	if logData.itemH == nil or logData.itemH == 0 then
		labelH = SoraDGetAutoHeightLabel(self.labelLog, 480) + 20
	else
		labelH = logData.itemH - SingleHAdd
		self.labelLog:ignoreContentAdaptWithSize(false)
		self.labelLog:setTextAreaSize(cc.size(480, labelH - 20))
	end
	self.labelLog:setPositionY(labelH - 5)
	self.labelLog:setColor(labelColor)
	self.nodeTouch:setContentSize(cc.size(535, math.max(69, labelH + 20)))
	self.imgBg:setContentSize(cc.size(535, math.max(56, labelH + 10)))
	self.spriteIcon:loadTexture(frameName, ccui.TextureResType.plistType)
end
function AllianceLogSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceLogSingle:setTouchEventCallBack(handle)
	self.handle = handle
end
function AllianceLogSingle:getSingleH()
	return self.nodeTouch:getContentSize().height
end
function AllianceLogSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll == nil or not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(self.tableSingleData)
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
return AllianceLogSingle
