local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackDayAwardPop = class("sultansBackDayAwardPop", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sultansBackDayAwardPop")
end)
function sultansBackDayAwardPop:ctor(properties)
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
end
function sultansBackDayAwardPop:initData(status, dayIndex)
	self.dayIndex = dayIndex
	_ENV = nil
	;(nil).day = dayIndex
	self.textTitle:setString(i18n("friend_return_text_03", nil))
	local dayConfig = sultansBackRead.getLoginRewardByDay(dayIndex)
	_UPVALUE2_ = i18n("friend_return_text_03", nil)
	i18n("friend_return_text_03", nil)[1] = "id"
	i18n("friend_return_text_03", nil)[2] = "count"
	local awardList = serviceFunctions.tableFormat(dayConfig.reward, i18n("friend_return_text_03", nil))
	for i, v in ipairs(awardList) do
		local itemNode = include("commonItemAward").new()
		itemNode:setScale(0.9)
		itemNode:setBaseScale(1.0)
		itemNode:setOwnView(self)
		itemNode:setPosition(0, 0)
		itemNode:addTo(self.nodeAward)
		itemNode:initData(v.id, v.count)
	end
	SoraDToCenter(self.nodeAward, 100, SoraDFIsRA())
	if status == gBtnTargetStatusDef.GET then
		self.btnOk:setTitleText(i18n("common_text_204"))
		self.btnOk:setVisible(true)
		self.Text_tip:setVisible(false)
	elseif status == gBtnTargetStatusDef.GO then
		self.Text_tip:setString(i18n("friend_back_text18"))
		self.Text_tip:setVisible(true)
		self.btnOk:setVisible(false)
	elseif status == gBtnTargetStatusDef.GOT then
		self.Text_tip:setString(i18n("common_text_1892"))
		self.Text_tip:setVisible(true)
		self.btnOk:setVisible(false)
	end
end
function sultansBackDayAwardPop:btnOkClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = nil
		;(nil).index = self.dayIndex
		sultansBackCtrl:reqBackLoginDayReceive(nil)
		self:removeFromParent()
	end
end
function sultansBackDayAwardPop:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return sultansBackDayAwardPop
