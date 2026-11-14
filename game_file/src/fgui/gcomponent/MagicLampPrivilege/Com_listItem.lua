local privilegeGiftRead = include("privilegeGiftRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_listItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampPrivilege/Com_listItem", Com_listItem)
function Com_listItem:onInit()
	self.itemList, _ENV = nil, nil
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_listItem:onShow()
end
function Com_listItem:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], index + 1)
end
function Com_listItem:initData(data)
	if type(data) == "number" then
		local giftInfo = privilegeGiftRead.getRechargeGiftByID(data)
		giftInfo = giftInfo or privilegeGiftRead.getStarRechargeGiftByID(data)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		self.itemList = serviceFunctions.tableFormat(giftInfo.rewards, nil)
	else
		self.itemList = data.totalReward
	end
	self.fields.List:setNumItems(#self.itemList)
end
return Com_listItem
