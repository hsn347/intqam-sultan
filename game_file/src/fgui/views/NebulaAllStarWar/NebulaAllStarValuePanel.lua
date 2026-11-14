local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaAllStarRead = include("nebulaAllStarRead")
local RANK_TYPE = nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarValuePanel = class("NebulaAllStarValuePanel", baseFguiPanel)
function NebulaAllStarValuePanel:ctor(...)
	NebulaAllStarValuePanel.super.ctor(self, ...)
	print("NebulaAllStarValuePanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.robValue = nebulaAllStarCtrl:getRobValue()
	self.rewardList, NebulaAllStarValuePanel, self.taskData, NebulaAllStarValuePanel, self.taskList, NebulaAllStarValuePanel, self.myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo(), nebulaAllStarCtrl:getMyTeamInfo(), nebulaAllStarCtrl:getMyTeamInfo(), nebulaAllStarCtrl:getMyTeamInfo(), nebulaAllStarCtrl:getMyTeamInfo(), nebulaAllStarCtrl:getMyTeamInfo(), nebulaAllStarCtrl:getMyTeamInfo()
end
function NebulaAllStarValuePanel:onInit()
	print("=======NebulaAllStarValuePanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Button_rank:setString(i18n("common_text_851"))
	self.fields.Button_rank:addClickListener(handler(self, self.onClickBtnRank))
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskItemRenderer))
	self.fields.List_task:setVirtual()
	self.fields.List_rewad:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_rewad:setVirtual()
	_ENV = self.fields.List_rewad.setVirtual
	_ENV, _ENV, self.fields.List_rewad.setVirtual.defaultClick = handler(self, self.onRewardItemRenderer)
	_ENV, self.fields.List_rewad[1], handler(self, self.onRewardItemRenderer).title = handler(self, self.onRewardItemRenderer)
	self.fields.List_rewad.setVirtual.tabsetArray, self.fields.List_rewad[2], handler(self, self.onRewardItemRenderer).title = self.fields.List_rewad, handler(self, self.onRewardItemRenderer)
	local self.fields.List_rewad.setVirtual.callback, param = handler(self, self.onClickTab), self.fields.List_rewad.setVirtual
	self.fields.com_Tab:initView(param)
	if not SoraDFIsRA() then
		self.fields.Com_head:fixPos()
		self.fields.Text_score:fixPos()
		self.fields.Text_rank:fixPos()
	end
end
function NebulaAllStarValuePanel:onShow()
	print("=======NebulaAllStarValuePanel:onShow")
	local _ENV, taskList = print, print
	local _ENV, rewardList = "=======NebulaAllStarValuePanel:onShow", "=======NebulaAllStarValuePanel:onShow"
	local rankType, handlerHelp
	if self.myTeamInfo:getIsSuperTeam() then
		self.controllers.c2:setSelectedIndex(0)
		self.fields.Com_title:setString(i18n("NebulaAllstar_165"))
		self.fields.Text_des:setString(i18n("NebulaAllstar_168"))
		taskList = nebulaAllStarRead.getScoreTaskList(true)
		rewardList = nebulaAllStarRead.getRobRewardConfig(true)
		rankType = RANK_TYPE.STAR_ROB_VALUE
		handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("allStarTeamValue")
	elseif self.myTeamInfo:getIsBackupTeam() then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Com_title:setString(i18n("NebulaAllstar_181"))
		self.fields.Text_des:setString(i18n("NebulaAllstar_182"))
		taskList = nebulaAllStarRead.getScoreTaskList()
		rewardList = nebulaAllStarRead.getRobRewardConfig()
		rankType = RANK_TYPE.SUPPORT_ROB_VALUE
		handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("backupTeamValue")
	end
	self.taskList = taskList
	self:updateRobTask()
	self.rewardList = rewardList
	self.fields.List_rewad:setNumItems(#self.rewardList)
	if rankType then
		nebulaAllStarCtrl:reqRankData(rankType, 1, 1, "NebulaAllStarValue")
	end
	if handlerHelp then
		self.fields.Com_title:setHelpCallBack(handlerHelp)
	end
end
function NebulaAllStarValuePanel:onClickBtnRank()
	SoraDPlaySound()
	nebulaAllStarUtil.openRankView()
end
function NebulaAllStarValuePanel:onClickTab(tag)
	print("==NebulaAllStarValuePanel:onClickTab==", tag)
	self.curSelect = tag
	self.controllers.c1:setSelectedIndex(tag - 1)
end
function NebulaAllStarValuePanel:onTaskItemRenderer(index, obj)
	local data = self.taskData[index + 1]
	obj:initData(data)
	obj:setHandler(handler(self, self.getAwardHandler), handler(self, self.skipToHandler))
end
function NebulaAllStarValuePanel:getAwardHandler(taskID)
	nebulaAllStarCtrl:reqRobTaskReward(taskID)
	SoraDShowLoading(self:displayObject())
end
function NebulaAllStarValuePanel:skipToHandler(guideId, taskDes)
	SoraDRemoveAllPanelFromManager()
end
function NebulaAllStarValuePanel:onMsgUpdateRobTask(target, event)
	SoraDCloseLoading(self:displayObject())
	self:updateRobTask()
end
function NebulaAllStarValuePanel:updateRobTask()
	local isSuperTeam = self.myTeamInfo:getIsSuperTeam()
	local _ENV, ret = self.myTeamInfo, self.myTeamInfo
	for taskID, cfg in ipairs(self.taskList) do
		_ENV = nil
		;(nil).taskID = taskID
		;(nil).taskStatus = nebulaAllStarCtrl:getRobTaskState(taskID, isSuperTeam)
		;(nil).taskDes = cfg.des
		;(nil).count = self.robValue
		;(nil).total = cfg.task
		_UPVALUE2_ = taskID
		taskID[1] = "id"
		taskID[2] = "count"
		;(nil).award = serviceFunctions.tableFormat(cfg.reward, taskID)
		table.insert(ret, nil)
	end
	self.taskData = ret
	_UPVALUE2_, _UPVALUE2_ = nil, ipairs(self.taskList)
	_UPVALUE2_, (nil)[1] = "taskStatus", "taskStatus"
	_UPVALUE2_, (nil)[2] = "taskStatus", "<"
	;("taskStatus")[1] = "total"
	;("taskStatus")[2] = "<"
	ipairs(self.taskList)[1] = nil
	ipairs(self.taskList)[2] = "taskStatus"
	serviceFunctions.sort(self.taskData, ipairs(self.taskList))
	self.fields.List_task:setNumItems(#self.taskData)
end
function NebulaAllStarValuePanel:onRewardItemRenderer(index, obj)
	local cfg = self.rewardList[index + 1]
	local rankStr = nebulaAllStarRead.getRewardConfigRankStr(cfg)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj:fixChildrenPos()
	end
	local _fields = obj._fields
	nebulaAllStarRead = nil
	;(nil).rank = cfg.rankCorridor[1]
	;(nil).rankStr = rankStr
	_fields.Com_rankBase:initRankBaseData(nil)
	if not cfg.reward then
		local nebulaAllStarRead, rewards = cfg.reward, cfg.reward
	end
	_fields.List:setItemRenderer(function(_index, _obj)
		_obj:initData(rewards[_index * 2 + 1], rewards[_index * 2 + 2])
	end)
	_fields.List:setNumItems(#rewards / 2)
end
function NebulaAllStarValuePanel:updateMyRankInfo(myInfo)
	myInfo = nebulaAllStarUtil.getRankDataMyInfo(myInfo)
	self.fields.Com_head:setHeadSprite(myInfo.headid, myInfo.avatar)
	self.fields.Com_head:setAvatarFrame(myInfo.avatarFrameId)
	nebulaAllStarUtil = nil
	;(nil).num = string.formatnumberthousands(self.robValue)
	self.fields.Text_score:setString(i18n("common_text_1256", nil))
	local rank = myInfo.rank or 0
	local rankStr = nebulaAllStarUtil.getRankStr(rank)
	nebulaAllStarUtil = i18n("common_text_1256", nil)
	i18n("common_text_1256", nil).rank = rankStr
	self.fields.Text_rank:setString(i18n("common_text_825", i18n("common_text_1256", nil)))
end
return NebulaAllStarValuePanel
