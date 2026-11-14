local memberMgr = SoraDGetCtrl("memberMgr")
local allianceDesRead = include("allianceDesRead")
local alliancePetRead = include("alliancePetRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_log = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceMainView/Btn_log", Btn_log)
function Btn_log:onInit()
	self.fields.title:setString(i18n("common_text_194"))
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Btn_log:onShow()
end
function Btn_log:initData(log, isMain)
	self.log = log
	self.isMain = isMain or false
	if self.isMain then
		local logNotice = log.data.content
		if logNotice == "" then
			logNotice = i18n("common_text_194")
		end
		local retString = SoraDConvertOmissionText(520, logNotice, 20)
		self.fields.title:setString(retString)
	else
		local logNotice = i18n("common_text_194")
		local frameName = "icon_alliance_xinxi.png"
		local labelColor = cc.c3b(182, 173, 151)
		local logData = self.log.data
		if self.log.tp == gALogType.JOIN_ALLIANCE then
			_ENV = nil
			;(nil).name = logData.user
			logNotice = i18n("common_text_196", nil)
			frameName = "icon_alliance_join.png"
		elseif self.log.tp == gALogType.AGREE_APPLY_JOIN_ALLIANCE then
			_ENV = nil
			;(nil).cuser = logData.cuser
			;(nil).uuser = logData.uuser
			logNotice = i18n("common_text_2049", nil)
			frameName = "icon_alliance_join.png"
		elseif self.log.tp == gALogType.AGREE_INVITE_JOIN_ALLIANCE then
			_ENV = nil
			;(nil).cuser = logData.cuser
			;(nil).uuser = logData.uuser
			logNotice = i18n("common_text_2050", nil)
			frameName = "icon_alliance_join.png"
		elseif self.log.tp == gALogType.QUIT_ALLIANCE then
			_ENV = nil
			;(nil).name = logData.user
			logNotice = i18n("common_text_197", nil)
			frameName = "icon_alliance_leave.png"
		elseif self.log.tp == gALogType.ALLIANCE_PLAYER_GIFT then
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
		elseif self.log.tp == gALogType.CITY_PLUNDER then
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
			frameName = "icon_alliance_war.png"
			labelColor = cc.c3b(149, 72, 72)
		elseif self.log.tp == gALogType.RES_POINT_PLUNDER then
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
			frameName = "icon_alliance_war.png"
			labelColor = cc.c3b(149, 72, 72)
		elseif self.log.tp == gALogType.TECHNOLOGY_REACH then
			_ENV = 149
			;(149).name = logData.user
			;(149).science = allianceDesRead.getScienceName(logData.tech)
			logNotice = i18n("common_text_200", 149)
			labelColor = cc.c3b(34, 107, 131)
			frameName = "icon_alliance_research.png"
		elseif self.log.tp == gALogType.NOTICE then
			logNotice = logData.content
			if logNotice == "" then
				logNotice = i18n("common_text_194")
			end
			frameName = "icon_alliance_notice.png"
		elseif self.log.tp == gALogType.ROME_ACTIVITY then
			_ENV = 107
			;(107).name = logData.user
			;(107).npc = i18n("common_text_1222")
			logNotice = i18n("common_text_1513", 107)
			labelColor = cc.c3b(149, 72, 72)
			frameName = "icon_alliance_roman.png"
		elseif self.log.tp == gALogType.MODIFY_PERMISSION then
			logNotice = i18n("common_text_2374")
			labelColor = cc.c3b(34, 107, 131)
			frameName = "btn_allance_power.png"
		elseif self.log.tp == gALogType.DEL_ALLIANE_BWLIST or self.log.tp == gALogType.ADD_ALLIANCE_BWLIST then
			local isBlack = logData.bwtype == gAllianceBWListType.BLACK
			local listName = isBlack and i18n("common_text_1679") or i18n("common_text_1680")
			local aname = logData.aname
			if logData.abbr and logData.abbr ~= "" then
				_ENV = i18n(kingPacksRead.getItem(logData.type).name)
				i18n(kingPacksRead.getItem(logData.type).name).abbr = logData.abbr
				i18n(kingPacksRead.getItem(logData.type).name).name = logData.aname
				aname = i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name)))
			end
			labelColor = isBlack and cc.c3b(149, 72, 72) or cc.c3b(182, 173, 151)
			frameName = isBlack and "icon_alliance_blacklist.png" or "icon_alliance_whitelist.png"
			if self.log.tp == gALogType.DEL_ALLIANE_BWLIST then
				_ENV = 173
				;(173).name = logData.user
				;(173).alliance = aname
				;(173).list = listName
			end
			_ENV = 173
			;(173).name = logData.user
			;(173).point = logData.score
			;(173).alliance = aname
			;(173).list = listName
			logNotice = i18n("common_text_1689", 173) or i18n("common_text_1688", 173)
		elseif self.log.tp == gALogType.SET_BUILDING then
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
				frameName = "icon_alliance_territory_build.png"
				if logData.bid == 6 then
					frameName = "icon_alliance_territory_flag_03.png"
				elseif logData.bid == gAllianceBuilding.ALTAR then
					frameName = "icon_alliance_beast_jtrk.png"
				end
			else
				_ENV = i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name)))
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).name = logData.user
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).x = logData.pos.x
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).y = logData.pos.y
				i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name))).superRes = allianceDesRead.getBuildName(logData.bid)
				logNotice = i18n("common_text_2229", (i18n("common_text_186", (i18n(kingPacksRead.getItem(logData.type).name)))))
				frameName = "icon_alliance_mineral_enter.png"
			end
		elseif self.log.tp == gALogType.DEMOLISH_BUILDING then
			labelColor = cc.c3b(149, 72, 72)
			if logData.point then
				if logData.point > 0 then
					_ENV = 72
					;(72).name = logData.user
					;(72).x = logData.pos.x
					;(72).y = logData.pos.y
					;(72).build = allianceDesRead.getBuildName(logData.bid)
					;(72).point = logData.point
					logNotice = i18n("alliance_text_14", 72)
				else
					_ENV = 72
					;(72).name = logData.user
					;(72).x = logData.pos.x
					;(72).y = logData.pos.y
					;(72).build = allianceDesRead.getBuildName(logData.bid)
					logNotice = i18n("alliance_text_18", 72)
				end
				frameName = "icon_alliance_territory_build.png"
				if logData.bid == 6 then
					frameName = "icon_alliance_territory_flag_03.png"
				elseif logData.bid == gAllianceBuilding.ALTAR then
					frameName = "icon_alliance_beast_jtrk.png"
				end
			else
				_ENV = 72
				;(72).name = logData.user
				;(72).superRes = allianceDesRead.getBuildName(logData.bid)
				logNotice = i18n("common_text_2230", 72)
				frameName = "icon_alliance_mineral_enter.png"
			end
		elseif self.log.tp == gALogType.RECYCLING_BUILDING then
			labelColor = cc.c3b(34, 107, 131)
			if logData.point then
				_ENV = 107
				;(107).x = logData.pos.x
				;(107).y = logData.pos.y
				;(107).build = allianceDesRead.getBuildName(logData.bid)
				;(107).point = logData.point
				logNotice = i18n("alliance_text_15", 107)
				frameName = "icon_alliance_territory_build.png"
				if logData.bid == 6 then
					frameName = "icon_alliance_territory_flag_03.png"
				elseif logData.bid == gAllianceBuilding.ALTAR then
					frameName = "icon_alliance_beast_jtrk.png"
				end
			else
				_ENV = 107
				;(107).superRes = allianceDesRead.getBuildName(logData.bid)
				logNotice = i18n("common_text_2231", 107)
				frameName = "icon_alliance_mineral_enter.png"
			end
		elseif self.log.tp == gALogType.ALLIANCE_BUILD_BE_MASSED or self.log.tp == gALogType.ALLIANCE_BUILD_BE_ATTACKED then
			labelColor = cc.c3b(149, 72, 72)
			frameName = "icon_alliance_territory_build.png"
			local mainKey = self.log.tp == gALogType.ALLIANCE_BUILD_BE_MASSED and "common_text_3108" or "common_text_3107"
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
		elseif self.log.tp == gALogType.ALLIANCE_BEAST_CALL then
			local petname = alliancePetRead.getName(logData.beastType)
			_ENV = i18n("common_text_290")
			i18n("common_text_290").name = logData.user
			i18n("common_text_290").petname = petname
			i18n("common_text_290").x = logData.pos.x
			i18n("common_text_290").y = logData.pos.y
			logNotice = i18n("alliance_beast_text_24", (i18n("common_text_290")))
			frameName = "icon_alliance_beast_jtrk.png"
		elseif self.log.tp == gALogType.ALLIANCE_TRIAL_BEAST then
			local petname = alliancePetRead.getName(logData.beastType)
			_ENV = i18n("common_text_290")
			i18n("common_text_290").name = logData.user
			i18n("common_text_290").petname = petname
			i18n("common_text_290").Lvl = logData.beastLv
			i18n("common_text_290").x = logData.pos.x
			i18n("common_text_290").y = logData.pos.y
			logNotice = i18n("alliance_beast_text_25", (i18n("common_text_290")))
			frameName = "icon_alliance_beast_jtrk.png"
		elseif self.log.tp == gALogType.ALLIANCE_KILL_BEAST then
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
			frameName = "icon_item_common.png"
		end
		self.fields.title:setString(logNotice)
		self.fields.title:setColor(labelColor)
		self.fields.icon:setSpriteFrame(frameName)
	end
end
function Btn_log:btnClick()
	SoraDPlaySound()
	if self.isMain then
		uiManager:show("allianceEventLogView")
	else
		if self.log == nil then
			return
		end
		if self.log.tp == gALogType.CITY_PLUNDER or self.log.tp == gALogType.RES_POINT_PLUNDER or self.log.tp == gALogType.ALLIANCE_BUILD_BE_ATTACKED or self.log.tp == gALogType.ALLIANCE_BUILD_BE_MASSED or self.log.tp == gALogType.SET_BUILDING or self.log.tp == gALogType.ALLIANCE_BEAST_CALL or self.log.tp == gALogType.ALLIANCE_TRIAL_BEAST or self.log.tp == gALogType.ALLIANCE_KILL_BEAST then
			local pos = self.log.data.pos
			local jumppos = cc.p(tonumber(pos.x), tonumber(pos.y))
			SoraDGotoWorldMapPoint(jumppos, true)
			SoraDRemoveAllPanelFromManager()
		elseif self.log.tp == gALogType.TECHNOLOGY_REACH then
			_ENV = jumppos
			jumppos.sid = self.log.data.tech
			uiManager:show("AllianceScience", jumppos)
		elseif self.log.tp == gALogType.NOTICE then
			local ownmember = memberMgr:getOwnMember()
			local ownRank = ownmember:getProperty("rank")
			if ownRank >= gAllianceRank.R4 then
				_ENV = tonumber(pos.y)
				tonumber(pos.y).tag = 1
				uiManager:show("allianceSettingsView", tonumber(pos.y))
			end
		elseif self.log.tp == gALogType.DEL_ALLIANE_BWLIST or self.log.tp == gALogType.ADD_ALLIANCE_BWLIST then
			local ownmember = memberMgr:getOwnMember()
			local ownRank = ownmember:getProperty("rank")
			if ownRank >= gAllianceRank.R4 then
				uiManager:show("allianceBlackWhiteView")
			end
		end
	end
end
return Btn_log
