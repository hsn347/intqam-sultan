local baseComponent = require("fgui.base.baseComponent")
local Activity_9001630_single_base = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001630_Read = include("activity_9001630_Read")
fgui.register_extension("ui://Activity_9001630/Activity_9001630_single_base", Activity_9001630_single_base)
function Activity_9001630_single_base:onInit()
	self:fixChildrenPos()
	self.fields.list_rewards:setItemRenderer(handler(self, self.onItemRederer))
end
function Activity_9001630_single_base:onShow()
end
function Activity_9001630_single_base:initData(cfg)
	self.rewardList = cfg.reward
	local cards = cfg.showType
	for i, v in ipairs(cards) do
		local iconCfg = activity_9001630_Read.getCardCfg(v)
		self.fields["icon_" .. i]:setURL(iconCfg.iocn)
	end
	self.fields.list_rewards:setNumItems(#self.rewardList)
	if IsArClient and #self.rewardList > 0 then
		self.fields.list_rewards:scrollToView(0)
	end
end
function Activity_9001630_single_base:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
return Activity_9001630_single_base
