local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001564_GainawardPanel = class("Activity_9001564_GainawardPanel", baseFguiPanel)
function Activity_9001564_GainawardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001564_GainawardPanel:ctor", self.viewName)
end
function Activity_9001564_GainawardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001564_GainawardPanel:onInit()
	print("=======Activity_9001564_GainawardPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.awardList = self.proxy.param.reward
	dump(self.awardList, "config")
	self.fields.Usm_2:setBlendMode(fgui.BlendMode.Normal)
	self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "gongxihdwz_ay.usm" or "gongxihdwz_en.usm")
	self.fields.List:setNumItems(#self.awardList)
	self.fields.Text_Tip:setString(i18n("birthday_text_04"))
end
function Activity_9001564_GainawardPanel:onShow()
	print("=======Activity_9001564_GainawardPanel:onShow")
end
function Activity_9001564_GainawardPanel:onItemRederer(index, target)
	target:initData(self.awardList[index + 1])
	target:getChildByName("line"):setVisible(false)
end
return Activity_9001564_GainawardPanel
