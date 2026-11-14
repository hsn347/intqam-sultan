local gametop = gModuleMgr.getObject("gametop")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigrateMobilityViewPanel = class("kohMigrateMobilityViewPanel", baseFguiPanel)
function kohMigrateMobilityViewPanel:ctor(...)
	kohMigrateMobilityViewPanel.super.ctor(self, ...)
	print("kohMigrateMobilityViewPanel:ctor", self.viewName)
	self.debug = true
	self.kingdomID = gametop.playertop_:getKingdomID()
	self.iBegin = 1
	self.nCount = 15
end
function kohMigrateMobilityViewPanel:onInit()
	print("=======kohMigrateMobilityViewPanel:onInit")
	self.fields.Com_title:initData(i18n("across_outAndIn_title"), handler(self, self.onClickClose))
	_ENV = i18n("across_outAndIn_title")
	_ENV, _ENV, i18n("across_outAndIn_title").var1 = "#%d", string.format("#%d", self.kingdomID), string.format("#%d", self.kingdomID)
	_ENV, string.format("#%d", self.kingdomID).var1, ("#%d").color = "#%d", "#%d", "#FFD719"
	string.format("#%d", self.kingdomID).__default, ("#%d").color = "#%d", "#FEF9EC"
	local kingdomStr = i18n_html("across_myKingdom_name", i18n("across_outAndIn_title"), (string.format("#%d", self.kingdomID)))
	self.fields.Text_kingdom:setString(kingdomStr)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("across_outAndIn_noInfo_desc"))
end
function kohMigrateMobilityViewPanel:onShow()
	print("=======kohMigrateMobilityViewPanel:onShow")
	self:reqData()
end
function kohMigrateMobilityViewPanel:refreshData(target, event)
	SoraDCloseLoading(self)
	self.hasMore = event.hasMore
	local mobilityList = kohMigrateCtrl:getMobilityList()
	self.mobilityList = mobilityList
	self.fields.List:setNumItems(#mobilityList)
	self.fields.Text_noData:setVisible(#mobilityList == 0)
	self.iBegin = #mobilityList + 1
end
function kohMigrateMobilityViewPanel:onItemRenderer(index, obj)
	local data = self.mobilityList[index + 1]
	obj:initMobilitySingle()
	obj:initData(data)
end
function kohMigrateMobilityViewPanel:onPullUpRelease()
	if self.hasMore then
		self:reqData()
	end
end
function kohMigrateMobilityViewPanel:reqData(...)
	SoraDShowLoading(self)
	kohMigrateCtrl:reqRecords(self.kingdomID, self.iBegin, self.nCount)
end
return kohMigrateMobilityViewPanel
