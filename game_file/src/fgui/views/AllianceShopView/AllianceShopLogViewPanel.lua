local gametop = gModuleMgr.getObject("gametop")
local allianceStore = gametop.playertop_:getModule("allianceStore")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceShopLogViewPanel = class("AllianceShopLogViewPanel", baseFguiPanel)
function AllianceShopLogViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceShopLogViewPanel:ctor", self.viewName)
end
function AllianceShopLogViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceShopLogViewPanel:onInit()
	print("=======AllianceShopLogViewPanel:onInit")
	self.curType = gAllianceStoreRecordType.ITEMSHOP
	self.fields.Panel_bg:setString(i18n("common_text_836"))
	self.fields.Text_notice:setString(i18n("common_text_1959"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function AllianceShopLogViewPanel:onShow()
	print("=======AllianceShopLogViewPanel:onShow")
	self:initData(self.proxy.param.curType)
end
function AllianceShopLogViewPanel:initData(type)
	self.curType = type == gIDDef.ALLIANCE_HONOR and gAllianceStoreRecordType.STORE or gAllianceStoreRecordType.ITEMSHOP
	SoraDShowLoading(self)
	allianceStore:reqStoreRecord(self.curType)
end
function AllianceShopLogViewPanel:updateScrollWithData(logData)
	SoraDCloseLoading(self)
	self.logData = logData
	if #self.logData == 0 then
		self.fields.Text_notice:setVisible(true)
	else
		self.fields.List:setNumItems(#self.logData)
	end
end
function AllianceShopLogViewPanel:onItemRederer(index, target)
	target:initData(self.logData[index + 1], self.curType)
end
return AllianceShopLogViewPanel
