local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_palaceItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_palaceItem", Com_palaceItem)
function Com_palaceItem:onInit()
	_ENV, _ENV = nil, nil
	;(nil).type = gHeroType.INFANTRY
	_ENV, (nil)[1], (nil).name = nil, nil, "步兵"
	;(nil).type = gHeroType.CAVALRY
	_ENV, (nil)[2], (nil).name = nil, nil, "骑兵"
	;(nil).type = gHeroType.ARCHER
	self.heroTypeCfg, (nil)[3], (nil).name = nil, nil, "弓兵"
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder(1)
end
function Com_palaceItem:onShow()
end
function Com_palaceItem:initData(index, editData)
	self.fields.bg:setVisible(index % 2 == 0)
	local cfg = self.heroTypeCfg[index]
	local addCfg = heroltCtrl:getHeroPalaceAdditionCfg(cfg.type)
	self.fields.title:setString("圣殿加成--" .. cfg.name)
	self.fields.Text_lv:setString("加成等级1~" .. #addCfg)
end
return Com_palaceItem
