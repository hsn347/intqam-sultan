local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteOnekeyUpPanel = class("MeteoriteOnekeyUpPanel", baseFguiPanel)
local meteorMagicRead = include("meteorMagicRead")
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
function MeteoriteOnekeyUpPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MeteoriteOnekeyUpPanel:ctor", self.viewName)
end
function MeteoriteOnekeyUpPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteOnekeyUpPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MeteoriteOnekeyUpPanel:onInit")
	self.idGroup = self.param.idGroup
	self.curProjectID = self.param.curProjectID
	self.fields.Panel_bg:setTitle(i18n("meteoritesmagic_text_62"))
	self.fields.btn_cancel:addClickEventListener(handler(self, self.close))
	self.fields.btn_sure:addClickEventListener(handler(self, self.openLights))
	self.fields.btn_cancel:setTitle(i18n("common_text_185"))
	self.fields.btn_sure:setTitle(i18n("common_text_204"))
end
function MeteoriteOnekeyUpPanel:onShow()
	print("=======MeteoriteOnekeyUpPanel:onShow")
	self:updateView()
	_ENV = self
	self.msg = "MESSAGE_UPDATE_METEOR_MAGIC_TALENTS_PREVIEW"
	self.idGroups = self.groupIds
	self.isShow = true
	SoraDSendMessage(self)
end
function MeteoriteOnekeyUpPanel:onHide()
	print("=======MeteoriteOnekeyUpPanel:onHide")
	_ENV = "=======MeteoriteOnekeyUpPanel:onHide"
	;("=======MeteoriteOnekeyUpPanel:onHide").msg = "MESSAGE_UPDATE_METEOR_MAGIC_TALENTS_PREVIEW"
	;("=======MeteoriteOnekeyUpPanel:onHide").idGroups = self.groupIds
	;("=======MeteoriteOnekeyUpPanel:onHide").isShow = false
	SoraDSendMessage("=======MeteoriteOnekeyUpPanel:onHide")
end
function MeteoriteOnekeyUpPanel:updateView()
	self.magicId = meteorMagicRead.getMagicId(self.idGroup, 1)
	self.magicCfg = meteorMagicRead.getMagicCfg(self.magicId)
	self.projectData = meteorMagicCtrl:getProjectData(self.curProjectID)
	meteorMagicRead = nil
	;(nil).name = i18n(meteorMagicRead.getName(self.idGroup))
	self.fields.text_title:setString(i18n("meteoritesmagic_text_63", nil))
	self.fields.text_cost:setString(i18n("meteoritesmagic_text_64"))
	self.fields.text_have:setString(i18n("meteoritesmagic_text_65"))
	self.groupIds, meteorMagicRead, self.costNum = self.fields.text_have.setString, self.fields.text_have.setString, 0
	self.groupIds = self:getPreviewGroupIds(self.magicId, self.groupIds)
	self.haveNum = meteorMagicCtrl:getTalentNum() - self.projectData.costTalentNum
	self.fields.text_cost_num:setString(self.costNum)
	self.fields.text_have_num:setString(self.haveNum)
	self.fields.text_have_num:setColor(self.haveNum >= self.costNum and cc.c3b(215, 195, 155) or cc.c3b(190, 30, 30))
	self.fields.text_tip:setString(i18n(self.haveNum >= self.costNum and "meteoritesmagic_text_66" or "meteoritesmagic_text_21"))
end
function MeteoriteOnekeyUpPanel:getPreviewGroupIds(magicId, idGroups)
	local idGroup, lv = meteorMagicRead.getIdGroup(magicId)
	for i, v in ipairs(idGroups) do
		if v == idGroup then
			return idGroups
		end
	end
	table.insert(idGroups, idGroup)
	self.costNum = self.costNum + 1
	local magicCfg = meteorMagicRead.getMagicCfg(magicId)
	for i, v in ipairs(magicCfg.specifiedId) do
		local isLvLight = meteorMagicCtrl:getIsLvLight(v, self.curProjectID)
		if not isLvLight then
			idGroups = self:getPreviewGroupIds(v, idGroups)
		end
	end
	local isNeedThereintoId = #magicCfg.thereintoId > 0
	for i, v in ipairs(magicCfg.thereintoId) do
		local isLvLight = meteorMagicCtrl:getIsLvLight(v, self.curProjectID)
		if isLvLight then
			isNeedThereintoId = false
			break
		end
	end
	if isNeedThereintoId then
		idGroups = self:getPreviewGroupIds(magicCfg.thereintoId[1], idGroups)
	end
	return idGroups
end
function MeteoriteOnekeyUpPanel:openLights()
	SoraDPlaySound()
	if self.haveNum < self.costNum then
		SoraDShowMsgTip(i18n("meteoritesmagic_text_21"))
		self:close()
		return
	end
	meteorMagicCtrl:openLights(self.curProjectID, self.groupIds)
	_ENV = self.curProjectID
	self.curProjectID.byUID = true
	if not SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", self.curProjectID) then
		_ENV = SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", self.curProjectID)
	end
	self.savedIdGroups = SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", self.curProjectID)
	if not self.savedIdGroups[tostring(self.curProjectID)] then
		self.savedIdGroups[tostring(self.curProjectID)], _ENV = self.curProjectID, self.curProjectID
	end
	self.savedIdGroups[tostring(self.curProjectID)][tostring(self.magicCfg.type)] = self.idGroup
	_ENV = self.groupIds
	self.groupIds.byUID = true
	SoraDConfigSet("Game:MeteoriteTalentsPanel:savedIdGroup~table", self.savedIdGroups, self.groupIds)
	self:close()
end
return MeteoriteOnekeyUpPanel
