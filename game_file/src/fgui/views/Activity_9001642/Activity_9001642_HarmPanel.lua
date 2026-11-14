local activity_9001642_Ctrl = SoraDGetCtrl("activity_9001642_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001642_HarmPanel = class("Activity_9001642_HarmPanel", baseFguiPanel)
function Activity_9001642_HarmPanel:ctor(...)
	Activity_9001642_HarmPanel.super.ctor(self, ...)
	print("Activity_9001642_HarmPanel:ctor", self.viewName)
end
function Activity_9001642_HarmPanel:onInit()
	print("=======Activity_9001642_HarmPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Phonex_Challenge_text_15"))
	self.fields.Text_tip:setString(i18n("Phonex_Challenge_text_18"))
	self.fields.Text_none:setString(i18n("common_text_927"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onRecordRenderer))
	self.fields.Btn_help:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_help:fixPos()
end
function Activity_9001642_HarmPanel:onRecordRenderer(index, obj)
	obj:initData(self.record[index + 1])
end
function Activity_9001642_HarmPanel:onShow()
	print("=======Activity_9001642_HarmPanel:onShow")
	self.record, _ENV = print, print
	local record = activity_9001642_Ctrl:getRecords()
	local _ENV, bestMap = activity_9001642_Ctrl, activity_9001642_Ctrl
	for k, v in ipairs(record) do
		local day = os.date("%d", v.t)
		if not bestMap[day] then
			_ENV = bestMap[day]
			bestMap[day].index = k
			bestMap[day], bestMap[day].score = bestMap[day], v.score
		elseif v.score > bestMap[day].score then
			_ENV = v.score
			v.score.index = k
			bestMap[day], v.score.score = v.score, v.score
		end
	end
	for k, v in ipairs(record) do
		local day = os.date("%d", v.t)
		_ENV = nil
		;(nil).date = os.date("%m-%d %H:%M", v.t)
		;(nil).score = v.score
		;(nil).isBest = bestMap[day].index == k
		table.insert(self.record, nil)
	end
	self.fields.List:setNumItems(#self.record)
	self.fields.Text_none:setVisible(#self.record == 0)
end
function Activity_9001642_HarmPanel:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Phonex_Challenge_text_16")
	uiManager:show("RuleView", nil)
end
return Activity_9001642_HarmPanel
