local activity_9001706_Ctrl = SoraDGetCtrl("activity_9001706_Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_bonusItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001706/Com_bonusItem", Com_bonusItem)
function Com_bonusItem:onInit()
	self.activityID = gActivityTimeActivityID.SULTAN_COIN_PRESENT_ACTIVITY
	self.fields.title:setString(i18n("Sultan_present_text_08"))
	self.fields.Text_noReach:setString(i18n("Sultan_present_text_09"))
	self.fields.Text_got:setString(i18n("common_text_1892"))
	self.fields.Com_item:initData(TOKEN_ITEM)
	self.fields.Label_time:setTimeEndListener(function()
		self:initData(self.cfg)
	end)
	self.fields.Button_receive:setString(i18n("common_text_1146"))
	self.fields.Button_receive:addClickListener(handler(self, self.btnReveiveClick))
end
function Com_bonusItem:onShow()
end
function Com_bonusItem:initData(cfg)
	self.cfg = self.cfg or cfg
	local iconIndex = 4
	self.fields.Com_item:setIcon(string.format("frame_9001706_sdb_icon%d.png", iconIndex))
	local costSultanCoin = math.min(activity_9001706_Ctrl:getCostSultanCoin(), constantRead.getConstValue("SULTAN_PRESENT_LIMIT", 20000))
	if 0 < costSultanCoin then
		self.fields.Text_num:setString(math.floor(costSultanCoin * cfg.proportion / 1000))
		local isClaimed = activity_9001706_Ctrl:isGainedMonth(cfg.rewardID)
		if isClaimed then
			self.controllers.c1:setSelectedIndex(3)
		else
			local doStage = activity_9001706_Ctrl:getDoStage()
			local stageTime = activity_9001706_Ctrl:getActivityStageTime()
			local leftTime = serviceFunctions.getNextMonthDayTime(stageTime, cfg.rewardID - 1)
			if cfg.rewardID == 1 and doStage == 0 then
				leftTime = activityShowCtrl:getRemainTime(self.activityID)
			end
			if 0 < leftTime then
				self.controllers.c1:setSelectedIndex(1)
				self.fields.Label_time:beginTime(leftTime)
			else
				self.controllers.c1:setSelectedIndex(2)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_bonusItem:btnReveiveClick()
	SoraDPlaySound()
	activity_9001706_Ctrl:sendMonthReward(self.cfg.rewardID)
end
return Com_bonusItem
