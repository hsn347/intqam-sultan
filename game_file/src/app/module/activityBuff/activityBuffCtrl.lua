local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local actCommonltCtrl = include("actCommonltCtrl")
local activityBuffMgr = include("activityBuffMgr")
local activityBuffCtrl = class("activityBuffCtrl", gameModule)
function activityBuffCtrl:initClientData(data)
	local list = actCommonltCtrl.getActBoostList()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	for k, _ in pairs(list) do
		if activityShowCtrl:isActivityOpen(k) then
			self.activityBuffMgr:openActivityBoost(k)
		end
	end
end
function activityBuffCtrl:actOpenListener(actID)
	if actCommonltCtrl.isActOfBoost(actID) then
		self.activityBuffMgr:openActivityBoost(actID, true)
	end
end
function activityBuffCtrl:actCloseListener(actID)
	if actCommonltCtrl.isActOfBoost(actID) then
		self.activityBuffMgr:closeActivityBoost(actID, true)
	end
end
function activityBuffCtrl:getActivityBoost(effectType)
	return self.activityBuffMgr:queryActBoostByBuff(effectType)
end
function activityBuffCtrl:ctor(properties)
	activityBuffCtrl.super.ctor(self, properties)
	self.activityBuffMgr = activityBuffMgr.new()
end
function activityBuffCtrl:EnterGame()
	activityBuffCtrl.super.EnterGame(self)
end
function activityBuffCtrl:resetData()
	self.activityBuffMgr:clean()
end
function activityBuffCtrl:Logout()
	activityBuffCtrl.super.Logout(self)
	self:resetData()
end
return activityBuffCtrl
