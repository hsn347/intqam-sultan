local allianceTerritoryAPI = include("allianceTerritoryAPI")
local resDesRead = include("resDesRead")
local lordLocalData = include("lordLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceWarehouseLogViewPanel = class("allianceWarehouseLogViewPanel", baseFguiPanel)
function allianceWarehouseLogViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("allianceWarehouseLogViewPanel:ctor", self.viewName)
end
function allianceWarehouseLogViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceWarehouseLogViewPanel:onInit()
	print("=======allianceWarehouseLogViewPanel:onInit")
	self.memberListData, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch")
	self.keyName = nil
	self.nextIndex = nil
	self.fromLoadText = false
	self.ccs_bg = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitle(i18n("common_text_3019"))
	self.scroll = SoraDGetChildByName(self, "scroll")
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.noTip = SoraDGetChildByName(self, "Center_no_tip")
	self.noTip:setString(i18n("god_beast_text_16"))
	self.scroll:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollEventCallBack))
	SoraDShowLoading(self)
	allianceTerritoryAPI:loadTaxRecordList(nil, 10)
end
function allianceWarehouseLogViewPanel:onShow()
	print("=======allianceWarehouseLogViewPanel:onShow")
end
function allianceWarehouseLogViewPanel:scrollEventCallBack(target, event)
	if self.fromLoadText and self.nextIndex then
		SoraDShowLoading(self)
		allianceTerritoryAPI:loadTaxRecordList(self.nextIndex, 10)
		self.fromLoadText = false
	end
end
function allianceWarehouseLogViewPanel:dataBack(target, data)
	self.nextIndex = data.nextReqFlag
	local allianceInviteListData = data.data
	for i, v in ipairs(allianceInviteListData) do
		table.insert(self.memberListData, v)
	end
	self:updateScrollSize()
	self:initMemberList()
	SoraDCloseLoading(self)
end
function allianceWarehouseLogViewPanel:onItemRenderer(index, single)
	local data = self.memberListData[index + 1]
	single:fixChildrenPos()
	local labelName = SoraDGetChildByName(single, "Text_name")
	local labelTime = SoraDGetChildByName(single, "Text_time")
	local imgHead = SoraDGetChildByName(single, "Image_head")
	local labelValueTitle = SoraDGetChildByName(single, "Text_valueTitle")
	local labelValue = SoraDGetChildByName(single, "Text_value")
	local imgIcon = SoraDGetChildByName(single, "Image_icon")
	if data.uInfo.allianceAbbr then
		_ENV = nil
		;(nil).abbr = data.uInfo.allianceAbbr
		;(nil).name = data.uInfo.nickname
		labelName:setString(i18n("common_text_186", nil))
	else
		labelName:setString(data.uInfo.nickname)
	end
	labelTime:setString(SoraDConvertTimeToDate(data.t, nil, nil, true))
	labelValue:setString(string.formatnumberthousands(data.res.num))
	labelValueTitle:setString(i18n("common_text_3020"))
	SoraDGetHeadFromManager(imgHead, data.uInfo.userIcon, data.uInfo.avatar)
	imgIcon:setIcon(resDesRead.getIcon(data.res.id))
	imgIcon:setPositionX(labelValueTitle:getPositionX() - SoraDFSign(labelValueTitle:getContentSize().width + 5))
	labelValue:setPositionX(imgIcon:getPositionX() - SoraDFSign(imgIcon:getContentSize().width + 5))
end
function allianceWarehouseLogViewPanel:initMemberList()
	self.scroll:setNumItems(#self.memberListData)
	self.noTip:setVisible(#self.memberListData <= 0)
	self.fromLoadText = true
end
function allianceWarehouseLogViewPanel:updateScrollSize()
end
return allianceWarehouseLogViewPanel
