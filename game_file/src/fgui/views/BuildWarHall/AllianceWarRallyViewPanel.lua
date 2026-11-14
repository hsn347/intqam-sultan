local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local queueTimeUtil = include("queueTimeUtil")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local kingdomMapUtil = include("kingdomMapUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceWarRallyViewPanel = class("AllianceWarRallyViewPanel", baseFguiPanel)
function AllianceWarRallyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AllianceWarRallyViewPanel:ctor", self.viewName)
end
function AllianceWarRallyViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWatchTower"
	end
	return self._packageList
end
function AllianceWarRallyViewPanel:onInit()
	print("=======AllianceWarRallyViewPanel:onInit")
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
		self.fields.nodeMass2:setPositionX(self.fields.nodeMass2:getParent():getSize().width - self.fields.nodeMass2:getX() - self.fields.nodeMass2:getWidth())
	end
	_ENV, self.tableSingleIndex, _ENV, self.tableSingle, _ENV, self.tableMainData, _ENV, self.indexID = self.fields.nodeMass2.setPositionX, self.fields.nodeMass2.setPositionX, self.fields.nodeMass2.setPositionX, self.fields.nodeMass2.setPositionX, self.fields.nodeMass2.setPositionX, self.fields.nodeMass2.setPositionX, self.fields.nodeMass2.setPositionX, nil
	self.fields.nodeMass2.setPositionX.x = 0
	self.leaderPos, self.fields.nodeMass2.setPositionX.y = self.fields.nodeMass2.setPositionX, 0
	self.timer = nil
	self.isCaptain = false
	self.isAttacker = false
	self.viewType = gAWarViewMemberType.NONE
	self.ownId = nil
	self.isSelfIn = false
	self.ownTeam = false
	self.massNum = 0
	self.maxMassNum = 0
	self.init = true
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.nodeTitle = self.fields.Com_title
	self.labelState = self.fields.labelState
	self.labelName = self.fields.Text_name
	self.labelRealName = self.fields.Text_realName
	self.labelMemeber = self.fields.Text_memeber
	self.labelMemberValue = self.fields.Text_memberValue
	self.Node_distance = self.fields.Node_distance
	self.labelDistance = self.fields.Text_distance
	self.laeblMiles = self.fields.Text_realMiles
	self.nodeTime = self.fields.nodeTime
	if not SoraDFIsRA() then
		self.fields.nodeTime:fixChildrenPos()
	end
	self.imgTitleBg = self.fields.imgTitleBg
	self.labelPos = self.fields.Text_pos
	_ENV = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_2588")
	self.labelPos:setString(i18n("common_text_1915", handler(self, self.onClickClose)))
	self.btnPos = self.fields.Button_pos
	self.btnPos:setTouchEnabled(true)
	local tabbatFields = fguiHelper.get_fields(self.fields.tabbar)
	if not SoraDFIsRA() then
	end
	self.labelTroops = tabbatFields.Text_troops
	self.labelTime = fguiHelper.get_fields(self.fields.nodeTime).txtTitle
	self.nodeTarget = self.fields.nodeTarget
	self.scroll = self.fields.scroll
	self.btnDissolve = self.fields.Button_dissolve
	self.btnDissolve:addClickEventListener(handler(self, self.btnClickCallBack))
	self.btnPos:addEventListener(fgui.UIEventType.Click, handler(self, self.btnJumpClickCallBack))
	self.nodeMass = self.fields.Node_mass
	local textTitle = self.fields.Text_title_mass
	textTitle:setString(i18n("common_text_4524") .. ":")
	self.Node_lv = self.fields.Node_lv
	self.Node_lv:setVisible(false)
	self.Text_lv = self.fields.Text_lv
	self.node_milltary = tabbatFields.node_milltary
	self.btnMilitary = tabbatFields.Button_Military
	self.btnMilitary:addEventListener(fgui.UIEventType.Click, handler(self, self.btnClickMilitary))
	self.node_milltary:setVisible(false)
	self.textMilitary = tabbatFields.Text_ButtonDetail
	_ENV = handler(self, self.btnClickMilitary)
	_ENV, _ENV, handler(self, self.btnClickMilitary).commonStr = "fortress_name_01", i18n("fortress_name_01"), i18n("fortress_name_01")
	;("fortress_name_01").c = "true"
	i18n("fortress_name_01").commonStr, ("fortress_name_01").u = "fortress_name_01", "true"
	self.textMilitary:setString(i18n_html("common_text_034", handler(self, self.btnClickMilitary)))
	self.fields.scroll:setVirtual()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function AllianceWarRallyViewPanel:onShow()
	print("=======AllianceWarRallyViewPanel:onShow")
	_ENV, self.tableSingleIndex, _ENV, self.tableSingle, _ENV, self.tableMainData, _ENV, self.indexID = print, print, print, print, print, print, print, nil
	print.x = 0
	self.leaderPos, print.y = print, 0
	self.timer = nil
	self.isCaptain = false
	self.isAttacker = false
	self.viewType = gAWarViewMemberType.NONE
	self.ownId = nil
	self.isSelfIn = false
	self.ownTeam = false
	self.massNum = 0
	self.maxMassNum = 0
	self.init = true
	self.fields.scroll:setNumItems(0)
end
function AllianceWarRallyViewPanel:updateDataRefresh(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if self.indexID then
		local warMainData = self.queueRoot:getWarHallData(self.indexID)
		if not warMainData or not next(warMainData) then
			self:close()
		else
			self:initData(self.indexID)
		end
	else
		self:close()
	end
end
function AllianceWarRallyViewPanel:updateDelete(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if data.indexID == self.indexID then
		local warMainData = self.queueRoot:getWarHallData(self.indexID)
		if not warMainData or not next(warMainData) then
			self:close()
		else
			self:initData(self.indexID)
		end
	end
end
function AllianceWarRallyViewPanel:updateView(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if data.indexID == self.indexID then
		self:initData(self.indexID)
	end
end
function AllianceWarRallyViewPanel:initData(indexID, rallyData, queueRoot)
	print("mly1", indexID)
	self.indexID = indexID
	self:resetSingle()
	if queueRoot then
		self.queueRoot = queueRoot
		if self.queueRoot:isWarQueueRoot() then
			self.nodeTitle:updateTitle(i18n("brightWar_text_21"))
		elseif worldMapDefine.isInTeamStatus() then
			self.nodeTitle:updateTitle(i18n("free_team_text_47"))
		else
			self.nodeTitle:updateTitle(i18n("common_text_047"))
		end
	elseif not self.queueRoot then
		self.queueRoot = kingdomMapCtrl:getQueueRootByWar()
	end
	self.isWar = self.queueRoot:isWarQueueRoot()
	self.init = true
	if rallyData then
		self.tableMainData = rallyData
	else
		local warMainData = self.queueRoot:getWarHallData(self.indexID)
		if warMainData and warMainData.queues and next(warMainData.queues) then
			local index, queue = next(warMainData.queues)
			if index and queue then
				self.tableMainData = queue
			end
		end
	end
	if not self.tableMainData or next(self.tableMainData) == nil then
		self:close()
		return
	end
	self.nodeTarget:initData(self.tableMainData.to, self.tableMainData)
	local uid = lordInfoCtrl:getLordInfo().base.uid
	self.isSelfIn = false
	self.maxMassNum = 0
	local fromAid = self.tableMainData:getAid()
	local selfAid = self.queueRoot:getOwnTeamID()
	local targetData = self:getShowTarget()
	local toAid = kingdomMapUtil.getTargetAid(targetData, fromAid, selfAid)
	if fromAid == selfAid then
		if fromAid == toAid then
			self.imgTitleBg:setColor(cc.c3b(39, 59, 70))
			self.labelState:setColor(cc.c3b(62, 170, 238))
		else
			self.imgTitleBg:setColor(cc.c3b(108, 53, 47))
			self.labelState:setColor(cc.c3b(224, 43, 43))
		end
		self.labelState:setString(i18n("common_text_292"))
		self.maxMassNum = self.tableMainData.maxMassNum
		local memberAttackQueue = self.queueRoot:getMassQueuesAttackQueues(self.tableMainData)
		if uid == self.tableMainData.from.uid then
			self.isCaptain = true
			self.isSelfIn = true
			if self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
				self.viewType = gAWarViewMemberType.ATTACKER
			else
				self.viewType = gAWarViewMemberType.NONE
			end
		else
			for _, v in ipairs(memberAttackQueue) do
				if v.uid == uid then
					self.isSelfIn = true
					break
				end
			end
		end
		self:initScrollData(memberAttackQueue, true)
		self:showInfo(self.tableMainData.from, memberAttackQueue)
		self.nodeMass:setVisible(true)
		self.Node_lv:setVisible(true)
		if self.isSelfIn then
			self.node_milltary:setVisible(SoraDIsMilitaryFOpen())
		end
	elseif toAid == selfAid then
		self.node_milltary:setVisible(false)
		self.imgTitleBg:setColor(cc.c3b(39, 59, 70))
		self.labelState:setColor(cc.c3b(55, 180, 190))
		self.labelState:setString(i18n("common_text_041"))
		self.maxMassNum = self.tableMainData.maxHelpNum
		local memberDefendQueue = self.queueRoot:getMassQueuesDefendQueues(self.tableMainData)
		self.isSelfIn = self.tableMainData.to.uid == uid
		if self.tableMainData.to.objType ~= gMapObjTypeDef.mapObjTypePlayer or uid ~= self.tableMainData.to.uid then
			self.viewType = gAWarViewMemberType.ALLY
			for _, v in ipairs(memberDefendQueue) do
				if v.uid == uid then
					self.viewType = gAWarViewMemberType.HELPER
					if v:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
						self.ownId = v.id
					else
						self.ownId = nil
					end
					self.isSelfIn = true
					break
				end
			end
			self.isCaptain = false
		else
			self.viewType = gAWarViewMemberType.DEFENDER
			self.isCaptain = true
			self.isSelfIn = true
		end
		self:showInfo(self.tableMainData.to, memberDefendQueue)
		self.nodeMass:setVisible(false)
		self.Node_lv:setVisible(false)
		self:initScrollData(memberDefendQueue, false)
	end
	self:updateBottomBtn()
	self:updateScrollView()
	self:updateMemberNum()
	self:updateMemberColor()
	_ENV = self
	self.msg = "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE"
	self.massNum = self.massNum
	self.maxMassNum = self.maxMassNum
	SoraDSendMessage(self)
	self:initMassView()
	self:refreshArmyForbidLvText()
	self:showQueue()
	self.init = false
end
function AllianceWarRallyViewPanel:updateBottomBtn()
	local isBottomVisible = false
	if self.viewType ~= gAWarViewMemberType.NONE then
		if self.viewType == gAWarViewMemberType.ATTACKER then
			isBottomVisible = true
			self.btnDissolve:setTitle(i18n("common_text_301"))
			self.btnDissolve:setBtnColorIndex(1)
		elseif self.viewType == gAWarViewMemberType.HELPER then
			isBottomVisible = self.ownId and true or false
			self.btnDissolve:setTitle(i18n("common_text_302"))
			self.btnDissolve:setBtnColorIndex(0)
		elseif self.viewType == gAWarViewMemberType.ALLY then
			isBottomVisible = true
			self.btnDissolve:setTitle(i18n("common_text_010"))
			self.btnDissolve:setBtnColorIndex(2)
		elseif self.viewType == gAWarViewMemberType.DEFENDER then
			isBottomVisible = true
			self.btnDissolve:setTitle(i18n("common_text_916"))
			self.btnDissolve:setBtnColorIndex(0)
		end
	end
	self:updateBottomBtnStatus(isBottomVisible)
end
function AllianceWarRallyViewPanel:updateBottomBtnStatus(isBottomVisible)
	self.controllers.c1:setSelectedIndex(isBottomVisible and 0 or 1)
end
function AllianceWarRallyViewPanel:showQueue()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function AllianceWarRallyViewPanel:openTimeUp(dt)
	local leftTime = queueTimeUtil.getRemainTime(self.tableMainData)
	local totalTime = queueTimeUtil.getTotalTime(self.tableMainData)
	local statusLabel
	if self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeMoving then
		if self.isAttacker then
			queueTimeUtil = nil
			;(nil).time = SoraDConvertSecondToString(leftTime)
			statusLabel = i18n("common_text_295", nil)
		else
			queueTimeUtil = nil
			;(nil).time = SoraDConvertSecondToString(leftTime)
			statusLabel = i18n("common_text_915", nil)
		end
	elseif self.isAttacker then
		queueTimeUtil = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		statusLabel = i18n("common_text_293", nil)
	else
		queueTimeUtil = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		statusLabel = i18n("common_text_914", nil)
	end
	self.labelTime:setString(statusLabel)
	self.nodeTime:setPercent((totalTime - leftTime) / totalTime)
	if leftTime < 1 and self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeMoving then
		self:close()
	end
end
function AllianceWarRallyViewPanel:initScrollData(warQueues, isAttack)
	local ownuid = lordInfoCtrl:getLordInfo().base.uid
	self.isAttacker = isAttack
	self.ownTeam = false
	local massNum = 0
	if self.isAttacker or self.tableMainData.to.objType == gMapObjTypeDef.mapObjTypePlayer then
		for _, v in ipairs(warQueues) do
			if v.uid == ownuid then
				self.ownTeam = true
				break
			end
		end
	end
	if self.isAttacker then
		for i, v in ipairs(warQueues) do
			local key = v.id
			if key then
				lordInfoCtrl = nil
				lordInfoCtrl, (nil).point = nil, nil
				;(nil).data = v.from
				;(nil).queue = v
				;(nil).ownTeam = self.ownTeam
				;(nil).isCaptain = self.isCaptain
				;(nil).teamStatus = self.viewType
				;(nil).isSelfIn = self.isSelfIn
				;(nil).data, (nil).mainStatus = nil, self.tableMainData.status
				;(nil).type = gAWarRallyMemberType.FULL
				;(nil).key = v.id
				;(nil).singleH = 120
				local (nil).posY, data = 0, nil
				local oldData = self.tableSingle[key]
				if oldData then
					data.point = oldData.point
				end
				self.tableSingle[key] = data
				table.insert(self.tableSingleIndex, 1, key)
				if 1 < i then
					massNum = massNum + v.totalNum
				end
			end
		end
		if not self.isWar then
			local totalMember = allianceMgr:getAllianceBattlePeopleCount()
			if self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally then
				self:createOhterCell("firstOne", totalMember <= #warQueues and gAWarRallyMemberType.NO_SPACE or gAWarRallyMemberType.OPEN)
			end
			if totalMember == #warQueues then
				self:createOhterCell("lastOne", gAWarRallyMemberType.LOCK)
			end
		end
	else
		for i, v in ipairs(warQueues) do
			if 1 < i then
				local key = v.id
				if key then
					lordInfoCtrl = nil
					lordInfoCtrl, (nil).point = self.tableSingle[key], nil
					self.tableSingle[key].data = v.from
					self.tableSingle[key].queue = v
					self.tableSingle[key].ownTeam = self.ownTeam
					self.tableSingle[key].isCaptain = self.isCaptain
					self.tableSingle[key].teamStatus = self.viewType
					;(nil).data, self.tableSingle[key].mainStatus = self.tableSingle[key], self.tableMainData.status
					;(nil).type = gAWarRallyMemberType.FULL
					;(nil).key = v.id or self.tableMainData.id
					;(nil).isSelfIn = self.isSelfIn
					;(nil).singleH = 120
					local (nil).posY, data = 0, nil
					local oldData = self.tableSingle[key]
					if oldData then
						data.point = oldData.point
					end
					self.tableSingle[key] = data
					table.insert(self.tableSingleIndex, 1, key)
					if 1 < i then
						massNum = massNum + v.totalNum
					end
				end
			end
		end
	end
	self.massNum = massNum
	self:updateTroopsNum(massNum, self.maxMassNum)
end
function AllianceWarRallyViewPanel:createOhterCell(key, singleType)
	queueTimeUtil = nil
	queueTimeUtil, (nil).point = nil, nil
	;(nil).data = self.tableMainData.from
	;(nil).ownTeam = self.ownTeam
	;(nil).teamStatus = self.viewType
	;(nil).id = self.tableMainData.id
	;(nil).mainObjType = self.tableMainData.to.objType
	;(nil).mainObjId = self.tableMainData.to.objId
	;(nil).isManuPlace = self.tableMainData.to.isManuPlace
	;(nil).massSlaveForbidArmyClass = self.tableMainData:getMassSlaveForbidArmyClass()
	;(nil).massSlaveArmyMinLv = self.tableMainData:getMassSlaveArmyMinLv()
	;(nil).massSlaveArmyMinNum = self.tableMainData:getMassSlaveArmyMinNum()
	;(nil).massSlaveArmyMaxNum = self.tableMainData:getMassSlaveArmyMaxNum()
	;(nil).isForbidSpeed = self.tableMainData:getIsForbidSpeed()
	;(nil).endTime = queueTimeUtil.getFinishTime(self.tableMainData)
	;(nil).isSelfIn = self.isSelfIn
	;(nil).data, (nil).attr = nil, self.tableMainData.attr
	;(nil).type = singleType
	;(nil).key = nil
	;(nil).singleH = 120
	local (nil).posY, data = 0, nil
	local oldData = self.tableSingle[key]
	if oldData then
		data.point = oldData.point
	end
	self.tableSingle[key] = data
	if key == "lastOne" then
		table.insert(self.tableSingleIndex, 1, key)
	else
		table.insert(self.tableSingleIndex, key)
	end
end
function AllianceWarRallyViewPanel:scrollOnScrollView()
end
function AllianceWarRallyViewPanel:onItemRenderer(index, obj)
	local key = self.tableSingleIndex[#self.tableSingleIndex - index]
	local v = self.tableSingle[key]
	if v then
		obj:initData(v.data, v.type, index, self.lanuchedIndexs[index])
	else
		obj:initData(nil, gAWarRallyMemberType.CLOSED, index, self.lanuchedIndexs[index])
	end
	obj:setClickCallBack(handler(self, self.updateScrollView))
end
function AllianceWarRallyViewPanel:updateScrollView(index, isLaunched)
	if not self.lanuchedIndexs then
		_ENV = self.lanuchedIndexs
	end
	self.lanuchedIndexs = self.lanuchedIndexs
	if index ~= nil then
		local key = self.tableSingleIndex[#self.tableSingleIndex - index]
		local v = self.tableSingle[key]
		self.lanuchedIndexs[index] = v and v.type == gAWarRallyMemberType.FULL and isLaunched
	end
	self.fields.scroll:setNumItems(#self.tableSingleIndex)
	if index ~= nil then
		self.fields.scroll:scrollToView(index)
	end
end
function AllianceWarRallyViewPanel:showInfo(mainData)
	_ENV = nil
	;(nil).name = ""
	self.labelName:setString(i18n("common_text_650", nil))
	self.labelRealName:setString(mainData.name)
	self.labelMemeber:setString(i18n("common_text_651"))
	_ENV = i18n("common_text_651")
	i18n("common_text_651").x = mainData.x
	i18n("common_text_651").y = mainData.y
	self.btnPos:setString(i18n("common_text_2155", i18n("common_text_651")))
	self.leaderPos.x = mainData.x
	self.leaderPos.y = mainData.y
	self.labelDistance:setString(i18n("common_text_4295"))
	local ownuid = lordInfoCtrl:getLordInfo().base.uid
	if ownuid == mainData.uid then
		self.Node_distance:setVisible(false)
		self.nodeMass:setPositionY(self.Node_distance:getPositionY())
		self.Node_lv:setPositionY(self.nodeMass:getPositionY() + 40)
	else
		self.Node_distance:setVisible(true)
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local myCityTilePoint = cityCtrl:getCurCityPos()
		local miles = cc.pGetDistance(myCityTilePoint, cc.p(mainData.x, mainData.y))
		_ENV = cc.p(mainData.x, mainData.y)
		cc.p(mainData.x, mainData.y).distance = math.ceil(miles)
		self.laeblMiles:setString(i18n("common_text_489", cc.p(mainData.x, mainData.y)))
		self.nodeMass:setPositionY(self.Node_distance:getPositionY() + 40)
		self.Node_lv:setPositionY(self.nodeMass:getPositionY() + 40)
	end
end
function AllianceWarRallyViewPanel:btnJumpClickCallBack(button, type)
	SoraDPlaySound()
	if SoraDGotoWorldMapPoint(cc.p(self.leaderPos.x, self.leaderPos.y), true, self.tableMainData:getMapID()) then
		SoraDRemoveAllPanelFromManager()
	end
end
function AllianceWarRallyViewPanel:btnClickCallBack(button, type)
	SoraDPlaySound()
	if self.viewType == gAWarViewMemberType.ATTACKER then
		kingdomMapCtrl:reqBackQueueById(self.tableMainData.id)
	elseif self.viewType == gAWarViewMemberType.HELPER then
		if self.ownId then
			kingdomMapCtrl:reqBackQueueById(self.ownId)
		end
	elseif self.viewType == gAWarViewMemberType.ALLY then
		if worldMapDefine.isInAtlantis() then
			local atlantisWarUtil = include("atlantisWarUtil")
			local point = cc.p(self.tableMainData.to.x, self.tableMainData.to.y)
			if not atlantisWarUtil.checkCanJoinMass(point, true) then
				return
			end
		end
		if worldMapDefine.isLegendMapId(gametop.playertop_:getMapID()) and SoraDGetCtrl("legendTeamCtrl"):isTeamCommander() then
			SoraDShowMsgTip(i18n("legendary_commander_text26"))
			return
		end
		if not kingdomMapCtrl:hasArmyHelpQueue2Player(self.tableMainData.to.uid) then
			local instanceID = self.tableMainData.to.id
			if self.tableMainData.to.objType == gMapObjTypeDef.mapObjTypeAllianceBuild then
				if kingdomMapCtrl:hasArmyHelpQueue2Object(instanceID) then
					SoraDShowMsgTip(i18n("common_text_704"))
				elseif SoraDEnoughTroops() then
					local endPoint = cc.p(self.tableMainData.to.x, self.tableMainData.to.y)
					local instanceType = gMapObjTypeDef.mapObjTypeAllianceBuild
					local dispatchPanel = uiManager:show("WorldDispatchArmyView")
					_ENV = uiManager
					uiManager.massSlaveForbidArmyClass = self.tableMainData:getMassSlaveForbidArmyClass()
					uiManager.massSlaveArmyMinLv = self.tableMainData:getMassSlaveArmyMinLv()
					uiManager.massSlaveArmyMinNum = self.tableMainData:getMassSlaveArmyMinNum()
					uiManager.massSlaveArmyMaxNum = self.tableMainData:getMassSlaveArmyMaxNum()
					local uiManager.isForbidSpeed, otherData = self.tableMainData:getIsForbidSpeed(), uiManager
					local dispatchType = worldMapDefine.worldMapTipButtonType_xiefang
					_ENV = i18n("common_text_704")
					i18n("common_text_704").maxCount = self.maxCount
					i18n("common_text_704").toPoint = endPoint
					i18n("common_text_704").dispatchType = dispatchType
					i18n("common_text_704").instanceID = instanceID
					i18n("common_text_704").otherData = otherData
					i18n("common_text_704").isJoinMass = true
					i18n("common_text_704").instanceType = instanceType
					dispatchPanel:initData(i18n("common_text_704"))
				end
			else
				_ENV = cc.p(self.tableMainData.to.x, self.tableMainData.to.y)
				cc.p(self.tableMainData.to.x, self.tableMainData.to.y).uid = self.tableMainData.to.uid
				cc.p(self.tableMainData.to.x, self.tableMainData.to.y).dispatchType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
				local cc.p(self.tableMainData.to.x, self.tableMainData.to.y).instanceID, cityArmyData = instanceID, cc.p(self.tableMainData.to.x, self.tableMainData.to.y)
				_ENV = worldMapDefine.worldMapTipButtonType_xiefang
				worldMapDefine.worldMapTipButtonType_xiefang.cityArmyData = cityArmyData
				uiManager:show("ReinforcementsMsgBox", worldMapDefine.worldMapTipButtonType_xiefang)
			end
		else
			SoraDShowMsgTip(i18n("common_text_704"))
		end
	elseif self.viewType == gAWarViewMemberType.DEFENDER then
		local memberDefend = self.queueRoot:getMassQueuesDefendQueues(self.tableMainData)
		local _ENV, queueIds = self.queueRoot, self.queueRoot
		for i, v in ipairs(memberDefend) do
			if 1 < i then
				table.insert(queueIds, v.id)
			end
		end
		kingdomMapCtrl:reqBackAllQueue(queueIds)
	end
end
function AllianceWarRallyViewPanel:btnClickMilitary(button, type)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("assembleFortressBuffView")
	dump(self.tableMainData, "tableMainData")
	panel:initData(self.indexID, self.tableMainData)
	panel:show()
end
function AllianceWarRallyViewPanel:updateMemberColor()
	if self.tableMainData.from.aid == self.queueRoot:getOwnTeamID() then
		if self.isSelfIn then
			self.labelMemberValue:setColor(cc.c3b(112, 199, 35))
		elseif self.tableMainData.from.aid == self.tableMainData.to.aid then
			self.labelMemberValue:setColor(cc.c3b(39, 59, 70))
		else
			self.labelMemberValue:setColor(cc.c3b(224, 43, 43))
		end
	elseif self.tableMainData.to.aid == self.queueRoot:getOwnTeamID() then
		if self.isSelfIn then
			self.labelMemberValue:setColor(cc.c3b(112, 199, 35))
		else
			self.labelMemberValue:setColor(cc.c3b(62, 170, 238))
		end
	end
end
function AllianceWarRallyViewPanel:updateMemberNum()
	local memberNum = 0
	for _, v in pairs(self.tableSingle) do
		if v.type == gAWarRallyMemberType.FULL then
			memberNum = memberNum + 1
		end
	end
	self.labelMemberValue:setString(tostring(memberNum))
end
function AllianceWarRallyViewPanel:updateTroopsNum(cur, max)
	if max <= 0 then
		max = cur
	elseif cur > max then
		cur = max
	end
	_ENV = nil
	;(nil).cur = cur
	;(nil).max = max
	self.labelTroops:setString(i18n("common_text_296", nil))
end
function AllianceWarRallyViewPanel:resetSingle()
	self.tableSingleIndex, _UPVALUE0_ = nil, nil
end
function AllianceWarRallyViewPanel:getShowTarget()
	if self.tableMainData:isTargetCapture() then
		local queuesFix = self.queueRoot:getWorkingCaptainQueue(self.tableMainData)
		if queuesFix then
			return queuesFix:getFrom()
		end
	end
	return self.tableMainData.to
end
function AllianceWarRallyViewPanel:initMassView()
	local massSlaveForbidArmyClass = self.tableMainData:getMassSlaveForbidArmyClass()
	for i = 4, 1, -1 do
		local node = self.fields["spriteMass" .. i]
		if node then
			if massSlaveForbidArmyClass and massSlaveForbidArmyClass[tostring(i)] then
				node:setVisible(false)
			else
				node:setVisible(true)
			end
		end
	end
	local minNum = self.tableMainData:getMassSlaveArmyMinNum()
	local maxNum = self.tableMainData:getMassSlaveArmyMaxNum()
	self.fields.Text_armyLimit:setString(i18n("common_text_4887"))
	if maxNum then
		self.fields.Text_armyLimit_count:setString(string.format("%d-%d", minNum, maxNum))
	else
		self.fields.Text_armyLimit_count:setString(i18n("common_text_4886"))
	end
end
function AllianceWarRallyViewPanel:refreshArmyForbidLvText(...)
	local massSlaveArmyMinLv = self.tableMainData:getMassSlaveArmyMinLv()
	local lvStr = "atlantiswar_text_0277"
	local mapType = self.tableMainData:getToMapType()
	if mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
		local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
		local occupyQueueArmyMinLv = atlantisWarCtrl:getOccupyQueueArmyMinLv()
		if 1 < occupyQueueArmyMinLv and massSlaveArmyMinLv < occupyQueueArmyMinLv then
			massSlaveArmyMinLv = occupyQueueArmyMinLv
			lvStr = "atlantiswar_text_0301"
		end
	end
	local armyDesRead = include("armyDesRead")
	_ENV = nil
	_ENV, _ENV, (nil).var = massSlaveArmyMinLv, armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv), armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv)
	_ENV, armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv).var, massSlaveArmyMinLv.color = massSlaveArmyMinLv, massSlaveArmyMinLv, "#FFFFFF"
	armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv).__default, massSlaveArmyMinLv.color = massSlaveArmyMinLv, "#D7C39B"
	local curLvStr = i18n_html(lvStr, nil, (armyDesRead.getMassLimitArmyLvStr(massSlaveArmyMinLv)))
	self.Text_lv:setString(curLvStr)
end
return AllianceWarRallyViewPanel
