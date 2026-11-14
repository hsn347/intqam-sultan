local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local actCommonltCtrl = include("actCommonltCtrl")
local activityBuffMgr = class("activityBuffMgr")
_ENV, activityBuffMgr.ctor = function(self)
	self.property, _UPVALUE0_ = nil, nil
end, function(self)
	self.property, _UPVALUE0_ = nil, nil
end
;(function(self)
	self.property, _UPVALUE0_ = nil, nil
end)[gBuffEffect.RESOURCE_OUTPUT_BOOST] = gActivityBoostType.RESOURCE_OUTPUT_BOOST
;(function(self)
	self.property, _UPVALUE0_ = nil, nil
end)[gBuffEffect.GATHER_SPEED_BOOST] = gActivityBoostType.GATHER_SPEED_BOOST
;(function(self)
	self.property, _UPVALUE0_ = nil, nil
end)[gBuffEffect.WISH_RESOURCE_BOOST] = gActivityBoostType.WISH_RESOURCE_BOOST
;(function(self)
	self.property, _UPVALUE0_ = nil, nil
end)[gBuffEffect.ARP_GATHER_SPEED_BOOST] = gActivityBoostType.ARP_GATHER_SPEED_BOOST
;(function(self)
	self.property, _UPVALUE0_ = nil, nil
end)[gBuffEffect.AT_DONATE_HONOR_BOOST] = gActivityBoostType.AT_DONATE_HONOR_BOOST
;(function(self)
	self.property, _UPVALUE0_ = nil, nil
end)[gBuffEffect.AT_DONATE_BONUS_BOOST] = gActivityBoostType.AT_DONATE_BONUS_BOOST
local _ENV, (function(self)
	self.property, _UPVALUE0_ = nil, nil
end)[gBuffEffect.AT_RESEARCH_SPEED_BOOST], buffEffectType_actBoostType = gBuffEffect.AT_RESEARCH_SPEED_BOOST, gActivityBoostType.AT_RESEARCH_SPEED_BOOST, function(self)
	self.property, _UPVALUE0_ = nil, nil
end
gBuffEffect.AT_RESEARCH_SPEED_BOOST[gActivityBoostType.RESOURCE_OUTPUT_BOOST] = gBuffEffect.RESOURCE_OUTPUT_BOOST
gBuffEffect.AT_RESEARCH_SPEED_BOOST[gActivityBoostType.GATHER_SPEED_BOOST] = gBuffEffect.GATHER_SPEED_BOOST
gBuffEffect.AT_RESEARCH_SPEED_BOOST[gActivityBoostType.WISH_RESOURCE_BOOST] = gBuffEffect.WISH_RESOURCE_BOOST
gBuffEffect.AT_RESEARCH_SPEED_BOOST[gActivityBoostType.ARP_GATHER_SPEED_BOOST] = gBuffEffect.ARP_GATHER_SPEED_BOOST
gBuffEffect.AT_RESEARCH_SPEED_BOOST[gActivityBoostType.AT_DONATE_HONOR_BOOST] = gBuffEffect.AT_DONATE_HONOR_BOOST
gBuffEffect.AT_RESEARCH_SPEED_BOOST[gActivityBoostType.AT_DONATE_BONUS_BOOST] = gBuffEffect.AT_DONATE_BONUS_BOOST
local gBuffEffect.AT_RESEARCH_SPEED_BOOST[gActivityBoostType.AT_RESEARCH_SPEED_BOOST], actBoostType_buffEffectType = gBuffEffect.AT_RESEARCH_SPEED_BOOST, gBuffEffect.AT_RESEARCH_SPEED_BOOST
function activityBuffMgr:openActivityBoost(actID, isNotify)
	local boostlist = actCommonltCtrl.getConfig(actID, "boost")
	for k, v in pairs(boostlist) do
		if gErrDef.Err_None == self:addBoost(k, actID, v) and isNotify then
			local buffCtrl = gametop.playertop_:getModule("buffCtrl")
			local effectType = actBoostType_buffEffectType[k]
			buffCtrl:dispatchBuffEvent(effectType, gBuffSource.ACTIVITY)
		end
	end
end
function activityBuffMgr:closeActivityBoost(actID, isNotify)
	local boostlist = actCommonltCtrl.getConfig(actID, "boost")
	for k, v in pairs(boostlist) do
		if gErrDef.Err_None == self:removeBoost(k, actID, v) and isNotify then
			local buffCtrl = gametop.playertop_:getModule("buffCtrl")
			local effectType = actBoostType_buffEffectType[k]
			buffCtrl:dispatchBuffEvent(effectType, gBuffSource.ACTIVITY)
		end
	end
end
function activityBuffMgr:queryActBoostByBuff(effectType)
	if not self:isActBuffType(effectType) then
		return
	end
	local boostType = buffEffectType_actBoostType[effectType]
	if boostType then
		return self:queryActivityBoost(boostType)
	end
end
function activityBuffMgr:isActBuffType(effectType)
	if buffEffectType_actBoostType[effectType] then
		return true
	end
end
function activityBuffMgr:isActBoostType(boostType)
	if actBoostType_buffEffectType[boostType] then
		return true
	end
end
function activityBuffMgr:addBoost(boostType, actID, value)
	if not self.property[boostType] then
		_ENV = self.property[boostType]
		self.property[boostType].list, _ENV, self.property[boostType].total = nil, nil, 0
	end
	self.property[boostType] = self.property[boostType]
	if "number" == type(value) and 0 < value then
		local boost = self.property[boostType]
		local list = boost.list
		if not list[actID] then
			list[actID] = value
			boost.total = boost.total + value
			return gErrDef.Err_None
		end
	else
		print("act log: value is error! param:", boostType, actID, value)
	end
end
function activityBuffMgr:removeBoost(boostType, actID)
	local boost = self.property[boostType]
	if boost then
		local value = boost.list[actID]
		if value then
			boost.list[actID] = nil
			boost.total = boost.total - value
			if boost.total <= 0 then
				self.property[boostType] = nil
			end
			return gErrDef.Err_None
		end
	end
end
function activityBuffMgr:queryActivityBoost(boostType)
	if not self:isActBoostType(boostType) then
		return
	end
	local boost = self.property[boostType]
	if boost then
		return boost.total, boost.list
	end
end
function activityBuffMgr:clean()
	self.property, _UPVALUE0_ = nil, nil
end
function activityBuffMgr:dump()
end
return activityBuffMgr
