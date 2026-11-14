local gametop = gModuleMgr.getObject("gametop")
local allianceLog = gametop.playertop_:getModule("allianceLog")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local allianceGuideCtrl = SoraDGetCtrl("allianceGuideCtrl")
local LogLoadCountOnce = 20
local checkInWar = function()
	return worldMapDefine.isInKingdomBattle() or worldMapDefine.isInWar(), true
end
local cehckNotInWar = function()
	return true, not checkInWar()
end
local cehckActive = function()
	local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
	local time = allianceActiveCtrl:getJoinAllianceTime()
	return true, not checkInWar() and (not time or not (0 < time))
end
local isForbiddenByInWar = function()
	if worldMapDefine.isInWarForbid(true) then
		return false, true
	end
	return true, true
end
local isForbiddenByInNewTrial = function()
	return not worldMapDefine.isInNewTrial(), true
end
local isAllianceTaskOpen = function()
	if checkInWar() then
		return false
	end
	local ret = false
	local gametop = gModuleMgr.getObject("gametop")
	local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
	local activityStatus = playerMobilizationCtrl:getActivityStatus()
	if activityStatus.status == gMobilizationActivityStatus.ACTIVITY_OPEN then
		ret = true
	end
	return true, ret
end
local isAlliancePetOpen = function(menuType)
	if checkInWar() then
		return true, false
	end
	local allianceTerritoryAPI = include("allianceTerritoryAPI")
	local showAltar = allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.ALTAR)
	local condition = menuType == ALLIANCE_MAIN_MENU_TYPE.PET and showAltar
	return true, condition
end
_ENV = nil
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_TASK], (nil).checkFunc = nil, isAllianceTaskOpen
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.PET], (nil).checkFunc = nil, isAlliancePetOpen
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.BUILD], (nil).checkFunc = nil, isForbiddenByInWar
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.SCIENCE], (nil).checkFunc = nil, isForbiddenByInWar
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.STORE], (nil).checkFunc = nil, isForbiddenByInWar
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE], (nil).checkFunc = nil, isForbiddenByInWar
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.MESSAGE], (nil).checkFunc = nil, isForbiddenByInNewTrial
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.COUNTER_SYS], (nil).checkFunc = nil, isForbiddenByInWar
_ENV = nil
;(nil)[ALLIANCE_MAIN_MENU_TYPE.ACTIVE], (nil).checkFunc = nil, cehckActive
local CheckShowMenuTable
if ALLIANCE_MAIN_MENU_TYPE.HUNT then
	_ENV = nil
	CheckShowMenuTable[ALLIANCE_MAIN_MENU_TYPE.HUNT], (nil).checkFunc = nil, cehckNotInWar
end
local AllianceMainScroll = class("allianceMainScroll", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMainScroll")
	end
	return target
end)
function AllianceMainScroll:ctor()
	self.fromLoadText = false
	self.isMainScrollShow = true
	self.tableSpare, (nil).time, _ENV, (nil).log, _ENV, _ENV, self.tableMainSingle, _ENV, self.tableLogData, _ENV, self.handle = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.scroll = SoraDGetChildByName(self, "ScrollView_alliance")
	self.btnClose = SoraDGetChildByName(self, "Button_closeLog")
	self.btnClose:setPressedActionEnabled(false)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	if self.btnClose then
		self.btnClose:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelUp = SoraDGetChildByName(self, "Text_up")
	self.labelUp:setString(i18n("common_text_1042"))
	self:showMenu()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_LOG_SUCCESS", function(target, data)
		self:updateLogData(target, data)
		SoraDAddMessage(self, "MESSAGE_ALLIACNE_LOG_ADD_SUCCESS", handler(self, self.updateLogData))
		SoraDAddMessage(self, "MESSAGE_ALLIACNE_NOTICE_CHANGE_SUCCESS", handler(self, self.updateLogData))
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", function(target, data)
		if gAllianceBuilding.ALTAR ~= data.bid then
			return
		end
		if not self.isMainScrollShow then
			return
		end
		for index = ALLIANCE_MAIN_MENU_TYPE.PET, table.nums(ALLIANCE_MAIN_MENU_TYPE) do
			if self.tableMainSingle[index] then
				self.tableMainSingle[index]:removeFromParent()
				self.tableMainSingle[index] = nil
			end
		end
		self:initMenuOnScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if data.activityID and type(data.activityID) == "table" then
			for i, v in ipairs(data.activityID) do
				if v == gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY then
					for i, v in ipairs(self.tableMainSingle) do
						v:removeFromParent()
					end
					self.tableMainSingle, _ENV = ipairs(self.tableMainSingle)
					if self.isMainScrollShow then
						self:initMenuOnScroll()
					end
					break
				end
			end
		elseif data.eventID and data.eventID == gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY then
			for i, v in ipairs(self.tableMainSingle) do
				v:removeFromParent()
			end
			self.tableMainSingle, _ENV = ipairs(self.tableMainSingle)
			if self.isMainScrollShow then
				self:initMenuOnScroll()
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GUIDE_UPDATE", handler(self, self.initGuideMail))
	allianceLog:reqAllianceLogData()
	SoraDShowLoading(self)
end
function AllianceMainScroll:updateLogData(target, data)
	local logListData = allianceLog:getLogList()
	if data.msg == "MESSAGE_ALLIACNE_GET_LOG_SUCCESS" then
		for i, v in ipairs(logListData) do
			allianceLog, allianceLog = nil, nil
			;(nil).time = v.key
			;(nil).data, (nil).itemH = nil, 0
			;(nil).posY = 0
			;(nil).point = nil
			;(nil).canLoad = false
			table.insert(self.tableLogData, 1, nil)
			for logIndex, logData in ipairs(v.data) do
				allianceLog, allianceLog = nil, nil
				;(nil).log = logData
				;(nil).data, (nil).itemH = nil, 0
				;(nil).posY = 0
				;(nil).point = nil
				;(nil).canLoad = false
				table.insert(self.tableLogData, 1, nil)
			end
		end
		local maxCount = #self.tableLogData
		for i = maxCount, math.max(1, maxCount - LogLoadCountOnce + 1), -1 do
			self.tableLogData[i].canLoad = true
		end
	else
		local newTime = logListData[1].key
		local newLogData = logListData[1].data[1]
		if newLogData.tp == gALogType.NOTICE then
			for i, v in ipairs(self.tableLogData) do
				if v.data.log and v.data.log.tp == gALogType.NOTICE then
					if v.point then
						v.point:setVisible(false)
						table.insert(self.tableSpare.log, v.point)
					end
					table.remove(self.tableLogData, i)
					if self.tableLogData[i - 1] and self.tableLogData[i - 1].data.time and self.tableLogData[i] and self.tableLogData[i].data.time then
						if self.tableLogData[i].point then
							self.tableLogData[i].point:setVisible(false)
							table.insert(self.tableSpare.time, self.tableLogData[i].point)
						end
						table.remove(self.tableLogData, i)
					end
					break
				end
			end
		end
		if self.tableLogData[1] and self.tableLogData[#self.tableLogData].data.time == newTime then
			allianceLog, allianceLog = ipairs(v.data)
			ipairs(v.data).log = newLogData
			self.tableLogData[i].data, ipairs(v.data).itemH = ipairs(v.data)
			self.tableLogData[i].posY = 0
			self.tableLogData[i].point = nil
			self.tableLogData[i].canLoad = true
			table.insert(self.tableLogData, #self.tableLogData, self.tableLogData[i])
		elseif logListData[2] and self.tableLogData[#self.tableLogData].data.time == logListData[2].key or #logListData <= 1 then
			allianceLog, allianceLog = ipairs(v.data)
			ipairs(v.data).log = newLogData
			self.tableLogData[i].data, ipairs(v.data).itemH = ipairs(v.data)
			self.tableLogData[i].posY = 0
			self.tableLogData[i].point = nil
			self.tableLogData[i].canLoad = true
			table.insert(self.tableLogData, #self.tableLogData + 1, self.tableLogData[i])
			allianceLog, allianceLog = ipairs(v.data)
			ipairs(v.data).time = newTime
			self.tableLogData[i].data, ipairs(v.data).itemH = ipairs(v.data)
			self.tableLogData[i].posY = 0
			self.tableLogData[i].point = nil
			self.tableLogData[i].canLoad = true
			table.insert(self.tableLogData, #self.tableLogData + 1, self.tableLogData[i])
		else
			self.tableLogData[#self.tableLogData].data.time = newTime
			allianceLog, allianceLog = ipairs(v.data)
			ipairs(v.data).log = newLogData
			self.tableLogData[i].data, ipairs(v.data).itemH = ipairs(v.data)
			self.tableLogData[i].posY = 0
			self.tableLogData[i].point = nil
			self.tableLogData[i].canLoad = true
			table.insert(self.tableLogData, #self.tableLogData, self.tableLogData[i])
		end
	end
	if self.isMainScrollShow then
		self:initMenuOnScroll()
	else
		self:updateScrollSize(true)
		self:initLogOnScroll(true)
	end
	SoraDCloseLoading(self)
end
function AllianceMainScroll:isNeedShow(menuType)
	local isNeedShow = true
	local isShow = true
	if CheckShowMenuTable[menuType] and CheckShowMenuTable[menuType].checkFunc then
		isShow, isNeedShow = CheckShowMenuTable[menuType].checkFunc(menuType)
	end
	if menuType ~= ALLIANCE_MAIN_MENU_TYPE.BATTLE and SoraDGetCtrl("conquestWarCtrl"):isHelper() then
		isNeedShow = false
	end
	return isShow, isNeedShow
end
function AllianceMainScroll:initMenuOnScroll()
	local scrollH = 20
	local logListData = allianceLog:getLogList()
	local index = 1
	for i = 1, table.nums(ALLIANCE_MAIN_MENU_TYPE) do
		local singleType = ALLIANCE_MAIN_MENU_TYPE.LOG + (i - 1)
		local isShow, isBright = self:isNeedShow(singleType)
		if isShow then
			local menuSingle = self.tableMainSingle[index]
			if menuSingle == nil then
				menuSingle = SoraDCreatePanel("allianceMenuSingle")
				menuSingle:setTouchEventCallBack(handler(self, self.menuCallBack))
				menuSingle:setScroll(self.scroll)
				menuSingle:addTo(self.scroll)
			end
			menuSingle:initData(singleType)
			menuSingle:setBright(isBright)
			if index == 1 and logListData[1] then
				allianceLog = isBright
				isBright.log = logListData[1].data[1]
				isBright.time = logListData[1].key
				menuSingle:updateLogData(isBright, true)
				scrollH = scrollH + menuSingle:getSingleH() + 20
			elseif index % 2 == 0 then
				scrollH = scrollH + menuSingle:getSingleH()
			end
			self.tableMainSingle[index] = menuSingle
			index = index + 1
		else
		end
	end
	scrollH = math.max(scrollH, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	if 0 < offsetY then
		self.scroll:scrollToBottom(0.5, true)
	end
	for i, v in ipairs(self.tableMainSingle) do
		if i == 1 then
			v:setPosition(cc.p(320, scrollH))
			scrollH = scrollH - v:getSingleH()
		else
			local _h = math.ceil((i - 1) / 2)
			local _l = (i - 1) % 2 == 0 and 2 or (i - 1) % 2
			local posX = _l == 1 and 640 - v:getSingleW() / 2 - 18 or v:getSingleW() / 2 + 18
			v:setPosition(SoraDFPosX(posX), scrollH - (_h - 1) * v:getSingleH() - 20)
		end
	end
	self:initGuideMail()
end
function AllianceMainScroll:initGuideMail()
	local isShow = allianceGuideCtrl:getGuideStauts() == 0 or allianceGuideCtrl:getGuideStauts() == 1
	for k, v in ipairs(self.tableMainSingle) do
		if v.singleType == ALLIANCE_MAIN_MENU_TYPE.BUILD then
			local icon = SoraDGetChildByName(v, "icon_mail")
			if not icon then
				local x, y = SoraDGetChildByName(v, "Node_time"):getPosition()
				local node = SoraDGetChildByName(v, "Node_normal")
				icon = self:createMail()
				icon:setPosition(cc.p(SoraDFIsRA() and x - 30 or x + 30, y))
				icon:addTo(node, 30)
			end
			print("迁城引导", x, y, allianceGuideCtrl:getGuideStauts())
			icon:setVisible(isShow)
		end
	end
end
function AllianceMainScroll:createMail()
	icon = SoraDCreatAnimation("Node_GuideIcon_Mail", nil, true)
	icon:setName("icon_mail")
	return icon
end
function AllianceMainScroll:updateScrollSize(isAddNew)
	self.labelNotice:setVisible(self.tableLogData[1] and not self.tableLogData[1].canLoad)
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local noticeH = self.labelNotice:isVisible() and 60 or 0
	local scrollInnerNewH = 30 + noticeH
	local logSingle = SoraDCreatePanel("allianceLogSingle")
	logSingle:retain()
	local timeSingle = SoraDCreatePanel("allianceLogTimeSingle")
	timeSingle:retain()
	for i, v in ipairs(self.tableLogData) do
		if v.canLoad then
			if v.point then
				v.data.itemH = v.point:getSingleH()
				v.posY = scrollInnerNewH + v.data.itemH
				v.point:setPositionY(v.posY)
				if v.data.time then
					v.point:initData(v.data, false)
				end
			elseif v.data.itemH == 0 then
				local single
				if v.data.log then
					single = logSingle
				else
					single = timeSingle
				end
				single:initData(v.data, false)
				v.data.itemH = single:getSingleH()
				v.posY = scrollInnerNewH + v.data.itemH
			elseif v.data.itemH ~= 0 then
				v.posY = scrollInnerNewH + v.data.itemH
			end
			scrollInnerNewH = v.posY
		end
	end
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableLogData) do
			v.posY = v.posY + upto
			if v.point then
				v.point:setPositionY(v.posY)
			end
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	if isAddNew then
		offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	end
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	logSingle:release()
	timeSingle:release()
	self.labelNotice:setString(i18n("common_text_089"))
end
function AllianceMainScroll:initLogOnScroll(isUpdate)
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableLogData) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				if v.data.log then
					table.insert(self.tableSpare.log, v.point)
				else
					table.insert(self.tableSpare.time, v.point)
				end
				v.point:setVisible(false)
				v.point = nil
			elseif isUpdate then
				v.point:setPositionY(v.posY)
			end
		elseif v.canLoad and tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			local singleType, single, pointTable
			if v.data.log then
				singleType = "allianceLogSingle"
				pointTable = self.tableSpare.log
			else
				singleType = "allianceLogTimeSingle"
				pointTable = self.tableSpare.time
			end
			if 0 < #pointTable then
				single = table.remove(pointTable)
				single:setVisible(true)
			else
				single = SoraDCreatePanel(singleType)
				single:setScroll(self.scroll)
				single:setTouchEventCallBack(handler(self, self.logCallBack))
				single:addTo(self.scroll)
			end
			single:initData(v.data, false)
			single:setPosition(cc.p(320, v.posY))
			v.point = single
		end
	end
	if offsetY < -50 and self.labelNotice:isVisible() then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
	end
end
function AllianceMainScroll:scrollEventCallBack(target, event)
	if self.btnClose:isVisible() then
		if event == ccui.ScrollviewEventType.containerMoved then
			self:initLogOnScroll()
		elseif event == ccui.ScrollviewEventType.bounceBottom then
			if self.fromLoadText then
				SoraDShowLoading(self)
				local loadCount = 1
				for i = #self.tableLogData, 1, -1 do
					if not self.tableLogData[i].canLoad then
						self.tableLogData[i].canLoad = true
						loadCount = loadCount + 1
						if loadCount >= LogLoadCountOnce and self.tableLogData[i].data.log then
							break
						end
					end
				end
				self:updateScrollSize(true)
				self.labelNotice:setVisible(false)
				self.fromLoadText = false
			end
			self:initLogOnScroll()
			SoraDCloseLoading(self)
		end
	end
end
local reportAllianceControl2Firebase = function(...)
	userSDKManager.report2firebase("reportAlliance")
end
function AllianceMainScroll:menuCallBack(type)
	reportAllianceControl2Firebase()
	reportAllianceControl2Firebase = reportAllianceControl2Firebase
	reportAllianceControl2Firebase[ALLIANCE_MAIN_MENU_TYPE.BUILD] = true
	reportAllianceControl2Firebase[ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE] = true
	local reportAllianceControl2Firebase[ALLIANCE_MAIN_MENU_TYPE.ACTIVE], checkList = true, reportAllianceControl2Firebase
	if ALLIANCE_MAIN_MENU_TYPE.HUNT then
		checkList[ALLIANCE_MAIN_MENU_TYPE.HUNT] = true
	end
	if checkList[type] and not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	if type == ALLIANCE_MAIN_MENU_TYPE.LOG then
		self:showLog()
	elseif type == ALLIANCE_MAIN_MENU_TYPE.STORE then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("AllianceShopView")
		else
			SoraDCreatePanel("allianceShopView"):show()
		end
	elseif type == ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
		if tonumber(depotBcell.info.lv) >= DEPOT_LV_ALLIANCE_TRRASURE then
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
			if isInConquestWar then
				SoraDShowMsgBox(i18n("common_text_2166"), i18n("common_text_204"))
			else
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("allianceStoreHouseView")
				else
					SoraDCreatePanel("allianceStoreHouseView"):show()
				end
				reportAllianceControl2Firebase = "allianceStoreHouseView"
				;("allianceStoreHouseView").position = 2
				userSDKManager.logEvent(gSDKDef.TDonEvent.click_alliance_treasure, "allianceStoreHouseView")
			end
		else
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			reportAllianceControl2Firebase = "allianceStoreHouseView"
			;("allianceStoreHouseView").bid = BUILDID.DEPOT
			;("allianceStoreHouseView").lv = DEPOT_LV_ALLIANCE_TRRASURE
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, "allianceStoreHouseView")
		end
	elseif type == ALLIANCE_MAIN_MENU_TYPE.SCIENCE then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("AllianceScience")
		else
			SoraDCreatePanel("allianceScienceView"):show()
		end
	elseif type == ALLIANCE_MAIN_MENU_TYPE.BATTLE then
		uiManager:show("AllianceWarView")
	elseif type == ALLIANCE_MAIN_MENU_TYPE.HELP then
		uiManager:show("EmbassyView")
	elseif type == ALLIANCE_MAIN_MENU_TYPE.MESSAGE then
		local allianceId = allianceMgr:getOwnAid()
		reportAllianceControl2Firebase = "EmbassyView"
		;("EmbassyView").allianceId = allianceId
		SoraDCreateAllianceChatView("EmbassyView")
	elseif type == ALLIANCE_MAIN_MENU_TYPE.BUILD then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("AllianceBuildView")
		else
			SoraDCreatePanel("allianceBuildView"):show()
		end
	elseif type == ALLIANCE_MAIN_MENU_TYPE.STRONGPOINT then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("AllianceStrongPoint")
		else
			SoraDCreatePanel("allianceStrongPointView"):show()
		end
	elseif type == ALLIANCE_MAIN_MENU_TYPE.COUNTER_SYS then
		uiManager:show("AllianceCounterSysView")
	elseif type == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_TASK then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY, 3)
	elseif type == ALLIANCE_MAIN_MENU_TYPE.PET then
		local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
		local state = alliancePetCtrl:getAlliancePetState()
		if state == gAlliancePetState.CALL then
			local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
			if callTimeCD <= 0 then
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("AlliancePetSelect")
				else
					SoraDCreatePanel("alliancePetSelectView"):show()
				end
			elseif GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("AlliancePetReduceTime")
			else
				SoraDCreatePanel("alliancePetReduceTimeView"):show()
			end
		elseif GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("AlliancePetMainView")
		else
			SoraDCreatePanel("alliancePetMainView"):show()
		end
	elseif type == ALLIANCE_MAIN_MENU_TYPE.HUNT then
		if SoraDGetCastleLv() < ALLIANCE_HUNT_CASTLE_LV_MIN then
			reportAllianceControl2Firebase = SoraDCreatePanel("alliancePetMainView")
			SoraDCreatePanel("alliancePetMainView").num = 4
			SoraDShowMsgTip(i18n("common_text_1795", (SoraDCreatePanel("alliancePetMainView"))))
		elseif GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceHuntView")
		else
			SoraDCreatePanel("allianceHuntView"):show()
		end
	elseif type == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceActiveView")
		else
			SoraDCreatePanel("allianceActiveView"):show()
		end
	elseif type == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_WAREHOUSE then
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
		if isInConquestWar then
			SoraDShowMsgBox(i18n("common_text_2166"), i18n("common_text_204"))
		elseif GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceWarehouseView")
		else
			SoraDCreatePanel("allianceWarehouseView"):show()
		end
	else
		print("联盟其他模块")
	end
end
function AllianceMainScroll:logCallBack(data)
	if data.tp == gALogType.CITY_PLUNDER or data.tp == gALogType.RES_POINT_PLUNDER or data.tp == gALogType.ALLIANCE_BUILD_BE_ATTACKED or data.tp == gALogType.ALLIANCE_BUILD_BE_MASSED or data.tp == gALogType.SET_BUILDING or data.tp == gALogType.ALLIANCE_BEAST_CALL or data.tp == gALogType.ALLIANCE_TRIAL_BEAST or data.tp == gALogType.ALLIANCE_KILL_BEAST then
		local pos = data.data.pos
		local jumppos = cc.p(tonumber(pos.x), tonumber(pos.y))
		SoraDGotoWorldMapPoint(jumppos, true)
		SoraDRemoveAllPanelFromManager()
	elseif data.tp == gALogType.TECHNOLOGY_REACH then
		self:showMenu()
		if GLOBAL_GAME_ALLIANCE_MODE then
			_ENV = jumppos
			jumppos.sid = data.data.tech
			uiManager:show("AllianceScience", jumppos)
		else
			local panel = SoraDCreatePanel("allianceScienceView")
			panel:jumpToSicence(data.data.tech)
			panel:show()
		end
	elseif data.tp == gALogType.NOTICE then
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank >= gAllianceRank.R4 then
			SoraDCreatePanel("allianceChangeNoticeView"):show()
		end
	elseif data.tp == gALogType.DEL_ALLIANE_BWLIST or data.tp == gALogType.ADD_ALLIANCE_BWLIST then
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank >= gAllianceRank.R4 then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceBlackWhiteView")
			else
				SoraDCreatePanel("allianceBlackWhiteView"):show()
			end
		end
	end
end
function AllianceMainScroll:showMenu()
	for i, v in ipairs(self.tableLogData) do
		if v.point then
			local pointTable
			if v.data.log then
				pointTable = self.tableSpare.log
			else
				pointTable = self.tableSpare.time
			end
			table.insert(pointTable, v.point)
			v.point:setVisible(false)
			v.point = nil
			v.posY = 0
		end
	end
	self.labelNotice:setVisible(false)
	self.btnClose:setVisible(false)
	self.scroll:setContentSize(cc.size(640, self:getPanelOffsetHeight() - 420))
	self:initMenuOnScroll()
	self.scroll:jumpToTop()
	self.isMainScrollShow = true
	if self.handle then
		self.handle(self.isMainScrollShow)
	end
end
function AllianceMainScroll:setHandle(handle)
	self.handle = handle
end
function AllianceMainScroll:showLog()
	for i, v in ipairs(self.tableMainSingle) do
		v:removeFromParent()
	end
	self.tableMainSingle, _ENV = ipairs(self.tableMainSingle)
	self.btnClose:setVisible(true)
	self.scroll:setContentSize(cc.size(640, self:getPanelOffsetHeight() - 400))
	self.btnClose:setPositionY(-(self:getPanelOffsetHeight() - 397))
	self:updateScrollSize()
	self.scroll:jumpToTop()
	self:initLogOnScroll()
	self.isMainScrollShow = false
	if self.handle then
		self.handle(self.isMainScrollShow)
	end
end
function AllianceMainScroll:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:showMenu()
	end
end
return AllianceMainScroll
