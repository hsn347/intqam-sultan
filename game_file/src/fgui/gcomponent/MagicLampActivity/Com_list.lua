local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampActivity/Com_list", Com_list)
function Com_list:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
_ENV, _ENV, Com_list.onShow = "ui://MagicLampActivity/Com_list", function(self)
end, function(self)
end
;("ui://MagicLampActivity/Com_list").title = "starlight_name_04"
_ENV, (function(self)
end)[1], ("ui://MagicLampActivity/Com_list").des = "ui://MagicLampActivity/Com_list", "ui://MagicLampActivity/Com_list", "magic_flip_7"
;("ui://MagicLampActivity/Com_list").title = "starlight_name_03"
_ENV, (function(self)
end)[2], ("ui://MagicLampActivity/Com_list").des = "ui://MagicLampActivity/Com_list", "ui://MagicLampActivity/Com_list", "magic_flip_6"
;("ui://MagicLampActivity/Com_list").title = "starlight_name_02"
;(function(self)
end)[3], ("ui://MagicLampActivity/Com_list").des = "ui://MagicLampActivity/Com_list", "magic_flip_6"
local function config(self)
end
function Com_list:initData(data)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(data.reward, nil)
	self.fields.List:setNumItems(#self.rewardList)
	self.fields.title:setString(i18n(config[data.type].title))
	_ENV = i18n(config[data.type].title)
	i18n(config[data.type].title).num = tonumber(data.type)
	self.fields.Text_Describe:setString(i18n(config[data.type].des, i18n(config[data.type].title)))
end
function Com_list:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
return Com_list
