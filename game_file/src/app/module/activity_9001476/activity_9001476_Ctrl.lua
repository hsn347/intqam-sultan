local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001476_Ctrl = class("activity_9001476_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001476_Ctrl:ctor(properties)
	activity_9001476_Ctrl.super.ctor(self, properties)
	self:resetData()
end
function activity_9001476_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ONE_GOAL_TO_FAME_MODULE, gCmd.REQ_ONE_GOAL_TO_FAME_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_ONE_GOAL_TO_FAME_MODULE, gCmd.REQ_ONE_GOAL_TO_FAME_DRAW, handler(self, self.reqDrawRsp))
	msgCtrl.register(gCmd.CMD_ONE_GOAL_TO_FAME_MODULE, gCmd.REQ_ONE_GOAL_TO_FAME_DRAW_TEN, handler(self, self.reqDrawTenRsp))
end
function activity_9001476_Ctrl:Logout()
	activity_9001476_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001476_Ctrl:resetData()
	self.classType = 1
	self.drawCount = 0
end
function activity_9001476_Ctrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ONE_GOAL_TO_FAME_MODULE, gCmd.REQ_ONE_GOAL_TO_FAME_INIT, nil)
end
function activity_9001476_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001476_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.classType = rspdata.classType or 1
		self.drawCount = rspdata.drawCount
		_ENV = "activity_9001476_Ctrl:reqInitRsp(content)"
		;("activity_9001476_Ctrl:reqInitRsp(content)").msg = "MESSAGE_ACTIVITY_9001476_UPDATE"
		SoraDSendMessage("activity_9001476_Ctrl:reqInitRsp(content)")
	end
end
function activity_9001476_Ctrl:reqDraw()
	serverproxy:Request(gCmd.CMD_ONE_GOAL_TO_FAME_MODULE, gCmd.REQ_ONE_GOAL_TO_FAME_DRAW)
end
function activity_9001476_Ctrl:reqDrawRsp(content)
	dump(content, "activity_9001476_Ctrl:reqDrawRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.drawCount = rspdata.drawCount
		_ENV = "activity_9001476_Ctrl:reqDrawRsp(content)"
		;("activity_9001476_Ctrl:reqDrawRsp(content)").msg = "MESSAGE_ACTIVITY_9001476_UPDATE"
		_UPVALUE1_, ("activity_9001476_Ctrl:reqDrawRsp(content)").isDraw = 10, true
		;("activity_9001476_Ctrl:reqDrawRsp(content)").rewards, (10)[1] = 10, rspdata.reward
		SoraDSendMessage("activity_9001476_Ctrl:reqDrawRsp(content)")
	end
end
function activity_9001476_Ctrl:reqDrawTen()
	serverproxy:Request(gCmd.CMD_ONE_GOAL_TO_FAME_MODULE, gCmd.REQ_ONE_GOAL_TO_FAME_DRAW_TEN)
end
function activity_9001476_Ctrl:reqDrawTenRsp(content)
	dump(content, "activity_9001476_Ctrl:reqDrawRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.drawCount = rspdata.drawCount
		_ENV = "activity_9001476_Ctrl:reqDrawRsp(content)"
		;("activity_9001476_Ctrl:reqDrawRsp(content)").msg = "MESSAGE_ACTIVITY_9001476_UPDATE"
		;("activity_9001476_Ctrl:reqDrawRsp(content)").isDrawTen = true
		;("activity_9001476_Ctrl:reqDrawRsp(content)").rewards = rspdata.rewardList
		SoraDSendMessage("activity_9001476_Ctrl:reqDrawRsp(content)")
	end
end
function activity_9001476_Ctrl:getRewardConfig()
	if not self.rewardConfig then
		local one_goal_to_fame = require_data("one_goal_to_fame", true).data
		local _ENV, ret = "one_goal_to_fame", "one_goal_to_fame"
		for i, v in ipairs(one_goal_to_fame) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			table.insert(ret[v.type], v)
		end
		self.rewardConfig = ret
	end
	return self.rewardConfig[self.classType]
end
function activity_9001476_Ctrl:getDrawReward(times)
	local __, index = self:getDrawLv(times)
	local configs = self:getRewardConfig()
	if configs[index].show == 0 then
		index = index + 1
	end
	if not configs[index] or not configs[index].reward then
		local _ENV, reward = configs[index].reward, configs[index].reward
	end
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "probability"
	return serviceFunctions.tableFormat(reward, nil)
end
function activity_9001476_Ctrl:getDrawCount(...)
	return self.drawCount
end
function activity_9001476_Ctrl:getDrawLv(times)
	local configs = self:getRewardConfig()
	for i, v in ipairs(configs) do
		if times >= v.times[1] and times <= v.times[2] then
			return v.goal, i
		end
	end
	return configs[#configs].goal, #configs
end
function activity_9001476_Ctrl:getItemID(...)
	local constantRead = include("constantRead")
	return constantRead.getConstValue("ONE_GOAL_TO_FAME_ITEM", 859101)
end
function activity_9001476_Ctrl:getBoxConfig(...)
	local configs = self:getRewardConfig()
	local _ENV, ret = self, self
	for i, v in ipairs(configs) do
		ret[v.goal] = ret[v.goal] or v.times[1] - 1
	end
	return ret
end
return activity_9001476_Ctrl
