local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemSingle2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_itemSingle2", Com_itemSingle2)
fgui.register_extension("ui://Activity_9001624/Com_itemSingle", Com_itemSingle2)
fgui.register_extension("ui://Activity_9001666/Com_itemSingle", Com_itemSingle2)
fgui.register_extension("ui://Activity_9001705/Com_itemSingle", Com_itemSingle2)
fgui.register_extension("ui://Activity_9001680/Com_itemSingle", Com_itemSingle2)
fgui.register_extension("ui://Activity_9001691/Com_itemSingle", Com_itemSingle2)
fgui.register_extension("ui://CommonBoxSingle/Com_itemSingle", Com_itemSingle2)
function Com_itemSingle2:onInit()
	if self.fields.nbg then
		self.fields.nbg:setVisible(false)
	end
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_itemSingle2:onShow()
end
function Com_itemSingle2:initData(data, otherData)
