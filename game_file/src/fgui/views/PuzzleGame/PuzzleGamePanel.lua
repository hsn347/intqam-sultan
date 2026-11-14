local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PuzzleGamePanel = class("PuzzleGamePanel", baseFguiPanel)
function PuzzleGamePanel:ctor(...)
	self.super.ctor(self, ...)
	print("PuzzleGamePanel:ctor", self.viewName)
end
function PuzzleGamePanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "fonts"
	end
	return self._packageList
end
function PuzzleGamePanel:onInit()
	print("=======PuzzleGamePanel:onInit")
	self.canTouch = false
	self.rightNum = 0
	self.originPosList, _ENV, self.posList, _ENV, self.playTime = print, print, print, print, 30
	self.fields.Com_title:initData(i18n("ramadan_world_explorer_text_0009"), handler(self, self.onClickClose))
	_ENV = i18n("ramadan_world_explorer_text_0009")
	i18n("ramadan_world_explorer_text_0009").callback = handler(self, self.onGameStart)
	self.fields.node_start:startGame((i18n("ramadan_world_explorer_text_0009")))
end
function PuzzleGamePanel:onGameStart()
	self.canTouch = true
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:beginTime(self.playTime, false, true)
	self.fields.Text_time:setTimeEndListener(handler(self, self.timeOver))
end
function PuzzleGamePanel:getPosList()
	for i = 1, 9 do
		local pos = self.fields["n" .. i - 1]:getPosition()
		local size = self.fields["n" .. i - 1]:getContentSize()
		print(size.width, size.height, "size")
		_UPVALUE3_ = size.height
		size.height[1] = cc.p(pos.x, pos.y + size.height / 2)
		size.height[2] = cc.p(pos.x + size.width / 2, pos.y)
		size.height[3] = cc.p(pos.x, pos.y - size.height / 2)
		size.height[4] = cc.p(pos.x - size.width / 2, pos.y)
		size.height[5] = cc.p(pos.x - size.width / 2, pos.y)
		size.height[6] = cc.p(pos.x - size.width / 2, pos.y)
		table.insert(self.posList, size.height)
	end
	dump(self.posList, "self.posList")
end
function PuzzleGamePanel:timeOver()
	self.isGameOver = true
	self:showResult(false)
end
function PuzzleGamePanel:showResult(isWin)
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
function PuzzleGamePanel:onShow()
	self:getPosList()
	self.beginPos = cc.p(self.fields.bg:getPosition().x, self.fields.bg:getPosition().y + 255)
	self:updateEffect()
	print("=======PuzzleGamePanel:onShow")
end
function PuzzleGamePanel:updateEffect()
	local randMap = SoraDGetRandList(9)
	print(self.beginPos.x, "self.beginPos", self.beginPos.y)
	local beginx = self.beginPos.x - 320
	local beginy = self.beginPos.y
	for i = 1, 9 do
		local index = randMap[i]
		self.fields["n_" .. i - 1]:setTag(index)
		self.fields["n_" .. i - 1]:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onImageTouchBegin))
		self.fields["n_" .. i - 1]:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onImageTouchMove))
		self.fields["n_" .. i - 1]:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onImageTouchEnd))
		local nameImage = string.format("SinglePicture/frame_WorldExplorer_pt_sp_%.2d.png", index)
		_ENV = 0
		;(0).x = -0.02
		;(0).y = -0.05
		local sp = SoraDCreateShadowSprite(nameImage, cc.c3b(0, 0, 0), 0.5, 0)
		local size = sp:getContentSize()
		sp:setPosition(cc.p(0, 0))
		self.fields["n_" .. i - 1]:setContentSize(size)
		self.fields["n_" .. i - 1]:getChild("iconShader"):setContent(sp)
		local width = self.fields["n_" .. i - 1]:getContentSize().width * 0.65
		print("width", beginx, width, index, beginx + width, self.beginPos.x + 320)
		if beginx + width > self.beginPos.x + 320 then
			beginy = beginy + 120
			beginx = self.beginPos.x - 320
		end
		self.originPosList[index] = cc.p(beginx + width / 2, beginy)
		self.fields["n_" .. i - 1]:setPosition(self.originPosList[index])
		beginx = beginx + width
	end
end
function PuzzleGamePanel:onImageTouchBegin(eventContext)
	if not self.canTouch or self.touchTarget then
		return
	end
	self.touchBegin = true
	self.touchTarget = eventContext:getSender()
	self.touchTarget:setScale(1)
	local touchmovePoint = eventContext:getInput():getPosition()
	print("onImageTouchMove", touchmovePoint.x, touchmovePoint.y)
	self.touchTarget:setPosition(cc.pMul(touchmovePoint, 1 / self:getScale()))
	local sp = self.touchTarget:getChild("iconShader"):getContent()
	self.touchTarget:displayObject():setLocalZOrder(999)
	_ENV = 0
	;(0).x = -0.002
	;(0).y = -0.005
	SoraDCreateShadowSprite(sp, cc.c3b(0, 0, 0), 0, 0)
	eventContext:captureTouch()
end
function PuzzleGamePanel:onImageTouchMove(eventContext)
	if not self.canTouch or self.touchTarget ~= eventContext:getSender() then
		return
	end
	local touchmovePoint = eventContext:getInput():getPosition()
	eventContext:getSender():setPosition(cc.pMul(touchmovePoint, 1 / self:getScale()))
end
function PuzzleGamePanel:onImageTouchEnd(eventContext)
	if not self.canTouch or self.touchTarget ~= eventContext:getSender() then
		return
	end
	print("onImageTouchEnd")
	local target = eventContext:getSender()
	local index = target:getTag()
	local pos = target:getPosition()
	local ret = SorDIsPointInPolygon(self.posList[index], pos)
	print(pos.x, pos.y, ret, index, self.posList[index][1].x, self.posList[index][1].y)
	if ret then
		target:setPosition(self.fields["n" .. index - 1]:getPosition())
		target:setTouchEnabled(false)
		local sp = target:getChild("iconShader"):getContent()
		SoraDCreateStrokeSprite2(sp, cc.c3b(235, 235, 0), 1, 0.03, 0.8)
		self.rightNum = self.rightNum + 1
		_UPVALUE1_ = 1
		;(1)[1] = ffa.delay(1)
		;(1)[2] = ffa.callFunc(function()
			local sp = target:getChild("iconShader"):getContent()
			target = 0
			;(0).x = -0.02
			;(0).y = -0.05
			SoraDCreateShadowSprite(sp, cc.c3b(0, 0, 0), 0, 0)
			target:displayObject():setLocalZOrder(index)
			if self.rightNum == 9 then
				self:showResult(true)
			end
		end)
		;(1)[3] = ffa.callFunc(function()
			local sp = target:getChild("iconShader"):getContent()
			target = 0
			;(0).x = -0.02
			;(0).y = -0.05
			SoraDCreateShadowSprite(sp, cc.c3b(0, 0, 0), 0, 0)
			target:displayObject():setLocalZOrder(index)
			if self.rightNum == 9 then
				self:showResult(true)
			end
		end)
		self:runAction(ffa.seq(1))
	else
		target:setPosition(self.originPosList[index])
		target:setScale(0.65)
		local sp = target:getChild("iconShader"):getContent()
		_ENV = 0
		;(0).x = -0.02
		;(0).y = -0.05
		SoraDCreateShadowSprite(sp, cc.c3b(0, 0, 0), 0.5, 0)
		target:displayObject():setLocalZOrder(index)
		SoraDShowMsgTip(i18n("ramadan_world_explorer_text_0028"))
	end
	self.touchTarget = nil
end
function PuzzleGamePanel:onClickClose()
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
return PuzzleGamePanel
