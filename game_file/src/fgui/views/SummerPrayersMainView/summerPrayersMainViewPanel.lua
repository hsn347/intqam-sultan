local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local summerPrayCtrl = SoraDGetCtrl("summerPrayCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local summerPrayersMainViewPanel = class("summerPrayersMainViewPanel", baseFguiPanel)
_ENV = "summerPrayersMainViewPanel"
;("summerPrayersMainViewPanel").EXCHANGE = 2
local ("summerPrayersMainViewPanel").PRAYERS, VIEW_TYPE = 1, "summerPrayersMainViewPanel"
function summerPrayersMainViewPanel:ctor(...)
	summerPrayersMainViewPanel.super.ctor(self, ...)
	print("summerPrayersMainViewPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
end
function summerPrayersMainViewPanel:onInit()
	print("=======summerPrayersMainViewPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.nodeSummerPrayersNode = self.fields.CCS_summerPrayersNode
	self.nodeSummerPrayersExchangeNode = self.fields.CCS_summerPrayersExchangeNode
	_ENV, _ENV, self.nodeCommonTabBtn = self.fields.Com_title, self.fields.com_Tab, self.fields.com_Tab
	self.fields.Com_title.title = i18n("lucky_btn_01")
	self.fields.Com_title.tag = VIEW_TYPE.PRAYERS
	_ENV, self.fields.com_Tab[1], self.fields.Com_title.fontSize = self.fields.Com_title, self.fields.Com_title, 20
	self.fields.Com_title.title = i18n("common_text_1889")
	self.fields.Com_title.tag = VIEW_TYPE.EXCHANGE
	self.tableData, self.fields.com_Tab[2], self.fields.Com_title.fontSize = self.fields.com_Tab, self.fields.Com_title, 20
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	_ENV = activityShowCtrl
	activityShowCtrl.defaultClick = (activityData.doStage or 0) + 1
	activityShowCtrl.tabsetArray = self.tableData
	local activityShowCtrl.callback, param = handler(self, self.btnTabClick), activityShowCtrl
	self.nodeCommonTabBtn:initView(param)
	self:updataRedPoint()
end
function summerPrayersMainViewPanel:onShow()
	print("=======summerPrayersMainViewPanel:onShow")
	self.nodeSummerPrayersNode:getEffectNode():setVisible(false)
	if _G.SoraDIsFileExistByKey("summerPrayFA") then
		_ENV, _UPVALUE1_ = "summerPrayFA", _G.SoraDIsFileExistByKey("summerPrayFA")
		;("summerPrayFA").name = "Common/summerPrayFA"
		local _G.SoraDIsFileExistByKey("summerPrayFA")[1], imgArray = "summerPrayFA", _G.SoraDIsFileExistByKey("summerPrayFA")
		self.proxy:loadImages(imgArray, function(...)
			if tolua.isnull(self) then
				return
			end
			self.nodeSummerPrayersNode:getEffectNode():setVisible(true)
		end)
	end
end
function summerPrayersMainViewPanel:initData(target, data)
end
function summerPrayersMainViewPanel:updataRedPoint()
	local retExchange = summerPrayCtrl:getExchangeRed()
	local retLuckyNum = summerPrayCtrl:getPrayRed()
	self.nodeCommonTabBtn:setBtnRedDot(VIEW_TYPE.EXCHANGE, retExchange)
	self.nodeCommonTabBtn:setBtnRedDot(VIEW_TYPE.PRAYERS, retLuckyNum)
end
function summerPrayersMainViewPanel:btnHelpClick()
	SoraDPlaySound()
	local summerPrayRead = include("summerPrayRead")
	local msgKey = summerPrayRead.getFAQKey()
	_ENV = nil
	;(nil).title = i18n("common_text_1173")
	;(nil).closeBtn = true
	;(nil).align = SoraDFLabelR()
	SoraDShowHelpMsgTip(msgKey, nil)
end
function summerPrayersMainViewPanel:btnTabClick(tag, name)
	self.nodeSummerPrayersNode:setVisible(tag == 1)
	self.nodeSummerPrayersExchangeNode:setVisible(tag == 2)
end
function summerPrayersMainViewPanel:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return summerPrayersMainViewPanel
