local activity_9001456_Ctrl = SoraDGetCtrl("activity_9001456_Ctrl")
local baseProxy = require("fgui.base.baseProxy")
local Activity_9001456_ScoreProxy = class("Activity_9001456_ScoreProxy", baseProxy)
function Activity_9001456_ScoreProxy:onRegisterEvent()
	print("=======Activity_9001456_ScoreProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001456_REWARD_UPDATE", handler(self, self.onMsgUpdateReward))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001456_SCORE_UPDATE", handler(self, self.onMsgUpdateScore))
end
function Activity_9001456_ScoreProxy:onMsgUpdateReward(...)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateReward()
end
function Activity_9001456_ScoreProxy:onMsgUpdateScore(...)
	self.view:updateScore()
	self.view:updateReward()
end
function Activity_9001456_ScoreProxy:getRewardShowList(rewardConfig)
	local curScore = activity_9001456_Ctrl:getPersonScore()
	local activity_9001456_Ctrl, ret = activity_9001456_Ctrl, activity_9001456_Ctrl
	for i, cfg in ipairs(rewardConfig) do
		local state = gBtnTargetStatusDef.GO
		if activity_9001456_Ctrl:checkIsReceived(cfg.id) then
			state = gBtnTargetStatusDef.GOT
		elseif curScore >= cfg.needIntegral then
			state = gBtnTargetStatusDef.GET
		end
		activity_9001456_Ctrl = cfg.id
		cfg.id.index = i
		cfg.id.state = state
		table.insert(ret, cfg.id)
	end
	_UPVALUE2_, _UPVALUE2_ = nil, ipairs(rewardConfig)
	_UPVALUE2_, (nil)[1] = "state", "state"
	_UPVALUE2_, (nil)[2] = "state", "<"
	;("state")[1] = "index"
	;("state")[2] = "<"
	ipairs(rewardConfig)[1] = nil
	ipairs(rewardConfig)[2] = "state"
	serviceFunctions.sort(ret, ipairs(rewardConfig))
	return ret
end
return Activity_9001456_ScoreProxy
