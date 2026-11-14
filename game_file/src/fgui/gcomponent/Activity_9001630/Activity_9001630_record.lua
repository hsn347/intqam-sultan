local baseComponent = require("fgui.base.baseComponent")
local Activity_9001630_record = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001630_Read = include("activity_9001630_Read")
fgui.register_extension("ui://Activity_9001630/Activity_9001630_record", Activity_9001630_record)
_ENV, _ENV = "ui://Activity_9001630/Activity_9001630_record", fgui.register_extension
;("ui://Activity_9001630/Activity_9001630_record").title = "starlight_name_01"
_ENV, fgui.register_extension[0], ("ui://Activity_9001630/Activity_9001630_record").des = "ui://Activity_9001630/Activity_9001630_record", "ui://Activity_9001630/Activity_9001630_record", "magic_flip_7"
;("ui://Activity_9001630/Activity_9001630_record").title = "starlight_name_02"
_ENV, fgui.register_extension[1], ("ui://Activity_9001630/Activity_9001630_record").des = "ui://Activity_9001630/Activity_9001630_record", "ui://Activity_9001630/Activity_9001630_record", "magic_flip_7"
;("ui://Activity_9001630/Activity_9001630_record").title = "starlight_name_03"
_ENV, fgui.register_extension[2], ("ui://Activity_9001630/Activity_9001630_record").des = "ui://Activity_9001630/Activity_9001630_record", "ui://Activity_9001630/Activity_9001630_record", "magic_flip_6"
;("ui://Activity_9001630/Activity_9001630_record").title = "starlight_name_04"
_ENV, fgui.register_extension[3], ("ui://Activity_9001630/Activity_9001630_record").des = "ui://Activity_9001630/Activity_9001630_record", "ui://Activity_9001630/Activity_9001630_record", "magic_flip_6"
;("ui://Activity_9001630/Activity_9001630_record").title = "nebula_paradise_text_06"
fgui.register_extension[4], ("ui://Activity_9001630/Activity_9001630_record").des = "ui://Activity_9001630/Activity_9001630_record", "magic_flip_6"
local config = fgui.register_extension
function Activity_9001630_record:onInit()
	self:fixChildrenPos()
end
function Activity_9001630_record:onShow()
end
function Activity_9001630_record:initData(recordData)
	local cfg = activity_9001630_Read.getRewardCfg(recordData.id)
	self.rewardList = cfg.reward
	self.fields.single_base:initData(cfg)
	self.fields.title:setString(i18n(config[cfg.rewardType].title))
	self.fields.Text_Time:setString(SoraDConverTimeStr(recordData.time))
end
return Activity_9001630_record
