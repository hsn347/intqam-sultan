local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorFarmRead = include("manorFarmRead")
local baseComponent = require("fgui.base.baseComponent")
local ComFarmBookItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComFarmBookItem", ComFarmBookItem)
function ComFarmBookItem:onInit()
	self.fields.txtUnlock:setString(i18n("jinn_skill_62"))
end
function ComFarmBookItem:onShow()
end
function ComFarmBookItem:initData(fruit, seed)
	if fruit.frame then
		self.controllers.ctrlType:setSelectedIndex(0)
		self.fields.qualityTitle:initData(fruit)
		return
	end
	self.controllers.ctrlType:setSelectedIndex(1)
	local received = manorCityCtrl:getReceivedFarmBookItem(fruit.fruitID)
	self.controllers.ctrlLock:setSelectedIndex(received and 1 or 0)
	self.fields.loaderType:setURL(manorFarmRead.getSeedTypeIcon(seed.seedType))
	self.fields.icon:setURL(fruit.image)
	self.fields.iconQuality:setURL(manorFarmRead.getQualityItemBg(seed.seedQuality))
	self.fields.title:setString(i18n(fruit.name))
	self.fields.txtQuality:setString(manorFarmRead.getQualityName(seed.seedQuality))
end
return ComFarmBookItem
