local gametop = gModuleMgr.getObject("gametop")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
local worldMapWarTip = class("worldMapWarTip", function()
	return SoraDCreateBasePanel("worldMapPyramidTip")
end)
function worldMapWarTip:ctor()
	self.txtTime = SoraDGetChildByName(self, "Text_tip")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
end
function worldMapWarTip:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.updateData))
end
function worldMapWarTip:onEnterPanel()
	self:updateData()
end
function worldMapWarTip:updateData()
	local localBattleState = conquestWarCtrl:getConquestWarState()
	if localBattleState and gConquestWarState.OPENING == localBattleState then
		self:setVisible(false)
		local time = conquestWarCtrl:getLeftTime()
		if 0 < time then
			self.txtTime:setTimeLast(function(str, tick)
				if tick <= 60 then
					self:setVisible(true)
					self = true
					;(true).time = str
					local reText = i18n("common_text_3555", true)
					return reText
				end
				return ""
			end)
			self.txtTime:setTimeEndListener(function(...)
				self:setVisible(false)
				self.txtTime:setTimeEndListener(nil)
			end)
			self.txtTime:beginTime(time)
		end
	else
		self:setVisible(false)
		self.txtTime:endTime()
	end
end
return worldMapWarTip
