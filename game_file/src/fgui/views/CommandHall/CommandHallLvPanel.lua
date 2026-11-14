local commandHallRead = include("commandHallRead")
local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallLvPanel = class("CommandHallLvPanel", baseFguiPanel)
function CommandHallLvPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallLvPanel:ctor", self.viewName)
end
function CommandHallLvPanel:onInit()
	print("=======CommandHallLvPanel:onInit")
	local ui = self.fields
	ui.Panel_bg:setString(i18n("commandhall_text_49"))
	ui.Text_des:setString(i18n("commandhall_text_50"))
	ui.Com_jiantou1:getController("c2"):setSelectedIndex(SoraDFIsRA() and 0 or 1)
	ui.Text_probability:setString(i18n("commandhall_text_92"))
	ui.List_probability:setItemRenderer(handler(self, self.onProItemRenderer))
	ui.Text_reward:setString(i18n("commandhall_text_56"))
	ui.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	ui.Button_upgrade:addClickListener(handler(self, self.onClickBtnUpgrade))
	ui.Usm_upgrade:setVisible(false)
	ui.Bar_upgrade:fixChildrenPos()
end
function CommandHallLvPanel:onShow()
	print("=======CommandHallLvPanel:onShow")
	self:refreshView()
end
function CommandHallLvPanel:onProItemRenderer(index, obj)
	local data = self.qualityProConfig[index + 1]
	obj:getController("c_state"):setSelectedIndex(self.isLvMax and 1 or 0)
	obj:fixChildrenPos()
	local ui = fguiHelper.get_fields(obj)
	ui.Text_1:setString(data[1])
	ui.Text_2:setString(data[2])
	ui.Text_3:setString(data[3])
	ui.Image_white:setVisible(index % 2 == 1)
end
function CommandHallLvPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
function CommandHallLvPanel:onClickBtnUpgrade(...)
	SoraDPlaySound()
	commandHallCtrl:reqUpgradeCommandLv()
	SoraDShowLoading(self:displayObject())
end
function CommandHallLvPanel:updateCommandLv(...)
	self.fields.Usm_upgrade:play()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.3)
	;(nil)[2] = ffa.callFunc(function()
		SoraDShowMsgTip(i18n("commandhall_text_75"))
		SoraDCloseLoading(self:displayObject())
		self:refreshView()
	end)
	;(nil)[3] = ffa.callFunc(function()
		SoraDShowMsgTip(i18n("commandhall_text_75"))
		SoraDCloseLoading(self:displayObject())
		self:refreshView()
	end)
	self:runAction(ffa.seq(nil))
end
function CommandHallLvPanel:refreshView(...)
	local data = commandHallCtrl:getInitData()
	local curLv = data.commandLv
	local curExp = data.commandExp
	local commandLvMax = commandHallRead.getCommandLvMax()
	self.isLvMax = curLv >= commandLvMax
	local nextLv = math.min(commandLvMax, curLv + 1)
	local ui = self.fields
	ui.Com_curLv:setString(curLv)
	ui.Com_curLv:setIcon(commandHallRead.getCommandLvIcon(curLv))
	ui.Com_nextLv:setString(nextLv)
	ui.Com_nextLv:setIcon(commandHallRead.getCommandLvIcon(nextLv))
	local curQualityPro = commandHallRead.getCommandLvQualityPro(curLv)
	local nextQualityPro = commandHallRead.getCommandLvQualityPro(nextLv)
	local ret[1], commandHallCtrl, commandHallCtrl, ret = commandHallRead.getCommandLvIcon(nextLv)
	_UPVALUE3_ = commandHallRead.getCommandLvIcon(nextLv)
	commandHallRead.getCommandLvIcon(nextLv)[1] = "commandhall_text_52"
	commandHallRead.getCommandLvIcon(nextLv)[2] = "commandhall_text_53"
	commandHallRead.getCommandLvIcon(nextLv)[3] = "commandhall_text_54"
	for i, v in ipairs(commandHallRead.getCommandLvIcon(nextLv)) do
		commandHallCtrl = v
		v.color = cc.c3b(230, 180, 110)
		table.insert(ret[1], SoraDWrapHtmlTagByStyle(i18n(v), v))
	end
	for i, v in ipairs(curQualityPro) do
		local name = commandHallRead.getQualityName(i)
		commandHallCtrl = SoraDWrapHtmlTagByStyle(i18n(v), v)
		SoraDWrapHtmlTagByStyle(i18n(v), v).color = commandHallRead.getQualityDeepColor(i)
		name = SoraDWrapHtmlTagByStyle(name, SoraDWrapHtmlTagByStyle(i18n(v), v))
		_UPVALUE3_ = SoraDWrapHtmlTagByStyle(i18n(v), v)
		SoraDWrapHtmlTagByStyle(i18n(v), v)[1] = name
		SoraDWrapHtmlTagByStyle(i18n(v), v)[2] = v / 10 .. "%"
		SoraDWrapHtmlTagByStyle(i18n(v), v)[3] = nextQualityPro[i] / 10 .. "%"
		table.insert(ret, SoraDWrapHtmlTagByStyle(i18n(v), v))
	end
	local curRadioStr = commandHallCtrl:getCurDamageRadioStr(curLv)
	local nextRadioStr = commandHallCtrl:getCurDamageRadioStr(nextLv)
	_UPVALUE3_ = "commandhall_text_54"
	commandHallCtrl = "commandhall_text_94"
	;("commandhall_text_94").color = "#FFD43E"
	;("commandhall_text_54")[1] = SoraDWrapHtmlTagByStyle(i18n("commandhall_text_94"), "commandhall_text_94")
	;("commandhall_text_54")[2] = curRadioStr
	;("commandhall_text_54")[3] = nextRadioStr
	table.insert(ret, "commandhall_text_54")
	local curRadioStr = commandHallCtrl:getCurRewardRadioStr(curLv)
	local nextRadioStr = commandHallCtrl:getCurRewardRadioStr(nextLv)
	_UPVALUE3_ = curRadioStr
	commandHallCtrl = "commandhall_text_101"
	;("commandhall_text_101").color = "#FFD43E"
	curRadioStr[1] = SoraDWrapHtmlTagByStyle(i18n("commandhall_text_101"), "commandhall_text_101")
	curRadioStr[2] = curRadioStr
	curRadioStr[3] = nextRadioStr
	table.insert(ret, curRadioStr)
	self.qualityProConfig = ret
	ui.List_probability:setNumItems(#self.qualityProConfig)
	self.rewards = commandHallRead.getCommandLvReward(curLv)
	ui.List_reward:setNumItems(#self.rewards)
	local c_upgrade = self.controllers.c_upgrade
	local needExp = commandHallRead.getCommandLvNeedExp(curLv)
	if self.isLvMax then
		ui.Com_curLv:setPositionX(self.view:getSize().width / 2)
		c_upgrade:setSelectedIndex(2)
		ui.Button_upgrade:setString(i18n("commandhall_text_4"))
		ui.Button_upgrade:setEnabled(false)
	elseif curExp >= needExp then
		c_upgrade:setSelectedIndex(0)
		ui.Button_upgrade:setString(i18n("common_text_055"))
		ui.Button_upgrade:setEnabled(true)
	else
		c_upgrade:setSelectedIndex(1)
		commandHallCtrl = i18n("common_text_055")
		i18n("common_text_055").num = needExp
		ui.Text_upgrade:setString(i18n("commandhall_text_58", i18n("common_text_055")))
		ui.Bar_upgrade:setMax(needExp)
		ui.Bar_upgrade:setValue(curExp)
	end
	ui.Com_curLv:fixPos()
	ui.Com_nextLv:fixPos()
end
return CommandHallLvPanel
