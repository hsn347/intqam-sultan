local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001588_GainawardPanel = class("Activity_9001588_GainawardPanel", baseFguiPanel)
function Activity_9001588_GainawardPanel:ctor(...)
	Activity_9001588_GainawardPanel.super.ctor(self, ...)
	print("Activity_9001588_GainawardPanel:ctor", self.viewName)
end
function Activity_9001588_GainawardPanel:onInit()
	print("=======Activity_9001588_GainawardPanel:onInit")
	self.fields.Usm_2:setBlendMode(fgui.BlendMode.Normal)
	self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "gongxihdwz_ay.usm" or "gongxihdwz_en.usm")
	self.fields.Text_Tip:setString(i18n("birthday_text_04"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function Activity_9001588_GainawardPanel:onShow()
	print("=======Activity_9001588_GainawardPanel:onShow")
	self.awardList = self.proxy.param.reward
	self.fields.List:setNumItems(#self.awardList)
end
function Activity_9001588_GainawardPanel:onItemRederer(index, target)
	target:initData(self.awardList[index + 1])
	target:getChildByName("line"):setVisible(false)
end
return Activity_9001588_GainawardPanel
