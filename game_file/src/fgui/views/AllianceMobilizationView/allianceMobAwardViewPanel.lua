local playerMobilizationCtrl = SoraDGetCtrl("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceMobAwardViewPanel = class("allianceMobAwardViewPanel", baseFguiPanel)
function allianceMobAwardViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceMobAwardViewPanel:ctor", self.viewName)
end
function allianceMobAwardViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceMobAwardViewPanel:onInit()
	print("=======allianceMobAwardViewPanel:onInit")
	self.dataList, _ENV, self.tag = print, print, 1
	self.fields.Com_title:initData(i18n("alliance_mobilize_text_01"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onRankRenderer))
end
function allianceMobAwardViewPanel:onRankRenderer(index, obj)
	obj:initData(self.dataList[index + 1], self.tag)
end
function allianceMobAwardViewPanel:onShow()
	print("=======allianceMobAwardViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("common_text_3143")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("common_text_3050")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function allianceMobAwardViewPanel:onClickTab(tag)
	self.tag = tag
	self.fields.Text_notice:setString(self.tag == 1 and i18n("alliance_mobilize_text_02") or i18n("common_text_3594"))
	local matchlev = playerMobilizationCtrl:getAllianceMatchlev()
	if self.tag == 1 then
		self.dataList = mobilizationltCtrl:getStagesAwardByLv(matchlev)
	elseif self.tag == 2 then
		self.dataList = mobilizationltCtrl:getAllianceRankAwardByLv(matchlev)
	end
	self.fields.List:setNumItems(#self.dataList)
	self.fields.List:jumpToTop()
end
return allianceMobAwardViewPanel
