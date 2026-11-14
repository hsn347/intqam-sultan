local baseFguiPanel = require("fgui.base.baseFguiPanel")
local eventQuestRead = include("eventQuestRead")
local legendOfPegasusCtrl = SoraDGetCtrl("legendOfPegasusCtrl")
local LegendOfPegasusRecordPanel = class("LegendOfPegasusRecordPanel", baseFguiPanel)
function LegendOfPegasusRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LegendOfPegasusRecordPanel:ctor", self.viewName)
	self.debug = true
end
function LegendOfPegasusRecordPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "LegendOfPegasus"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function LegendOfPegasusRecordPanel:onInit()
	print("=======LegendOfPegasusRecordPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("lost_ruins_text_23"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function LegendOfPegasusRecordPanel:onShow()
	print("=======LegendOfPegasusRecordPanel:onShow")
	legendOfPegasusCtrl:reqLegendOfPegasusClearNewNum()
	self.records = legendOfPegasusCtrl:getRecordList()
	self.fields.scroll:setNumItems(#self.records)
	self.fields.txt_nodesc:setVisible(#self.records == 0)
	self.fields.txt_nodesc:setString(i18n("Legends_of_Pegasus_text_15"))
end
function LegendOfPegasusRecordPanel:onHide()
	print("=======LegendOfPegasusRecordPanel:onHide")
end
function LegendOfPegasusRecordPanel:onDispose()
	print("=======LegendOfPegasusRecordPanel:onDispose")
end
function LegendOfPegasusRecordPanel:onItemRenderer(index, obj)
	local record = self.records[index + 1]
	obj:initData(record)
end
return LegendOfPegasusRecordPanel
