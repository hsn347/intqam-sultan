local purchaseRebateCtrl = SoraDGetCtrl("purchaseRebateCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local treasurePackageRead = include("treasurePackageRead")
local treasurePackageView = class("treasurePackageView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("treasurePackageView")
	end
	return target
end)
singleNodeHeight = 210
function treasurePackageView:ctor()
	self:initControls()
	self:fitDevice()
end
function treasurePackageView:fitDevice()
	if display.height > 960 then
		self.Top_Size_ScrollView:setContentSize(cc.size(640, 1000))
	elseif display.height < 960 then
		self.Top_Size_ScrollView:setContentSize(cc.size(640, 400))
	end
end
function treasurePackageView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001199"))
	self.txtTimeTitle:setString(i18n("rides_text_09"))
	self.btn_help_tip:addTouchEventListener(handler(self, self.btnTipClick))
	self.btnDetail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.btnUnlock:addTouchEventListener(handler(self, self.btnUnlockClick))
	self.activityID = gActivityTimeActivityID.TREASURE_PACKAGE
	self.packageNum = treasurePackageRead:getPackageNum()
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	local treasureTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if treasureTime then
		self.txtTime:beginTime(treasureTime.timerNode.timer:getRemainTime())
	end
	self.txtUnlockTime = SoraDChangeTextToHtml(self.txtUnlockTime)
	self.txtUnlockTime = SoraDCreateTimerLabel(self, self.txtUnlockTime)
	self.txtUnlockTime:setTimeEndListener(function()
		local isAllNotBought = purchaseRebateCtrl:isAllPackageNotBought()
		if not isAllNotBought then
			local lanStr = "en"
			if SoraDFIsRA() then
				lanStr = "ar"
			elseif SoraDGetDefaultLanguage() == "ko" then
				lanStr = "ko"
			end
			self.bg_treasure_package:setSpriteFrame("bg_jbfl_return_" .. lanStr .. ".png")
			purchaseRebateCtrl = self.bg_treasure_package
			self.bg_treasure_package.msg = "MESSAGE_TREASURE_PACKAGE_REBATE_STATE"
			SoraDSendMessage(self.bg_treasure_package)
		else
			SoraDRemoveAllAfterPanelFromManager(self)
		end
		purchaseRebateCtrl = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(self)
	end)
	self.txtUnlockTime:setColor(cc.c3b(255, 255, 255))
	self.txtUnlockTime:setTimeLast(function(time)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, time
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#D7C39B"
		return i18n_html("Gather_text_02", nil, nil)
	end)
	if SoraDGetDefaultLanguage() == "ru" then
		SoraDSetTextWidthHeight(self.txtUnlockTime, cc.size(300, 60))
		SoraDSetTextWidthHeight(self.txtRebateTime, cc.size(300, 60))
		self.txtUnlockTime:setFontSize(18)
		self.txtRebateTime:setFontSize(18)
	end
	SoraDSetTextWidthHeight(self.txtUnlockTimeIns, cc.size(450, 30))
	self.txtUnlockTimeIns:setPositionY(520)
	self.txtRebateTime = SoraDChangeTextToHtml(self.txtRebateTime)
	self.txtRebateTime = SoraDCreateTimerLabel(self, self.txtRebateTime)
	self.txtRebateTime:setTimeEndListener(function()
		local rebateTime = purchaseRebateCtrl:getTodayClaimRemainTime()
		if 0 < rebateTime then
			self.txtRebateTime:setTimeLast(function(time)
				_ENV = nil
				_ENV, _ENV, (nil).time = nil, nil, time
				_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
				;(nil).__default, (nil).color = nil, "#D7C39B"
				return i18n_html("Gather_text_09", nil, nil)
			end)
			self.txtRebateTime:beginTime(rebateTime)
			self:initScroll()
		else
			SoraDRemoveAllAfterPanelFromManager(self)
		end
		purchaseRebateCtrl = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(self)
	end)
	self.txtRebateTime:setColor(cc.c3b(255, 255, 255))
	self.txtRebateTime:setTimeLast(function(time)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, time
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#D7C39B"
		return i18n_html("Gather_text_09", nil, nil)
	end)
	self.singleIsMoved = false
	self.singleDetailMoved = false
	purchaseRebateCtrl:reqInitInfo()
	SoraDShowLoading(self)
end
function treasurePackageView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_TREASURE_PACKAGE_INIT_BACK", function(target, data)
		SoraDCloseLoading(self)
		local lanStr = "en"
		if SoraDFIsRA() then
			lanStr = "ar"
		elseif SoraDGetDefaultLanguage() == "ko" then
			lanStr = "ko"
		end
		print("wehjrjkwehrkew", lanStr, userSDKManager.isKO())
		local unlockTime = purchaseRebateCtrl:getUnlockTime() - serviceFunctions.systemTime()
		if 0 < unlockTime then
			self.txtUnlockTime:beginTime(unlockTime)
			self.txtUnlockTime:setVisible(true)
			self.txtRebateTime:setVisible(false)
			self.txtUnlockTimeIns:setString(i18n("Gather_text_03"))
			self.txtUnlockTimeIns:setFontSize(14)
			self.bg_treasure_package:setSpriteFrame("bg_jbfl_pack_" .. lanStr .. ".png")
		else
			local rebateTime = purchaseRebateCtrl:getTodayClaimRemainTime()
			self.txtUnlockTime:setVisible(false)
			self.txtRebateTime:setVisible(true)
			self.txtRebateTime:beginTime(rebateTime)
			self.txtUnlockTimeIns:setString(i18n("Gather_text_10"))
			self.bg_treasure_package:setSpriteFrame("bg_jbfl_return_" .. lanStr .. ".png")
		end
		self:initScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_TREASURE_PACKAGE_REFRESH", function(target, data)
		self:initScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_TREASURE_PACKAGE_CLAIM_REWARD", function(target, data)
		SoraDCloseLoading(self)
		self:initScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_TREASURE_PACKAGE_REBATE_STATE", function(target, data)
		local rebateTime = purchaseRebateCtrl:getTodayClaimRemainTime()
		self.txtUnlockTime:setVisible(false)
		self.txtRebateTime:setVisible(true)
		self.txtRebateTime:setTimeLast(function(time)
			_ENV = nil
			_ENV, _ENV, (nil).time = nil, nil, time
			_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
			;(nil).__default, (nil).color = nil, "#D7C39B"
			return i18n_html("Gather_text_09", nil, nil)
		end)
		self.txtRebateTime:beginTime(rebateTime)
		self.txtUnlockTimeIns:setString(i18n("Gather_text_10"))
		self:initScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_TREASURE_PACKAGE_CLAIM_REBATE_REWARD", function(target, data)
		SoraDCloseLoading(self)
		self:initScroll()
	end)
end
function treasurePackageView:initScroll()
	self.Top_Size_ScrollView:removeAllChildren()
	local taskData = purchaseRebateCtrl:getRebateTaskData()
	local unlockTime = purchaseRebateCtrl:getUnlockTime() - serviceFunctions.systemTime()
	local scrollH = math.max(self.Top_Size_ScrollView:getContentSize().height, singleNodeHeight * #taskData)
	self.Top_Size_ScrollView:setInnerContainerSize(cc.size(640, scrollH + 20))
	for i = 1, #taskData do
		local cell = self.nodeSingle:clone()
		cell:setPosition(320, scrollH - 210 * (i - 1))
		cell:addTo(self.Top_Size_ScrollView)
		local bgEffect = SoraDCreatAnimation("jbfl_bg_effect", nil, true)
		bgEffect:setPosition(3, -111)
		SoraDMixtureGLONEByParent(bgEffect)
		bgEffect:addTo(cell)
		local imgSingleLeft = SoraDGetChildByName(cell, "imgSingleLeft")
		local imgSingleRight = SoraDGetChildByName(cell, "imgSingleRight")
		local frameJbflBg = SoraDGetChildByName(cell, "frameJbflBg")
		local iconTreasure = SoraDGetChildByName(cell, "iconTreasure")
		local classStr = ""
		local openStr = "jbfl_box_open_" .. taskData[i].taskID
		local closeStr = "jbfl_box_close_" .. taskData[i].taskID
		local frameBgStr = "frame_jbfl_bg_0" .. taskData[i].taskID .. ".png"
		if taskData[i].taskID == 1 then
			imgSingleLeft:loadTexture("frame_smsr6.png", ccui.TextureResType.plistType)
			imgSingleRight:loadTexture("frame_smsr6.png", ccui.TextureResType.plistType)
			classStr = "first"
		elseif taskData[i].taskID == 2 then
			iconTreasure:setSpriteFrame("icon_treasure_package_second_lock.png")
			classStr = "second"
		elseif taskData[i].taskID == 3 then
			imgSingleLeft:loadTexture("frame_smsr2.png", ccui.TextureResType.plistType)
			imgSingleRight:loadTexture("frame_smsr2.png", ccui.TextureResType.plistType)
			classStr = "third"
		end
		frameJbflBg:setSpriteFrame(frameBgStr)
		local boxOpenEffect = SoraDCreatAnimation(openStr, nil, true)
		boxOpenEffect:setPosition(75, 75)
		SoraDMixtureGLONEByParent(boxOpenEffect)
		boxOpenEffect:setVisible(taskData[i].status == gTreasurePackageType.UNLOCK)
		boxOpenEffect:addTo(iconTreasure)
		local boxCloseEffect = SoraDCreatAnimation(closeStr, nil, true)
		boxCloseEffect:setPosition(75, 75)
		SoraDMixtureGLONEByParent(boxCloseEffect)
		boxCloseEffect:setVisible(taskData[i].status == gTreasurePackageType.LOCKED)
		boxCloseEffect:addTo(iconTreasure)
		local btnUnlock = SoraDGetChildByName(cell, "btnUnlock")
		local btnDetail = SoraDGetChildByName(cell, "btnDetail")
		btnUnlock:setTag(taskData[i].status * 10 + taskData[i].taskID)
		btnDetail:setTag(taskData[i].taskID)
		btnDetail:setSwallowTouches(false)
		if taskData[i].status == gTreasurePackageType.LOCKED then
			iconTreasure:setSpriteFrame("icon_treasure_package_" .. classStr .. "_lock.png")
			btnUnlock:setTitleText(i18n("Secret_explore_text_14"))
		elseif taskData[i].status == gTreasurePackageType.UNLOCK then
			iconTreasure:setSpriteFrame("icon_treasure_package_" .. classStr .. "_open.png")
			btnUnlock:setTitleText(i18n("Gather_text_07"))
			btnUnlock:loadTextures("btn_green_small_01.png", "btn_green_small_02.png", "btn_gray_small.png", ccui.TextureResType.plistType)
		elseif taskData[i].status == gTreasurePackageType.CLAIMED then
			if unlockTime <= 0 then
				btnUnlock:setTitleText(i18n("common_text_1146"))
				iconTreasure:setSpriteFrame("icon_treasure_package_" .. classStr .. "_open.png")
				btnUnlock:loadTextures("btn_green_small_01.png", "btn_green_small_02.png", "btn_gray_small.png", ccui.TextureResType.plistType)
				btnUnlock:setBright(true)
				boxOpenEffect:setVisible(true)
			else
				iconTreasure:setSpriteFrame("icon_treasure_package_" .. classStr .. "_empty.png")
				btnUnlock:setTitleText(i18n("common_text_2943"))
				btnUnlock:setBright(false)
			end
		end
		SoraDAutoSizeButtonText(btnUnlock, cc.size(120, 40))
		if purchaseRebateCtrl:isTodayRewardClaim(taskData[i].taskID) then
			btnUnlock:setTitleText(i18n("common_text_1892"))
			iconTreasure:setSpriteFrame("icon_treasure_package_" .. classStr .. "_empty.png")
			btnUnlock:setBright(false)
			boxOpenEffect:setVisible(false)
		end
		local txtSIngleGold = SoraDGetChildByName(cell, "txtSIngleGold")
		local originalPrice = treasurePackageRead:getPackageOriginalPriceByIndex(taskData[i].taskID)
		if SoraDGetDefaultLanguage() == "ko" then
			originalPrice = paymentManager.ko_judgePrice(originalPrice)
		end
		purchaseRebateCtrl = i18n("common_text_1892")
		i18n("common_text_1892").price = originalPrice
		txtSIngleGold:setString(i18n("Gather_text_04", i18n("common_text_1892")))
		SoraDSetTextWidthHeight(txtSIngleGold, cc.size(200, 60))
		local txtSingleTitle = SoraDGetChildByName(cell, "txtSingleTitle")
		txtSingleTitle:setString(i18n(treasurePackageRead:getPackageNameByIndex(taskData[i].taskID)))
		local txtSIngleClaim = SoraDGetChildByName(cell, "txtSIngleClaim")
		local packagePrice = treasurePackageRead:getPackageSoldPriceByIndex(taskData[i].taskID)
		if SoraDGetDefaultLanguage() == "ko" then
			packagePrice = paymentManager.ko_judgePrice(packagePrice)
		end
		if 0 < unlockTime then
			purchaseRebateCtrl = i18n(treasurePackageRead:getPackageNameByIndex(taskData[i].taskID))
			i18n(treasurePackageRead:getPackageNameByIndex(taskData[i].taskID)).price = packagePrice
			i18n(treasurePackageRead:getPackageNameByIndex(taskData[i].taskID)).name = i18n(treasurePackageRead:getPackageNameByIndex(taskData[i].taskID))
			txtSIngleClaim:setString(i18n("Gather_text_14", i18n(treasurePackageRead:getPackageNameByIndex(taskData[i].taskID))))
		else
			txtSIngleClaim:setString(i18n("Gather_text_11"))
		end
		txtSIngleClaim:setPositionY(txtSIngleClaim:getPositionY() - 10)
		txtSIngleClaim:setLocalZOrder(1)
		txtSingleTitle:setLocalZOrder(1)
		txtSIngleGold:setLocalZOrder(1)
		btnUnlock:setLocalZOrder(2)
		btnDetail:setLocalZOrder(1)
		iconTreasure:setLocalZOrder(1)
	end
end
function treasurePackageView:btnTipClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Gather_text_06"
		;("Gather_text_06").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Gather_text_06"), "Gather_text_06")
	end
end
function treasurePackageView:btnDetailClick(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.Top_Size_ScrollView) then
			print("node is not on view")
			return
		end
		if self.singleDetailMoved then
			self.singleDetailMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("treasurePackagePopView")
		panel:initData(button:getTag())
		panel:show()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleDetailMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleDetailMoved = false
	end
end
function treasurePackageView:btnUnlockClick(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.Top_Size_ScrollView) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local status = math.floor(button:getTag() / 10)
		local taskID = button:getTag() % 10
		local unlockTime = purchaseRebateCtrl:getUnlockTime() - serviceFunctions.systemTime()
		if status == gTreasurePackageType.LOCKED then
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
		elseif status == gTreasurePackageType.UNLOCK then
			purchaseRebateCtrl:reqClaimReward(taskID)
			SoraDShowLoading(self)
		elseif status == gTreasurePackageType.CLAIMED and unlockTime <= 0 and not purchaseRebateCtrl:isTodayRewardClaim(taskID) then
			purchaseRebateCtrl:reqClaimRebateReward(taskID)
			SoraDShowLoading(self)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function treasurePackageView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return treasurePackageView
