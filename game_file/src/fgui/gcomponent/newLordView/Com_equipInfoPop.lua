local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_equipInfoPop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_equipInfoPop", Com_equipInfoPop)
function Com_equipInfoPop:onInit()
	self.equipList, _ENV, self.suitList, _ENV, self.attrList, _ENV, self.height = nil, nil, nil, nil, nil, nil, 80
	self.fields.list_attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.list_suit:setItemRenderer(handler(self, self.onSuitRenderer))
	self.fields.list_equip:setItemRenderer(handler(self, self.onEquipRenderer))
	self.fields.Text_equipName:fixPos()
end
function Com_equipInfoPop:onShow()
end
function Com_equipInfoPop:onAttrRenderer(index, obj)
	obj:initData(self.attrList[index + 1])
end
function Com_equipInfoPop:onSuitRenderer(index, obj)
	obj:initData(self.suitList[index + 1])
end
function Com_equipInfoPop:onEquipRenderer(index, obj)
	obj:initData(self.equipList[index + 1], self.equipWearInfo)
end
function Com_equipInfoPop:initData(data, equipWearInfo)
