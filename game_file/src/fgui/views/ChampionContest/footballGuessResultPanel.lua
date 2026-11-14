local footballChampionCtrl = SoraDGetCtrl("footballChampionCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local footballGuessResultPanel = class("footballGuessResultPanel", baseFguiPanel)
function footballGuessResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("footballGuessResultPanel:ctor", self.viewName)
end
function footballGuessResultPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function footballGuessResultPanel:onInit()
	print("=======footballGuessResultPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001474"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	_ENV = handler(self, self.onItemRederer)
	_ENV, _ENV, handler(self, self.onItemRederer).defaultClick = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).title = i18n("common_text_635")
	_ENV, handler(self, self.onItemRederer)[1], handler(self, self.onItemRederer).tag = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).title = i18n("champion_prediction_05")
	_ENV, handler(self, self.onItemRederer)[2], handler(self, self.onItemRederer).tag = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).title = i18n("champion_prediction_06")
	handler(self, self.onItemRederer).tabsetArray, handler(self, self.onItemRederer)[3], handler(self, self.onItemRederer).tag = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).callback = handler(self, self.onClickTab)
	self.fields.Com_Tab:initView(handler(self, self.onItemRederer))
end
function footballGuessResultPanel:onShow()
	print("=======footballGuessResultPanel:onShow")
end
function footballGuessResultPanel:onItemRederer(index, target)
	target:initData(self.resultList[index + 1])
end
function footballGuessResultPanel:onClickTab(tag)
	self.resultList = footballChampionCtrl:getResutData(tonumber(tag))
	dump(self.resultList, "self.resultList")
	self.fields.List:setNumItems(#self.resultList)
end
return footballGuessResultPanel
