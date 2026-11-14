local exchangeltCtrl = include("exchangeltCtrl")
local _ENV, exchangeDataModuleAPI = "exchangeltCtrl", "exchangeltCtrl"
function exchangeDataModuleAPI:getExchangeList(id)
	return exchangeltCtrl:getExchangeList(id)
end
function exchangeDataModuleAPI:exchange(eid, exchangeNum)
	self:getModuleCtrl():exchange(eid, exchangeNum)
end
function exchangeDataModuleAPI:exchangeFeast(eid, exchangeNum)
	self:getModuleCtrl():exchangeFeast(eid, exchangeNum)
end
function exchangeDataModuleAPI:exchangeBBQ(eid, exchangeNum)
	self:getModuleCtrl():exchangeBBQ(eid, exchangeNum)
end
function exchangeDataModuleAPI:reqExchangeSummerFestival(eid, exchangeNum)
	self:getModuleCtrl():reqExchangeSummerFestival(eid, exchangeNum)
end
function exchangeDataModuleAPI:getModuleCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("exchangeCtrl")
end
return exchangeDataModuleAPI
