local activityCtrl = SoraDGetCtrl("activityCtrl")
local activityltCtrl = include("activityltCtrl")
local activityLogic = include("activityLogic")
local kingsOrderRead = include("kingsOrderRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Score = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001061/Com_Score", Com_Score)
function Com_Score:onInit()
	self:fixChildrenPos()
	self.fields.LoadingBar_bar:fixChildrenPos()
	self.fields.Text_myScore:setString(i18n("common_text_625"))
	self.fields.Text_scoreRoad:setString(i18n("common_text_623"))
	self.fields.Button_helpTip:addClickListener(handler(self, self.onBtnHelpTip))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function Com_Score:onItemRender(index, target)
	target:initData(self.tableScoreRoadData[index + 1])
end
function Com_Score:onShow()
end
function Com_Score:updateView()
	local sectionEventID = activityCtrl.curActivityID
	self.isNewServer = activityCtrl.isNewServer
	self.serverLv = activityCtrl.serverLv
	local rewardTable = activityLogic.getPointReward(sectionEventID)
	if next(rewardTable) == nil then
		return
	end
	self:initProgressBar(rewardTable)
	for k = 1, 3 do
		local isGot = activityCtrl:pointRewardIsGet(rewardTable[k].pointID)
		self.fields["RewardNode_" .. k]:initData(rewardTable[k], isGot)
	end
	self:setScoreRoad()
end
function Com_Score:initProgressBar(rewardTable)
	local myScore = activityCtrl.activityScore
	local percent = 0
	local maxScore = rewardTable[table.nums(rewardTable)].needPoint
	if myScore >= maxScore then
		percent = 1
	else
		local per = 1 / table.nums(rewardTable)
		local curIndex = 0
		for k, v in ipairs(rewardTable) do
			if myScore <= v.needPoint then
				curIndex = k
				break
			end
		end
		local prePoint = 1 < curIndex and rewardTable[curIndex - 1].needPoint or 0
		percent = (curIndex - 1) * per + per * (myScore - prePoint) / (rewardTable[curIndex].needPoint - prePoint)
	end
	self.fields.LoadingBar_bar:setMax(100)
	self.fields.LoadingBar_bar:setPercent(percent)
	self.fields.LoadingBar_bar:getChild("title_score"):setString(string.formatnumberthousands(myScore))
end
function Com_Score:setScoreRoad()
	self.stringHelpData, activityltCtrl, self.tableScoreRoadData, activityltCtrl = nil, nil, nil, nil
	local list = activityltCtrl.getEventIDList(activityCtrl.curActivityID, activityCtrl.serverLv)
	for k, v in ipairs(list) do
		local point = activityltCtrl.getEventPoint(v)
		local first = activityltCtrl.getEventCondition(v)
		local arg1, arg2 = 1, 1
		if first < 1 then
			arg1, arg2 = -first, 1
		elseif 1 < first then
			arg1, arg2 = 1, first
		end
		local arg3 = math.abs(activityltCtrl.getEventPoint(v))
		local txtID = activityltCtrl.getEventText(v)
		activityltCtrl = txtID
		txtID.count = arg1
		txtID.level = arg2
		local txt = i18n(kingsOrderRead.getSectionEventContent(txtID), txtID)
		activityltCtrl = txtID
		txtID.eventID = v
		txtID.point = point
		self.tableScoreRoadData[k], txtID.txt = txtID, txt
		activityltCtrl = txtID
		txtID.count = arg1
		txtID.level = arg2
		txtID.point = arg3
		txtID.string = i18n(kingsOrderRead.getSectionEventDescArmy(arg2))
		self.stringHelpData[k] = i18n(kingsOrderRead.getSectionEventDesc(txtID), txtID)
	end
	self.fields.List:setNumItems(#self.tableScoreRoadData)
	self.fields.List:resizeToFit(#self.tableScoreRoadData)
end
function Com_Score:onBtnHelpTip()
	SoraDShowFixWindow(i18n("common_text_695"), self.stringHelpData)
end
return Com_Score
