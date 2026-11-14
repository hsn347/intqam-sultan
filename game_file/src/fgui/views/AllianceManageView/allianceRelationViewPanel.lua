local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceRelationViewPanel = class("allianceRelationViewPanel", baseFguiPanel)
function allianceRelationViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceRelationViewPanel:ctor", self.viewName)
end
function allianceRelationViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceRelationViewPanel:onInit()
	print("=======allianceRelationViewPanel:onInit")
	self.tableRelationList, _ENV, self.curTag = print, print, 4
	self.fields.Com_title:initData(i18n("common_text_3075"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_ignoreAll:setString(i18n("common_text_1266"))
	self.fields.Button_ignoreAll:addClickListener(handler(self, self.btnIgnoreAllClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function allianceRelationViewPanel:onShow()
	print("=======allianceRelationViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initList()
	if not worldMapDefine.isInRemains() then
		SoraDShowLoading(self)
		allianceRelationCtrl:reqGetRelations()
		if allianceDesRead.checkRank(gAllianceRank.R4) then
			allianceRelationCtrl:reqGetRelationInvites()
		end
	else
		self:initData()
	end
end
function allianceRelationViewPanel:setShowMode()
	if allianceDesRead.checkRank(gAllianceRank.R4) then
		self.controllers.c1:setSelectedIndex(self.curTag == 4 and 0 or 1)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function allianceRelationViewPanel:initList()
	_UPVALUE3_, self.tableRelationList, _ENV = nil, nil, nil
	;(nil)[1] = gAllianceRelationType.ALLY
	;(nil)[2] = gAllianceRelationType.FRIENDLY
	local (nil)[3], tableRelationListKey = gAllianceRelationType.ENEMY, nil
	if allianceDesRead.checkRank(gAllianceRank.R4) then
		table.insert(tableRelationListKey, 4)
	end
	for i, v in ipairs(tableRelationListKey) do
		self.tableRelationList[i], _ENV = nil, nil
	end
end
function allianceRelationViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableRelationList[index + 1], index + 1, self.curTag)
end
function allianceRelationViewPanel:initData()
	self.fields.List:setNumItems(#self.tableRelationList)
	local enable = self.tableRelationList[4] and #self.tableRelationList[4] > 0
	self.fields.Button_ignoreAll:setEnabled(enable)
	self:setShowMode()
end
function allianceRelationViewPanel:dataBack(target, data)
