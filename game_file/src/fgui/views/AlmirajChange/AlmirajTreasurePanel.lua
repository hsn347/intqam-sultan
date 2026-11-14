local mirajChallengeCtrl = SoraDGetCtrl("mirajChallengeCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local almirjchangeRead = include("almirjchangeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AlmirajTreasurePanel = class("AlmirajTreasurePanel", baseFguiPanel)
function AlmirajTreasurePanel:ctor(...)
	self.super.ctor(self, ...)
	print("AlmirajTreasurePanel:ctor", self.viewName)
end
function AlmirajTreasurePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AlmirajTreasurePanel:onInit()
	print("=======AlmirajTreasurePanel:onInit")
	self.activityID = gActivityTimeActivityID.MIRAJ_CHALLENGE_ACTIVITY
	self.fields.Panel_bg:setTitle(i18n("anniversary_fire_text_16"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function AlmirajTreasurePanel:onItemRenderer(index, obj)
	obj:initData(self.boxCfg[index + 1])
end
function AlmirajTreasurePanel:onShow()
	print("=======AlmirajTreasurePanel:onShow")
	local param = activityShowCtrl:getParamByID(self.activityID)
	local classtype = param.classtype or 1
	self.boxCfg = almirjchangeRead.getBoxCfg(classtype)
	mirajChallengeCtrl:sendInit()
end
function AlmirajTreasurePanel:initData()
	print("AlmirajTreasurePanel:initData=====")
	for k, v in ipairs(self.boxCfg) do
		if mirajChallengeCtrl:checkBoxStatus(v.rank) then
			v.status = gBtnTargetStatusDef.GOT
		elseif mirajChallengeCtrl:getKilledCount() >= v.bossNum then
			v.status = gBtnTargetStatusDef.GET
		else
			v.status = gBtnTargetStatusDef.GO
		end
	end
	table.sort(self.boxCfg, function(a, b)
		if a.status == b.status then
			return a.rank < b.rank
		else
			return a.status < b.status
		end
	end)
	self.fields.List:setNumItems(#self.boxCfg)
end
function AlmirajTreasurePanel:onHide()
	print("=======AlmirajTreasurePanel:onHide")
end
function AlmirajTreasurePanel:onDispose()
	print("=======AlmirajTreasurePanel:onDispose")
end
return AlmirajTreasurePanel
