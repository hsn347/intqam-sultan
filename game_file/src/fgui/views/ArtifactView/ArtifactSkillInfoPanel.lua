local equipDesRead = include("equipDesRead")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtifactSkillInfoPanel = class("ArtifactSkillInfoPanel", baseFguiPanel)
function ArtifactSkillInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArtifactSkillInfoPanel:ctor", self.viewName)
end
function ArtifactSkillInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ArtifactSkillInfoPanel:onInit()
	print("=======ArtifactSkillInfoPanel:onInit")
	self:fixChildrenPos()
	self.curData = self.proxy.param.data
	local skillType = self.proxy.param.skillType
	if skillType == 1 then
		self.infoData = equipDesRead.getArtifactAwakeSkillInfo(self.curData.weaponID)
		if self.curData.info.awakeStatus ~= ARMS_AWAKE_STATUS.STATUS_AWAKE then
			self.fields.Text_tip:setString(i18n("artifact_text_23"))
			self.fields.Text_tip:setVisible(true)
		end
	else
		self.infoData = equipDesRead.getArtifactActiveSkill(self.curData.weaponID)
		if self.curData.info and self.curData.info.activeSkillList[1].isActive and not self.curData.isLock then
			self.fields.Node_use:setVisible(true)
			self:showQueue()
		else
			_ENV = i18n("artifact_text_23")
			i18n("artifact_text_23").num = self.curData.info.activeSkillList[1].activeLevel
			self.fields.Text_tip:setString(i18n("artifact_text_01", i18n("artifact_text_23")))
			self.fields.Text_tip:setVisible(true)
		end
	end
	self.fields.com_Skill:setIcon(self.infoData.icon)
	self.fields.Panel_bg:setString(i18n(self.infoData.name))
	self.fields.Text_des:setString(i18n(self.infoData.des))
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnClickCallBack))
end
function ArtifactSkillInfoPanel:onShow()
	print("=======ArtifactSkillInfoPanel:onShow")
end
function ArtifactSkillInfoPanel:showQueue()
	self:endCDTime()
	local isInCD, cdTime = godArmsCtrl:skillInCD(self.infoData.skillID, self.infoData.skillCD)
	if isInCD then
		self:updateUseBtn(true)
		self:beginCDTime()
	else
		self:updateUseBtn(false)
	end
end
function ArtifactSkillInfoPanel:beginCDTime()
	self.timerCD = SoradCreateTimer(self, handler(self, self.updateCDTime))
	self:updateCDTime()
end
function ArtifactSkillInfoPanel:endCDTime()
	if self.timerCD then
		SoraDManagerRemoveTimer(self, self.timerCD)
		self.timerCD = nil
	end
end
function ArtifactSkillInfoPanel:updateCDTime()
	local isInCD, cdTime = godArmsCtrl:skillInCD(self.infoData.skillID, self.infoData.skillCD)
	if isInCD then
		godArmsCtrl = nil
		;(nil).time = SoraDConvertSecondToString(cdTime)
		self.fields.Text_cd:setString(i18n("common_text_725", nil))
	elseif isInCD == false or cdTime == 0 or cdTime == nil then
		self:endCDTime()
		self:updateUseBtn(false)
	end
end
function ArtifactSkillInfoPanel:updateUseBtn(isCD)
	self.fields.Text_cd:setVisible(isCD)
	self.fields.Button_use:setEnabled(not isCD)
end
function ArtifactSkillInfoPanel:btnClickCallBack()
	SoraDPlaySound()
	godArmsCtrl:reqUseSkill(self.infoData.weaponID, self.infoData.skillID)
	self:removeFromParent()
end
return ArtifactSkillInfoPanel
