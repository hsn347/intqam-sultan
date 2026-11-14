local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local nebulaRegionSignCtrl = SoraDGetCtrl("nebulaRegionSignCtrl")
local signRewadRead = include("signRewadRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaRegionSignPanel = class("NebulaRegionSignPanel", baseFguiPanel)
function NebulaRegionSignPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaRegionSignPanel:ctor", self.viewName)
end
function NebulaRegionSignPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicHerb"
	end
	return self._packageList
end
function NebulaRegionSignPanel:onInit()
	self.activityID = gActivityTimeActivityID.NEBULA_SIGN_ACTIVITY
	print("=======NebulaRegionSignPanel:onInit")
	self.fields.com_title:initData(i18n("activity_name_9001436"), handler(self, self.onClickClose))
	self:setActivityTime()
	self.classtype = activityShowCtrl:getParamByID(self.activityID).classtype
	dump(self.classtype, "fjksdfjkdjfkdfjk")
	self.signDayList = signRewadRead.getNebulaRegionSignCfg(self.classtype)
	self.fields.List_sign:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function NebulaRegionSignPanel:initData()
	dump(self.signDayList, "Com_accuMain:initData")
	self.fields.List_sign:setNumItems(table.nums(self.signDayList))
end
function NebulaRegionSignPanel:refreshData()
end
function NebulaRegionSignPanel:onItemRenderer(index, obj)
	dump(self.signDayList[index + 1], "fjksdfskfld")
	_ENV = dump
	dump.day = index + 1
	dump.reward = self.signDayList[index + 1].sign_reward_thing
	dump.curDay = nebulaRegionSignCtrl:getCurDay()
	local dump.hadGot, data = nebulaRegionSignCtrl:isDaySigned(index + 1), dump
	dump(data, "f534fddfgfgfgfgk")
	obj:initData(index + 1, data)
end
function NebulaRegionSignPanel:setActivityTime()
	self.fields.Label_time:setUbbOn()
	self.fields.Label_time:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", strTime)
		return str
	end)
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.fields.Label_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function NebulaRegionSignPanel:onShow()
	print("=======NebulaRegionSignPanel:onShow")
end
return NebulaRegionSignPanel
