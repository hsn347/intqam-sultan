local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaOfficer1Panel = class("NebulaOfficer1Panel", baseFguiPanel)
function NebulaOfficer1Panel:ctor(...)
	NebulaOfficer1Panel.super.ctor(self, ...)
	print("NebulaOfficer1Panel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_PRIVILEGE
end
function NebulaOfficer1Panel:onInit()
	print("=======NebulaOfficer1Panel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001430"), handler(self, self.onClickClose), handler(self, self.onHelpBack))
	self.fields.Label_time:initActivityTimeStyle(self.activityID)
	self.fields.Button_Award:setString(i18n("common_text_1441"))
	self.fields.Button_Award:addClickEventListener(handler(self, self.onClickAward))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	_ENV = self.fields.List.setVirtual
	_ENV, _ENV, self.fields.List.setVirtual.defaultClick = handler(self, self.onItemRenderer)
	_ENV, self.fields.List[1], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	self.fields.List.setVirtual.tabsetArray, self.fields.List[2], handler(self, self.onItemRenderer).title = self.fields.List, handler(self, self.onItemRenderer)
	local self.fields.List.setVirtual.callback, param = handler(self, self.onClickTab), self.fields.List.setVirtual
	self.fields.com_Tab:initView(param)
end
function NebulaOfficer1Panel:onShow()
	print("=======NebulaOfficer1Panel:onShow")
	nebulaPrivilegeCtrl:sendInit()
	self:updateView()
end
function NebulaOfficer1Panel:onHelpBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_war_text_0623")
	uiManager:show("RuleView", nil)
end
function NebulaOfficer1Panel:onClickAward()
	SoraDPlaySound()
	uiManager:show("NebulaAward")
end
function NebulaOfficer1Panel:onClickTab(tag)
	self.curTag = tag
	self.controllers.c1:setSelectedIndex(tag - 1)
end
function NebulaOfficer1Panel:updateView(...)
	self:updateDataOfficer()
	local ret = nebulaPrivilegeCtrl:getGiftStatusAndNum() or false
	self.fields.Button_Award:setReddot(ret)
	local ret = nebulaPrivilegeCtrl:getOfficerStatusAndNum() or false
	self.fields.com_Tab:setBtnRedDot(2, ret)
end
function NebulaOfficer1Panel:updateDataOfficer()
	local round = nebulaPrivilegeCtrl:getRound()
	local officers = nebulaPrivilegelRead.getOfficers(round)
	local nebulaPrivilegeCtrl, ret = round, round
	for _, v in ipairs(officers) do
		if nebulaPrivilegelRead.checkIsAppointID(v.officerID) then
			table.insert(ret, v.officerID)
		end
	end
	self.appintIDList = ret
	self.fields.List:setNumItems(#self.appintIDList)
	local _fields = fguiHelper.get_fields(self.fields.Com_officerInfo)
	for i = 1, 8 do
		local Com_officer = _fields["officerpos" .. i]
		if Com_officer then
			local officerID = self.appintIDList[i]
			if officerID then
				Com_officer:initOfficerID(officerID, true)
			else
				Com_officer:setVisible(false)
			end
		end
	end
end
function NebulaOfficer1Panel:onItemRenderer(index, obj)
	local appintID = self.appintIDList[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local OfficerName = nebulaPrivilegelRead.getOfficialName(appintID)
	_fields.Text_title:setString(i18n(OfficerName))
	if not nebulaPrivilegelRead.getOfficerIDList(appintID) then
		local _ENV, idList = nebulaPrivilegelRead.getOfficerIDList(appintID), nebulaPrivilegelRead.getOfficerIDList(appintID)
	end
	for i = 1, 3 do
		local Com_officer = _fields["Com_officer" .. i]
		if Com_officer then
			local officerID = idList[i]
			if officerID then
				Com_officer:initOfficerID(officerID)
			else
				Com_officer:setVisible(false)
			end
		end
	end
end
return NebulaOfficer1Panel
