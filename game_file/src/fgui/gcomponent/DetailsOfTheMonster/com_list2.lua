local baseComponent = require("fgui.base.baseComponent")
local com_list2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DetailsOfTheMonster/com_list2", com_list2)
function com_list2:onInit()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function com_list2:onShow()
end
function com_list2:initData(monsterCfgs, title)
	dump(monsterCfgs, "monsterCfgs")
	self.monsterCfgs = monsterCfgs
	self.fields.title:setString(title)
	self.fields.scroll:setNumItems(#self.monsterCfgs)
end
function com_list2:onItemRenderer(index, obj)
	local monsterCfg = self.monsterCfgs[index + 1]
	fguiHelper.get_fields(obj).title:setString(monsterCfg.num)
	fguiHelper.get_fields(obj).icon:setURL(monsterCfg.cfg.picture)
end
return com_list2
