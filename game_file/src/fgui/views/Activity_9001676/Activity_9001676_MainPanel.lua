local gametop = gModuleMgr.getObject("gametop")
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001676_MainPanel = class("Activity_9001676_MainPanel", baseFguiPanel)
_ENV = "Activity_9001676_MainPanel"
;("Activity_9001676_MainPanel").SINGLE_ONE = 1
;("Activity_9001676_MainPanel").SINGLE_FIVE = 5
;("Activity_9001676_MainPanel").MATCH = 2
local ("Activity_9001676_MainPanel").ROOM, PLAY_MODE = 3, "Activity_9001676_MainPanel"
function Activity_9001676_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001676_MainPanel.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001676
end
function Activity_9001676_MainPanel:onInit()
	print("=======Activity_9001676_MainPanel:onInit")
	self.view:fixChildrenPos()
	self.fields.Com_title:initData(i18n("krone_text_01"), handler(self, self.onBackClick), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.currentIndex = 1
	_ENV, _ENV, _ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("krone_text_01")
	_ENV, handler(self, self.onBackClick)[1], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("krone_text_48")
	self.activityID.tabsetArray, handler(self, self.onBackClick)[2], handler(self, self.onClickHelp).tag = handler(self, self.onBackClick), handler(self, self.onClickHelp)
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(self.activityID)
	self.fields.Com_9001676_mainUI:setGameStartCallback(handler(self, self.onGameStartCallback))
	self.fields.Com_9001676_mainUI:setGameEndCallback(handler(self, self.onGameEndCallback))
end
function Activity_9001676_MainPanel:switchTab(index)
	self.fields.Com_tab:setDefaultClick(index, index)
end
function Activity_9001676_MainPanel:onTabClick(tag)
	self.currentIndex = tag
	self.controllers.c1:setSelectedIndex(tag - 1)
	self.fields.Label_time:setVisible(true)
	self:updateView()
end
function Activity_9001676_MainPanel:endShow()
	print("=======Activity_9001676_MainPanel:endShow")
	self:switchTab(1)
	self.fields.Com_9001676_mainUI:dealClose()
	self:updateView()
	local roomData = activity_9001676_Ctrl:getRoomData()
	if roomData and roomData.mode ~= 1 and roomData.state == 0 then
		local selfUid = gametop.playertop_:getPlayerID()
		local hostUid = roomData.host.uid
		if selfUid ~= hostUid then
			self.fields.Com_9001676_mainUI:playStartAni(PLAY_MODE.ROOM)
		end
	else
		guideCtrl:updateGuideModule(gGuideModule.KOREAN_CHESS)
	end
end
function Activity_9001676_MainPanel:onGameStartCallback(playMode)
	self.isInGame = true
	self.playingMode = playMode
	self.transitions.t1:play(function()
		self.controllers.c1:setSelectedIndex(2)
	end)
end
function Activity_9001676_MainPanel:onGameEndCallback()
	self.isInGame = false
	self.transitions.t1:play(1, 0, 0, 0)
	self.controllers.c1:setSelectedIndex(self.currentIndex - 1)
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	uiManager:close("MessageBox")
end
function Activity_9001676_MainPanel:updateView()
	if self.currentIndex == 1 then
		self.fields.Com_9001676_mainUI:updateView()
	elseif self.currentIndex == 2 then
		self.fields.Com_9001676_sign:updateUI()
	end
	self:updateRedDot()
end
function Activity_9001676_MainPanel:updateRedDot()
	local redNum1 = self.fields.Com_9001676_mainUI:updateRedDot()
	local redNum2 = self.fields.Com_9001676_sign:updateRedDot()
	self.fields.Com_tab:setBtnRedDot(1, 0 < redNum1)
	self.fields.Com_tab:setBtnRedDot(2, 0 < redNum2)
end
function Activity_9001676_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("krone_text_02")
	uiManager:show("RuleView", nil)
end
function Activity_9001676_MainPanel:onBackClick()
	if self.isInGame then
		SoraDPlaySound()
		local textTip = (PLAY_MODE.SINGLE_ONE == self.playingMode or PLAY_MODE.SINGLE_FIVE == self.playingMode) and i18n("Korean_chess_optimization_05") or i18n("krone_text_47")
		_ENV = nil
		;(nil).content = textTip
		;(nil).confirmString = i18n("common_text_204")
		;(nil).cancelString = i18n("common_text_185")
		;(nil).confirmFunc = function()
			self.fields.Com_9001676_mainUI:dealClose()
		end
		uiManager:show("MessageBox", nil)
	else
		self:onClickClose()
	end
end
function Activity_9001676_MainPanel:obSystemBackKeyClick()
	self:onBackClick()
end
function Activity_9001676_MainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Guide_Battle" then
		return self.fields.Com_9001676_mainUI.fields.Button_one
	elseif itemName == "Guide_Move" then
		self.fields.Com_9001676_mainUI.fields.Com_9001676_EnterGame:setGuideAni(true)
		return self.fields.Com_9001676_mainUI.fields.Com_9001676_EnterGame.fields.guide_rect_move
	elseif itemName == "Guide_Rotate" then
		return self.fields.Com_9001676_mainUI.fields.Com_9001676_EnterGame.fields.guide_rect_rotate
	end
	return self.fields[itemName]
end
return Activity_9001676_MainPanel
