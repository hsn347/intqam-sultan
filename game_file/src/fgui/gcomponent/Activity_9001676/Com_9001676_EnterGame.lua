local gametop = gModuleMgr.getObject("gametop")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001676_EnterGame = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
fgui.register_extension("ui://Activity_9001676/Com_9001676_EnterGame", Com_9001676_EnterGame)
_ENV = fgui.register_extension
fgui.register_extension.WHITE = 0
fgui.register_extension.BLACK = 1
fgui.register_extension.RED = 2
fgui.register_extension.STRIKER = 3
local _ENV, fgui.register_extension.BOARD, COIN_TAG = "ui://Activity_9001676/Com_9001676_EnterGame", 4, fgui.register_extension
;("ui://Activity_9001676/Com_9001676_EnterGame").P1 = 0
local _ENV, ("ui://Activity_9001676/Com_9001676_EnterGame").P2, PLAYER = Com_9001676_EnterGame, 1, "ui://Activity_9001676/Com_9001676_EnterGame"
Com_9001676_EnterGame.SINGLE_ONE = 1
Com_9001676_EnterGame.SINGLE_FIVE = 5
Com_9001676_EnterGame.MATCH = 2
local Com_9001676_EnterGame.ROOM, PLAY_MODE = 3, Com_9001676_EnterGame
function Com_9001676_EnterGame:onInit()
	self.isCanCheat = device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop()
	if self.isCanCheat then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Button_send:setTitle("发送")
		self.fields.Button_send:addClickEventListener(handler(self, self.onCheatSendClick))
	end
	self.fields.Btn_Ready:addClickEventListener(handler(self, self.onReadyClick))
	_ENV, _ENV = self.fields.Btn_Ready, self.fields.Btn_Ready.addClickEventListener
	self.fields.Btn_Ready.head = self.fields.Com_head1
	self.fields.Btn_Ready.coin = self.fields.coin1
	_ENV, self.fields.Btn_Ready.addClickEventListener[1], self.fields.Btn_Ready.count = self.fields.Btn_Ready, self.fields.Btn_Ready, self.fields.txt_count1
	self.fields.Btn_Ready.head = self.fields.Com_head2
	self.fields.Btn_Ready.coin = self.fields.coin2
	self.playerUIs, self.fields.Btn_Ready.addClickEventListener[2], self.fields.Btn_Ready.count = self.fields.Btn_Ready.addClickEventListener, self.fields.Btn_Ready, self.fields.txt_count2
	self.fields.Usm_1:setPrepareCallback(function(crisp)
	end)
end
function Com_9001676_EnterGame:onReadyClick()
	SoraDPlaySound()
	if not self.isRoomMode then
		return
	end
	local roomData = activity_9001676_Ctrl:getRoomData()
	if self.isHost then
		activity_9001676_Ctrl:reqKoreanChessRoomStart()
	else
		activity_9001676_Ctrl:reqKoreanChessRoomReady(not self.isReady)
	end
end
function Com_9001676_EnterGame:setGameEndCallback(callback)
	self.gameEndCallback = callback
end
function Com_9001676_EnterGame:onShow()
	self.transitions.t0:play(1, 0, 0, 0)
end
function Com_9001676_EnterGame:onHide()
	self:stopAllActions()
	if self.playingMode ~= nil then
		if not self.isMatchMode or activity_9001676_Ctrl:getRoomData() ~= nil then
			activity_9001676_Ctrl:reqKoreanChessRoomQuit()
		elseif self.isInMatching then
			activity_9001676_Ctrl:reqKoreanChessMatchCancel()
		end
		self.playingMode = nil
	else
	end
end
function Com_9001676_EnterGame:dealClose()
	self:stopAllActions()
	if self.playingMode ~= nil then
		if not self.isMatchMode or activity_9001676_Ctrl:getRoomData() ~= nil then
			activity_9001676_Ctrl:reqKoreanChessRoomQuit()
		elseif self.isInMatching then
			activity_9001676_Ctrl:reqKoreanChessMatchCancel()
		end
		self.playingMode = nil
	elseif self.gameEndCallback then
		self.gameEndCallback()
	end
end
function Com_9001676_EnterGame:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001676_UPDATE", handler(self, self.onUpdateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_LAST_FINISH", handler(self, self.startGame))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE", function(target, data)
		if data.otherPic then
			self:setGuideAni(false)
		end
	end)
end
function Com_9001676_EnterGame:startGame()
	self.Com_9001676_game:startGame(self.playingMode, self.myPlayer)
end
function Com_9001676_EnterGame:onUpdateData(target, data)
	dump(data, "Com_9001676_EnterGame:onUpdateData")
	if data.msgType == "ShotEnd" then
		self.isWaitingShotEnd = false
		if data.data.gameOver then
			_ENV = nil
			;(nil).isWin = not data.isNotify
			;(nil).reward = data.reward
			;(nil).playMode = self.playingMode
			;(nil).msgData = data.data
			;(nil).hitResult = self.lastHitResult
			;(nil).myColor = self.myColor
			uiManager:show("Activity_9001676_Result", nil)
			self.playingMode = nil
			if self.gameEndCallback then
				self.gameEndCallback()
			end
		else
			self:showNextPlayerTurn(data.data.nextPlayer, data.data.isGenPenaltyCoin, data.data.genPenaltyCoinTag)
		end
	elseif data.msgType == "Shot" then
		if self.isCanCheat and data.data and type(data.data) == "string" then
			self.fields.text_pos:setText(data.data)
		end
		self.playerUI1.head:stopCountDownAni()
		self.playerUI2.head:stopCountDownAni()
	elseif data.msgType == "RoomQuit" then
		if self.isAIMode or self.Com_9001676_game.isInGame then
			local isWin = not self.isAIMode and self.Com_9001676_game.isInGame and data.isNotify
			_ENV = data.data.genPenaltyCoinTag
			data.data.genPenaltyCoinTag.isWin = isWin
			data.data.genPenaltyCoinTag.reward = data.reward
			data.data.genPenaltyCoinTag.playMode = self.playingMode
			data.data.genPenaltyCoinTag.msgData = self.lastMsgData
			data.data.genPenaltyCoinTag.hitResult = self.lastHitResult
			data.data.genPenaltyCoinTag.myColor = self.myColor
			uiManager:show("Activity_9001676_Result", data.data.genPenaltyCoinTag)
			self.playingMode = nil
			if self.gameEndCallback then
				self.gameEndCallback()
			end
		else
			local roomData = activity_9001676_Ctrl:getRoomData()
			if roomData == nil then
				if data.isNotify then
					SoraDShowMsgTip(i18n("krone_text_10"))
				end
				self.playingMode = nil
				if self.gameEndCallback then
					self.gameEndCallback()
				end
			else
				self:updateRoomData()
			end
		end
	elseif data.msgType == "RoomEnter" or data.msgType == "RoomReady" or data.msgType == "MatchResult" then
		self:updateRoomData()
	elseif data.msgType == "RoomKick" then
		if data.isNotify then
			SoraDShowMsgTip(i18n("krone_text_46"))
			self.playingMode = nil
			if self.gameEndCallback then
				self.gameEndCallback()
			end
		else
			self:updateRoomData()
		end
	elseif data.msgType == "RoomStart" then
		self.fields.Btn_Ready:setVisible(false)
		self:playStartAni()
	elseif data.msgType == "MatchCancel" then
		SoraDShowMsgTip(i18n("krone_text_49"))
		self.playingMode = nil
		if self.gameEndCallback then
			self.gameEndCallback()
		end
	end
end
function Com_9001676_EnterGame:startMatch(playMode)
	self.controllers.c1:setSelectedIndex(0)
	self.controllers.c3:setSelectedIndex(0)
	self.fields.Com_9001676_game:clearContent()
	self.fields.Com_9001676_game:setURL("ui://Activity_9001676/Com_9001676_game")
	self.Com_9001676_game = self.fields.Com_9001676_game:getComponent()
	self.Com_9001676_game:setFireCallback(handler(self, self.onFireCallback))
	self.Com_9001676_game:setHitResultCallback(handler(self, self.onHitResultCallback))
	self.Com_9001676_game:setNexPlayerTurnCallback(handler(self, self.onNextPlayerTurnCallback))
	self.isAIMode = playMode == PLAY_MODE.SINGLE_ONE or playMode == PLAY_MODE.SINGLE_FIVE
	self.isRoomMode = playMode == PLAY_MODE.ROOM
	self.isMatchMode = playMode == PLAY_MODE.MATCH
	self.playingMode = playMode
	self.myColor = nil
	self.isWaitingShotEnd = false
	self.fields.Com_head1:createMyHead()
	if self.isAIMode then
		self.myPlayer = PLAYER.P1
		self.playerUI1 = self.playerUIs[1]
		self.playerUI2 = self.playerUIs[2]
		self.playerUI1.head:setState(2)
		self.playerUI2.head:setState(2)
		self.playerUI2.head:startMatchAni()
		self.fields.Btn_Ready:setVisible(false)
		self.fields.text_matching:setVisible(true)
		self.fields.text_matching:setString(i18n("krone_text_13"))
		self:runAction(ffa.seq(ffa.delay(2.5), ffa.callFunc(function()
			self.playerUI2.head:stopMatchAni()
			self.playerUI2.head:createAiHead()
			self.fields.text_matching:setString(i18n("krone_text_14"))
		end), ffa.delay(0.5), ffa.callFunc(handler(self, self.playStartAni))))
	else
		self.fields.text_matching:setVisible(self.isMatchMode)
		self.fields.Btn_Ready:setVisible(self.isRoomMode)
		if self.isMatchMode then
			self.isInMatching = true
			self.fields.Com_head1:setState(2)
			self.fields.Com_head2:setState(2)
			self.fields.Com_head2:startMatchAni()
			self.fields.text_matching:setString(i18n("krone_text_13"))
		end
		self:updateRoomData()
	end
end
function Com_9001676_EnterGame:playStartAni()
	self.playerUI2.head:setIsCanClick(false)
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setEffectPath("9001676_dusting_01.usm", false)
	self.playerUI1.head:setState(1)
	self.playerUI2.head:setState(1)
	self.Com_9001676_game:setRotateBoard(self.myPlayer)
	self.transitions.t0:play(1, 0, 0, -1, function()
		self.fields.Usm_1.effect:start()
		self.fields.Usm_1:setCompleteCallback(function()
			self.fields.Usm_1:clearEffect()
			self.controllers.c1:setSelectedIndex(1)
			self.Com_9001676_game.transitions.t0:play(1, 0, 0, -1, function()
				if SoraDIsGameGuide() then
					return
				end
				self:startGame()
			end)
		end)
	end)
end
function Com_9001676_EnterGame:updateRoomData()
	local roomData = activity_9001676_Ctrl:getRoomData()
	dump(roomData, "Com_9001676_EnterGame:updateRoomData")
	if roomData == nil or roomData.host == nil then
		return
	end
	local selfUid = gametop.playertop_:getPlayerID()
	self.isHost = roomData.host.uid == selfUid
	self.myPlayer = self.isHost and PLAYER.P1 or PLAYER.P2
	self.playerUI1 = self.isHost and self.playerUIs[1] or self.playerUIs[2]
	self.playerUI2 = self.isHost and self.playerUIs[2] or self.playerUIs[1]
	self.fields.Btn_Ready:setVisible(self.isRoomMode)
	if self.isRoomMode then
		if self.isHost then
			self.fields.Btn_Ready:setBtnColorIndex(2)
			self.fields.Btn_Ready:setTitle(i18n("common_text_1139"))
			self.playerUI2.head:setIsCanClick(true)
		else
			self.playerUI1.head:setIsCanClick(true)
		end
		self.playerUI1.head:setIsHost(true)
		self.playerUI2.head:setIsHost(false)
		if self.isHost and roomData.guest == nil or next(roomData.guest) == nil then
			self.playerUI2.head:setWaiting()
			self.playerUI1.head:setState(0)
			self.fields.Btn_Ready:setEnabled(false)
		else
			self.fields.Btn_Ready:setEnabled(not self.isHost or roomData.guest.isReady)
			self.playerUI2.head:setIsRead(roomData.guest.isReady)
			self.isReady = roomData.guest.isReady
			if not self.isHost then
				self.fields.Btn_Ready:setBtnColorIndex(self.isReady and 0 or 2)
				self.fields.Btn_Ready:setTitle(self.isReady and i18n("krone_text_33") or i18n("krone_text_30"))
			end
		end
	elseif self.isMatchMode then
		self.isInMatching = false
		self.playerUI1.head:stopMatchAni()
		self.playerUI2.head:stopMatchAni()
		self.fields.text_matching:setString(i18n("krone_text_14"))
		self:runAction(ffa.seq(ffa.delay(0.5), ffa.callFunc(handler(self, self.playStartAni))))
	end
	if roomData.guest ~= nil then
		if self.isHost then
			self.playerUI2.head:createHeadByData(roomData.guest)
		else
			self.playerUI1.head:createHeadByData(roomData.host)
		end
	end
end
function Com_9001676_EnterGame:onFireCallback(pos, velocity)
	if self.isWaitingShotEnd then
		return
	end
	local sendStr = pos.x .. "," .. pos.y .. "," .. velocity.x .. "," .. velocity.y
	if self.isCanCheat then
		self.fields.text_pos:setText(sendStr)
	end
	self.playerUI1.head:stopCountDownAni()
	self.playerUI2.head:stopCountDownAni()
	if self.isMyTurn then
		activity_9001676_Ctrl:reqKoreanChessShot(sendStr)
	end
end
function Com_9001676_EnterGame:onHitResultCallback(hitResult, msgData)
	dump(hitResult, "Com_9001676_EnterGame:onHitResultCallback")
	if hitResult.p1Color ~= nil then
		self.myColor = self.myPlayer == PLAYER.P1 and hitResult.p1Color or hitResult.p2Color
		if self.controllers.c3:getSelectedIndex() == 0 then
			self.controllers.c3:setSelectedIndex(1)
			self.playerUI1.coin:setURL(hitResult.p1Color == COIN_TAG.WHITE and "frame_9001676_whitechess.png" or "frame_9001676_blackchess.png")
			self.playerUI2.coin:setURL(hitResult.p2Color == COIN_TAG.WHITE and "frame_9001676_whitechess.png" or "frame_9001676_blackchess.png")
		end
		self.playerUI1.count:setString(9 - hitResult.coinCount[hitResult.p1Color])
		self.playerUI2.count:setString(9 - hitResult.coinCount[hitResult.p2Color])
	end
	self.lastMsgData = msgData
	self.lastHitResult = hitResult
	local isAITurn = not hitResult.isMyTurn and self.isAIMode
	if hitResult.isMyTurn and msgData then
		activity_9001676_Ctrl:reqKoreanChessShotEnd(msgData)
	elseif isAITurn and hitResult.isGameOver then
		activity_9001676_Ctrl:reqKoreanChessRoomQuit()
	end
	if not (not isAITurn or hitResult.isGameOver) or msgData == nil then
		local isGenPenaltyCoin = msgData and msgData.isGenPenaltyCoin or false
		local genPenaltyCoinTag = msgData and msgData.genPenaltyCoinTag or nil
		self:showNextPlayerTurn(hitResult.nextPlayer, isGenPenaltyCoin, genPenaltyCoinTag)
	end
end
function Com_9001676_EnterGame:showNextPlayerTurn(player, isGenPenaltyCoin, genPenaltyCoinTag)
	self.isMyTurn = self.myPlayer == player
	self.Com_9001676_game:showNextPlayerTurn(player, isGenPenaltyCoin, genPenaltyCoinTag)
end
function Com_9001676_EnterGame:onNextPlayerTurnCallback(player)
	if player == PLAYER.P1 then
		self.playerUI1.head:startCountDownAni(30, handler(self, self.onTimeUp))
	else
		self.playerUI2.head:startCountDownAni(30, handler(self, self.onTimeUp))
	end
end
function Com_9001676_EnterGame:onTimeUp()
	self.Com_9001676_game:onTimeUp()
	self.playerUI1.head:stopCountDownAni()
	self.playerUI2.head:stopCountDownAni()
	if self.isMyTurn then
		self.isWaitingShotEnd = true
		activity_9001676_Ctrl = nil
		activity_9001676_Ctrl:reqKoreanChessShot(nil)
	end
	self.Com_9001676_game:shotEnd(true)
end
function Com_9001676_EnterGame:onCheatSendClick()
	if self.fields.text_input:getText() == "start" then
		self:playStartAni()
	else
		self.Com_9001676_game:sendFireData(self.fields.text_input:getText())
	end
end
function Com_9001676_EnterGame:setGuideAni(isAni)
	self.controllers.guide:setSelectedIndex(isAni and 1 or 0)
	if isAni then
		if not self.spriteFinger then
			local spriteFinger = SoraDFingerAction()
			spriteFinger:addTo(self.fields.Com_empty)
			spriteFinger:setPosition(0, 0)
			self.spriteFinger = spriteFinger
		end
		self.transitions.t1:play(-1, 0, 0, -1)
	end
end
return Com_9001676_EnterGame
