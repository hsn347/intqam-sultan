local activity_9001688_Read = include("activity_9001688_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_award_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001689/Com_award_single", Com_award_single)
function Com_award_single:onInit()
	self.fields.best:setString(i18n("daily_salute_text36"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
	self.fields.nbg:fix()
end
function Com_award_single:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_award_single:onShow()
end
function Com_award_single:initData(data, bribeType)
	local bribeCfg = activity_9001688_Read.getBribeRewardCfg(bribeType, data.rank)
	self.reward = bribeCfg.reward
	self.fields.List:setNumItems(#self.reward)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	self.fields.name:setString(textParser.formatPlayerName(data.allianceAbb, data.nickName))
	self.controllers.c1:setSelectedIndex(data.uid == SoraDGetPlayerID() and 1 or 0)
	self.controllers.c2:setSelectedIndex(data.rank == 1 and 1 or 0)
end
return Com_award_single
