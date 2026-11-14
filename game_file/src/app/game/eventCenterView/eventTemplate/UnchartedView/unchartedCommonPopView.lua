local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local unchartedCtrl = gametop.playertop_:getModule("unchartedCtrl")
local unchartedCommonPopView = class("unchartedCommonPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("unchartedCommonPopView")
	end
	return target
end)
_ENV, _UPVALUE6_ = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("unchartedCommonPopView")
	end
	return target
end, "unchartedCommonPopView"
_ENV, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("unchartedCommonPopView")
	end
	return target
end).pic = nil, "bust_small_w_003.png"
_ENV, (nil).pic = nil, "bust_big_m_003.png"
_ENV, (nil).pic = nil, "bt_mjtx_tanchuang02.png"
_ENV, (nil).pic = nil, "bt_mjtx_tanchuang01.png"
_ENV, (nil).pic = nil, "bt_mjtx_tanchuang02.png"
;(nil).pic = "bt_mjtx_tanchuang02.png"
;("unchartedCommonPopView")[1] = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("unchartedCommonPopView")
	end
	return target
end
;("unchartedCommonPopView")[2] = nil
;("unchartedCommonPopView")[3] = nil
;("unchartedCommonPopView")[4] = nil
;("unchartedCommonPopView")[5] = nil
local ("unchartedCommonPopView")[6], changePicTable = nil, "unchartedCommonPopView"
function unchartedCommonPopView:ctor()
	self:initControls()
end
function unchartedCommonPopView:initControls()
	self.iconTask = SoraDGetChildByName(self, "Image_41")
	self.panelTotal = SoraDGetChildByName(self, "panel_total")
	self.panelSurprise = SoraDGetChildByName(self, "panel_surprise")
	self.panelMerchant = SoraDGetChildByName(self, "panel_merchant")
	self.panelTask = SoraDGetChildByName(self, "panel_task")
	self.panelTreasure = SoraDGetChildByName(self, "panel_treasure")
	self.btnMerchantBuy = SoraDGetChildByName(self, "btn_merchant")
	self.btnMerchantGiveUp = SoraDGetChildByName(self, "btn_merchantGiveUp")
	self.btnTaskGetReward = SoraDGetChildByName(self, "btn_taskGetReward")
	self.btnTaskFinish = SoraDGetChildByName(self, "btn_taskFinish")
	self.btnTaskGiveUp = SoraDGetChildByName(self, "btn_taskGiveUp")
	self.btnTaskGetReward = SoraDGetChildByName(self, "btn_taskGetReward")
	self.btnSurpriseGo = SoraDGetChildByName(self, "btn_surprise")
	self.btnTreasure = SoraDGetChildByName(self, "btn_treasure")
	self.txtMerchantDes = SoraDGetChildByName(self, "Text_merchantDes")
	self.txtMerchantBuy = SoraDGetChildByName(self, "text_buy")
	self.txtmerchantGold = SoraDGetChildByName(self, "text_merchantGold")
	self.txtmerchantThrow = SoraDGetChildByName(self, "text_throw")
	self.txtMerchantAfter = SoraDGetChildByName(self, "text_after")
	self.txtMerchantBefore = SoraDGetChildByName(self, "text_before")
	self.txtTaskInstanceFinish = SoraDGetChildByName(self, "text_instanceFinish")
	self.txtTaskGoldCost = SoraDGetChildByName(self, "text_taskGoldCost")
	self.txtTaskGold = SoraDGetChildByName(self, "text_taskGold")
	self.txtTaskThrow = SoraDGetChildByName(self, "text_taskThrow")
	self.txtTaskDes = SoraDGetChildByName(self, "Text_taskDes")
	self.txtTaskCurDes = SoraDGetChildByName(self, "text_taskCurDes")
	self.txtTaskCur = SoraDGetChildByName(self, "text_taskCur")
	self.txtTaskTotal = SoraDGetChildByName(self, "text_taskTotal")
	self.txtSurpriseDes = SoraDGetChildByName(self, "Text_surpriseDes")
	self.txtSurpriseReward = SoraDGetChildByName(self, "text_reward")
	self.txtSurpriseGold = SoraDGetChildByName(self, "text_gold")
	self.txtTreasureDes = SoraDGetChildByName(self, "Text_treasureDes")
	self.txtTreasureReward = SoraDGetChildByName(self, "text_treasureReward")
	self.txtTreasureGold = SoraDGetChildByName(self, "text_treasureGold")
	self.txtSurpriseDes:setString(i18n("Secret_explore_text_31"))
	self.txtMerchantDes:setString(i18n("Secret_explore_text_37"))
	self.txtMerchantBuy:setString(i18n("common_text_282"))
	self.btnMerchantGiveUp:setTitleText(i18n("Secret_explore_text_19"))
	self.txtTaskInstanceFinish:setString(i18n("Secret_explore_text_20"))
	self.txtTaskDes:setString(i18n("Secret_explore_text_15"))
	self.btnSurpriseGo:setTitleText(i18n("Secret_explore_text_36"))
	self.txtTreasureDes:setString(i18n("Secret_explore_text_39"))
	self.txtTreasureReward:setString(i18n("Secret_explore_text_40"))
	self.btnTreasure:setTitleText(i18n("Secret_explore_text_36"))
	self.btnMerchantGiveUp:addTouchEventListener(handler(self, self.merchantGiveUpClickCallBack))
	self.btnMerchantBuy:addTouchEventListener(handler(self, self.merchantBuyClickCallBack))
	self.btnTaskFinish:addTouchEventListener(handler(self, self.taskFinishClickCallBack))
	self.btnTaskGiveUp:addTouchEventListener(handler(self, self.taskGiveUpClickCallBack))
	self.btnTaskGetReward:addTouchEventListener(handler(self, self.taskGetRewardClickCallBack))
	self.btnSurpriseGo:addTouchEventListener(handler(self, self.btnSurpriseGoClickCallBack))
	self.btnTreasure:addTouchEventListener(handler(self, self.btnTreasureGoClickCallBack))
	self.panelTotal:setPositionY(display.height / 2)
	self.needGold = 0
end
function unchartedCommonPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK", handler(self, self.refreshData))
end
function unchartedCommonPopView:initData(taskInfo)
	if table.nums(taskInfo) <= 0 then
		return
	end
	self.taskInfo = taskInfo
	self:isPanelVisible(taskInfo.type)
	if taskInfo.type == gUnchartedGridType.TRADER then
		local str1 = string.format("%s +%d", i18n("Secret_explore_text_17"), taskInfo.data.coin)
		self.txtmerchantGold:setString(str1)
		local str2 = string.format("%s +%d", i18n("Secret_explore_text_18"), 1)
		self.txtmerchantThrow:setString(str2)
		self.txtMerchantAfter:setString(taskInfo.data.prePrice)
		self.txtMerchantBefore:setString(taskInfo.data.oriPrice)
		local itemKey = taskInfo.data.goods[1]
		local itemCount = taskInfo.data.goods[2] or 1
		local singleItem = include("itemSingleView").new()
		singleItem:setScale(0.5)
		singleItem:setItemDelegate(handler(self, self.singleItemClick))
		singleItem:setRechargeUse(true)
		singleItem:setButtonTag(itemKey)
		singleItem:sendParentToButton(self)
		singleItem:addTo(self.panelMerchant)
		singleItem:setPosition(cc.p(100, 235))
		singleItem:initRechargeForRewardData(itemKey, itemCount)
		singleItem.btnItem:setSwallowTouches(true)
		self.needGold = taskInfo.data.prePrice
	elseif taskInfo.type == gUnchartedGridType.TASK then
		if not taskInfo.bFinish then
			self.btnTaskGetReward:setTitleText(i18n("common_text_477"))
			self.btnTaskGetReward:setTag(taskInfo.data.type)
			self.btnTaskFinish:setTag(0)
			self.btnTaskGiveUp:setTag(0)
		else
			self.btnTaskGetReward:setTitleText(i18n("common_text_854"))
			self.btnTaskGetReward:setTag(10)
			self.btnTaskFinish:setTag(1)
			self.btnTaskGiveUp:setTag(1)
		end
		if taskInfo.data.type == gUnchartedTaskJumpType.WISH then
			self.txtTaskCurDes:setString(i18n("Secret_explore_text_25"))
		elseif taskInfo.data.type == gUnchartedTaskJumpType.PYRAMID then
			local castleLV = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			self.btnTaskGetReward:setEnabled(tonumber(castleLV) >= CASTLE_LV8_LIMITED)
			self.btnTaskGetReward:getVirtualRenderer():setState(tonumber(castleLV) < CASTLE_LV8_LIMITED and 1 or 0)
			self.txtTaskCurDes:setString(i18n("Secret_explore_text_26"))
		elseif taskInfo.data.type == gUnchartedTaskJumpType.SENDING_FLOWERS then
			self.txtTaskCurDes:setString(i18n("Secret_explore_text_28"))
		elseif taskInfo.data.type == gUnchartedTaskJumpType.RESOURCE then
		elseif taskInfo.data.type == gUnchartedTaskJumpType.TRAIN_SOLDIERS then
			_ENV = i18n("Secret_explore_text_28")
			i18n("Secret_explore_text_28").Level = 1
			self.txtTaskCurDes:setString(i18n("Secret_explore_text_27", i18n("Secret_explore_text_28")))
		elseif taskInfo.data.type == gUnchartedTaskJumpType.FEED_PET then
			self.txtTaskCurDes:setString(i18n("Secret_explore_text_24"))
		elseif taskInfo.data.type == gUnchartedTaskJumpType.KILL_MONSTER then
			_ENV = i18n("Secret_explore_text_24")
			i18n("Secret_explore_text_24").Level = 1
			self.txtTaskCurDes:setString(i18n("Secret_explore_text_23", i18n("Secret_explore_text_24")))
		elseif taskInfo.data.type == gUnchartedTaskJumpType.ALLIANCE_DONATE then
			self.txtTaskCurDes:setString(i18n("Secret_explore_text_29"))
		end
		self.txtTaskCur:setString(taskInfo.plan)
		self.txtTaskTotal:setString("/" .. taskInfo.data.param[1])
		if taskInfo.data.type == gUnchartedTaskJumpType.KILL_MONSTER then
			self.txtTaskTotal:setString("/" .. taskInfo.data.param[2])
		end
		self.txtTaskCur:setPositionX(self.txtTaskCurDes:getPositionX() + self.txtTaskCurDes:getContentSize().width)
		self.txtTaskTotal:setPositionX(self.txtTaskCur:getPositionX() + self.txtTaskCur:getContentSize().width)
		self.btnTaskGiveUp:setTitleText(i18n("Secret_explore_text_19"))
		self.txtTaskGoldCost:setString(taskInfo.data.goldCost)
		local str1 = string.format("%s +%d", i18n("Secret_explore_text_17"), taskInfo.data.coin)
		self.txtTaskGold:setString(str1)
		local str2 = string.format("%s +%d", i18n("Secret_explore_text_18"), 1)
		self.txtTaskThrow:setString(str2)
		self.needGold = taskInfo.data.goldCost
	elseif taskInfo.type == gUnchartedGridType.SURPRICE then
		local str1 = ""
		if taskInfo.data.type == gUnchartedSurpriseType.COIN_RATE then
			_ENV = self.txtTaskThrow
			self.txtTaskThrow.Num = taskInfo.data.effect
			str1 = i18n("Secret_explore_text_33", self.txtTaskThrow)
		elseif taskInfo.data.type == gUnchartedSurpriseType.ADD_THROW then
			str1 = string.format("%s +%d", i18n("Secret_explore_text_18"), taskInfo.data.effect)
		elseif taskInfo.data.type == gUnchartedSurpriseType.DICE_RATE then
			_ENV = i18n("Secret_explore_text_18")
			i18n("Secret_explore_text_18").Num = taskInfo.data.effect
			str1 = i18n("Secret_explore_text_34", (i18n("Secret_explore_text_18")))
		elseif taskInfo.data.type == gUnchartedSurpriseType.TRANSMIT then
			str1 = i18n("Secret_explore_text_35")
		end
		self.txtSurpriseReward:setString(str1)
		local str2 = string.format("%s +%d", i18n("Secret_explore_text_17"), taskInfo.data.coin)
		self.txtSurpriseGold:setString(str2)
	elseif taskInfo.type == gUnchartedGridType.BOX then
		local str1 = string.format("%s +%d", i18n("Secret_explore_text_17"), taskInfo.data.coin)
		self.txtTreasureGold:setString(str1)
		local itemKey = taskInfo.data.items[1]
		local itemCount = taskInfo.data.items[2] or 1
		local singleItem = include("itemSingleView").new()
		singleItem:setScale(0.5)
		singleItem:setItemDelegate(handler(self, self.singleItemClick))
		singleItem:setRechargeUse(true)
		singleItem:setButtonTag(itemKey)
		singleItem:sendParentToButton(self)
		singleItem:addTo(self.panelTreasure)
		singleItem:setPosition(cc.p(100, 170))
		singleItem:initRechargeForRewardData(itemKey, itemCount)
		singleItem.btnItem:setSwallowTouches(true)
	end
end
function unchartedCommonPopView:refreshData(target, data)
	local unchartedInfo = unchartedCtrl:getUnchartedInfo()
	self.taskInfo.plan = unchartedInfo.taskInfo.plan
	self.taskInfo.bFinish = unchartedInfo.taskInfo.bFinish
	self:initData(self.taskInfo)
end
function unchartedCommonPopView:isPanelVisible(taskType)
	self.panelMerchant:setVisible(taskType == gUnchartedGridType.TRADER)
	self.panelSurprise:setVisible(taskType == gUnchartedGridType.SURPRICE)
	self.panelTask:setVisible(taskType == gUnchartedGridType.TASK)
	self.panelTreasure:setVisible(taskType == gUnchartedGridType.BOX)
	if taskType == gUnchartedGridType.TRADER then
		self.iconTask:setScale(1.2)
	end
	self.iconTask:loadTexture(changePicTable[taskType].pic, ccui.TextureResType.plistType)
end
function unchartedCommonPopView:merchantGiveUpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		unchartedCtrl:sendGiveUpRewardsMsg()
		self:removeFromParent()
	end
end
function unchartedCommonPopView:merchantBuyClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if lordInfoCtrl:getBaseInfo().gold < self.needGold then
			SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
		else
			unchartedCtrl:sendTraderBuyMsg()
			self:removeFromParent()
		end
	end
end
function unchartedCommonPopView:taskGetRewardClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:getTag() == gUnchartedTaskJumpType.RESOURCE or button:getTag() == gUnchartedTaskJumpType.KILL_MONSTER then
			_ENV = gUnchartedTaskJumpType.KILL_MONSTER
			gUnchartedTaskJumpType.KILL_MONSTER.msg = "MESSAGE_MAINSCEN_ONSHOW"
			gUnchartedTaskJumpType.KILL_MONSTER.viewType = VIEW_TYPE_MAP
			SoraDSendMessage(gUnchartedTaskJumpType.KILL_MONSTER)
			SoraDRemoveAllPanelFromManager()
		elseif button:getTag() == gUnchartedTaskJumpType.FEED_PET then
			if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV4_LIMITED then
				_ENV = nil
				;(nil).lv = CASTLE_LV4_LIMITED
				SoraDShowMsgTip(i18n("common_text_2974", nil))
			else
				uiManager:show("PetFguiView")
			end
		elseif button:getTag() == gUnchartedTaskJumpType.WISH then
			local wellCell = cityCtrl:getBuildCell(BUILDID.WISHING_WELL, 0)
			if wellCell == nil or tonumber(wellCell.info.state) == BUILD_STATE.BUILDING then
				SoraDShowMsgTip(i18n("common_text_2992"))
			else
				uiManager:show("TreasureHuntView")
			end
		elseif button:getTag() == gUnchartedTaskJumpType.PYRAMID then
			uiManager:show("pyramidMain")
		elseif button:getTag() == gUnchartedTaskJumpType.SENDING_FLOWERS then
			_ENV = "TreasureHuntView"
			;("TreasureHuntView").enum = 3
			uiManager:show("rankingsScrollView", "TreasureHuntView")
		elseif button:getTag() == gUnchartedTaskJumpType.ALLIANCE_DONATE then
			if allianceMgr:hasJoinAlliance() then
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("AllianceScience")
				else
					SoraDCreatePanel("allianceScienceView"):show()
				end
			else
				uiManager:show("AllianceJoinView")
			end
		elseif button:getTag() == gUnchartedTaskJumpType.GET_REWARD then
			unchartedCtrl:sendGetRewardsMsg()
			self:removeFromParent()
		elseif button:getTag() == gUnchartedTaskJumpType.TRAIN_SOLDIERS then
			_ENV = gUnchartedTaskJumpType.TRAIN_SOLDIERS
			gUnchartedTaskJumpType.TRAIN_SOLDIERS.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			gUnchartedTaskJumpType.TRAIN_SOLDIERS.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			gUnchartedTaskJumpType.TRAIN_SOLDIERS.buildIndex = 1050
			gUnchartedTaskJumpType.TRAIN_SOLDIERS.scale = 0.9
			gUnchartedTaskJumpType.TRAIN_SOLDIERS.skip = true
			SoraDSendMessage(gUnchartedTaskJumpType.TRAIN_SOLDIERS)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function unchartedCommonPopView:taskGiveUpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnTaskGiveUp:getTag() == 0 then
			unchartedCtrl:sendGiveUpRewardsMsg()
			SoraDShowLoading(self)
			self:removeFromParent()
		else
			SoraDShowMsgTip(i18n("Secret_explore_notice_07"))
		end
	end
end
function unchartedCommonPopView:taskFinishClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnTaskFinish:getTag() == 0 then
			if lordInfoCtrl:getBaseInfo().gold < self.needGold then
				SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
			else
				unchartedCtrl:sendGoldGetRewardsMsg()
				self:removeFromParent()
			end
		else
			SoraDShowMsgTip(i18n("Secret_explore_notice_07"))
		end
	end
end
function unchartedCommonPopView:btnSurpriseGoClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closePanel()
	end
end
function unchartedCommonPopView:btnTreasureGoClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.taskInfo.data.items then
			local reward = self.taskInfo.data.items
			if table.nums(reward) > 0 then
				SoraDPopGainItem(reward[1], reward[2])
			end
		end
		self:closePanel()
	end
end
function unchartedCommonPopView:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function unchartedCommonPopView:setHandle(handle)
	self.handle = handle
end
function unchartedCommonPopView:closePanel()
	if self.handle then
		self.handle()
	end
	local basePanel = include("basePanel")
	basePanel.closePanel(self)
end
return unchartedCommonPopView
