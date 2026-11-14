local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorFarmRead = include("manorFarmRead")
local manorCityUtil = include("manorCityUtil")
local baseComponent = require("fgui.base.baseComponent")
local ComPlant = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComPlant", ComPlant)
function ComPlant:onInit()
end
function ComPlant:onShow()
end
function ComPlant:initData(mapObjData, fakeSeedId)
	if not mapObjData.extra.plant then
		_ENV = mapObjData.extra.plant
	end
	local seedId = mapObjData.extra.plant.seedId
	self.data = mapObjData
	self.fakeSeedID = fakeSeedId
	_ENV = nil
	;(nil).lv = manorCityCtrl:getBuildLv(mapObjData.realId)
	self.fields.txtLv:setString(i18n("common_text_100", nil))
	self.fields.comType:initData(self.data.extra.type, manorFarmRead.getSeedTypeIcon(self.data.extra.type))
	if seedId then
		local canReceive = manorCityUtil.canReceiveFarmFruit(mapObjData.iid)
		local seedData = manorFarmRead.getSeedInfo(seedId)
		self.fields.plant:initData(seedData, mapObjData)
		if canReceive then
			self.fields.txtComplete:setString(i18n("palace_text_27"))
			self.controllers.ctrlStatus:setSelectedIndex(3)
		else
			self.controllers.ctrlStatus:setSelectedIndex(2)
			local plantData = self.data.extra.plant
			if self.labelTimer then
				self.labelTimer:endTime()
				self.labelTimer = nil
			end
			self.labelTimer = SoraDCreateTimerLabel(self, self.fields.txtCountDown)
			self.labelTimer:setTimeUpdateListener(handler(self, self.onTimer))
			self.labelTimer:beginTime(plantData.fruitTime - serviceFunctions.systemTime())
		end
	elseif fakeSeedId then
		local seedData = manorFarmRead.getSeedInfo(fakeSeedId)
		if seedData then
			self.fields.plant:initData(seedData, mapObjData, true)
			self.controllers.ctrlStatus:setSelectedIndex(1)
			local num, time = manorCityUtil.previewFarmProduceNumAndTime(mapObjData.iid, fakeSeedId)
			_ENV = handler(self, self.onTimer)
			handler(self, self.onTimer).num = num
			self.fields.txtNum:setString(i18n("farmland_text_18", handler(self, self.onTimer)))
			_ENV = i18n("farmland_text_18", handler(self, self.onTimer))
			i18n("farmland_text_18", handler(self, self.onTimer)).time = SoraDConvertSecondToString(time)
			self.fields.txtPreviewTime:setString(i18n("farmland_text_19", i18n("farmland_text_18", handler(self, self.onTimer))))
		else
			self.controllers.ctrlStatus:setSelectedIndex(0)
			self.fields.plant:clearData()
			return -1
		end
	else
		self.controllers.ctrlStatus:setSelectedIndex(0)
		self.fields.plant:clearData()
	end
end
function ComPlant:onTimer(time)
	local canReceive = manorCityUtil.canReceiveFarmFruit(self.data.iid)
	if canReceive then
		manorCityUtil = nil
		;(nil).msg = "MESSAGE_MANOR_CITY_FARMLAND_UPDATE"
		SoraDSendMessage(nil)
	end
end
return ComPlant
