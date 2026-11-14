local GameModule = include("GameModule")
local deadlyHuntingCtrl = class("deadlyHuntingCtrl", GameModule)
local eventQuestRead = include("eventQuestRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function deadlyHuntingCtrl:ctor(properties)
	deadlyHuntingCtrl.super.ctor(self, properties)
	self:resetData()
end
function deadlyHuntingCtrl:Logout()
	deadlyHuntingCtrl.super.Logout(self)
end
function deadlyHuntingCtrl:resetData()
end
function deadlyHuntingCtrl:getReceiveStatusAndNum(activityID)
	print("deadlyHuntingCtrl:getReceiveStatusAndNum", activityID)
	local show, num = false, 0
	if activityID == gActivityTimeActivityID.DEADLY_HUNTING_ACTIVITY then
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(activityID)
	end
	return show, -1
end
function deadlyHuntingCtrl:EnterGame()
end
function deadlyHuntingCtrl:initLocalData()
end
return deadlyHuntingCtrl
