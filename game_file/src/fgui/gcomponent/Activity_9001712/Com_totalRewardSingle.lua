local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_totalRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001712/Com_totalRewardSingle", Com_totalRewardSingle)
function Com_totalRewardSingle:onInit()
end
function Com_totalRewardSingle:onShow()
end
function Com_totalRewardSingle:initData(index, data)
	local itemId = data.stageReward[1]
	self.fields.Text_name:setString(publicRead.getName(itemId))
	publicRead = publicRead.getName(itemId)
	publicRead.getName(itemId).num = data.stageReward[2]
	self.fields.Text_num:setString(i18n("Eidal_celebration_text_29", publicRead.getName(itemId)))
	publicRead = i18n("Eidal_celebration_text_29", publicRead.getName(itemId))
	i18n("Eidal_celebration_text_29", publicRead.getName(itemId)).num = data.day
	self.fields.Text_totalNum:setString(i18n("anniversary_ten_daily_08", i18n("Eidal_celebration_text_29", publicRead.getName(itemId))))
	self.fields.item:initData(itemId)
	self.controllers.ctrlLight:setSelectedIndex(index % 2 == 1 and 0 or 1)
end
return Com_totalRewardSingle
