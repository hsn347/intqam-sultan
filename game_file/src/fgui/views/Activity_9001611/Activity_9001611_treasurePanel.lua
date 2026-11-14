local activity_9001611_Ctrl = SoraDGetCtrl("activity_9001611_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001611_treasurePanel = class("Activity_9001611_treasurePanel", baseFguiPanel)
function Activity_9001611_treasurePanel:ctor(...)
	Activity_9001611_treasurePanel.super.ctor(self, ...)
	print("Activity_9001611_treasurePanel:ctor", self.viewName)
end
function Activity_9001611_treasurePanel:onInit()
	print("=======Activity_9001611_treasurePanel:onInit")
	self.rewardCfg, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("Player_Return_test09"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setAlignCenter(true)
	self.fields.Btn_gold:addClickListener(handler(self, self.btnClick))
end
function Activity_9001611_treasurePanel:onItemRenderer(index, obj)
	obj:initData(self.rewardCfg[index + 1].id, self.rewardCfg[index + 1].count)
end
function Activity_9001611_treasurePanel:onShow()
	print("=======Activity_9001611_treasurePanel:onShow")
	self.data = self.param.data
	self:initData()
end
function Activity_9001611_treasurePanel:initData()
	self.fields.Btn_gold:initData(gIDDef.GOLD, self.data.price)
	_UPVALUE2_ = gIDDef.GOLD
	gIDDef.GOLD[1] = "id"
	gIDDef.GOLD[2] = "count"
	self.rewardCfg = serviceFunctions.tableFormat(self.data.dropitem, gIDDef.GOLD)
	self.fields.List_reward:setNumItems(#self.rewardCfg)
	self.fields.List_reward:setScrollEnable(#self.rewardCfg > 5)
end
function Activity_9001611_treasurePanel:btnClick()
	SoraDPlaySound()
	if SoraDEnoughGold(self.data.price) then
		activity_9001611_Ctrl:sendRewardMsg(self.data.rewardtype, self.data.target)
		self:close()
	end
end
return Activity_9001611_treasurePanel
