local romeActivityltCtrl = include("romeActivityltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RomanPointExplainPanel = class("RomanPointExplainPanel", baseFguiPanel)
function RomanPointExplainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RomanPointExplainPanel:ctor", self.viewName)
end
function RomanPointExplainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RomanSoulNew"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function RomanPointExplainPanel:onInit()
	print("=======RomanPointExplainPanel:onInit")
	self.fields.Text_title:setString(i18n("luckyFlip_title_10"))
	self.fields.Text_tip:setString(i18n("mail_2_text_12"))
	self.data = self:setData()
	self.fields.List_level:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_level:setNumItems(table.nums(self.data))
end
function RomanPointExplainPanel:onItemRenderer(index, object)
	object:initData(self.data[index + 1])
end
function RomanPointExplainPanel:setData(...)
	local _ENV, content
	local _ENV, t
	local _ENV, subTitle
	for i = 1, 10 do
		t, _ENV = nil, nil
		local _ENV, subData
		_ENV = nil
		;(nil).level = i
		t.title = i18n("common_text_1502", nil)
		for index = 1, 16 do
			local _ENV, info
			_ENV = nil
			;(nil).level = index
			info.level = i18n("romanInvaders_text_02", nil)
			info.point = romeActivityltCtrl.getRomeActivityArmyTotalScore(i, index)
			subData[index] = info
		end
		t.subData = subData
		content[i] = t
	end
	return content
end
function RomanPointExplainPanel:onClickClose()
	self:close()
end
function RomanPointExplainPanel:onShow()
	print("=======RomanPointExplainPanel:onShow")
end
function RomanPointExplainPanel:onHide()
	print("=======RomanPointExplainPanel:onHide")
end
function RomanPointExplainPanel:onDispose()
	print("=======RomanPointExplainPanel:onDispose")
end
return RomanPointExplainPanel
