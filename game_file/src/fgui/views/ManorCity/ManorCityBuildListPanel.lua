local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorCityBuildListPanel = class("ManorCityBuildListPanel", baseFguiPanel)
function ManorCityBuildListPanel:ctor(...)
	ManorCityBuildListPanel.super.ctor(self, ...)
	print("ManorCityBuildListPanel:ctor", self.viewName)
end
function ManorCityBuildListPanel:onInit()
	print("=======ManorCityBuildListPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Lab_noData:setString(i18n("decoration_text_27"))
	self.fields.Button_layout:setString(i18n("Socialize_text_10"))
	self.fields.Button_layout:addClickListener(handler(self, self.onClickBtnLayout))
end
function ManorCityBuildListPanel:endShow()
	print("=======ManorCityBuildListPanel:endShow")
	self.isInLayoutEdit = self.param.isInLayoutEdit or nil
	if self.isInLayoutEdit then
		self.fields.Button_layout:setVisible(false)
		self.mapData = self.param.mapData or nil
	else
		local isUnlockLayout = false
		local needBid, needLv = manorCityUtil.getLayoutUnlockCond()
		if needBid and needLv then
			local buildLv = manorCityCtrl:getBuildLvByBid(needBid)
			if needLv <= buildLv then
				isUnlockLayout = true
			end
		end
		self.fields.Button_layout:setVisible(isUnlockLayout)
	end
	local _ENV, buildIDs = isUnlockLayout, true
	for buildType = 1, MANOR_BUILD_TYPE.COLLECTION do
		if buildType == MANOR_BUILD_TYPE.COLLECTION then
			buildIDs[buildType] = manorCityCtrl:getOwnedDressIDList()
		else
			buildIDs[buildType] = manorCityRead.getBuildIDListByType(buildType)
		end
	end
	self.buildIDs = buildIDs
	local defaultClick = MANOR_BUILD_TYPE.BUILD
	self.buildID = self.param.buildID
	if self.buildID then
		defaultClick = manorCityRead.getBuildType(self.buildID)
	end
	_ENV = manorCityRead.getBuildType(self.buildID)
	_ENV, _ENV, manorCityRead.getBuildType(self.buildID).defaultClick = self.fields.Button_layout, self.buildID, defaultClick
	_ENV, self.buildID[1], self.fields.Button_layout.title = self.fields.Button_layout, self.fields.Button_layout, i18n("mail_2_text_51")
	_ENV, self.buildID[2], self.fields.Button_layout.title = self.fields.Button_layout, self.fields.Button_layout, i18n("GardenBuild_Type_02")
	manorCityRead.getBuildType(self.buildID).tabsetArray, self.buildID[3], self.fields.Button_layout.title = self.buildID, self.fields.Button_layout, i18n("GardenBuild_Type_03")
	local manorCityRead.getBuildType(self.buildID).callback, param = handler(self, self.onClickTab), manorCityRead.getBuildType(self.buildID)
	self.fields.com_Tab:initView(param)
	self:updateTabNewState()
end
function ManorCityBuildListPanel:onClickTab(tag)
	self.curTag = tag
	if not self.buildIDs[self.curTag] then
		_ENV = self.buildIDs[self.curTag]
	end
	self.buildIDList = self.buildIDs[self.curTag]
	self.fields.List:setNumItems(#self.buildIDList)
	self.fields.Lab_noData:setVisible(#self.buildIDList == 0)
	if #self.buildIDList > 0 then
		self.fields.List:scrollToView(0)
	end
	if not SoraDIsGameGuide() then
		self:showBuildFinger()
	end
end
function ManorCityBuildListPanel:itemRenderer_List(index, obj)
	local buildID = self.buildIDList[index + 1]
	obj:initData(buildID, self.mapData, self.isInLayoutEdit)
	obj:setClickCallback(handler(self, self.onClickCallback))
end
function ManorCityBuildListPanel:onClickCallback(buildID)
	print("==ManorCityBuildListPanel:onClickCallback==", buildID)
	self:closePanel()
	_ENV = self
	self.msg = "MESSAGE_MANOR_CITY_ENTER_BUILD"
	self.buildID = buildID
	self.isInLayoutEdit = self.isInLayoutEdit
	SoraDSendMessage(self)
end
function ManorCityBuildListPanel:showBuildFinger()
	if self.finger then
		self.finger:removeFromParent()
		self.finger = nil
	end
	if not self.buildID then
		return
	end
	local idx = table.indexof(self.buildIDList, self.buildID)
	if not idx then
		return
	end
	local obj = self.fields.List:GetChildAt(idx - 1)
	if not obj then
		return
	end
	self.fields.List:scrollToView(idx - 1)
	local finger = SoraDFingerAction(nil, nil, 3)
	finger:setName("finger")
	finger:addTo(obj)
	self.finger = finger
	local objSize = obj:getSize()
	finger:setPosition(cc.p(objSize.width / 2, objSize.height / 2))
end
function ManorCityBuildListPanel:gameGuide_getTarget(itemName, parameters)
