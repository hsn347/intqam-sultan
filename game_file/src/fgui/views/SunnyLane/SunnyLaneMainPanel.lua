local baseFguiPanel = require("fgui.base.baseFguiPanel")
local monsterInvasionCtrl = SoraDGetCtrl("monsterInvasionCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local SunnyLaneMainPanel = class("SunnyLaneMainPanel", baseFguiPanel)
local NEED_NUM = 1
function SunnyLaneMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SunnyLaneMainPanel:ctor", self.viewName)
	self.debug = true
	self.itemID = 860201
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.MONSTER_INVASION_ACTIVITY
end
function SunnyLaneMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SunnyLaneMainPanel:onInit()
	print("=======SunnyLaneMainPanel:onInit")
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.Com_title:initData(i18n("activity_name_9001481"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.btn_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.btn_reward:addClickEventListener(handler(self, self.onRewardClick), 1)
	self.fields.btn_rank:setTitle(i18n("common_text_851"))
	self.fields.btn_rank:addClickEventListener(handler(self, self.onRankClick), 1)
	self.fields.button_go:setTitle(i18n("arena_btn_04"))
	self.fields.button_go:addClickEventListener(handler(self, self.onGoClick), 1)
	self.fields.button_call:setTitle(i18n("common_text_2341"))
	self.fields.button_call:addClickEventListener(handler(self, self.onCallClick), 1)
	self.fields.text_Tips:setString(i18n("MonsterInvade_08"))
	monsterInvasionCtrl:sendInitMsg()
	self.fields.label_timer:setTimeEndListener(handler(self, self.updateView))
	self.fields.label_timer:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("lost_ruins_text_21", nil)
	end)
end
function SunnyLaneMainPanel:onShow()
	print("=======SunnyLaneMainPanel:onShow")
	self.fields.Usm_1:setScale(self.fields.n11:getSize().width / 640)
	self:updateView()
end
function SunnyLaneMainPanel:updateView()
	self.bossX, self.bossY = monsterInvasionCtrl:getBossPosition()
	self.bossCreateTime = monsterInvasionCtrl:getBossCreateTime() or 0
	self.lastTime = self.bossCreateTime + 3600 - serviceFunctions.systemTime()
	self.controllers.c1:setSelectedIndex(0 >= self.lastTime and 0 or 1)
	if 0 >= self.lastTime then
		self.fields.icon:setURL(publicRead.getIcon(self.itemID))
		self:updateItemCount()
	else
		self.fields.label_timer:beginTime(self.lastTime)
	end
end
function SunnyLaneMainPanel:updateItemCount()
	local itemHave = backpackCtrl:getItemCount(self.itemID)
	self.itemHave = itemHave
	if self.lastTime and self.lastTime > 0 then
		return
	end
	local color = itemHave >= NEED_NUM and "#FFFFFF" or "#FE0101"
	backpackCtrl = nil
	;(nil).num1 = itemHave
	backpackCtrl, backpackCtrl, (nil).num2 = nil, NEED_NUM, NEED_NUM
	NEED_NUM.num1, (nil).color = nil, color
	self.fields.text_item:setString(i18n_html("MonsterInvade_02", nil, NEED_NUM))
end
function SunnyLaneMainPanel:onCallClick()
	SoraDPlaySound()
	local itemHave = backpackCtrl:getItemCount(self.itemID)
	self.itemHave = itemHave
	if itemHave < NEED_NUM then
		local ret = gModuleMgr.sharedMgr("shopltCtrl"):getQuickShopItemArrayByItemID(self.itemID)[1]
		_ENV = nil
		_ENV, (nil).itemData = nil, ret
		;(nil).curValue = 1
		;(nil).otherData, (nil).maxCount = nil, 999
		uiManager:show("newShopSingleBuy", nil)
		return
	end
	monsterInvasionCtrl:reqMonsterInvasionSumon()
end
function SunnyLaneMainPanel:onGoClick()
	SoraDPlaySound()
	if self.bossX ~= nil and self.bossY ~= nil then
		SoraDGotoWorldMapPoint(cc.p(self.bossX, self.bossY), true)
	else
		SoraDGotoWorldMapPoint()
	end
	SoraDRemoveAllPanelFromManager()
end
function SunnyLaneMainPanel:onRewardClick()
	SoraDPlaySound()
	uiManager:show("SunnyLanePopup"):setOwnerKey(self)
end
function SunnyLaneMainPanel:onRankClick()
	SoraDPlaySound()
	uiManager:show("SunnyLaneRank"):setOwnerKey(self)
end
function SunnyLaneMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("MonsterInvade_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return SunnyLaneMainPanel
