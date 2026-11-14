local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveCtrl = SoraDGetCtrl("allianceActiveCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceActiveLevelViewPanel = class("allianceActiveLevelViewPanel", baseFguiPanel)
function allianceActiveLevelViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceActiveLevelViewPanel:ctor", self.viewName)
end
function allianceActiveLevelViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceActiveLevelViewPanel:onInit()
	print("=======allianceActiveLevelViewPanel:onInit")
	self.dataList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("alliance_text_23"))
	self.fields.Text_tip:setString(i18n("alliance_text_24"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.icon_level:fixPos()
	self.fields.Font_level:fixPos()
	self.fields.Text_tip:fixPos()
	self.fields.LoadingBar_bar:fixPos()
	self.fields.Text_percent:fixPos()
	self.fields.LoadingBar_bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function allianceActiveLevelViewPanel:onShow()
	print("=======allianceActiveLevelViewPanel:onShow")
	self:initData()
end
function allianceActiveLevelViewPanel:onItemRenderer(index, obj)
	obj:initData(self.dataList[index + 1])
end
function allianceActiveLevelViewPanel:initData()
	local curLv = allianceActiveCtrl:getActiveLevel()
	local curPoint = allianceActiveCtrl:getActivePoint()
	local nextPoint = allianceActiveltCtrl.getActiveLvPoint(curLv + 1)
	self.fields.Font_level:setString(curLv)
	allianceActiveCtrl = nil
	;(nil).member = string.formatnumberthousands(curPoint)
	;(nil).total = string.formatnumberthousands(nextPoint)
	self.fields.Text_percent:setString(i18n("common_text_155", nil))
	self.fields.LoadingBar_bar:setValue(math.min(100, math.floor(curPoint * 100 / nextPoint)))
	self.dataList = allianceActiveltCtrl.getActiveLvInfo()
	self.fields.List:setNumItems(#self.dataList)
end
return allianceActiveLevelViewPanel
