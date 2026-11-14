local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
local nebulaCompetitionRead = include("nebulaCompetitionRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCompetitionPreviewPanel = class("NebulaCompetitionPreviewPanel", baseFguiPanel)
function NebulaCompetitionPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaCompetitionPreviewPanel:ctor", self.viewName)
end
function NebulaCompetitionPreviewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaCompetitionPreviewPanel:onInit()
	print("=======NebulaCompetitionPreviewPanel:onInit")
	self.fields.Com_title:initData(i18n("Nebula_Competition_title_01"), handler(self, self.onClickClose), function()
		_ENV = nil
		;(nil).content = i18n("Nebula_Competition_text_03")
		uiManager:show("RuleView", nil)
	end)
	self.fields.Text_reward:setString(i18n("common_text_2078"))
	self.fields.Text_desc:setString(i18n("Nebula_Competition_text_02"))
	self.fields.Button_history:setString(i18n("Nebula_Competition_title_02"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_history:addClickListener(handler(self, self.onClickHistory))
end
function NebulaCompetitionPreviewPanel:onClickHistory()
	uiManager:show("NebulaCompetitionHistory")
end
function NebulaCompetitionPreviewPanel:onItemRenderer(index, obj)
	local itemID = self.rewardList[index + 1]
	obj:initData(itemID)
end
function NebulaCompetitionPreviewPanel:onShow()
	print("=======NebulaCompetitionPreviewPanel:onShow")
	if nebulaCompetitionCtrl:isActivityOpen() and not self.param.testOpen then
		self:close()
		SoraDShowMsgTip(i18n("common_text_1516"))
		return
	end
	local activityData = nebulaCompetitionCtrl:getActivityData()
	self.begintime = activityData.begintime
	SoradCreateTimer(self, handler(self, self.updateTime))
	self:updateTime()
	local groupId = nebulaCompetitionCtrl:getGroupId()
	local groupCfg = nebulaCompetitionRead.getGroupCfg(groupId)
	self.rewardList = groupCfg.previewReward
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function NebulaCompetitionPreviewPanel:updateTime()
	local curTime = serviceFunctions.systemTime()
	local leftTime = self.begintime - curTime
	if leftTime < 0 and not self.param.testOpen then
		self:close()
		SoraDShowMsgTip(i18n("common_text_1516"))
		return
	end
	local strTime = SoraDConvertSecondToString(leftTime)
	_ENV = i18n("common_text_1516")
	i18n("common_text_1516").time = strTime
	self.fields.Label_leftTime:setString(i18n("common_text_606", i18n("common_text_1516")))
end
return NebulaCompetitionPreviewPanel
