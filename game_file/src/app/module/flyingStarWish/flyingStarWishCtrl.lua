local flyingStarWishRead = include("flyingStarWishRead")
local constantRead = include("constantRead")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local flyingStarWishCtrl = class("flyingStarWishCtrl", GameModule)
function flyingStarWishCtrl:ctor(properties)
	flyingStarWishCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.FLYING_STAR_WISH
	self.maxCostGold = constantRead.getConstValue("GIFTGIVING_GOLD_MAX")
	self.taskConfig = flyingStarWishRead.getTaskConfig()
end
function flyingStarWishCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GIFT_GIVING_MODULE, gCmd.REQ_GIFT_GIVING_DATA, handler(self, self.sendInitRsp))
	msgCtrl.register(gCmd.CMD_GIFT_GIVING_MODULE, gCmd.REQ_GIFT_GIVING_BUY, handler(self, self.sendGiftBuyRsp))
	msgCtrl.register(gCmd.CMD_GIFT_GIVING_MODULE, gCmd.REQ_GIFT_GIVING_GET_TASK_REWARD, handler(self, self.sendGetTaskRewardRsp))
	self:resetData()
end
function flyingStarWishCtrl:initClientData(data)
	if not data then
		return
	end
	self:setData(data)
end
function flyingStarWishCtrl:Logout()
	flyingStarWishCtrl.super.Logout(self)
	self:resetData()
end
function flyingStarWishCtrl:setData(data)
	dump(data, "flyingStarWishCtrl:setData")
	self.lastBuyTime = data.lastBuyTime
	self.buyDays = data.buyDays
	self.dayBuyCount = data.dayBuyCount
	self.buyCount = data.buyCount
	self.dayBuyGolds = data.dayBuyGolds
	self.buyGolds = data.buyGolds
	self.task = data.task
end
function flyingStarWishCtrl:resetData()
	self.lastBuyTime = 0
	self.buyDays = 0
	self.dayBuyCount = 0
	self.buyCount = 0
	self.dayBuyGolds = 0
	self.task, _UPVALUE0_, self.buyGolds = nil, nil, 0
	self.allGiftCount = 0
	self.buyList, _UPVALUE0_, self.allPlayerCount = nil, nil, 0
end
function flyingStarWishCtrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_GIFT_GIVING_MODULE, gCmd.REQ_GIFT_GIVING_DATA)
end
function flyingStarWishCtrl:sendGiftBuyMsg(giftList)
	serverproxy:Request(gCmd.CMD_GIFT_GIVING_MODULE, gCmd.REQ_GIFT_GIVING_BUY, giftList)
end
function flyingStarWishCtrl:sendTaskRewardMsg(taskId)
	serverproxy = nil
	;(nil).taskId = taskId
	serverproxy:Request(gCmd.CMD_GIFT_GIVING_MODULE, gCmd.REQ_GIFT_GIVING_GET_TASK_REWARD, nil)
end
function flyingStarWishCtrl:getTaskList(quests)
	local _ENV, ret
	for i, v in pairs(quests) do
		local taskStatus = gBtnTargetStatusDef.GO
		local progress = 0
		if self.task then
			progress = v.type == 71 and self.buyDays or self.buyGolds
			if progress >= v.num and self.task[tostring(i)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif progress >= v.num then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		_ENV = i
		i.activityID = self.activityID
		i.taskID = v.Index
		_UPVALUE1_, i.taskStatus = v.Index, taskStatus
		v.Index.num = v.num
		i.taskDes, v.Index[1] = v.Index, v.type == 71 and "giftgiving_text_26" or "giftgiving_text_27"
		i.progress = progress
		i.aim = v.num
		i.guideId = nil
		i.isAct = 0
		_UPVALUE2_ = v.num
		v.num[1] = "id"
		v.num[2] = "count"
		i.award = serviceFunctions.tableFormat(v.reward, v.num)
		i.rank = v.rank
		table.insert(ret, i)
	end
	table.sort(ret, function(l, r)
		if l.taskStatus == r.taskStatus then
			return l.rank < r.rank
		else
			return l.taskStatus < r.taskStatus
		end
	end)
	return ret
end
function flyingStarWishCtrl:sendInitRsp(content)
	dump(content, "flyingStarWishCtrl:sendInitRsp")
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.myInfo)
		self.allGiftCount = content.rspdata.allGiftCount
		self.allPlayerCount = content.rspdata.allPlayerCount
		_ENV = self
		self.msg = "MESSAGE_FLYING_STAR_WISH"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function flyingStarWishCtrl:sendGiftBuyRsp(content)
	dump(content, "flyingStarWishCtrl:sendGiftBuyRsp")
	if content.err == gErrDef.Err_None then
		self.allGiftCount = content.rspdata.allGiftCount
		self.allPlayerCount = content.rspdata.allPlayerCount
		self:setData(content.rspdata.myInfo)
		self:clearBuyList()
		print("回调清空")
		_ENV = "回调清空"
		;("回调清空").msg = "MESSAGE_FLYING_STAR_WISH"
		;("回调清空").subMsg = "buySuccess"
		SoraDSendMessage("回调清空")
	end
end
function flyingStarWishCtrl:sendGetTaskRewardRsp(content)
	dump(content, "flyingStarWishCtrl:sendGetRewardRsp")
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_UPVALUE2_ = content.data.taskId
		content.data.taskId[1] = "id"
		content.data.taskId[2] = "count"
		SoraDMailGainItems(serviceFunctions.tableFormat(self.taskConfig[content.data.taskId].reward, content.data.taskId), true)
		_ENV = serviceFunctions.tableFormat(self.taskConfig[content.data.taskId].reward, content.data.taskId)
		serviceFunctions.tableFormat(self.taskConfig[content.data.taskId].reward, content.data.taskId).msg = "MESSAGE_FLYING_STAR_WISH"
		serviceFunctions.tableFormat(self.taskConfig[content.data.taskId].reward, content.data.taskId).subMsg = "task"
		SoraDSendMessage((serviceFunctions.tableFormat(self.taskConfig[content.data.taskId].reward, content.data.taskId)))
	end
end
function flyingStarWishCtrl:getReceiveStatusAndNum()
	for i, v in pairs(self.taskConfig) do
		local progress = v.type == 71 and self.buyDays or self.buyGolds
		if progress >= v.num and not self.task[tostring(i)] then
			return true, -1
		end
	end
	return false, 0
end
function flyingStarWishCtrl:getAllGiftCount()
	return self.allGiftCount
end
function flyingStarWishCtrl:getAllPlayerCount()
	return self.allPlayerCount
end
function flyingStarWishCtrl:getDayBuyCount()
	return self.dayBuyCount
end
function flyingStarWishCtrl:getDayBuyGold()
	return self.dayBuyGolds
end
function flyingStarWishCtrl:getLeftGold()
	return self.maxCostGold - self.dayBuyGolds
end
function flyingStarWishCtrl:resetDayData()
	self.dayBuyCount = 0
	self.dayBuyGolds = 0
	self.allGiftCount = 0
	self.allPlayerCount = 0
	self:clearBuyList()
end
function flyingStarWishCtrl:getHadBuyList()
	if not self.buyList then
		_UPVALUE0_ = self.buyList
	end
	return self.buyList
end
function flyingStarWishCtrl:saveBuyList(buyList)
	self.buyList = buyList
end
function flyingStarWishCtrl:clearBuyList()
	self.buyList, _UPVALUE0_ = nil, nil
	self.buyList = nil
end
return flyingStarWishCtrl
