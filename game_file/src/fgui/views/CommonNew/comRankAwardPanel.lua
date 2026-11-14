local baseFguiPanel = require("fgui.base.baseFguiPanel")
local comRankAwardPanel = class("comRankAwardPanel", baseFguiPanel)
function comRankAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("comRankAwardPanel:ctor", self.viewName)
end
function comRankAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function comRankAwardPanel:onInit()
	self.awardList = self.proxy.param.awardList
	self.fields.List_Award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.Panel_bg:setTitle(i18n("hero_title_02"))
	print("=======comRankAwardPanel:onInit")
end
function comRankAwardPanel:onShow()
	print("=======comRankAwardPanel:onShow")
	self.fields.List_Award:setNumItems(#self.awardList)
end
function comRankAwardPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function comRankAwardPanel:setTitle(str)
	self.fields.Panel_bg:setTitle(str or i18n("hero_title_02"))
end
return comRankAwardPanel
