local baseProxy = require("fgui.base.baseProxy")
local worldMapMonsterInfoProxy = class("worldMapMonsterInfoProxy", baseProxy)
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
function worldMapMonsterInfoProxy:onRegisterEvent()
	print("=======worldMapMonsterInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MONSTER_VERIFY_BACK", handler(self, self.serverMessage_RequestVerifyBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.serverMessage_RequestAllianceBack))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MONSTERSEARCH_DATAARRIVE", handler(self, self.msgBackData))
	SoraDAddMessage(self, "MESSAGE_SERVER_SEMLUK_BALL_REFRESH", function(target, data)
		SoraDCloseLoading(self.view)
		self.view.curKillSemlukNum = lordInfoCtrl:getKillSemlukNum()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ICE_HUNTING_MARKECT_REFRESH", function(target, data)
		SoraDCloseLoading(self.view)
		self.view.curKillIceHuntingNum = lordInfoCtrl:getKillSnowMansNum()
	end)
end
function worldMapMonsterInfoProxy:serverMessage_RequestMapInstaceInfo(...)
	self.view:serverMessage_RequestMapInstaceInfo(...)
end
function worldMapMonsterInfoProxy:serverMessage_RequestVerifyBack(...)
	self.view:serverMessage_RequestVerifyBack(...)
end
function worldMapMonsterInfoProxy:serverMessage_RequestAllianceBack(...)
	self.view:serverMessage_RequestAllianceBack(...)
end
function worldMapMonsterInfoProxy:msgBackData(...)
	self.view:msgBackData(...)
end
return worldMapMonsterInfoProxy
