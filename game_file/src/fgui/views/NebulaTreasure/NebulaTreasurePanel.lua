local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaTreasurePanel = class("NebulaTreasurePanel", baseFguiPanel)
local nebulaTreasureRead = include("nebulaTreasureRead")
local nebulaTreasureCtrl = SoraDGetCtrl("nebulaTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function NebulaTreasurePanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("NebulaTreasurePanel:ctor", self.viewName)
end
function NebulaTreasurePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaTreasurePanel:onInit()
	self.fields.Com_title:initData(i18n("activity_name_9001428"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Usm_1:setPrivewImage("#bg_xybz_01.png", cc.size(852, 763), true, true)
	self.fields.TaskList:setItemRenderer(handler(self, self.onQeustsRender))
	self.fields.btn_refresh:addClickEventListener(handler(self, self.onClickRefresh))
	self.fields.text_title:setString(i18n("StarTreasure_text_31"))
	local constantRead = include("constantRead")
	self.refresMaxCount = constantRead.getConstValue("STAR_TREASURE_REFRESH") or 5
	fguiHelper.get_fields(self.fields.shine).shine:setAllFrameName("dh_xiansaoguang_%02d.png", 1)
	fguiHelper.get_fields(self.fields.shine).shine:setPlaySettings(0, -1, -1)
	print("=======NebulaTreasurePanel:onInit")
end
function NebulaTreasurePanel:onShow()
	print("=======NebulaTreasurePanel:onShow")
	self.rateCfg = nebulaTreasureRead.getRateCfg()
	self.maxRate = self.rateCfg[#self.rateCfg].rate
	self.fields.Activity_time:initActivityTime(gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY)
	local lang = SoraDGetDefaultLanguage()
	local titleName = lang == "ar" and "frame_StarlitTreasure_ar.png" or "frame_StarlitTreasure_en.png"
	self.fields.title:setURL(titleName)
	self.fields.txt_refresh:setString(i18n("alliance_mobilize_text_10"))
	self:updateView()
end
function NebulaTreasurePanel:updateView()
	self.curRate = nebulaTreasureCtrl:getCompleteCount()
	self.tasks, nebulaTreasureCtrl, self.claimedTasks = nebulaTreasureCtrl:getClaimedTasks(), nebulaTreasureCtrl:getClaimedTasks(), nebulaTreasureCtrl:getClaimedTasks()
	for k, v in pairs(self.claimedTasks) do
		table.insert(self.tasks, k)
	end
	table.sort(self.tasks, function(a, b)
		return tonumber(a) > tonumber(b)
	end)
	self.fields.TaskList:setNumItems(table.nums(self.tasks))
	nebulaTreasureCtrl = table.nums(self.tasks)
	table.nums(self.tasks).num1 = self.curRate
	nebulaTreasureCtrl, nebulaTreasureCtrl, table.nums(self.tasks).num2 = table.nums(self.tasks)
	self.maxRate.num2, table.nums(self.tasks).color = table.nums(self.tasks)
	local curStr = i18n_html("%{num1}/%{num2}", table.nums(self.tasks))
	self.fields.textTips:setString(curStr)
	self.lastDailyCompleteCount = nebulaTreasureCtrl:getLastDailyCompleteCount()
	local completeCount, limitCount = nebulaTreasureCtrl:getCompleteDatas()
	nebulaTreasureCtrl = table.nums(self.tasks)
	table.nums(self.tasks).num = completeCount
	table.nums(self.tasks).limitNum = limitCount
	self.fields.text_complete:setString(i18n("lost_ruins_text_38", table.nums(self.tasks)))
	for i = 1, 5 do
		self:onRewardsRender(i - 1, self.fields["box" .. i])
	end
end
function NebulaTreasurePanel:onQeustsRender(index, obj)
	local tmpIdx = 0
	obj:initData(self.tasks[index + 1])
end
function NebulaTreasurePanel:onRewardsRender(index, obj)
	local rateCfg = self.rateCfg[index + 1]
	local isOpen = rateCfg and self.curRate >= rateCfg.rate
	local isGot = nebulaTreasureCtrl:getIsRateGot(rateCfg.stage)
	obj:initData(rateCfg, isOpen, isGot)
end
function NebulaTreasurePanel:onClickRefresh()
	SoraDPlaySound()
	if self.lastDailyCompleteCount > 0 then
		local dailyRemindManager = include("dailyRemindManager")
		if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.nebulaTreasure) then
			_ENV = nil
			;(nil).content = i18n("StarTreasure_text_03")
			;(nil).confirmFunc = function()
				nebulaTreasureCtrl:sendRefresh()
			end
			;(nil).remindString = i18n("coffeeCraftsman_text_27")
			;(nil).remindFunc = function(value)
				if value then
					dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.nebulaTreasure)
				end
			end
			uiManager:show("MessageBox", nil)
		else
			nebulaTreasureCtrl:sendRefresh()
		end
	else
		SoraDShowMsgTip(i18n("StarTreasure_text_24"))
	end
end
function NebulaTreasurePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("StarTreasure_text_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return NebulaTreasurePanel
