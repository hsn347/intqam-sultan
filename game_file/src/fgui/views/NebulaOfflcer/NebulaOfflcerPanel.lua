local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaOfflcerPanel = class("NebulaOfflcerPanel", baseFguiPanel)
local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
function NebulaOfflcerPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaOfflcerPanel:ctor", self.viewName)
end
function NebulaOfflcerPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaOfflcerPanel:onInit()
	print("=======NebulaOfflcerPanel:onInit")
	nebulaPrivilegeCtrl:sendInit()
	self.fieldsScroll = fguiHelper.get_fields(self.fields.Com_scroll)
	self.controllersScroll = fguiHelper.get_controllers(self.fields.Com_scroll)
	self.fields.Com_title:initData(i18n("activity_name_9001430"), handler(self, self.onClickClose), handler(self, self.onHelpBack))
	self.fields.Label_time:initActivityTimeStyle(gActivityTimeActivityID.NEBULA_PRIVILEGE)
	self.fields.Button_Award:setTitle(i18n("common_text_1441"))
	self.fields.Button_Award:addClickEventListener(handler(self, self.onClickAward))
	self:updateView()
end
function NebulaOfflcerPanel:updateView()
	self:updateDataOfficer()
	local ret = nebulaPrivilegeCtrl:getGiftStatusAndNum() or false
	self.fields.Button_Award:setReddot(ret)
end
function NebulaOfflcerPanel:updateDataOfficer()
	local round = nebulaPrivilegeCtrl:getRound()
	local officers = nebulaPrivilegelRead.getOfficers(round)
	for _, v in ipairs(officers) do
		local com = self.fields[v.officerpos] or self.fieldsScroll[v.officerpos]
		if com then
			com:updateDataOfficer(v)
		end
	end
	if round <= 3 then
		self.controllers.c1:setSelectedIndex(0)
		self.controllersScroll.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.controllersScroll.c1:setSelectedIndex(1)
	end
	local nebulaPrivilegeCtrl, ret = self.controllersScroll.c1.setSelectedIndex, self.controllersScroll.c1.setSelectedIndex
	for _, v in ipairs(officers) do
		if nebulaPrivilegelRead.checkIsAppointID(v.officerID) then
			table.insert(ret, v.officerID)
		end
	end
	for i, officerID in ipairs(ret) do
		local Text_title = self.fieldsScroll["Text_title" .. i]
		if Text_title then
			Text_title:setString(i18n(nebulaPrivilegelRead.getOfficialName(officerID)))
		end
	end
end
function NebulaOfflcerPanel:onShow()
	print("=======NebulaOfflcerPanel:onShow")
end
function NebulaOfflcerPanel:onHelpBack()
	SoraDPlaySound()
	local nebulaWarUtil = include("nebulaWarUtil")
	if nebulaWarUtil.checkSelfCampType1() then
		_ENV = nil
		;(nil).content = i18n("nebula_war_text_0623")
		uiManager:show("RuleView", nil)
	else
		_ENV = nil
		;(nil).content = i18n("nebula_officer_text_001")
		uiManager:show("RuleView", nil)
	end
end
function NebulaOfflcerPanel:onClickAward()
	SoraDPlaySound()
	uiManager:show("NebulaAward")
end
return NebulaOfflcerPanel
