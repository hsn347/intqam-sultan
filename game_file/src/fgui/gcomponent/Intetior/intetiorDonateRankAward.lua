local baseComponent = require("fgui.base.baseComponent")
local intetiorDonateRankAward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorDonateRankAward", intetiorDonateRankAward)
function intetiorDonateRankAward:onInit()
	self.fields.Text_des:setString(i18n("parliament_text_17"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function intetiorDonateRankAward:onShow()
	self:init()
end
function intetiorDonateRankAward:init()
	local intetiorRead = include("intetiorRead")
	self.rankData = intetiorRead:getRankRewardConfig()
	self.fields.List:setNumItems(#self.rankData)
end
function intetiorDonateRankAward:onItemRederer(index, target)
	_UPVALUE0_ = index + 1
	;(index + 1).showKey = true
	target:initData(self.rankData[index + 1], index + 1)
end
return intetiorDonateRankAward
