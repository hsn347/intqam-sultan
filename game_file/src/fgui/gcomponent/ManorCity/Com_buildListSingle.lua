local manorCityRead = include("manorCityRead")
local manorCityUtil = include("manorCityUtil")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_buildListSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorCity/Com_buildListSingle", Com_buildListSingle)
function Com_buildListSingle:onInit()
	self:addClickListener(handler(self, self.onClickItem))
	if not SoraDFIsRA() then
		self.fields.Text_build:fixPos()
		self.fields.Text_buildValue:fixPos()
	end
end
function Com_buildListSingle:onShow()
end
function Com_buildListSingle:setClickCallback(callback)
	self.clickCallback = callback
end
function Com_buildListSingle:onClickItem()
	SoraDPlaySound()
	local selectIndex = self.controllers.c1:getSelectedIndex()
	if selectIndex == 0 then
		if self.clickCallback then
			self.clickCallback(self.buildID)
		end
	elseif selectIndex == 1 then
		if 0 >= self.hasCount then
			self:showMsgTip1()
		else
			self:showMsgTip2()
		end
	elseif selectIndex == 2 then
		self:showMsgTip2()
	end
end
function Com_buildListSingle:showMsgTip1()
	local buildName = manorCityRead.getBuildName(self.data.bid)
	local buildLv = self.data.blv
	manorCityRead = nil
	;(nil).buildName = buildName
	;(nil).lv = buildLv
	local msgTip = i18n("garden_text_53", nil)
	SoraDShowMsgTip(msgTip)
end
function Com_buildListSingle:showMsgTip2()
	SoraDShowMsgTip(i18n("garden_text_31"))
	if self.buildType == MANOR_BUILD_TYPE.BUILD then
		_ENV = MANOR_BUILD_TYPE.BUILD
		MANOR_BUILD_TYPE.BUILD.msg = "MESSAGE_MANOR_CITY_GO_TO_BUILD"
		MANOR_BUILD_TYPE.BUILD.buildID = self.buildID
		MANOR_BUILD_TYPE.BUILD.isInLayoutEdit = self.isInLayoutEdit
		SoraDSendMessage(MANOR_BUILD_TYPE.BUILD)
	end
end
function Com_buildListSingle:initData(buildID, mapData, isInLayoutEdit)
	self.buildID = buildID
	self.mapData = mapData
	self.isInLayoutEdit = isInLayoutEdit
	local buildImage = manorCityRead.getBuildSmallImage(buildID)
	self.fields.Image_build:setURL(buildImage)
	local buildName = manorCityRead.getBuildName(buildID)
	self.fields.Text_name:setString(buildName)
	local c1 = self.controllers.c1
	local buildType = manorCityRead.getBuildType(buildID)
	self.buildType = buildType
	if self.buildType == MANOR_BUILD_TYPE.BUILD or self.buildType == MANOR_BUILD_TYPE.SCENERY then
		self.hasCount = manorCityCtrl:getBuildCountByBid(buildID, self.mapData)
		self.maxCount = manorCityRead.getBuildMaxNum(buildID)
		self.unlockNum = manorCityUtil.getBuildUnlockNum(buildID)
		local unlock, data = manorCityUtil.checkBuildUnlock(buildID, self.hasCount + 1)
		if not unlock then
			self:doState1(data)
			return
		end
		if self.hasCount >= self.maxCount then
			self:doState2()
		else
			self:doState0()
		end
	elseif self.buildType == MANOR_BUILD_TYPE.COLLECTION then
		self.hasCount = manorCityCtrl:getBuildCountByBid(buildID, self.mapData)
		self.maxCount = 1
		self.unlockNum = self.maxCount
		if self.hasCount >= self.maxCount then
			self:doState2()
		else
			self:doState0()
		end
	end
	if self.buildType == MANOR_BUILD_TYPE.COLLECTION then
		local bgName = manorCityRead.getDressBg2(buildID)
		self.fields.bg:setURL(bgName)
	else
		local bgName = manorCityRead.getDressBg2ByQuality(4)
		self.fields.bg:setURL(bgName)
	end
end
function Com_buildListSingle:doState0()
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Text_build:setString(i18n("decoration_text_28"))
	self.fields.Text_buildValue:setString(self.hasCount .. "/" .. self.unlockNum)
	if not self.mapData and self.hasCount < self.unlockNum then
		local isNew = manorCityUtil.getBuildIsNew(self.buildID)
		self.fields.Image_new:setVisible(isNew)
	else
		self.fields.Image_new:setVisible(false)
	end
end
function Com_buildListSingle:doState1(data)
	self.data = data
	self.controllers.c1:setSelectedIndex(1)
	if self.hasCount == 0 then
		self.fields.Text_build2:setString("")
	else
		local buildStr = i18n("decoration_text_30") .. self.hasCount .. "/" .. self.unlockNum
		self.fields.Text_build2:setString(buildStr)
	end
	local buildName = manorCityRead.getBuildName(data.bid)
	_ENV = buildStr
	buildStr.buildName = buildName
	buildStr.num = data.blv
	local lockStr = i18n("decoration_text_29", buildStr)
	self.fields.Text_lock:setString(lockStr)
end
function Com_buildListSingle:doState2()
	self.controllers.c1:setSelectedIndex(2)
	local buildStr = i18n("decoration_text_30") .. self.hasCount .. "/" .. self.unlockNum
	self.fields.Text_build2:setString(buildStr)
	self.fields.Text_limit:setString(i18n("commandhall_text_4"))
end
return Com_buildListSingle
