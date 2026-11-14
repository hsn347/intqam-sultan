local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local ancientTreasureRead = include("ancientTreasureRead")
local eventAncientSecretDigDetailView = class("eventAncientSecretDigDetailView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventAncientSecretDigDetailView")
	end
	return target
end)
function eventAncientSecretDigDetailView:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self.tableHeights, _ENV, self.tableSingleList, _ENV = SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget
	self.leftDigValue = 0
	self.digSpeed = 0
	self.digLeftTime = 0
	self.totalArmyNum = 0
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("activity_name_9001201"))
	self.Text_digPercent:setString(i18n("AncienTreasure_text_48"))
	self.Text_digleftTime:setString(i18n("AncienTreasure_text_49"))
	self.Text_digTime = SoraDCreateTimerLabel(self, self.Text_digTime)
	self.Text_digArmyNum:setString(i18n("AncienTreasure_text_50"))
	self.Text_des:setString(i18n("AncienTreasure_text_51"))
	self.Text_digging:setString(i18n("overview_text_03"))
	self:suitView()
end
function eventAncientSecretDigDetailView:suitView()
	self.Image_dec_left:setFillType(1)
	self.Image_dec_right:setFillType(1)
	self.Image_left:setContentSize(cc.size(display.height - 450, 80))
	self.Image_right:setContentSize(cc.size(display.height - 450, 80))
	self.ScrollView_list:setContentSize(cc.size(630, display.height - 495))
end
function eventAncientSecretDigDetailView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_info))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE", handler(self, self.isRemoveBuild))
	SoraDAddMessage(self, "MESSAGE_UI_ANCIENT_DIGDETAILVIEW", handler(self, self.updateScrollView))
end
function eventAncientSecretDigDetailView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function eventAncientSecretDigDetailView:isRemoveBuild(target, data)
	if data and (data.msgType == "removeBuild" and data.removeID == self.buildID or data.isOccupy) then
		self:removeFromParent()
	end
end
function eventAncientSecretDigDetailView:initData(instance)
	self.instance = instance
	self.buildID = self.instance.buildID
	self:setBoxInfo()
	SoraDShowLoading(self)
	kingdomMapCtrl:reqMapObjInfo(self.instance:getTilePoint().x, self.instance:getTilePoint().y, self.instance:getInstanceID(), self.instance:getWorldMapCell().kingdomID)
end
function eventAncientSecretDigDetailView:updateView(time)
	if self.leftDigValue and self.leftDigValue > 0 then
		self.leftDigValue = self.leftDigValue - self.digSpeed
		self:setDigPercent(self.leftDigValue)
	end
end
function eventAncientSecretDigDetailView:closeSelfView()
	self:removeFromParent()
end
function eventAncientSecretDigDetailView:setDigPercent(digValue)
	local areadyDig = (self.data.outputNum - self.data.remainNum) * 100 / self.data.outputNum
	local percent = math.floor(areadyDig + (self.data.remainNum - digValue) * 100 / self.data.outputNum)
	self.LoadingBar_bar:setPercent(percent)
	self.Text_percent:setString(percent .. "%")
end
function eventAncientSecretDigDetailView:serverMessage_info(target, data)
	SoraDCloseLoading(self)
	if not data.data.data then
		_ENV = data.data.data
	end
	self.data = data.data.data
	dump(data, "eventAncientSecretDigDetailView data======", 10)
	self.leftDigValue, self.digSpeed, self.digLeftTime, self.totalArmyNum = ancientTreasureCtrl:getWajueValue(self.data)
	if self.totalArmyNum > 0 then
		self:setDigPercent(self.leftDigValue)
		self.Text_digTime:beginTime(self.digLeftTime)
		self.Text_digTime:setTimeUpdateListener(handler(self, self.updateView))
		self.Text_digTime:setTimeEndListener(handler(self, self.closeSelfView))
		self.Text_digNum:setString(string.formatnumberthousands(self.totalArmyNum) .. "/" .. string.formatnumberthousands(self.data.maxNum))
		self.Text_digging:setVisible(true)
	else
		self.Text_digTime:setString("--:--:--")
		self:setDigPercent(self.leftDigValue)
		self.Text_digNum:setString("--/--")
	end
	self:setScrollInfo()
end
function eventAncientSecretDigDetailView:setScrollInfo()
	if not self.data.army then
		_ENV = self.data.army
	end
	self.data.army = self.data.army
	if self.data.maxNum and self.totalArmyNum < self.data.maxNum or not self.data.maxNum then
		_ENV = nil
		table.insert(self.data.army, nil)
	end
	self:initView()
end
function eventAncientSecretDigDetailView:initView()
	self.ScrollView_list:removeAllChildren()
	self.tableSingleList, _ENV = self.ScrollView_list.removeAllChildren, self.ScrollView_list.removeAllChildren
	dump(self.data.army, "self.data.army====", 10)
	local sSize = self.ScrollView_list:getContentSize()
	local sH = math.max(#self.data.army * 110, sSize.height)
	self.ScrollView_list:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.data.army) do
		local armySingle = SoraDCreatePanel("eventAncientSecretDigSingle")
		armySingle:addTo(self.ScrollView_list)
		_ENV = cc.size(sSize.width, sH)
		cc.size(sSize.width, sH).isOccupy = self.totalArmyNum > 0
		cc.size(sSize.width, sH).view = self
		cc.size(sSize.width, sH).scroll = self.ScrollView_list
		cc.size(sSize.width, sH).instance = self.instance
		cc.size(sSize.width, sH).leftDigTime = self.digLeftTime
		cc.size(sSize.width, sH).outputNum = self.data.remainNum
		armySingle:initData(v, cc.size(sSize.width, sH))
		table.insert(self.tableSingleList, armySingle)
	end
	self:scrollListPosUpdate()
end
function eventAncientSecretDigDetailView:updateScrollView(target, data)
	self:scrollListPosUpdate()
end
function eventAncientSecretDigDetailView:setBoxInfo()
	local buildInfo = ancientTreasureRead.getBuildInfo(self.instance.buildType)
	self.Image_box:loadTexture(buildInfo.icon, ccui.TextureResType.plistType)
	self.Text_boxName:setString(i18n(buildInfo.name))
	self.Button_box = include("commonBtnInstance").new(self.Button_box)
	self.Button_box:setItemInfo(self, buildInfo.item, 1)
end
function eventAncientSecretDigDetailView:getSpeed()
	local speed = 0
	if self.data.army then
		for k, v in pairs(self.data.army) do
			if v.armyList then
				local power = ancientTreasureCtrl:getArmySpeed(v.armyList)
				speed = speed + power
			end
		end
		return speed
	end
	return 0
end
function eventAncientSecretDigDetailView:scrollListPosUpdate()
	self.tableHeights, _ENV = nil, nil
	local sSize = self.ScrollView_list:getContentSize()
	local totalInnerH = 0
	for i, v in ipairs(self.tableSingleList) do
		totalInnerH = totalInnerH + v.size.height
		if i == 1 then
			self.tableHeights[i] = 110
		else
			self.tableHeights[i] = self.tableHeights[i - 1] + self.tableSingleList[i - 1].size.height
		end
	end
	local sH = math.max(totalInnerH, sSize.height)
	self.ScrollView_list:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.tableSingleList) do
		v:setPosition(cc.p(0, sH - self.tableHeights[i]))
	end
end
return eventAncientSecretDigDetailView
