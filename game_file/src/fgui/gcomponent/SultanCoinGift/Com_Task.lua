local sultanCoinRebateCtrl = SoraDGetCtrl("sultanCoinRebateCtrl")
local sultanCoinRebateRead = include("sultanCoinRebateRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SultanCoinGift/Com_Task", Com_Task)
function Com_Task:onInit()
	self:fixChildrenPos()
	self.fields.Award_Scroll:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Button_Task:addClickListener(handler(self, self.onClickTask))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self.fields.group_got:fixPos()
end
function Com_Task:onShow()
end
function Com_Task:initData(data)
	self.index = data.index
	self.status = data.status
	self.controllers.status:setSelectedIndex(data.status)
	local info = sultanCoinRebateRead.getDetailByIndex(data.dataIndex, sultanCoinRebateCtrl:getGroupIndex())
	self.controllers.c1:setSelectedIndex(info.importante)
	self.total = info.consume
	self.award = info.reward
	sultanCoinRebateRead = sultanCoinRebateCtrl:getGroupIndex()
	sultanCoinRebateRead, sultanCoinRebateRead, sultanCoinRebateCtrl:getGroupIndex().num = info.consume, string.formatnumberthousands(info.consume), string.formatnumberthousands(info.consume)
	sultanCoinRebateRead, string.formatnumberthousands(info.consume).num, info.consume.color = info.consume, info.consume, "#FFD43E"
	string.formatnumberthousands(info.consume).__default, info.consume.color = info.consume, "#FFEBB9"
	self.fields.Task_Des:setString(i18n_html("othen_rebate_2", sultanCoinRebateCtrl:getGroupIndex()))
	self.fields.Button_Task:setTitle(self.status == gBtnTargetStatusDef.GO and i18n("othen_rebate_3") or i18n("common_text_1146"))
	self:setScheduleText()
	self.fields.Award_Scroll:setNumItems(#self.award / 2)
	self.fields.Button_Task:getController("c1"):setSelectedIndex(self.status == gBtnTargetStatusDef.GO and 2 or 0)
end
function Com_Task:setScheduleText()
	local count = sultanCoinRebateCtrl:getCostCount()
	local total = self.total
	sultanCoinRebateCtrl = nil
	;(nil).var = string.formatnumberthousands(count)
	sultanCoinRebateCtrl, sultanCoinRebateCtrl, (nil).var1 = total, string.formatnumberthousands(total), string.formatnumberthousands(total)
	sultanCoinRebateCtrl, string.formatnumberthousands(total).var, total.color = total, total, self.status == gBtnTargetStatusDef.GO and "#FF0000" or "#FFEBB9"
	string.formatnumberthousands(total).__default, total.color = total, "#FFEBB9"
	self.fields.Task_Scedule:setString(_G.i18n_html("alliance_stronghold_text_070", nil, (string.formatnumberthousands(total))))
end
function Com_Task:onItemRender(index, target)
	target:initData(self.award[index * 2 + 1], self.award[index * 2 + 2])
end
function Com_Task:onClickTask()
	SoraDPlaySound()
	if self.status == gBtnTargetStatusDef.GET then
		sultanCoinRebateCtrl:reqSultanCoinRebateReceive(self.index)
	elseif GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
return Com_Task
