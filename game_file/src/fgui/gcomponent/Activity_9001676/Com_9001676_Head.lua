local baseComponent = require("fgui.base.baseComponent")
local Com_9001676_Head = fgui.extension_class(fgui.GComponent, baseComponent)
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001676_Read = include("activity_9001676_Read")
fgui.register_extension("ui://Activity_9001676/Com_9001676_Head", Com_9001676_Head)
function Com_9001676_Head:onInit()
	self.fields.txt_unready:setString(i18n("krone_text_45"))
	self.fields.txt_ready:setString(i18n("krone_text_33"))
	self.fields.Com_head:setHandle(handler(self, self.onHeadClick))
	self.AIPlayers = activity_9001676_Read.getAIPlayers()
end
function Com_9001676_Head:onShow()
	self.fields.cd:setVisible(false)
end
function Com_9001676_Head:onHide()
	self.playerData = nil
	self.isReady = false
	self.isHost = false
	self.isCanClick = false
end
function Com_9001676_Head:createMyHead()
	local lordInfo = lordInfoCtrl:getBaseInfo()
	self.fields.Com_head:setHeadSprite(lordInfo.imageId, lordInfo.avatar)
	self.fields.Com_head:getLoadHead():setAlpha(1)
	self.fields.txt_name:setString(lordInfo.nickName)
end
function Com_9001676_Head:createHeadByData(data)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:getLoadHead():setAlpha(1)
	self.fields.txt_name:setString(data.name)
	self.playerData = data
end
function Com_9001676_Head:createAiHead()
	self.aniHeadIdx = math.random(1, #self.AIPlayers)
	local AIPlayer = self.AIPlayers[self.aniHeadIdx]
	self.fields.Com_head:setImage(AIPlayer.head, false)
	self.fields.Com_head:getLoadHead():setAlpha(1)
	self.fields.txt_name:setString(i18n(AIPlayer.name))
end
function Com_9001676_Head:setWaiting()
	self.fields.Com_head:setHeadSprite("icon_nouser.png")
	self.fields.Com_head:getLoadHead():setAlpha(0.1)
	self:setState(3)
	self.playerData = nil
	self.isCanClick = false
end
function Com_9001676_Head:setState(idx)
	self.controllers.c2:setSelectedIndex(idx)
end
function Com_9001676_Head:setIsRead(isReady)
	self:setState(0)
	if isReady then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.isReady = isReady
end
function Com_9001676_Head:setIsHost(isHost)
	self.isHost = isHost
	if isHost then
		self.controllers.c1:setSelectedIndex(2)
	elseif self.isReady then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_9001676_Head:startMatchAni()
	self.controllers.c2:setSelectedIndex(2)
	self:stopMatchAni()
	self.timeMatchHandler = SoradCreateTimer(self, handler(self, self.updateMatchTime), true)
	self.aniHeadIdx = 1
	self:updateMatchTime(0.0)
end
local timeCount = 0
function Com_9001676_Head:updateMatchTime()
	if timeCount % 5 == 0 then
		self.aniHeadIdx = self.aniHeadIdx % #self.AIPlayers + 1
		local AIPlayer = self.AIPlayers[self.aniHeadIdx]
		self.fields.Com_head:setImage(AIPlayer.head, false)
		self.fields.Com_head:getLoadHead():setAlpha(1)
	end
end
function Com_9001676_Head:stopMatchAni()
	if self.timeMatchHandler then
		SoraDManagerRemoveTimer(self, self.timeMatchHandler)
	end
end
function Com_9001676_Head:stopCountDownAni()
	if self.timeCountDownHandler ~= nil then
		SoraDManagerRemoveTimer(self, self.timeCountDownHandler)
		self.timeCountDownHandler = nil
	end
	self.fields.cd:setVisible(false)
end
function Com_9001676_Head:startCountDownAni(cdTime, timeUpCallback)
	if self.timeCountDownHandler ~= nil then
		SoraDManagerRemoveTimer(self, self.timeCountDownHandler)
		self.timeCountDownHandler = nil
	end
	self.timeCountDownHandler = SoradCreateTimer(self, handler(self, self.updateCountDownTime), nil, nil, true)
	self.cdTime = cdTime
	self.timeUpCallback = timeUpCallback
	self.fields.cd:setVisible(true)
	self.fields.cd:setMax(self.cdTime)
	self.fields.cd:setValue(self.cdTime)
end
function Com_9001676_Head:updateCountDownTime()
	self.cdTime = self.cdTime - 1
	self.fields.cd:setValue(self.cdTime)
	if self.cdTime <= 0 and self.timeCountDownHandler ~= nil then
		SoraDManagerRemoveTimer(self, self.timeCountDownHandler)
		self.timeCountDownHandler = nil
		if self.timeUpCallback then
			self.timeUpCallback()
		end
	end
end
function Com_9001676_Head:setIsCanClick(value)
	self.isCanClick = value
end
function Com_9001676_Head:onHeadClick()
	SoraDPlaySound()
	if not self.isCanClick then
		return
	end
	_ENV = nil
	;(nil).playerData = self.playerData
	;(nil).isHost = self.isHost
	uiManager:show("Activity_9001676_Player", nil)
end
return Com_9001676_Head
