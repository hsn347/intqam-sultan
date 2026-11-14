XIAN_XIA_SAI_PLAYER_KEY = "XIAN_XIA_SAI_PLAYER_KEY"
XIAN_XIA_SAI_STATUS_KEY = "XIAN_XIA_SAI_STATUS_KEY"
PYRAMID_LEGION_TOTALSERVER_RANK_REDISKEY = "PYRAMID_LEGION_TOTALSERVER_RANK_REDISKEY"
gLegionRankRefreshCD = 1800
gLockLegionQueueType = 60000
gSetPinnacleSeasonTimeAhead = 864000
_ENV, gPinnacleApplyTime = nil, 345600
;(nil).NONE = 0
;(nil).REGULAR_SEASON = 1
_ENV, gSeasonType, (nil).PINNACLE_SEASON = nil, nil, 2
;(nil).NOT_OPEN = 0
_ENV, gPyramidWarOpenState, (nil).OPEN = nil, nil, 1
;(nil).NO_APPOINT = 1
;(nil).CANNOT_APPOINT = 2
;(nil).APPOINT_ED = 3
_ENV, gMemberState, (nil).ENTER_BATTLE = nil, nil, 4
;(nil).WIN = 1
;(nil).LOSE = 2
_ENV, gPersonalRewardType, (nil).NOT_MATCH = nil, nil, 3
;(nil).WAR_DATA = 1
;(nil).WAR_PERSONAL_RESULT = 2
;(nil).WAR_WATCH_KINGDOM_CHANGE = 3
_ENV, gPyramidWarNotifyType, (nil).PYRAMID_PBL_POINT = nil, nil, 4
;(nil).REGULAR_TIME = 1
gPyramidWarMatchTimeType, (nil).PINNACLE_TIME = nil, 2
REDISKEY_PW_KINGDOM_ID_DISPATCH = "REDISKEY_PW_KINGDOM_ID_DISPATCH"
KINGDOM_OPEN_TIME = 7776000
PYRAMIDWAR_ENTER_BATTLEGROUND_CDTIME = 900
APPOINT_MEM_JOIN_ALLIANCE_TIME_MIN = 172800
APPOINT_MEM_CITYLV_MIN = 15
APPOINT_MAX = 50
PYRAMID_LEGION_MAX_MEMBER = 50
PYRAMIDWAR_ALLIANCE_BATTLE_TIME = 3600
_ENV, PYRAMIDWAR_ALLIANCE_BATTLE_READY_TIME = nil, 180
;(nil)[1] = "bg_JZT_zcxuanzhe01.png"
;(nil)[2] = "bg_JZT_zcxuanzhe01.png"
;(nil)[3] = "bg_JZT_zcxuanzhe02.png"
;(nil)[4] = "bg_JZT_zcxuanzhe02.png"
;(nil)[5] = "bg_JZT_zcxuanzhe03.png"
_ENV, gSignUpSingleBanner, (nil)[6] = nil, nil, "bg_JZT_zcxuanzhe03.png"
;(nil).NOT_OPEN = 1
;(nil).APPLY_ING = 2
;(nil).WAIT_APPLY_NEXT = 3
_ENV, gRegularSeasonState, (nil).FINISH = nil, nil, 4
;(nil).NOT_APPLY = 21
;(nil).APPLY_ED = 22
;(nil).NOT_MATCH = 23
;(nil).PREPARE = 24
;(nil).RUNNING = 25
_ENV, gRegularSeasonAllianceState, (nil).FINISH = nil, nil, 26
;(nil).RANGE = 1
;(nil).SEARCH = 2
gRegularSeasonRankReqType, (nil).SELF_KINGDOM = nil, 3
REDISKEY_PW_REGULAR_SEASON_RANK = "REDISKEY_PW_REGULAR_SEASON_RANK"
NEW_REDISKEY_PW_REGULAR_SEASON_APPLY = "NEW_REDISKEY_PW_REGULAR_SEASON_APPLY"
NEW_REDISKEY_PW_REGULAR_SEASON_MATCH = "NEW_REDISKEY_PW_REGULAR_SEASON_MATCH"
NEW_REDISKEY_PW_REGULAR_CAMP_DATA = "NEW_REDISKEY_PW_REGULAR_CAMP_DATA"
NEW_REDISKEY_PW_REGULAR_SEASON_NEW_KID = "NEW_REDISKEY_PW_REGULAR_SEASON_NEW_KID"
PW_REGULAR_SEASON_MATCH_GROUP_NUM = 80
REGULAR_SEASON_MIN_ROUND = 15
ALLIANCE_CREATETIME_MIN = 1209600
REGULAR_SEASON_APPLIING_TIME = 216000
REGULAR_SEASON_WOUNDARMY_MAX = 9999999999
NEW_REDISKEY_PW_PINNACLE_SEASON_MATCH = "NEW_REDISKEY_PW_PINNACLE_SEASON_MATCH"
NEW_REDISKEY_PW_PINNACLE_CAMP_DATA = "NEW_REDISKEY_PW_PINNACLE_CAMP_DATA"
REDISKEY_PW_PINNACLE_SEASON_RANK = "REDISKEY_PW_PINNACLE_SEASON_RANK"
function getRegularSeasonApplyKey(number)
	return string.format("%s_%d", NEW_REDISKEY_PW_REGULAR_SEASON_APPLY, number)
end
_ENV, getRegularSeasonApplyMaxAllianceNum = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_1 = 1
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_2 = 2
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_3 = 3
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_4 = 4
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_5 = 5
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_6 = 6
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_7 = 7
_ENV, gPinnacleAreaDef, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_8 = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 8
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).GROUP_A = 1
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).GROUP_B = 2
_ENV, gPinnacleGroupDef, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).GROUP_C = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 3
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).NONE = 0
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).GROUP_MATCH = 1
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).BREAKOUT_MATCH = 2
_ENV, gPinnacleMatchType, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).CHAMPION_MATCH = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 3
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).MATCH_ABC = 1
gPinnacleGroupMatchType, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).MATCH_B = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 2
_ENV, gMaxPinnacleSeasonMemberNum = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 512
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).NOT_OPEN_OLD = 1
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).NOT_OPEN = 11
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_OPEN = 12
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).APPLY_ING_A = 13
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_AREA_SELECT = 14
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_MATCH_A = 15
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_MATCH_B = 16
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_APPLY_NEXT = 17
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_LOT = 18
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).CHAMPION_LOT = 19
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_MATCH_COMPETITION = 20
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_APPLY_COMPETITION = 21
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).FINISH = 22
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).GROUP_LIST_WILL_SHOW = 23
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).GROUP_LIST_WAITING = 24
_ENV, gPinnacleSeasonState, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).SYSTEM_LOT = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 25
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).NOT_APPLY = 31
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).APPLY_ED = 32
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).AREA_SELECT = 33
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).NOT_MATCH = 34
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).PREPARE = 35
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).RUNNING = 36
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).FINISH = 37
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).WAIT_COMPETITION_LOT = 38
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).COMPETITION_LOTED = 39
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).PINNACLE_SIGN_UP = 40
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).PINNACLE_WAIT_GROUP_AREA = 41
_ENV, gPinnacleSeasonAllianceState, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).PINNACLE_GROUP_AREA_OK = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 42
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).DARK_HORSE_RANK = 1
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).NEWBIE_LEGION = 2
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).ALSTAR_PLAYER = 3
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).ADVANCE_16_LEGION = 4
_ENV, gGloryRankTypeDef, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).POWER_TOP_4_LEGION = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 5
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).ALLIANCE_RANK = 1
_ENV, gPostSeasonAllianceReward, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).ALLIANCE_GIFTBAG = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 2
;(function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).OPEN = 0
gPostSeasonWatchState, (function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end).CLOSE = function(openKidNum)
	return math.floor(openKidNum * 5 / 4) * 4
end, 1
POSTSEASON_TOTAL_ROUND = 5
POST_SEASON_APPLIING_TIME = 216000
POST_SEASON_APPLY_TIME_NUMBER = 3
POST_SEASON_TOP_ALLIANCE_GIFT_TOTAL_NUM = 20
POST_SEASON_NONE_MATCH_ID = 99999999
POST_SEASON_TOP_GIFT_TIME_LIMIT = 86400
REDISKEY_PW_POST_SEASON_APPLY = "REDISKEY_PW_POST_SEASON_APPLY"
REDISKEY_PW_POST_SEASON_MATCH = "REDISKEY_PW_POST_SEASON_MATCH"
REDISKEY_PW_PINNACLE_SEASON_NEW_KID = "REDISKEY_PW_PINNACLE_SEASON_NEW_KID"
REDISKEY_PINNACLE_APPLY_LIST = "REDISKEY_PINNACLE_APPLY_LIST"
REDISKEY_PINNACLE_FINAL_LEGION_LIST = "REDISKEY_PINNACLE_FINAL_LEGION_LIST"
REDISKEY_PINNACLE_AREA_KEY = "REDISKEY_PINNACLE_AREA_KEY"
REDISKEY_PINNACLE_GROUP = "REDISKEY_PINNACLE_GROUP"
REDISKEY_PINNACLE_COMPETITION_C = "REDISKEY_PINNACLE_COMPETITION_C"
REDISKEY_PINNACLE_COMPETITION_A = "REDISKEY_PINNACLE_COMPETITION_A"
function getPinnacleAreaGroupKey(area, group)
	local key = string.format("%s_%d_%d", REDISKEY_PINNACLE_GROUP, area, group)
	return key
end
function getPinnacleAreaKey(area)
	local key = string.format("%s_%d", REDISKEY_PINNACLE_AREA_KEY, area)
	return key
end
function getPinnacleApplyMemberKey(legionId, kid)
	local key = string.format("%d_%d", tonumber(legionId), tonumber(kid))
	return key
end
