local foreignPavilionRead = include("foreignPavilionRead")
local baseComponent = require("fgui.base.baseComponent")
local RoadBoard = fgui.extension_class(fgui.GScrollBar, baseComponent)
fgui.register_extension("ui://RoadRoughGame/RoadBoard", RoadBoard)
function RoadBoard:onInit()
	self.heroNpc = nil
	self.oirPos = nil
	self:getScrollPane():setBouncebackEffect(false)
end
function RoadBoard:onShow()
end
function RoadBoard:posToIndex(x, y)
	return (x - 1) * 5 + y
end
function RoadBoard:initMap(map)
	local mapInfo = foreignPavilionRead.getMapConfig(map)
	for i = 1, 5 do
		for j = 1, 5 do
			local board = self:getBoardInstance(i, j)
			local npc = self:getNpcInstance(i, j)
			if SoraDisInList(j, mapInfo[i].land) then
				board:setVisible(true)
				npc:setVisible(true)
				local info = foreignPavilionRead.getRoadrough(map, i, j)
				info.x = i
				info.y = j
				board:setIndex(i, j)
				npc:setTagetInfo(info)
				if info.npcType == 1 then
					self.heroNpc = self:getNpcInstance(i, j)
					self.oirPos = cc.p(i, j)
				end
			else
				board:setVisible(false)
				npc:setVisible(false)
			end
		end
	end
	self:getScrollPane():setPercX(0.5)
	self:getScrollPane():updatePositionImmediately()
	foreignPavilionRead = self:getScrollPane()
	self:getScrollPane().msg = "MESSAGE_ROADROUGH_MOVE_SHOW"
	self:getScrollPane().x = self.heroNpc:getX()
	self:getScrollPane().y = self.heroNpc:getY()
	SoraDSendMessage((self:getScrollPane()))
end
function RoadBoard:isNeighbor(x1, y1, x2, y2)
	return math.abs(x1 - x2) + math.abs(y1 - y2) == 1
end
function RoadBoard:showMoveBoard(x, y)
	for i = 1, 5 do
		for j = 1, 5 do
			local board = self:getBoardInstance(i, j)
			if board:isVisible() then
				board:hideMove()
				if self:isNeighbor(i, j, x, y) then
					board:showMove(x, y)
				end
			end
		end
	end
end
function RoadBoard:hideMoveBoard()
	for i = 1, 5 do
		for j = 1, 5 do
			local board = self:getBoardInstance(i, j)
			if board:isVisible() then
				board:hideMove()
			end
		end
	end
end
function RoadBoard:isAllKilled()
	local aliveCount = 0
	for i = 1, 5 do
		for j = 1, 5 do
			if 0 < self:getNpcBlood(i, j) then
				aliveCount = aliveCount + 1
			end
		end
	end
	return aliveCount == 0
end
function RoadBoard:getBoardInstance(x, y)
	local boardName = "n" .. self:posToIndex(x, y)
	return self.fields[boardName]
end
function RoadBoard:getNpcInstance(x, y)
	local npcName = "m" .. self:posToIndex(x, y)
	return self.fields[npcName]
end
function RoadBoard:getNpcBlood(x, y)
	local npc = self:getNpcInstance(x, y)
	local blood = npc:getBlood()
	if self.oirPos.x == x and self.oirPos.y == y then
		blood = 0
	end
	return blood
end
function RoadBoard:getGJDir(x, y)
	_UPVALUE0_ = nil
	;(nil).dir = "ws"
	local _UPVALUE0_, (nil).isFX, dir1 = nil, false, nil
	;(nil).dir = "ws"
	local (nil).isFX, dir2 = false, nil
	if self.heroNpc:getX() == x then
		dir1.dir = y < self.heroNpc:getY() and "wn" or "ws"
		dir1.isFX = y > self.heroNpc:getY()
		dir2.dir = y < self.heroNpc:getY() and "ws" or "wn"
		dir2.isFX = y < self.heroNpc:getY()
	elseif self.heroNpc:getY() == y then
		dir1.dir = x < self.heroNpc:getX() and "wn" or "ws"
		dir1.isFX = x < self.heroNpc:getX()
		dir2.dir = x < self.heroNpc:getX() and "ws" or "wn"
		dir2.isFX = x > self.heroNpc:getX()
	end
	return dir1, dir2
end
function RoadBoard:playAttackMovie(x, y)
	local monster = self:getNpcInstance(x, y)
	local dir1Cfg, dir2Cfg = self:getGJDir(x, y)
	self.heroNpc:playGJMovie(dir1Cfg)
	monster:playGJMovie(dir2Cfg)
end
function RoadBoard:playMoveMovie(x, y)
	local dir1Cfg, dir2Cfg = self:getGJDir(x, y)
	self.heroNpc:playYDMovie(dir1Cfg)
	local board = self:getBoardInstance(x, y)
	self.heroNpc:runAction(ffa.moveTo(1.0, board:getPositionX(), board:getPositionY()))
end
function RoadBoard:moveTo(x, y)
	local npc = self:getNpcInstance(x, y)
	local toBlood = self:getNpcBlood(x, y)
	print("toBlood=======", toBlood, self.heroNpc:getBlood())
	if 0 < toBlood then
		if toBlood < self.heroNpc:getBlood() then
			_UPVALUE6_ = self.heroNpc:getBlood()
			self.heroNpc:getBlood()[1] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_MOVE_HIDE"
				SoraDSendMessage(nil)
				self:playAttackMovie(x, y)
			end)
			self.heroNpc:getBlood()[2] = ffa.delay(1.0)
			self.heroNpc:getBlood()[3] = ffa.callFunc(function()
				npc:playSWMovie()
				self:playMoveMovie(x, y)
				self.heroNpc:setXY(x, y)
				self.heroNpc:addBlood(toBlood)
			end)
			self.heroNpc:getBlood()[4] = ffa.delay(1.0)
			self.heroNpc:getBlood()[5] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_MOVE_SHOW"
				;(nil).x = x
				;(nil).y = y
				SoraDSendMessage(nil)
			end)
			self.heroNpc:getBlood()[6] = ffa.delay(0.1)
			self.heroNpc:getBlood()[7] = ffa.callFunc(function()
				if self:isAllKilled() then
					self = self
					self.msg = "MESSAGE_ROADROUGH_RESULT"
					self.isWin = true
					SoraDSendMessage(self)
				end
			end)
			self.heroNpc:getBlood()[8] = ffa.callFunc(function()
				if self:isAllKilled() then
					self = self
					self.msg = "MESSAGE_ROADROUGH_RESULT"
					self.isWin = true
					SoraDSendMessage(self)
				end
			end)
			self:runAction(ffa.seq(self.heroNpc:getBlood()))
		else
			_UPVALUE2_ = ffa.seq(self.heroNpc:getBlood())
			ffa.seq(self.heroNpc:getBlood())[1] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_MOVE_HIDE"
				SoraDSendMessage(nil)
				self:playAttackMovie(x, y)
			end)
			ffa.seq(self.heroNpc:getBlood())[2] = ffa.delay(1.0)
			ffa.seq(self.heroNpc:getBlood())[3] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_RESULT"
				;(nil).isWin = false
				SoraDSendMessage(nil)
			end)
			ffa.seq(self.heroNpc:getBlood())[4] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_RESULT"
				;(nil).isWin = false
				SoraDSendMessage(nil)
			end)
			ffa.seq(self.heroNpc:getBlood())[5] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_RESULT"
				;(nil).isWin = false
				SoraDSendMessage(nil)
			end)
			ffa.seq(self.heroNpc:getBlood())[6] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_RESULT"
				;(nil).isWin = false
				SoraDSendMessage(nil)
			end)
			ffa.seq(self.heroNpc:getBlood())[7] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_RESULT"
				;(nil).isWin = false
				SoraDSendMessage(nil)
			end)
			ffa.seq(self.heroNpc:getBlood())[8] = ffa.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_ROADROUGH_RESULT"
				;(nil).isWin = false
				SoraDSendMessage(nil)
			end)
			self:runAction(ffa.seq(ffa.seq(self.heroNpc:getBlood())))
		end
	else
		_UPVALUE2_ = ffa.seq(ffa.seq(self.heroNpc:getBlood()))
		ffa.seq(ffa.seq(self.heroNpc:getBlood()))[1] = ffa.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_ROADROUGH_MOVE_HIDE"
			SoraDSendMessage(nil)
			self:playMoveMovie(x, y)
			self.heroNpc:setXY(x, y)
		end)
		ffa.seq(ffa.seq(self.heroNpc:getBlood()))[2] = ffa.delay(1.0)
		ffa.seq(ffa.seq(self.heroNpc:getBlood()))[3] = ffa.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_ROADROUGH_MOVE_SHOW"
			;(nil).x = x
			;(nil).y = y
			SoraDSendMessage(nil)
		end)
		ffa.seq(ffa.seq(self.heroNpc:getBlood()))[4] = ffa.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_ROADROUGH_MOVE_SHOW"
			;(nil).x = x
			;(nil).y = y
			SoraDSendMessage(nil)
		end)
		ffa.seq(ffa.seq(self.heroNpc:getBlood()))[5] = ffa.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_ROADROUGH_MOVE_SHOW"
			;(nil).x = x
			;(nil).y = y
			SoraDSendMessage(nil)
		end)
		ffa.seq(ffa.seq(self.heroNpc:getBlood()))[6] = ffa.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_ROADROUGH_MOVE_SHOW"
			;(nil).x = x
			;(nil).y = y
			SoraDSendMessage(nil)
		end)
		ffa.seq(ffa.seq(self.heroNpc:getBlood()))[7] = ffa.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_ROADROUGH_MOVE_SHOW"
			;(nil).x = x
			;(nil).y = y
			SoraDSendMessage(nil)
		end)
		ffa.seq(ffa.seq(self.heroNpc:getBlood()))[8] = ffa.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_ROADROUGH_MOVE_SHOW"
			;(nil).x = x
			;(nil).y = y
			SoraDSendMessage(nil)
		end)
		self:runAction(ffa.seq(ffa.seq(ffa.seq(self.heroNpc:getBlood()))))
	end
end
return RoadBoard
