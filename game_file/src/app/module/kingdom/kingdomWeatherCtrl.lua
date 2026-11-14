local gamemodulec = include("GameModule")
local msgCtrl = include("msgCtrl")
local kingdomWeatherCtrl = class("kingdomWeatherCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local cityBuildConstDef = include("cityBuildConstDef")
function kingdomWeatherCtrl:ctor(properties)
	kingdomWeatherCtrl.super.ctor(self, properties)
end
function kingdomWeatherCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KINGDOM_COMMON_MODULE, gCmd.REQ_GET_KINGDOM_WEATHER, handler(self, self.getKingdomWeatherRsp))
end
function kingdomWeatherCtrl:resetData()
	self.weatherType = nil
	self.oriWType = nil
end
function kingdomWeatherCtrl:Logout()
	kingdomWeatherCtrl.super.Logout(self)
	self:resetData()
end
function kingdomWeatherCtrl:setKingdomWeather(wType, owType)
	self.weatherType = wType
	self.oriWType = owType
end
function kingdomWeatherCtrl:getKingdomWeather(...)
	return self.weatherType, self.oriWType
end
function kingdomWeatherCtrl:initNotifyHandle(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WEATHER, handler(self, self.notifyWeatherChange))
end
function kingdomWeatherCtrl:notifyWeatherChange(respone)
	self.weatherType = respone.data[1].wType
	self.oriWType = respone.data[1].owType
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_WEATHER_NOTIFY_MSG"
	;(nil).wType = self.weatherType
	;(nil).oWType = self.oriWType
	SoraDSendMessage(nil)
end
function kingdomWeatherCtrl:reqGetKingdomWeather(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KINGDOM_COMMON_MODULE, gCmd.REQ_GET_KINGDOM_WEATHER, nil, ...)
end
function kingdomWeatherCtrl:getKingdomWeatherRsp(content)
	self:setKingdomWeather(content.wType, content.owType)
end
function kingdomWeatherCtrl:initClientData(data)
	self:setKingdomWeather(data.wType, data.owType)
	self:initNotifyHandle()
end
return kingdomWeatherCtrl
