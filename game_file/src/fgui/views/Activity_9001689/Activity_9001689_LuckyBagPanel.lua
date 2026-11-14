local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001689_LuckyBagPanel = class("Activity_9001689_LuckyBagPanel", baseFguiPanel)
function Activity_9001689_LuckyBagPanel:ctor(...)
	self.isLRU = true
	Activity_9001689_LuckyBagPanel.super.ctor(self, ...)
	print("Activity_9001689_LuckyBagPanel:ctor", self.viewName)
end
function Activity_9001689_LuckyBagPanel:onInit()
	print("=======Activity_9001689_LuckyBagPanel:onInit")
	self.fields.Panel_bg:setString(i18n("daily_salute_text34"))
	self.fields.Text_none:setString(i18n("daily_salute_text38"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001689_LuckyBagPanel:onItemRenderer(index, obj)
	obj:initData(self.playerList[index + 1], self.bribeType)
end
function Activity_9001689_LuckyBagPanel:endShow()
	print("=======Activity_9001689_LuckyBagPanel:endShow")
	if not self.param.collMap then
		_ENV = self.param.collMap
	end
	self.collMap = self.param.collMap
	self.bribeType = self.param.bribeType
	local bribePickNum = constantRead.getConstValue("DAILY_SALUTE_BRIBE_PICKUP_NUM")
	_ENV = nil
	;(nil).num1 = bribePickNum - table.nums(self.collMap)
	;(nil).num2 = bribePickNum
	self.fields.Text_left:setString(i18n("daily_salute_text37", nil))
	self.playerList, _ENV = self.fields.Text_left.setString, self.fields.Text_left.setString
	for rank, v in pairs(self.collMap) do
		v.rank = tonumber(rank)
		table.insert(self.playerList, v)
	end
	table.sort(self.playerList, function(a, b)
		return a.t < b.t
	end)
	self.fields.List:setNumItems(#self.playerList)
	self.fields.Text_none:setVisible(#self.playerList == 0)
end
return Activity_9001689_LuckyBagPanel
