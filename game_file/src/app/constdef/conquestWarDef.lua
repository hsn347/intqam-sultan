_ENV = nil
;(nil).LOCK = 1
;(nil).WAITING = 2
;(nil).NOT_MATCH = 3
;(nil).PREPARE = 4
_ENV, gConquestWarState, (nil).OPENING = nil, nil, 5
;(nil).KILL_ENEMY = 1
;(nil).COLLECT_RESOURCE = 2
;(nil).KILL_MONSTER = 3
;(nil).OCCUPY_PALACE = 4
_ENV, gConquestWarScoreEventTp, (nil).HELP_PALACE = nil, nil, 5
;(nil).SUCCESS = 1
_ENV, gConquestWarMatchState, (nil).FAILED = nil, nil, 2
;(nil).GROUP1 = 1
_ENV, gConquestWarMatchGroup, (nil).GROUP2 = nil, nil, 2
;(nil).AUTO = 1
_ENV, gConquestWarMatchType, (nil).CONF = nil, nil, 2
;(nil).NOT_BATTLE_IN = 1
_ENV, gConquestWarKingdomBattleState, (nil).BATTLE_IN = nil, nil, 2
;(nil).NOT_FINISH = 1
_ENV, gConquestWarIsFinish, (nil).FINISH = nil, nil, 2
;(nil).WIN = 1
_ENV, gConquestWarResult, (nil).LOSE = nil, nil, 2
;(nil).PERSON = 1
_ENV, gConquestWarStageRewardType, (nil).ALLIANCE = nil, nil, 2
;(nil).NO_RECEIVE = 0
_ENV, gPersonReceiveStatus, (nil).HAVE_RECEIVED = nil, nil, 1
;(nil).NO_RECEIVE = 0
;(nil).CANNOT_RECEIVE = 1
;(nil).RECEIVE_IN_NOW_ALLIANCE = 2
gAllianceReceiveStatus, (nil).RECEIVE_IN_BEFORE_ALLIANCE = nil, 3
CONQUESTWAR_MATCHTIME_KEY = "CONQUESTWAR_MATCHTIME_KEY"
CONQUESTWAR_LOCK_TIME = 10368000
CONQUESTWAR_OPENING_TIME = 86400
CONQUESTWAR_REINFORCE_WAITING_SETTING_TIME = 86400
CONQUESTWAR_HOSTPITAL_MAX_CAPACITY_ADD_VALUE = 0.5
CONQUESTWAR_PERSIONAL_SCORE_RANK_START = 0
CONQUESTWAR_PERSIONAL_SCORE_RANK_END = 99
REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE = "REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE"
REDIS_KEY_CONQUESTWAR_KINGDOM_SCORE = "REDIS_KEY_CONQUESTWAR_KINGDOM_SCORE"
REDIS_KEY_CONQUESTWAR_PERSIONAL_RANK_LAST = "REDIS_KEY_CONQUESTWAR_PERSIONAL_RANK_LAST"
REDIS_KEY_CONQUESTWAR_PERSIONAL_RANK_IN_ALLIANCE = "REDIS_KEY_CONQUESTWAR_PERSIONAL_RANK_IN_ALLIANCE_"
REDIS_KEY_CONQUESTWAR_PERSIONAL_RANK_IN_ALLIANCE_SET = "REDIS_KEY_CONQUESTWAR_PERSIONAL_RANK_IN_ALLIANCE_SET_"
REDIS_KEY_CONQUESTWAR_PERSIONAL_RECEIVED_INFO = "REDIS_KEY_CONQUESTWAR_PERSIONAL_RECEIVED_INFO_"
CONQUESTWAR_WIN_BUFF_LASTTIME = 172800
CONQUESTWAR_WIN_BUFF_TIMEQUEUE_KEY = "CONQUESTWAR_WIN_BUFF_TIMEQUEUE_KEY"
CONQUESTWAR_KINGDOM_MAIL_QUEUE_KEY = "CONQUESTWAR_KINGDOM_MAIL_QUEUE_KEY"
CONQUESTWAR_RESURRECTION_QUEUE_KEY = "CONQUESTWAR_RESURRECTION_QUEUE_KEY"
CONQUESTWAR_REINFORCE_QUEUE_KEY = "CONQUESTWAR_REINFORCE_QUEUE_KEY"
CONQUESTWAR_TO_BE_REINFORCE_QUEUE_KEY = "CONQUESTWAR_TO_BE_REINFORCE_QUEUE_KEY"
CONQUESTWAR_PALACE_OCCUPIED_KINGDOMSCORE_RATE = 0.3
CONQUESTWAR_MATCH_RECORD_MAXCOUNT = 5
_ENV, getPersionalScoreKey_Redis = function(kid, matchKid)
	local key = string.format("%d_%d", kid, matchKid)
	if matchKid < kid then
		key = string.format("%d_%d", matchKid, kid)
	end
	local ret = string.format("%s_%s", REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE, key)
	return ret
end, function(kid, matchKid)
	local key = string.format("%d_%d", kid, matchKid)
	if matchKid < kid then
		key = string.format("%d_%d", matchKid, kid)
	end
	local ret = string.format("%s_%s", REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE, key)
	return ret
end
;(function(kid, matchKid)
	local key = string.format("%d_%d", kid, matchKid)
	if matchKid < kid then
		key = string.format("%d_%d", matchKid, kid)
	end
	local ret = string.format("%s_%s", REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE, key)
	return ret
end).INVETED = 1
;(function(kid, matchKid)
	local key = string.format("%d_%d", kid, matchKid)
	if matchKid < kid then
		key = string.format("%d_%d", matchKid, kid)
	end
	local ret = string.format("%s_%s", REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE, key)
	return ret
end).AGREE = 2
;(function(kid, matchKid)
	local key = string.format("%d_%d", kid, matchKid)
	if matchKid < kid then
		key = string.format("%d_%d", matchKid, kid)
	end
	local ret = string.format("%s_%s", REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE, key)
	return ret
end).REJECT = 3
gConquestWarReinforcementsState, (function(kid, matchKid)
	local key = string.format("%d_%d", kid, matchKid)
	if matchKid < kid then
		key = string.format("%d_%d", matchKid, kid)
	end
	local ret = string.format("%s_%s", REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE, key)
	return ret
end).CANCEL = function(kid, matchKid)
	local key = string.format("%d_%d", kid, matchKid)
	if matchKid < kid then
		key = string.format("%d_%d", matchKid, kid)
	end
	local ret = string.format("%s_%s", REDIS_KEY_CONQUESTWAR_PERSIONAL_SCORE, key)
	return ret
end, 4
