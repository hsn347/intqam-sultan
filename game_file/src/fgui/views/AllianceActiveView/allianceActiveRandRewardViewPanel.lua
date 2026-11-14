local allianceActiveltCtrl = include("allianceActiveltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceActiveRandRewardViewPanel = class("allianceActiveRandRewardViewPanel", baseFguiPanel)
function allianceActiveRandRewardViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceActiveRandRewardViewPanel:ctor", self.viewName)
end
function allianceActiveRandRewardViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceActiveRandRewardViewPanel:onInit()
	print("=======allianceActiveRandRewardViewPanel:onInit")
	self.rankData, _ENV = print, print
	self.tag = 1
	self.fields.Panel_bg:setString(i18n("alliance_title_09"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function allianceActiveRandRewardViewPanel:onShow()
	print("=======allianceActiveRandRewardViewPanel:onShow")
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("alliance_title_11")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("alliance_title_10")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_TabW:initView(nil)
end
function allianceActiveRandRewardViewPanel:onItemRenderer(index, obj)
	obj:initData(self.rankData[index + 1])
end
function allianceActiveRandRewardViewPanel:onTabClick(tag)
	self.tag = tag
	self.rankData = allianceActiveltCtrl.getRankRewardInfo(tag)
	self.fields.Text_tip:setString(self.tag == 2 and i18n("alliance_text_42") or i18n("alliance_text_40"))
	self.fields.List:setNumItems(#self.rankData)
end
return allianceActiveRandRewardViewPanel
