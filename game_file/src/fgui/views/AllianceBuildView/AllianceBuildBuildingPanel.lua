local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceBuildBuildingPanel = class("AllianceBuildBuildingPanel", baseFguiPanel)
local string_fnt = string.formatnumberthousands
function AllianceBuildBuildingPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceBuildBuildingPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function AllianceBuildBuildingPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWatchTower"
	end
	return self._packageList
end
function AllianceBuildBuildingPanel:onInit()
	print("=======AllianceBuildBuildingPanel:onInit")
	self.tablePartyList, _ENV = print, print
	self.controllers.c1:setSelectedIndex(1)
	self.ccs_title = self.fields.Com_title
	self.fields.Com_title:setCloseCallback(handler(self, self.onClickClose))
	self.Image_build = self.fields.Sprite_build
	self.Node_flag = self.fields.Node_flag
	self.Text_building = self.fields.Text_name
	self.Text_building:setString(i18n("common_text_043"))
	self.Text_bValStr = self.fields.Text_title_1
	self.Text_bValStr:setString(i18n("alliance_stronghold_text_106"))
	self.Text_bVal = self.fields.Text_value_1
	self.Text_bArmyStr = self.fields.Text_title_2
	self.Text_bArmyStr:setString(i18n("alliance_stronghold_text_107"))
	self.Text_bArmy = self.fields.Text_value_2
	self.Text_bTimeStr = self.fields.Text_title_3
	_ENV = i18n("alliance_stronghold_text_107")
	i18n("alliance_stronghold_text_107").var = ""
	self.Text_bTimeStr:setString(i18n("alliance_stronghold_text_021", i18n("alliance_stronghold_text_107")))
	self.Text_bTime = SoraDCreateTimerLabel(self, self.fields.Text_value_3)
	self.Text_log = self.fields.Com_log
	self.fields.List = self.fields.List2
	self.scroll = self.fields.List
	self.fields.List:setItemRenderer(handler(self, self.onItemRenerer))
	if not SoraDFIsRA() then
		local _fields = fguiHelper.get_fields(self.Text_log)
		_UPVALUE11_ = handler(self, self.onItemRenerer)
		handler(self, self.onItemRenerer)[1] = _fields.title
		handler(self, self.onItemRenerer)[2] = _fields.icon_message
		handler(self, self.onItemRenerer)[3] = self.Image_build
		handler(self, self.onItemRenerer)[4] = self.Text_building
		handler(self, self.onItemRenerer)[5] = self.Text_bValStr
		handler(self, self.onItemRenerer)[6] = self.Text_bArmyStr
		handler(self, self.onItemRenerer)[7] = self.Text_bTimeStr
		handler(self, self.onItemRenerer)[8] = self.Text_bVal
		handler(self, self.onItemRenerer)[9] = self.Text_bArmy
		handler(self, self.onItemRenerer)[10] = self.Text_bTime
		handler(self, self.onItemRenerer)[11] = self.Node_flag
		for __, widget in ipairs(handler(self, self.onItemRenerer)) do
			widget:fixPos()
		end
	end
end
function AllianceBuildBuildingPanel:onShow()
	print("=======AllianceBuildBuildingPanel:onShow")
end
function AllianceBuildBuildingPanel:serverMessage_RequestMapInstaceInfo(target, data)
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
function AllianceBuildBuildingPanel:judgeBeQuit(target, data)
	if not allianceMgr:hasJoinAlliance() then
		self:removeFromParent()
	end
end
function AllianceBuildBuildingPanel:judgeCloseView(target, data)
	if data.id == self.data.id then
		self:removeFromParent()
	end
end
function AllianceBuildBuildingPanel:updateData(target, data)
	dump(data, "AllianceBuildBuildingPanel:updateData data=======")
	print("self.data.id===", self.data.id)
	if data.id == self.data.id and not self.isRequesting then
		self.isRequesting = true
		kingdomMapCtrl:reqMapObjInfo(self.instanceData.x, self.instanceData.y, self.instanceData.id, self.instanceData.kingdomId)
	end
end
function AllianceBuildBuildingPanel:localUpdate()
end
function AllianceBuildBuildingPanel:initDispatchData(dispatchData)
	self.dispatchData = dispatchData
end
function AllianceBuildBuildingPanel:updateInfo()
	_ENV = nil
	;(nil).var1 = string_fnt(math.max(0, math.floor(self.data.totalPoint - self.data.surplusPoint)))
	;(nil).var2 = string_fnt(self.data.totalPoint)
	self.Text_bVal:setString(i18n("%{var1}/%{var2}", nil))
	if self.data.buildFinishTime and 0 < self.data.buildFinishTime and 0 < self.data.buildSpeed then
		self.Text_bTime:setTimeUpdateListener(function(time)
			self = nil
			;(nil).var1 = string_fnt(math.max(0, math.floor(self.data.totalPoint - time * self.data.buildSpeed)))
			;(nil).var2 = string_fnt(self.data.totalPoint)
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
function AllianceBuildBuildingPanel:initData(classID, data, instanceData)
	self.classID = classID
	self.data = data
	self.instanceData = instanceData
	dump(classID, "classID=======", 10)
	dump(data, "data=======", 10)
	self.ccs_title:setTitle(i18n(allianceDesRead.getBuildName(self.classID)))
	self.Image_build:setURL(allianceDesRead.getBuildIcon(self.classID))
	self.Node_flag:setVisible(self.classID == gAllianceBuilding.FLAG)
	self.Image_build:setVisible(self.classID ~= gAllianceBuilding.FLAG)
	local nodeFlag = allianceDesRead.getFlagNode()
	nodeFlag:addTo(self.fields.Node_flag:displayObject())
	_ENV = self.fields.Node_flag:displayObject()
	self.fields.Node_flag:displayObject().var = i18n(allianceDesRead.getBuildName(self.classID))
	self.Text_log:setString(i18n("alliance_stronghold_text_022", self.fields.Node_flag:displayObject()))
	self:updateInfo()
	self:initView()
end
function AllianceBuildBuildingPanel:initView()
	self.fields.List:setNumItems(#self.tablePartyList)
	_ENV = nil
	;(nil).member = string_fnt(self.data.guardArmyTotalNum)
	;(nil).total = string_fnt(self.data.guardArmyCapacity)
	self.Text_bArmy:setString(i18n("%{member}/%{total}", nil))
end
function AllianceBuildBuildingPanel:onItemRenerer(index, obj)
	local v = self.tablePartyList[index + 1]
	obj:setRepatriateCallBack(handler(self, self.localUpdate))
	obj:initData(v, v.isFold, self.classID, self.data.guardArmyCapacity > 0 and self.data.guardArmyTotalNum >= self.data.guardArmyCapacity)
	obj:setParent(self)
end
return AllianceBuildBuildingPanel
