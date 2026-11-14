local activity_9001731_Read = include("activity_9001731_Read")
local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local constantRead = include("constantRead")
local teamDef = include("teamDef")
local GRID_SIZE = 39
_ENV = nil
_ENV = nil
_ENV, (nil).rotate = nil, 0
;(nil)[1] = cc.p(-230, 400)
;(nil)[2] = cc.p(-230, -400)
;(nil)[3] = cc.p(230, -400)
;(nil)[gFlyingChessPlayer.BLUE], (nil).offsets, (nil)[4] = nil, nil, cc.p(230, 400)
_ENV = nil
_ENV, (nil).rotate = nil, -90
;(nil)[2] = cc.p(-230, 400)
;(nil)[3] = cc.p(-230, -400)
;(nil)[4] = cc.p(230, -400)
;(nil)[gFlyingChessPlayer.RED], (nil).offsets, (nil)[1] = nil, nil, cc.p(230, 400)
_ENV = nil
_ENV, (nil).rotate = nil, -180
;(nil)[3] = cc.p(-230, 400)
;(nil)[4] = cc.p(-230, -400)
;(nil)[1] = cc.p(230, -400)
;(nil)[gFlyingChessPlayer.GREEN], (nil).offsets, (nil)[2] = nil, nil, cc.p(230, 400)
_ENV = nil
_ENV, (nil).rotate = nil, 90
;(nil)[4] = cc.p(-230, 400)
;(nil)[1] = cc.p(-230, -400)
;(nil)[2] = cc.p(230, -400)
_UPVALUE2_, _ENV, _ENV, (nil)[gFlyingChessPlayer.YELLOW], (nil).offsets, (nil)[3] = nil, nil, gFlyingChessPlayer.YELLOW, nil, nil, cc.p(230, 400)
local playerViewCfg
_UPVALUE2_, (nil).x, (nil)[1] = nil, nil, -11
_UPVALUE2_, (nil).x, (nil)[2] = nil, nil, 11
_UPVALUE3_, _ENV, gFlyingChessPlayer.YELLOW[2], (nil).y, (nil)[1] = nil, nil, nil, nil, 0
_UPVALUE3_, _ENV, gFlyingChessPlayer.YELLOW[2], (nil).y, (nil)[2] = nil, nil, nil, nil, 0
_UPVALUE3_, (nil).x, (nil)[1] = nil, nil, 0
_UPVALUE3_, (nil).x, (nil)[2] = nil, nil, -11
_UPVALUE3_, (nil).x, (nil)[3] = nil, nil, 11
_UPVALUE4_, _ENV, gFlyingChessPlayer.YELLOW[3], (nil).y, (nil)[1] = nil, nil, nil, nil, -11
_UPVALUE4_, _ENV, gFlyingChessPlayer.YELLOW[3], (nil).y, (nil)[2] = nil, nil, nil, nil, 11
_UPVALUE4_, _ENV, gFlyingChessPlayer.YELLOW[3], (nil).y, (nil)[3] = nil, nil, nil, nil, 11
_UPVALUE4_, (nil).x, (nil)[1] = nil, nil, -11
_UPVALUE4_, (nil).x, (nil)[2] = nil, nil, 11
_UPVALUE4_, (nil).x, (nil)[3] = nil, nil, -11
_UPVALUE4_, (nil).x, (nil)[4] = nil, nil, 11
gFlyingChessPlayer.YELLOW[4], (nil).y, (nil)[1] = nil, nil, -11
gFlyingChessPlayer.YELLOW[4], (nil).y, (nil)[2] = nil, nil, -11
gFlyingChessPlayer.YELLOW[4], (nil).y, (nil)[3] = nil, nil, 11
gFlyingChessPlayer.YELLOW[4], (nil).y, (nil)[4] = nil, nil, 11
local mulitCfg = gFlyingChessPlayer.YELLOW
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001731_GamePanel = class("Activity_9001731_GamePanel", baseFguiPanel)
function Activity_9001731_GamePanel:ctor(...)
	self.isLRU = true
	Activity_9001731_GamePanel.super.ctor(self, ...)
	print("Activity_9001731_GamePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FLYING_CHESS_ACTIVITY
end
function Activity_9001731_GamePanel:onInit()
	print("=======Activity_9001731_GamePanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Button_game:addClickListener(handler(self, self.onClick_Button_game))
	self.fields.maskArea:setVisible(false)
	self.fields.maskArea:addEventListener(fgui.UIEventType.Click, handler(self, self.hideKeyboardMask))
	self.input = self.fields.input:getChild("input")
	self.fields.input:setVisible(userSDKManager.isBeta() or device.platform == "mac")
	self.fields.Button_cheat:setString("作弊点数")
	self.fields.Button_cheat:addClickListener(handler(self, self.btnCheatClick))
	self.fields.Button_cheat:setVisible(userSDKManager.isBeta() or device.platform == "mac")
end
function Activity_9001731_GamePanel:endShow()
	print("=======Activity_9001731_GamePanel:endShow")
	self.model = self.param.model or 1
	self.isJoin = self.param.isJoin or false
	self.roomId = self.param.roomId
	self.isFirst = true
	self.isReqStart = false
	self.gameOverData = nil
	self.moveDone = false
	self:initSafeGrid()
	self.controllers.c1:setSelectedIndex(0)
	self.controllers.c2:setSelectedIndex(self.model - 1)
	self.fields.Mod_board:setRotation(0)
	for k, v in pairs(gFlyingChessPlayer) do
		local cfg = playerViewCfg[gFlyingChessPlayer.BLUE]
		self.fields["player" .. v]:setVisible(true)
		self.fields["player" .. v]:setPosition(cc.p(self.fields.Mod_board:getPositionX() + cfg.offsets[v].x, self.fields.Mod_board:getPositionY() + cfg.offsets[v].y))
		self.fields["player" .. v]:init(v)
	end
	self:clearBoard()
	self:updateHead()
	if self.model == 1 then
		self.fields.Button_game:setVisible(true)
		if self.isJoin then
			_ENV = nil
			;(nil).subMsg = "create"
			self:roomUpdate(self, nil)
		else
			activity_9001731_Ctrl:reqRoomCreate()
			SoraDShowLoading(self)
		end
	else
		self.fields.player2:setVisible(false)
		self.fields.player4:setVisible(false)
		self.fields.player1:setPositionX(self:getWidth() / 2)
		self.fields.player3:setPositionX(self:getWidth() / 2)
		self.fields.Button_game:setVisible(false)
		_ENV = false
		;(false).c1Index = 2
		;(false).c2Index = 2
		;(false).c3Index = 0
		;(false).nickName = SoraDGetCtrl("lordInfoCtrl"):getNickName()
		;(false).uid = SoraDGetPlayerID()
		self.fields.player1:initHead(false)
		self.fields.player3:runRandom()
		playerViewCfg = SoraDGetPlayerID()
		SoraDGetPlayerID()[1] = ffa.delay(5)
		SoraDGetPlayerID()[2] = ffa.callFunc(function()
			self.fields.player1:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 - 230, self.fields.player1:getPositionY()))
			self.fields.player3:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 + 230, self.fields.player3:getPositionY()))
			activity_9001731_Ctrl:reqStart(self.param.count or 1)
			self.isReqStart = true
			SoraDShowLoading(self)
		end)
		SoraDGetPlayerID()[3] = ffa.callFunc(function()
			self.fields.player1:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 - 230, self.fields.player1:getPositionY()))
			self.fields.player3:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 + 230, self.fields.player3:getPositionY()))
			activity_9001731_Ctrl:reqStart(self.param.count or 1)
			self.isReqStart = true
			SoraDShowLoading(self)
		end)
		SoraDGetPlayerID()[4] = ffa.callFunc(function()
			self.fields.player1:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 - 230, self.fields.player1:getPositionY()))
			self.fields.player3:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 + 230, self.fields.player3:getPositionY()))
			activity_9001731_Ctrl:reqStart(self.param.count or 1)
			self.isReqStart = true
			SoraDShowLoading(self)
		end)
		SoraDGetPlayerID()[5] = ffa.callFunc(function()
			self.fields.player1:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 - 230, self.fields.player1:getPositionY()))
			self.fields.player3:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 + 230, self.fields.player3:getPositionY()))
			activity_9001731_Ctrl:reqStart(self.param.count or 1)
			self.isReqStart = true
			SoraDShowLoading(self)
		end)
		SoraDGetPlayerID()[6] = ffa.callFunc(function()
			self.fields.player1:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 - 230, self.fields.player1:getPositionY()))
			self.fields.player3:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 + 230, self.fields.player3:getPositionY()))
			activity_9001731_Ctrl:reqStart(self.param.count or 1)
			self.isReqStart = true
			SoraDShowLoading(self)
		end)
		SoraDGetPlayerID()[7] = ffa.callFunc(function()
			self.fields.player1:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 - 230, self.fields.player1:getPositionY()))
			self.fields.player3:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 + 230, self.fields.player3:getPositionY()))
			activity_9001731_Ctrl:reqStart(self.param.count or 1)
			self.isReqStart = true
			SoraDShowLoading(self)
		end)
		SoraDGetPlayerID()[8] = ffa.callFunc(function()
			self.fields.player1:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 - 230, self.fields.player1:getPositionY()))
			self.fields.player3:runAction(ffa.moveTo(0.25, self.view:getWidth() / 2 + 230, self.fields.player3:getPositionY()))
			activity_9001731_Ctrl:reqStart(self.param.count or 1)
			self.isReqStart = true
			SoraDShowLoading(self)
		end)
		self:runAction(ffa.seq((SoraDGetPlayerID())))
	end
	if userSDKManager.isBeta() or device.platform == "mac" then
		self.input:setText(6)
		self:initGrid()
	end
end
function Activity_9001731_GamePanel:initGrid()
	self.fields.Node_grid:clearContent()
	local list = activity_9001731_Read.getMapList()
	for _, v in ipairs(list) do
		local obj = fguiHelper.createObject("Activity_9001731", "Com_grid")
		obj:setPosition(cc.p(v.coordinates[1] * GRID_SIZE, -v.coordinates[2] * GRID_SIZE))
		obj:addTo(self.fields.Node_grid)
		obj:getChild("Text_girdID"):setString(v.mapNumer)
		obj:getChild("Text_pos"):setString("(" .. v.coordinates[1] .. "," .. v.coordinates[2] .. ")")
	end
end
function Activity_9001731_GamePanel:initSafeGrid()
	self.fields.Node_safe:clearContent()
	local list = activity_9001731_Read.getMapList()
	for _, v in ipairs(list) do
		if v.mapType == gFlyingChessBroadGridType.SAFE then
			local obj = fguiHelper.createObject("Activity_9001731", "Lab_safe")
			obj:setPosition(cc.p(v.coordinates[1] * GRID_SIZE, -v.coordinates[2] * GRID_SIZE))
			obj:addTo(self.fields.Node_safe)
		end
	end
end
function Activity_9001731_GamePanel:showKeyboardMask()
	self.fields.maskArea:setVisible(true)
end
function Activity_9001731_GamePanel:hideKeyboardMask()
	self.fields.maskArea:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(function()
		self.fields.maskArea:setVisible(false)
		self = self.fields.maskArea
		self.fields.maskArea.msg = "MESSAGE_CHAT_CLOSE_IME"
		self.fields.maskArea.viewType = "Activity_9001731_Game"
		SoraDSendMessage(self.fields.maskArea)
	end)))
end
function Activity_9001731_GamePanel:suitPlayerView()
	if self.model == 2 then
		self.fields.Mod_board:setRotation(0)
		local cfg = playerViewCfg[gFlyingChessPlayer.BLUE]
		for k, v in pairs(gFlyingChessPlayer) do
			self.fields["player" .. v]:setPosition(cc.p(self.fields.Mod_board:getPositionX() + cfg.offsets[v].x, self.fields.Mod_board:getPositionY() + cfg.offsets[v].y))
			self.fields["player" .. v]:init(v)
		end
		return
	end
	local camp = activity_9001731_Ctrl:getCampByUid()
	local cfg = playerViewCfg[camp]
	self.fields.Mod_board:setRotation(cfg.rotate)
	for k, v in pairs(gFlyingChessPlayer) do
		self.fields["player" .. v]:setPosition(cc.p(self.fields.Mod_board:getPositionX() + cfg.offsets[v].x, self.fields.Mod_board:getPositionY() + cfg.offsets[v].y))
		self.fields["player" .. v]:init(v)
	end
end
function Activity_9001731_GamePanel:obSystemBackKeyClick()
	self:onClickClose()
end
function Activity_9001731_GamePanel:onClickClose()
	SoraDPlaySound("uicontrol", 1)
	if self.model == 1 then
		if activity_9001731_Ctrl:isGaming() then
			_ENV = nil
			;(nil).content = i18n("Ludo_test_043")
			;(nil).cancel = true
			;(nil).confirmFunc = function()
				activity_9001731_Ctrl:reqRoomQuit()
				self:close()
			end
			uiManager:show("MessageBox", nil)
		else
			activity_9001731_Ctrl:reqRoomQuit()
			self:close()
		end
	elseif self.isReqStart or activity_9001731_Ctrl:isGaming() then
		_ENV = nil
		;(nil).content = i18n("Ludo_test_031")
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			activity_9001731_Ctrl:reqQuit()
		end
		uiManager:show("MessageBox", nil)
	else
		self:close()
	end
end
function Activity_9001731_GamePanel:messageShow(target, data)
	local msgData = data.data[1]
	if msgData and msgData.content and msgData.content.teamType == teamDef.teamAreaEnum.ACTIVITY_9001731 then
		for i = 1, 4 do
			self.fields["player" .. i]:showMsgPop(msgData.content.content, msgData.sender.userInfo.uid)
		end
		self.fields.Com_chat:setMsgData(msgData)
	end
end
function Activity_9001731_GamePanel:roomUpdate(target, data)
	SoraDCloseLoading(self)
	local subMsg = data.subMsg
	self.roomData = activity_9001731_Ctrl:getRoomData()
	local gameStr = i18n("common_text_2849")
	local isHost = activity_9001731_Ctrl:isSelfHost()
	local btnColor = gBtnColorDef.GREEN
	if not isHost then
		gameStr = activity_9001731_Ctrl:isReady() and i18n("Ludo_test_014") or i18n("Ludo_test_013")
		btnColor = activity_9001731_Ctrl:isReady() and gBtnColorDef.RED or gBtnColorDef.GREEN
	end
	self.fields.Button_game:setTitle(gameStr)
	self.fields.Button_game:setEnabled(not isHost)
	self.fields.Button_game:setBtnColorIndex(btnColor)
	if subMsg == "create" then
		self:suitPlayerView()
		self:updateHead()
	elseif subMsg == "beKicked" then
	elseif subMsg == "quitRoom" then
	elseif subMsg == "setRoom" then
		local isEnable = true
		if activity_9001731_Ctrl:isSelfHost() then
			isEnable = activity_9001731_Ctrl:isAllReady()
		end
		self.fields.Button_game:setEnabled(isEnable)
		self:updateHeadStatus()
	end
end
function Activity_9001731_GamePanel:endGuide(target, data)
	if data and data.step and tonumber(data.step) == 9992003 then
		activity_9001731_Ctrl:reqRoomGuide()
		self:firstAni()
	end
end
function Activity_9001731_GamePanel:firstAni()
	if not self.dicePanel then
		self.dicePanel = SoraDCreatePanel("pyramidDiceView")
		self.dicePanel:setPosition(cc.p(0, 0))
		self.dicePanel:addTo(self.fields.Node_dice)
	end
	_ENV = self.fields.Node_dice
	self.fields.Node_dice.num1 = self.firstRollNum
	self.dicePanel:initExData(self.fields.Node_dice, function()
		if activity_9001731_Ctrl:isGaming() and self.starPlayer then
			activity_9001731_Ctrl = nil
			;(nil).player = self.starPlayer
			uiManager:show("Activity_9001731_First", nil)
		end
		self.isFirst = false
		self.dicePanel = nil
	end)
end
function Activity_9001731_GamePanel:startGame(target, data)
	SoraDCloseLoading(self)
	self.controllers.c1:setSelectedIndex(1)
	self:updateHead()
	self:initBoard()
	self.starPlayer = data.player
	self.firstRollNum = data.rollNum
	if self.model == 2 then
		SoraDShowMsgTip(i18n("Ludo_test_022"))
		if activity_9001731_Ctrl:isNeedGuide() then
			_ENV = activity_9001731_Ctrl
			activity_9001731_Ctrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			activity_9001731_Ctrl.step = 9992000
			SoraDSendMessage(activity_9001731_Ctrl)
		else
			self:firstAni()
		end
	else
		self.fields.Com_chat:initData(self)
		self:firstAni()
	end
end
function Activity_9001731_GamePanel:changePlayer(target, data)
	local playerID = data.playerID
	for k, v in pairs(gFlyingChessPlayer) do
		self.fields["player" .. v]:update(v == data.playerID, v == data.playerID and 1 or nil)
	end
end
function Activity_9001731_GamePanel:rollAni(data)
	if not self.dicePanel then
		self.dicePanel = SoraDCreatePanel("pyramidDiceView")
		self.dicePanel:setPosition(cc.p(0, 0))
		self.dicePanel:addTo(self.fields.Node_dice)
	end
	_ENV = self.fields.Node_dice
	self.fields.Node_dice.num1 = data.rollNums[1]
	self.fields.Node_dice.num2 = data.rollNums[2]
	self.dicePanel:initExData(self.fields.Node_dice, function()
		for k, v in pairs(gFlyingChessPlayer) do
			if self.chessList[v] then
				local chessArray, otherArray = self:checkChessMove(v, data.rollNums)
				if 0 < #chessArray then
					self.fields["player" .. v]:update(false, v == data.playerID and 2 or nil)
				else
					self.fields["player" .. v]:update(false)
				end
			else
				self.fields["player" .. v]:update(false)
			end
		end
		if data.playerID == activity_9001731_Ctrl:getCampByUid() then
			local chessArray, otherArray = self:checkChessMove(data.playerID, data.rollNums)
			if 0 < #otherArray then
				for _, v in ipairs(otherArray) do
					v:setIdle()
				end
			end
			if 0 < #chessArray then
				for _, v in ipairs(chessArray) do
					v:setReadyGoAni()
				end
			else
				SoraDShowMsgTip(i18n("Ludo_test_041"))
			end
		end
		self.dicePanel = nil
	end, nil, nil, nil, nil, 1.5)
end
function Activity_9001731_GamePanel:rollShow(target, data)
	local rollNums = data.rollNums
	if not self.isFirst then
		self:rollAni(data)
	else
		for k, v in pairs(gFlyingChessPlayer) do
			self.fields["player" .. v]:update(false)
		end
	end
end
function Activity_9001731_GamePanel:moveShow(target, data)
	local notifyData = data.notifyData
	self.moveDone = false
	local chess = self.chessList[notifyData.playerID][notifyData.chessID]
	chess:setSortingOrder(2)
	for _, v in ipairs(self.chessList[notifyData.playerID]) do
		v:setIdle()
	end
	if notifyData.pathIndex then
		local fromPath = chess:getPathIndex()
		local toPath = notifyData.pathIndex
		if fromPath == 0 then
			chess:setStatus(gFlyingChessPieceStatus.FLYING)
		end
		chess:setPathIndex(toPath)
		print("player,from,to====", notifyData.playerID, fromPath, toPath)
		local movePath = activity_9001731_Read.getMovePathList(notifyData.playerID, fromPath, toPath)
		local _ENV, action = notifyData.playerID, notifyData.playerID
		dump(movePath, "movePath===")
		if fromPath ~= 0 then
			local gridID_begin = activity_9001731_Read.getGridByPathIndex(notifyData.playerID, fromPath)
			if activity_9001731_Read.isSafeMapNumber(gridID_begin) then
				table.insert(action, ffa.callFunc(function()
					chess:setShowModel(false)
					self:refreshSafeGrid(gridID_begin)
				end))
			end
		end
		for _, v in ipairs(movePath) do
			local mapCfg = activity_9001731_Read.getMapCfg(v)
			table.insert(action, ffa.moveTo(0.2, mapCfg.coordinates[1] * GRID_SIZE, -mapCfg.coordinates[2] * GRID_SIZE))
			table.insert(action, ffa.delay(0.1))
		end
		if notifyData.addItem then
			table.insert(action, ffa.callFunc(function()
				local gridID = activity_9001731_Read.getGridByPathIndex(notifyData.playerID, notifyData.pathIndex)
				print("playerID,pathIndex,gridID====", notifyData.playerID, notifyData.pathIndex, gridID)
				local item = self.itemList[gridID]
				if item then
					local toObj = self.fields["player" .. notifyData.playerID]:getItem(notifyData.addItem)
					local pos = self.fields.Node_item:globalToLocal(toObj:localToGlobal(cc.p(0, 0)))
					dump(pos, "道具目标pos=======")
					notifyData = toObj:localToGlobal(cc.p(0, 0))
					toObj:localToGlobal(cc.p(0, 0))[1] = ffa.moveTo(0.3, pos.x, pos.y)
					toObj:localToGlobal(cc.p(0, 0))[2] = ffa.callFunc(function()
						self.fields["player" .. notifyData.playerID]:addItem(notifyData.addItem)
						item:removeFromParent()
						self.itemList[gridID] = nil
					end)
					toObj:localToGlobal(cc.p(0, 0))[3] = ffa.callFunc(function()
						self.fields["player" .. notifyData.playerID]:addItem(notifyData.addItem)
						item:removeFromParent()
						self.itemList[gridID] = nil
					end)
					toObj:localToGlobal(cc.p(0, 0))[4] = ffa.callFunc(function()
						self.fields["player" .. notifyData.playerID]:addItem(notifyData.addItem)
						item:removeFromParent()
						self.itemList[gridID] = nil
					end)
					item:runAction(ffa.seq(toObj:localToGlobal(cc.p(0, 0))))
				end
			end))
		end
		if notifyData.kickChess then
			table.insert(action, ffa.callFunc(function()
				for _, v in ipairs(notifyData.kickChess.chessList) do
					local kickChess = self.chessList[notifyData.kickChess.playerID][v]
					kickChess:setPathIndex(0)
					kickChess:setStatus(gFlyingChessPieceStatus.HOME)
					local obj = self:getBirthIndex(notifyData.kickChess.playerID, v)
					kickChess:runAction(ffa.moveTo(0.3, obj:getPositionX() - self.fields.Node_chess:getPositionX(), obj:getPositionY() - self.fields.Node_chess:getPositionY()))
				end
			end))
		end
		if notifyData.isReach then
			table.insert(action, ffa.callFunc(function()
				local obj = self:getBirthIndex(notifyData.playerID, notifyData.chessID)
				notifyData = notifyData.playerID
				notifyData.playerID[1] = ffa.moveTo(0.3, obj:getPositionX() - self.fields.Node_chess:getPositionX(), obj:getPositionY() - self.fields.Node_chess:getPositionY())
				notifyData.playerID[2] = ffa.callFunc(function()
					chess:setReachAni()
					self.moveDone = true
					self:gameOverCheck()
				end)
				notifyData.playerID[3] = ffa.callFunc(function()
					chess:setReachAni()
					self.moveDone = true
					self:gameOverCheck()
				end)
				notifyData.playerID[4] = ffa.callFunc(function()
					chess:setReachAni()
					self.moveDone = true
					self:gameOverCheck()
				end)
				notifyData.playerID[5] = ffa.callFunc(function()
					chess:setReachAni()
					self.moveDone = true
					self:gameOverCheck()
				end)
				notifyData.playerID[6] = ffa.callFunc(function()
					chess:setReachAni()
					self.moveDone = true
					self:gameOverCheck()
				end)
				local seq = ffa.seq(notifyData.playerID)
				chess:runAction(seq)
			end))
		end
		if toPath ~= 0 then
			local gridID_end = activity_9001731_Read.getGridByPathIndex(notifyData.playerID, toPath)
			if activity_9001731_Read.isSafeMapNumber(gridID_end) then
				table.insert(action, ffa.callFunc(function()
					self:refreshSafeGrid(gridID_end)
				end))
			end
		end
		table.insert(action, ffa.callFunc(function()
			chess:setSortingOrder(notifyData.playerID == activity_9001731_Ctrl:getCampByUid() and 1 or 0)
		end))
		chess:runAction(ffa.seq(action))
	end
end
function Activity_9001731_GamePanel:refreshSafeGrid(gridID)
	;(nil)[gridID], _ENV, _ENV = nil, nil, nil
	local campMap
	for playerID, list in pairs(self.chessList) do
		for chessID, obj in ipairs(list) do
			if obj:getSafeGrid() == gridID then
				if not campMap[gridID][playerID] then
					campMap[gridID][playerID], _ENV = obj, obj
				end
				table.insert(campMap[gridID][playerID], obj)
			end
		end
	end
	local cfg = mulitCfg[table.nums(campMap[gridID])]
	local mapCfg = activity_9001731_Read.getMapCfg(gridID)
	local index = 0
	dump(campMap, "campMap=======", 10)
	for playerID, list in pairs(campMap[gridID]) do
		index = index + 1
		if cfg then
			for _, v in ipairs(list) do
				v:setShowModel(true)
				v:setPosition(cc.p(mapCfg.coordinates[1] * GRID_SIZE + (cfg.x[index] or 0), -mapCfg.coordinates[2] * GRID_SIZE + (cfg.y[index] or 0)))
			end
		else
			for _, v in ipairs(list) do
				v:setShowModel(false)
				v:setPosition(cc.p(mapCfg.coordinates[1] * GRID_SIZE, -mapCfg.coordinates[2] * GRID_SIZE))
			end
		end
	end
end
function Activity_9001731_GamePanel:useItem(target, data)
	local notifyData = data.notifyData
	self.fields["player" .. notifyData.playerID]:useItem(notifyData.useItemID)
end
function Activity_9001731_GamePanel:itemCreate(target, data)
	local notifyData = data.notifyData
	local obj = fguiHelper.createObject("Activity_9001731", notifyData.itemID == gFlyingChessItemID.ROLLSIX and "Btn_six" or "Btn_twice")
	local mapCfg = activity_9001731_Read.getMapCfg(tonumber(notifyData.gridID))
	obj:setPosition(cc.p(mapCfg.coordinates[1] * GRID_SIZE, -mapCfg.coordinates[2] * GRID_SIZE))
	obj:addTo(self.fields.Node_item)
	self.itemList[tonumber(notifyData.gridID)] = obj
end
function Activity_9001731_GamePanel:gameOver(target, data)
	self.gameOverData = data.notifyData
	self:gameOverCheck()
end
function Activity_9001731_GamePanel:gameOverCheck()
	if self.gameOverData and self.moveDone then
		uiManager:close("MessageBox")
		if self.model == 1 then
			_ENV = nil
			;(nil).winList = self.gameOverData.winList
			uiManager:show("Activity_9001731_Rank", nil)
		else
			_ENV = nil
			;(nil).rewards = self.gameOverData.rewards
			;(nil).isWin = self.gameOverData.isWin
			uiManager:show("Activity_9001731_Finish", nil)
		end
	end
end
function Activity_9001731_GamePanel:getBirthIndex(playerID, chessID)
	local nodeName = string.format("Node_chess_%d_%d", playerID, chessID)
	return self.fields[nodeName]
end
function Activity_9001731_GamePanel:updateHeadStatus()
	for i = 1, 4 do
		local playerInfo = activity_9001731_Ctrl:getPlayerInfoEX(i)
		local c1Index = 0
		local c2Index = 2
		local c3Index = 0
		if activity_9001731_Ctrl:isSelfHost() then
			c1Index = playerInfo and 2 or 1
		else
			c1Index = playerInfo and 2 or 0
		end
		if self.roomData and self.roomData.state == gFlyingRoomState.READY then
			c2Index = 0
			if playerInfo then
				if playerInfo.isHost then
					c2Index = 0
				else
					c2Index = playerInfo.ready and 1 or 0
				end
			end
		else
			c3Index = 1
		end
		self.fields["player" .. i]:setHeadStatus(c1Index, c2Index, c3Index, playerInfo)
		self.roomData = activity_9001731_Ctrl:getRoomData()
		if self.roomData then
			self.fields["player" .. i]:setVisible(self.roomData.state == gFlyingRoomState.READY or playerInfo ~= nil)
		else
			self.fields["player" .. i]:setVisible(false)
		end
	end
end
function Activity_9001731_GamePanel:updateHead()
	if self.model == 1 then
		self.roomData = activity_9001731_Ctrl:getRoomData()
		if self.roomData then
			for i = 1, 4 do
				local playerInfo = activity_9001731_Ctrl:getPlayerInfoEX(i)
				local c1Index = 0
				local c2Index = 2
				local c3Index = 0
				if activity_9001731_Ctrl:isSelfHost() then
					c1Index = playerInfo and 2 or 1
				else
					c1Index = playerInfo and 2 or 0
				end
				if self.roomData.state == gFlyingRoomState.READY then
					c2Index = 0
					if playerInfo then
						if playerInfo.isHost then
							c2Index = 0
						else
							c2Index = playerInfo.ready and 1 or 0
						end
					end
				else
					c3Index = 1
				end
				activity_9001731_Ctrl = 1
				;(1).c1Index = c1Index
				;(1).c2Index = c2Index
				local (1).c3Index, data = c3Index, 1
				local status = ""
				if playerInfo then
					status = playerInfo.isHost and i18n("Ludo_test_039") or i18n("krone_text_45")
					data.nickName = playerInfo.nickName
					data.iconID = playerInfo.iconID
					data.avatar = playerInfo.avatar
					data.status = status
					data.uid = playerInfo.uid
					self.fields["player" .. i]:setVisible(true)
					self.fields["player" .. i]:initHead(data)
				else
					self.fields["player" .. i]:initHead(data)
					self.fields["player" .. i]:setVisible(self.roomData.state == gFlyingRoomState.READY)
				end
			end
		else
			for i = 1, 4 do
				self.fields["player" .. i]:setVisible(false)
			end
		end
	else
		activity_9001731_Ctrl = 1
		;(1).c1Index = 2
		;(1).c2Index = 2
		;(1).c3Index = 1
		;(1).nickName = SoraDGetCtrl("lordInfoCtrl"):getNickName()
		;(1).uid = SoraDGetPlayerID()
		self.fields.player1:initHead(1)
		local aiCfg = activity_9001731_Ctrl:getAICfg()
		activity_9001731_Ctrl = SoraDGetPlayerID()
		SoraDGetPlayerID().c1Index = 2
		SoraDGetPlayerID().c2Index = 2
		SoraDGetPlayerID().c3Index = 1
		SoraDGetPlayerID().nickName = i18n(aiCfg.name)
		SoraDGetPlayerID().iconID = aiCfg.head
		SoraDGetPlayerID().avatar = ""
		self.fields.player3:initHead((SoraDGetPlayerID()))
	end
end
function Activity_9001731_GamePanel:clearBoard()
	self.itemList, _UPVALUE0_ = nil, nil
	self.fields.Node_item:removeAllChildren()
	self.chessList, _UPVALUE0_ = self.fields.Node_item.removeAllChildren, self.fields.Node_item.removeAllChildren
	self.fields.Node_chess:removeAllChildren()
	if self.dicePanel then
		self.fields.Node_dice:removeAllChildren()
		self.dicePanel = nil
	end
end
function Activity_9001731_GamePanel:initBoard()
	self.gameData = activity_9001731_Ctrl:getGameData()
	if self.gameData then
		for mapNumer, chessItem in pairs(self.gameData.itemGridMap) do
			local obj = fguiHelper.createObject("Activity_9001731", chessItem == gFlyingChessItemID.ROLLSIX and "Btn_itemSix" or "Btn_itemTwice")
			local mapCfg = activity_9001731_Read.getMapCfg(tonumber(mapNumer))
			obj:setPosition(cc.p(mapCfg.coordinates[1] * GRID_SIZE, -mapCfg.coordinates[2] * GRID_SIZE))
			obj:addTo(self.fields.Node_item)
			self.itemList[tonumber(mapNumer)] = obj
		end
		for _, v in ipairs(self.gameData.players) do
			self.chessList[v.playerID], activity_9001731_Ctrl = self.itemList, self.itemList
			for i, m in ipairs(v.chessPieces) do
				local obj = fguiHelper.createObject("Activity_9001731", "Btn_chess")
				local pos = self:getChessPos(v.playerID, m.pathIndex, m.chessID)
				obj:initData(v.playerID, m)
				obj:setName("chess_" .. v.playerID .. "_" .. m.chessID)
				obj:setPosition(cc.p(pos.x, pos.y))
				obj:addTo(self.fields.Node_chess)
				obj:setSortingOrder(v.playerID == activity_9001731_Ctrl:getCampByUid() and 1 or 0)
				self.chessList[v.playerID][m.chessID] = obj
				self.fields["player" .. v.playerID]:initItems(v.items)
			end
		end
	end
end
function Activity_9001731_GamePanel:checkChessMove(playerID, rollNums)
	local _ENV, chessArray
	local _ENV, otherArray
	local chessList = self.chessList[playerID]
	for _, v in ipairs(chessList) do
		if v:getStatus() == gFlyingChessPieceStatus.REACH then
			table.insert(otherArray, v)
		elseif v:getStatus() == gFlyingChessPieceStatus.HOME then
			local nums = (rollNums[1] or 0) + (rollNums[2] or 0)
			if 6 <= nums then
				table.insert(chessArray, v)
			else
				table.insert(otherArray, v)
			end
		else
			local path = activity_9001731_Read.getPathCfg(playerID)
			local nums = (rollNums[1] or 0) + (rollNums[2] or 0)
			if nums <= #path - v:getPathIndex() then
				table.insert(chessArray, v)
			else
				table.insert(otherArray, v)
			end
		end
	end
	return chessArray, otherArray
end
function Activity_9001731_GamePanel:getChessPos(playerID, pathIndex, chessID)
	local activity_9001731_Read, pos
	if pathIndex == 0 then
		local obj = self.fields["Node_chess_" .. playerID .. "_" .. chessID]
		pos.x = obj:getPositionX() - self.fields.Node_chess:getPositionX()
		pos.y = obj:getPositionY() - self.fields.Node_chess:getPositionY()
	else
		local mapCfg = activity_9001731_Read.getMapCfg(pathIndex)
		pos.x = mapCfg.coordinates[1] * GRID_SIZE
		pos.y = -mapCfg.coordinates[2] * GRID_SIZE
	end
	return pos
end
function Activity_9001731_GamePanel:onClick_Button_game(context)
	SoraDPlaySound()
	if activity_9001731_Ctrl:isSelfHost() then
		local isAllReady = activity_9001731_Ctrl:isAllReady()
		if not isAllReady then
			SoraDShowMsgTip(i18n("Ludo_test_012"))
			return
		end
		activity_9001731_Ctrl:reqRoomStart()
		SoraDShowLoading(self)
	else
		activity_9001731_Ctrl:reqRoomReady(not activity_9001731_Ctrl:isReady())
		SoraDShowLoading(self)
	end
end
function Activity_9001731_GamePanel:btnCheatClick()
	SoraDPlaySound()
	local num = tonumber(self.input:getText()) or 6
	if num then
		activity_9001731_Ctrl:reqRoll(num)
	end
end
return Activity_9001731_GamePanel
