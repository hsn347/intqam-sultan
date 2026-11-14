local publicRead = include("publicRead")
local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local princeGiftRead = include("princeGiftRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local princeGiftView = class("princeGiftView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("princeGiftView")
	end
	return target
end)
function princeGiftView:ctor()
	self:initControls()
	self:initEffect()
end
function princeGiftView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_INIT", function(target, data)
		SoraDCloseLoading()
		self:setPackageInfo()
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_BUY_PACKAGE", function(target, data)
		SoraDCloseLoading()
		self:removeFromParent()
		SoraDCreatePanel("princeGiftTaskView"):show()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.initData))
end
function princeGiftView:initEffect()
	SoraDMixtureGLONEByParent(self.Node_Award)
	SoraDMixtureGLONEByParent(self.Node_Buff)
	SoraDMixtureGLONEByParent(self.Node_Task)
	local loop = false
	local cssFileName = "princeGiftView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	action:setFrameEventCallFunc(handler(self, function(target, frameEventName)
		local frameEvent = frameEventName:getEvent()
		if frameEvent and frameEvent == "ENDINACTON" then
			action:gotoFrameAndPlay(50, true)
		end
	end))
	self:runAction(action)
	local topEffect = SoraDGetChildByName(self, "top_Effect")
	local effectNode = SoraDCreatAnimation("princeGiftEffect", nil, true)
	topEffect:addChild(effectNode)
end
function princeGiftView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("Wisdom_of_oriental_prince_text_01"))
	self.activityID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
	self.Text_More = SoraDChangeTextToHtml(self.Text_More)
	self.Text_Title_1:setString(i18n("Payment_activity_optimization_text_01"))
	self.Text_Describe:setString(i18n("Payment_activity_optimization_text_02"))
	self.Text_Title_2:setString(i18n("Payment_activity_optimization_text_06"))
	_ENV = i18n("Payment_activity_optimization_text_06")
	_ENV, _ENV, i18n("Payment_activity_optimization_text_06").commonStr = "valueTreasure_text_04", i18n("valueTreasure_text_04"), i18n("valueTreasure_text_04")
	;("valueTreasure_text_04").color = "#3BDE33"
	;("valueTreasure_text_04").c = "true"
	_ENV, i18n("valueTreasure_text_04").commonStr, ("valueTreasure_text_04").u = "valueTreasure_text_04", "valueTreasure_text_04", "true"
	i18n("valueTreasure_text_04").__default, ("valueTreasure_text_04").color = "valueTreasure_text_04", "#ffffff"
	self.Text_More:setString(i18n_html("common_text_034", i18n("Payment_activity_optimization_text_06")))
	self.Text_TaskDescribe:setString(i18n("Payment_activity_optimization_text_24"))
	self.Text_BuffDescribe:setString(i18n("Payment_activity_optimization_text_05"))
	self.Button_More:addTouchEventListener(handler(self, self.btnClickMore))
	self.Button_Detail:addTouchEventListener(handler(self, self.buttonTaskDetailCallBack))
	self.Button_buy:addTouchEventListener(handler(self, self.buttonBuyPackageCallBack))
	self.btnHelpTip:addTouchEventListener(handler(self, self.buttonHelpCallBack))
	self.Node:setPositionY(math.max(500, self.Top_ScrollView_Size:getContentSize().height))
	print(self.Top_ScrollView_Size:getContentSize().height)
	if 500 <= self.Top_ScrollView_Size:getContentSize().height then
		self.Top_ScrollView_Size:setPositionY(self.Top_ScrollView_Size:getPositionY() + (500 - self.Top_ScrollView_Size:getContentSize().height) / 2)
	end
	self.Top_ScrollView_Size:setTouchEnabled(500 > self.Top_ScrollView_Size:getContentSize().height)
	self:initRewardNode()
	self:initTaskRewardNode()
	princeGiftCtrl:reqInitInfo()
	SoraDShowLoading()
end
function princeGiftView:setPackageInfo()
	local firtPackageInfo = princeGiftRead.getFirstPackageInfo()
	local nowPrice = paymentManager.judgePrice(firtPackageInfo.ID, firtPackageInfo.price)
	self.Text_nowPrice:setString(tostring(nowPrice))
	local discount = firtPackageInfo.originalPrice / firtPackageInfo.price
	local showDiscount = math.floor(firtPackageInfo.originalPrice / firtPackageInfo.price * 100)
	local oriPrice = paymentManager.calculateDiscount(firtPackageInfo.ID, nowPrice, discount, firtPackageInfo.originalPrice)
	self.Text_oriPrice:setString(tostring(oriPrice))
	self.Text_discount:setString(showDiscount .. "%")
	self.Button_buy:setTag(firtPackageInfo.ID)
end
function princeGiftView:initData()
	local stage = princeGiftCtrl:getWhichStage()
	local unReceiveNum = princeGiftRead.getTotalUnreceiveRewardNum(princeGiftCtrl:getCurScore())
	princeGiftCtrl = princeGiftCtrl:getCurScore()
	princeGiftCtrl:getCurScore().byUID = true
	local saveNum = SoraDConfigGet("Game:princeGiftView:rewardNum~integer", princeGiftCtrl:getCurScore())
	self.Image_redPoint:setVisible(stage == 1 and unReceiveNum > saveNum)
end
function princeGiftView:buttonBuyPackageCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		princeGiftCtrl:reqBuyPackage(button:getTag())
		SoraDShowLoading()
	end
end
function princeGiftView:initRewardNode()
	local packageInfo = princeGiftRead.getFirstPackageInfo()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(packageInfo.gift, nil)
	for i, v in ipairs(rewardList) do
		local item = include("commonItemAward").new()
		item:setScale(0.7)
		item:setBaseScale(1.0)
		item:setOwnView(self)
		item:setPosition(0, 0)
		item:initData(v.id, v.count)
		item:addTo(self.Node_Reward)
		item:setSwallowTouches(true)
	end
	SoraDautoSortPos(self.Node_Reward, 2, 1, cc.size(80, 80), SoraDFIsRA())
end
function princeGiftView:initTaskRewardNode()
	local packageInfo = princeGiftRead.getFirstPackageInfo()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(packageInfo.special_display, nil)
	for i, v in ipairs(rewardList) do
		if i <= 3 then
			local item = include("commonItemAward").new()
			item:setScale(0.55)
			item:setBaseScale(1.0)
			item:setOwnView(self)
			item:setPosition(0, 0)
			item:initData(v.id, v.count)
			item:addTo(self.Node_TaskAward)
			item:setSwallowTouches(true)
		end
	end
	SoraDToCenter(self.Node_TaskAward, 60, SoraDFIsRA())
end
function princeGiftView:buttonTaskDetailCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("princeGiftTaskExplainPopView")
		panel:show()
	end
end
function princeGiftView:buttonHelpCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("Payment_activity_optimization_text_26"))
	end
end
function princeGiftView:btnClickMore(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("princeGiftTaskView")
		panel:show()
	end
end
function princeGiftView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return princeGiftView
