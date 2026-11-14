local newLotteryRead = include("newLotteryRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_PreAward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DesertMining/Com_PreAward", Com_PreAward)
function Com_PreAward:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_PreAward:initData(data)
	self.fields.Label:setString(i18n(string.format("Desertmining_%02d", data.prize + 6)))
	self.config = data.reward
	self.fields.List:setNumItems(#self.config)
end
function Com_PreAward:onShow()
	print("=======Com_PreAward:onShow")
end
function Com_PreAward:onItemRederer(index, target)
	target:initData(self.config[index + 1].id, self.config[index + 1].count)
end
return Com_PreAward
