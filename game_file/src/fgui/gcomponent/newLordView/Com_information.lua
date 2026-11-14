local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local achiDesRead = include("achiDesRead")
local lordLocalData = include("lordLocalData")
local achievementctrl = SoraDGetCtrl("achievementctrl")
local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_information = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_information", Com_information)
function Com_information:onInit()
	self.defInfoArray, _ENV, self.developArray, _ENV, self.resourceArray, _ENV, self.militaryArray, _ENV, self.powerArray, _ENV, self.stateArray, _ENV, self.officialTitleArray, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.fields.title_official:setString(i18n("lord_title_01"))
	self.fields.title_medal:setString(i18n("common_text_1752"))
	self.fields.title_state:setString(i18n("common_text_343"))
	self.fields.title_power:setString(i18n("common_text_090"))
	self.fields.title_military:setString(i18n("common_text_045"))
	self.fields.title_resource:setString(i18n("common_text_123"))
	self.fields.title_develop:setString(i18n("common_text_331"))
	self.fields.title_defInfo:setString(i18n("common_text_332"))
	self.fields.list_official:setItemRenderer(handler(self, self.onOfficialRenderer))
	self.fields.achi:addClickListener(handler(self, self.btnAchiClick))
end
function Com_information:onShow()
end
function Com_information:onOfficialRenderer(index, obj)
	obj:initData(self.officialTitleArray[index + 1], self.tablePlayerInfo)
end
function Com_information:initData(data)
	self.tablePlayerInfo = data
	self.isOwnData = self.tablePlayerInfo.base.uid == lordInfoCtrl:getLordInfo().base.uid
	self.officialTitleArray = lordInfoCtrl:getShowOfficialTypeArrayForLord(self.tablePlayerInfo)
	if #self.officialTitleArray > 0 then
		self.fields.title_official:setVisible(true)
		self.fields.list_official:setVisible(true)
		self.fields.list_official:setNumItems(#self.officialTitleArray)
	else
		self.fields.title_official:setVisible(false)
		self.fields.list_official:setVisible(false)
	end
	self.showAchieve = self.tablePlayerInfo.achieveInfo and self.tablePlayerInfo.achieveInfo.showAchieveID ~= 0 and (self.isOwnData or self.tablePlayerInfo.achieveInfo.isShow)
	if self.showAchieve then
		self.fields.title_medal:setVisible(true)
		self.fields.achi:setVisible(true)
		local spriteAchi = achiDesRead.getShowMedalPic(self.tablePlayerInfo.achieveInfo.showAchieveID, self.tablePlayerInfo.achieveInfo.showMetalID)
		spriteAchi:setScale(1.2)
		spriteAchi:setPosition(100, 100)
		self.fields.achi:clearContent()
		self.fields.achi:setContent(spriteAchi)
		if #self.officialTitleArray > 0 then
			self.fields.title_medal:setPositionY(225)
			self.fields.achi:setPositionY(355)
			self.fields.title_state:setPositionY(480)
			self.fields.list_state:setPositionY(505)
		else
			self.fields.title_medal:setPositionY(25)
			self.fields.achi:setPositionY(155)
			self.fields.title_state:setPositionY(280)
			self.fields.list_state:setPositionY(305)
		end
	else
		self.fields.title_medal:setVisible(false)
		self.fields.achi:setVisible(false)
		if #self.officialTitleArray > 0 then
			self.fields.title_state:setPositionY(225)
			self.fields.list_state:setPositionY(250)
		else
			self.fields.title_state:setPositionY(25)
			self.fields.list_state:setPositionY(50)
		end
	end
	self.stateArray = lordLocalData.getLordPowerTableByKey("state")
	self.fields.list_state:initData(self.stateArray, self.tablePlayerInfo.fcInfo)
	self.fields.title_power:setVisible(self.isOwnData)
	self.fields.list_power:setVisible(self.isOwnData)
	self.fields.title_military:setVisible(self.isOwnData)
	self.fields.list_military:setVisible(self.isOwnData)
	self.fields.title_resource:setVisible(self.isOwnData)
	self.fields.list_resource:setVisible(self.isOwnData)
	self.fields.title_develop:setVisible(self.isOwnData)
	self.fields.list_develop:setVisible(self.isOwnData)
	self.fields.title_defInfo:setVisible(self.isOwnData)
	self.fields.list_defInfo:setVisible(self.isOwnData)
	if self.isOwnData then
		self.powerArray = clone(lordLocalData.getLordPowerTableByKey("power"))
		if not SoraDGetCtrl("divineBeastCtrl"):getIsUnlock() then
			table.remove(self.powerArray, 16)
		end
		if not SoraDGetCtrl("magicLampCtrl"):getIsUnlock() then
			table.remove(self.powerArray, 15)
		end
		print("not SoraDIsBraveOpen()", not SoraDIsBraveOpen())
		if not SoraDIsBraveOpen() then
			table.remove(self.powerArray, 14)
		end
		if not commonCheck.ARTIFACT then
			table.remove(self.powerArray, 13)
		end
		if not SoraDCheckIsOpenBuildStar() then
			table.remove(self.powerArray, 5)
		end
		if not IsArClient then
			lordInfoCtrl = 5
			;(5).key = "masteryFc"
			;(5).name = "specialization_text_15"
			;(5).nameType = 1
			;(5).valueType = 3
			table.insert(self.powerArray, 5)
		end
		if SoraDGetCtrl("manorCityCtrl"):getIsUnLock() then
			lordInfoCtrl = 5
			;(5).key = "gardenFc"
			;(5).name = "garden_text_43"
			;(5).nameType = 1
			;(5).valueType = 3
			table.insert(self.powerArray, 5)
		end
		self.fields.list_power:initData(self.powerArray, self.tablePlayerInfo.fcInfo)
		self.fields.title_power:setPositionY(self.fields.list_state:getPositionY() + self.fields.list_state:getRealHeight() + 30)
		self.fields.list_power:setPositionY(self.fields.title_power:getPositionY() + 25)
		self.militaryArray = lordLocalData.getLordPowerTableByKey("military")
		local militaryInfo = lordInfoCtrl:getLordMilitaryInfo(true)
		local uSkillList = heroCtrl:getHeroUSkillActive()
		for k, v in pairs(uSkillList) do
			local key = lordInfoCtrl:getLordMilitaryBuffKey(k)
			if key then
				militaryInfo[key] = (militaryInfo[key] or 0) + v / 10000
			end
		end
		self.fields.list_military:initData(self.militaryArray, militaryInfo)
		self.fields.title_military:setPositionY(self.fields.list_power:getPositionY() + self.fields.list_power:getRealHeight() + 30)
		self.fields.list_military:setPositionY(self.fields.title_military:getPositionY() + 25)
		self.resourceArray = lordLocalData.getLordPowerTableByKey("resource")
		self.fields.list_resource:initData(self.resourceArray, lordInfoCtrl:getLordResourceInfo())
		self.fields.title_resource:setPositionY(self.fields.list_military:getPositionY() + self.fields.list_military:getRealHeight() + 30)
		self.fields.list_resource:setPositionY(self.fields.title_resource:getPositionY() + 25)
		self.developArray = lordLocalData.getLordPowerTableByKey("develop")
		self.fields.list_develop:initData(self.developArray, lordInfoCtrl:getLordCityDevelopInfo(true))
		self.fields.title_develop:setPositionY(self.fields.list_resource:getPositionY() + self.fields.list_resource:getRealHeight() + 30)
		self.fields.list_develop:setPositionY(self.fields.title_develop:getPositionY() + 25)
		self.defInfoArray = lordLocalData.getLordPowerTableByKey("defInfo")
		self.fields.list_defInfo:initData(self.defInfoArray, lordInfoCtrl:getLordCityDefInfo())
		self.fields.title_defInfo:setPositionY(self.fields.list_develop:getPositionY() + self.fields.list_develop:getRealHeight() + 30)
		self.fields.list_defInfo:setPositionY(self.fields.title_defInfo:getPositionY() + 25)
	end
end
function Com_information:btnAchiClick()
	SoraDPlaySound()
	if self.isOwnData then
		_ENV = nil
		;(nil).isToAchi = false
		;(nil).isReqForList = true
		uiManager:show("honourWallView", nil)
	else
		achievementctrl:sendOtherLordMetalInfo(gametop.playertop_:getKingdomID(), self.tablePlayerInfo.base.uid)
	end
end
return Com_information
