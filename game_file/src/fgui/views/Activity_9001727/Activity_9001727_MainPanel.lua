local activity_9001727_Read = include("activity_9001727_Read")
local activity_9001727_Ctrl = SoraDGetCtrl("activity_9001727_Ctrl")
local divineBeastRead = include("divineBeastRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001727_MainPanel = class("Activity_9001727_MainPanel", baseFguiPanel)
function Activity_9001727_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001727_MainPanel.super.ctor(self, ...)
	print("Activity_9001727_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ALBARQ_DECREE_ACTIVITY
end
function Activity_9001727_MainPanel:onInit()
	print("=======Activity_9001727_MainPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.itemRenderer_List_task))
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_buff:setTitle(i18n("Battle_Towers_23"))
	self.fields.Button_buff:addClickListener(handler(self, self.onClick_Button_buff))
	self.fields.Button_active:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_active:addClickListener(handler(self, self.onClick_Button_active))
	self.fields.Button_claim:setTitle(i18n("summoned_btn_01"))
	self.fields.Button_claim:addClickListener(handler(self, self.onClick_Button_claim))
	self.fields.Text_normal:setString(i18n("cityUp_title_03"))
	self.fields.Text_adv:setString(i18n("StarlitNight_text_07"))
	self.fields.Lab_tip:setString(i18n("Braque_text_08"))
	self.fields.Lab_tip:setVisible(false)
end
function Activity_9001727_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("AlbarqDecree_text_05")
	uiManager:show("RuleView", nil)
end
function Activity_9001727_MainPanel:endShow()
	print("=======Activity_9001727_MainPanel:endShow")
	self.usmData = divineBeastRead.getUsmData(gBestID.ONE)
	self.starLv = 3
	self.usmFileData = self.usmData.star[self.starLv] or self.usmData.star.default
	self.fields.bg:setURL(self.usmFileData.bg)
	self.rewards = activity_9001727_Read.getReward()
	self.tag = 1
	_ENV = self.usmFileData.bg
	_ENV, _ENV, self.usmFileData.bg.defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("AlbarqDecree_text_02")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("AlbarqDecree_text_03")
	self.usmFileData.bg.tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	self.usmFileData.bg.callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(self.usmFileData.bg)
end
function Activity_9001727_MainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.fields.Com_title:setTimeShow(self.tag == 2)
	self:initView()
	if self.tag == 1 then
		self.fields.Usm:setEffectPath(self.usmFileData.daiji)
		self.fields.Com_title:initCommonActivityTime(self.activityID)
		self.fields.List:jumpToTop()
	else
		self.fields.List_task:jumpToTop()
	end
end
function Activity_9001727_MainPanel:initView()
	SoraDCloseLoading(self)
	if self.tag == 1 then
		self.fields.List:setNumItems(#self.rewards)
		self.fields.Bar:initData()
		local isUnlockAdv = activity_9001727_Ctrl:isAdvUnlock()
		self.fields.Lab_tip:setVisible(isUnlockAdv)
		self.fields.Button_active:setVisible(not isUnlockAdv)
		local crescentNum = activity_9001727_Ctrl:getCrescentNum()
		self.fields.Button_claim:setEnabled(0 < crescentNum)
		self.fields.Button_claim:setReddot(0 < crescentNum)
	else
		self.taskData = activity_9001727_Ctrl:getTaskList()
		self.fields.List_task:setNumItems(#self.taskData)
	end
	local crescentNum = activity_9001727_Ctrl:getCrescentNum()
	self.fields.Com_title:setBtnRedDot(1, 0 < crescentNum)
	local questNum = activity_9001727_Ctrl:getQuestNum()
	self.fields.Com_title:setBtnRedDot(2, 0 < questNum, questNum)
end
function Activity_9001727_MainPanel:itemRenderer_List(index, obj)
	obj:initData(self.rewards[index + 1])
end
function Activity_9001727_MainPanel:itemRenderer_List_task(index, obj)
	obj:initData(self.taskData[index + 1])
end
function Activity_9001727_MainPanel:onClick_Button_buff(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001727_Buff")
end
function Activity_9001727_MainPanel:onClick_Button_active(context)
	SoraDPlaySound()
	local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
	local step = divineBeastCtrl:getStepLv(gBestID.ONE)
	if step >= include("divineBeastRead").getMaxStepLv(gBestID.ONE) then
		_ENV = nil
		;(nil).content = i18n("common_text_4951")
		;(nil).confirmFunc = function()
			uiManager:show("Activity_9001727_BuyGift")
		end
		;(nil).cancel = true
		uiManager:show("MessageBox", nil)
	else
		uiManager:show("Activity_9001727_BuyGift")
	end
end
function Activity_9001727_MainPanel:onClick_Button_claim(context)
	SoraDPlaySound()
	SoraDShowLoading(self)
	activity_9001727_Ctrl:reqGetReward()
end
return Activity_9001727_MainPanel
