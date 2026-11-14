local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local baseComponent = require("fgui.base.baseComponent")
local ManorUIBottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/ManorUIBottom", ManorUIBottom)
function ManorUIBottom:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS", handler(self, self.initAllianceHelpBtn))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_DRESS_UPDATE", handler(self, self.onMsgDressUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_DRESS_EXCHANGE", handler(self, self.onMsgDressExchange))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_BACKPACK_UPDATE", handler(self, self.onMsgBackpackUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_MAIN_LV_UP", handler(self, self.onMsgBuildMainLvUp))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_LV_UP", handler(self, self.onMsgBuildLvUp))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_INIT", handler(self, self.onMsgMapInit))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_NEW", handler(self, self.onMsgBuildNew))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_UPDATE", handler(self, self.onMsgFarmFruitCultivateReddotUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT", handler(self, self.onMsgFarmFruitCultivateReddotUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT_PICK", handler(self, self.onMsgFarmFruitCultivateReddotUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT_TIME_END", handler(self, self.onMsgFarmFruitCultivateReddotUpdate))
end
function ManorUIBottom:onInit()
	self.fields.Button_build:addClickListener(handler(self, self.onClickBtnBuild))
	self.Image_new = self.fields.Button_build:getChild("Image_new")
	self.fields.Button_worldCity:addClickListener(handler(self, self.onClickBtnWorldCity))
	self.fields.Button_dressBook:setString(i18n("garden_btn_07"))
	self.fields.Button_dressBook:addClickListener(handler(self, self.onClickBtnDressBook))
	self.fields.Button_dressBag:setString(i18n("garden_btn_06"))
	self.fields.Button_dressBag:addClickListener(handler(self, self.onClickBtnDressBag))
	self.fields.Button_seedBook:setString(i18n("farmland_text_25"))
	self.fields.Button_seedBook:addClickListener(handler(self, self.onClickBtnSeedBook))
	self.fields.Button_seedBag:setString(i18n("garden_btn_09"))
	self.fields.Button_seedBag:addClickListener(handler(self, self.onClickBtnSeedBag))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function ManorUIBottom:onShow()
	self:initAllianceHelpBtn()
	self:updateBtnUnlock()
	self:updateBtnBuildNew()
	self:updateDressBookRedPoint()
	self:updateSeedBookRedPoint()
	self:updateBtnUnlockSeedBook()
end
function ManorUIBottom:onHide()
	self:removeSeedBookFinger()
end
function ManorUIBottom:onClickBtnBuild()
	SoraDPlaySound()
	local param
	if tonumber(SoraDIsGameGuide()) == 1270101 then
		_ENV = tonumber(SoraDIsGameGuide())
		param, tonumber(SoraDIsGameGuide()).buildID = tonumber(SoraDIsGameGuide()), MANOR_BUILD_ID.FARM
	end
	uiManager:show("ManorCityBuildList", param)
end
function ManorUIBottom:onClickBtnWorldCity()
	SoraDPlaySound()
	if self.isGardenWarUI then
		manorCityUtil.gotoGardenCity()
	elseif worldMapDefine.isInGarden() then
		uiManager:close("ManorCityView")
	else
		manorCityCtrl:reqInWarMap()
	end
end
function ManorUIBottom:onClickBtnDressBook()
	SoraDPlaySound()
	if not manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_DECORATION", true) then
		return
	end
	uiManager:show("ManorDressBook")
end
function ManorUIBottom:onClickBtnDressBag()
	SoraDPlaySound()
	if not manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_DECORATION", true) then
		return
	end
	uiManager:show("ManorDressBag")
end
function ManorUIBottom:onClickBtnSeedBook()
	SoraDPlaySound()
	self:removeSeedBookFinger()
	if not manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_FARMLAND", true) then
		return
	end
	uiManager:show("FarmHandbook")
end
function ManorUIBottom:showSeedBookFinger()
	self:updateBtnUnlock()
	if not self.isSeedCultivationUnlock then
		self:removeSeedBookFinger()
		return
	end
	local button = self.fields.Button_seedBook
	if not button then
		return
	end
	self:removeSeedBookFinger()
	local finger = SoraDFingerAction()
	finger:setName("finger")
	finger:addTo(button:displayObject())
	self.seedBookFinger = finger
	local buttonSize = button:getSize()
	finger:setPosition(buttonSize.width / 2, buttonSize.height / 2)
end
function ManorUIBottom:removeSeedBookFinger()
	if self.seedBookFinger then
		self.seedBookFinger:removeFromParent()
		self.seedBookFinger = nil
	end
	local button = self.fields and self.fields.Button_seedBook
	if button and button.displayObject then
		local finger = button:displayObject():getChildByName("finger")
		if finger then
			finger:removeFromParent()
		end
	end
end
function ManorUIBottom:onClickBtnSeedBag()
	SoraDPlaySound()
	if not manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_FARMLAND", true) then
		return
	end
	uiManager:show("FarmBag")
end
function ManorUIBottom:initAllianceHelpBtn()
	if self.isGardenWarUI then
		self.fields.Button_allianceHelp:setVisible(false)
		return
	end
	local allianceHelp = SoraDGetCtrl("allianceHelp")
	if allianceHelp:getIsCanHelp() then
		self.fields.Button_allianceHelp:setVisible(true)
		local helpCount = #allianceHelp:getHelpList().otherhelplist
		self.fields.Button_allianceHelp:setRed(helpCount)
	else
		self.fields.Button_allianceHelp:setVisible(false)
	end
end
function ManorUIBottom:updateDressBookRedPoint()
	if not self.isDressUnlock then
		return
	end
	local isRed = manorCityCtrl:getDressBookRedPoint()
	self.fields.Button_dressBook:setReddot(isRed)
end
function ManorUIBottom:updateSeedBookRedPoint()
	if not self.isSeedCultivationUnlock then
		self.fields.Button_seedBook:setReddot(false)
		return
	end
	local isRed = manorCityCtrl:getFarmFruitCultivateReddot()
	self.fields.Button_seedBook:setReddot(isRed)
end
function ManorUIBottom:onMsgDressUpdate()
	self:updateDressBookRedPoint()
end
function ManorUIBottom:onMsgDressExchange()
	self:updateDressBookRedPoint()
end
function ManorUIBottom:onMsgBackpackUpdate()
	self:updateDressBookRedPoint()
end
function ManorUIBottom:onMsgBuildMainLvUp()
	self:updateDressBookRedPoint()
	self:updateSeedBookRedPoint()
	self:updateBtnUnlock()
end
function ManorUIBottom:onMsgFarmFruitCultivateReddotUpdate()
	self:updateSeedBookRedPoint()
end
function ManorUIBottom:setIsGardenWarUI(isGardenWarUI)
	self.isGardenWarUI = isGardenWarUI
	self.fields.Button_build:setVisible(not isGardenWarUI)
	self:initAllianceHelpBtn()
	if isGardenWarUI and not worldMapDefine.isInGarden() then
		self.fields.Button_worldCity:setVisible(false)
		self.fields.Button_allianceHelp:setVisible(false)
		self.fields.Button_dressBook:setVisible(false)
		self.fields.Button_dressBag:setVisible(false)
		self.fields.Button_seedBook:setVisible(false)
		self.fields.Button_seedBag:setVisible(false)
	end
end
function ManorUIBottom:updateBtnUnlock()
	self:updateBtnUnlockDress()
	self:updateBtnUnlockFarmland()
	self:updateBtnUnlockSeedBook()
end
function ManorUIBottom:updateBtnUnlockDress()
	if self.isDressUnlock then
		return
	end
	local unlock = manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_DECORATION")
	self.isDressUnlock = unlock
	local c_unlock = self.fields.Button_dressBook:getController("unlock")
	c_unlock:setSelectedIndex(unlock and 0 or 1)
	if unlock then
		self:updateDressBookRedPoint()
	end
	local c_unlock = self.fields.Button_dressBag:getController("unlock")
	c_unlock:setSelectedIndex(unlock and 0 or 1)
end
function ManorUIBottom:updateBtnUnlockFarmland()
	if self.isFarmlandUnlock then
		return
	end
	local unlock = manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_FARMLAND")
	self.isFarmlandUnlock = unlock
	local c_unlock = self.fields.Button_seedBag:getController("unlock")
	c_unlock:setSelectedIndex(unlock and 0 or 1)
end
function ManorUIBottom:updateBtnUnlockSeedBook()
	local unlock = manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_FARMLAND")
	local c_unlock = self.fields.Button_seedBook:getController("unlock")
	c_unlock:setSelectedIndex(unlock and 0 or 1)
	self:updateSeedBookRedPoint()
	if not unlock then
		self:removeSeedBookFinger()
	end
end
function ManorUIBottom:onMsgBuildLvUp(target, event)
	local buildId = event.buildId
	local buildLv = event.buildLv
	local unlockBid = self:getUnlockBuildId("GARDEN_UNLOCK_DECORATION")
	if unlockBid and buildId == unlockBid then
		self:updateBtnUnlockDress()
	end
	local unlockBid = self:getUnlockBuildId("GARDEN_UNLOCK_FARMLAND")
	if unlockBid and buildId == unlockBid then
		self:updateBtnUnlockFarmland()
		self:updateBtnUnlockSeedBook()
	end
	self:updateBtnUnlock()
end
function ManorUIBottom:getUnlockBuildId(funcKey)
	local valueArray = CONST_ARRAY[funcKey]
	if #valueArray <= 0 then
		return
	end
	local unlockBid = valueArray[1]
	return unlockBid
end
function ManorUIBottom:onMsgMapInit(target, event)
	if not event.player then
		local _ENV, player = event.player, event.player
	end
	if player.uid == SoraDGetPlayerID() then
		self:initAllianceHelpBtn()
		self:updateBtnUnlock()
		self:updateDressBookRedPoint()
		self:updateSeedBookRedPoint()
	end
end
function ManorUIBottom:updateBtnBuildNew()
	local isNew = manorCityUtil.getBuildListIsNew()
	self.Image_new:setVisible(isNew)
end
function ManorUIBottom:onMsgBuildNew(target, event)
	self:updateBtnBuildNew()
	self:updateBtnUnlock()
end
return ManorUIBottom
