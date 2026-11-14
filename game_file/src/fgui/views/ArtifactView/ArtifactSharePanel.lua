local equipDesRead = include("equipDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtifactSharePanel = class("ArtifactSharePanel", baseFguiPanel)
function ArtifactSharePanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArtifactSharePanel:ctor", self.viewName)
end
function ArtifactSharePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ArtifactSharePanel:onInit()
	print("=======ArtifactSharePanel:onInit")
	local data = self.proxy.param
	self.curData = equipDesRead.getShareInfo(data.armsID)
	self.curData.info.level = data.level
	self.curData.info.awakeStatus = data.isAwake and 1 or 0
	self.curData.info.exp = data.exp
	self.attrList = self:getAttrList()
	self.fields.Label_load:setString(i18n("common_text_3853"))
	self.fields.Text_powerTitle:setString(i18n("common_text_090"))
	self.fields.Label_attrTitle:setString(i18n("artifact_title_02"))
	self.fields.List_attr:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Com_skill:addClickListener(handler(self, self.btnSkillClickCallBack))
	self.fields.Com_awakenSkill:addClickListener(handler(self, self.btnAwakeSkillClickCallBack))
	self.fields.Com_skill:fixPos()
	self.fields.Com_awakenSkill:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Bar_Power:fixChildrenPos()
end
function ArtifactSharePanel:onItemRederer(index, target)
	target:initData(self.attrList[index + 1], self.curData.info.level, self.curData.info.awakeStatus)
end
function ArtifactSharePanel:onShow()
	print("=======ArtifactSharePanel:onShow")
	SoraDPlaySound("artifactSound", self.curData.actionNode.sound)
	self:updateArtifactAction()
	self:updatePublic()
end
function ArtifactSharePanel:updateArtifactAction()
	local _, isExist = SoraDIsFileExistByFileName(self.curData.actionNode.png, true)
	if isExist then
		self.fields.Load_artifact:setURL(string.format("ui://ArtifactView/Com_%s", self.curData.weaponID))
		self.fields.Load_artifact:getComponent():getTransition("t0"):play(-1, 0, 0, -1)
		self.fields.Load_artifact:setVisible(true)
		self.fields.Label_load:setVisible(false)
	else
		self.fields.Load_artifact:setVisible(false)
		self.fields.Label_load:setVisible(true)
	end
end
function ArtifactSharePanel:updatePublic(...)
	self.fields.Label_name:setString(i18n(self.curData.name))
	self.fields.Label_name:setIcon(self.curData.typeIcon)
	self.fields.List_attr:setNumItems(#self.attrList)
	self:updatePower()
	self:updateSkill()
	self:updateAwakenSkill()
end
function ArtifactSharePanel:updatePower()
	local lv = self.curData.info.level
	if lv == ARMS_MAX_LEVEL_NORMAL and self.curData.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_NORMAL or lv == ARMS_MAX_LEVEL_ADVANCE then
		local exp = equipDesRead.getArtifactExp(self.curData.weaponID, self.curData.info.level - 1)
		self.fields.Bar_Power:setMax(exp + 1)
		self.fields.Bar_Power:setValue(exp + 1)
		self.fields.Bar_Power:getChild("title"):setString("MAX")
		_ENV = nil
		;(nil).lv = lv
		self.fields.Text_lv:setString(i18n("common_text_100", nil))
	else
		self.oldLevel = lv
		self.fields.Bar_Power:setMax(equipDesRead.getArtifactExp(self.curData.weaponID, lv))
		self.fields.Bar_Power:setValue(self.curData.info.exp)
		_ENV = equipDesRead.getArtifactExp(self.curData.weaponID, lv)
		equipDesRead.getArtifactExp(self.curData.weaponID, lv).lv = lv
		self.fields.Text_lv:setString(i18n("common_text_100", equipDesRead.getArtifactExp(self.curData.weaponID, lv)))
	end
	self.fields.Text_power:setString(string.formatnumberthousands(equipDesRead.getArtifactPower(self.curData.weaponID, lv)))
end
function ArtifactSharePanel:updateSkill()
	if not self.curData.info or not self.curData.info.activeSkillList[1] then
		local equipDesRead, skillData = self.curData.info.activeSkillList[1], self.curData.info.activeSkillList[1]
	end
	local isLock = not skillData.isActive or self.curData.isLock
	self.curSkillData = equipDesRead.getArtifactActiveSkill(self.curData.weaponID)
	self.fields.Com_skill:setIcon(self.curSkillData.icon)
	self.fields.Com_skill:getController("c1"):setSelectedIndex(isLock and 1 or 0)
	if isLock then
		equipDesRead = nil
		;(nil).num = skillData.activeLevel
		self.fields.Com_skill:setString(i18n("artifact_text_01", nil))
	else
		self.fields.Com_skill:setString(i18n(self.curSkillData.name))
	end
end
function ArtifactSharePanel:updateAwakenSkill()
	local awakenInfo = equipDesRead.getArtifactAwakeSkillInfo(self.curData.weaponID)
	self.fields.Com_awakenSkill:setIcon(awakenInfo.icon)
	self.fields.Com_awakenSkill:getController("c1"):setSelectedIndex(self.curData.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_AWAKE and 0 or 1)
	if self.curData.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_AWAKE then
		self.fields.Com_awakenSkill:setString(i18n(awakenInfo.name))
	else
		self.fields.Com_awakenSkill:setString(i18n("artifact_text_22"))
	end
	self.fields.Com_awakenSkill:setVisible(self.curData.info.level >= ARMS_MAX_LEVEL_NORMAL)
end
function ArtifactSharePanel:btnSkillClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.curData
	;(nil).skillType = 2
	uiManager:show("ArtifactSkillInfo", nil)
end
function ArtifactSharePanel:btnAwakeSkillClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.curData
	;(nil).skillType = 1
	uiManager:show("ArtifactSkillInfo", nil)
end
function ArtifactSharePanel:getAttrList()
	if self.curData.info then
		local skillData = self.curData.info.skillList
		if self.curData.info.skillList[1] == nil then
			skillData, _ENV = self.curData.info.skillList[1], self.curData.info.skillList[1]
			for k, v in pairs(self.curData.info.skillList) do
				table.insert(skillData, v)
			end
			table.sort(skillData, function(l, r)
				return l.activeLevel < r.activeLevel
			end)
			self.curData.info.skillList = skillData
		end
		return skillData
	end
	_ENV = skillData
	return self.curData.info.skillList
end
return ArtifactSharePanel
