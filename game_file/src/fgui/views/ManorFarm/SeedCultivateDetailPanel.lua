local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SeedCultivateDetailPanel = class("SeedCultivateDetailPanel", baseFguiPanel)
function SeedCultivateDetailPanel:ctor(...)
	self.isLRU = true
	SeedCultivateDetailPanel.super.ctor(self, ...)
	print("SeedCultivateDetailPanel:ctor", self.viewName)
end
function SeedCultivateDetailPanel:onInit()
	print("=======SeedCultivateDetailPanel:onInit")
	self.fields.Panel_bg:setString(i18n("farmland_text_08"))
	if self.fields.n4 then
		self.fields.n4:setTouchable(false)
	end
	self.fields.btnCancel:setTitle(i18n("farmland_text_94"))
	self.fields.btnCancel:setTouchable(true)
	self.fields.btnCancel:addClickListener(handler(self, self.onClick_btnCancel))
end
function SeedCultivateDetailPanel:endShow()
	print("=======SeedCultivateDetailPanel:endShow")
	self.queue = self:getQueue()
	self:initData()
end
function SeedCultivateDetailPanel:onHide()
	self.fields.timer:endTimeNoCauseEndCallBack()
end
function SeedCultivateDetailPanel:getQueue()
	if not self.param and (not self.proxy or not self.proxy.param) then
		local _UPVALUE0_, param = self.proxy.param, self.proxy.param
	end
	return param.queue or self.queue
end
function SeedCultivateDetailPanel:onClick_btnCancel(context)
	SoraDPlaySound()
	if context then
		context:stopPropagation()
	end
	local queue = self:getQueue()
	_ENV = nil
	;(nil).content = i18n("farmland_text_93")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		self:doCancelMerge(queue)
	end
	uiManager:show("MessageBox", nil)
end
function SeedCultivateDetailPanel:doCancelMerge(queue)
	queue = queue or self:getQueue()
	if queue == nil then
		print("SeedCultivateDetailPanel:doCancelMerge queue is nil")
		return
	end
	manorCityCtrl:reqFarmlandCancelMergeSeed(queue)
	SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_CANCEL_MERGE_SEED)
end
function SeedCultivateDetailPanel:getMergeInputIds(mergeData)
