local worldMapTroopTip = class("worldMapTroopTip", function()
	local view = include("baseView").new(display.size, false)
	return view
end)
function worldMapTroopTip:ctor()
	self.troopInstance = nil
	self.moveLineID = nil
	self.moveLine = nil
	self:addTouchEventListener(function(ref, type)
		self:viewOnClick(ref, type)
	end)
end
function worldMapTroopTip:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TIPBUTTON_TOUCHCALL", handler(self, self.tipButtonTouchCall))
end
function worldMapTroopTip:initData(moveLine)
	self.moveLine = moveLine
	self.troopInstance = moveLine:getTroopInstance()
	self.moveLineID = moveLine:getMoveLineID()
	local kingdomID = self.moveLine:getKingdomID()
	self.buttonsTip = include("worldMapTip").new(kingdomID)
	self.buttonsTip:setPosition(cc.p(display.cx, display.cy))
	self.buttonsTip:setTilePoint(self.moveLine:getShowTilePointEnd())
	self.buttonsTip:initMoveLineData(self.troopInstance)
	self:addChild(self.buttonsTip, 1)
end
function worldMapTroopTip:viewOnClick(ref, type)
	if type == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPTIP"
		;(nil).moveLineID = self.moveLineID
		SoraDSendMessage(nil)
	end
end
function worldMapTroopTip:setMoveLineID(moveLineID)
	self.moveLineID = moveLineID
end
function worldMapTroopTip:getMoveLineID()
	return self.moveLineID
end
function worldMapTroopTip:show()
	local parent = display.getRunningScene()
	parent:addChild(self, 2)
end
function worldMapTroopTip:close()
	local _ENV, actionsArray
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.3)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:removeFromParent()
	end)
	local actions = transition.sequence(actionsArray)
	self:runAction(actions)
end
function worldMapTroopTip:tipButtonTouchCall(target, data)
	local tipButtonType = data.tipButtonType
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPTIP"
	;(nil).moveLineID = self.moveLineID
	SoraDSendMessage(nil)
end
return worldMapTroopTip
