local magicFlipCtrl = SoraDGetCtrl("magicFlipCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampStagePanel = class("MagicLampStagePanel", baseFguiPanel)
function MagicLampStagePanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampStagePanel:ctor", self.viewName)
end
function MagicLampStagePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "StarEnergyCube"
	end
	return self._packageList
end
function MagicLampStagePanel:onInit()
	print("=======MagicLampStagePanel:onInit")
	self.activityID = self.param and self.param.activityID
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		self.fields.Panel_bg:setTitle(i18n("common_text_1232"))
		self.fields.Com_Stage:setActivityID(self.activityID)
		local score = nebulaActivityCtrl:getPlayerScore()
		_ENV = i18n("common_text_1232")
		i18n("common_text_1232").num = score
		self.fields.Text_time:setString(i18n("nebula_war_text_0525", i18n("common_text_1232")))
		self.fields.bg:setVisible(false)
		self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
		self.controllers.c_help:setSelectedIndex(1)
		if not SoraDFIsRA() then
			self.fields.Button_help:fixPos()
		end
	else
		self.fields.Panel_bg:setTitle(i18n("magic_flip_4"))
		_ENV = i18n("magic_flip_4")
		i18n("magic_flip_4").num = magicFlipCtrl:getFlipCount()
		self.fields.Text_time:setString(i18n("magic_flip_8", i18n("magic_flip_4")))
	end
end
function MagicLampStagePanel:onShow()
	print("=======MagicLampStagePanel:onShow")
end
function MagicLampStagePanel:onClickBtnHelp(...)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		uiManager:show("NebulaWarScoreDetail")
	end
end
function MagicLampStagePanel:onMsgUpdateScore()
	if self.activityID ~= gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		return
	end
	local score = nebulaActivityCtrl:getPlayerScore()
	_ENV = nil
	;(nil).num = score
	self.fields.Text_time:setString(i18n("nebula_war_text_0525", nil))
end
function MagicLampStagePanel:onMsgUpdateView(...)
	if self.activityID ~= gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		return
	end
	SoraDCloseLoading(self:displayObject())
	self.fields.Com_Stage:updateScrolll()
end
return MagicLampStagePanel
