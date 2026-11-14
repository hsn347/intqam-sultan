local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewbulaAreaTechRewardPanel = class("NewbulaAreaTechRewardPanel", baseFguiPanel)
local loginRewardCtrl = SoraDGetCtrl("loginRewardCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
function NewbulaAreaTechRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NewbulaAreaTechRewardPanel:ctor", self.viewName)
end
function NewbulaAreaTechRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NewbulaAreaTechRewardPanel:onInit()
	print("=======NewbulaAreaTechRewardPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_get:addClickEventListener(handler(self, self.onGetClick))
	self.fields.btn_get:setTitle(i18n("Nebula_science_text_006"))
	self.fields.text_desc2:setString(i18n("Nebula_science_text_005"))
	self.fields.text_desc:setString(i18n("Nebula_science_text_003"))
end
function NewbulaAreaTechRewardPanel:updateView()
	local rewardType = loginRewardCtrl:getIsCanReceiveNebulaReward1() and 1 or loginRewardCtrl:getIsCanReceiveNebulaReward2() and 2 or 0
	local addV1 = technologyCtrl:getTechnologyPower(gTechnologyType.DAILY_RECEIVE_METEORITE_LV_ADD)
	local addV2 = technologyCtrl:getTechnologyPower(gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD)
	_UPVALUE3_ = gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD
	gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD[1] = rewardType
	gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD[2] = addV1
	gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD[3] = addV2
	dump(gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD, "NewbulaAreaTechRewardPanel:updateView")
	if rewardType == 0 then
		if 0 < addV1 + addV2 then
			self.controllers.c1:setSelectedIndex(1)
			rewardType = 0 < addV1 and 1 or 2
			local sec = serviceFunctions.getTomorrowZeroHourUTC() - serviceFunctions.systemTime()
			if not self.text_time then
				self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
				self.text_time:setTimeLast(function(strTime)
					_ENV = nil
					;(nil).time = strTime
					return i18n("Nebula_science_text_004", nil)
				end)
			end
			self.text_time:beginTime(sec)
			self.fields.btn_get:setTitle("")
			self.fields.btn_get:setEnabled(false)
			self.fields.text_title:setString(i18n("Nebula_science_text_001"))
		else
			self.controllers.c1:setSelectedIndex(2)
			self.fields.text_title:setString(i18n("Nebula_science_text_001"))
			return
		end
	else
		self.fields.btn_get:setEnabled(true)
		self.fields.btn_get:setTitle(i18n("Nebula_science_text_006"))
		self.fields.text_title:setString(i18n("Nebula_science_text_001"))
		self.controllers.c1:setSelectedIndex(0)
	end
	local technologyLocalData = include("technologyLocalData")
	self.rewards = technologyLocalData.getNebulaTechReward(1, addV1)
	self.rewards2 = technologyLocalData.getNebulaTechReward(2, addV2)
	for k, v in pairs(self.rewards2) do
		local isIn = false
		for k2, v2 in pairs(self.rewards) do
			if v.id == v2.id then
				v2.count = v2.count + v.count
				isIn = true
				break
			end
		end
		if not isIn then
			table.insert(self.rewards, v)
		end
	end
	self.fields.scroll:setNumItems(#self.rewards)
end
function NewbulaAreaTechRewardPanel:onShow()
	self:updateView()
	print("=======NewbulaAreaTechRewardPanel:onShow")
end
function NewbulaAreaTechRewardPanel:onItemRenderer(index, obj)
	local award = self.rewards[index + 1]
	obj:initData(award.id, award.count)
end
function NewbulaAreaTechRewardPanel:onGetClick()
	SoraDPlaySound()
	local loginRewardCtrl = SoraDGetCtrl("loginRewardCtrl")
	loginRewardCtrl:nebulaDailyReward(self.rewardType)
	SoraDMailGainItems(self.rewards, true)
	self:close()
end
return NewbulaAreaTechRewardPanel
