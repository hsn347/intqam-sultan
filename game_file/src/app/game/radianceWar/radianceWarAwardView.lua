local radianceWarAwardView = class("radianceWarAwardView", function(target)
	return target or SoraDCreateBasePanel("radianceWarAwardView")
end)
local REWARD_VIEW_TYPE = include("radianceWarDef").REWARD_VIEW_TYPE
function radianceWarAwardView:ctor(properties)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY
	self.nodeRadianceWarAwardPersonalView = SoraDGetExtendChildFromCCSByName(self, "CCS_radianceWarAwardPersonalView", true)
	self.nodeRadianceWarAwardAllianceView = SoraDGetExtendChildFromCCSByName(self, "CCS_radianceWarAwardAllianceView", true)
	self.nodeRadianceWarAwardKingdomWinsView = SoraDGetExtendChildFromCCSByName(self, "CCS_radianceWarAwardKingdomWinsView", true)
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("brightWar_text_26"))
	_ENV, self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabNum = 3
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").defaultClick = "Top_CCS_commonTabBtn", self, 1
	;("Top_CCS_commonTabBtn").title = i18n("brightWar_text_208")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").tag = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_PERSONAL
	_ENV, self[1], ("Top_CCS_commonTabBtn").fontSize = "Top_CCS_commonTabBtn", "Top_CCS_commonTabBtn", 22
	;("Top_CCS_commonTabBtn").title = i18n("brightWar_title_02")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").tag = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_ALLIANCE
	_ENV, self[2], ("Top_CCS_commonTabBtn").fontSize = "Top_CCS_commonTabBtn", "Top_CCS_commonTabBtn", 22
	;("Top_CCS_commonTabBtn").title = i18n("brightWar_title_03")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").tag = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_WINNER
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabsetArray, self[3], ("Top_CCS_commonTabBtn").fontSize = self, "Top_CCS_commonTabBtn", 22
	local tableData = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.nodeCommonTabBtn:initView(tableData)
end
function radianceWarAwardView:initData(target, data)
end
function radianceWarAwardView:btnTabClick(showViewType)
	self.showViewType = showViewType
	self.nodeRadianceWarAwardPersonalView:setVisible(showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_PERSONAL)
	self.nodeRadianceWarAwardAllianceView:setVisible(showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_ALLIANCE)
	self.nodeRadianceWarAwardKingdomWinsView:setVisible(showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_WINNER)
end
function radianceWarAwardView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("key"))
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return radianceWarAwardView
