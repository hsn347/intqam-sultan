local manorCityUtil = include("manorCityUtil")
local manorFarmRead = include("manorFarmRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local ComResonanceItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComResonanceItem", ComResonanceItem)
function ComResonanceItem:onInit()
	self.fields.types:setItemRenderer(handler(self, self.itemRenderer_types))
	self.fields.txtDesc:fixPos()
end
function ComResonanceItem:onShow()
end
function ComResonanceItem:itemRenderer_types(index, obj)
	local type = self.types[index + 1]
	local icon = manorFarmRead.getSeedTypeIcon(type)
	obj:initData(type, icon)
end
function ComResonanceItem:initData(resonanceData)
	self.data = resonanceData
	local nextData = manorFarmRead.getResonance(resonanceData.lv + 1)
	self.types = manorCityUtil.getFarmTypesInNum(self.data.farmlandNum, nextData and nextData.farmlandNum)
	self.fields.types:setNumItems(#self.types)
	self.fields.txtDesc:setString(i18n(self.data.bonusDesc))
	self.fields.Text_score:setString(self.data.farmlandNum)
	self.controllers.ctrlState:setSelectedIndex(manorCityUtil.getResonanceUnlock(self.data.lv) and 1 or 0)
	self.controllers.ctrlBook:setSelectedIndex(0)
end
function ComResonanceItem:initHandbookBuff(handbookBuffData)
	self.data = handbookBuffData
	local bookNum = manorCityCtrl:getUnlockFruitBookNum()
	self.fields.types:setNumItems(0)
	self.fields.Text_score:setString(self.data.fruitNum)
	self.controllers.ctrlState:setSelectedIndex(bookNum >= self.data.fruitNum and 1 or 0)
	self.controllers.ctrlBook:setSelectedIndex(1)
	local str = ""
	for i = 1, #self.data.buff, 2 do
		if i ~= 1 then
			str = str .. "\n"
		end
		str = str .. buffDesRead.getTitleWithValue(self.data.buff[i], self.data.buff[i + 1])
	end
	self.fields.txtDesc2:setString(str)
end
return ComResonanceItem
