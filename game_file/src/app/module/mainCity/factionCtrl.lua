local GameModule = include("GameModule")
local factionCtrl = class("factionCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function factionCtrl:ctor(properties)
	factionCtrl.super.ctor(self, properties)
	self.factionId = FACTION_TYPE.FACTION_NORMAL
	self.firstLoginFactionId = FACTION_TYPE.FACTION_NORMAL
	self.isFirstLogin = false
end
function factionCtrl:EnterGame()
	self:init()
	self:registerNotify()
	msgCtrl.register(gCmd.CMD_PLAYER_MODULE, gCmd.REQ_SWITCH_CIVILIZATION, handler(self, self.switchFactionCallBack))
end
function factionCtrl:init()
	self:initfaction()
end
function factionCtrl:initClientData(data)
	if data then
		self.factionId = FACTION_TYPE.FACTION_NORMAL
		SoraDConfigSet("Game::lastLoginFaction~integer", self.factionId)
		print("init initSkinData", self.factionId)
	end
end
function factionCtrl:initfaction()
end
function factionCtrl:getfactionById(skinId)
end
function factionCtrl:getFactionWorldCastle(factionType, isWarLv, level)
	factionType = factionType or self:getFactionId()
	local WCCD = require_data("world_castle_config_data")
	local worldKey = "normalLvCfg"
	if isWarLv then
		worldKey = "warLvCfg"
	end
	print("getFactionWorldCastle", factionType, isWarLv, level, WCCD.data[factionType][worldKey][level])
	if WCCD.data[factionType] and WCCD.data[factionType][worldKey] and WCCD.data[factionType][worldKey][level] then
		return WCCD.data[factionType][worldKey][level]
	end
end
function factionCtrl:getBuildViewCfg(bid, factionId)
	print("factionCtrl:getBuildViewCfg", bid, factionId)
	factionId = factionId or self:getFactionId()
	local CACUD = require_data("city_auto_create_ui")
	local info = CACUD.data[bid]
	if info then
		return info[factionId] or info[FACTION_TYPE.FACTION_NORMAL]
	end
end
function factionCtrl:getCityBuildTipsInfo(bid)
	local BTBLD = require_data("build_tips_btn_list_data")
	return BTBLD.data[bid]
end
function factionCtrl:getCityBuildBaseTipsCfg(bid)
	local BTBLD = require_data("build_tips_btn_list_data")
	local nationInfo = BTBLD.data[bid]
	return nationInfo
end
function factionCtrl:getBuildTipButtonCfgById(btnId)
	local BTBD = require_data("build_tips_btn_config")
	return BTBD.data[btnId]
end
function factionCtrl:getBuildImgWithNation(bid)
	local CBD = require_data("city_build_config")
	local info = CBD.data[bid]
	local imgName = info.buildImg or ""
	local alias = self:getFactionAlias(self:getFactionId())
	imgName = alias and info["buildImg_" .. alias] or imgName
	return getImageFileNameByPlatform(imgName, "png")
end
function factionCtrl:getFactionId()
	return FACTION_TYPE.FACTION_NORMAL
end
function factionCtrl:getFactionMainCityCfg()
	local factionType = self:getFactionId()
	if factionType == FACTION_TYPE.FACTION_NORMAL then
		if IsArClient then
			_ENV = IsArClient
			IsArClient.container = "mainCityViewInfo"
			IsArClient.far = "mainCityView_info_far"
			IsArClient.middle = "mainCityView_info_middle"
			return IsArClient
		else
			_ENV = IsArClient
			IsArClient.container = "mainCityView_ros"
			IsArClient.far = "mainCityView_info_far"
			IsArClient.middle = "mainCityView_info_middle"
			return IsArClient
		end
	elseif factionType == FACTION_TYPE.FACTION_BYZANTINE then
		_ENV = FACTION_TYPE.FACTION_BYZANTINE
		FACTION_TYPE.FACTION_BYZANTINE.container = "mainCityView_bzt"
		FACTION_TYPE.FACTION_BYZANTINE.far = "mainCityView_info_far"
		FACTION_TYPE.FACTION_BYZANTINE.middle = "mainCityView_info_middle"
		return FACTION_TYPE.FACTION_BYZANTINE
	end
end
function factionCtrl:getFactionAlias(factionId)
	return FACTION_ALIAS[factionId]
end
function factionCtrl:getCityBuildBaseCfg(bid)
	local CBD = require_data("city_build_config")
	return CBD.data[bid]
end
function factionCtrl:getWorldSoliderImageSets(factionId)
	local factionId = factionId or self:getFactionId()
	return FACTION_WORLD_SOLIDER_IMAGE_SETS[factionId] or FACTION_WORLD_SOLIDER_IMAGE_SETS[FACTION_TYPE.FACTION_NORMAL]
end
function factionCtrl:switchFaction(targetFactionId, force)
	local lastFactionId = self.factionId
	self.factionId = targetFactionId
	if self.factionId ~= lastFactionId or force then
		SoraDConfigSet("Game::lastLoginFaction~integer", self.factionId)
		_ENV = "Game::lastLoginFaction~integer"
		;("Game::lastLoginFaction~integer").msg = "MESSAGE_MAINSCEN_ONSHOW"
		;("Game::lastLoginFaction~integer").viewType = VIEW_TYPE_CITY
		;("Game::lastLoginFaction~integer").isFactionSwitch = true
		;("Game::lastLoginFaction~integer").lastFaction = lastFactionId
		SoraDSendMessage("Game::lastLoginFaction~integer")
		_ENV = "Game::lastLoginFaction~integer"
		;("Game::lastLoginFaction~integer").msg = "MESSAGE_MAIN_SCENE_IPHONEX"
		;("Game::lastLoginFaction~integer").isShow = true
		SoraDSendMessage("Game::lastLoginFaction~integer")
	end
end
function factionCtrl:setFirstLogin(bValue)
	self.isFirstLogin = bValue
end
function factionCtrl:switchFactionType(factionType, ...)
	serverproxy = nil
	local (nil).factionType, data = factionType, nil
	serverproxy:Request(gCmd.CMD_PLAYER_MODULE, gCmd.REQ_SWITCH_CIVILIZATION, data, ...)
end
function factionCtrl:registerNotify()
end
function factionCtrl:switchFactionCallBack(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		self:switchFaction(data.factionType)
	end
end
return factionCtrl
