local magicFlipRead = include("magicFlipRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_list3 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampActivity/Com_list3", Com_list3)
function Com_list3:onInit()
	self:fixChildrenPos()
	self.fields.List_Award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.List_Card:setItemRenderer(handler(self, self.onCardItemRederer))
end
_ENV, Com_list3.onShow = function(self)
end, function(self)
end
;(function(self)
end)[1] = "starlight_name_04"
;(function(self)
end)[2] = "starlight_name_03"
local (function(self)
end)[3], config = "starlight_name_02", function(self)
end
function Com_list3:initData(data)
	self.fields.Text_Time:setString(SoraDConverTimeStr(data.time))
	self.fields.title:setString(i18n(config[data.retType]))
	self.cardList = data.cards
	self.isDouble = data.double
	magicFlipRead = data.retType
	data.retType[1] = "id"
	data.retType[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(magicFlipRead.getRewadByType(data.retType), data.retType)
	self.fields.List_Award:setNumItems(#self.rewardList)
	self.fields.List_Card:setNumItems(#self.cardList)
end
function Com_list3:onAwardItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count * (self.isDouble and 2 or 1))
end
function Com_list3:onCardItemRederer(index, target)
	target:initData(self.cardList[index + 1])
end
return Com_list3
