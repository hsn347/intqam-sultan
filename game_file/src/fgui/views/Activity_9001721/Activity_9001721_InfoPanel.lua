local activity_9001721_Read = include("activity_9001721_Read")
local activity_9001721_Ctrl = SoraDGetCtrl("activity_9001721_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001721_InfoPanel = class("Activity_9001721_InfoPanel", baseFguiPanel)
function Activity_9001721_InfoPanel:ctor(...)
	self.isLRU = true
	Activity_9001721_InfoPanel.super.ctor(self, ...)
	print("Activity_9001721_InfoPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001721
	self.itemID = activity_9001721_Read.getItemID()
	self.itemCount = activity_9001721_Read.getItemCount()
end
function Activity_9001721_InfoPanel:onInit()
	print("=======Activity_9001721_InfoPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_attack:setTitle(i18n("worldboss_monkey_12"))
	self.fields.Button_attack:addClickListener(handler(self, self.onClick_Button_attack))
	self.fields.Text_monterName:setString(i18n("worldboss_monkey_08"))
	self.fields.Text_drop:setString(i18n("worldboss_monkey_05"))
	self.fields.Text_tip:setString(i18n("worldboss_monkey_11"))
	self.fields.Text_talk:setString(i18n("worldboss_monkey_15"))
	self.fields.Text_leftCount:setAlign(2)
	self.fields.Button_go:setTitle(i18n("worldboss_monkey_04"))
	self.fields.Button_go:addClickListener(handler(self, self.onClick_Button_go))
	self.fields.Bar:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Activity_9001721_InfoPanel:endShow()
	print("=======Activity_9001721_InfoPanel:endShow")
	self.instanceID = self.param.instanceID
	local isAlive = activity_9001721_Ctrl:isBossAlive()
	self.controllers.c1:setSelectedIndex(isAlive and 1 or 0)
	if isAlive then
		_ENV = nil
		;(nil).num = activity_9001721_Ctrl:getBossLeftAttackNum()
		self.fields.Text_leftCount:setString(i18n("worldboss_monkey_10", nil))
		local leftLife = SoraDPreciseDecimal(activity_9001721_Ctrl:getBossLeftLife(), 1)
		_ENV = i18n("worldboss_monkey_10", nil)
		i18n("worldboss_monkey_10", nil).num = isAlive and leftLife .. "%" or "100%"
		self.fields.Text_blood:setString(i18n("worldboss_monkey_09", i18n("worldboss_monkey_10", nil)))
		self.fields.Bar:setValue(isAlive and leftLife or 100)
	else
		self.point = activity_9001721_Ctrl:getPoint()
		self.fields.Button_go:setCostIcon(self.itemID)
		self.fields.Button_go:setCostNum(self.itemCount)
		self.fields.Button_go:setIsEnough(self.point >= self.itemCount)
	end
	self.ListData = activity_9001721_Read.getVictoryRewards()
	self.fields.List:setNumItems(#self.ListData)
end
function Activity_9001721_InfoPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001721_InfoPanel:onClick_Button_attack(context)
	SoraDPlaySound()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local hasMyQueue = kingdomMapCtrl:hasMyQueue(_G.gMapMoveLineServerType.captureMonkey)
	if hasMyQueue then
		SoraDShowMsgTip(i18n("worldboss_monkey_14"))
		return
	end
	local dispatchPanel = uiManager:show("WorldDispatchArmyView")
	local pos = activity_9001721_Ctrl:getBossPos()
	_ENV = i18n("worldboss_monkey_14")
	i18n("worldboss_monkey_14").toPoint = include("mapSyncUtilClient").serverTOClientPos(pos)
	i18n("worldboss_monkey_14").dispatchType = worldMapDefine.worldMapTipButtonType_gongJi
	i18n("worldboss_monkey_14").instanceID = self.instanceID
	i18n("worldboss_monkey_14").instanceType = gMapObjTypeDef.captureMonkey
	i18n("worldboss_monkey_14").bossType = gBossType.monkeyBoss
	dispatchPanel:initData(i18n("worldboss_monkey_14"))
	self:close()
end
function Activity_9001721_InfoPanel:onClick_Button_go()
	SoraDPlaySound()
	if self.point < self.itemCount then
		SoraDShowMsgTip(i18n("worldboss_monkey_06"))
		return
	end
	if lordInfoCtrl:getSourceKid() > 0 then
		SoraDShowMsgTip(i18n("worldboss_monkey_19"))
		return
	end
	activity_9001721_Ctrl:reqCaptureMonkeyCreate()
	self:close()
end
return Activity_9001721_InfoPanel
