local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local footballElfCtrl = SoraDGetCtrl("footballElfCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local footballElfRead = include("footballElfRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FootballSpiritPanel = class("FootballSpiritPanel", baseFguiPanel)
function FootballSpiritPanel:ctor(...)
	self.super.ctor(self, ...)
	print("FootballSpiritPanel:ctor", self.viewName)
end
function FootballSpiritPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FootballSpiritPanel:onInit()
	print("=======FootballSpiritPanel:onInit")
	self.activityID = gActivityTimeActivityID.FOOTBALL_ELF_ACTIVITY
	self.itemID = 858801
	self.classType = footballElfCtrl:getClassType()
	self.fields.Com_title:initData(i18n("footballelf_title"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Btn_more:addClickListener(handler(self, self.onBtnMore))
	self.fields.Btn_tool:addClickListener(handler(self, self.onBtnTool))
	self.fields.Btn_claim:setString(i18n("summoned_btn_01"))
	self.fields.Btn_claim:setEnabled(false)
	self.fields.Btn_claim:addClickListener(handler(self, self.onBtnClaim))
	self.fields.Btn_unlock:setString(i18n("footballelf_16"))
	self.fields.Btn_unlock:addClickListener(handler(self, self.onBtnUnlock))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_high:setString(i18n("footballelf_02"))
	self.fields.Text_normal:setString(i18n("footballelf_11"))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.timer:setTimeUpdateListener(function(time)
		self = nil
		;(nil).time = fguiHelper.getColorString("#FFFFFF", SoraDConvertSecondToString(time))
		self.fields.timer:setString(i18n("common_text_607", nil))
	end)
	self.fields.Btn_rank:fixPos()
	self.fields.Btn_tool:fixPos()
	self.fields.Btn_more:fixPos()
	self.fields.Text_expLv:fixPos()
	self.fields.Bar_exp:fixPos()
	self.fields.Bar_exp:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Text_pro:fixPos()
	self.fields.n22:fixPos()
	self.fields.n26:fixPos()
	self.fields.Text_high:fixPos()
	self.fields.Text_normal:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.n29:fixPos()
	self.fields.Btn_unlock:fixPos()
end
function FootballSpiritPanel:onShow()
	print("=======FootballSpiritPanel:onShow")
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.timer:beginTime(leftTime)
	end
	self.showList = footballElfRead.getExpCfg(self.classType)
	self:updateView()
end
function FootballSpiritPanel:onItemRenderer(index, obj)
	obj:initData(self.showList[index + 1])
end
function FootballSpiritPanel:updateView(target, data)
	self:setBtnUnlock(data and data.isUnlock)
	self:setToolNum()
	self:setBarInfo()
	self:setBtnClaim()
	self.fields.List:setNumItems(#self.showList)
	local recordLv = footballElfCtrl:getReceiveRecord(footballElfCtrl:getIsUnlock())
	self.fields.List:scrollToView(math.min(recordLv, #self.showList - 1))
	self.fields.com_exSingle:initExtra()
end
function FootballSpiritPanel:setBtnUnlock(isUnlock)
	if isUnlock then
		self.fields.Btn_unlock:playUnlock(function()
			self.controllers.c1:setSelectedIndex(footballElfCtrl:getIsUnlock() and 1 or 0)
		end)
	else
		self.controllers.c1:setSelectedIndex(footballElfCtrl:getIsUnlock() and 1 or 0)
	end
end
function FootballSpiritPanel:setBtnClaim()
	local ret = footballElfCtrl:getReceiveStatusAndNum()
	self.fields.Btn_claim:setEnabled(ret)
end
function FootballSpiritPanel:setToolNum()
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.fields.Btn_tool:initData(self.itemNum)
end
function FootballSpiritPanel:setBarInfo()
	local lv, leftExp, nextExp = footballElfRead.getExpLv(footballElfCtrl:getExp(), self.classType)
	print("lv,leftExp,nextExp====", footballElfCtrl:getExp(), lv, leftExp, nextExp)
	self.fields.Bar_exp:initData(leftExp, nextExp)
	footballElfRead = leftExp
	leftExp.var1 = string.formatnumberthousands(leftExp)
	leftExp.var2 = string.formatnumberthousands(nextExp)
	self.fields.Text_pro:setString(i18n("%{var1}/%{var2}", leftExp))
	self.fields.Text_expLv:setString(lv)
end
function FootballSpiritPanel:onBtnUnlock()
	SoraDPlaySound()
	uiManager:show("FootballSpiritPop")
end
function FootballSpiritPanel:onBtnMore()
	SoraDPlaySound()
	uiManager:show("FootballSpiritGetWay")
end
function FootballSpiritPanel:onBtnTool()
	SoraDPlaySound()
	if self.itemNum > 0 then
		_ENV = nil
		;(nil).pType = 1
		uiManager:show("FootballSpiritProp", nil)
	else
		uiManager:show("FootballSpiritGetWay")
	end
end
function FootballSpiritPanel:onBtnClaim()
	SoraDPlaySound()
	footballElfCtrl:sendReceive()
end
function FootballSpiritPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	_ENV = nil
	;(nil).num = footballElfRead.getMaxExpCfgLv(self.classType)
	;(nil).content = i18n("footballelf_09", nil)
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return FootballSpiritPanel
