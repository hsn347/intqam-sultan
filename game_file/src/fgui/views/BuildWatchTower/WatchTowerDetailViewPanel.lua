local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WatchTowerDetailViewPanel = class("WatchTowerDetailViewPanel", baseFguiPanel)
function WatchTowerDetailViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("WatchTowerDetailViewPanel:ctor", self.viewName)
end
function WatchTowerDetailViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WatchTowerDetailViewPanel:onInit()
	self.view:fixChildrenPos()
	print("=======WatchTowerDetailViewPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	_UPVALUE3_ = self.fields.Com_title.initData
	_UPVALUE3_, self.barsTbl, self.fields.Com_title.initData[1] = self.fields.Com_title.initData, self.fields.Com_title.initData, self.fields.btnArmyBar
	_UPVALUE3_, self.barsTbl, self.fields.Com_title.initData[2] = self.fields.Com_title.initData, self.fields.Com_title.initData, self.fields.btnScienceBar
	_UPVALUE3_, self.barsTbl, self.fields.Com_title.initData[3] = self.fields.Com_title.initData, self.fields.Com_title.initData, self.fields.btnTalentBar
	_UPVALUE2_, self.scrollsTbl, self.fields.Com_title.initData[1] = self.fields.Com_title.initData, self.fields.Com_title.initData, self.fields.scrollMain
	_UPVALUE2_, self.scrollsTbl, self.fields.Com_title.initData[2] = self.fields.Com_title.initData, self.fields.Com_title.initData, self.fields.scrollScience
	_UPVALUE2_, self.scrollsTbl, self.fields.Com_title.initData[3] = self.fields.Com_title.initData, self.fields.Com_title.initData, self.fields.scrollTalent
	self.funcsTbl, self.fields.Com_title.initData[1] = self.fields.Com_title.initData
	self.funcsTbl, self.fields.Com_title.initData[2] = self.fields.Com_title.initData, handler(self, self.showScience)
	self.funcsTbl, self.fields.Com_title.initData[3] = self.fields.Com_title.initData, handler(self, self.showTalent)
	self.funcsTbl, self.fields.Com_title.initData[4] = self.fields.Com_title.initData, handler(self, self.showTalent)
	self.funcsTbl, self.fields.Com_title.initData[5] = self.fields.Com_title.initData, handler(self, self.showTalent)
	self.funcsTbl, self.fields.Com_title.initData[6] = self.fields.Com_title.initData, handler(self, self.showTalent)
	self.funcsTbl, self.fields.Com_title.initData[7] = self.fields.Com_title.initData, handler(self, self.showTalent)
	self.funcsTbl, self.fields.Com_title.initData[8] = self.fields.Com_title.initData, handler(self, self.showTalent)
	self.fields.btnBack:setTitle(i18n("common_text_302"))
	self.fields.btnBack:setVisible(false)
	self.fields.btnBack:addClickEventListener(handler(self, self.btnBackClick))
	self.fields.btnHide:setTitle(i18n("common_text_1267"))
	self.fields.btnHide:setTouchEnabled(false)
	self.fields.btnHide:setBright(false)
	self.fields.btnHide:addClickEventListener(handler(self, self.btnHideClick))
	self.fields.btnScienceBar:setTitle(i18n("common_text_775"))
	self.fields.btnTalentBar:setTitle(i18n("common_text_774"))
	self.fields.imgHead:addEventListener(fgui.UIEventType.Click, handler(self, self.onHeadClick))
	for i = 1, 3 do
		self.barsTbl[i]:addClickEventListener(handler(self, self.onTabBarClick), i)
		self.barsTbl[i]:fixChildrenPos()
		self.barsTbl[i]:fixChildren(true)
	end
	self:rangeBars()
	if worldMapDefine.isInNebula() then
		self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime))
	end
end
function WatchTowerDetailViewPanel:onShow()
	if not SoraDFIsRA() then
		self.fields.btnBack:setPositionX(self.view:getSize().width - 160)
	end
	print("=======WatchTowerDetailViewPanel:onShow")
end
function WatchTowerDetailViewPanel:rangeBars(num)
	num = num or 3
	self.lastBar = nil
	for i = 1, 3 do
		self.barsTbl[i]:setVisible(i <= num)
		if i == 1 then
			self:onTabBarClick(self.barsTbl[i], i)
		end
	end
end
function WatchTowerDetailViewPanel:onHeadClick()
	if self.fromData and self.fromData.uid then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = self.fromData.uid
		SoraDSendMessage(nil)
	end
end
function WatchTowerDetailViewPanel:onTabBarClick(sender, param)
	local findIt = false
	for i = 1, 3 do
		local v = self.barsTbl[i]
		local arrow = fguiHelper.get_fields(v).imgArr
		if v == sender and self.lastBar ~= v then
			findIt = true
			self.scrollsTbl[i]:setVisible(true)
			arrow:setRotation(0)
			self.lastBar = sender
			if self.funcsTbl[i] then
				self.funcsTbl[i]()
			end
		else
			self.scrollsTbl[i]:setVisible(false)
			arrow:setRotation(SoraDFPosX(90, 0))
		end
	end
	if not findIt then
		self.lastBar = nil
	end
end
function WatchTowerDetailViewPanel:rangeScrollHeigh(num)
end
function WatchTowerDetailViewPanel:closeMe(target, redata)
	SoraDRemoveAllPrePanelFromManager(self)
end
function WatchTowerDetailViewPanel:reciveData(target, redata)
	if self.myQueueID and redata and self.myQueueID == redata.indexID and ("MESSAGE_SERVER_WATCHTOWER_REMOVEINFO" == redata.msg or "MESSAGE_SERVER_WATCHSOULTOWER_REMOVEINFO" == redata.msg) then
		SoraDRemoveAllPrePanelFromManager(self)
	end
	if self.myQueueObj and redata and redata.indexID == self.myQueueObj:getId() and ("MESSAGE_SERVER_WATCHTOWER_EDITINFO" == redata.msg or "MESSAGE_SERVER_WATCHSOULTOWER_EDITINFO" == redata.msg) then
		self:afterInitData(redata.data:getFilterDataByWatchTower())
	end
end
function WatchTowerDetailViewPanel:req4info(_id)
	SoraDShowLoading(self:displayObject(), nil, nil, nil, 10)
	self.myQueueID = _id
	local jQueue = kingdomMapCtrl.kingdomMapCell.localQueueMgr:getQueue(_id)
	if jQueue then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local aid = allianceMgr:getOwnTeamID()
		if jQueue:isFromAlliance(aid) then
			self:afterInitData(jQueue:getFilterDataByWatchTower())
			SoraDCloseLoading(self:displayObject())
		else
			kingdomMapCtrl = self:displayObject()
			self:displayObject()[1] = _id
			kingdomMapCtrl:reqQueueWatchTowerData(self:displayObject())
		end
	else
		self:close()
	end
end
function WatchTowerDetailViewPanel:initData(target, redata)
	dump(redata, "initData", 5)
	SoraDCloseLoading(self:displayObject())
	if redata and redata.data then
		self:afterInitData(redata.data:getFilterDataByWatchTower())
	else
		self:close()
	end
end
function WatchTowerDetailViewPanel:afterInitData(qOBJ)
	self.myQueueObj = qOBJ
	self.myQueueID = self.myQueueObj:getId()
	dump(self.myQueueObj, "WatchTowerDetailViewPanel:afterInitDat--self.myQueueObj", 20)
	if not worldMapDefine.isInNebula() then
		self.fields.scrollMain:clearAll()
		self:initView()
		return
	end
	self.needRefresh = true
	if not self.isInit then
		self.isInit = true
		self:updateTime()
	end
	self:updateTime()
end
function WatchTowerDetailViewPanel:updateTime(...)
	if not self.needRefresh then
		return
	end
	self.needRefresh = false
	self.fields.scrollMain:clearAll()
	self:initView()
end
function WatchTowerDetailViewPanel:initView(...)
	local fromData = self.myQueueObj:getFrom()
	self.fromData = fromData
	dump(self.fromData, "self.fromData")
	self:checkIgnoreBtn()
	if fromData.level then
		_ENV = nil
		;(nil).lv = fromData.level
		self.fields.txtLevel:setString(i18n("common_text_2485", nil))
	else
		_ENV = i18n("common_text_2485", nil)
		i18n("common_text_2485", nil).lv = "???"
		self.fields.txtLevel:setString(i18n("common_text_2485", i18n("common_text_2485", nil)))
	end
	if gArmyFromType.allianceWar == self.myQueueObj.armyFromType then
		self.fields.txtName:setString(i18n("common_text_3387"))
		self.fields.imgHead:setURL("ygzh_full.png")
		self.fields.txtLevel:setString("")
		self:rangeBars(1)
	elseif gArmyFromType.ruinsWar == self.myQueueObj.armyFromType then
		self.fields.txtName:setString(i18n("remains_text_157"))
		self.fields.imgHead:setURL("myzh_full.png")
		self.fields.txtLevel:setString("")
		self:rangeBars(0)
	elseif gArmyFromType.devilValley == self.myQueueObj.armyFromType or fromData.objType == gMapObjTypeDef.mapObjNewTrialCity then
		self.fields.txtName:setString(i18n("devilvalley_text_20"))
		self.fields.imgHead:setURL("qlzjt_full.png")
		self.fields.txtLevel:setString("")
		self:rangeBars(1)
	else
		if fromData.allianceAbb ~= nil then
			_ENV = 1
			;(1).abbr = fromData.allianceAbb
			;(1).name = fromData.name
			if i18n("common_text_186", 1) then
				goto lbl_134
			end
		end
		local showName = fromData.name
		::lbl_134::
		self.fields.txtName:setString(showName)
		SoraDGetHeadFromManager(self.fields.imgHead, fromData.headid, fromData.avatar)
	end
	if fromData then
		if fromData.x and fromData.y then
			_ENV = fromData.avatar
			fromData.avatar.x = fromData.x
			fromData.avatar.y = fromData.y
			self.fields.txtPos:setString(i18n("common_text_2155", fromData.avatar))
		else
			_ENV = i18n("common_text_2155", fromData.avatar)
			i18n("common_text_2155", fromData.avatar).x = "???"
			i18n("common_text_2155", fromData.avatar).y = "???"
			self.fields.txtPos:setString(i18n("common_text_2155", i18n("common_text_2155", fromData.avatar)))
		end
		if not self.fields.btn_pos.addEvent then
			self.fields.btn_pos:addEventListener(fgui.UIEventType.Click, handler(self, self.panelFromPosClick))
			self.fields.btn_pos.addEvent = true
		end
	end
	local toData = self.myQueueObj:getTo()
	if toData then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_targetPos:setString("X:" .. toData.x .. " Y:" .. toData.y)
		if not self.fields.btn_targetPos.addEvent then
			self.fields.btn_targetPos:addEventListener(fgui.UIEventType.Click, handler(self, self.panelToPosClick))
			self.fields.btn_targetPos.addEvent = true
		end
		if toData.mapType then
			local mapObjUtil = include("mapObjUtil")
			self.fields.Text_target:setString(mapObjUtil.reOutDoor(toData))
		end
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self:class2Load()
end
function WatchTowerDetailViewPanel:showTotalArmy(_num, _title)
	dump(_num, "_num")
	self.txtTotalArmy = fguiHelper.get_fields(self.fields.btnArmyBar).num
	if _num then
		self.txtTotalArmy:setString(type(_num) == "number" and string.formatnumberthousands(_num) or _num)
	else
		_ENV = nil
		;(nil).level = WATCH_TOWER_VIEW_ARMYTOTALCOUNT
		self.txtTotalArmy:setString(i18n("common_text_596", nil))
	end
	if _title then
		self.fields.btnArmyBar:setTitle(_title)
	end
end
local getOwnAllianceID = function(...)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	return allianceMgr:getOwnTeamID()
end
function WatchTowerDetailViewPanel:class2Load(...)
	local qType = self.myQueueObj:getQueueType()
	local massAttack = function(...)
		self:setTitle(i18n("common_text_595"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_595"))
		local totalNum = self:showMassArmy()
		self:showTotalArmy(totalNum, i18n("common_text_584"))
		self:runPartyAttack()
	end
	local massAid = function(...)
		self:rangeBars(1)
		self:setTitle(i18n("common_text_1383"))
		self.fields.txtAim:setColor(display.COLOR_GREEN)
		self.fields.txtAim:setString(i18n("common_text_1383"))
		local totalNum = self:showMassArmy()
		self:showTotalArmy(totalNum, i18n("common_text_584"))
		self:runPartyAttack()
	end
	if gMapMoveLineServerType.moveLineTypeAttackLord == qType then
		self:setTitle(i18n("common_text_008"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
	elseif gMapMoveLineServerType.moveLineTypeAttackTreasure == qType then
		self:setTitle(i18n("common_text_008"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
	elseif gMapMoveLineServerType.moveLineTypeNpcAttack == qType then
		self:setTitle(i18n("common_text_008"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		if gArmyFromType.ruinsWar == self.myQueueObj.armyFromType then
		else
			self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
			self:showSingleArmy()
		end
	elseif gMapMoveLineServerType.moveLineTypeScout == qType then
		self:setTitle(i18n("common_text_007"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_007"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy("", i18n("common_text_007"))
	elseif gMapMoveLineServerType.moveLineTypeResourceHelp == qType then
		self:rangeBars(1)
		self:setTitle(i18n("common_text_221"))
		self.fields.txtAim:setColor(display.COLOR_GREEN)
		self.fields.txtAim:setString(i18n("common_text_221"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy("", i18n("common_text_221"))
		self:showResArmy()
	elseif gMapMoveLineServerType.moveLineTypeArmyHelp == qType then
		self:rangeBars(1)
		self:setTitle(i18n("common_text_594"))
		self.fields.txtAim:setColor(display.COLOR_GREEN)
		self.fields.txtAim:setString(i18n("common_text_594"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
		self.fields.btnBack:setVisible(true)
	elseif gMapMoveLineServerType.moveLineTypeAttackCamp == qType then
		self:setTitle(i18n("common_text_008"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
	elseif gMapMoveLineServerType.moveLineTypeAtkTorchMine == qType then
		self:setTitle(i18n("common_text_008"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
	elseif gMapMoveLineServerType.moveLineTypeAttackWarTreasure == qType then
		self:setTitle(i18n("common_text_008"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
	elseif gMapMoveLineServerType.moveLineTypeAttackResource == qType then
		self:setTitle(i18n("common_text_008"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
	elseif gMapMoveLineServerType.moveLineTypeMassSlave == qType then
		self:rangeBars(1)
		self:setTitle(i18n("common_text_292"))
		self.fields.txtAim:setColor(display.COLOR_GREEN)
		self.fields.txtAim:setString(i18n("common_text_292"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
		self.fields.btnBack:setVisible(true)
	elseif gMapMoveLineServerType.moveLineTypeEscort == qType then
	elseif gMapMoveLineServerType.moveLineTypeMass == qType then
		massAttack()
	elseif gMapMoveLineServerType.moveLineTypeAttackAllianceBuild == qType then
		self:setTitle(i18n("common_text_008"))
		self.fields.txtAim:setColor(display.COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
	elseif gMapMoveLineServerType.moveLineTypeMassAllianceBuild == qType then
		massAttack()
	elseif gMapMoveLineServerType.moveLineTypeOccupy == qType or gMapMoveLineServerType.moveLineTypeATBuilding == qType then
		if self.myQueueObj:isFromAlliance(getOwnAllianceID()) then
			self:rangeBars(1)
			self:setTitle(i18n("common_text_594"))
			self.fields.txtAim:setColor(display.COLOR_GREEN)
			self.fields.txtAim:setString(i18n("common_text_594"))
			self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
			self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
			self:showSingleArmy()
		else
			self:setTitle(i18n("common_text_008"))
			self.fields.txtAim:setColor(display.COLOR_RED)
			self.fields.txtAim:setString(i18n("common_text_008"))
			self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
			self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
			self:showSingleArmy()
		end
	elseif gMapMoveLineServerType.moveLineTypeOccupyMass == qType or gMapMoveLineServerType.moveLineTypeMassATBuilding == qType then
		if self.myQueueObj:isFromAlliance(getOwnAllianceID()) then
			massAid()
		else
			massAttack()
		end
	elseif gMapMoveLineServerType.moveLineTypeGuardAllianceBuild == qType then
		self:rangeBars(1)
		self:setTitle(i18n("common_text_2913"))
		self.fields.txtAim:setColor(display.COLOR_GREEN)
		self.fields.txtAim:setString(i18n("common_text_2913"))
		self.fields.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
		self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
		self:showSingleArmy()
	end
end
function WatchTowerDetailViewPanel:showMassArmy(...)
	local mainID = self.myQueueObj:getId()
	local slaveQueue = kingdomMapCtrl.kingdomMapCell.localMassQueueMgr:getSlaveQueueMap(mainID)
	return self.fields.scrollMain:initMassData(self.myQueueObj, slaveQueue)
end
function WatchTowerDetailViewPanel:showSingleArmy(...)
	self.fields.scrollMain:initSingleData(self.myQueueObj)
end
function WatchTowerDetailViewPanel:showScience(...)
	local scienceinfo = self.myQueueObj:getFrom().technology
	self.fields.scrollScience:initData(scienceinfo)
end
function WatchTowerDetailViewPanel:showTalent(...)
	local talentinfo = self.myQueueObj:getFrom().ability
	self.fields.scrollTalent:initData(talentinfo)
end
function WatchTowerDetailViewPanel:showResArmy(...)
	local resourceList = self.myQueueObj:getData().data.resourceList
	local taxRate = self.myQueueObj:getData().taxRate
	if resourceList and taxRate then
		self.fields.scrollRes:initData(resourceList, taxRate)
		self.fields.scrollRes:setVisible(true)
		self.scrollsTbl[1] = self.fields.scrollRes
	end
end
function WatchTowerDetailViewPanel:runPartyAttack(...)
	self.fields.attackBar:endTime()
	if gMapMoveLineStatusType.moveLineStatusTypeRally == self.myQueueObj:getStatus() then
		if self.myQueueObj:getStatusRemainTime() then
			local curTime = self.myQueueObj:getStatusRemainTime() + self.myQueueObj:getTotalMoveTime()
			local totalTime = self.myQueueObj:getOrgStatusTotalTime() + self.myQueueObj:getTotalMoveTime()
			self.fields.attackBar:initData(curTime, totalTime)
		else
			self.fields.attackBar:initData(nil, nil)
		end
	elseif gMapMoveLineStatusType.moveLineStatusTypeMoving == self.myQueueObj:getStatus() then
		local curTime = self.myQueueObj:getStatusRemainTime()
		local totalTime = self.myQueueObj:getTotalMoveTime()
		self.fields.attackBar:initData(curTime, totalTime)
	end
end
function WatchTowerDetailViewPanel:setTitle(str)
	_ENV = nil
	;(nil).type = str
	self.fields.txtAim:setString(i18n("common_text_3516", nil))
	self.fields.Com_title:updateTitle(str)
end
function WatchTowerDetailViewPanel:panelFromPosClick(panel, eventType)
	SoraDPlaySound()
	if self.myQueueObj:getFromX() and self.myQueueObj:getFromY() then
		SoraDGotoWorldMapPoint(cc.p(self.myQueueObj:getFromX(), self.myQueueObj:getFromY()), true)
		SoraDRemoveAllPrePanelFromManager(self)
	else
		_ENV = self.myQueueObj:getFromY()
		self.myQueueObj:getFromY().level = WATCH_TOWER_VIEW_ARRIVEPOS_LV
		SoraDShowMsgTip(i18n("common_text_596", self.myQueueObj:getFromY()))
	end
end
function WatchTowerDetailViewPanel:panelToPosClick(panel, eventType)
	SoraDPlaySound()
	if self.myQueueObj:getTo() then
		SoraDGotoWorldMapPoint(cc.p(self.myQueueObj:getToX(), self.myQueueObj:getToY()), true)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function WatchTowerDetailViewPanel:checkIgnoreBtn(...)
	local queueMgr = kingdomMapCtrl:getWatchTowerQueue()
	if queueMgr:judgeCouldWarning(self.myQueueObj) then
		local oriQueue = queueMgr:getWatchTowerData(self.myQueueObj:getId())
		if not oriQueue then
			self.fields.btnHide:setTouchEnabled(false)
			self.fields.btnHide:setBright(false)
			self.fields.btnHide:setTitleText(i18n("common_text_1267"))
		elseif oriQueue:isRedFrmIgnore() then
			self.fields.btnHide:setTouchEnabled(true)
			self.fields.btnHide:setBright(true)
			self.fields.btnHide:setTitleText(i18n("common_text_3389"))
		else
			self.fields.btnHide:setTouchEnabled(true)
			self.fields.btnHide:setBright(true)
			self.fields.btnHide:setTitleText(i18n("common_text_1267"))
		end
	else
		self.fields.btnHide:setTouchEnabled(false)
		self.fields.btnHide:setBright(false)
	end
end
function WatchTowerDetailViewPanel:btnHideClick(button, eventType)
	SoraDPlaySound()
	local queueMgr = kingdomMapCtrl:getWatchTowerQueue()
	if queueMgr:judgeCouldWarning(self.myQueueObj) then
		local oriQueue = queueMgr:getWatchTowerData(self.myQueueObj:getId())
		if not oriQueue then
			return
		end
		if not oriQueue:isRedFrmIgnore() then
			oriQueue:ignoreRedFrm()
			_ENV = oriQueue
			oriQueue.msg = "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROLONE"
			oriQueue.controlType = "add"
			oriQueue.qid = self.myQueueObj:getId()
			SoraDSendMessage(oriQueue)
			queueMgr:decreaseCount("frm")
			queueMgr:controlRecordQ(self.myQueueObj:getId(), "add")
		else
			oriQueue:noIgnoreRedFrm()
			_ENV = oriQueue
			oriQueue.msg = "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROLONE"
			oriQueue.controlType = "sub"
			oriQueue.qid = self.myQueueObj:getId()
			SoraDSendMessage(oriQueue)
			queueMgr:addCount("frm")
			queueMgr:controlRecordQ(self.myQueueObj:getId(), "sub")
		end
		_ENV = queueMgr
		queueMgr.msg = "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROL"
		SoraDSendMessage(queueMgr)
		self:checkIgnoreBtn()
	end
end
function WatchTowerDetailViewPanel:btnBackClick(button, eventType)
	SoraDPlaySound()
	kingdomMapCtrl:reqBackQueueById(self.myQueueObj:getId())
	self.fields.btnBack:setVisible(false)
end
return WatchTowerDetailViewPanel
