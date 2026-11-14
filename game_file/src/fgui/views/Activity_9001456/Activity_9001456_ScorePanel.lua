local activity_9001456_Ctrl = SoraDGetCtrl("activity_9001456_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001456_ScorePanel = class("Activity_9001456_ScorePanel", baseFguiPanel)
function Activity_9001456_ScorePanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001456_ScorePanel:ctor", self.viewName)
	self.rewardConfig = activity_9001456_Ctrl:getRewardConfig()
	self.rewardShowList, _ENV, self.curScore = activity_9001456_Ctrl:getRewardConfig(), activity_9001456_Ctrl:getRewardConfig(), 0
end
function Activity_9001456_ScorePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001456_ScorePanel:onInit()
	print("=======Activity_9001456_ScorePanel:onInit")
	self.fields.Panel_bg:setString(i18n("fierydragon_text_6"))
	self.fields.List_score:setItemRenderer(handler(self, self.onScoreItemRenderer))
end
function Activity_9001456_ScorePanel:onShow()
	print("=======Activity_9001456_ScorePanel:onShow")
	self:updateScore()
	self:updateReward()
end
function Activity_9001456_ScorePanel:onScoreItemRenderer(index, object)
	local data = self.rewardShowList[index + 1]
	local cfg = self.rewardConfig[data.index]
	local ui = object.fields
	if not ui then
		object.fields = fguiHelper.get_fields(object)
		ui = object.fields
		ui.Button_receive:addClickListener(handler(self, self.onClickBtnReceive))
		object:fixChildrenPos()
		ui.frame_bg:fix()
	end
	local scoreStr = string.formatnumberthousands(cfg.needIntegral)
	if data.state == gBtnTargetStatusDef.GO then
		_ENV = handler(self, self.onClickBtnReceive)
		handler(self, self.onClickBtnReceive).color = "#FF0000"
		scoreStr = SoraDWrapHtmlTagByStyle(scoreStr, handler(self, self.onClickBtnReceive))
	end
	ui.Text_need:setString(i18n("fierydragon_text_7") .. scoreStr)
	ui.List_rewards:setItemRenderer(function(_index, _object)
		local reward = cfg.reward[_index + 1]
		_object:initData(reward.id, reward.count)
	end)
	ui.List_rewards:setNumItems(#cfg.reward)
	ui.Button_receive:setTag(index)
	if data.state == gBtnTargetStatusDef.GOT then
		ui.Button_receive:setString(i18n("common_text_1892"))
		ui.Button_receive:setEnabled(false)
	elseif data.state == gBtnTargetStatusDef.GET then
		ui.Button_receive:setString(i18n("common_text_1146"))
		ui.Button_receive:setEnabled(true)
	else
		ui.Button_receive:setString(i18n("common_text_1146"))
		ui.Button_receive:setEnabled(false)
	end
end
function Activity_9001456_ScorePanel:onClickBtnReceive(EventContext)
	local index = EventContext:getSender():getTag()
	local data = self.rewardShowList[index + 1]
	local cfg = self.rewardConfig[data.index]
	if data.state == gBtnTargetStatusDef.GET then
		activity_9001456_Ctrl:reqReward(cfg.id)
		SoraDShowLoading(self:displayObject())
	end
end
function Activity_9001456_ScorePanel:updateReward(...)
	self.rewardShowList = self.proxy:getRewardShowList(self.rewardConfig)
	self.fields.List_score:setNumItems(#self.rewardShowList)
end
function Activity_9001456_ScorePanel:updateScore(...)
	self.curScore = activity_9001456_Ctrl:getPersonScore()
	activity_9001456_Ctrl = nil
	;(nil).num = string.formatnumberthousands(self.curScore)
	self.fields.Text_score:setString(i18n("common_text_1256", nil))
end
return Activity_9001456_ScorePanel
