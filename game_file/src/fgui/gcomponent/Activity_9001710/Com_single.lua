local activity_9001710_Ctrl = SoraDGetCtrl("activity_9001710_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001710/Com_single", Com_single)
function Com_single:onInit()
	self.fields.List_normal:setItemRenderer(handler(self, self.onNormalItemRender))
	self.fields.List_adv:setItemRenderer(handler(self, self.onAdvItemRender))
	self:fixChildrenPos()
end
function Com_single:onNormalItemRender(index, obj)
	local data = self.cfg.bronzeAward[index + 1]
	obj:initData(data.id, data.count)
	obj:setStatus(activity_9001710_Ctrl:getLvStatus(self.cfg.lv))
end
function Com_single:onAdvItemRender(index, obj)
	local data = self.cfg.goldAward1[index + 1]
	obj:initData(data.id, data.count)
	obj:setStatus(activity_9001710_Ctrl:getLvStatus(self.cfg.lv, true))
end
function Com_single:onShow()
end
function Com_single:initData(cfg)
	self.cfg = cfg
	self.fields.Text_lv:setString(self.cfg.lv)
	self.fields.List_normal:setNumItems(#self.cfg.bronzeAward)
	self.fields.List_adv:setNumItems(#self.cfg.goldAward1)
end
return Com_single
