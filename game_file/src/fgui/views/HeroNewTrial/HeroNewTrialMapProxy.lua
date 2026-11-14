local baseProxy = require("fgui.base.baseProxy")
local HeroNewTrialMapProxy = class("HeroNewTrialMapProxy", baseProxy)
function HeroNewTrialMapProxy:onRegisterEvent()
	print("=======HeroNewTrialMapProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_NEW_TRIAL_UPDATE", handler(self, self.onMsgUpdateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.playGameToIncrIntimacy))
end
function HeroNewTrialMapProxy:onMsgUpdateView(...)
	self.view:onMsgUpdateView(...)
end
function HeroNewTrialMapProxy:playGameToIncrIntimacy(...)
	self.view:playGameToIncrIntimacy(...)
end
function HeroNewTrialMapProxy:dumpLineInfo(...)
	local self = self.view
	local _ENV, ret
	for stage = 1, #self.comStageList - 1 do
		local pos1 = self:getComStagePos(stage)
		local pos2 = self:getComStagePos(stage + 1)
		local distance = cc.pGetDistance(pos1, pos2)
		local angle = SoraDGetAngleByPos(pos1, pos2)
		_ENV = nil
		;(nil).stage = stage
		;(nil).pos = pos1
		;(nil).distance = distance
		;(nil).angle = angle
		table.insert(ret, nil)
	end
	dump(ret, "==HeroNewTrialMapProxy:dumpLineInfo==")
end
function HeroNewTrialMapProxy:runActionTest(...)
	local self = self.view
	local _ENV, actionList
	local moveTime = 2
	local _ENV, moveData
	for stage = 1, #self.comStageList - 1 do
		do
			local pos1 = self:getComStagePos(stage)
			local pos2 = self:getComStagePos(stage + 1)
			local angle, isFlipX = self:getStageImgAngel(pos1, pos2)
			table.insert(actionList, ffa.callFunc(function(...)
				self.fieldsMap.mv_zhujue:setFlip(isFlipX and 1 or 0)
				local frameName = string.format(self.frameName, "dj", angle)
				self.fieldsMap.mv_zhujue:setAllFrameName(frameName, 1)
			end))
			table.insert(actionList, ffa.delay(moveTime))
			table.insert(actionList, ffa.callFunc(function(...)
				self.fieldsMap.mv_zhujue:setFlip(isFlipX and 1 or 0)
				local frameName = string.format(self.frameName, "yd", angle)
				self.fieldsMap.mv_zhujue:setAllFrameName(frameName, 1)
			end))
			table.insert(actionList, ffa.moveTo(moveTime, pos2.x, pos2.y))
			_ENV = ffa.moveTo(moveTime, pos2.x, pos2.y)
			ffa.moveTo(moveTime, pos2.x, pos2.y).stage = stage
			ffa.moveTo(moveTime, pos2.x, pos2.y).angle = angle
			ffa.moveTo(moveTime, pos2.x, pos2.y).isFlipX = isFlipX
			table.insert(moveData, ffa.moveTo(moveTime, pos2.x, pos2.y))
		end
	end
	dump(moveData, "==moveData==")
	local pos = self:getComStagePos(1)
	self.fieldsMap.mv_zhujue:setPosition(pos)
	self.fieldsMap.mv_zhujue:runAction(ffa.seq(actionList))
end
return HeroNewTrialMapProxy
