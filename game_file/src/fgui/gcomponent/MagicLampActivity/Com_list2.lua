local baseComponent = require("fgui.base.baseComponent")
local Com_list2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampActivity/Com_list2", Com_list2)
function Com_list2:onInit()
	self:fixChildrenPos()
	self.fields.List_Award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.List_Card:setItemRenderer(handler(self, self.onCardItemRederer))
end
function Com_list2:onShow()
end
function Com_list2:initData(index, data)
	self.fields.title:setString(index + 1)
	self.cardList = data.cards
	self.rewardList = data.reward
	self.isDouble = data.double
	self.fields.List_Award:setNumItems(#self.rewardList)
	self.fields.List_Card:setNumItems(#self.cardList)
end
function Com_list2:onAwardItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count, self.isDouble and 2 or 0)
end
function Com_list2:onCardItemRederer(index, target)
	target:initData(self.cardList[index + 1], self:getCardIsSame(index + 1))
end
function Com_list2:getCardIsSame(index)
	for i, v in ipairs(self.cardList) do
		if i ~= index and v == self.cardList[index] then
			return true
		end
	end
end
return Com_list2
