local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local pyramidCtrl = gametop.playertop_:getModule("pyramidCtrl")
local pyramidData = include("pyramidData")
local publicRead = include("publicRead")
_ENV = "publicRead"
;("publicRead").None = 0
;("publicRead").World = 1
local ("publicRead").Alliance, ChannelShare = 2, "publicRead"
local pyramidRewardView = class("pyramidRewardView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidRewardView")
	end
	return target
end)
function pyramidRewardView:ctor()
	self.isHidePrePanel = false
	self:setBackGround(204.0)
	self.isShowShareChanel = false
	self.isHideMaskOnExit = true
	self.text_tip = SoraDGetChildByName(self, "text_tip")
	self.text_tip:setString(i18n("common_text_1145"))
	SoraDGetChildByName(self, "Image_contentBg"):setFillType(1)
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.item:setBaseScale(1)
	self.item:setOwnView(self)
	self.itemName = SoraDGetChildByName(self, "Text_name")
	self.btn_continue = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_continue")
	_ENV = "CCS_commonGoldNormalBtn_continue"
	;("CCS_commonGoldNormalBtn_continue").title = i18n("common_text_490")
	self.btn_continue:initData("CCS_commonGoldNormalBtn_continue", 1)
	self.btn_continue:setPositionX(SoraDFPosX(440))
	self.btn_continue:setVisible(false)
	self.btn_reward = SoraDGetChildByName(self, "btn_reward")
	self.btn_share = SoraDGetChildByName(self, "btn_share")
	self.btn_share:setVisible(false)
	self.btn_reward:setTitleText(i18n("common_text_1402"))
	self.btn_share:setTitleText(i18n("common_text_533"))
	self.Node_world = SoraDGetChildByName(self, "Node_world")
	self.Node_world:setVisible(false)
	self.Node_alliance = SoraDGetChildByName(self, "Node_alliance")
	self.Node_alliance:setVisible(false)
	self.btn_check_world = SoraDGetChildByName(self, "btn_check_world")
	self.btn_check_alliance = SoraDGetChildByName(self, "btn_check_alliance")
	self.text_check_world = SoraDGetChildByName(self, "text_check_world")
	self.text_check_alliance = SoraDGetChildByName(self, "text_check_alliance")
	self.text_continue_tip = SoraDGetChildByName(self, "text_continue_tip")
	self.text_continue_tip:setString(i18n("common_text_2613"))
	self.text_continue_tip:setVisible(false)
	self.text_check_world:setString(i18n("common_text_1486"))
	self.text_check_alliance:setString(i18n("common_text_1487"))
	self.text_check_world:setTouchEnabled(true)
	self.text_check_alliance:setTouchEnabled(true)
	self.text_check_world:addTouchEventListener(handler(self, self.onCheckWorld))
	self.text_check_alliance:addTouchEventListener(handler(self, self.onCheckAlliance))
	self.btn_check_world:addEventListener(handler(self, self.checkEventWorld))
	self.btn_check_alliance:addEventListener(handler(self, self.checkEventAlliance))
	self.btn_reward:addTouchEventListener(handler(self, self.onBtnReward))
	self.btn_continue:addTouchEventListener(handler(self, self.onBtnContinue))
	self.btn_share:addTouchEventListener(handler(self, self.onBtnShare))
	self.sharePicBtn = include("commonShareButton").createSnapshootButton(2)
	self.sharePicBtn:setPosition(SoraDFPosX(-150, 0), 90)
	self.sharePicBtn:addTo(self.item)
	self.sharePicBtn:setVisible(false)
	self:loadCfg()
	self.text_multValue = SoraDGetChildByName(self, "text_multValue")
	self.text_multValue:setVisible(false)
end
function pyramidRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_CLOSE_REWARD_VIEW", handler(self, self.msgCloseRewardView))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_GET_REWARD_SUCCESS", handler(self, self.sMsgGetRewardSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_BACKPACK_IS_FULL", handler(self, self.sMsgBackPackIsFull))
end
function pyramidRewardView:updateShare()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local isJoinAllliance = allianceMgr:hasJoinAlliance()
	if not isJoinAllliance then
		self.Node_alliance:setVisible(false)
		self.Node_world:setPositionX(320)
		SoraDToCenter(self.Node_world)
	end
end
function pyramidRewardView:updateBtns()
	local awardState = pyramidCtrl:getAwardState()
	local multiple = self.itemData.multiple or 0
	local curFloor = pyramidCtrl:getFloor()
	if awardState == gPyramidState.AWARD_WITH_CANNOT_THROW then
		if curFloor == 6 then
			self.btn_continue:setVisible(false)
			self.btn_reward:setVisible(true)
			self.btn_reward:setPositionX(SoraDFPosX(200))
			self:showPanelShareChanel()
			self.Node_world:setVisible(true)
			self.Node_alliance:setVisible(true)
		else
			self.btn_reward:setVisible(true)
			self.btn_continue:setVisible(false)
			if multiple >= PYRAMID_SHOW_MIN_FLOOR then
				self.btn_reward:setPositionX(SoraDFPosX(200))
				self:showPanelShareChanel()
			else
				self.btn_reward:setPositionX(320)
				self.btn_share:setVisible(false)
			end
		end
	elseif awardState == gPyramidState.AWARD_WITH_CAN_THROW then
		if curFloor == 6 then
			self.btn_reward:setVisible(true)
			self.btn_reward:setPositionX(SoraDFPosX(200))
			self.btn_continue:setVisible(false)
			self:showPanelShareChanel()
			self.Node_world:setVisible(true)
			self.Node_alliance:setVisible(true)
		else
			self.btn_reward:setVisible(true)
			self.btn_reward:setPositionX(SoraDFPosX(200))
			local needGold = pyramidCtrl:getGoldByFloor(curFloor)
			self.btn_continue:setGoldText(needGold)
			self.btn_continue:setVisible(true)
			if multiple >= PYRAMID_SHOW_MIN_FLOOR then
				self:showPanelShareChanel(true)
			else
				self.btn_share:setVisible(false)
			end
		end
	end
end
function pyramidRewardView:initWithData(data)
	self.itemData = data
	if not data then
		return
	end
	self.item:initData(self.itemData.id, self.itemData.count)
	self.itemName:setString(publicRead.getName(self.itemData.id))
	if self.itemData.multiple ~= nil and self.itemData.multiple > 1 then
		self.text_multValue:setVisible(true)
		if SoraDFIsRA() then
			self.text_multValue:setString(self.itemData.multiple .. "X")
		else
			self.text_multValue:setString("X" .. self.itemData.multiple)
		end
		SoraDPlaySound("pyramid", 5)
	else
		SoraDPlaySound("pyramid", 4)
	end
	self:updateBtns()
	self:updateShare()
end
function pyramidRewardView:onBtnReward(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		pyramidData:setIsOneKey(false)
		_ENV = pyramidData
		pyramidData.msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
		SoraDSendMessage(pyramidData)
		local loading = SoraDShowLoading(self.btn_reward, self.btn_reward:getContentSize())
		if loading.loadingImg then
			loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
		end
		loading:setPosition(cc.p(self.btn_reward:getContentSize().width / 2, self.btn_reward:getContentSize().height / 2))
		if self.isShowShareChanel == true then
			if self.btn_check_world:isSelected() then
				pyramidCtrl:sendReceiveReward(gPyramidReceiveState.RECEIVE_SHARE_IN_WORLD)
			elseif self.btn_check_alliance:isSelected() then
				pyramidCtrl:sendReceiveReward(gPyramidReceiveState.RECEIVE_SHARE_IN_ALLIANCE)
			else
				pyramidCtrl:sendReceiveReward(gPyramidReceiveState.ONLY_RECEIVE)
			end
		else
			pyramidCtrl:sendReceiveReward(gPyramidReceiveState.ONLY_RECEIVE)
		end
	end
end
function pyramidRewardView:sMsgGetRewardSuccess(target, data)
	local awardItem = data.award
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_PYRAMID_UPDATE_BTNS_AND_COPPER"
	SoraDSendMessage(nil)
	if awardItem == nil then
		self:close(nil, ccui.TouchEventType.ended)
		return
	else
		local multiple = awardItem.multiple or 1
		local itemCount = awardItem.itemnum * multiple
		local panel = SoraDCreatePanel("animationGainItem")
		_ENV = nil
		;(nil).itemID = awardItem.itemid
		;(nil).itemCount = itemCount
		panel:initData(nil)
		panel:show()
		self:close(nil, ccui.TouchEventType.ended)
		return
	end
end
function pyramidRewardView:sMsgBackPackIsFull(target, data)
	print("背包已满!")
	self:close(nil, ccui.TouchEventType.ended)
end
function pyramidRewardView:msgCloseRewardView(target, data)
	self:close(nil, ccui.TouchEventType.ended)
end
function pyramidRewardView:onExitPanel()
	self:saveConfig()
	if self.isHideMaskOnExit then
		_ENV = self
		self.msg = "MESSAGE_UI_PYRAMID_SET_PYRAMID_MASK"
		self.isMask = false
		SoraDSendMessage(self)
	end
end
function pyramidRewardView:onBtnContinue(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local curFloor = pyramidCtrl:getFloor()
		local needGold = pyramidCtrl:getGoldByFloor(curFloor)
		local isEnough = SoraDEnoughGold(needGold)
		if not isEnough then
			return
		end
		if self.isShowShareChanel == true then
			if self.btn_check_world:isSelected() then
				pyramidCtrl:sendThrowAgain(gPyramidReceiveState.RECEIVE_SHARE_IN_WORLD)
			elseif self.btn_check_alliance:isSelected() then
				pyramidCtrl:sendThrowAgain(gPyramidReceiveState.RECEIVE_SHARE_IN_ALLIANCE)
			else
				pyramidCtrl:sendThrowAgain(gPyramidReceiveState.ONLY_RECEIVE)
			end
		else
			pyramidCtrl:sendThrowAgain(gPyramidReceiveState.ONLY_RECEIVE)
		end
		if pyramidCtrl:getIsOneKey() then
			_ENV = pyramidCtrl
			pyramidCtrl.msg = "MESSAGE_UI_PYRAMID_SHOW_LOADING"
			pyramidCtrl.isShow = true
			SoraDSendMessage(pyramidCtrl)
		else
			_ENV = gPyramidReceiveState.ONLY_RECEIVE
			gPyramidReceiveState.ONLY_RECEIVE.byUID = true
			local switch = SoraDConfigGet("Game:pyramidView:actSwitch~bool", gPyramidReceiveState.ONLY_RECEIVE) or false
			if not switch then
				local pyramidDiceView = include("pyramidDiceView")
				local pyramidDiceViewNode = pyramidDiceView.new()
				pyramidDiceViewNode:show()
				_ENV = pyramidDiceViewNode
				pyramidDiceViewNode.msg = "MESSAGE_UI_PYRAMID_SET_PYRAMID_MASK"
				pyramidDiceViewNode.isMask = true
				SoraDSendMessage(pyramidDiceViewNode)
				self.isHideMaskOnExit = false
			else
				self.isHideMaskOnExit = true
			end
		end
		if not self.itemData then
			self:close(nil, ccui.TouchEventType.ended)
			return
		else
			local panel = SoraDCreatePanel("animationGainItem")
			_ENV = ccui.TouchEventType.ended
			ccui.TouchEventType.ended.itemID = self.itemData.itemid or self.itemData.id
			ccui.TouchEventType.ended.itemCount = self.itemData.itemnum or self.itemData.count
			panel:initData(ccui.TouchEventType.ended)
			panel:show()
			self:close(nil, ccui.TouchEventType.ended)
			return
		end
	end
end
function pyramidRewardView:onBtnShare(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local playerAlliance = allianceMgr:getAlliance()
		if playerAlliance ~= nil then
			if self.btn_check_alliance:isSelected() then
				_ENV = self.btn_check_alliance
				self.btn_check_alliance.msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
				SoraDSendMessage(self.btn_check_alliance)
				pyramidCtrl:sendReceiveReward(gPyramidReceiveState.RECEIVE_SHARE_IN_ALLIANCE)
				SoraDShowLoading(self)
			elseif self.btn_check_world:isSelected() then
				_ENV = self.btn_check_world
				self.btn_check_world.msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
				SoraDSendMessage(self.btn_check_world)
				pyramidCtrl:sendReceiveReward(gPyramidReceiveState.RECEIVE_SHARE_IN_WORLD)
				SoraDShowLoading(self)
			else
				_ENV = self
				self.msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
				SoraDSendMessage(self)
				pyramidCtrl:sendReceiveReward(gPyramidReceiveState.ONLY_RECEIVE)
				SoraDShowLoading(self)
			end
		elseif self.btn_check_world:isSelected() then
			_ENV = self.btn_check_world
			self.btn_check_world.msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
			SoraDSendMessage(self.btn_check_world)
			pyramidCtrl:sendReceiveReward(gPyramidReceiveState.RECEIVE_SHARE_IN_WORLD)
			SoraDShowLoading(self)
		else
			_ENV = self
			self.msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
			SoraDSendMessage(self)
			pyramidCtrl:sendReceiveReward(gPyramidReceiveState.ONLY_RECEIVE)
			SoraDShowLoading(self)
		end
	end
end
function pyramidRewardView:confirmShare(type)
	if type == MSGBOX_CALLBACK_YES then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local playerAlliance = allianceMgr:getAlliance()
		if playerAlliance ~= nil then
			print("分享到联盟")
			_ENV = "分享到联盟"
			;("分享到联盟").msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
			SoraDSendMessage("分享到联盟")
			pyramidCtrl:sendReceiveReward(gPyramidReceiveState.RECEIVE_SHARE_IN_ALLIANCE)
			SoraDShowLoading(self)
		else
			print("分享到世界")
			_ENV = "分享到世界"
			;("分享到世界").msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
			SoraDSendMessage("分享到世界")
			pyramidCtrl:sendReceiveReward(gPyramidReceiveState.RECEIVE_SHARE_IN_WORLD)
			SoraDShowLoading(self)
		end
	elseif type == MSGBOX_CALLBACK_NO then
		print("分享到世界")
		_ENV = "分享到世界"
		;("分享到世界").msg = "MESSAGE_UI_PYRAMID_RESET_SCORE"
		SoraDSendMessage("分享到世界")
		pyramidCtrl:sendReceiveReward(gPyramidReceiveState.RECEIVE_SHARE_IN_WORLD)
		SoraDShowLoading(self)
	else
		print("取消分享")
	end
end
function pyramidRewardView:checkEventWorld(sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print(" world selected !")
		if self.btn_check_alliance:isSelected() then
			self.btn_check_alliance:setSelected(false)
		end
		self:saveConfig()
	elseif event == ccui.CheckBoxEventType.unselected then
		print(" world cancel selected !")
	end
end
function pyramidRewardView:checkEventAlliance(sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print(" alliance selected !")
		if self.btn_check_world:isSelected() then
			self.btn_check_world:setSelected(false)
		end
		self:saveConfig()
	elseif event == ccui.CheckBoxEventType.unselected then
		print(" alliance cancel selected !")
	end
end
function pyramidRewardView:showPanelShareChanel(isShowContinueTip)
	if self.isShowShareChanel == true then
		return
	end
	self.btn_share:setVisible(not isShowContinueTip)
	self.btn_share:setPositionX(SoraDFPosX(440))
	self.sharePicBtn:setVisible(true)
	self.Node_world:setVisible(true)
	self.Node_alliance:setVisible(true)
	self.isShowShareChanel = true
	if isShowContinueTip == true then
		self.text_continue_tip:setVisible(true)
	end
end
function pyramidRewardView:loadCfg()
	local isWorldSelect = false
	local isAllianceSelect = false
	local cfgChannel = SoraDConfigGet("Pyramid:rewardView:channel~integer")
	if cfgChannel == ChannelShare.World then
		isWorldSelect = true
	elseif cfgChannel == ChannelShare.Alliance then
		isAllianceSelect = true
	end
	self.btn_check_world:setSelected(isWorldSelect)
	self.btn_check_alliance:setSelected(isAllianceSelect)
end
function pyramidRewardView:saveConfig()
	local isWorldSelect = self.btn_check_world:isSelected()
	local isAllianceSelect = self.btn_check_alliance:isSelected()
	if isWorldSelect == true then
		SoraDConfigSet("Pyramid:rewardView:channel~integer", ChannelShare.World)
	elseif isAllianceSelect == true then
		SoraDConfigSet("Pyramid:rewardView:channel~integer", ChannelShare.Alliance)
	else
		SoraDConfigSet("Pyramid:rewardView:channel~integer", ChannelShare.None)
	end
end
function pyramidRewardView:onCheckWorld(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.btn_check_world:isSelected() then
			self.btn_check_world:setSelected(false)
			self:checkEventWorld(nil, ccui.CheckBoxEventType.unselected)
		else
			self.btn_check_world:setSelected(true)
			self:checkEventWorld(nil, ccui.CheckBoxEventType.selected)
		end
	end
end
function pyramidRewardView:onCheckAlliance(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.btn_check_alliance:isSelected() then
			self.btn_check_alliance:setSelected(false)
			self:checkEventAlliance(nil, ccui.CheckBoxEventType.unselected)
		else
			self.btn_check_alliance:setSelected(true)
			self:checkEventAlliance(nil, ccui.CheckBoxEventType.selected)
		end
	end
end
return pyramidRewardView
