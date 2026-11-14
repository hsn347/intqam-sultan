local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001705_MainPanel = class("Activity_9001705_MainPanel", baseFguiPanel)
local activity_9001705_Ctrl = SoraDGetCtrl("activity_9001705_Ctrl")
function Activity_9001705_MainPanel:ctor(...)
	Activity_9001705_MainPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001705_MainPanel:ctor", self.viewName)
end
function Activity_9001705_MainPanel:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001705
	print("=======Activity_9001705_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001705"), handler(self, self.onBackClick), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.currentIndex = 1
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("activity_name_9001705")
	_ENV, self.currentIndex[1], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("snow_competition_text_01")
	self.activityID.tabsetArray, self.currentIndex[2], handler(self, self.onClickHelp).tag = self.currentIndex, handler(self, self.onClickHelp)
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(self.activityID)
	self.fields.Com_9001705_mainUI:setStartCallback(function()
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Label_time:setVisible(false)
		self.isInGame = true
		self.fields.Com_9001705_game:startGame(handler(self, self.onGameResultCallback))
	end)
end
function Activity_9001705_MainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function Activity_9001705_MainPanel:switchTab(index)
	self.fields.Com_tab:setDefaultClick(index, index)
end
function Activity_9001705_MainPanel:onTabClick(tag)
	self.currentIndex = tag
	self.controllers.c1:setSelectedIndex(tag - 1)
	self.fields.Label_time:setVisible(true)
	self:updateView()
end
function Activity_9001705_MainPanel:onShow()
	print("=======Activity_9001705_MainPanel:onShow")
end
function Activity_9001705_MainPanel:onHide()
	print("=======Activity_9001705_MainPanel:onHide")
	local devicePerformanceUtil = require("app.devicePerformanceUtil")
	devicePerformanceUtil.resetQuality()
end
function Activity_9001705_MainPanel:updateRedDot()
	local redNum1 = self.fields.Com_9001705_mainUI:updateRedDot()
	local redNum2 = self.fields.Com_9001705_sign:updateRedDot()
	self.fields.Com_tab:setBtnRedDot(1, 0 < redNum1)
	self.fields.Com_tab:setBtnRedDot(2, 0 < redNum2)
end
function Activity_9001705_MainPanel:updateView(msgType)
	if msgType == "begin" then
	elseif self.currentIndex == 1 then
		self.fields.Com_9001705_mainUI:initData()
	elseif self.currentIndex == 2 then
		self.fields.Com_9001705_sign:updateUI()
	end
	self:updateRedDot()
end
function Activity_9001705_MainPanel:onGameResultCallback(passTime, runDistance, hitItemRecount)
	activity_9001705_Ctrl:reqSnowCompetitionEnd(math.floor(runDistance), hitItemRecount[2], hitItemRecount[1], hitItemRecount[3] + hitItemRecount[4])
end
function Activity_9001705_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("sky_competition_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001705_MainPanel:onBackClick()
	if self.isInGame then
		SoraDPlaySound()
		if self.fields.Com_9001705_game:getIsGameStart() then
			self.fields.Com_9001705_game:pauseGame(true)
			SoraDShowMsgBoxNew(i18n("exitic_pavillion_text_0118"), nil, i18n("common_text_185"), function(exitType)
				if exitType == MSGBOX_CALLBACK_YES then
					if tolua.isnull(self) then
						return
					end
					self.fields.Com_9001705_game:finishGame()
				else
					self.fields.Com_9001705_game:pauseGame(false)
				end
			end)
		else
			self:onTabClick(1)
			self.isInGame = false
		end
	else
		self:onClickClose()
	end
end
function Activity_9001705_MainPanel:obSystemBackKeyClick()
	self:onBackClick()
end
return Activity_9001705_MainPanel
