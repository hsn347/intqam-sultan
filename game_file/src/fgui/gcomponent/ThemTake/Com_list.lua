local loudlyDressRead = include("loudlyDressRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ThemTake/Com_list", Com_list)
function Com_list:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_list:onItemRenderer(index, obj)
	local item = self.reward[index + 1]
	obj:initData(item.id, item.count)
end
function Com_list:onShow()
end
function Com_list:initData(index)
	_ENV = nil
	;(nil).num = index
	self.fields.title:setString(i18n("Loudlydressed_text_13", nil))
	self.reward = loudlyDressRead.getRewardByTimes(index)
	self.fields.List_reward:setNumItems(#self.reward)
end
return Com_list
