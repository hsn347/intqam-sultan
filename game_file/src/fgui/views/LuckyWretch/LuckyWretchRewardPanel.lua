local luckyWretchRead = include("luckyWretchRead")
local luckyWretchCtrl = SoraDGetCtrl("luckyWretchCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LuckyWretchRewardPanel = class("LuckyWretchRewardPanel", baseFguiPanel)
function LuckyWretchRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LuckyWretchRewardPanel:ctor", self.viewName)
end
function LuckyWretchRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LuckyWretchRewardPanel:onInit()
	print("=======LuckyWretchRewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.awardList = luckyWretchRead.getPreawardConfig(luckyWretchCtrl:getClassType())
	self.fields.List:setNumItems(#self.awardList)
end
function LuckyWretchRewardPanel:onShow()
	print("=======LuckyWretchRewardPanel:onShow")
end
function LuckyWretchRewardPanel:onItemRenderer(index, obj)
	obj:initData(self.awardList[index + 1])
end
return LuckyWretchRewardPanel
