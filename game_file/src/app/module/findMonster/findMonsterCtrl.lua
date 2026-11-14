local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local findMonsterCtrl = class("findMonsterCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function findMonsterCtrl:ctor(properties)
	findMonsterCtrl.super.ctor(self, properties)
end
function findMonsterCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FIND_MONSTER_MODULE, gCmd.REQ_JUST_DO_FIND_BATTLE_BOSS, handler(self, self.getFindBattleBossRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_MONSTER, handler(self, self.searchMonstersRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_RESOURCE, handler(self, self.searchResourcesRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_SEA_MONSTER, handler(self, self.searchSeaMonsterRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_BOSS, handler(self, self.searchBossRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_FORTY_THIEVES, handler(self, self.searchThievesRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_RADIANCE_WAR_RES, handler(self, self.searchRadianceResourcesRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_RADIANCE_WAR_BEACON, handler(self, self.searchRadianceWarBeaconRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_HUNT_FAIR, handler(self, self.searchIceHuntingMarketRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_MAP_TPYE, handler(self, self.searchMapTypeRsp))
	msgCtrl.register(gCmd.CMD_WORLD_SEARCH_MODULE, gCmd.REQ_SEARCH_ROARING_FLAME_NPC, handler(self, self.searchRoaringFlameNpcRsp))
end
function findMonsterCtrl:sendSearchMapType(mapType, subMapType, level, mMinlv, mMaxlv, mPosX, mPosY, leastCount, research)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_WORLD_SEARCH_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SEARCH_MAP_TPYE, gCmd.REQ_SEARCH_MAP_TPYE
	gCmd.REQ_SEARCH_MAP_TPYE.mapType = mapType
	gCmd.REQ_SEARCH_MAP_TPYE.subMapType = subMapType
	gCmd.REQ_SEARCH_MAP_TPYE.level = level
	gCmd.REQ_SEARCH_MAP_TPYE.minlv = mMinlv
	gCmd.REQ_SEARCH_MAP_TPYE.maxlv = mMaxlv
	gCmd.REQ_SEARCH_MAP_TPYE.posx = mPosX
	gCmd.REQ_SEARCH_MAP_TPYE.posy = mPosY
	gCmd.REQ_SEARCH_MAP_TPYE.leastCount = leastCount
	;(nil).data, gCmd.REQ_SEARCH_MAP_TPYE.research = gCmd.REQ_SEARCH_MAP_TPYE, research
	local msg
	serverproxy:SendMsg(msg)
end
function findMonsterCtrl:sendSearchMonstersMsg(mMinLv, mMaxLv, mPosX, mPosY, research)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_WORLD_SEARCH_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SEARCH_MONSTER, gCmd.REQ_SEARCH_MONSTER
	gCmd.REQ_SEARCH_MONSTER.minLv = mMinLv
	gCmd.REQ_SEARCH_MONSTER.maxLv = mMaxLv
	gCmd.REQ_SEARCH_MONSTER.posx = mPosX
	gCmd.REQ_SEARCH_MONSTER.posy = mPosY
	;(nil).data, gCmd.REQ_SEARCH_MONSTER.research = gCmd.REQ_SEARCH_MONSTER, research
	local msg
	serverproxy:SendMsg(msg)
end
function findMonsterCtrl:sendSearchThievesMsg()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_WORLD_SEARCH_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_SEARCH_FORTY_THIEVES, gCmd.REQ_SEARCH_FORTY_THIEVES, gCmd.REQ_SEARCH_FORTY_THIEVES
	local msg
	serverproxy:SendMsg(msg)
end
function findMonsterCtrl:sendSearchResourcesMsg(restype, level, mPosX, mPosY, research)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_WORLD_SEARCH_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SEARCH_RESOURCE, gCmd.REQ_SEARCH_RESOURCE
	gCmd.REQ_SEARCH_RESOURCE.restype = restype
	gCmd.REQ_SEARCH_RESOURCE.level = level
	gCmd.REQ_SEARCH_RESOURCE.posx = mPosX
	gCmd.REQ_SEARCH_RESOURCE.posy = mPosY
	;(nil).data, gCmd.REQ_SEARCH_RESOURCE.research = gCmd.REQ_SEARCH_RESOURCE, research
	local msg
	serverproxy:SendMsg(msg)
end
function findMonsterCtrl:sendSearchRadianceResourcesMsg(restype, minLv)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_WORLD_SEARCH_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SEARCH_RADIANCE_WAR_RES, gCmd.REQ_SEARCH_RADIANCE_WAR_RES
	gCmd.REQ_SEARCH_RADIANCE_WAR_RES.restype = restype
	;(nil).data, gCmd.REQ_SEARCH_RADIANCE_WAR_RES.minLv = gCmd.REQ_SEARCH_RADIANCE_WAR_RES, minLv
	local msg
	serverproxy:SendMsg(msg)
end
function findMonsterCtrl:sendSearchRadianceWarBeaconMsg(data)
