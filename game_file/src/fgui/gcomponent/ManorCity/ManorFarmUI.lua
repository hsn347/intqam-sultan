local manorFarmRead = include("manorFarmRead")
local baseComponent = require("fgui.base.baseComponent")
local ManorFarmUI = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://ManorCity/ManorFarmUI", ManorFarmUI)
function ManorFarmUI:onInit()
	self.fields.pb:setBarColor(2)
	self.fields.pb:setVisible(false)
	self.fields.pb:setValue(0)
	self.fields.ani_watering:setVisible(false)
end
function ManorFarmUI:onShow()
end
function ManorFarmUI:onHide()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function ManorFarmUI:initData(mapObjData, instance, isInVisit)
	self.data = mapObjData
	self.instance = instance
	self.isInVisit = isInVisit
	local url = manorFarmRead.getSeedTypeBuildAttachIcon(self.data.extra.type)
	self:setIcon(url)
	self.fields.pb:setVisible(false)
	self.fields.pb:setValue(0)
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	if not self.data.extra then
		manorFarmRead = self.data.extra
	end
	if not self.data.extra.plant then
		local manorFarmRead, plant = self.data.extra.plant, self.data.extra.plant
	end
	if self.isInVisit and not serviceFunctions.isNilOrZero(plant.seedId) then
		self.timer = SoradCreateTimer(self, handler(self, self.onTimer))
	end
	if self.data.iid then
		self.instance:updateFarm()
	end
end
function ManorFarmUI:onTimer()
	if not self.data.extra then
		_ENV = self.data.extra
	end
	if not self.data.extra.plant then
		local _ENV, plantData = self.data.extra.plant, self.data.extra.plant
	end
	if not serviceFunctions.isNilOrZero(plantData.seedId) then
		self.instance:checkShowTopTip()
		self.instance:updateFarm()
		if serviceFunctions.systemTime() >= (plantData.fruitTime or 0) then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
	elseif self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function ManorFarmUI:showWateringAni()
	self.fields.ani_watering:setVisible(true)
	self.fields.ani_watering:setAllFrameName("manor_watering_01_%.2d.png", 1)
	local seq = ffa.seq(ffa.delay(1), ffa.callFunc(function()
		self.fields.ani_watering:setVisible(false)
	end))
	self:runAction(seq)
end
return ManorFarmUI
