local allianceMgr = SoraDGetCtrl("allianceMgr")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtifactsShareBoxPanel = class("ArtifactsShareBoxPanel", baseFguiPanel)
function ArtifactsShareBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArtifactsShareBoxPanel:ctor", self.viewName)
end
function ArtifactsShareBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ArtifactsShareBoxPanel:onInit()
	print("=======ArtifactsShareBoxPanel:onInit")
	self.shareAid = self.proxy.param.shareAid
	self.fields.Panel_bg:setString(i18n("common_text_533"))
	self.checkBoxWorld = self.fields.CheckBox_world
	self.checkBoxAlliance = self.fields.CheckBox_alliance
	self.checkBoxWorld:addClickListener(handler(self, self.btnCheckClickCallBack))
	self.checkBoxAlliance:addClickListener(handler(self, self.btnCheckClickCallBack))
	self.fields.Text_world:setString(i18n("common_text_1486"))
	self.fields.Text_alliance:setString(i18n("common_text_1487"))
	self:setCheck(true)
	self.fields.Button_share:setString(i18n("common_text_533"))
	self.fields.Button_share:setCostNum(ARMS_SHARE_GOLD)
	self.fields.Button_share:addClickListener(handler(self, self.btnClickCallBack))
	if not SoraDFIsRA() then
		self.checkBoxWorld:fixPos()
		self.checkBoxAlliance:fixPos()
		self.fields.Text_world:fixPos()
		self.fields.Text_alliance:fixPos()
	end
end
function ArtifactsShareBoxPanel:onShow()
	print("=======ArtifactsShareBoxPanel:onShow")
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	self:openTimeUp()
end
function ArtifactsShareBoxPanel:openTimeUp()
	local leftTime = godArmsCtrl:getShareCDTime()
	self.fields.Text_cd:setVisible(0 < leftTime)
	self.fields.Button_share:setTouchEnabled(leftTime <= 0)
	self.fields.Button_share:setBright(leftTime <= 0)
	if 0 < leftTime then
		godArmsCtrl = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.fields.Text_cd:setString(i18n("common_text_2944", nil))
	end
end
function ArtifactsShareBoxPanel:setCheck(isWorld)
	self.checkBoxWorld:setSelected(isWorld)
	self.checkBoxWorld:setTouchEnabled(not isWorld)
	self.checkBoxAlliance:setSelected(not isWorld)
	self.checkBoxAlliance:setTouchEnabled(isWorld)
end
function ArtifactsShareBoxPanel:btnClickCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(PET_SHARE_GOLD) then
		godArmsCtrl:reqShare(self.shareAid, self.checkBoxWorld:isSelected() and gChatChannel.KINGDOM or gChatChannel.ALLIANCE)
		self:removeFromParent()
	end
end
function ArtifactsShareBoxPanel:btnCheckClickCallBack(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	if button == self.checkBoxWorld then
		self:setCheck(true)
	elseif not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("common_text_583"))
		self:setCheck(true)
	else
		self:setCheck(false)
	end
end
return ArtifactsShareBoxPanel
