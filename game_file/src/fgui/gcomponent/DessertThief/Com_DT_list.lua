local baseComponent = require("fgui.base.baseComponent")
local Com_DT_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DessertThief/Com_DT_list", Com_DT_list)
function Com_DT_list:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_DT_list:onShow()
end
function Com_DT_list:initData(cfg)
	_ENV = nil
	_ENV = nil
	;(nil).level = cfg.Lv
	;(nil).lv = i18n("common_text_1229", nil)
	self.fields.title:setString(i18n("Dessert_Thief_02", nil))
	_UPVALUE2_ = i18n("Dessert_Thief_02", nil)
	i18n("Dessert_Thief_02", nil)[1] = "id"
	i18n("Dessert_Thief_02", nil)[2] = "num"
	self.rewards = serviceFunctions.tableFormat(cfg.rewards, i18n("Dessert_Thief_02", nil))
	self.fields.List_reward:setNumItems(#self.rewards)
end
function Com_DT_list:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1].id, self.rewards[index + 1].num)
end
return Com_DT_list
