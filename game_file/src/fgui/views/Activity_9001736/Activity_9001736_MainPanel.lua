local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_MainPanel = class("Activity_9001736_MainPanel", baseFguiPanel)
function Activity_9001736_MainPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "Activity_9001738"
	return nil
end
function Activity_9001736_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_MainPanel.super.ctor(self, ...)
	print("Activity_9001736_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
	activity_9001736_Ctrl:reqEnterGame()
end
function Activity_9001736_MainPanel:onInit()
	print("=======Activity_9001736_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
end
function Activity_9001736_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("football_match_text_001")
	uiManager:show("RuleView", nil)
end
function Activity_9001736_MainPanel:endShow()
	print("=======Activity_9001736_MainPanel:endShow")
	_ENV = print
	_ENV, _ENV, print.defaultClick = nil, "=======Activity_9001736_MainPanel:endShow", 1
	_ENV, ("=======Activity_9001736_MainPanel:endShow")[1], (nil).title = nil, nil, i18n("football_match_text_002")
	_ENV, ("=======Activity_9001736_MainPanel:endShow")[2], (nil).title = nil, nil, i18n("football_match_text_003")
	print.tabsetArray, ("=======Activity_9001736_MainPanel:endShow")[3], (nil).title = "=======Activity_9001736_MainPanel:endShow", nil, i18n("football_match_text_004")
	local print.callback, param = handler(self, self.onClickTab), print
	self.fields.Com_title:initTab(param)
	self:updateAllTabRedDot()
	activity_9001736_Ctrl:sendReqInitDataMsg()
end
function Activity_9001736_MainPanel:onClickTab(tag)
	self.curTag = tag
	self.controllers.c_page:setSelectedIndex(self.curTag - 1)
	if self.curTag == 3 then
		self.fields.Com_pass:initData(self.activityID)
	end
end
function Activity_9001736_MainPanel:jumpToBattlePass()
	SoraDRemoveAllAfterPanelFromManager(self, true)
	self.fields.Com_title:setTabIndex(3, true)
end
function Activity_9001736_MainPanel:onMsgUpdateBattlePass(...)
	self:updateTabRedDot(3)
	self.fields.Com_pass:initData(self.activityID)
end
function Activity_9001736_MainPanel:updateAllTabRedDot()
	self:updateTabRedDot(1)
	self:updateTabRedDot(2)
	self:updateTabRedDot(3)
end
function Activity_9001736_MainPanel:updateTabRedDot(tag)
	local _isRed, _num = false
	if tag == 1 then
		_isRed, _num = activity_9001736_Ctrl:getSeedRedPointAndNum()
	elseif tag == 2 then
		_isRed, _num = activity_9001736_Ctrl:getMatchRedPointAndNum()
	elseif tag == 3 then
		_isRed, _num = activity_9001736_Ctrl:getBattlePassRedPointAndNum()
	end
	self.fields.Com_title:setBtnRedDot(tag, _isRed, _num)
end
function Activity_9001736_MainPanel:onMsgUpdateItemCount(...)
	self:updateTabRedDot(1)
	self.fields.Com_9001736_Seed:updateBtnGetSeedRedDot()
end
function Activity_9001736_MainPanel:onMsgUpdateQuest(...)
	self:updateTabRedDot(1)
	self.fields.Com_9001736_Seed:updateBtnTaskRedDot()
end
function Activity_9001736_MainPanel:onMsgUpdateBattleBack(...)
	self:updateTabRedDot(2)
end
function Activity_9001736_MainPanel:updateDoStage()
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if self.doStage == doStage then
		return
	end
	self.doStage = doStage
	self.fields.Com_title:updateActivityTime()
	self:onMsgUpdateData()
end
function Activity_9001736_MainPanel:onMsgUpdateData()
	self:updateAllTabRedDot()
	self.fields.Com_9001736_Match:updateData()
	self.fields.Com_pass:initData(self.activityID)
end
function Activity_9001736_MainPanel:onMsgExchangeMallRefresh()
	self:updateTabRedDot(1)
	self.fields.Com_9001736_Seed:updateBtnExchangeRedDot()
end
return Activity_9001736_MainPanel
