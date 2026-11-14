local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteDetailsPanel = class("MeteoriteDetailsPanel", baseFguiPanel)
local meteorMagicRead = include("meteorMagicRead")
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
function MeteoriteDetailsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MeteoriteDetailsPanel:ctor", self.viewName)
end
function MeteoriteDetailsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteDetailsPanel:onInit()
	print("=======MeteoriteDetailsPanel:onInit")
	self.fields.text_max:setString(i18n("common_text_283"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemsRenderer))
	self.fields.btn:addClickEventListener(handler(self, self.onClicked))
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
		self.controllers.c1:fix(true)
	end
end
function MeteoriteDetailsPanel:onShow()
	self.idGroup = self.param.idGroup
	self.curProjectID = self.param.curProjectID
	self:updateView(true)
end
function MeteoriteDetailsPanel:onHide()
	print("MeteoriteDetailsPanel:onHide()")
	_ENV = "MeteoriteDetailsPanel:onHide()"
	;("MeteoriteDetailsPanel:onHide()").msg = "MESSAGE_UPDATE_METEOR_MAGIC_TALENTS"
	SoraDSendMessage("MeteoriteDetailsPanel:onHide()")
end
function MeteoriteDetailsPanel:updateView(isOpen)
	self.projectData = meteorMagicCtrl:getProjectData(self.curProjectID)
	self.lv = self.projectData.light[tostring(self.idGroup)] or 0
	if not isOpen and self.oldLv ~= self.lv and self.lv == meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100 then
		self:close()
		return
	end
	self.oldLv = self.lv
	self.showLv = self.lv == 0 and 1 or self.lv
	self.magicId = meteorMagicRead.getMagicId(self.idGroup, self.showLv)
	self.magicCfg = meteorMagicRead.getMagicCfg(self.magicId)
	self.nextMagicCfg = meteorMagicRead.getMagicCfg(self.magicId + 1)
	self.showMagicCfg = self.nextMagicCfg
	if self.lv == 0 then
		local nextMagicID = meteorMagicRead.getMaxLvMagicId(self.idGroup)
		self.showMagicCfg = meteorMagicRead.getMagicCfg(nextMagicID)
	end
	self.fields.Panel_bg:setTitle(i18n(meteorMagicRead.getName(self.idGroup)))
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local buildLv = cityCtrl:getBuildMaxLv(BUILDID.NEBULA_PALACE)
	self.buildLv = buildLv
	self.fields.scroll:setSize(cc.size(513, 118))
	self.isOneKey = false
	if self.showMagicCfg == nil and self.lv ~= 0 then
		self.controllers.c1:setSelectedIndex(2)
	else
		local needMagicCfg = self.lv == 0 and self.magicCfg or self.nextMagicCfg
		local isSpecifiedAll = true
		self.spNeeds, meteorMagicCtrl = 2, 2
		for i, v in ipairs(needMagicCfg.specifiedId) do
			local isLvLight = meteorMagicCtrl:getIsLvLight(v, self.curProjectID)
			if not isLvLight then
				isSpecifiedAll = false
			end
			meteorMagicCtrl = self.curProjectID
			self.curProjectID.id = v
			self.curProjectID.isLvLight = isLvLight
			table.insert(self.spNeeds, self.curProjectID)
		end
		self.thNeeds, meteorMagicCtrl = ipairs(needMagicCfg.specifiedId)
		local isThereintoOne = #needMagicCfg.thereintoId == 0
		for i, v in ipairs(needMagicCfg.thereintoId) do
			local isLvLight = meteorMagicCtrl:getIsLvLight(v, self.curProjectID)
			if isLvLight then
				isThereintoOne = true
			end
			meteorMagicCtrl = self.curProjectID
			self.curProjectID.id = v
			self.curProjectID.isLvLight = isLvLight
			table.insert(self.thNeeds, self.curProjectID)
		end
		local isBuildLv = buildLv >= needMagicCfg.needBuildLv
		self.isBuildLv = isBuildLv
		if isSpecifiedAll and isThereintoOne and isBuildLv then
			self.controllers.c1:setSelectedIndex(1)
		else
			self.controllers.c1:setSelectedIndex(0)
			self:setUnlockNeed(needMagicCfg.needBuildLv)
			self.isOneKey = true
		end
	end
	self.fields.btn:setTitle(i18n("common_text_055"))
	if self.isOneKey then
		self.fields.btn:setCostNum(0)
		self.fields.btn:setFreeTitle(i18n("meteoritesmagic_text_62"))
	else
		self.fields.btn:setCostNum(1, meteorMagicCtrl:getTalentNum() - self.projectData.costTalentNum, true)
	end
	self.fields.text_lv_cur:setString(i18n("common_text_279"))
	self.fields.text_des_cur:setTitle(meteorMagicRead.getDes(self.magicId))
	if self.showMagicCfg == nil and self.lv == 0 or meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100 == 1 then
		self.fields.text_lv_next:setVisible(false)
		self.fields.text_des_next:setVisible(false)
		if self.lv == 0 then
			self.fields.text_lv_cur:setString(i18n("alliance_beast_text_03"))
		end
		self.fields.text_des_cur:setSize(cc.size(315, 160))
	elseif self.showMagicCfg ~= nil then
		self.fields.text_lv_next:setString(i18n(self.lv == 0 and "alliance_beast_text_03" or "common_text_280"))
		self.fields.text_des_next:setTitle(meteorMagicRead.getDes(self.showMagicCfg.id))
		self.fields.text_des_cur:setSize(cc.size(315, 50))
	end
	local iconName = meteorMagicRead.getIcon(self.idGroup)
	local tmpFields = fguiHelper.get_fields(self.fields.talent)
	tmpFields.icon:setScale((iconName == "framer_yxmn_jnk_tb.png" or iconName == "framer_yxmn_bdmn_04.png") and 1 or 0.58)
	tmpFields.iconBg:setURL(meteorMagicRead.getIconBg(self.idGroup))
	self.fields.talent:setIcon(iconName)
	self.fields.talent:setTitle(self.lv .. "/" .. meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)
end
function MeteoriteDetailsPanel:setUnlockNeed(needBuildLv)
	self.unlockNeeds = #self.spNeeds > 0 and self.spNeeds or self.thNeeds
	if #self.spNeeds > 0 or self.unlockNeeds == 0 and self.isBuildLv then
		self.fields.text_title:setString(i18n("meteoritesmagic_text_22"))
	else
		self.fields.text_title:setString(i18n("meteoritesmagic_text_23"))
	end
	self.controllers.c1:setSelectedIndex(#self.unlockNeeds > 0 and 0 or 3)
	self.fields.build_need:setVisible(0 < needBuildLv)
	if 0 < needBuildLv then
		self:updateLockDetails(self.fields.build_need, i18n("buildDes_name_305"), needBuildLv, needBuildLv <= self.buildLv)
	end
	self.fields.scroll:setSize(cc.size(513, 37 * #self.unlockNeeds))
	self.fields.scroll:setNumItems(#self.unlockNeeds)
end
function MeteoriteDetailsPanel:onItemsRenderer(index, obj)
	local need = self.unlockNeeds[index + 1]
	local idGroup, lv = meteorMagicRead.getIdGroup(need.id)
	self:updateLockDetails(obj, i18n(meteorMagicRead.getName(idGroup)), lv, need.isLvLight, idGroup)
end
function MeteoriteDetailsPanel:updateLockDetails(obj, title, lv, isLight, idGroup)
	local fields = fguiHelper.get_fields(obj)
	local ctrls = fguiHelper.get_controllers(obj)
	ctrls.c1:setSelectedIndex(isLight and 1 or idGroup ~= nil and 2 or 0)
	fields.name:setString(title)
	_ENV = nil
	;(nil).level = lv
	fields.lv:setString(i18n("common_text_600", nil))
	if idGroup ~= nil and not isLight then
		fields.btn_go:setTitle(i18n("common_text_477"))
		if obj.clickHandler == nil then
			obj.clickHandler = handler(self, self.onGoClick)
			fields.btn_go:addClickEventListener(function()
				obj.clickHandler(idGroup)
			end)
		end
	end
end
function MeteoriteDetailsPanel:onGoClick(idGroup)
	SoraDPlaySound()
	local curProjectID = self.curProjectID
	self:close()
	_ENV = nil
	;(nil).idGroup = idGroup
	;(nil).curProjectID = curProjectID
	uiManager:show("MeteoriteDetails", nil)
	_ENV = uiManager
	uiManager.msg = "MESSAGE_UPDATE_METEOR_MAGIC_TALENTS_GO"
	uiManager.idGroup = idGroup
	SoraDSendMessage(uiManager)
end
function MeteoriteDetailsPanel:onClicked()
	SoraDPlaySound()
	if self.isOneKey then
		_ENV = nil
		;(nil).idGroup = self.idGroup
		;(nil).curProjectID = self.curProjectID
		uiManager:show("MeteoriteOnekeyUp", nil)
		self:close()
		return
	end
	if meteorMagicCtrl:getTalentNum() - self.projectData.costTalentNum <= 0 then
		SoraDShowMsgTip(i18n("meteoritesmagic_text_21"))
		return
	end
	local func = function()
		meteorMagicCtrl:openLight(self.curProjectID, self.idGroup)
		meteorMagicCtrl = self.curProjectID
		self.curProjectID.byUID = true
		if not SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", self.curProjectID) then
			meteorMagicCtrl = SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", self.curProjectID)
		end
		self.savedIdGroups = SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", self.curProjectID)
		if not self.savedIdGroups[tostring(self.curProjectID)] then
			self.savedIdGroups[tostring(self.curProjectID)], meteorMagicCtrl = self.curProjectID, self.curProjectID
		end
		self.savedIdGroups[tostring(self.curProjectID)][tostring(self.showMagicCfg.type)] = self.idGroup
		meteorMagicCtrl = self.idGroup
		self.idGroup.byUID = true
		SoraDConfigSet("Game:MeteoriteTalentsPanel:savedIdGroup~table", self.savedIdGroups, self.idGroup)
	end
	if meteorMagicCtrl:getIsActiveType(self.curProjectID, self.showMagicCfg.type) then
		func()
	else
		local dailyRemindManager = include("dailyRemindManager")
		if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.meteoriteActive) then
			_ENV = i18n("meteoritesmagic_text_21")
			i18n("meteoritesmagic_text_21").content = i18n("meteoritesmagic_text_59")
			i18n("meteoritesmagic_text_21").confirmFunc = function()
				func()
			end
			i18n("meteoritesmagic_text_21").remindString = i18n("coffeeCraftsman_text_27")
			i18n("meteoritesmagic_text_21").remindFunc = function(value)
				if value then
					dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.meteoriteActive)
				end
			end
			uiManager:show("MessageBox", i18n("meteoritesmagic_text_21"))
		else
			func()
		end
	end
end
return MeteoriteDetailsPanel
