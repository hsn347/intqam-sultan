local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeNumSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_decreeNumSingle", Com_decreeNumSingle)
function Com_decreeNumSingle:onInit()
	self.unlock_reward, _ENV, self.reward, _ENV = nil, nil, nil, nil
	self.fields.List_normal:setItemRenderer(handler(self, self.onItem1Renderer))
	self.fields.List_adv:setItemRenderer(handler(self, self.onItem2Renderer))
	self.fields.Text_num:fixPos()
	self.fields.List_normal:fixPos()
	self.fields.List_adv:fixPos()
end
function Com_decreeNumSingle:onShow()
end
function Com_decreeNumSingle:onItem1Renderer(index, obj)
	obj:initNumData(self.reward[index + 1], self.index, self.num)
end
function Com_decreeNumSingle:onItem2Renderer(index, obj)
	obj:initNumData(self.unlock_reward[index + 1], self.index, self.num, true)
end
function Com_decreeNumSingle:initData(cfg, index)
	self.index = index
	self.num = cfg.lv
	self.fields.Text_num:setString(cfg.lv)
	_UPVALUE2_ = cfg.lv
	cfg.lv[1] = "id"
	cfg.lv[2] = "count"
	self.reward = serviceFunctions.tableFormat(cfg.reward, cfg.lv)
	_UPVALUE2_ = cfg.lv
	cfg.lv[1] = "id"
	cfg.lv[2] = "count"
	self.unlock_reward = serviceFunctions.tableFormat(cfg.unlock_reward, cfg.lv)
	self.fields.List_normal:setNumItems(#self.reward)
	self.fields.List_adv:setNumItems(#self.unlock_reward)
end
return Com_decreeNumSingle
