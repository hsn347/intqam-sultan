local GameModule = include("GameModule")
local groomHorsesCtrl = class("groomHorsesCtrl", GameModule)
local eventQuestRead = include("eventQuestRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function groomHorsesCtrl:ctor(properties)
	groomHorsesCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.GROOM_HORSES_AND_TROOPS
	self:resetData()
end
function groomHorsesCtrl:Logout()
	groomHorsesCtrl.super.Logout(self)
end
function groomHorsesCtrl:resetData()
end
function groomHorsesCtrl:initClientData(data)
	dump(data, "groomHorsesCtrl:initClientData")
end
function groomHorsesCtrl:getReceiveStatusAndNum(activityID)
	print("groomHorsesCtrl:getReceiveStatusAndNum", activityID)
	local show, num = false, 0
	if activityID == gActivityTimeActivityID.GROOM_HORSES_AND_TROOPS then
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(activityID)
	end
	return show, num
end
function groomHorsesCtrl:EnterGame()
end
function groomHorsesCtrl:initLocalData()
end
return groomHorsesCtrl
