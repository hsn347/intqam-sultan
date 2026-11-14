local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceDesRead = include("allianceDesRead")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceBuildBuildingView = class("allianceBuildBuildingView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildBuildingView")
	end
	return target
end)
function allianceBuildBuildingView:ctor()
	self.tableHeights, _ENV, self.tableSingleList, _ENV, self.tablePartyList, _ENV = nil, nil, nil, nil, nil, nil
	self.totalArmyCount = 0
	self.totalContentArmyCount = 0
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	SoraDGetChildByName(self, "Image_tile_line"):setFillType(1)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_troops")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("allianceBuildBuildingSingle")
	self.Image_build = SoraDGetChildByName(self, "Image_build")
	self.Node_flag = SoraDGetChildByName(self, "Node_flag")
	self.Node_flag:setVisible(false)
	self.Text_building = SoraDGetChildByName(self, "Text_building")
	self.Text_building:setString(i18n("common_text_043"))
	self.Text_bValStr = SoraDGetChildByName(self, "Text_bValStr")
	self.Text_bValStr:setString(i18n("alliance_stronghold_text_106"))
	self.Text_bVal = SoraDGetChildByName(self, "Text_bVal")
	self.Text_bArmyStr = SoraDGetChildByName(self, "Text_bArmyStr")
	self.Text_bArmyStr:setString(i18n("alliance_stronghold_text_107"))
	self.Text_bArmy = SoraDGetChildByName(self, "Text_bArmy")
	self.Text_bTimeStr = SoraDGetChildByName(self, "Text_bTimeStr")
	_ENV = i18n("alliance_stronghold_text_107")
	i18n("alliance_stronghold_text_107").var = ""
	self.Text_bTimeStr:setString(i18n("alliance_stronghold_text_021", i18n("alliance_stronghold_text_107")))
	self.Text_bTime = SoraDGetChildByName(self, "Text_bTime")
	self.Text_bTime = SoraDCreateTimerLabel(self, self.Text_bTime)
	self.Text_log = SoraDGetChildByName(self, "Text_log")
end
function allianceBuildBuildingView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_DESTROY", handler(self, self.judgeCloseView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.judgeBeQuit))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self:removeFromParent()
	end)
end
function allianceBuildBuildingView:serverMessage_RequestMapInstaceInfo(target, data)
	if not (data and data.data and next(data.data)) or not data.data.build then
		return
	end
	if data.data.build.id == self.data.id then
		print("刷新")
		if (data.data.build.buildFinishTime or 0) <= serviceFunctions.systemTime() then
			self.isRequesting = false
			return
		end
		self.tablePartyList, _ENV, self.data = data.data.build, data.data.build, data.data.build
		self:updateInfo()
		self:initView()
		self.isRequesting = false
	end
end
function allianceBuildBuildingView:judgeBeQuit(target, data)
	if not allianceMgr:hasJoinAlliance() then
		self:removeFromParent()
	end
end
function allianceBuildBuildingView:judgeCloseView(target, data)
	if data.id == self.data.id then
		self:removeFromParent()
	end
end
function allianceBuildBuildingView:updateData(target, data)
	dump(data, "allianceBuildBuildingView:updateData data=======")
	print("self.data.id===", self.data.id)
	if data.id == self.data.id and not self.isRequesting then
		self.isRequesting = true
		kingdomMapCtrl:reqMapObjInfo(self.instanceData.x, self.instanceData.y, self.instanceData.id, self.instanceData.kingdomId)
	end
end
function allianceBuildBuildingView:scrollListPosUpdate()
	self.tableHeights, _ENV = nil, nil
	local sSize = self.scroll:getContentSize()
	local totalInnerH = 0
	for i, v in ipairs(self.tableSingleList) do
		totalInnerH = totalInnerH + v:getSingleHeight() + 5
		if i == 1 then
			self.tableHeights[i] = 0
		else
			self.tableHeights[i] = self.tableHeights[i - 1] + self.tableSingleList[i - 1]:getSingleHeight() + 5
		end
	end
	local sH = math.max(totalInnerH, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.tableSingleList) do
		v:setPosition(cc.p(0, sH - self.tableHeights[i]))
	end
end
function allianceBuildBuildingView:localUpdate(uid)
	if uid then
		for i, v in ipairs(self.tableSingleList) do
			if v:getQid() == uid then
				self.totalArmyCount = self.totalArmyCount - v:getTotalArmyCount()
				v:removeFromParent()
				table.remove(self.tableSingleList, i)
				table.remove(self.tablePartyList, i)
			end
		end
	end
	self:scrollListPosUpdate()
end
function allianceBuildBuildingView:initDispatchData(dispatchData)
	self.dispatchData = dispatchData
end
function allianceBuildBuildingView:updateInfo()
	_ENV = nil
	;(nil).var1 = string.formatnumberthousands(math.max(0, math.floor(self.data.totalPoint - self.data.surplusPoint)))
	;(nil).var2 = string.formatnumberthousands(self.data.totalPoint)
	self.Text_bVal:setString(i18n("%{var1}/%{var2}", nil))
	if self.data.buildFinishTime and 0 < self.data.buildFinishTime and 0 < self.data.buildSpeed then
		self.Text_bTime:setTimeUpdateListener(function(time)
			self = nil
			;(nil).var1 = string.formatnumberthousands(math.max(0, math.floor(self.data.totalPoint - time * self.data.buildSpeed)))
			;(nil).var2 = string.formatnumberthousands(self.data.totalPoint)
			self.Text_bVal:setString(i18n("%{var1}/%{var2}", nil))
		end)
		self.Text_bTime:setTimeEndListener(function(...)
			print("退出")
			self:removeFromParent()
		end)
		self.Text_bTime:beginTime(self.data.buildFinishTime - serviceFunctions.systemTime())
		self.Text_building:setString(i18n("common_text_043"))
	else
		self.Text_bTime:setString("")
		self.Text_bTime:removeTime()
		self.Text_building:setString(i18n("common_text_2139"))
	end
	if self.data.guards then
		local isSelfIn = false
		for _, v in ipairs(self.data.guards) do
			v.sType = 1
			v.isFold = true
			table.insert(self.tablePartyList, v)
			if v.playerID == gametop.playertop_:getPlayerID() then
				isSelfIn = true
			end
		end
		_ENV = ipairs(self.data.guards)
		ipairs(self.data.guards).sType = 2
		ipairs(self.data.guards).isSelfIn = isSelfIn
		ipairs(self.data.guards).dispatchData = self.dispatchData
		table.insert(self.tablePartyList, ipairs(self.data.guards))
	end
end
function allianceBuildBuildingView:initData(classID, data, instanceData)
	self.classID = classID
	self.data = data
	self.instanceData = instanceData
	dump(classID, "classID=======", 10)
	dump(data, "data=======", 10)
	self.ccs_title:setTitle(i18n(allianceDesRead.getBuildName(self.classID)))
	self.Image_build:setSpriteFrame(allianceDesRead.getBuildIcon(self.classID))
	self.Node_flag:setVisible(self.classID == gAllianceBuilding.FLAG)
	self.Image_build:setVisible(self.classID ~= gAllianceBuilding.FLAG)
	if allianceMgr:hasJoinAlliance() then
		SoraDGetAllianceFlagByFid(allianceMgr:getAllianceInfo().flag):addTo(self.Node_flag)
	else
		SoraDGetAllianceFlagByFid(1):addTo(self.Node_flag)
	end
	_ENV = allianceDesRead.getBuildIcon(self.classID)
	allianceDesRead.getBuildIcon(self.classID).var = i18n(allianceDesRead.getBuildName(self.classID))
	self.Text_log:setString(i18n("alliance_stronghold_text_022", allianceDesRead.getBuildIcon(self.classID)))
	self:updateInfo()
	self:initView()
end
function allianceBuildBuildingView:initView()
	self.scroll:removeAllChildren()
	self.tableSingleList, _ENV = self.scroll.removeAllChildren, self.scroll.removeAllChildren
	self.totalArmyCount = 0
	local sSize = self.scroll:getContentSize()
	local sH = math.max(#self.tablePartyList * 120, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.tablePartyList) do
		local partySingle = SoraDCreatePanel("allianceBuildBuildingSingle")
		partySingle:addTo(self.scroll)
		partySingle:setRepatriateCallBack(handler(self, self.localUpdate))
		partySingle:initData(v, v.isFold, self.classID, 0 < self.data.guardArmyCapacity and self.data.guardArmyTotalNum >= self.data.guardArmyCapacity)
		self.totalArmyCount = self.totalArmyCount + partySingle:getTotalArmyCount()
		partySingle:setScroll(self.scroll)
		partySingle:setParent(self)
		table.insert(self.tableSingleList, partySingle)
	end
	self:scrollListPosUpdate()
	_ENV = cc.size(sSize.width, sH)
	cc.size(sSize.width, sH).member = string.formatnumberthousands(self.data.guardArmyTotalNum)
	cc.size(sSize.width, sH).total = string.formatnumberthousands(self.data.guardArmyCapacity)
	self.Text_bArmy:setString(i18n("%{member}/%{total}", cc.size(sSize.width, sH)))
end
return allianceBuildBuildingView
