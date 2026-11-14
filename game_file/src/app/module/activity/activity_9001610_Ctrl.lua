local gamemodulec = include("GameModule")
local activity_9001610_Ctrl = class("activity_9001610_Ctrl", gamemodulec)
_ENV, activity_9001610_Ctrl.ctor = function(self, properties)
	activity_9001610_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN
end, function(self, properties)
	activity_9001610_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN
end
;(function(self, properties)
	activity_9001610_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN
end).sendReqInitDataMsg = "reqInit"
;(function(self, properties)
	activity_9001610_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN
end).sendSignMsg = "reqSign"
;(function(self, properties)
	activity_9001610_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN
end).sendUseGoldSignMsg = "reqUseGoldSign"
local (function(self, properties)
	activity_9001610_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN
end).sendGetExtraRewardMsg, funcConfig = "reqExtraReward", function(self, properties)
	activity_9001610_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN
end
for funcSrc, funcName in pairs(funcConfig) do
	activity_9001610_Ctrl[funcSrc] = function(self, ...)
		local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
		local func = activityCommonSignCtrl[funcName]
		if func then
			return func(activityCommonSignCtrl, gActivityTimeActivityID.HONOR_BACK_SIGN, ...)
		end
	end
end
_UPVALUE9_ = (for generator)
pairs(funcConfig)[1] = "getTotalDay"
pairs(funcConfig)[2] = "getCurDay"
pairs(funcConfig)[3] = "getTotalSignDay"
pairs(funcConfig)[4] = "getUseGoldDay"
pairs(funcConfig)[5] = "getSignTypeByDay"
pairs(funcConfig)[6] = "getExtraRewardInfoByDay"
pairs(funcConfig)[7] = "isCanReceive"
pairs(funcConfig)[8] = "getReceiveStatusAndNum"
local pairs(funcConfig)[9], funcConfig = "getGroup", pairs(funcConfig)
for __, funcName in ipairs(funcConfig) do
	activity_9001610_Ctrl[funcName] = function(self, ...)
		local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
		local func = activityCommonSignCtrl[funcName]
		if func then
			return func(activityCommonSignCtrl, gActivityTimeActivityID.HONOR_BACK_SIGN, ...)
		end
	end
end
return activity_9001610_Ctrl
