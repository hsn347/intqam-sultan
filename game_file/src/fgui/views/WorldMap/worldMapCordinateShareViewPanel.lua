local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local worldMapDefine = include("worldMapDefine")
local chatCtrl = SoraDGetCtrl("chatCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local worldMapWarDef = include("worldMapWarDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local worldMapCordinateShareViewPanel = class("worldMapCordinateShareViewPanel", baseFguiPanel)
function worldMapCordinateShareViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("worldMapCordinateShareViewPanel:ctor", self.viewName)
end
function worldMapCordinateShareViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function worldMapCordinateShareViewPanel:onInit()
	print("=======worldMapCordinateShareViewPanel:onInit")
	self.totalData, _ENV = print, print
	self.confirmTag = 0
	self.fields.Panel_bg:setString(i18n("position_share_04"))
	self.fields.Button_share:setString(i18n("common_text_204"))
	self.fields.Button_share:addClickListener(handler(self, self.btnConfirmClickCallBack))
	self.fields.Button_share:setEnabled(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:addClickListener(handler(self, self.onItemClick))
end
function worldMapCordinateShareViewPanel:onItemRender(index, target)
	target:initData(self.totalData[index + 1], self.mapData.kingdomID)
end
function worldMapCordinateShareViewPanel:onItemClick()
	SoraDPlaySound()
	local selectIndex = self.fields.List:getSelectedIndex() + 1
	if selectIndex == 0 then
		self.fields.Button_share:setEnabled(false)
		return
	end
	local isSelect = self.fields.List:getChildAt(selectIndex - 1):isTickSelect()
	self.confirmTag = isSelect and selectIndex or 0
	print("selectIndex,isSelect,self.confirmTag====", selectIndex, isSelect, self.confirmTag)
	self.fields.Button_share:setEnabled(self.confirmTag ~= 0)
end
function worldMapCordinateShareViewPanel:onShow()
	print("=======worldMapCordinateShareViewPanel:onShow")
	if not self.param.mapData then
		_ENV = self.param.mapData
	end
	self.mapData = self.param.mapData
	self.activityID = self.param.activityID
	chatroomCtrl:reqChatRoomAllInfo(20)
	SoraDShowLoading(self)
	if self.activityID == gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY then
		self.fields.List:setSelectionMode(fgui.ListSelectionMode.Multiple_SingleClick)
	else
		self.fields.List:setSelectionMode(fgui.ListSelectionMode.Multiple)
	end
end
function worldMapCordinateShareViewPanel:reqAllChatRoomInfo()
	contactCtrl:reqGetData(true, false, false)
end
function worldMapCordinateShareViewPanel:initData(mapData)
	self.mapData = mapData or self.mapData
end
function worldMapCordinateShareViewPanel:friendDataBack()
	self:initData(self.mapData)
	SoraDCloseLoading(self)
	self:sortData()
	self:initScroll()
end
function worldMapCordinateShareViewPanel:sortData()
	if worldMapDefine.isNebulaAllStarViewer(self.kingdomID) then
		worldMapDefine = nil
		;(nil).channel = gChatChannel.VIEWER
		table.insert(self.totalData, nil)
	else
		worldMapDefine = nil
		;(nil).channel = gChatChannel.KINGDOM
		table.insert(self.totalData, nil)
		if worldMapDefine.isInNebula() then
			worldMapDefine = nil
			;(nil).channel = gChatChannel.CAMP
			table.insert(self.totalData, nil)
		end
		local showAllianceChat = false
		if worldMapWarDef.isInWarForbidShowAllianceChat() then
			showAllianceChat = false
		else
			showAllianceChat = allianceMgr:hasJoinAlliance()
		end
		if showAllianceChat then
			worldMapDefine = gChatChannel.CAMP
			gChatChannel.CAMP.channel = gChatChannel.ALLIANCE
			table.insert(self.totalData, gChatChannel.CAMP)
		end
		if worldMapDefine.isInTeamChannel() then
			worldMapDefine = gChatChannel.CAMP
			gChatChannel.CAMP.channel = gChatChannel.TEAM
			table.insert(self.totalData, gChatChannel.CAMP)
		end
	end
	if not self.activityID then
		local chatRoomList = clone(chatroomCtrl:getAllChatRoomInfo())
		if chatRoomList and next(chatRoomList) then
			for _, v in ipairs(chatRoomList) do
				v.channel = gChatChannel.CHATROOM
				table.insert(self.totalData, v)
			end
		end
	end
	local friendList = clone(contactCtrl:getContactList())
	table.sort(friendList, function(l, r)
		return l.totalFc > r.totalFc
	end)
	for k, v in pairs(friendList) do
		v.uid = tonumber(k)
		if not chatCtrl:isShield(v.uid) then
			v.channel = gChatChannel.MAIL
			table.insert(self.totalData, v)
		end
	end
end
function worldMapCordinateShareViewPanel:initScroll()
	self.fields.List:setNumItems(#self.totalData)
end
function worldMapCordinateShareViewPanel:btnConfirmClickCallBack()
	SoraDPlaySound()
	local activityID = self.param.activityID
	if activityID then
		self:onShareActivity(activityID)
		self:close()
		return
	end
	local subType, targetid, roomCrid
	for i, v in ipairs(self.totalData) do
		if v.crid and self.confirmTag == i then
			roomCrid = v.crid
			break
		elseif v.uid and self.confirmTag == i then
			targetid = v.uid
			break
		end
	end
	self.confirmTag = self.totalData[self.confirmTag].channel
	if self.mapData.isEndLess then
		local subType = gWorldTypeServerDef.mapTypeEndlessTrialsPortal
		chatCtrl:chatSharePos(self.confirmTag, self.mapData.kingdomID, gMapObjTypeDef.mapTypeEndlessTrialsPortal, subType, self.mapData.x, self.mapData.y, nil, targetid, roomCrid)
		self:close()
		return
	end
	if self.mapData.mapInstance then
		local instanceID = self.mapData.mapInstance.instanceID
		local instanceType = self.mapData.mapInstance.instanceType
		local resourceClassID = self.mapData.mapInstance.resourceClassID
		if instanceType == gMapObjTypeDef.mapObjTypeResource then
			subType = worldMapDefine.getResourceType(resourceClassID)
		elseif instanceType == gMapObjTypeDef.mapObjTypeRelics then
			subType = gWorldTypeServerDef.subMapTypeAWRelic
		elseif instanceType == gMapObjTypeDef.mapObjTypeSuperResource then
			subType = worldMapDefine.getAllianceResourceType(resourceClassID)
		elseif instanceType == gMapObjTypeDef.mapObjTypePlayer then
		elseif instanceType == gMapObjTypeDef.mapObjTypeAllianceBuild then
			subType = self.mapData.mapInstance:getBuildClassID()
		elseif instanceType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
			subType = self.mapData.mapInstance:getSiteClassID()
		elseif instanceType == gMapObjTypeDef.mapTypeMine then
			subType = self.mapData.mapInstance:getBuildClassID()
		elseif instanceType == gMapObjTypeDef.stronghold then
			subType = self.mapData.mapInstance:getBuildClassID()
		elseif instanceType == gMapObjTypeDef.nebulaWarBuilding then
			subType = self.mapData.mapInstance:getSubType()
		elseif instanceType == gMapObjTypeDef.nebulaWarMine then
			subType = self.mapData.mapInstance:getSiteClassID()
		elseif instanceType == gMapObjTypeDef.nebulaEmperorWarBuilding then
			subType = self.mapData.mapInstance:getSiteClassID()
		elseif instanceType == gMapObjTypeDef.nebulaAllStarWarBuilding then
			local mapInstance = self.mapData.mapInstance
			subType = mapInstance.subType or mapInstance:getSiteClassID()
		elseif instanceType == gMapObjTypeDef.nebulaDefenceWarBuilding then
			subType = self.mapData.mapInstance:getBuildClassID()
		elseif instanceType == gMapObjTypeDef.bubbleLandGift then
			subType = self.mapData.mapInstance:getGiftType()
		elseif instanceType == gMapObjTypeDef.fantasyLandGift then
			subType = self.mapData.mapInstance:getGiftType()
		elseif instanceType == gMapObjTypeDef.roaringFlameWarBuilding then
			subType = self.mapData.mapInstance:getSubType()
		elseif instanceType == gMapObjTypeDef.simulatedDrillWarBuilding then
			subType = self.mapData.mapInstance.objId
		elseif instanceType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
			subType = self.mapData.mapInstance:getSiteClassID()
		else
			subType = self.mapData.mapInstance.subType
		end
		if self.mapData.mapInstance.userData then
			instanceType = self.mapData.mapInstance.userData.fromObjectType
			if instanceType == gMapObjTypeDef.mapObjTypeBattlefieldSite and self.mapData.mapInstance.userData.cartLv then
				subType = gMapBattlefieldSiteTypeDef.subTypeAWSupply
			end
		end
		chatCtrl:chatSharePos(self.confirmTag, self.mapData.kingdomID, instanceType, subType, self.mapData.x, self.mapData.y, self.mapData.mapInstance.playerName, targetid, roomCrid)
	else
		chatCtrl:chatSharePos(self.confirmTag, self.mapData.kingdomID, gMapObjTypeDef.mapTypePlain, subType, self.mapData.x, self.mapData.y, nil, targetid, roomCrid)
	end
	self:close()
end
function worldMapCordinateShareViewPanel:onShareActivity(activityID)
	_ENV = nil
	local toUids, toAlliance, toKingdom = nil, false, false
	local seletion = self.fields.List:GetSelection()
	for __, selectIndex in ipairs(seletion) do
		local data = self.totalData[selectIndex + 1]
		local channel = data.channel
		if channel == gChatChannel.KINGDOM then
			toKingdom = true
		elseif channel == gChatChannel.ALLIANCE then
			toAlliance = true
		elseif channel == gChatChannel.MAIL then
			table.insert(toUids, data.uid)
		end
	end
	if activityID == gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY then
		local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
		simulatedDrillCtrl:reqRoomShare(toUids, toAlliance, toKingdom)
	end
end
return worldMapCordinateShareViewPanel
