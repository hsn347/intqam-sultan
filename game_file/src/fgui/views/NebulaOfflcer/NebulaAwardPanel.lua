local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAwardPanel = class("NebulaAwardPanel", baseFguiPanel)
local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
function NebulaAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaAwardPanel:ctor", self.viewName)
end
function NebulaAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaAwardPanel:onInit()
	nebulaPrivilegeCtrl:sendInit()
	print("=======NebulaAwardPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001430"), handler(self, self.onClickClose), handler(self, self.onHelpBack))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_Log:setTitle(i18n("common_text_836"))
	self.fields.Button_Log:addClickEventListener(handler(self, self.btnLogClick))
end
function NebulaAwardPanel:onShow()
	print("=======NebulaAwardPanel:onShow")
	self:updateView()
end
function NebulaAwardPanel:updateView()
	local round = nebulaPrivilegeCtrl:getRound()
	local awards = nebulaPrivilegelRead.getOfficerAwardNew(round)
	self.rewards = awards
	self.fields.List_award:setNumItems(#self.rewards)
end
function NebulaAwardPanel:onItemRenderer(index, obj)
	local award = self.rewards[index + 1]
	obj:initData(award)
end
function NebulaAwardPanel:onHelpBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_officer_text_001")
	uiManager:show("RuleView", nil)
end
function NebulaAwardPanel:btnLogClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("NebulaOfflcerAwardLog")
	panel:show()
end
return NebulaAwardPanel
