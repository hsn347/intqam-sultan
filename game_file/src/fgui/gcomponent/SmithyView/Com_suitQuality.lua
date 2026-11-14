local baseComponent = require("fgui.base.baseComponent")
local Com_suitQuality = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_suitQuality", Com_suitQuality)
function Com_suitQuality:onInit()
	self.qualityData, _ENV = nil, nil
	self.fields.List_quality:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_suitQuality:onShow()
end
function Com_suitQuality:onItemRenderer(index, obj)
	obj:initData(self.qualityData[index + 1], index + 1, self.selectIndex)
end
function Com_suitQuality:initData(data, selectIndex, maxQuality)
	print("maxQuality====", maxQuality)
	self.data = data
	self.selectIndex = selectIndex
	self.controllers.c1:setSelectedIndex(maxQuality - 3)
	for i = 1, maxQuality + 1 do
		_ENV = nil
		;(nil).quality = i - 1
		self.qualityData[i], (nil).equipmentID = nil, self.data.equipmentID
	end
	self.fields.List_quality:setNumItems(#self.qualityData)
	for i = 1, 4 do
		self.fields["arrow" .. i]:fixPos()
		self.fields["arrow" .. i]:setRotation(SoraDFIsRA() and 90 or -90)
	end
end
return Com_suitQuality
