local foreignPavilionRead = include("foreignPavilionRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LinkLinkViewPanel = class("LinkLinkViewPanel", baseFguiPanel)
function LinkLinkViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("LinkLinkViewPanel:ctor", self.viewName)
end
function LinkLinkViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "LinkLinkGame"
		self._packageList, self._packageList[3] = self._packageList, "CommonNew"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function LinkLinkViewPanel:onInit()
	print("=======LinkLinkViewPanel:onInit")
	self.itemList, _ENV = print, print
	self.chooseIndex = nil
	self.maxX = 6
	self.maxY = 7
	self.path, _ENV, self.playTime = print, print, 80
	self.resetTime = 0
	self.isGameOver = false
	self.isLinking = false
	self.fields.Com_title:initData(i18n("exitic_pavillion_text_0124"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Btn_reset:setTitle(i18n("common_text_4152"))
	self.fields.Btn_reset:addClickListener(handler(self, self.onResetClick))
	local resetAni = fguiHelper.get_fields(self.fields.Btn_reset).ani
	resetAni:setAllFrameName("dh_llkcz1_%02d.png", 1)
	resetAni:setPlaySettings(0, -1, -1)
	self.resetAni = resetAni
	self.resetAni:setVisible(false)
	if display.height < 960 then
		self.fields.Btn_reset:setScale(0.6)
		self.fields.Text_time:setScale(0.6)
	end
	if display.height >= 1136 then
		self.fields.Btn_reset:setPositionY(140)
		self.fields.Text_time:setPositionY(130)
	end
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setNeedAutoFix(false)
	self.fields.Text_time:setString(self.playTime)
	_ENV = self.playTime
	self.playTime.callback = handler(self, self.onGameStart)
	self.fields.node_start:startGame(self.playTime)
end
function LinkLinkViewPanel:onGameStart()
	self:startDelayShine()
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:beginTime(self.playTime, false, true)
	self.fields.Text_time:setTimeEndListener(handler(self, self.timeOver))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
end
function LinkLinkViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index], index, self.isLinking, index == self.chooseIndex)
end
function LinkLinkViewPanel:onShow()
	print("=======LinkLinkViewPanel:onShow")
	self:initBoard()
	self.fields.List:setNumItems(self.maxX * self.maxY)
end
function LinkLinkViewPanel:onHide()
	print("=======LinkLinkViewPanel:onHide")
end
function LinkLinkViewPanel:onDispose()
	print("=======LinkLinkViewPanel:onDispose")
end
function LinkLinkViewPanel:initBoard()
	local heroArray = foreignPavilionRead.getLinkgame()
	_UPVALUE25_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 1
	;(nil)[3] = 2
	;(nil)[4] = 3
	;(nil)[5] = 4
	;(nil)[6] = 5
	;(nil)[7] = 6
	;(nil)[8] = 7
	;(nil)[9] = 8
	;(nil)[10] = 9
	;(nil)[11] = 10
	;(nil)[12] = 11
	;(nil)[13] = 12
	;(nil)[14] = 13
	;(nil)[15] = 14
	;(nil)[16] = 15
	;(nil)[17] = 16
	;(nil)[18] = 17
	;(nil)[19] = 24
	;(nil)[20] = 25
	;(nil)[21] = 26
	;(nil)[22] = 27
	;(nil)[23] = 28
	;(nil)[24] = 29
	;(nil)[25] = 30
	;(nil)[26] = 31
	;(nil)[27] = 32
	;(nil)[28] = 33
	;(nil)[29] = 34
	;(nil)[30] = 35
	;(nil)[31] = 36
	;(nil)[32] = 37
	;(nil)[33] = 38
	;(nil)[34] = 39
	;(nil)[35] = 40
	local (nil)[36], boardIndex = 41, nil
	local foreignPavilionRead, boardArray = 0, 0
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	for i = 1, #heroArray do
		local heroID = table.remove(heroArray, math.random(1, #heroArray))
		local r1 = table.remove(boardIndex, math.random(1, #boardIndex))
		local r2 = table.remove(boardIndex, math.random(1, #boardIndex))
		foreignPavilionRead = boardIndex
		boardIndex.heroID = heroID
		foreignPavilionRead, boardArray[r1], boardIndex.pos = boardIndex, boardIndex, self:indexToPos(r1)
		boardIndex.heroID = heroID
		boardArray[r2], boardIndex.pos = boardIndex, self:indexToPos(r2)
	end
	self.itemList = boardArray
end
function LinkLinkViewPanel:updateBoard()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	local _ENV, heroArray = math.randomseed, math.randomseed
	local _ENV, boardIndex = tostring(os.time()):reverse():sub(1, 6) * math.random(), tostring(os.time()):reverse():sub(1, 6) * math.random()
	local _ENV, boardArray = math.random(), math.random()
	for k, v in pairs(self.itemList) do
		if not SoraDisInList(v.heroID, heroArray) then
			table.insert(heroArray, v.heroID)
		end
		table.insert(boardIndex, k)
	end
	for i = 1, #heroArray do
		local heroID = table.remove(heroArray, math.random(1, #heroArray))
		local r1 = table.remove(boardIndex, math.random(1, #boardIndex))
		local r2 = table.remove(boardIndex, math.random(1, #boardIndex))
		_ENV = boardIndex
		boardIndex.heroID = heroID
		_ENV, boardArray[r1], boardIndex.pos = boardIndex, boardIndex, self:indexToPos(r1)
		boardIndex.heroID = heroID
		boardArray[r2], boardIndex.pos = boardIndex, self:indexToPos(r2)
	end
	self.itemList = boardArray
	self.fields.List:setNumItems(self.maxX * self.maxY)
end
function LinkLinkViewPanel:timeUpdate()
	if self.resetTime > 0 then
		self.resetTime = self.resetTime - 1
	end
end
function LinkLinkViewPanel:onResetClick()
	SoraDPlaySound()
	if self.isGameOver then
		return
	end
	if self.resetTime > 0 then
		SoraDShowMsgTip(i18n("exitic_pavillion_text_0112"))
	else
		SoraDPlaySound("innerbuildsound", 205)
		self.chooseIndex = nil
		self:updateBoard()
		self.resetTime = 3
		self:startDelayShine()
	end
end
function LinkLinkViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("exitic_pavillion_text_0111")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function LinkLinkViewPanel:isPosInPath(pos, list)
	for k, v in ipairs(list) do
		if v.x == pos.x and v.y == pos.y then
			return true
		end
	end
	return false
end
function LinkLinkViewPanel:drawOneLine(pos1, pos2, v, h)
	local line = fgui.UIPackage:createObjectFromURL("ui://LinkLinkGame/LinkRect")
	local fields = fguiHelper.get_fields(line)
	local r = fields.r
	local l = fields.l
	r:setAllFrameName("dh_llk3_%02d.png", 0)
	r:setPlaySettings(0, -1, -1)
	l:setAllFrameName("dh_llk3_%02d.png", 0)
	l:setPlaySettings(0, -1, -1)
	local pivot = 0
	if v and pos1.x > pos2.x then
		pivot = 1
	end
	if h and pos1.y > pos2.y then
		pivot = 1
	end
	if pos1.x == pos2.x then
		line:setSize(40, 100 * (math.max(pos1.y, pos2.y) - math.min(pos1.y, pos2.y)))
		r:setVisible(true)
		l:setVisible(false)
		line:setPivot(0.5, pivot)
	elseif pos1.y == pos2.y then
		line:setSize(100 * (math.max(pos1.x, pos2.x) - math.min(pos1.x, pos2.x)), 40)
		r:setVisible(false)
		l:setVisible(true)
		line:setPivot(pivot, 0.5)
	end
	return line
end
function LinkLinkViewPanel:drawLine()
	_ENV = nil
	;(nil).msg = "MESSAGE_LINKLINK_SHADOW"
	;(nil).isShadow = true
	SoraDSendMessage(nil)
	local _ENV, newPath = SoraDSendMessage, SoraDSendMessage
	for k, v in ipairs(self.path) do
		if not self:isPosInPath(v, newPath) then
			table.insert(newPath, v)
		end
	end
	local _ENV, sortPath = (for generator), ipairs(self.path)
	local oriPos = newPath[1]
	table.insert(sortPath, oriPos)
	newPath[1].isJoin = true
	while #sortPath < #newPath do
		for k, v in pairs(newPath) do
			if not v.isJoin and self:isNeighbor(oriPos, v) then
				table.insert(sortPath, v)
				oriPos = v
				v.isJoin = true
			end
		end
	end
	local _ENV, finalPath = pairs(newPath)
	local isToEnd = false
	for k, v in ipairs(sortPath) do
		if v.x == self.itemList[self.curIndex].x and v.y == self.itemList[self.curIndex].y then
			table.insert(finalPath, v)
			isToEnd = true
		elseif not isToEnd then
			table.insert(finalPath, v)
		end
	end
	dump(finalPath, "finalPath=====", 20)
	local index = 1
	local tmpNode = finalPath[index]
	local _ENV, lineArray = "finalPath=====", "finalPath====="
	local hbPos, hePos, lbPos, lePos
	while index < #finalPath do
		index = index + 1
		if finalPath[index].x == tmpNode.x then
			lbPos = lbPos or tmpNode
			lePos = finalPath[index]
			if hbPos and hePos then
				_ENV = nil
				;(nil).beginPos = hbPos
				;(nil).endPos = hePos
				;(nil).isH = true
				table.insert(lineArray, nil)
				hbPos = nil
			end
		elseif finalPath[index].y == tmpNode.y then
			hbPos = hbPos or tmpNode
			hePos = finalPath[index]
			if lbPos and lePos then
				_ENV = nil
				;(nil).beginPos = lbPos
				;(nil).endPos = lePos
				;(nil).isL = true
				table.insert(lineArray, nil)
				lbPos = nil
			end
		end
		tmpNode = finalPath[index]
		if index == #finalPath then
			if hbPos and hePos then
				_ENV = nil
				;(nil).beginPos = hbPos
				;(nil).endPos = hePos
				;(nil).isH = true
				table.insert(lineArray, nil)
				hbPos = nil
			end
			if lbPos and lePos then
				_ENV = nil
				;(nil).beginPos = lbPos
				;(nil).endPos = lePos
				;(nil).isL = true
				table.insert(lineArray, nil)
				lbPos = nil
			end
		end
	end
	for k, v in ipairs(lineArray) do
		local line = self:drawOneLine(v.beginPos, v.endPos, v.isH, v.isL)
		line:setPosition(v.beginPos.x * 100 + 30, v.beginPos.y * 100 + 50)
		local isFX = false
		local isFY = false
		if line:getPivot().y == 1 then
			line:setPositionY(v.beginPos.y * 100 + 50 - line:getSize().height)
		end
		if v.isH then
			line:setScaleX(0)
		end
		if v.isL then
			line:setScaleY(0)
		end
		if v.beginPos.x ~= v.endPos.x then
			line:setPosition(v.beginPos.x * 100 + 50, v.beginPos.y * 100 + 30)
		end
		if line:getPivot().x == 1 then
			line:setPositionX(v.beginPos.x * 100 + 50 - line:getSize().width)
		end
		self.fields.line:addChild(line)
		_UPVALUE3_ = line:getSize().width
		line:getSize().width[1] = ffa.delay(0.05 * (k - 1))
		line:getSize().width[2] = ffa.scaleTo(0.05, isFX and -1 or 1, isFY and -1 or 1)
		line:getSize().width[3] = ffa.delay(0.05 * #lineArray)
		line:getSize().width[4] = ffa.callFunc(function()
			self:breakTwoPice(self.curIndex)
		end)
		line:getSize().width[5] = ffa.callFunc(function()
			self:breakTwoPice(self.curIndex)
		end)
		line:runAction(ffa.seq(line:getSize().width))
	end
end
function LinkLinkViewPanel:breakTwoPice(index)
	if self.itemList[index] and self.itemList[self.chooseIndex] then
		SoraDPlaySound("artifactSound", "qizhi")
		self.fields.List:getChildAt(self.chooseIndex):showBreak()
		self.fields.line:removeAllChildren()
		self.fields.List:getChildAt(index):showBreak(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_LINKLINK_SHADOW"
			;(nil).isShadow = false
			SoraDSendMessage(nil)
			if table.nums(self.itemList) == 0 then
				self:showResult(true)
			end
		end)
		self.itemList[index] = nil
		self.itemList[self.chooseIndex] = nil
		self.chooseIndex = nil
	end
end
function LinkLinkViewPanel:updateClick(isShadow)
	self.isLinking = isShadow
	self.fields.List:setNumItems(self.maxX * self.maxY)
end
function LinkLinkViewPanel:judgeLink(index)
	self:startDelayShine()
	if not self.chooseIndex and self.itemList[index] then
		self.chooseIndex = index
	else
		if self.chooseIndex ~= index and self.itemList[index] and self.itemList[self.chooseIndex] and self.itemList[index].heroID == self.itemList[self.chooseIndex].heroID then
			if not self:isNeighbor(self.itemList[self.chooseIndex].pos, self.itemList[index].pos) then
				local isLinked = self:isLink(self.itemList[self.chooseIndex].pos, self.itemList[index].pos)
				if isLinked then
					self.curIndex = index
					self:drawLine()
				else
					self.chooseIndex = nil
					self.fields.List:setNumItems(self.maxX * self.maxY)
				end
			else
				self:breakTwoPice(index)
			end
		else
			self.chooseIndex = nil
			self.fields.List:setNumItems(self.maxX * self.maxY)
		end
		self.path, _UPVALUE0_ = self.fields.List.setNumItems, self.fields.List.setNumItems
	end
end
function LinkLinkViewPanel:timeOver()
	self.isGameOver = true
	self:showResult(false)
end
function LinkLinkViewPanel:showResult(isWin)
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
	else
		_ENV = nil
		;(nil).type = 2
		;(nil).isWin = isWin
		;(nil).isInStory = self.isInStory
		uiManager:show("ForeignPsettlement", nil)
	end
end
function LinkLinkViewPanel:indexToPos(index)
	return cc.p(index % self.maxX, math.floor(index / self.maxX))
end
function LinkLinkViewPanel:posToIndex(pos)
	return pos.x + pos.y * self.maxX
end
function LinkLinkViewPanel:isBlocked(pos)
	return self.itemList[self:posToIndex(pos)] and true or false
end
function LinkLinkViewPanel:isNeighbor(pos1, pos2)
	return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y) == 1
end
function LinkLinkViewPanel:horizon(pos1, pos2)
	if pos1.x ~= pos2.x then
		return false
	end
	local curX = pos1.x
	local minY = math.min(pos1.y, pos2.y)
	local maxY = math.max(pos1.y, pos2.y)
	if maxY - 1 < minY + 1 then
		return not self:isBlocked(pos1) or not self:isBlocked(pos2)
	else
		for i = minY + 1, maxY - 1 do
			if self:isBlocked(cc.p(curX, i)) then
				return false
			end
		end
	end
	return true
end
function LinkLinkViewPanel:getHorizonPath(pos1, pos2)
	local minY = math.min(pos1.y, pos2.y)
	local maxY = math.max(pos1.y, pos2.y)
	if maxY - 1 < minY + 1 then
		if not self:isBlocked(pos1) then
			table.insert(self.path, pos1)
		end
		if not self:isBlocked(pos2) then
			table.insert(self.path, pos2)
		end
	else
		for i = minY + 1, maxY - 1 do
			table.insert(self.path, cc.p(pos1.x, i))
		end
	end
end
function LinkLinkViewPanel:vertical(pos1, pos2)
	if pos1.y ~= pos2.y then
		return false
	end
	local curY = pos1.y
	local minX = math.min(pos1.x, pos2.x)
	local maxX = math.max(pos1.x, pos2.x)
	if maxX - 1 < minX + 1 then
		return not self:isBlocked(pos1) or not self:isBlocked(pos2)
	else
		for i = minX + 1, maxX - 1 do
			if self:isBlocked(cc.p(i, curY)) then
				return false
			end
		end
	end
	return true
end
function LinkLinkViewPanel:getVerticalPath(pos1, pos2)
	local minX = math.min(pos1.x, pos2.x)
	local maxX = math.max(pos1.x, pos2.x)
	if maxX - 1 < minX + 1 then
		if not self:isBlocked(pos1) then
			table.insert(self.path, pos1)
		end
		if not self:isBlocked(pos2) then
			table.insert(self.path, pos2)
		end
	else
		for i = minX + 1, maxX - 1 do
			table.insert(self.path, cc.p(i, pos1.y))
		end
	end
end
function LinkLinkViewPanel:turnOnce(pos1, pos2)
	local tp1 = cc.p(pos1.x, pos2.y)
	local tp2 = cc.p(pos2.x, pos1.y)
	local ret = false
	if not self:isBlocked(tp1) then
		ret = self:horizon(pos1, tp1) and self:vertical(tp1, pos2)
	end
	if not ret and not self:isBlocked(tp2) then
		ret = self:vertical(pos1, tp2) and self:horizon(tp2, pos2)
	end
	return ret
end
function LinkLinkViewPanel:getTurnOncePath(pos1, pos2)
	local tp1 = cc.p(pos1.x, pos2.y)
	local tp2 = cc.p(pos2.x, pos1.y)
	local ret = false
	if not self:isBlocked(tp1) then
		ret = self:horizon(pos1, tp1) and self:vertical(tp1, pos2)
		if ret then
			self:getHorizonPath(pos1, tp1)
			table.insert(self.path, tp1)
			self:getVerticalPath(tp1, pos2)
		end
	end
	if not ret and not self:isBlocked(tp2) then
		ret = self:vertical(pos1, tp2) and self:horizon(tp2, pos2)
		if ret then
			self:getVerticalPath(pos1, tp2)
			table.insert(self.path, tp2)
			self:getHorizonPath(tp2, pos2)
		end
	end
end
function LinkLinkViewPanel:turnTwice(pos1, pos2)
	for i = 0, self.maxX - 1 do
		local j = 0
		while j <= self.maxY - 1 do
			if not self:isBlocked(cc.p(i, j)) and self:turnOnce(pos1, cc.p(i, j)) and (self:horizon(cc.p(i, j), pos2) or self:vertical(cc.p(i, j), pos2)) then
				return true
			end
			if not self:isBlocked(cc.p(i, j)) and self:turnOnce(cc.p(i, j), pos2) and (self:horizon(pos1, cc.p(i, j)) or self:vertical(pos1, cc.p(i, j))) then
				return true
			end
			j = j + 1
		end
	end
	return false
end
function LinkLinkViewPanel:getTurnTwicePath(pos1, pos2)
	for i = 0, self.maxX - 1 do
		local j = 0
		while j <= self.maxY - 1 do
			if not self:isBlocked(cc.p(i, j)) and self:turnOnce(pos1, cc.p(i, j)) and (self:horizon(cc.p(i, j), pos2) or self:vertical(cc.p(i, j), pos2)) then
				self:getTurnOncePath(pos1, cc.p(i, j))
				table.insert(self.path, cc.p(i, j))
				if self:horizon(cc.p(i, j), pos2) then
					self:getHorizonPath(cc.p(i, j), pos2)
				end
				if self:vertical(cc.p(i, j), pos2) then
					self:getVerticalPath(cc.p(i, j), pos2)
				end
				return
			end
			if not self:isBlocked(cc.p(i, j)) and self:turnOnce(cc.p(i, j), pos2) and (self:horizon(pos1, cc.p(i, j)) or self:vertical(pos1, cc.p(i, j))) then
				self:getTurnOncePath(cc.p(i, j), pos2)
				table.insert(self.path, cc.p(i, j))
				if self:horizon(pos1, cc.p(i, j)) then
					self:getHorizonPath(pos1, cc.p(i, j))
				end
				if self:vertical(pos1, cc.p(i, j)) then
					self:getVerticalPath(pos1, cc.p(i, j))
				end
				return
			end
			j = j + 1
		end
	end
end
function LinkLinkViewPanel:isLink(pos1, pos2)
	local rl1 = self:horizon(pos1, pos2)
	local rl2 = self:vertical(pos1, pos2)
	local rl3 = self:turnOnce(pos1, pos2)
	local rl4 = self:turnTwice(pos1, pos2)
	local ret = rl1 or rl2 or rl3 or rl4
	local isInsert = false
	if ret then
		table.insert(self.path, pos1)
		if not isInsert and rl1 then
			self:getHorizonPath(pos1, pos2)
			isInsert = true
		end
		if not isInsert and rl2 then
			self:getVerticalPath(pos1, pos2)
			isInsert = true
		end
		if not isInsert and rl3 then
			self:getTurnOncePath(pos1, pos2)
			isInsert = true
		end
		if not isInsert and rl4 then
			self:getTurnTwicePath(pos1, pos2)
			isInsert = true
		end
		table.insert(self.path, pos2)
	end
	return ret
end
function LinkLinkViewPanel:onClickClose()
	self.msgPanel = SoraDShowMsgBoxNew(i18n("exitic_pavillion_text_0118"), nil, i18n("common_text_185"), function(exitType)
		self.msgPanel = nil
		if exitType == MSGBOX_CALLBACK_YES then
			if self.isGameOver then
				return
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
			;(nil).isWin = false
			;(nil).gameType = 2
			;(nil)[1] = false
			SoraDSendMessage(nil)
		end
	end)
end
function LinkLinkViewPanel:startDelayShine()
	self.resetAni:setVisible(false)
	self.resetAni:stopAllActions()
	self.resetAni:runAction(ffa.seq(ffa.delay(5), ffa.callFunc(function()
		self.resetAni:setVisible(true)
	end)))
end
return LinkLinkViewPanel
