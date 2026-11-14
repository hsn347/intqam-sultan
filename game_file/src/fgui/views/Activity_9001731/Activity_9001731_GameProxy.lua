local baseProxy = require("fgui.base.baseProxy")
local Activity_9001731_GameProxy = class("Activity_9001731_GameProxy", baseProxy)
function Activity_9001731_GameProxy:onRegisterEvent()
	print("=======Activity_9001731_GameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_ROOM", handler(self, self.roomUpdate))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_START", handler(self, self.startGame))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_PLAYER", handler(self, self.changePlayer))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_ROLL", handler(self, self.rollShow))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_MOVE", handler(self, self.moveShow))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_USEITEM", handler(self, self.useItem))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_ITEMCREATE", handler(self, self.itemCreate))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_LAST_FINISH", handler(self, self.endGuide))
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_NEW_MESSAGE", handler(self, self.messageShow))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_GAMEOVER", handler(self, self.gameOver))
end
function Activity_9001731_GameProxy:roomUpdate(target, data)
	self.view:roomUpdate(target, data)
end
function Activity_9001731_GameProxy:startGame(target, data)
	self.view:startGame(target, data)
end
function Activity_9001731_GameProxy:changePlayer(target, data)
	self.view:changePlayer(target, data)
end
function Activity_9001731_GameProxy:rollShow(target, data)
	self.view:rollShow(target, data)
end
function Activity_9001731_GameProxy:moveShow(target, data)
	self.view:moveShow(target, data)
end
function Activity_9001731_GameProxy:useItem(target, data)
	self.view:useItem(target, data)
end
function Activity_9001731_GameProxy:itemCreate(target, data)
	self.view:itemCreate(target, data)
end
function Activity_9001731_GameProxy:messageShow(target, data)
	self.view:messageShow(target, data)
end
function Activity_9001731_GameProxy:endGuide(target, data)
	self.view:endGuide(target, data)
end
function Activity_9001731_GameProxy:gameOver(target, data)
	self.view:gameOver(target, data)
end
return Activity_9001731_GameProxy
