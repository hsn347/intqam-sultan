local GameModule = include("GameModule")
local roadToGloryCtrl = class("roadToGloryCtrl", GameModule)
local roadToGloryRead = include("roadToGloryRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
_ENV = "msgCtrl"
;("msgCtrl").noClaim = 1
;("msgCtrl").noReach = 2
local ("msgCtrl").claimed, giftStatus = 3, "msgCtrl"
function roadToGloryCtrl:ctor(properties)
	roadToGloryCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.GLORY_ROAD_ACTIVITY
	self:resetData()
end
function roadToGloryCtrl:Logout()
	roadToGloryCtrl.super.Logout(self)
end
function roadToGloryCtrl:resetData()
end
function roadToGloryCtrl:initClientData(data)
	dump(data, "roadToGloryCtrl:initClientData")
	if clientEventMgr.judgeIsOpen(self.activityID) then
	end
end
function roadToGloryCtrl:getReceiveStatusAndNum()
	print("roadToGloryCtrl:getReceiveStatusAndNum")
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local show, num = false, 0
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return false, 0
	end
	return show, num
end
function roadToGloryCtrl:EnterGame()
end
function roadToGloryCtrl:initLocalData()
end
function roadToGloryCtrl:getTaskListByDay(lv, star)
end
function roadToGloryCtrl:getSortList(list)
	local _ENV, ret
	local eventQuestRead = include("eventQuestRead")
	for _, v in ipairs(list) do
		local item = v
		local questID = v.taskID
		local cfgItem = eventQuestRead.questconfig[tonumber(questID)]
		local count = 0
		if self.questProgress then
			count = self.questProgress[tostring(questID)] or 0
		end
		item.count = count
		table.insert(ret, item)
	end
	table.sort(ret, function(a, b)
		if a.status ~= b.status then
			return a.status < b.status
		end
		return a.taskID < b.taskID
	end)
	return ret
end
function roadToGloryCtrl:isResetEveryday()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local roadToGloryRead = include("roadToGloryRead")
	local otherInfo = activityTaskComponentCtrl:getActivityInitData(gActivityTimeActivityID.GLORY_ROAD_ACTIVITY)
	local type = roadToGloryRead.getActType(otherInfo.castleLv or 0, otherInfo.starLv or 0)
	return type == 1
end
function roadToGloryCtrl:reqInitData()
end
return roadToGloryCtrl
