local baseFguiPanel = require("fgui.base.baseFguiPanel")
local congratulations2Panel = class("congratulations2Panel", baseFguiPanel)
function congratulations2Panel:ctor(...)
	self.super.ctor(self, ...)
	print("congratulations2Panel:ctor", self.viewName)
end
function congratulations2Panel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function congratulations2Panel:onInit()
	print("=======congratulations2Panel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.awardList = self.proxy.param.reward
	dump(self.awardList, "config")
	self.fields.Usm_2:setBlendMode(fgui.BlendMode.Normal)
	self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "gongxihdwz_ay.usm" or "gongxihdwz_en.usm")
	self.fields.List:setNumItems(#self.awardList)
	self.fields.Text_Tip:setString(i18n("birthday_text_04"))
end
function congratulations2Panel:onShow()
	print("=======congratulations2Panel:onShow")
end
function congratulations2Panel:onItemRederer(index, target)
	target:initData(self.awardList[index + 1].id, self.awardList[index + 1].count)
end
return congratulations2Panel
