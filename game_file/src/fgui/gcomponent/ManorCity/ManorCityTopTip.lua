local manorFarmRead = include("manorFarmRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityRead = include("manorCityRead")
local manorCityUtil = include("manorCityUtil")
local baseComponent = require("fgui.base.baseComponent")
local ManorCityTopTip = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://ManorCity/ManorCityTopTip", ManorCityTopTip)
function ManorCityTopTip:onInit()
	self:addClickListener(handler(self, self.onClickSelf))
end
function ManorCityTopTip:onShow()
end
function ManorCityTopTip:onHide()
	self:clearFarmTimer()
end
function ManorCityTopTip:clearFarmTimer()
	if self.farmTimer then
		SoraDManagerRemoveTimer(self, self.farmTimer)
		self.farmTimer = nil
	end
end
function ManorCityTopTip:resetTimeProgress()
	self.controllers.ctrlTime:setSelectedIndex(0)
	self:setMax(1)
	self:setValue(0)
end
function ManorCityTopTip:startFarmTimer()
	if not self.farmTimer then
		self.farmTimer = SoradCreateTimer(self, handler(self, self.onFarmTimer))
	end
end
function ManorCityTopTip:onFarmTimer()
	self:updateFarmProgress()
end
function ManorCityTopTip:updateFarmProgress()
	if not self.data then
		_ENV = self.data
	end
	if not self.data.extra then
		_ENV = self.data.extra
	end
	if not self.data.extra.plant then
		local _ENV, plant = self.data.extra.plant, self.data.extra.plant
	end
	local seedTime = plant.seedTime
	local fruitTime = plant.fruitTime
	local nowTime = serviceFunctions.systemTime()
	if not (not serviceFunctions.isNilOrZero(plant.seedId) and seedTime) or not fruitTime then
		self:clearFarmTimer()
		self:resetTimeProgress()
		return
	end
	if fruitTime <= nowTime then
		self:clearFarmTimer()
		self:resetTimeProgress()
		if self.instance then
			self.instance:updateFarm()
		end
		return
	end
	local progressMin = seedTime
	local progressMax = fruitTime
	local totalTime = math.max(1, progressMax - progressMin)
	local passTime = math.max(0, math.min(totalTime, nowTime - progressMin))
	self.controllers.ctrlTime:setSelectedIndex(1)
	self:setMax(totalTime)
	self:setValue(passTime)
	self.fields.txtCountDown:setString(SoraDConvertSecondToString(fruitTime - nowTime))
	if self.instance then
		self.instance:updateFarm()
	end
	self:startFarmTimer()
end
function ManorCityTopTip:onClickSelf(context)
	if self.tipType == MANOR_TOPTIP_TYPE.FARM then
		if not self.data then
			_ENV = self.data
		end
		if not self.data.extra then
			_ENV = self.data.extra
		end
		if not self.data.extra.plant then
			local _ENV, plant = self.data.extra.plant, self.data.extra.plant
		end
		if serviceFunctions.isNilOrZero(plant.seedId) then
			uiManager:show("FarmPlant")
			return
		elseif (plant.fruitTime or 0) > serviceFunctions.systemTime() then
			SoraDShowMsgTip(i18n("farmland_text_14"))
			return
		end
		manorCityCtrl:reqFarmlandPickFruit()
	elseif self.tipType == MANOR_TOPTIP_TYPE.HELP then
		self.instance:doReqHelp()
	elseif self.tipType == MANOR_TOPTIP_TYPE.FARM_HELP then
		manorCityCtrl:reqFarmlandAssist(self.player.uid, self.data)
	elseif self.tipType == MANOR_TOPTIP_TYPE.BANQUET then
		if manorCityUtil.checkAttendedBanquet(self.data) then
			return
		end
		if manorCityUtil.checkReachBanquetMax() then
			SoraDShowMsgTip(i18n("Socialize_text_39"))
			return
		end
		if not self.data.extra then
			_ENV = self.data.extra
		end
		local cfg = manorCityRead.getBanquetRewardConfig(self.data.extra.lv)
		if (self.data.extra.placeTime + cfg.time or 0) < serviceFunctions.systemTime() then
			SoraDShowMsgTip(i18n("Socialize_text_41"))
			return
		end
		manorCityCtrl:reqGardenMapAttendParty(self.player.uid)
	elseif self.tipType == MANOR_TOPTIP_TYPE.MERGE_SEED then
		if not manorCityCtrl:getFirstReadyMergeSeedData() then
			return
		end
		local manorCityViewProxy = uiManager:getProxy("ManorCityView")
		if manorCityViewProxy then
			SoraDShowLoading(manorCityViewProxy.view, nil, gCmd.REQ_GARDEN_FARMLAND_PICK_MERGE_SEED)
		else
			SoraDShowLoading()
		end
		manorCityCtrl:reqFarmlandPickMergeSeed()
	end
end
function ManorCityTopTip:initData(data, tipType, player)
