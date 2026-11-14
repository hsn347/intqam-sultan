local activity_9001700_Read = include("activity_9001700_Read")
local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001700_MakePanel = class("Activity_9001700_MakePanel", baseFguiPanel)
local string_fnt = string.formatnumberthousands
function Activity_9001700_MakePanel:ctor(...)
	self.isLRU = true
	Activity_9001700_MakePanel.super.ctor(self, ...)
	print("Activity_9001700_MakePanel:ctor", self.viewName)
end
function Activity_9001700_MakePanel:onInit()
	print("=======Activity_9001700_MakePanel:onInit")
	self.fields.List_need:setItemRenderer(handler(self, self.onItemNeedRenderer))
	self.fields.Label_select1:setString(i18n("eid_fireworks_022"))
	self.fields.Label_select2:setString(i18n("eid_fireworks_023"))
	self.fields.Label_select3:setString(i18n("eid_fireworks_024"))
	self.fields.List_select1:setItemRenderer(handlerEx(self, self.onItemRenderer, 1))
	self.fields.List_select2:setItemRenderer(handlerEx(self, self.onItemRenderer, 2))
	self.fields.List_select3:setItemRenderer(handlerEx(self, self.onItemRenderer, 3))
	self.fields.List_select1:addEventListener(fgui.UIEventType.ClickItem, handlerEx(self, self.onClickItem, 1))
	self.fields.List_select2:addEventListener(fgui.UIEventType.ClickItem, handlerEx(self, self.onClickItem, 2))
	self.fields.List_select3:addEventListener(fgui.UIEventType.ClickItem, handlerEx(self, self.onClickItem, 3))
	self.fields.Text_reward:setString(i18n("eid_fireworks_025"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRewardRenderer))
	self.fields.Button_make:setString(i18n("common_btn_20"))
	self.fields.Button_make:addClickListener(handler(self, self.onClickBtnMake))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickClose))
end
function Activity_9001700_MakePanel:endShow()
	print("=======Activity_9001700_MakePanel:endShow")
	_ENV, self.fireType = self.param and self.param.fireType or 1, self.param and self.param.fireType or 1
	;(self.param and self.param.fireType or 1)[1] = i18n("eid_fireworks_006")
	local (self.param and self.param.fireType or 1)[2], itemNameConfig = i18n("eid_fireworks_005"), self.param and self.param.fireType or 1
	local itemName = itemNameConfig[self.fireType] or ""
	_ENV = nil
	;(nil).item = itemName
	local titleStr = i18n("eid_fireworks_020", nil)
	self.fields.Panel_bg:setString(titleStr)
	local config1 = activity_9001700_Read.getFireworksShowConfig(self.fireType, 1)
	self.fields.List_select1:setNumItems(#config1)
	local config2 = activity_9001700_Read.getFireworksShowConfig(self.fireType, 2)
	self.fields.List_select2:setNumItems(#config2)
	local config3 = activity_9001700_Read.getFireworksShowConfig(self.fireType, 3)
	self.fields.List_select3:setNumItems(#config3)
	local select1, select2, select3 = 1, 1, 1
	self.fields.List_select1:setSelectedIndex(select1 - 1)
	self.fields.List_select2:setSelectedIndex(select2 - 1)
	self.fields.List_select3:setSelectedIndex(select3 - 1)
	self.fields.Com_firework:initData(self.fireType, select1, select2, select3)
	self:updateFireWorksID()
end
function Activity_9001700_MakePanel:updateFireWorksID(...)
	local select1 = self.fields.List_select1:getSelectedIndex() + 1
	local select2 = self.fields.List_select2:getSelectedIndex() + 1
	local select3 = self.fields.List_select3:getSelectedIndex() + 1
	self.fireWorksID = activity_9001700_Read.getFireWorksID(self.fireType, select1, select2, select3)
	self.isMaterialEnough = true
	self.materialList = activity_9001700_Read.getFireWorksMaterial(self.fireWorksID)
	self.fields.List_need:setNumItems(#self.materialList)
	self.rewardList = activity_9001700_Read.getFireWorksReward(self.fireWorksID)
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function Activity_9001700_MakePanel:onItemNeedRenderer(index, obj)
	local material = self.materialList[index + 1]
	local resNeed = material.count
	obj:initData(material.id)
	local resCount = activity_9001700_Ctrl:getResCount(material.id)
	activity_9001700_Ctrl = nil
	;(nil).member = string_fnt(resNeed)
	;(nil).total = string_fnt(resCount)
	local str = i18n("common_text_155", nil)
	local title = obj:getChild("title")
	title:setString(str)
	if resNeed > resCount then
		title:setColor(display.COLOR_RED)
		self.isMaterialEnough = false
	else
		title:setColor(cc.c3b(255, 200, 100))
	end
	obj:hideBtnAdd()
end
function Activity_9001700_MakePanel:onItemRenderer(selectType, index, obj)
	local resource = activity_9001700_Read.getFireworkResource(self.fireType, selectType, index + 1)
	obj:setIcon(resource)
end
function Activity_9001700_MakePanel:onClickItem(selectType, EventContext)
	SoraDPlaySound()
	local List_select = self.fields["List_select" .. selectType]
	local index = List_select:getSelectedIndex()
	self.fields.Com_firework:updateSelect(selectType, index + 1)
	self:updateFireWorksID()
end
function Activity_9001700_MakePanel:onItemRewardRenderer(index, obj)
	local reward = self.rewardList[index + 1]
	obj:initData(reward.id, reward.count)
end
function Activity_9001700_MakePanel:onClickBtnMake(...)
	SoraDPlaySound()
	if not self.isMaterialEnough then
		SoraDShowMsgTip(i18n("Tycoon_text_14"))
		return
	end
	local dailyRemindManager = include("dailyRemindManager")
	local rType = dailyRemindManager.REMIND_TYPE.activity_9001770_1
	if dailyRemindManager.checkNeedRemind(rType) then
		_ENV = i18n("Tycoon_text_14")
		i18n("Tycoon_text_14").isMake = true
		i18n("Tycoon_text_14").fireWorksID = self.fireWorksID
		i18n("Tycoon_text_14").parentPanel = self
		uiManager:show("Activity_9001700_Sure", i18n("Tycoon_text_14"))
	else
		activity_9001700_Ctrl:reqMake(self.fireWorksID)
		SoraDShowLoading(self)
	end
end
function Activity_9001700_MakePanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "make" then
		self:closePanel()
	end
end
function Activity_9001700_MakePanel:onHide(...)
	SoraDCloseLoading(self)
end
return Activity_9001700_MakePanel
