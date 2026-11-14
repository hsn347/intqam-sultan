local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoadRoughViewPanel = class("RoadRoughViewPanel", baseFguiPanel)
function RoadRoughViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("RoadRoughViewPanel:ctor", self.viewName)
end
function RoadRoughViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "RoadRoughGame"
		self._packageList, self._packageList[3] = self._packageList, "CommonNew"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function RoadRoughViewPanel:onInit()
	print("=======RoadRoughViewPanel:onInit")
	self.playTime = 60
	self.isInStory = self.proxy.param and self.proxy.param.isInStory or false
	self.fields.Com_title:initData(i18n("exitic_pavillion_text_0123"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_time:setString(self.playTime)
	_ENV = self.playTime
	self.playTime.callback = handler(self, self.onGameStart)
	self.fields.node_start:startGame(self.playTime)
end
function RoadRoughViewPanel:onGameStart()
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:beginTime(self.playTime, false, true)
	self.fields.Text_time:setTimeEndListener(handler(self, self.timeOver))
end
function RoadRoughViewPanel:onShow()
	print("=======RoadRoughViewPanel:onShow")
	self:initBoard()
end
function RoadRoughViewPanel:onHide()
	print("=======RoadRoughViewPanel:onHide")
end
function RoadRoughViewPanel:onDispose()
	print("=======RoadRoughViewPanel:onDispose")
end
function RoadRoughViewPanel:initBoard()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	self.fields.board:initMap(math.random(1, 3))
end
function RoadRoughViewPanel:showMove(x, y)
	self.fields.board:showMoveBoard(x, y)
end
function RoadRoughViewPanel:hideMove()
	self.fields.board:hideMoveBoard()
end
function RoadRoughViewPanel:moveTo(x, y)
	self.fields.board:moveTo(x, y)
end
function RoadRoughViewPanel:timeOver()
	self.isGameOver = true
	self:showResult(false)
end
function RoadRoughViewPanel:showResult(isWin)
	if self.isShowedResult then
		return
	end
	self.isShowedResult = true
	self.fields.Text_time:removeTime()
	if self.msgPanel then
		self.msgPanel:removeFromParent()
	end
	if self.proxy.param and self.proxy.param.resultCallback then
		self.proxy.param.resultCallback(isWin)
	elseif not (not isWin or self.isInStory) or not isWin then
		_ENV = nil
		;(nil).type = 1
		;(nil).isWin = isWin
		;(nil).isInStory = self.isInStory
		uiManager:show("ForeignPsettlement", nil)
	else
		_ENV = nil
		;(nil).isWin = isWin
		;(nil).isInStory = self.isInStory
		uiManager:show("ForeignPVictory", nil)
	end
end
function RoadRoughViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("exitic_pavillion_text_0115")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function RoadRoughViewPanel:onClickClose()
	self.msgPanel = SoraDShowMsgBoxNew(i18n("exitic_pavillion_text_0118"), nil, i18n("common_text_185"), function(exitType)
		self.msgPanel = nil
		if exitType == MSGBOX_CALLBACK_YES then
			if self.isGameOver then
				return
			end
			self = nil
			;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
			;(nil).isWin = false
			;(nil).gameType = 1
			;(nil).isInStory = self.isInStory
			SoraDSendMessage(nil)
		end
	end)
end
return RoadRoughViewPanel
