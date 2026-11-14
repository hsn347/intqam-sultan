local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local manorFarmRead = include("manorFarmRead")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildGarden = class("cityBuildGarden", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildGarden:ctor()
end
function cityBuildGarden:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_UNLOCK", handler(self, self.onMsgManorCityUnlock))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_NEW", handler(self, self.onMsgManorBuildNew))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_UPGRADE_QUEUE", handler(self, self.onMsgManorBuildQueue))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TECH_QUEUE", handler(self, self.onMsgManorTechQueue))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_PLACE", handler(self, self.onMsgMapPlace))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_MAIN_LV_UP", handler(self, self.onMsgMainBuildLvUp))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.onMsgMagicLampUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_INIT", handler(self, self.onMsgManorCityMapInit))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_UPDATE", handler(self, self.onMsgFarmTopTipUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_PLANT", handler(self, self.onMsgFarmTopTipUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_PICK", handler(self, self.onMsgFarmTopTipUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_PICK_ALL", handler(self, self.onMsgFarmTopTipUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT", handler(self, self.onMsgFarmTopTipUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT_PICK", handler(self, self.onMsgFarmTopTipUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT_TIME_END", handler(self, self.onMsgFarmTopTipUpdate))
end
function cityBuildGarden:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("garden_btn_02"), i18n("garden_btn_02")
	i18n("garden_btn_02").x = 0
	;(nil).pos, i18n("garden_btn_02").y = i18n("garden_btn_02"), -150
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildGarden:onAfterInitWithoutBuildCell()
	print("==cityBuildGarden:onAfterInitWithoutBuildCell==")
	if not self:getIsLockVisible() then
		return
	end
	self:updateView()
end
function cityBuildGarden:updateView()
	self:updateIsLock()
	self:showBuildLv()
	self:updateTextLv()
	self:updateLvPos()
	self:updateNewBubble()
	self:updateCooling()
	if self:getIsLocked() and SoraDCheckNoGuideNoPanelAndInMianCity() then
		_ENV = self
		self.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		self.step = 9991900
		SoraDSendMessage(self)
	end
end
function cityBuildGarden:showBuildLv()
	if self.textLv then
		self.textLv:setVisible(true)
	end
	if self.buildLvBg then
		self.buildLvBg:setVisible(true)
	end
end
function cityBuildGarden:updateTextLv()
	local buildLv = manorCityCtrl:getGardenBuildLv()
	self:setTextLv(buildLv)
end
function cityBuildGarden:getIsLocked()
	if not self:getIsLockVisible() then
		return false
	end
	if manorCityCtrl:getIsUnLock() then
		return false
	end
	return true
end
function cityBuildGarden:getIsLockVisible()
	if manorCityCtrl:getIsUnLock() then
		return true
	end
	if not manorCityUtil.checkServerUnlock() then
		return false
	end
	if not manorCityUtil.checkClientUnlock() then
		return false
	end
	return true
end
function cityBuildGarden:onMsgManorCityUnlock()
	self:updateIsLock()
	self:updateNewBubble()
	self:updateCooling()
end
function cityBuildGarden:checkBuildClick()
	if self:getIsLocked() then
		if not SoraDIsGameGuide() then
			_ENV = self
			self.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			self.step = 9991900
			SoraDSendMessage(self)
			return false
		end
		manorCityCtrl:reqGardenUnlock()
		return false
	end
	return true
end
function cityBuildGarden:onClickBuildTopTip(topType)
	if topType == cityBuildConstDef.topType.TOP_TYPE_GARDEN_FARM_REWARD then
		if not self.gardenTopTipData and not self:getGardenTopTipData() then
			local cityBuildConstDef, topTipData = self:getGardenTopTipData(), self:getGardenTopTipData()
		end
		cityBuildConstDef = nil
		;(nil).jumpBuildID = MANOR_BUILD_ID.FARM
		;(nil).jumpIid = topTipData.iid
		;(nil).selectBuild = true
		manorCityUtil.gotoGardenCity(nil)
	elseif topType == cityBuildConstDef.topType.TOP_TYPE_GARDEN_CULTIVATE_FULL then
		cityBuildConstDef = manorCityUtil.gotoGardenCity
		manorCityUtil.gotoGardenCity.showSeedBookFinger = true
		manorCityUtil.gotoGardenCity(manorCityUtil.gotoGardenCity)
	elseif topType == cityBuildConstDef.topType.TOP_TYPE_GARDEN_NEW then
		manorCityUtil.gotoGardenCity()
	end
end
function cityBuildGarden:updateNewBubble()
	self:updateTopTip()
end
function cityBuildGarden:showNewBubble(isNew)
	self:updateTopTip()
end
function cityBuildGarden:getGardenTopTipData()
