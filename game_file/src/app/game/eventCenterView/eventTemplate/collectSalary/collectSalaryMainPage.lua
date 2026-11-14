local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl")
local collectSalaryMainPage = class("collectSalaryMainPage", function(target)
	return target or SoraDCreateBasePanel("collectSalaryMainPage")
end)
_UPVALUE3_, collectSalaryMainPage.ctor = function(self)
	SoraDDeviceFitOffset(self)
	self.rankNodeTbl, _ENV = SoraDDeviceFitOffset, SoraDDeviceFitOffset
	self.activityID = gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	self.textTopTips = SoraDGetChildByName(self, "Text_Tips")
	self.textDownTips = SoraDGetChildByName(self, "Text_Rank_Tips")
	self.textPointTitle = SoraDGetChildByName(self, "Text_PointTitle")
	self.textPoint = SoraDGetChildByName(self, "Text_Point")
	self.textPointTitle:setString(i18n("common_text_625"))
	self.textTopTips:setString(i18n("treasuremap_text_04"))
	SoraDGetAutoHeightLabel(self.textTopTips, 630)
	self.textDownTips:setString(i18n("treasuremap_text_05"))
	self.btnGetWay = SoraDGetChildByName(self, "Button_GetWay")
	SoraDAutoSizeButtonText(self.btnGetWay, cc.size(124, 36))
	self.btnGetWay:setTitleText(i18n("common_text_4342"))
	self.btnGetWay:addTouchEventListener(handler(self, self.btnClickShowGetWay))
	self.animationNode = SoraDGetChildByName(self, "Animation_Node")
	self.animationNode = SoraDCreatAnimation("collectSalaryEffect", self.animationNode, true)
	SoraDMixtureGLONEByParent(self.animationNode)
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.timeNode = SoraDGetChildByName(self, "Node_Time")
	self.bgNode = SoraDGetChildByName(self, "Node_Bg")
	self.rankNode = SoraDGetChildByName(self, "Node_Rank")
	_UPVALUE3_, self.textNode = SoraDGetChildByName(self, "Node_ButtonAndText"), SoraDGetChildByName(self, "Node_ButtonAndText")
	SoraDGetChildByName(self, "Node_ButtonAndText")[1] = "Node_PRank"
	SoraDGetChildByName(self, "Node_ButtonAndText")[2] = "Node_LRank"
	local SoraDGetChildByName(self, "Node_ButtonAndText")[3], rankNodeName = "Node_ARank", SoraDGetChildByName(self, "Node_ButtonAndText")
	for i, v in ipairs(rankNodeName) do
		local single = SoraDGetChildByName(self.rankNode, v)
		single = self:initRankNode(i, single)
		self.rankNodeTbl[i] = single
	end
	collectSalaryCtrl:reqGetMyRankData()
	self:fitView()
	self.textPoint:setString(collectSalaryCtrl:getPointHave())
end, function(self)
	SoraDDeviceFitOffset(self)
	self.rankNodeTbl, _ENV = SoraDDeviceFitOffset, SoraDDeviceFitOffset
	self.activityID = gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	self.textTopTips = SoraDGetChildByName(self, "Text_Tips")
	self.textDownTips = SoraDGetChildByName(self, "Text_Rank_Tips")
	self.textPointTitle = SoraDGetChildByName(self, "Text_PointTitle")
	self.textPoint = SoraDGetChildByName(self, "Text_Point")
	self.textPointTitle:setString(i18n("common_text_625"))
	self.textTopTips:setString(i18n("treasuremap_text_04"))
	SoraDGetAutoHeightLabel(self.textTopTips, 630)
	self.textDownTips:setString(i18n("treasuremap_text_05"))
	self.btnGetWay = SoraDGetChildByName(self, "Button_GetWay")
	SoraDAutoSizeButtonText(self.btnGetWay, cc.size(124, 36))
	self.btnGetWay:setTitleText(i18n("common_text_4342"))
	self.btnGetWay:addTouchEventListener(handler(self, self.btnClickShowGetWay))
	self.animationNode = SoraDGetChildByName(self, "Animation_Node")
	self.animationNode = SoraDCreatAnimation("collectSalaryEffect", self.animationNode, true)
	SoraDMixtureGLONEByParent(self.animationNode)
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.timeNode = SoraDGetChildByName(self, "Node_Time")
	self.bgNode = SoraDGetChildByName(self, "Node_Bg")
	self.rankNode = SoraDGetChildByName(self, "Node_Rank")
	_UPVALUE3_, self.textNode = SoraDGetChildByName(self, "Node_ButtonAndText"), SoraDGetChildByName(self, "Node_ButtonAndText")
	SoraDGetChildByName(self, "Node_ButtonAndText")[1] = "Node_PRank"
	SoraDGetChildByName(self, "Node_ButtonAndText")[2] = "Node_LRank"
	local SoraDGetChildByName(self, "Node_ButtonAndText")[3], rankNodeName = "Node_ARank", SoraDGetChildByName(self, "Node_ButtonAndText")
	for i, v in ipairs(rankNodeName) do
		local single = SoraDGetChildByName(self.rankNode, v)
		single = self:initRankNode(i, single)
		self.rankNodeTbl[i] = single
	end
	collectSalaryCtrl:reqGetMyRankData()
	self:fitView()
	self.textPoint:setString(collectSalaryCtrl:getPointHave())
end
;(function(self)
	SoraDDeviceFitOffset(self)
	self.rankNodeTbl, _ENV = SoraDDeviceFitOffset, SoraDDeviceFitOffset
	self.activityID = gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	self.textTopTips = SoraDGetChildByName(self, "Text_Tips")
	self.textDownTips = SoraDGetChildByName(self, "Text_Rank_Tips")
	self.textPointTitle = SoraDGetChildByName(self, "Text_PointTitle")
	self.textPoint = SoraDGetChildByName(self, "Text_Point")
	self.textPointTitle:setString(i18n("common_text_625"))
	self.textTopTips:setString(i18n("treasuremap_text_04"))
	SoraDGetAutoHeightLabel(self.textTopTips, 630)
	self.textDownTips:setString(i18n("treasuremap_text_05"))
	self.btnGetWay = SoraDGetChildByName(self, "Button_GetWay")
	SoraDAutoSizeButtonText(self.btnGetWay, cc.size(124, 36))
	self.btnGetWay:setTitleText(i18n("common_text_4342"))
	self.btnGetWay:addTouchEventListener(handler(self, self.btnClickShowGetWay))
	self.animationNode = SoraDGetChildByName(self, "Animation_Node")
	self.animationNode = SoraDCreatAnimation("collectSalaryEffect", self.animationNode, true)
	SoraDMixtureGLONEByParent(self.animationNode)
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.timeNode = SoraDGetChildByName(self, "Node_Time")
	self.bgNode = SoraDGetChildByName(self, "Node_Bg")
	self.rankNode = SoraDGetChildByName(self, "Node_Rank")
	_UPVALUE3_, self.textNode = SoraDGetChildByName(self, "Node_ButtonAndText"), SoraDGetChildByName(self, "Node_ButtonAndText")
	SoraDGetChildByName(self, "Node_ButtonAndText")[1] = "Node_PRank"
	SoraDGetChildByName(self, "Node_ButtonAndText")[2] = "Node_LRank"
	local SoraDGetChildByName(self, "Node_ButtonAndText")[3], rankNodeName = "Node_ARank", SoraDGetChildByName(self, "Node_ButtonAndText")
	for i, v in ipairs(rankNodeName) do
		local single = SoraDGetChildByName(self.rankNode, v)
		single = self:initRankNode(i, single)
		self.rankNodeTbl[i] = single
	end
	collectSalaryCtrl:reqGetMyRankData()
	self:fitView()
	self.textPoint:setString(collectSalaryCtrl:getPointHave())
end)[1] = "rides_title_01"
;(function(self)
	SoraDDeviceFitOffset(self)
	self.rankNodeTbl, _ENV = SoraDDeviceFitOffset, SoraDDeviceFitOffset
	self.activityID = gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	self.textTopTips = SoraDGetChildByName(self, "Text_Tips")
	self.textDownTips = SoraDGetChildByName(self, "Text_Rank_Tips")
	self.textPointTitle = SoraDGetChildByName(self, "Text_PointTitle")
	self.textPoint = SoraDGetChildByName(self, "Text_Point")
	self.textPointTitle:setString(i18n("common_text_625"))
	self.textTopTips:setString(i18n("treasuremap_text_04"))
	SoraDGetAutoHeightLabel(self.textTopTips, 630)
	self.textDownTips:setString(i18n("treasuremap_text_05"))
	self.btnGetWay = SoraDGetChildByName(self, "Button_GetWay")
	SoraDAutoSizeButtonText(self.btnGetWay, cc.size(124, 36))
	self.btnGetWay:setTitleText(i18n("common_text_4342"))
	self.btnGetWay:addTouchEventListener(handler(self, self.btnClickShowGetWay))
	self.animationNode = SoraDGetChildByName(self, "Animation_Node")
	self.animationNode = SoraDCreatAnimation("collectSalaryEffect", self.animationNode, true)
	SoraDMixtureGLONEByParent(self.animationNode)
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.timeNode = SoraDGetChildByName(self, "Node_Time")
	self.bgNode = SoraDGetChildByName(self, "Node_Bg")
	self.rankNode = SoraDGetChildByName(self, "Node_Rank")
	_UPVALUE3_, self.textNode = SoraDGetChildByName(self, "Node_ButtonAndText"), SoraDGetChildByName(self, "Node_ButtonAndText")
	SoraDGetChildByName(self, "Node_ButtonAndText")[1] = "Node_PRank"
	SoraDGetChildByName(self, "Node_ButtonAndText")[2] = "Node_LRank"
	local SoraDGetChildByName(self, "Node_ButtonAndText")[3], rankNodeName = "Node_ARank", SoraDGetChildByName(self, "Node_ButtonAndText")
	for i, v in ipairs(rankNodeName) do
		local single = SoraDGetChildByName(self.rankNode, v)
		single = self:initRankNode(i, single)
		self.rankNodeTbl[i] = single
	end
	collectSalaryCtrl:reqGetMyRankData()
	self:fitView()
	self.textPoint:setString(collectSalaryCtrl:getPointHave())
end)[2] = "rides_title_02"
local (function(self)
	SoraDDeviceFitOffset(self)
	self.rankNodeTbl, _ENV = SoraDDeviceFitOffset, SoraDDeviceFitOffset
	self.activityID = gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	self.textTopTips = SoraDGetChildByName(self, "Text_Tips")
	self.textDownTips = SoraDGetChildByName(self, "Text_Rank_Tips")
	self.textPointTitle = SoraDGetChildByName(self, "Text_PointTitle")
	self.textPoint = SoraDGetChildByName(self, "Text_Point")
	self.textPointTitle:setString(i18n("common_text_625"))
	self.textTopTips:setString(i18n("treasuremap_text_04"))
	SoraDGetAutoHeightLabel(self.textTopTips, 630)
	self.textDownTips:setString(i18n("treasuremap_text_05"))
	self.btnGetWay = SoraDGetChildByName(self, "Button_GetWay")
	SoraDAutoSizeButtonText(self.btnGetWay, cc.size(124, 36))
	self.btnGetWay:setTitleText(i18n("common_text_4342"))
	self.btnGetWay:addTouchEventListener(handler(self, self.btnClickShowGetWay))
	self.animationNode = SoraDGetChildByName(self, "Animation_Node")
	self.animationNode = SoraDCreatAnimation("collectSalaryEffect", self.animationNode, true)
	SoraDMixtureGLONEByParent(self.animationNode)
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.timeNode = SoraDGetChildByName(self, "Node_Time")
	self.bgNode = SoraDGetChildByName(self, "Node_Bg")
	self.rankNode = SoraDGetChildByName(self, "Node_Rank")
	_UPVALUE3_, self.textNode = SoraDGetChildByName(self, "Node_ButtonAndText"), SoraDGetChildByName(self, "Node_ButtonAndText")
	SoraDGetChildByName(self, "Node_ButtonAndText")[1] = "Node_PRank"
	SoraDGetChildByName(self, "Node_ButtonAndText")[2] = "Node_LRank"
	local SoraDGetChildByName(self, "Node_ButtonAndText")[3], rankNodeName = "Node_ARank", SoraDGetChildByName(self, "Node_ButtonAndText")
	for i, v in ipairs(rankNodeName) do
		local single = SoraDGetChildByName(self.rankNode, v)
		single = self:initRankNode(i, single)
		self.rankNodeTbl[i] = single
	end
	collectSalaryCtrl:reqGetMyRankData()
	self:fitView()
	self.textPoint:setString(collectSalaryCtrl:getPointHave())
end)[3], rankName = "treasuremap_text_06", function(self)
	SoraDDeviceFitOffset(self)
	self.rankNodeTbl, _ENV = SoraDDeviceFitOffset, SoraDDeviceFitOffset
	self.activityID = gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	self.textTopTips = SoraDGetChildByName(self, "Text_Tips")
	self.textDownTips = SoraDGetChildByName(self, "Text_Rank_Tips")
	self.textPointTitle = SoraDGetChildByName(self, "Text_PointTitle")
	self.textPoint = SoraDGetChildByName(self, "Text_Point")
	self.textPointTitle:setString(i18n("common_text_625"))
	self.textTopTips:setString(i18n("treasuremap_text_04"))
	SoraDGetAutoHeightLabel(self.textTopTips, 630)
	self.textDownTips:setString(i18n("treasuremap_text_05"))
	self.btnGetWay = SoraDGetChildByName(self, "Button_GetWay")
	SoraDAutoSizeButtonText(self.btnGetWay, cc.size(124, 36))
	self.btnGetWay:setTitleText(i18n("common_text_4342"))
	self.btnGetWay:addTouchEventListener(handler(self, self.btnClickShowGetWay))
	self.animationNode = SoraDGetChildByName(self, "Animation_Node")
	self.animationNode = SoraDCreatAnimation("collectSalaryEffect", self.animationNode, true)
	SoraDMixtureGLONEByParent(self.animationNode)
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.timeNode = SoraDGetChildByName(self, "Node_Time")
	self.bgNode = SoraDGetChildByName(self, "Node_Bg")
	self.rankNode = SoraDGetChildByName(self, "Node_Rank")
	_UPVALUE3_, self.textNode = SoraDGetChildByName(self, "Node_ButtonAndText"), SoraDGetChildByName(self, "Node_ButtonAndText")
	SoraDGetChildByName(self, "Node_ButtonAndText")[1] = "Node_PRank"
	SoraDGetChildByName(self, "Node_ButtonAndText")[2] = "Node_LRank"
	local SoraDGetChildByName(self, "Node_ButtonAndText")[3], rankNodeName = "Node_ARank", SoraDGetChildByName(self, "Node_ButtonAndText")
	for i, v in ipairs(rankNodeName) do
		local single = SoraDGetChildByName(self.rankNode, v)
		single = self:initRankNode(i, single)
		self.rankNodeTbl[i] = single
	end
	collectSalaryCtrl:reqGetMyRankData()
	self:fitView()
	self.textPoint:setString(collectSalaryCtrl:getPointHave())
end
function collectSalaryMainPage:initRankNode(rankType, parent)
	local textRankName = SoraDGetChildByName(parent, "Text_Name")
	textRankName:setString(i18n(rankName[rankType]))
	local bmfRank = SoraDGetChildByName(parent, "BMF_Rank")
	bmfRank:setVisible(false)
	local textRank = SoraDGetChildByName(parent, "Text_Rank")
	textRank:setVisible(false)
	parent.textRank = textRank
	parent.bmfRank = bmfRank
	local btnJump = SoraDGetChildByName(parent, "Button_Rank")
	btnJump:setTag(rankType)
	btnJump:addTouchEventListener(handler(self, self.btnClickJumpToRank))
	local textMore = SoraDGetChildByName(parent, "Text_More")
	if textMore then
		textMore = SoraDChangeTextToHtml(textMore)
		_ENV = handler(self, self.btnClickJumpToRank)
		_ENV, _ENV, handler(self, self.btnClickJumpToRank).name = "common_text_3825", i18n("common_text_3825"), i18n("common_text_3825")
		i18n("common_text_3825").name, ("common_text_3825").u = "common_text_3825", "true"
		local str = i18n_html("common_text_035", handler(self, self.btnClickJumpToRank))
		textMore:setString(str)
	end
	return parent
end
function collectSalaryMainPage:fitView()
	local panelHeight = self:getPanelOffsetHeight()
	local offsetY = panelHeight - 960
	if panelHeight < 900 then
		SoraDGetChildByName(self.bgNode, "Image_Bg"):setPositionY(-60)
		self.bgNode:setPositionY(self.bgNode:getPositionY() + 80)
		self.timeNode:setPositionY(self.timeNode:getPositionY() + 90)
		self.rankNode:setPositionY(self.rankNode:getPositionY() + 100)
		self.textNode:setPositionY(self.textNode:getPositionY() + 100)
	elseif 0 < offsetY then
		offsetY = 50 < offsetY and 50 or offsetY
		self.bgNode:setPositionY(self.bgNode:getPositionY() - offsetY)
		self.timeNode:setPositionY(self.timeNode:getPositionY() - offsetY)
		self.rankNode:setPositionY(self.rankNode:getPositionY() - offsetY - 20)
		self.textNode:setPositionY(self.textNode:getPositionY() - offsetY - 40)
	end
	if 1290 < panelHeight then
		self.textTopTips:setPositionY(self.textTopTips:getPositionY() - 20)
		self.textNode:setPositionY(self.textNode:getPositionY() - 70)
		self.rankNode:setPositionY(self.rankNode:getPositionY() - 40)
	end
	if SoraDFIsRA() then
		self.textPoint:setPositionX(self.textPointTitle:getPositionX() - self.textPointTitle:getContentSize().width)
	end
end
function collectSalaryMainPage:updataInfo(target, data)
	if data.subMsg == "notify" then
		self.textPoint:setString(collectSalaryCtrl:getPointHave())
	elseif data.subMsg == "myRank" then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local hasAlliance = allianceMgr:hasJoinAlliance()
		for i, v in ipairs(self.rankNodeTbl) do
			local rank = collectSalaryCtrl:getMyRank(i)
			v.bmfRank:setVisible(0 < rank)
			v.textRank:setVisible(not (0 < rank))
			if 0 < rank then
				v.bmfRank:setString(rank)
			else
				v.textRank:setString(i18n("herobattle_text_05"))
				if not hasAlliance and i ~= gCollectSalaryRankType.PERSONAL_RANK_TYPE then
					v.textRank:setString(i18n("pyramid_text_02"))
				elseif hasAlliance and rank < 0 and i == 3 then
					v.textRank:setString(i18n("herobattle_text_05"))
				end
			end
		end
	end
end
function collectSalaryMainPage:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_COLLECT_RANK_MESSAGE", handler(self, self.updataInfo))
end
function collectSalaryMainPage:btnClickShowGetWay(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("collectSalaryGetWay"):show()
	end
end
function collectSalaryMainPage:btnClickJumpToRank(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rankType = button:getTag()
		_ENV = nil
		;(nil).msg = "MESSAGE_COLLECT_RANK_MESSAGE"
		;(nil).subMsg = "Jump"
		;(nil).rankType = rankType
		SoraDSendMessage(nil)
	end
end
return collectSalaryMainPage
