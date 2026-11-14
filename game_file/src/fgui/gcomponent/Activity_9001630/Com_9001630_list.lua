local baseComponent = require("fgui.base.baseComponent")
local Com_9001630_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001630/Com_9001630_list", Com_9001630_list)
_ENV, _ENV = "ui://Activity_9001630/Com_9001630_list", fgui.register_extension
;("ui://Activity_9001630/Com_9001630_list").title = "starlight_name_01"
_ENV, fgui.register_extension[0], ("ui://Activity_9001630/Com_9001630_list").des = "ui://Activity_9001630/Com_9001630_list", "ui://Activity_9001630/Com_9001630_list", "magic_flip_7"
;("ui://Activity_9001630/Com_9001630_list").title = "starlight_name_02"
_ENV, fgui.register_extension[1], ("ui://Activity_9001630/Com_9001630_list").des = "ui://Activity_9001630/Com_9001630_list", "ui://Activity_9001630/Com_9001630_list", "magic_flip_7"
;("ui://Activity_9001630/Com_9001630_list").title = "starlight_name_03"
_ENV, fgui.register_extension[2], ("ui://Activity_9001630/Com_9001630_list").des = "ui://Activity_9001630/Com_9001630_list", "ui://Activity_9001630/Com_9001630_list", "magic_flip_6"
;("ui://Activity_9001630/Com_9001630_list").title = "starlight_name_04"
_ENV, fgui.register_extension[3], ("ui://Activity_9001630/Com_9001630_list").des = "ui://Activity_9001630/Com_9001630_list", "ui://Activity_9001630/Com_9001630_list", "magic_flip_6"
;("ui://Activity_9001630/Com_9001630_list").title = "nebula_paradise_text_06"
fgui.register_extension[4], ("ui://Activity_9001630/Com_9001630_list").des = "ui://Activity_9001630/Com_9001630_list", "magic_flip_6"
local config = fgui.register_extension
function Com_9001630_list:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_9001630_list:onShow()
end
function Com_9001630_list:initData(data)
	self.rewardList = data.reward
	self.fields.List:setNumItems(#self.rewardList)
	self.fields.title:setString(i18n(config[data.rewardType].title))
end
function Com_9001630_list:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
return Com_9001630_list
