local baseComponent = require("fgui.base.baseComponent")
local Com_9001687_single = fgui.extension_class(fgui.GComponent, baseComponent)
local chatFunctions = include("chatFunctions")
fgui.register_extension("ui://Activity_9001687/Com_9001687_single", Com_9001687_single)
function Com_9001687_single:onInit()
	self:fixChildrenPos()
end
function Com_9001687_single:onShow()
end
function Com_9001687_single:initData(data)
	dump(data, "Com_9001687_single initData")
	local playerId = chatFunctions:getSelfId()
	self.controllers.c1:setSelectedIndex(playerId == data.uid and 1 or 0)
	self.fields.Com_item:initData(data.item.id, data.item.count)
	self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	local nameStr = textParser.formatPlayerName(data.allianceAbbr, data.nickName)
	self.fields.name:setString(nameStr)
	self.fields.time:setString(SoraDConverTimeStr(data.time))
end
return Com_9001687_single
