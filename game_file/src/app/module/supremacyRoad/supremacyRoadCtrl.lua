local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local supremacyRoadCtrl = class("supremacyRoadCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function supremacyRoadCtrl:ctor(properties)
	supremacyRoadCtrl.super.ctor(self, properties)
	self:resetData()
end
function supremacyRoadCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SUPREMACY_ROAD_MODULE, gCmd.REQ_SUPREMACY_ROAD_INIT, handler(self, self.reqInitRsp))
end
function supremacyRoadCtrl:Logout()
	supremacyRoadCtrl.super.Logout(self)
	self:resetData()
end
function supremacyRoadCtrl:resetData()
end
function supremacyRoadCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SUPREMACY_ROAD_MODULE, gCmd.REQ_SUPREMACY_ROAD_INIT, nil)
end
function supremacyRoadCtrl:reqInitRsp(content)
	dump(content, "supremacyRoadCtrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SUPREMACY_ROAD_INIT_BACK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function supremacyRoadCtrl:initQuestConfig(...)
	if self.config then
		return
	end
	self.config, _ENV = self.config, self.config
	local supremacy_road_config = require_data("supremacy_road_config").data
	for i, v in ipairs(supremacy_road_config) do
		self.config[v.type] = v
	end
end
function supremacyRoadCtrl:getQuestConfig(questType)
	self:initQuestConfig()
	return self.config[questType]
end
function supremacyRoadCtrl:getQuestTypeName(questType)
	local config = self:getQuestConfig(questType)
	return config.name
end
function supremacyRoadCtrl:getQuestTypeDes(questType)
	local config = self:getQuestConfig(questType)
	return config.describe
end
function supremacyRoadCtrl:getQuestTypeMailName(questType)
	local config = self:getQuestConfig(questType)
	return config.mailname
end
function supremacyRoadCtrl:getQuestData(round)
	if not self.questConfig then
		local supremacy_road_quest = require_data("supremacy_road_quest", true).data
		local _ENV, ret = "supremacy_road_quest", "supremacy_road_quest"
		for i, v in ipairs(supremacy_road_quest) do
			local _round = v.round
			local _type = v.type
			if not ret[_round] then
				_ENV = ret[_round]
			end
			ret[_round] = ret[_round]
			if not ret[_round][_type] then
				_ENV = ret[_round][_type]
			end
			ret[_round][_type] = ret[_round][_type]
			table.insert(ret[_round][_type], v)
		end
		self.questConfig = ret
	end
	return self.questConfig[round]
end
return supremacyRoadCtrl
