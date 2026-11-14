local timerList = gModuleMgr.getObject("timerList")
local gameModule = include("GameModule")
local alliance = class("alliance", gameModule)
_ENV = "alliance"
;("alliance").aid = 0
;("alliance").name = ""
;("alliance").abbr = ""
;("alliance").leader = 0
;("alliance").flag = 0
;("alliance").language = 0
;("alliance").limitCount = 0
;("alliance").recruitType = gARecruit.public
;("alliance").bonus = 0
;("alliance").manifesto = ""
;("alliance").notice = ""
;("alliance").r1Name = ""
;("alliance").r2Name = ""
;("alliance").r3Name = ""
;("alliance").r4Name = ""
;("alliance").r5Name = ""
;("alliance").creatTime = ""
;("alliance").joinLevel = 0
;("alliance").joinPower = 0
;("alliance").open_level = ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL
;("alliance").isMigration = false
_ENV, ("alliance").sourceKid = ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, 0
ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.state = gEscortAddState.CLOSE
ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.starttime = 0
ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.totaltime = 0
_ENV, ("alliance").escortinfo, ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.openTimes = ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, 0
ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.starttime = 0
_ENV, ("alliance").bestAllianceInfo, ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.totaltime = ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, 0
ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.starttime = 0
_ENV, ("alliance").mobiBestAlliance, ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.totaltime = ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, 0
ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.rank = 1
ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.starttime = 0
;("alliance").ramadanMobilizeTopAlliance, ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL.totaltime = ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, 0
;("alliance").kingPacksInfo, _ENV, ("alliance").terrScore = ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, ALLIANCE_ROME_ACTIVITY_DEFAULT_OPEN_LEVEL, 0
local property = "alliance"
function alliance:ctor(params)
	alliance.super.ctor(self)
	dump(params, "alliance:ctor")
	self.inviteMoveCityList, alliance, self.legionList, alliance, self.invitelist, alliance, self.applylist, alliance, self.memberlist, alliance, self.property = clone(property), clone(property), clone(property), clone(property), clone(property), clone(property), clone(property), clone(property), clone(property), clone(property), clone(property)
	self.leaderName = ""
	self.migrationMemList, alliance, self.totalBattle = clone(property), clone(property), 0
	if params then
		for key, var in pairs(params) do
			self:setProperty(key, var, false)
		end
	end
	self.queue, alliance = pairs(params)
	self:addEventListener(tostring(gEscortAddState.OPENING), handler(self, self.escortOpeningTimeCb))
end
function alliance:setProperty(key, value)
