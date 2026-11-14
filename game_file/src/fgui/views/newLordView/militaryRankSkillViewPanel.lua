local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local militaryRankCtrl = SoraDGetCtrl("militaryRankCtrl")
local militaryRankRead = include("militaryRankRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipDesRead = include("equipDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local militaryRankSkillViewPanel = class("militaryRankSkillViewPanel", baseFguiPanel)
function militaryRankSkillViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("militaryRankSkillViewPanel:ctor", self.viewName)
end
function militaryRankSkillViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function militaryRankSkillViewPanel:onInit()
	print("=======militaryRankSkillViewPanel:onInit")
	self.toolData, _ENV, self.skillData, _ENV, self.tab = print, print, print, print, 1
	self.fields.Com_title:initData(i18n("Military_btn_02"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
	self.fields.List_tool:setItemRenderer(handler(self, self.onToolRenderer))
end
function militaryRankSkillViewPanel:onShow()
	print("=======militaryRankSkillViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_val:setIcon("icon_military_point.png")
	self.isTool = self.param and self.param.isTool or false
	self.tab = self.isTool and 2 or 1
	_ENV = "icon_military_point.png"
	_ENV, _ENV, ("icon_military_point.png").defaultClick = nil, self.tab, self.tab
	;(nil).title = i18n("common_text_2401")
	_ENV, self.tab[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Military_btn_03")
	;("icon_military_point.png").tabsetArray, self.tab[2], (nil).tag = self.tab, nil, 2
	;("icon_military_point.png").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView("icon_military_point.png")
end
function militaryRankSkillViewPanel:onSkillRenderer(index, obj)
	obj:initData(self.skillData[index + 1])
end
function militaryRankSkillViewPanel:onToolRenderer(index, obj)
	obj:initData(self.toolData[index + 1])
end
function militaryRankSkillViewPanel:onClickTab(tag)
	self.tab = tag
	self.controllers.c1:setSelectedIndex(self.tab - 1)
	self:updateData()
end
function militaryRankSkillViewPanel:initSkill()
	self.skillData = militaryRankCtrl:getMilitarySkillData()
	table.sort(self.skillData, function(a, b)
		if a.isFull and b.isFull then
			return a.id < b.id
		elseif a.isFull and not b.isFull then
			return false
		elseif not a.isFull and b.isFull then
			return true
		else
			return a.id < b.id
		end
	end)
	self.fields.List_skill:setNumItems(#self.skillData)
end
function militaryRankSkillViewPanel:initShop()
	self.toolData = militaryRankCtrl:getMilitaryExchangeData()
	self.fields.List_tool:setNumItems(#self.toolData)
end
function militaryRankSkillViewPanel:updateData()
	if self.tab == 2 then
		self:initShop()
	else
		self:initSkill()
	end
	self.fields.Com_val:setTitle(i18n("common_text_2416") .. ":" .. string.formatnumberthousands(lordInfoCtrl:getLordInfo().militaryRankInfo.exploit))
end
function militaryRankSkillViewPanel:equipBack(target, data)
	if data.equip then
		_ENV = nil
		;(nil).singleData = data.equip
		uiManager:show("equipForgeSuccessView", nil)
	end
end
function militaryRankSkillViewPanel:onClickHelp()
	SoraDPlaySound()
	userSDKManager.showFAQSection(gSDKDef.FAQSectionType.MILITARY_RANK)
end
return militaryRankSkillViewPanel
