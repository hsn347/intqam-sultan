local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
local publicRead = include("publicRead")
local worldMapTreasureBowlView = class("worldMapTreasureBowlView", function()
	return SoraDCreateTouchPanel("worldMapTreasureBowlView")
end)
_ENV = "worldMapTreasureBowlView"
;("worldMapTreasureBowlView")[1] = 851501
;("worldMapTreasureBowlView")[2] = 851601
;("worldMapTreasureBowlView")[3] = 851701
local _ENV, ("worldMapTreasureBowlView")[4], treeId = function()
	return SoraDCreateTouchPanel("worldMapTreasureBowlView")
end, 851801, "worldMapTreasureBowlView"
;(function()
	return SoraDCreateTouchPanel("worldMapTreasureBowlView")
end)[1] = "8515.png"
;(function()
	return SoraDCreateTouchPanel("worldMapTreasureBowlView")
end)[2] = "8516.png"
;(function()
	return SoraDCreateTouchPanel("worldMapTreasureBowlView")
end)[3] = "8517.png"
local (function()
	return SoraDCreateTouchPanel("worldMapTreasureBowlView")
end)[4], treeName = "8518.png", function()
	return SoraDCreateTouchPanel("worldMapTreasureBowlView")
end
local REWARD_TREE_MAX_COUNT = 30
local PLANT_TREE_MAX_COUNT = 5
function worldMapTreasureBowlView:ctor()
	self.treasureBowl = nil
	self.isCanClick = false
	self.treasureBowlRewardLimit = 10
	self.colledNum = 0
	self.tilePoint = nil
	self.isSelfKindom = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	self.gainButton = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_gain")
	gametop = "CCS_commonGoldNormalBtn_gain"
	;("CCS_commonGoldNormalBtn_gain").title = i18n("common_text_3541")
	self.gainButton:initData("CCS_commonGoldNormalBtn_gain", 1)
	if self.gainButton then
		self.gainButton:setTouchEnabled(false)
		self.gainButton:setBright(false)
		self.gainButton:addTouchEventListener(function(ref, type)
			self:gainButtonCallFun(ref, type)
		end)
	end
	local itemID = 805701
	local itemDesRead = include("itemDesRead")
	local itemIconImagName = itemDesRead.getIcon(itemID)
	self.gainButton:setIconTexture(itemIconImagName)
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local haveItem, itemNum = backpackCtrl:isThereTheItem(itemID)
	gametop = nil
	;(nil).member = itemNum
	;(nil).total = 1
	self.gainButton:setGoldText(i18n("common_text_155", nil))
	self.gainButton:setTextGoldColor(display.COLOR_WHITE)
	if not haveItem then
		self.gainButton:setTextGoldColor(display.COLOR_RED)
	end
	self.rewards, gametop, self.text_Name = SoraDGetChildByName(self, "Text_TreasureBowlName"), SoraDGetChildByName(self, "Text_TreasureBowlName"), SoraDGetChildByName(self, "Text_TreasureBowlName")
	for i = 1, 4 do
		self.rewards[i] = SoraDGetChildByName(self, "image_kuang_" .. i)
	end
	local rewardItemName4 = SoraDGetChildByName(self, "Text_item_name_4")
	rewardItemName4:setString(i18n("common_text_486"))
	self.panel = SoraDGetChildByName(self, "Center_Node")
	self.text_talk = SoraDGetChildByName(self, "Text_desInfo")
	self.text_talk:setString(i18n("common_text_3545"))
	SoraDSetTextWidthHeight(self.text_talk, cc.size(260, 180))
	self.imgTreasureBowl = SoraDGetChildByName(self, "Image_treasureBowl")
	local randomInfoLabel = SoraDGetChildByName(self, "Text_randomInfo")
	randomInfoLabel:setString(i18n("common_text_488"))
	self.warningLabel = SoraDGetChildByName(self, "Text_warning")
	gametop = i18n("common_text_488")
	i18n("common_text_488").count = self.treasureBowlRewardLimit
	self.warningLabel:setString(i18n("common_text_3540", i18n("common_text_488")))
	SoraDPlaySound("worldmap", 19)
end
function worldMapTreasureBowlView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_TREE_GET_REWARD", handler(self, self.setChristmasTreeInfo))
end
function worldMapTreasureBowlView:initData(mapInstance, treeData, tilePoint, instanceID)
	self.treasureBowl = mapInstance
	self.treasureBowlClassID = mapInstance:getTreasureBowlClassID()
	self.treasureBowlData = worldMapDefine.getTreasureBowlpackShow(self.treasureBowlClassID)
	self.treeData = treeData
	self.tilePoint = tilePoint
	self.instanceID = instanceID
	if not self.treeData then
		self.imgTreasureBowl:setSpriteFrame(self.treasureBowlData.image)
		self.text_Name:setString(i18n(self.treasureBowlData.name) .. " LV." .. self.treasureBowl.treasureBowlLevel)
		local reward = worldMapDefine.getTreasureBowlpackReward(self.treasureBowl.treasureBowlLevel)
		if reward then
			for i = 1, 3 do
				SoraDGetChildByName(self.rewards[i], "Sprite_item"):setSpriteFrame(publicRead.getIcon(reward[i]))
				SoraDGetChildByName(self, "Text_item_name_" .. i):setString(publicRead.getName(reward[i]))
			end
		end
		self:setTreasureBowlInfo()
	else
		self.imgTreasureBowl:setSpriteFrame("sds_bust.png")
		self.text_Name:setString(publicRead.getName(treeId[self.treeData.level]))
		self.text_talk:setString(i18n("christmas_tree_text_17"))
		_ENV = i18n("christmas_tree_text_17")
		i18n("christmas_tree_text_17").text = i18n("common_text_1146")
		self.gainButton:initData(i18n("christmas_tree_text_17"))
		for i = 1, 4 do
			if self.treeData.rewards[2 * i - 1] then
				SoraDGetChildByName(self.rewards[i], "Sprite_item"):setSpriteFrame(publicRead.getIcon(self.treeData.rewards[2 * i - 1]))
				SoraDGetChildByName(self, "Text_item_name_" .. i):setString(publicRead.getName(self.treeData.rewards[2 * i - 1]))
				if i == 4 then
					SoraDGetChildByName(self.rewards[i], "Sprite_item"):setScale(0.65)
				end
			elseif self.rewards[i] then
				self.rewards[i]:setVisible(false)
				SoraDGetChildByName(self, "Text_item_name_" .. i):setVisible(false)
			end
		end
		_ENV = 4
		;(4).text = ""
		;(4).size = 20
		;(4).align = cc.ui.TEXT_ALIGN_CENTER
		;(4).color = cc.c3b(255, 255, 255)
		local labelTime = cc.ui.UILabel.new(4)
		labelTime = SoraDCreateTimerLabel(self, txtRemainTime)
		local remainTime = tonumber(self.treeData.leftTime) - serviceFunctions.systemTime()
		labelTime:setTimeLast(function(str)
			_ENV = nil
			;(nil).Time = str
			return i18n("christmas_tree_text_19", nil)
		end)
		labelTime:beginTime(remainTime)
		labelTime:setTimeEndListener(function(...)
			self:close()
		end)
		labelTime:setPosition(cc.p(self.warningLabel:getPositionX(), self.warningLabel:getPositionY() - 190))
		labelTime:setAnchorPoint(cc.p(0.5, 0.5))
		labelTime:addTo(self.panel)
		_ENV = labelTime
		labelTime.text = ""
		labelTime.size = 20
		labelTime.align = cc.ui.TEXT_ALIGN_CENTER
		labelTime.color = cc.c3b(230, 140, 140)
		self.labelTotal = cc.ui.UILabel.new(labelTime)
		self.labelTotal:setPosition(cc.p(self.warningLabel:getPositionX(), self.warningLabel:getPositionY() - 70))
		self.labelTotal:setAnchorPoint(cc.p(0.5, 0.5))
		self.labelTotal:addTo(self.panel)
		_ENV = self.labelTotal
		self.labelTotal.text = ""
		self.labelTotal.size = 14
		self.labelTotal.align = cc.ui.TEXT_ALIGN_CENTER
		self.labelTotal.color = cc.c3b(255, 255, 255)
		local labelPhysical = cc.ui.UILabel.new(self.labelTotal)
		labelPhysical:setPosition(cc.p(self.warningLabel:getPositionX(), self.warningLabel:getPositionY() - 230))
		labelPhysical:setAnchorPoint(cc.p(0.5, 0.5))
		_ENV = cc.p(0.5, 0.5)
		cc.p(0.5, 0.5).num = 10
		labelPhysical:setString(i18n("christmas_tree_text_24", cc.p(0.5, 0.5)))
		labelPhysical:addTo(self.panel)
		self:setChristmasTreeInfo()
	end
end
function worldMapTreasureBowlView:setTreasureBowlInfo()
	local data = kingdomMapCtrl:getTreasureBowlInfo()
	if not data then
		return
	end
	self.isCanClick = data.isCanClick
	self.treasureBowlRewardLimit = data.rewardLimit
	self.colledNum = data.colledNum
	if self.isCanClick and self.isSelfKindom then
		self.gainButton:setTouchEnabled(true)
		self.gainButton:setBright(true)
	else
		self.gainButton:setTouchEnabled(false)
		self.gainButton:setBright(false)
	end
	local count = self.treasureBowlRewardLimit - self.colledNum
	if count < 0 then
		count = 0
	end
	kingdomMapCtrl = nil
	;(nil).count = count
	self.warningLabel:setString(i18n("common_text_3540", nil))
end
function worldMapTreasureBowlView:setChristmasTreeInfo()
	self.gainButton:setTouchEnabled(true)
	self.gainButton:setBright(true)
	local myData = christmasTreeCtrl:getChristmasTreeData()
	christmasTreeCtrl = nil
	;(nil).Num = REWARD_TREE_MAX_COUNT - (myData and myData.rewardTree or 0)
	self.warningLabel:setString(i18n("christmas_tree_text_18", nil))
	christmasTreeCtrl = i18n("christmas_tree_text_18", nil)
	i18n("christmas_tree_text_18", nil).num = self.treeData.leftCount
	self.labelTotal:setString(i18n("christmas_tree_text_23", i18n("christmas_tree_text_18", nil)))
end
function worldMapTreasureBowlView:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapTreasureBowlView:getTilePoint()
	return self.tilePoint
end
function worldMapTreasureBowlView:gainButtonCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.treeData then
			if not self.isCanClick then
				_ENV = nil
				;(nil).count = self.treasureBowlRewardLimit
				SoraDShowMsgTip(i18n("notice_0192", nil))
				return
			end
			local itemID = 805701
			local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
			local haveItem, num = backpackCtrl:isThereTheItem(itemID)
			if not haveItem then
				SoraDShowMsgTip(i18n("common_text_3621"))
				return
			end
			if not self.treasureBowl or self.treasureBowl == "NONE" or not self.treasureBowl.__cname then
				SoraDShowMsgTip(i18n("notice_0026"))
				self:close(ref, type)
				return
			end
			local selectShowPanel = include("worldMapTreasureBowlOpView").new()
			selectShowPanel:setTilePoint(self.tilePoint)
			selectShowPanel:initData(self.treasureBowl)
			selectShowPanel:show()
		else
			if self.treeData.isColl then
				SoraDShowMsgTip(i18n("christmas_tree_text_20"))
				return
			end
			if not self:checkPhysicalEnough(HP_MIN_CHRISTMAS_TREE) then
				return
			end
			if SoraDEnoughTroops() then
				_ENV = SoraDEnoughTroops()
				SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_zhanLing
				SoraDEnoughTroops().toPoint = self.tilePoint
				local SoraDEnoughTroops().instanceID, armyData = self.instanceID, SoraDEnoughTroops()
				worldMapFunction.gotoDispatch(armyData, true)
				_ENV = armyData
				armyData.msg = "MESSAGE_WORLD_MAP_DISPATCH_ARMY"
				armyData.hp = HP_MIN_CHRISTMAS_TREE
				SoraDSendMessage(armyData)
			end
		end
		self:close(ref, type)
	end
end
function worldMapTreasureBowlView:checkPhysicalEnough(needPhysical)
	local physical = lordInfoCtrl:getBaseInfo().physical
	if needPhysical > physical then
		SoraDShowMsgBox(i18n("common_text_988"), i18n("common_text_204"), nil, handler(self, self.physicalNotEnough))
		return false
	end
	return true
end
function worldMapTreasureBowlView:physicalNotEnough(type)
	if type == nil or type == MSGBOX_CALLBACK_YES then
		SoraDCreatePanel("physicalBuyView"):show()
	end
end
function worldMapTreasureBowlView:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return worldMapTreasureBowlView
