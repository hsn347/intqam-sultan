local GameModule = include("GameModule")
local blackGhostCtrl = class("blackGhostCtrl", GameModule)
local eventQuestRead = include("eventQuestRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function blackGhostCtrl:ctor(properties)
	blackGhostCtrl.super.ctor(self, properties)
	self:resetData()
end
function blackGhostCtrl:Logout()
	blackGhostCtrl.super.Logout(self)
end
function blackGhostCtrl:resetData()
end
function blackGhostCtrl:getReceiveStatusAndNum(activityID)
	print("blackGhostCtrl:getReceiveStatusAndNum", activityID)
	local show, num = false, 0
	if activityID == gActivityTimeActivityID.BLACK_GHOST_ACTIVITY then
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(activityID)
	end
	return show, -1
end
function blackGhostCtrl:EnterGame()
end
function blackGhostCtrl:initLocalData()
end
return blackGhostCtrl
