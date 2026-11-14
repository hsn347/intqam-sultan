local member = class("member")
_ENV = "member"
;("member").aid = 0
;("member").uid = 0
;("member").rank = gAllianceRank.R0
;("member").joinTime = 0
;("member").honorDay = 0
;("member").honorWeek = 0
;("member").honorTotal = 0
;("member").playerHonor = 0
;("member").sciPointDay = 0
;("member").sciPointWeek = 0
;("member").sciPointTotal = 0
;("member").curApplyAid = 0
;("member").isfirstjoin = false
;("member").official = 0
;("member").donateCD, _ENV, ("member").donateState, _ENV, ("member").curApplyOfficial = gAllianceRank.R0, gAllianceRank.R0, gAllianceRank.R0, gAllianceRank.R0, 0
;("member").donatePopularityCD, _ENV, ("member").donateLock = gAllianceRank.R0, gAllianceRank.R0, 0
;("member").donatePopularityState, _ENV, ("member").donatePopularityLock = gAllianceRank.R0, gAllianceRank.R0, 0
;("member").lastProsperity = 0
local _ENV, ("member").lastReturnGoodsTime, minfo = gAllianceRank.R0, 0, "member"
gAllianceRank.R0.costTp = 0
local _ENV, gAllianceRank.R0.opCount, donateData = nil, 0, gAllianceRank.R0
;(nil).cityLevel = 0
;(nil).iconID = 0
;(nil).avatar = ""
;(nil).nickName = ""
;(nil).online = 0
;(nil).totalFc = 0
local (nil).sourceKid, uinfo = 0, nil
function member:ctor()
	self.minfo = clone(minfo)
	self.uinfo = clone(uinfo)
end
function member:reset()
	local playerHonor = self:getProperty("playerHonor")
	local uid = self:getProperty("uid")
	self.minfo = clone(minfo)
	self.uinfo = clone(uinfo)
	self:setProperty("uid", uid)
	self:setProperty("playerHonor", playerHonor)
end
function member:setProperty(key, value)
