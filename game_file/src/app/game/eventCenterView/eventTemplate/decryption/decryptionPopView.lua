local decryptionRead = include("decryptionRead")
local decryptionPopView = class("decryptionPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("decryptionPopView_ros")
	end
	return target
end)
function decryptionPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	SoraDAddMessage(self, "MESSAGE_DECRYPTION_REFRESH_TASK", handler(self, self.refreshSingleTask))
end
function decryptionPopView:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("anniversary_uncover_text_03"))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_task"
	self.Text_task = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE2_ = "Center_Node"
	;("Center_Node")[1] = "node_progress"
	;("Center_Node")[2] = "LoadingBar_progress"
	self.loadingBar = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE2_ = "Center_Node"
	;("Center_Node")[1] = "node_progress"
	;("Center_Node")[2] = "Text_count"
	self.Text_count = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Sprite_left"
	self.Sprite_left = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Sprite_right"
	self.Sprite_right = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_rewards"
	self.Text_rewards = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	self.Text_rewards:setString(i18n("anniversary_uncover_text_04"))
	self.Sprite_left:setPositionX(320 - self.Text_rewards:getContentSize().width / 2 - 20)
	self.Sprite_right:setPositionX(320 + self.Text_rewards:getContentSize().width / 2 + 20)
	_UPVALUE1_ = 320 + self.Text_rewards:getContentSize().width / 2 + 20
	;(320 + self.Text_rewards:getContentSize().width / 2 + 20)[1] = "Node_rewards"
	self.Node_rewards = SoraDGetChildByFullPath(self.Node_content, 320 + self.Text_rewards:getContentSize().width / 2 + 20)
	_UPVALUE1_ = 320 + self.Text_rewards:getContentSize().width / 2 + 20
	;(320 + self.Text_rewards:getContentSize().width / 2 + 20)[1] = "Button_receive"
	self.Button_receive = SoraDGetChildByFullPath(self.Node_content, 320 + self.Text_rewards:getContentSize().width / 2 + 20)
	self.Button_receive:setTitleText(i18n("common_text_1146"))
	self.Button_receive:addTouchEventListener(handler(self, self.btnReceiveCallback))
	_UPVALUE1_ = handler(self, self.btnReceiveCallback)
	handler(self, self.btnReceiveCallback)[1] = "Button_go"
	self.Button_go = SoraDGetChildByFullPath(self.Node_content, handler(self, self.btnReceiveCallback))
	self.Button_go:setTitleText(i18n("common_text_678"))
	self.Button_go:addTouchEventListener(handler(self, self.btnGoCallback))
	SoraChangeButtonImage(self.Button_go, "btn_blue_normal_01.png")
end
function decryptionPopView:initData(data)
	if not data.taskInfo then
		_ENV = data.taskInfo
	end
	self.taskInfo = data.taskInfo
	self.index = data.index
	if not self.taskInfo.reward then
		local _ENV, rewards = self.taskInfo.reward, self.taskInfo.reward
	end
	local dataCount = math.min(#rewards / 2, 4)
	for i = 1, dataCount do
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(100 * i - 290, 40))
		singleItem:addTo(self.Node_rewards)
		singleItem:setScale(0.55)
		_ENV, _ENV = cc.p(100 * i - 290, 40)
		cc.p(100 * i - 290, 40).id = rewards[2 * i - 1]
		;(0.55).itemData, cc.p(100 * i - 290, 40).count = cc.p(100 * i - 290, 40)
		singleItem:initData(0.55)
		singleItem:setButtonTag(rewards[2 * i - 1])
		singleItem:setItemClickCallback(handler(self, self.showDetail))
	end
	self:refreshTaskInfo()
end
function decryptionPopView:refreshTaskInfo()
	local taskId = self.taskInfo.taskId or 0
	self.Text_task:setString(i18n(decryptionRead.getTaskDes(taskId)))
	local nNum = self.taskInfo.nNum
	local plan = self.taskInfo.plan or 0
	self.loadingBar:setPercent(plan / nNum * 100)
	self.Text_count:setString(string.format("%d/%d", plan, nNum))
	if plan == nNum then
		self.Button_receive:setVisible(true)
		self.Button_go:setVisible(false)
	else
		self.Button_receive:setVisible(false)
		self.Button_go:setVisible(true)
	end
end
function decryptionPopView:btnReceiveCallback(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDGetCtrl("decryptionCtrl"):sendReqGetReward(1, self.index)
		self:removeFromParent()
	end
end
function decryptionPopView:btnGoCallback(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local taskId = self.taskInfo.taskId or 0
		local guideId = decryptionRead.getGuideId(taskId)
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local ret = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if ret ~= false then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function decryptionPopView:showDetail(target, etype)
	if etype == ccui.TouchEventType.ended or etype == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		self:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif etype == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			if self.tips then
				self.tips:removeFromParent()
				self.tips = nil
			end
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(target:getTag())
			self.tips:setPosition(cc.p(180, display.cy + 150))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			if self.tips then
				self.tips:removeFromParent()
				self.tips = nil
			end
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(target:getTag())
			self.tips:setPosition(cc.p(180, display.cy + 150))
			self.tips:addTo(self, 99)
		end)
		self:runAction(cca.seq(nil))
	end
end
function decryptionPopView:refreshSingleTask(target, redata)
	local index = redata.nIndex or 0
	if index == self.index then
		self.taskInfo = SoraDGetCtrl("decryptionCtrl"):getTaskInfoByIndex(index)
		self:refreshTaskInfo()
	end
end
return decryptionPopView
