local luckyWretchCtrl = SoraDGetCtrl("luckyWretchCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LuckyWretchPopPanel = class("LuckyWretchPopPanel", baseFguiPanel)
function LuckyWretchPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LuckyWretchPopPanel:ctor", self.viewName)
end
function LuckyWretchPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LuckyWretchPopPanel:onInit()
	print("=======LuckyWretchPopPanel:onInit")
	self.boxInfo = self.proxy.param.boxInfo
	self.fields.Panel_bg:setString(i18n("Lucky_twist_egg_03"))
	_ENV = i18n("Lucky_twist_egg_03")
	i18n("Lucky_twist_egg_03").num = self.boxInfo.donateScore
	self.fields.Text_Des:setString(i18n("Lucky_twist_egg_04", i18n("Lucky_twist_egg_03")))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_Sure:addClickEventListener(handler(self, self.onClickSure))
	dump(self.boxInfo, "self.boxInfo")
	self.fields.List:setNumItems(#self.boxInfo.stageReward / 2)
end
function LuckyWretchPopPanel:onShow()
	print("=======LuckyWretchPopPanel:onShow")
	self.status = luckyWretchCtrl:getStageStatusByNum(self.boxInfo.stage, self.boxInfo.donateScore)
	if self.status == gBtnTargetStatusDef.GOT then
		self.fields.Button_Sure:setString(i18n("common_text_1892"))
		self.fields.Button_Sure:setEnabled(false)
	elseif self.status == gBtnTargetStatusDef.GET then
		self.fields.Button_Sure:setString(i18n("common_text_1146"))
		self.fields.Button_Sure:setEnabled(true)
	else
		self.fields.Button_Sure:setEnabled(false)
		self.fields.Button_Sure:setString(i18n("common_text_1146"))
	end
end
function LuckyWretchPopPanel:onItemRenderer(index, obj)
	obj:initData(self.boxInfo.stageReward[index * 2 + 1], self.boxInfo.stageReward[index * 2 + 2])
end
function LuckyWretchPopPanel:onClickSure()
	luckyWretchCtrl:reqLuckyWretchStageReward(self.boxInfo.stage)
	self:close()
end
return LuckyWretchPopPanel
