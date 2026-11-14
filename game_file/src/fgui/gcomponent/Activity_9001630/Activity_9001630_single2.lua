local baseComponent = require("fgui.base.baseComponent")
local Activity_9001630_single2 = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001630_Read = include("activity_9001630_Read")
fgui.register_extension("ui://Activity_9001630/Activity_9001630_single2", Activity_9001630_single2)
_ENV, _ENV = "ui://Activity_9001630/Activity_9001630_single2", fgui.register_extension
;("ui://Activity_9001630/Activity_9001630_single2").title = "starlight_name_01"
_ENV, fgui.register_extension[0], ("ui://Activity_9001630/Activity_9001630_single2").des = "ui://Activity_9001630/Activity_9001630_single2", "ui://Activity_9001630/Activity_9001630_single2", "magic_flip_7"
;("ui://Activity_9001630/Activity_9001630_single2").title = "starlight_name_02"
_ENV, fgui.register_extension[1], ("ui://Activity_9001630/Activity_9001630_single2").des = "ui://Activity_9001630/Activity_9001630_single2", "ui://Activity_9001630/Activity_9001630_single2", "magic_flip_7"
;("ui://Activity_9001630/Activity_9001630_single2").title = "starlight_name_03"
_ENV, fgui.register_extension[2], ("ui://Activity_9001630/Activity_9001630_single2").des = "ui://Activity_9001630/Activity_9001630_single2", "ui://Activity_9001630/Activity_9001630_single2", "magic_flip_6"
;("ui://Activity_9001630/Activity_9001630_single2").title = "starlight_name_04"
_ENV, fgui.register_extension[3], ("ui://Activity_9001630/Activity_9001630_single2").des = "ui://Activity_9001630/Activity_9001630_single2", "ui://Activity_9001630/Activity_9001630_single2", "magic_flip_6"
;("ui://Activity_9001630/Activity_9001630_single2").title = "nebula_paradise_text_06"
fgui.register_extension[4], ("ui://Activity_9001630/Activity_9001630_single2").des = "ui://Activity_9001630/Activity_9001630_single2", "magic_flip_6"
local config = fgui.register_extension
function Activity_9001630_single2:onInit()
	self:fixChildrenPos()
	self.fields.list_rewards:setItemRenderer(handler(self, self.onItemRederer))
end
function Activity_9001630_single2:onShow()
end
function Activity_9001630_single2:initData(rewardId)
	local cfg = activity_9001630_Read.getRewardCfg(rewardId)
	self.rewardList = cfg.reward
	self.fields.list_rewards:setNumItems(#self.rewardList)
	local cards = cfg.showType
	for i, v in ipairs(cards) do
		local iconCfg = activity_9001630_Read.getCardCfg(v)
		self.fields["icon_" .. i]:setURL(iconCfg.iocn)
	end
	dump(cfg.rewardType, "cfg.rewardType")
	if cfg.rewardType == 1 then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.effect1:setAllFrameNameOnce("dh__mck1_%02d.png", 0, true)
		self.fields.effect2:setAllFrameNameOnce("dh__mck2_%02d.png", 0, true)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.title:setString(i18n(config[cfg.rewardType].title))
end
function Activity_9001630_single2:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
return Activity_9001630_single2
