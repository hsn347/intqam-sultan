local nebulaKingCtrl = SoraDGetCtrl("nebulaKingCtrl")
local nebulaKingRead = include("nebulaKingRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaKingPreviewPanel = class("NebulaKingPreviewPanel", baseFguiPanel)
function NebulaKingPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaKingPreviewPanel:ctor", self.viewName)
end
function NebulaKingPreviewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaKingPreviewPanel:onInit()
	print("=======NebulaKingPreviewPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001440"), handler(self, self.onClickClose))
	self.fields.Text_reward:setString(i18n("common_text_2078"))
	self.fields.Text_desc:setString(i18n("Nebulaking_rule_01"))
	self.fields.Button_history:setString(i18n("Nebulaking_title_02"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_history:addClickListener(handler(self, self.onClickHistory))
end
function NebulaKingPreviewPanel:onClickHistory()
	uiManager:show("NebulaKingHistory")
end
function NebulaKingPreviewPanel:onItemRenderer(index, obj)
	local itemID = self.rewardList[index + 1]
	obj:initData(itemID)
end
function NebulaKingPreviewPanel:onShow()
	print("=======NebulaKingPreviewPanel:onShow")
	if nebulaKingCtrl:isActivityOpen() and not self.param.testOpen then
		self:close()
		SoraDShowMsgTip(i18n("common_text_1516"))
		return
	end
	local activityData = nebulaKingCtrl:getActivityData()
	self.begintime = activityData.begintime
	SoradCreateTimer(self, handler(self, self.updateTime))
	self:updateTime()
	local groupId = nebulaKingCtrl:getGroupId()
	local groupCfg = nebulaKingRead.getGroupCfg(groupId)
	self.fields.Spine_hero:setEffectPath(groupCfg.picture)
	self.rewardList = groupCfg.previewReward
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function NebulaKingPreviewPanel:updateTime()
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
return NebulaKingPreviewPanel
