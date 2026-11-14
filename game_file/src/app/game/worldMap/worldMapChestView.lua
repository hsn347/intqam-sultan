local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local publicRead = include("publicRead")
local worldMapChestView = class("worldMapChestView", function()
	return SoraDCreateTouchPanel("worldMapChestView")
end)
function worldMapChestView:ctor()
	self.chest = nil
	self.isCanReceive = false
	self.chestRewardLimit = 0
	self.tilePoint = nil
	self.isSelfKindom = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	self.gainButton = SoraDGetChildByName(self, "Button_gain")
	if self.gainButton then
		self.gainButton:setTitleText(i18n("common_text_1892"))
		self.gainButton:setEnabled(false)
		self.gainButton:setBright(false)
		self.gainButton:addTouchEventListener(function(ref, type)
			self:gainButtonCallFun(ref, type)
		end)
	end
	self.rewards, gametop, self.text_Name = SoraDGetChildByName(self, "Text_ChestName"), SoraDGetChildByName(self, "Text_ChestName"), SoraDGetChildByName(self, "Text_ChestName")
	for i = 1, 4 do
		self.rewards[i] = SoraDGetChildByName(self, "image_kuang_" .. i)
	end
	local rewardItemName4 = SoraDGetChildByName(self, "Text_item_name_4")
	rewardItemName4:setString(i18n("common_text_486"))
	self.text_talk = SoraDGetChildByName(self, "Text_desInfo")
	self.text_talk:setString(i18n("common_text_1670"))
	self.text_Info = SoraDGetChildByName(self, "Text_info")
	if self.text_Info then
		self.text_Info:setVisible(false)
	end
	self.imgChest = SoraDGetChildByName(self, "Image_chest")
	local randomInfoLabel = SoraDGetChildByName(self, "Text_randomInfo")
	randomInfoLabel:setString(i18n("common_text_488"))
	local warningLabel = SoraDGetChildByName(self, "Text_warning")
	warningLabel:setString(i18n("common_text_1671"))
	SoraDSetTextWidthHeight(warningLabel, cc.size(600, 50))
end
function worldMapChestView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
end
function worldMapChestView:initData(mapInstance)
	self.chest = mapInstance
	self.chestClassID = mapInstance:getChestClassID()
	self.chestData = worldMapDefine.getChestpackShow(self.chestClassID)
	self.imgChest:setSpriteFrame(self.chestData.image)
	self.text_Name:setString(i18n(self.chestData.name) .. " LV." .. self.chest.chestLevel)
	self.text_Info:setVisible(true)
	_ENV = self.chest.chestLevel
	self.chest.chestLevel.count = self.chest.leftCount
	self.text_Info:setString(i18n("common_text_1673", self.chest.chestLevel))
	local isSelfKindom = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	if not isSelfKindom then
		self.gainButton:setTitleText(i18n("common_text_1669"))
		self.gainButton:setEnabled(false)
		self.gainButton:setBright(false)
	elseif self.chest.isColl then
		self.gainButton:setTitleText(i18n("common_text_1892"))
		self.gainButton:setEnabled(false)
		self.gainButton:setBright(false)
	else
		self.gainButton:setTitleText(i18n("common_text_1669"))
		self.gainButton:setEnabled(true)
		self.gainButton:setBright(true)
	end
	local reward = worldMapDefine.getChestpackReward(self.chest.chestLevel)
	if reward then
		for i = 1, 3 do
			SoraDGetChildByName(self.rewards[i], "Sprite_item"):setSpriteFrame(publicRead.getIcon(reward[i]))
			SoraDGetChildByName(self, "Text_item_name_" .. i):setString(publicRead.getName(reward[i]))
		end
	end
	kingdomMapCtrl:reqGetPlayerChestDayReceiveInfo()
	SoraDShowLoading(self)
end
function worldMapChestView:serverMessage_RequestMapInstaceInfo(target, data)
	SoraDCloseLoading(self)
	if not data.data then
		return
	end
	self.isCanReceive = data.data.isCanReceive
	self.chestRewardLimit = data.data.chestRewardLimit
end
function worldMapChestView:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapChestView:getTilePoint()
	return self.tilePoint
end
function worldMapChestView:gainButtonCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.isCanReceive then
			_ENV = nil
			;(nil).count = self.chest.dailyMaxCount
			SoraDShowMsgTip(i18n("notice_0192", nil))
			return
		end
		local physical = lordInfoCtrl:getBaseInfo().physical
		if physical < HP_MIN_MONSTER_CHEST then
			SoraDShowMsgBox(i18n("common_text_988"), i18n("common_text_204"), nil, handler(self, self.physicalNotEnough))
			return
		end
		local hasOtherSolider = kingdomMapCtrl:hasQueue2MapObj(self.chest:getInstanceID())
		if hasOtherSolider then
			_ENV = self.chest:getInstanceID()
			self.chest:getInstanceID().name = i18n(self.chestData.name)
			SoraDShowMsgBox(i18n("common_text_1879", self.chest:getInstanceID()), i18n("common_text_204"))
			return
		end
		if SoraDEnoughTroops() then
			_ENV = SoraDEnoughTroops()
			SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_zhanLing
			SoraDEnoughTroops().toPoint = self.tilePoint
			local SoraDEnoughTroops().instanceID, armyData = self.chest:getInstanceID(), SoraDEnoughTroops()
			worldMapFunction.gotoDispatch(armyData, true)
			_ENV = armyData
			armyData.msg = "MESSAGE_WORLD_MAP_DISPATCH_ARMY"
			armyData.hp = HP_MIN_MONSTER_CHEST
			SoraDSendMessage(armyData)
		end
		self:close(ref, type)
	end
end
function worldMapChestView:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
function worldMapChestView:physicalNotEnough(type)
	if type == nil or type == MSGBOX_CALLBACK_YES then
		SoraDCreatePanel("physicalBuyView"):show()
	end
end
return worldMapChestView
