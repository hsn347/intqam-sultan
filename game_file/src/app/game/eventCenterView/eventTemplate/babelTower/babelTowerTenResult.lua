local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerTenResult = class("babelTowerTenResult", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("babelTowerTenResult")
end)
function babelTowerTenResult:onExitPanel()
	if self.reward then
		local _ENV, recountReward = self.reward, self.reward
		for i, v in ipairs(self.reward) do
			local isIn = false
			for i2, v2 in ipairs(recountReward) do
				if v.id == v2.id then
					isIn = true
					v2.count = v2.count + v.count
					break
				end
			end
			if not isIn then
				_ENV = ipairs(recountReward)
				ipairs(recountReward).id = v.id
				ipairs(recountReward).count = v.count
				table.insert(recountReward, ipairs(recountReward))
			end
		end
		SoraDMailGainItems(recountReward, true)
	end
	if self.nowFloor <= babelTowerRead:getTowerNum() then
		if self.isContinueTen then
			_ENV = babelTowerRead:getTowerNum()
			babelTowerRead:getTowerNum().msg = "MESSAGE_BABEL_TOWER_REFRESH"
			babelTowerRead:getTowerNum().subMsg = "nextTenAction"
			SoraDSendMessage((babelTowerRead:getTowerNum()))
		else
			_ENV = babelTowerRead:getTowerNum()
			babelTowerRead:getTowerNum().msg = "MESSAGE_BABEL_TOWER_REFRESH"
			babelTowerRead:getTowerNum().subMsg = "nextFloorAction"
			SoraDSendMessage((babelTowerRead:getTowerNum()))
		end
	elseif self.nowFloor > babelTowerRead:getTowerNum() then
		_ENV = babelTowerRead:getTowerNum()
		babelTowerRead:getTowerNum().msg = "MESSAGE_BABEL_TOWER_REFRESH"
		babelTowerRead:getTowerNum().subMsg = "maxTowerReset"
		SoraDSendMessage((babelTowerRead:getTowerNum()))
	end
end
function babelTowerTenResult:ctor()
	if display.height < 960 then
		local scale = display.height / 960
		self._ccsView:setScale(scale)
		self._ccsView:setPosition((640 - 640 * scale) / 2, (960 - display.height) / 2)
	end
	self.ticketsID = 726001
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	if self.centerNode == nil then
		self.centerNode = SoraDGetChildByName(self, "Center_Node_0")
	end
	self.centerNode:setPositionY(self.centerNode:getPositionY() - 50)
	self.farme_winlose = SoraDGetChildByName(self, "farme_winlose")
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnSure:addTouchEventListener(handler(self, self.btnSureClick))
	self.btnSureLose = SoraDGetChildByName(self, "Button_Sure_lose")
	self.btnSureLose:setTitleText(i18n("epic_war_endChallenge_btn"))
	self.btnSureLose:addTouchEventListener(handler(self, self.btnSureLoseClick))
	self.Node_win = SoraDGetChildByName(self, "Node_win")
	self.Node_lose = SoraDGetChildByName(self, "Node_lose")
	self.Text_AwardTitle = SoraDGetChildByName(self, "Text_AwardTitle")
	self.Text_title_floor = SoraDGetChildByName(self, "Text_title_floor")
	self.Text_title_floor:setString(i18n("Promise_Summit_text_03"))
	self.Text_title_tip = SoraDGetChildByName(self, "Text_title_tip")
	self.Text_title_tip:setString(i18n("Promise_Summit_text_54"))
	self.Right_Pandect = SoraDGetChildByName(self, "Right_Pandect")
	self.Left_Pandect = SoraDGetChildByName(self, "Left_Pandect")
	self.Txt_fnt_floor = SoraDGetChildByName(self, "Txt_fnt_floor")
	self.scrollItem = SoraDGetChildByName(self, "ScrollView")
	self.nodeItem = SoraDGetChildByName(self, "Node_Item")
	self.textItemNum = SoraDGetChildByName(self, "Text_ItemNum")
	self.btnJumpToRecharge = SoraDGetChildByName(self, "Button_JumpToRecharge")
	self.btnJumpToRecharge:addTouchEventListener(handler(self, self.btnJumpToRechargeClick))
	self.Text_cost_num = SoraDGetChildByName(self, "Text_cost_num")
	self.Text_cost_des = SoraDGetChildByName(self, "Text_2")
	self:initEffect()
end
function babelTowerTenResult:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemNum))
end
function babelTowerTenResult:initEffect()
	local loop = true
	local cssFileName = "babelTowerTenResult"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function babelTowerTenResult:initData(tenResult)
	self.isContinueTen = false
	local floor = tenResult.floor
	local floorCount = tenResult.floorCount
	local reward = tenResult.rewards
	self.farme_winlose:setSpriteFrame(SoraDFIsRA() and "font_ttt_congratulations_ar.png" or "farme_jlnf_gx_en.png")
	self.nowFloor = floor
	self.reward = reward
	self.Text_title_tip:setVisible(#self.reward > 0)
	self.Right_Pandect:setVisible(#self.reward > 0)
	self.Left_Pandect:setVisible(#self.reward > 0)
	if self.reward then
		self:refreshScroll()
	end
	self.Txt_fnt_floor:setString(floor)
	local buffStr = i18n("Promise_Summit_text_62")
	if tenResult.buffFloor ~= 0 then
		local buffList = babelTowerRead:getBuffList(tenResult.buffFloor)
		if buffList and buffList[tenResult.buffIndex] then
			local buffData = buffList[tenResult.buffIndex]
			local buffConfig = babelTowerRead:getBuffConfig(buffData.buffType)
			_ENV = nil
			;(nil).num = tenResult.buffFloor
			_ENV = nil
			;(nil).level = buffData.buffType
			;(nil).num = buffData.buffValue
			;(nil).name = i18n(buffConfig.describe, nil)
			buffStr = i18n("Promise_Summit_text_61", nil)
		end
	end
	local var = tenResult.oldBlood
	local var1 = tenResult.floorCount
	local var3 = 0
	for k, v in pairs(tenResult.events) do
		if k ~= 0 then
			var3 = var3 + v
		end
	end
	local var4 = tenResult.changeBlood
	local var5 = tenResult.blood
	local var6 = buffStr
	if tenResult.isWin then
		_ENV = nil
		;(nil).var = var
		;(nil).var1 = var1
		;(nil).var2 = var2
		;(nil).var3 = var3
		;(nil).var4 = var4
		;(nil).var5 = var5
		;(nil).var6 = var6
		self.Text_AwardTitle:setString(i18n("Promise_Summit_text_53", nil))
	else
		_ENV = i18n("Promise_Summit_text_53", nil)
		i18n("Promise_Summit_text_53", nil).var = var
		i18n("Promise_Summit_text_53", nil).var1 = var1
		i18n("Promise_Summit_text_53", nil).var2 = var2
		i18n("Promise_Summit_text_53", nil).var3 = var3
		i18n("Promise_Summit_text_53", nil).var4 = var4
		i18n("Promise_Summit_text_53", nil).var5 = var5
		i18n("Promise_Summit_text_53", nil).var6 = var6
		i18n("Promise_Summit_text_53", nil).num = tenResult.finalFloor
		self.Text_AwardTitle:setString(i18n("Promise_Summit_text_60", i18n("Promise_Summit_text_53", nil)))
	end
	self:updateItemNum()
	if tenResult.isWin then
		self.farme_winlose:setSpriteFrame(SoraDFIsRA() and "font_ttt_congratulations_ar.png" or "farme_jlnf_gx_en.png")
	else
		self.farme_winlose:setSpriteFrame(SoraDFIsRA() and "font_ttt_fail_ar.png" or "font_ttt_fail_en.png")
	end
	self.Node_win:setVisible(tenResult.isWin)
	self.Node_lose:setVisible(not tenResult.isWin)
end
function babelTowerTenResult:updateItemNum()
	self.numOfTickets = backpackCtrl:getItemCount(self.ticketsID)
	self.textItemNum:setString(self.numOfTickets)
	if self.nowFloor > babelTowerRead:getTowerNum() then
		self.btnSure:setVisible(false)
		return
	end
	self.maxNum = babelTowerRead:getTowerNum()
	local lastNum = math.max(math.min(10, self.maxNum - self.nowFloor + 1), 0)
	self.lastNum = lastNum
	backpackCtrl = nil
	;(nil).num = lastNum
	self.Text_cost_des:setString(i18n("Promise_Summit_text_55", nil))
	lastNum = babelTowerCtrl:isFirstClimb() and lastNum - 1 or lastNum
	self.Text_cost_num:setString(lastNum)
	self.isEnough = true
	if lastNum > self.numOfTickets then
		self.isEnough = false
		self.Text_cost_num:setColor(cc.c3b(255, 1, 1))
	else
		self.Text_cost_num:setColor(cc.c3b(255, 255, 255))
	end
end
function babelTowerTenResult:refreshScroll()
	local innerContainer = self.scrollItem:getInnerContainer()
	local innerWidth = innerContainer:getContentSize().width
	local innerHeight = self.scrollItem:getContentSize().height
	self.scrollItem:setBounceEnabled(#self.reward > 4)
	for i, v in ipairs(self.reward) do
		local single = include("commonItemAward").new()
		single:setBaseScale(0.9)
		single:setOwnScroll(self.scrollItem)
		single:initData(v.id, v.count)
		single:addTo(self.nodeItem)
	end
	innerHeight = math.max(math.ceil(#self.reward / 5) * 100, innerHeight)
	self.scrollItem:setInnerContainerSize(cc.size(innerWidth, innerHeight))
	self.nodeItem:setPosition(260, innerHeight / 2)
	SoraDautoSortPos(self.nodeItem, 5, 1, cc.size(100, 100), SoraDFIsRA())
end
function babelTowerTenResult:btnSureClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.isEnough then
			SoraDShowMsgBox(i18n("Promise_Summit_text_65"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					self:openRechargeView()
				end
			end)
			return
		end
		print("self.lastNum === ", self.lastNum)
		if self.lastNum > 0 then
			self.isContinueTen = true
		end
		self:removeFromParent()
	end
end
function babelTowerTenResult:btnSureLoseClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function babelTowerTenResult:btnBoxAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.nowFloor % 10 == 1 then
			local panel = SoraDCreatePanel("babelTowerBoxInfo")
			local nextTenFloor = math.ceil(self.nowFloor / 10) * 10
			panel:initData(nextTenFloor)
			panel:show()
		end
	end
end
function babelTowerTenResult:getGiftInfo()
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	dump(giftInfo, "giftInfo", 10)
	_UPVALUE4_ = giftInfo
	giftInfo[1] = 13941
	giftInfo[2] = 13940
	giftInfo[3] = 13939
	giftInfo[4] = 13938
	for _, v in ipairs(giftInfo) do
		local item = giftInfo[tostring(v)]
		if item and tonumber(item.extraData) >= 1 then
			return item
		end
	end
end
function babelTowerTenResult:btnJumpToRechargeClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		self:openRechargeView()
	end
end
function babelTowerTenResult:openRechargeView()
	local giftData = self:getGiftInfo()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeID = giftData and tonumber(giftData.ID)
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		if giftData then
			panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
		end
		panel:show()
	end
end
return babelTowerTenResult
