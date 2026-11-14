local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local collegeDesRead = include("collegeDesRead")
local waitQueueCtrl = SoraDGetCtrl("waitQueueCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local collegeWaitCancelViewPanel = class("collegeWaitCancelViewPanel", baseFguiPanel)
function collegeWaitCancelViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("collegeWaitCancelViewPanel:ctor", self.viewName)
end
function collegeWaitCancelViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function collegeWaitCancelViewPanel:onInit()
	print("=======collegeWaitCancelViewPanel:onInit")
	self.fields.Text_des:setString(i18n("privilege_text_84"))
	self.fields.Button_cancel:setString(i18n("privilege_btn_03"))
	self.fields.Button_cancel:addClickListener(handler(self, self.btnCancelClickCallBack))
end
function collegeWaitCancelViewPanel:onShow()
	print("=======collegeWaitCancelViewPanel:onShow")
	self.techID = self.param.techID
	self.techType = self.param.techType or collegeDesRead.getType(self.techID)
	self.fields.Panel_bg:setString(collegeDesRead.getName(self.techID))
	self:updateView()
end
function collegeWaitCancelViewPanel:updateView()
	self.tableSingleData = technologyCtrl:getTechnoDataByID(self.techID, self.techType)
	self.tableSingleDetails = technologyCtrl:getTechnologyDetails(self.techID, self.tableSingleData.currentLevel)
	self.fields.Com_top:initData(self.techID, self.techType, self.tableSingleData, self.tableSingleDetails)
end
function collegeWaitCancelViewPanel:btnCancelClickCallBack()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("privilege_text_119"), i18n("common_text_204"), nil, function(eventType)
		if eventType == MSGBOX_CALLBACK_YES then
			technologyCtrl:delWaitQueue(gQueueTypeDef.technology_upgrade_queue)
			self:close()
		end
	end)
end
function collegeWaitCancelViewPanel:refreshWaitQueue()
	SoraDRemoveAllAfterPanelFromManager(self)
end
return collegeWaitCancelViewPanel
