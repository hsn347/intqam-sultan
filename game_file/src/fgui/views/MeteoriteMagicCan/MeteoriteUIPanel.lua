local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteUIPanel = class("MeteoriteUIPanel", baseFguiPanel)
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
local meteorMagicRead = include("meteorMagicRead")
local constantRead = include("constantRead")
function MeteoriteUIPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("MeteoriteUIPanel:ctor", self.viewName)
end
function MeteoriteUIPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteUIPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MeteoriteUIPanel:onInit")
	self.maxActiveNum = constantRead.getConstValue("MeteoritesMagic_Activate_Max") or 3
	self.activeItemID = constantRead.getConstValue("MeteoritesMagic_PlanChange_Item")
	self.resetItemID = constantRead.getConstValue("MeteoritesMagic_MagicReset_Item")
	self.fields.Com_title:initData(i18n("meteoritesmagic_text_1"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.button_reset:setTitle(i18n("common_text_4152"))
	self.fields.button_reset:addClickEventListener(handler(self, self.resetClick))
	self.fields.button_recount:setTitle(i18n("meteoritesmagic_text_29"))
	self.fields.button_recount:addClickEventListener(handler(self, self.recountClick))
	self.fields.button_active:addClickEventListener(handler(self, self.activeClick))
	self.fields.button_change:addClickEventListener(handler(self, self.changeClick))
	self.fields.button_strategy:setTitle(i18n("meteoritesmagic_text_44"))
	self.fields.button_strategy:addClickEventListener(handler(self, self.strategyClick))
	self.fields.btn_icon:addClickEventListener(handler(self, self.iconClick))
	self.fields.button_name:addClickEventListener(handler(self, self.onRenameClick))
	self.fields.scroll_menu:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.scroll_menu:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	meteorMagicCtrl:sendDataMsg()
end
function MeteoriteUIPanel:onShow()
	print("=======MeteoriteUIPanel:onShow")
	self.configs = meteorMagicRead.getMagicTrees()
	self.planConfigs = meteorMagicRead.getMagicPlans()
	for i = 1, 8 do
		local com_magic = self.fields["magic_" .. i]
		com_magic:setConfig(self.configs[i])
	end
	self.curProjectID = meteorMagicCtrl:getCurProjectID()
	self:updateView()
end
function MeteoriteUIPanel:updateView()
	self.ProjectData = meteorMagicCtrl:getProjectData(self.curProjectID)
	self.isActivie = meteorMagicCtrl:getProjectIsActive(self.curProjectID)
	for i = 1, 8 do
		local com_magic = self.fields["magic_" .. i]
		com_magic:setData(self.ProjectData, self.curProjectID)
	end
	if self.ProjectData.name == "" or self.ProjectData.name == tostring(self.curProjectID) or not self.ProjectData.name then
		meteorMagicCtrl = self.curProjectID
		self.curProjectID.num = self.curProjectID
		local projectName = i18n("meteoritesmagic_text_12", self.curProjectID)
	end
	self.fields.text_plan_title:setString(projectName)
	self.fields.button_active:setVisible(not self.isActivie)
	self.fields.button_active:setTitle(self.isActivie and i18n("privilege_text_130") or i18n("common_text_314"))
	if not self.isActivie then
		self.fields.button_active:setCost(self.activeItemID, 1, true)
	end
	self.fields.text_use:setVisible(false)
	for i = 1, 4 do
		self.fields["text_use_bg" .. i]:setVisible(false)
	end
	self.fields.button_reset:setEnabled(self.ProjectData.costTalentNum > 0)
	meteorMagicCtrl = self.fields["text_use_bg" .. i].setVisible
	self.fields["text_use_bg" .. i].setVisible.num = self.maxActiveNum
	self.fields.text_active_num:setString(i18n("meteoritesmagic_text_53", self.fields["text_use_bg" .. i].setVisible))
	self.fields.progress:setData(meteorMagicCtrl:getCurExp(), meteorMagicCtrl:getCurLv(), self.curProjectID)
	meteorMagicCtrl = self.curProjectID
	self.curProjectID.num = meteorMagicCtrl:getTalentNum() - self.ProjectData.costTalentNum
	self.fields.text_item_num:setString(i18n("meteoritesmagic_text_4", self.curProjectID))
	self.fields.text_use:setString(i18n("privilege_text_130"))
	local lvCfg, isMax = meteorMagicRead.getCurLvCfg(meteorMagicCtrl:getCurLv())
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	self.text_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("meteoritesmagic_text_55", nil)
	end)
	self.fields.text_time:beginTime(nebulaActivityCtrl:getStateBeginTime(NEBULA_REGION_STATE.SETTLE) - serviceFunctions.systemTime())
end
function MeteoriteUIPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("meteoritesmagic_text_2")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function MeteoriteUIPanel:activeClick()
	SoraDPlaySound()
	local publicRead = include("publicRead")
	local itemName = publicRead.getName(self.activeItemID)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemNum = backpackCtrl:getItemCount(self.activeItemID)
	if itemNum <= 0 then
		_ENV = nil
		;(nil).item = itemName
		SoraDShowMsgBoxNew(i18n("meteoritesmagic_text_56", nil), i18n("common_text_477"), nil, function(exitType, other)
			if exitType ~= MSGBOX_CALLBACK_YES then
				return
			end
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local curState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY)
			if curState == gActivityState.OPEN then
				uiManager:show("Shiftingstars")
				return
			end
			SoraDShowMsgTip(i18n("nebula_war_text_0175"))
			return
		end)
		return
	end
	_ENV = nil
	;(nil).itemID = self.activeItemID
	_ENV = nil
	;(nil).name = itemName
	;(nil).num = 1
	;(nil).tip = i18n("meteoritesmagic_text_5", nil)
	;(nil).callback = function()
		meteorMagicCtrl:changeProject(self.curProjectID)
	end
	uiManager:show("MeteoriteTips", nil)
end
function MeteoriteUIPanel:resetClick()
	SoraDPlaySound()
	local publicRead = include("publicRead")
	local itemName = publicRead.getName(self.resetItemID)
	_ENV = nil
	;(nil).itemID = self.resetItemID
	_ENV = nil
	;(nil).name = itemName
	;(nil).num = 1
	;(nil).tip = i18n("meteoritesmagic_text_27", nil)
	;(nil).callback = function()
		meteorMagicCtrl:closeLight(self.curProjectID)
	end
	uiManager:show("MeteoriteTips", nil)
end
function MeteoriteUIPanel:recountClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).curProjectID = self.curProjectID
	uiManager:show("MeteoriteRecount", nil)
end
function MeteoriteUIPanel:changeClick()
	SoraDPlaySound()
	if self.controllers.c2:getSelectedIndex() == 1 then
		self.controllers.c2:setSelectedIndex(0)
		return
	end
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	self.controllers.c2:setSelectedIndex(1)
	self.buildLv = cityCtrl:getBuildMaxLv(BUILDID.NEBULA_PALACE)
	self.fields.scroll_menu:setSize(cc.size(324, 50 * #self.planConfigs))
	self.fields.scroll_menu:setNumItems(#self.planConfigs)
end
function MeteoriteUIPanel:strategyClick()
	SoraDPlaySound()
	uiManager:show("MeteoriteStrategy")
end
function MeteoriteUIPanel:iconClick()
	SoraDPlaySound()
	_ENV = "item_des_1650"
	;("item_des_1650").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("item_des_1650"), "item_des_1650")
end
function MeteoriteUIPanel:changeProjectCallback(projectID)
	self.curProjectID = projectID
	self:updateView()
end
function MeteoriteUIPanel:onItemRenderer(index, obj)
	local panelIndex = index + 1
	obj:initData(self.planConfigs[index + 1], self.curProjectID == panelIndex, self.buildLv >= self.planConfigs[panelIndex].activateLv)
end
function MeteoriteUIPanel:onClickItem()
	SoraDPlaySound()
	local index = self.fields.scroll_menu:getSelectedIndex()
	local setID = index + 1
	if setID < 1 then
		error("setID < 1")
		return
	end
	if self.buildLv < self.planConfigs[index + 1].activateLv then
		_ENV = nil
		;(nil).name = i18n("buildDes_name_305")
		;(nil).lv = self.planConfigs[index + 1].activateLv
		SoraDShowMsgTip(i18n("meteoritesmagic_text_11", nil))
		self.fields.scroll_menu:setSelectedIndex(self.curProjectID - 1)
		return
	end
	self:changeProjectCallback(setID)
	self.controllers.c2:setSelectedIndex(0)
end
function MeteoriteUIPanel:onRenameClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.planConfigs[self.curProjectID].id
	;(nil).renameType = 5
	uiManager:show("lordEquipRename", nil)
end
return MeteoriteUIPanel
