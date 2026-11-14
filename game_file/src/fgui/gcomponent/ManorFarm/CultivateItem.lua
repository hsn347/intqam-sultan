local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local manorFarmRead = include("manorFarmRead")
local manorCityRead = include("manorCityRead")
local baseComponent = require("fgui.base.baseComponent")
local CultivateItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/CultivateItem", CultivateItem)
function CultivateItem:onInit()
	self:addClickListener(handler(self, self.onClickSeedSlot))
	self.fields.btnChange:addClickListener(handler(self, self.onClick_btnChange))
	self.fields.prefabEx:setTouchable(false)
end
function CultivateItem:onShow()
end
function CultivateItem:onClick_btnChange(context)
	_ENV = nil
	;(nil).content = i18n("farmland_text_37")
	;(nil).cancel = true
	;(nil).confirmFunc = handler(self, function()
		_ENV = nil
		;(nil).queue = self.queue
		;(nil).isFruit = self.isFruit
		if not self.data then
			_ENV = self.data
		end
		;(nil).fruitId = self.data.fruitId
		uiManager:show("SeedCultivateSimChoose", nil)
	end)
	;(nil).remindString = i18n("coffeeCraftsman_text_27")
	;(nil).remindFunc = function(value)
	end
	uiManager:show("MessageBox", nil)
	context:stopPropagation()
end
function CultivateItem:initSeedData(queue)
	self.isSeed = true
	local status = manorCityUtil.getSeedCultivateStatus(queue)
	self.controllers.ctrlState:setSelectedIndex(status)
	self.data = manorCityCtrl:getSeedCultivateData(queue)
	self.queue = queue
	self.fields.prefabEx:setVisible(false)
	if status == 2 then
		self.fields.timer:initSpecialTime(self.data.outputTime - serviceFunctions.systemTime(), "%{time}")
		self.fields.timer:setTimeEndListener(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_SEED_TIME_END"
			SoraDSendMessage(nil)
			self.fields.prefabEx:setVisible(false)
		end)
		self.fields.prefabEx:setVisible(true)
		self.fields.prefabEx:setEffectPath("fx_farm_zzpy_paopao.prefab")
	elseif status == 3 then
		self.fields.item:initData(self.data.output)
	end
end
function CultivateItem:onClickSeedSlot()
	if self.isSeed then
		local status = manorCityUtil.getSeedCultivateStatus(self.queue)
		if status == 0 then
			local data = manorFarmRead.getSeedCultivateUnlock(self.queue)
			manorCityUtil = nil
			;(nil).build = manorCityRead.getBuildName(data.seedBuildLv[1])
			;(nil).lv = data.seedBuildLv[2]
			SoraDShowMsgTip(i18n("farmland_text_09", nil))
		elseif status == 1 then
			manorCityUtil = i18n("farmland_text_09", nil)
			i18n("farmland_text_09", nil).queue = self.queue
			uiManager:show("SeedCultivateChoose", i18n("farmland_text_09", nil))
		elseif status == 2 then
			manorCityUtil = i18n("farmland_text_09", nil)
			i18n("farmland_text_09", nil).queue = self.queue
			uiManager:show("SeedCultivateDetail", i18n("farmland_text_09", nil))
		elseif status == 3 then
			manorCityCtrl:reqFarmlandPickMergeSeed(self.queue)
			SoraDShowLoading(uiManager:getProxy("SeedCultivate").view)
		end
	elseif self.isFruit then
		local status = manorCityUtil.getFruitCultivateStatus(self.queue)
		if status == 0 then
			local data = manorFarmRead.getFruitCultivateUnlock(self.queue)
			manorCityUtil = self.queue
			self.queue.build = manorCityRead.getBuildName(data.fruitBuildLv[1])
			self.queue.lv = data.fruitBuildLv[2]
			SoraDShowMsgTip(i18n("farmland_text_09", self.queue))
		elseif status == 1 then
			manorCityUtil = i18n("farmland_text_09", self.queue)
			i18n("farmland_text_09", self.queue).queue = self.queue
			i18n("farmland_text_09", self.queue).isFruit = true
			uiManager:show("SeedCultivateSimChoose", i18n("farmland_text_09", self.queue))
		elseif status == 2 then
		elseif status == 3 then
			manorCityCtrl:reqFarmlandPickMergeSeed(self.queue)
			SoraDShowLoading(uiManager:getProxy("FruitCultivate").view)
		end
	end
end
function CultivateItem:initFruitData(queue)
	self.isFruit = true
	local status = manorCityUtil.getFruitCultivateStatus(queue)
	self.controllers.ctrlState:setSelectedIndex(status)
	self.data = manorCityCtrl:getFruitCultivateData(queue)
	self.queue = queue
	self.controllers.ctrlFruit:setSelectedIndex(0)
	if status == 2 then
		self.controllers.ctrlState:setSelectedIndex(4)
		self.controllers.ctrlFruit:setSelectedIndex(1)
		self.fields.item:initData(self.data.fruitId)
		if self.data then
			local config = manorFarmRead.getSeedInfoByFruitID(self.data.fruitId)
			local pastTime = serviceFunctions.systemTime() - self.data.t
			local leftTime
			if pastTime > config.cultitaveTime then
				leftTime = config.cultitaveTime - util.mod(pastTime, config.cultitaveTime)
			else
				leftTime = config.cultitaveTime - pastTime
			end
			self.fields.timer:initSpecialTime(leftTime, "%{time}")
			self.fields.timer:setTimeEndListener(function()
				self.fields.timer:initSpecialTime(config.cultitaveTime, "%{time}")
				self = self.fields.timer
				self.fields.timer.msg = "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT_TIME_END"
				self.fields.timer.data = self.data
				SoraDSendMessage(self.fields.timer)
			end)
		end
	end
end
return CultivateItem
