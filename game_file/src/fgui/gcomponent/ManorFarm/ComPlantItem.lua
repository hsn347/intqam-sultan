local manorFarmRead = include("manorFarmRead")
local manorCityUtil = include("manorCityUtil")
local baseComponent = require("fgui.base.baseComponent")
local ComPlantItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComPlantItem", ComPlantItem)
function ComPlantItem:onInit()
	self.fields.btnReduce:addClickListener(handler(self, self.onClick_btnReduce))
end
function ComPlantItem:onShow()
end
function ComPlantItem:onClick_btnReduce(context)
	SoraDPlaySound()
	uiManager:getProxy("FarmPlant"):removeFakePlant(nil, nil, self.data.iid)
	context:StopPropagation()
end
function ComPlantItem:initData(seedInfo, mapObjData, isFake)
	self.data = mapObjData
	self.fields.Image_quality:setURL(manorFarmRead.getSeedItemBg(seedInfo.seedID))
	self.fields.icon:setURL(manorFarmRead.getSeedItemIcon(seedInfo.seedID))
	self.controllers.ctrlEmpty:setSelectedIndex(0)
	self.controllers.ctrlFake:setSelectedIndex(isFake and 1 or 0)
	local status = manorCityUtil.getFarmStatus(mapObjData.iid)
	self.fields.mv:setVisible(status == 2)
	self.fields.mv:setAllFrameName("mv_border_00%.2d.png", 1)
end
function ComPlantItem:clearData()
	self.data = nil
	self.fields.Image_quality:setURL()
	self.fields.icon:setURL()
	self.controllers.ctrlEmpty:setSelectedIndex(1)
	self.fields.mv:setVisible(false)
end
return ComPlantItem
