local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteTalentsPanel = class("MeteoriteTalentsPanel", baseFguiPanel)
local meteorMagicRead = include("meteorMagicRead")
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
function MeteoriteTalentsPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("MeteoriteTalentsPanel:ctor", self.viewName)
end
function MeteoriteTalentsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteTalentsPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MeteoriteTalentsPanel:onInit")
	local constantRead = include("constantRead")
	self.activeItemID = constantRead.getConstValue("MeteoritesMagic_NebulaChange_Item")
	self.maxActiveNum = constantRead.getConstValue("MeteoritesMagic_Activate_Max")
	self.fields.btn:addClickEventListener(handler(self, self.onBtnClick))
	self.fields.btn_icon:addClickEventListener(handler(self, self.iconClick))
	_ENV = handler(self, self.iconClick)
	handler(self, self.iconClick).num = self.maxActiveNum
	self.fields.text_tip1:setString(i18n("meteoritesmagic_text_53", handler(self, self.iconClick)))
	self.fields.text_tip2:setString(i18n("meteoritesmagic_text_58"))
	_ENV = i18n("meteoritesmagic_text_58")
	i18n("meteoritesmagic_text_58").num = self.maxActiveNum
	self.fields.text_tip3:setString(i18n("meteoritesmagic_text_57", i18n("meteoritesmagic_text_58")))
end
function MeteoriteTalentsPanel:onShow()
	self.config = self.param.config
	self.configs, _ENV, self.curProjectID = self.param.curProjectID, self.param.curProjectID, self.param.curProjectID
	for i, v in ipairs(self.config.idGroup) do
		table.insert(self.configs, meteorMagicRead.getMagicInfo(v))
	end
	_ENV = ipairs(self.config.idGroup)
	ipairs(self.config.idGroup).byUID = true
	if not SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", ipairs(self.config.idGroup)) then
		_ENV = SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", ipairs(self.config.idGroup))
	end
	self.savedIdGroups = SoraDConfigGet("Game:MeteoriteTalentsPanel:savedIdGroup~table", ipairs(self.config.idGroup))
	self.jumpIdGroup = self.param.idGroup and self.param.idGroup or self.savedIdGroups[tostring(self.curProjectID)] and self.savedIdGroups[tostring(self.curProjectID)][tostring(self.config.type)] and self.savedIdGroups[tostring(self.curProjectID)][tostring(self.config.type)] or self.config.idGroup[1]
	self.fields.Com_title:initData(i18n(self.config.name), handler(self, self.onClickClose))
	local scrollName = "ui://MeteoriteMagicCan/com_Meteorite_talentTree" .. self.config.type
	self.viewSize = self.fields.scroll:getSize()
	self.fields.scroll:setURL(scrollName)
	self.talentTree = self.fields.scroll:getComponent()
	if self.talentTree == nil then
		return
	end
	self.talentTree:initData(self.config, self.curProjectID, self)
	self.talentTree:setSize(self.viewSize.width, self.viewSize.height)
	_ENV = self.viewSize.width
	self.viewSize.width.scroll = self.talentTree
	self.viewSize.width.innerSize = cc.size(852, 1386)
	self.viewSize.width.minScale = 1.0
	self.viewSize.width.maxScale = 2.5
	self.viewSize.width.zoomScale = 2.5
	function self.viewSize.width.afterInitScroll()
		self:updateView()
		local obj = self.talentTree:getObjByIdGroup(self.jumpIdGroup)
		self:scrollToCenter(obj)
	end
	self.fields.scroll_zoom:initData(self.viewSize.width)
end
function MeteoriteTalentsPanel:scrollToCenter(obj, ani)
	local scale = self.fields.scroll_zoom:getZoomScale()
	local scrollPane = self.talentTree:getScrollPane()
	local objW = obj:getContentSize().width * obj:getScale()
	local posX = (obj:getX() + objW / 2) * scale - self.viewSize.width / 2
	scrollPane:setPosX(posX, ani)
	local objH = obj:getContentSize().height * obj:getScale()
	local posY = (obj:getY() + objH / 2) * scale - self.viewSize.height / 2
	scrollPane:setPosY(posY, ani)
end
function MeteoriteTalentsPanel:updateView()
	self:updateTalentTree()
	self:updateMsg()
end
function MeteoriteTalentsPanel:updateMsg()
	self.isActiveType = meteorMagicCtrl:getIsActiveType(self.curProjectID, self.config.type)
	self.projectData = meteorMagicCtrl:getProjectData(self.curProjectID)
	if self.isActiveType then
		self.fields.btn.controllers.c1:setSelectedIndex(2)
		self.fields.btn:setCost(self.activeItemID, 1, true)
		self.fields.btn:setTitle(i18n("meteoritesmagic_text_16"))
	else
		self.fields.btn.controllers.c1:setSelectedIndex(1)
		self.fields.btn:setCostNum(0)
		self.fields.btn:setFreeTitle(i18n("common_btn_05"))
	end
	local activeNum = meteorMagicCtrl:getActiveTypeNum(self.curProjectID, self.config.type)
	self.fields.btn:setVisible(activeNum < self.maxActiveNum or self.isActiveType)
	self.fields.text_tip3:setVisible(not self.fields.btn:isVisible())
	self.fields.btn:setTitle(self.isActiveType and i18n("meteoritesmagic_text_16") or i18n("common_btn_05"))
	meteorMagicCtrl = i18n("common_btn_05")
	i18n("common_btn_05").num = meteorMagicCtrl:getTalentNum() - self.projectData.costTalentNum
	self.fields.text_num:setString(i18n("meteoritesmagic_text_4", i18n("common_btn_05")))
end
function MeteoriteTalentsPanel:updateTalentTree()
	if self.talentTree == nil then
		return
	end
	self.talentTree:updateView()
end
function MeteoriteTalentsPanel:onBtnClick()
	local publicRead = include("publicRead")
	local itemName = publicRead.getName(self.activeItemID)
	local activeNum = meteorMagicCtrl:getActiveTypeNum(self.curProjectID, self.config.type)
	if not self.isActiveType then
		if activeNum >= self.maxActiveNum then
			SoraDShowMsgTip(i18n("meteoritesmagic_text_17"))
			return
		end
		_ENV = i18n("meteoritesmagic_text_17")
		i18n("meteoritesmagic_text_17").name = itemName
		i18n("meteoritesmagic_text_17").num = self.maxActiveNum - activeNum
		local tip = i18n("meteoritesmagic_text_18", i18n("meteoritesmagic_text_17"))
		SoraDShowMsgBoxNew(tip, i18n("common_text_204"), nil, function(exitType, other)
			if exitType ~= MSGBOX_CALLBACK_YES then
				return
			end
			meteorMagicCtrl:openActive(self.curProjectID, self.config.type)
		end)
	else
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemNum = backpackCtrl:getItemCount(self.activeItemID)
		if itemNum <= 0 then
			function _ENV(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				meteorMagicCtrl:openActive(self.curProjectID, self.config.type)
			end
			;(function(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				meteorMagicCtrl:openActive(self.curProjectID, self.config.type)
			end).item = itemName
			SoraDShowMsgBoxNew(i18n("meteoritesmagic_text_56", function(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				meteorMagicCtrl:openActive(self.curProjectID, self.config.type)
			end), i18n("common_text_477"), nil, function(exitType, other)
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
		_ENV = i18n("meteoritesmagic_text_17")
		i18n("meteoritesmagic_text_17").name = itemName
		i18n("meteoritesmagic_text_17").num = 1
		;(nil).tip = i18n("meteoritesmagic_text_25", i18n("meteoritesmagic_text_17"))
		;(nil).callback = function()
			meteorMagicCtrl:closeActive(self.curProjectID, self.config.type)
		end
		uiManager:show("MeteoriteTips", nil)
	end
end
function MeteoriteTalentsPanel:iconClick()
	SoraDPlaySound()
	_ENV = "item_des_1650"
	;("item_des_1650").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("item_des_1650"), "item_des_1650")
end
return MeteoriteTalentsPanel
