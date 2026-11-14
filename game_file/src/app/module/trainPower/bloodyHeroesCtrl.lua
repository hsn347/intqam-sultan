local GameModule = include("GameModule")
local bloodyHeroesCtrl = class("bloodyHeroesCtrl", GameModule)
local eventQuestRead = include("eventQuestRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function bloodyHeroesCtrl:ctor(properties)
	bloodyHeroesCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.IRON_BLOOD_ACTIVITY
	self:resetData()
end
function bloodyHeroesCtrl:Logout()
	bloodyHeroesCtrl.super.Logout(self)
end
function bloodyHeroesCtrl:resetData()
end
function bloodyHeroesCtrl:initClientData(data)
	dump(data, "bloodyHeroesCtrl:initClientData")
end
function bloodyHeroesCtrl:isResetEveryday()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local newDayTaskRead = include("newDayTaskRead")
	local eventQuestRead = include("eventQuestRead")
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	local queueList = eventQuestRead.getSortList(self.activityID, serverData)
	if next(queueList) then
		local questInfo = eventQuestRead.getTaskConfig(tonumber(queueList[1]))
		if questInfo and next(questInfo) then
			return questInfo.type == 1
		end
	end
	return false
end
function bloodyHeroesCtrl:getReceiveStatusAndNum(activityID)
	print("bloodyHeroesCtrl:getReceiveStatusAndNum", activityID)
	local show, num = false, 0
	if activityID == gActivityTimeActivityID.IRON_BLOOD_ACTIVITY then
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(activityID)
	end
	return show, num
end
function bloodyHeroesCtrl:EnterGame()
end
function bloodyHeroesCtrl:initLocalData()
end
return bloodyHeroesCtrl
