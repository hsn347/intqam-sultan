local baseComponent = require("fgui.base.baseComponent")
local Com_buffItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_buffItem", Com_buffItem)
function Com_buffItem:onInit()
	_ENV = nil
	;(nil)[1] = "步兵"
	;(nil)[2] = "弓兵"
	self.buffList, _ENV, self.titleCfg, (nil)[3] = nil, nil, nil, "骑兵"
	self.fields.List:setItemRenderer(handler(self, self.onBuffRender))
end
function Com_buffItem:onBuffRender(index, obj)
	local cfg = self.buffList[index + 1]
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("Text_id"):setString(cfg.buffid)
	obj:getChild("Text_buff"):setString(cfg.des)
	local val = cfg.inputNumTest
	if cfg.numType == 1 then
		val = tostring(cfg.inputNumTest / 10) .. "%"
	elseif cfg.numType == 3 then
		val = SoraDConvertSecondToString(cfg.inputNumTest)
	end
	obj:getChild("Text_value"):setString(val)
	obj:getChild("Text_value"):setVisible(not self.isEditModel)
	obj:getChild("input"):setText(cfg.inputNumTest)
	obj:getChild("input"):setVisible(self.isEditModel or false)
end
function Com_buffItem:onShow()
end
function Com_buffItem:initData(cfg, index, isEditModel)
	self.isEditModel = isEditModel
	self.fields.title:setString(self.titleCfg[index])
	self.buffList = cfg
	self.fields.List:setNumItems(#self.buffList)
	self.fields.List:setHeight(#self.buffList * 29)
end
return Com_buffItem
