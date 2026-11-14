local baseComponent = require("fgui.base.baseComponent")
local Com_WTV_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_WTV_single", Com_WTV_single)
local COLOR_GREE = cc.c3b(112, 199, 35)
local COLOR_RED = display.COLOR_RED
function Com_WTV_single:onInit()
	self:fixChildrenPos()
	self.fields.imgArr:fix()
	self.fields.imgSbg:addEventListener(fgui.UIEventType.Click, handler(self, self.singleClick))
	self.fields.btnAgree:setTitle(i18n("common_text_140"))
	self.fields.btnRefuse:setTitle(i18n("common_text_091"))
	self.fields.Text_partyTim:setString(i18n("common_text_467"))
	self.fields.Text_attackTime:setString(i18n("watchtower_text2"))
	self.fields.Text_attackTime2:setString(i18n("common_text_2809"))
	self.fields.btn_pos:addEventListener(fgui.UIEventType.Click, handler(self, self.panelTargetPosClick))
	self.fields.btn_startPos:addEventListener(fgui.UIEventType.Click, handler(self, self.panelStartPosClick))
	self.fields.imgHead:addEventListener(fgui.UIEventType.Click, handler(self, self.onHeadClick))
	self:setYayunBtns()
end
function Com_WTV_single:onShow()
end
function Com_WTV_single:initData(data)
	self.myQueueObj = data.data
	self:defaultView()
	local isMass = self:initView()
	if data.isFilter then
		self:dark()
	else
		self:undark()
	end
	return isMass
end
function Com_WTV_single:defaultView(...)
	self.controllers.c2:setSelectedIndex(1)
	self.fields.imgArr:setVisible(true)
end
local getOwnAllianceID = function(...)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	return allianceMgr:getOwnTeamID()
end
function Com_WTV_single:initView()
	local isMass = false
	self:fillBaseInfo()
	local finalC3SelectedIndex = 0
	local massAttack = function(...)
		self.fields.txtAim:setColor(COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_595"))
		self.controllers.c1:setSelectedIndex(2)
		self:runPartyAttack()
	end
	local massAid = function(...)
		self.fields.txtAim:setColor(COLOR_GREE)
		self.fields.txtAim:setString(i18n("common_text_1383"))
		self.controllers.c1:setSelectedIndex(2)
		self:runPartyAttack()
	end
	local totolArmyCount = 0
	local qType = self.myQueueObj:getQueueType()
	self.fields.mass_flag:setVisible(false)
	if gMapMoveLineServerType.moveLineTypeAttackLord == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		finalC3SelectedIndex = 1
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeNpcAttack == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		finalC3SelectedIndex = 1
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.massNebulaDefenceWarBuild == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		finalC3SelectedIndex = 1
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeAttackTreasure == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		finalC3SelectedIndex = 1
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeScout == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		self.fields.txtAim:setString(i18n("common_text_007"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
	elseif gMapMoveLineServerType.moveLineTypeResourceHelp == qType then
		self.fields.txtAim:setColor(COLOR_GREE)
		self.fields.txtAim:setString(i18n("common_text_221"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
	elseif gMapMoveLineServerType.moveLineTypeArmyHelp == qType then
		self.fields.txtAim:setColor(COLOR_GREE)
		self.fields.txtAim:setString(i18n("common_text_594"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
	elseif gMapMoveLineServerType.moveLineTypeAttackCamp == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		finalC3SelectedIndex = 1
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeAtkTorchMine == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		finalC3SelectedIndex = 1
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeAttackResource == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		finalC3SelectedIndex = 1
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeMassSlave == qType then
		self.fields.txtAim:setColor(COLOR_GREE)
		self.fields.txtAim:setString(i18n("common_text_292"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeEscort == qType then
		self.fields.txtAim:setColor(COLOR_GREE)
		local singleData = self.myQueueObj:getData()
		local escortDesRead = include("escortDesRead")
		local mache = escortDesRead.getCarName(singleData.cartLv)
		COLOR_RED = self.myQueueObj:getTotalMoveTime()
		self.myQueueObj:getTotalMoveTime().car = i18n(mache)
		self.fields.txtAim:setString(i18n("common_text_2418", self.myQueueObj:getTotalMoveTime()))
		self.controllers.c1:setSelectedIndex(3)
		self.controllers.c2:setSelectedIndex(0)
		self.fields.imgArr:setVisible(false)
		self.fields.barYayun:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		self.cantOpen = true
	elseif gMapMoveLineServerType.moveLineTypeMass == qType then
		massAttack()
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeAttackAllianceBuild == qType then
		self.fields.txtAim:setColor(COLOR_RED)
		finalC3SelectedIndex = 1
		self.fields.txtAim:setString(i18n("common_text_008"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeMassAllianceBuild == qType then
		massAttack()
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeOccupy == qType or gMapMoveLineServerType.moveLineTypeATBuilding == qType then
		if self.myQueueObj:isFromAlliance(getOwnAllianceID()) then
			self.fields.txtAim:setColor(COLOR_GREE)
			self.fields.txtAim:setString(i18n("common_text_594"))
			self.controllers.c1:setSelectedIndex(1)
			self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		else
			self.fields.txtAim:setColor(COLOR_RED)
			finalC3SelectedIndex = 1
			self.fields.txtAim:setString(i18n("common_text_008"))
			self.controllers.c1:setSelectedIndex(1)
			self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		end
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeOccupyMass == qType or gMapMoveLineServerType.moveLineTypeMassATBuilding == qType then
		if self.myQueueObj:isFromAlliance(getOwnAllianceID()) then
			massAid()
		else
			massAttack()
		end
		totolArmyCount = self:getTotalArmy()
	elseif gMapMoveLineServerType.moveLineTypeGuardAllianceBuild == qType then
		self.fields.txtAim:setColor(COLOR_GREE)
		self.fields.txtAim:setString(i18n("common_text_2913"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.barSingle:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		totolArmyCount = self:getTotalArmy()
	end
	self.controllers.c3:setSelectedIndex(finalC3SelectedIndex)
	self.fields.txtArmyNum:setVisible(0 < totolArmyCount)
	self.fields.txtArmyNum:setString(i18n("AncienTreasure_text_52") .. ":" .. totolArmyCount)
	return isMass
end
function Com_WTV_single:setYayunBtns(...)
	self.fields.btnAgree:addClickEventListener(function(button, eventType)
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local escortCtrl = gametop.playertop_:getModule("escortCtrl")
		if escortCtrl:isReachAssistLimit() then
			SoraDShowMsgTip(i18n("common_text_2488"), "#icon_escort_convey.png")
			return
		end
		local escortAssistCtrl = gametop.playertop_:getModule("escortAssistCtrl")
		escortAssistCtrl:reqAcceptAssist(self.myQueueObj:getFromUid())
	end)
	self.fields.btnRefuse:addClickEventListener(function(button, eventType)
		SoraDPlaySound()
		local _uid = self.myQueueObj:getFromUid()
		local gametop = gModuleMgr.getObject("gametop")
		local escortAssistCtrl = gametop.playertop_:getModule("escortAssistCtrl")
		print("点击了拒绝----------------, uid = ", _uid)
		escortAssistCtrl:reqRejectAssist(_uid)
	end)
end
function Com_WTV_single:runPartyAttack(...)
	self.fields.mass_flag:setVisible(true)
	self.fields.barParty:endTime()
	self.fields.barAttack:endTime()
	if not self.myQueueObj:getStatusRemainTime() then
		self.fields.barParty:setPercent(1, 1)
		self.fields.barAttack:setPercent(1, 1)
		self.fields.mass_flag:setURL("frame_lwt_xingzhong.png")
	elseif gMapMoveLineStatusType.moveLineStatusTypeRally == self.myQueueObj:getStatus() then
		local remindTime = self.myQueueObj:getStatusRemainTime()
		self.fields.barParty:initData(remindTime, self.myQueueObj:getOrgStatusTotalTime())
		self.fields.barAttack:setPercent(1, 1)
		self.fields.barAttack:showWaitingTitle(SoraDConvertSecondToString(self.myQueueObj:getTotalMoveTime()))
		self.fields.mass_flag:setURL("frame_lwt_jijie.png")
	elseif gMapMoveLineStatusType.moveLineStatusTypeMoving == self.myQueueObj:getStatus() then
		self.fields.barParty:setPercent(0, 1)
		self.fields.barParty:setTitle(i18n("Battlefield_queue_text_007"))
		self.fields.barAttack:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getTotalMoveTime())
		self.fields.mass_flag:setURL("frame_lwt_xingzhong.png")
	end
end
function Com_WTV_single:fillBaseInfo(...)
	local fromData = self.myQueueObj:getFrom()
	self.fromData = fromData
	if gArmyFromType.allianceWar == self.myQueueObj.armyFromType then
		self.fields.txtName:setString(i18n("common_text_3387"))
		self.fields.imgHead:setURL("ygzh_full.png")
	elseif gArmyFromType.ruinsWar == self.myQueueObj.armyFromType then
		self.fields.txtName:setString(i18n("remains_text_157"))
		self.fields.imgHead:setURL("myzh_full.png")
	elseif gArmyFromType.devilValley == self.myQueueObj.armyFromType or fromData.objType == gMapObjTypeDef.mapObjNewTrialCity then
		self.fields.txtName:setString(i18n("devilvalley_text_20"))
		self.fields.imgHead:setURL("qlzjt_full.png")
	else
		if fromData.allianceAbb ~= nil then
			_ENV = "qlzjt_full.png"
			;("qlzjt_full.png").abbr = fromData.allianceAbb
			;("qlzjt_full.png").name = fromData.name
			if i18n("common_text_186", "qlzjt_full.png") then
				goto lbl_81
			end
		end
		local showName = fromData.name
		::lbl_81::
		self.fields.txtName:setString(showName)
		SoraDGetHeadFromManager(self.fields.imgHead, fromData.headid, fromData.avatar)
	end
	local artifact = self.myQueueObj:getFromArtifact()
	self.fields.Com_armyDetail_artifact:setVisible(artifact[1] ~= nil)
	if artifact[1] then
		self.fields.Com_armyDetail_artifact:initData(artifact, 1)
	end
	local toData = self.myQueueObj:getTo()
	self.fields.Text_startPos:setString("x:" .. (fromData.x or 0) .. " y:" .. (fromData.y or 0))
	if toData then
		self.controllers.c2:setSelectedIndex(1)
		if toData.mapType then
			local mapObjUtil = include("mapObjUtil")
			if SoraDFIsRA() then
				self.fields.Text_targetPos:setString(string.format("x:%d y:%d (%s)%s", toData.x, toData.y, mapObjUtil.reOutDoor(toData), fromData and " <---" or ""))
			else
				self.fields.Text_targetPos:setString(string.format("%sx:%d y:%d (%s)", fromData and "---> " or "", toData.x, toData.y, mapObjUtil.reOutDoor(toData)))
			end
		else
			self.fields.Text_targetPos:setString("x:" .. toData.x .. " y:" .. toData.y)
		end
	else
		self.fields.Text_targetPos:setString("")
	end
end
function Com_WTV_single:getTotalArmy()
	return self.myQueueObj:getFromTotalAmryCount()
end
function Com_WTV_single:panelTargetPosClick(panel, eventType)
	SoraDPlaySound()
	local toData = self.myQueueObj:getTo()
	if toData then
		SoraDGotoWorldMapPoint(cc.p(toData.x, toData.y), true)
		SoraDRemoveAllPrePanelFromManager(self, true)
	end
end
function Com_WTV_single:panelStartPosClick(panel, eventType)
	SoraDPlaySound()
	local toData = self.myQueueObj:getFrom()
	if toData then
		SoraDGotoWorldMapPoint(cc.p(toData.x, toData.y), true)
		SoraDRemoveAllPrePanelFromManager(self, true)
	end
end
function Com_WTV_single:singleClick(panel, eventType)
	SoraDPlaySound()
	print("Com_WTV_single:singleClick")
	if not self.cantOpen then
		local panel = uiManager:show("WatchTowerDetailView")
		panel:req4info(self.myQueueObj:getId())
	end
end
function Com_WTV_single:dark()
	self.fields.panelMask:setVisible(true)
end
function Com_WTV_single:undark()
	self.fields.panelMask:setVisible(false)
end
function Com_WTV_single:onHeadClick()
	if self.fromData and self.fromData.uid then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = self.fromData.uid
		SoraDSendMessage(nil)
	end
end
return Com_WTV_single
