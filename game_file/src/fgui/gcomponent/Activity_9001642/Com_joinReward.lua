local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_joinReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001642/Com_joinReward", Com_joinReward)
function Com_joinReward:onInit()
	self.itemList, _ENV = nil, nil
	self.fields.title:setString(i18n("Phonex_Challenge_text_13"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_joinReward:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function Com_joinReward:onShow()
	_ENV = nil
	_UPVALUE2_ = "PHOENIX_CHALLENGE_ACTIVE_REWARD"
	;("PHOENIX_CHALLENGE_ACTIVE_REWARD")[1] = "id"
	;("PHOENIX_CHALLENGE_ACTIVE_REWARD")[2] = "count"
	self.itemList = serviceFunctions.tableFormat(constantRead.getConstValueArray("PHOENIX_CHALLENGE_ACTIVE_REWARD", nil), "PHOENIX_CHALLENGE_ACTIVE_REWARD")
	self.fields.List:setNumItems(#self.itemList)
end
return Com_joinReward
