local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_equipInfoPop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001722/Com_equipInfoPop", Com_equipInfoPop)
function Com_equipInfoPop:onInit()
	self.attrList, _ENV, self.height = nil, nil, 80
	self.fields.list_attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.title:fixPos()
end
function Com_equipInfoPop:onShow()
end
function Com_equipInfoPop:onAttrRenderer(index, obj)
	obj:setTitle(self.attrList[index + 1].title)
	obj:getChild("title"):setColor(self.attrList[index + 1].color)
end
function Com_equipInfoPop:initData(data)
