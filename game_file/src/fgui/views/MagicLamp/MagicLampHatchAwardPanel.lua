local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampHatchAwardPanel = class("MagicLampHatchAwardPanel", baseFguiPanel)
function MagicLampHatchAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MagicLampHatchAwardPanel:ctor", self.viewName)
end
function MagicLampHatchAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampHatchAwardPanel:onInit()
	print("=======MagicLampHatchAwardPanel:onInit")
	self.fields.Scroll_award:setItemRenderer(handler(self, self.onItemsRender))
end
function MagicLampHatchAwardPanel:onShow()
	print("=======MagicLampHatchAwardPanel:onShow")
	self.fields.Title:setString(i18n("Battle_Towers_14"))
	self.extra = self.param.extra
	local rate = self.extra.rate
	_ENV = i18n("Battle_Towers_14")
	i18n("Battle_Towers_14").num = rate
	self.fields.Text_Title:setString(i18n("Jinn_hatch_text_34", i18n("Battle_Towers_14")))
	self.awards, _ENV = self.fields.Text_Title.setString, self.fields.Text_Title.setString
	for i, v in ipairs(self.extra.rewards) do
		local oNum = math.floor(v.count / rate)
		_ENV = v.count / rate
		;(v.count / rate).id = v.id
		local (v.count / rate).count, newItem1 = oNum, v.count / rate
		table.insert(self.awards, newItem1)
		_ENV = table.insert
		table.insert.id = v.id
		local table.insert.count, newItem2 = v.count - oNum, table.insert
		table.insert(self.awards, newItem2)
	end
	self.fields.Scroll_award:setNumItems(#self.awards)
end
function MagicLampHatchAwardPanel:onItemsRender(index, obj)
	local data = self.awards[index + 1]
	obj:initData(data, index == 1)
end
return MagicLampHatchAwardPanel
