local gametop = gModuleMgr.getObject("gametop")
local starRhapsodyCtrl = gametop.playertop_:getModule("starRhapsodyCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local starRhapsodyDef = include("starRhapsodyDef")
local starRhapsodyRead = include("starRhapsodyRead")
local publicRead = include("publicRead")
local starRhapsodyUtil = include("starRhapsodyUtil")
local starRhapsodyActivity = class("starRhapsodyActivity", function(target)
	if target == nil then
		return SoraDCreateBasePanel("starRhapsodyActivity")
	end
	return target
end)
function starRhapsodyActivity:ctor()
	self.isHideCurrentSceneView = true
	self.txtRemainTime = SoraDGetChildByName(self, "Text_time")
	self.txtTipOne = SoraDGetChildByName(self, "Text_tip_one")
	self.txtTipTwo = SoraDGetChildByName(self, "Text_tip_two")
	self.txtTimesNum = SoraDGetChildByName(self, "Text_times_num")
	self.btnReset = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_reset")
	self.txtDesAward = SoraDGetChildByName(self, "Text_des_award")
	self.btnAward = SoraDGetChildByName(self, "Button_award")
	self.txtItemNum = SoraDGetChildByName(self, "Text_item_num")
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.title:setTitle(i18n("activity_name_11"))
	self.imgHourglass = SoraDGetChildByName(self, "icon_hourglass")
	self.spGreen = SoraDGetChildByName(self, "Sprite_green")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.nodeComb = SoraDGetChildByName(self, "Node_comb")
	self.txtTipComb = SoraDGetChildByName(self, "Text_comb_tip")
	self.txtTipComb:setString(i18n("starlight_text_03"))
	self.nodeCenter = SoraDGetChildByName(self, "Center_Node_lamp")
	self.btnReset:addTouchEventListener(handler(self, self.onClickReset))
	self.btnAward:addTouchEventListener(handler(self, self.onClickAward))
	self.btnBuy:addTouchEventListener(handler(self, self.onClickBuy))
	self.btnHelp:addTouchEventListener(handler(self, self.onClickHelp))
	self.txtTipOne:setString(i18n("starlight_text_02"))
	self.txtTipTwo:setString(i18n("starlight_text_08"))
	self.txtDesAward:setString(i18n("starlight_name_01"))
	self.btnAward:setTitleText(i18n("decrypt_text_03"))
	SoraDAutoSizeButtonText(self.btnAward, cc.size(120, 35))
	self.btnBuy:setTitleText(i18n("starlight_btn_01"))
	self.Image_icon = SoraDGetChildByName(self, "Image_icon")
	self.Button_item = SoraDGetChildByName(self, "Button_item")
	self.Button_item:setSwallowTouches(false)
	self.Button_item:setTouchEnabled(true)
	self.Button_item = include("commonBtnInstance").new(self.Button_item)
	self.txtRemainTime = SoraDCreateTimerLabel(self, self.txtRemainTime)
	self.txtRemainTime:setTimeLast(function(str)
		_ENV = nil
		;(nil).time = str
		return i18n("common_text_766", nil)
	end)
	self.tableItem = SoraDGetChildsArrayByName(self, "CCS_starRhapsodyLamp_", 9, 1, true, true)
	if self:getPanelOffsetHeight() < 900 then
		local offset = 40
		for i, v in ipairs(self.tableItem) do
			if i <= 3 then
				v:setPositionY(v:getPositionY() + offset)
			elseif 6 < i then
				v:setPositionY(v:getPositionY() - offset)
			end
		end
	end
	self:starLoadImage()
	self:initView()
end
function starRhapsodyActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_STAR_RHAPSODY_REFRESH", handler(self, self.updateViewInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_STAR_RHAPSODY_REQ", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.setItemInfo))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.setTaskInfo))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.setTaskInfo))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.setTaskInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_STAR_RHAPSODY_EFFECT", handler(self, self.gemEffect))
end
function starRhapsodyActivity:closeLoading()
	SoraDCloseLoading(self)
end
function starRhapsodyActivity:initView()
	self:setTime()
	self:initLampCombInfo()
	self:updateViewInfo()
end
function starRhapsodyActivity:updateViewInfo()
	self:setItemInfo()
	self:setTaskInfo()
	self:setLampInfo()
	self:setResetTimes()
end
function starRhapsodyActivity:initLampCombInfo()
	local lampInfo = starRhapsodyRead:getCombCfg(1)
	if lampInfo then
		local isCompRound = true
		local tableItem = SoraDGetChildsArrayByName(self, "CCS_starRhapsodyLamp_award_", 3, 1, true, true)
		for i, v in ipairs(tableItem) do
			if lampInfo.colorComb[i] then
				v:setLampColor(lampInfo.colorComb[i], isCompRound)
			end
		end
	end
end
function starRhapsodyActivity:setTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.STAR_RHAPSODY)
	if eventTime then
		self.txtRemainTime:beginTime(eventTime.timerNode.timer:getRemainTime())
		if SoraDFIsRA() then
			self.imgHourglass:setPositionX(self.txtRemainTime:getPositionX() + (self.txtRemainTime:getContentSize().width * 0.5 + 20))
		else
			self.imgHourglass:setPositionX(self.txtRemainTime:getPositionX() - (self.txtRemainTime:getContentSize().width * 0.5 + 20))
		end
	end
end
function starRhapsodyActivity:setResetTimes()
	if starRhapsodyCtrl:isStarLampAllLight() then
		self.btnReset:setBright(true)
		self.txtTimesNum:setVisible(false)
		starRhapsodyCtrl = false
		;(false).text = i18n("starlight_btn_02")
		self.btnReset:initData(false, 0)
		self:checkShowFinger()
	else
		self.txtTimesNum:setVisible(true)
		local gold = starRhapsodyCtrl:getResetCost()
		starRhapsodyCtrl = 0
		;(0).title = i18n("common_text_4152")
		;(0).gold = gold
		self.btnReset:initData(0, 1)
		local times = starRhapsodyCtrl:getResetTimes()
		starRhapsodyCtrl = nil
		;(nil).num = times
		self.txtTimesNum:setString(i18n("starlight_text_04", nil))
		local enableReset = 0 < times
		self.btnReset:setBright(enableReset)
	end
	local isCompRound = starRhapsodyCtrl:isCombAppearRound()
	self.nodeComb:setVisible(isCompRound)
end
function starRhapsodyActivity:setLampInfo()
	for i, v in ipairs(self.tableItem) do
		local lampInfo = starRhapsodyCtrl:getStarLampDataByIndex(i)
		v:initView(i, lampInfo)
		v:setHandle(handler(self, self.opClickCallBack))
	end
end
function starRhapsodyActivity:setItemInfo()
	local num = starRhapsodyCtrl:getItemMoonCount()
	starRhapsodyCtrl = nil
	;(nil).count = string.formatnumberthousands(num)
	self.txtItemNum:setString(i18n("common_text_1377", nil))
	local itemID = starRhapsodyDef.MOON_ITEM_ID
	self.Image_icon:loadTexture(publicRead.getIcon(itemID), ccui.TextureResType.plistType)
	self.Button_item:setItemInfo(self, itemID, num)
end
function starRhapsodyActivity:setTaskInfo()
	local taskNum = starRhapsodyCtrl:getTaskAwardNum()
	self.spGreen:setVisible(0 < taskNum)
end
function starRhapsodyActivity:opClickCallBack(index, data)
	local bright = starRhapsodyCtrl:getStarLampStatus(index)
	if bright then
		return
	end
	local num = starRhapsodyCtrl:getItemMoonCount()
	if num <= 0 then
		SoraDPlaySound()
		local itemID = starRhapsodyDef.MOON_ITEM_ID
		local itemName = publicRead.getName(itemID)
		starRhapsodyCtrl = nil
		;(nil).name = itemName
		SoraDShowMsgTip(i18n("commom_text_4302", nil))
		return
	end
	SoraDPlaySound("uicontrol", 46)
	starRhapsodyCtrl:reqLightUpInStarLamp(index)
	SoraDShowLoading(self)
end
function starRhapsodyActivity:onClickHelp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1173"
		;("common_text_1173")[1] = i18n("starlight_text_01")
		;("common_text_1173")[2] = i18n("starlight_text_01")
		SoraDShowFixWindow(i18n("common_text_1173"), "common_text_1173")
	end
end
function starRhapsodyActivity:onClickReset(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if starRhapsodyCtrl:isStarLampAllLight() then
			local spriteHand = SoraDGetChildByName(self.btnReset, "animationFinger")
			if spriteHand then
				spriteHand:stopAllActions()
				spriteHand:removeFromParent()
				self.guide = false
			end
			starRhapsodyCtrl:reqResetInStarLamp()
			SoraDShowLoading(self)
		elseif starRhapsodyCtrl:isHasGoldResetNum() then
			local gold = starRhapsodyCtrl:getResetCost()
			_ENV = nil
			;(nil).num = gold
			local showMsg = i18n("starlight_text_09", nil)
			self.msgBox = SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) and SoraDEnoughGold(gold) then
					starRhapsodyCtrl:reqResetInStarLamp()
					SoraDShowLoading(self)
				end
				self.msgBox = nil
			end)
		else
			SoraDShowMsgTip(i18n("starlight_text_05"))
		end
	end
end
function starRhapsodyActivity:onClickAward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("starRhapsodyAwardPreviewView"):show()
	end
end
function starRhapsodyActivity:onClickBuy(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("starRhapsodyTaskView"):show()
	end
end
function starRhapsodyActivity:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STAR_RHAPSODY) then
		self:removeFromParent()
	end
end
function starRhapsodyActivity:checkShowFinger()
	if self.guide then
		return
	end
	self:openGuide()
end
function starRhapsodyActivity:openGuide()
	if self.guide then
		return
	end
	self.guide = true
	self:showFinger()
end
function starRhapsodyActivity:showFinger()
	local pos = cc.p(0, 0)
	local spriteHand = SoraDFingerAction(false, false, 10)
	spriteHand:setPosition(pos)
	spriteHand:setName("animationFinger")
	spriteHand:addTo(self.btnReset, 99)
end
function starRhapsodyActivity:starLoadImage()
	_ENV, _UPVALUE1_ = nil, nil
	;(nil).name = "Common/gemRhapsody"
	;(nil).key = "gemRhapsody"
	local (nil)[1], imgArray
	local canLoad = true
	for _, v in ipairs(imgArray) do
		local ret = _G.SoraDIsFileExistByKey(v.key)
		print(v.name .. " ret = ", ret)
		if not ret then
			canLoad = false
		end
	end
	if canLoad then
		self:loadImages(imgArray, function()
			self.hasHD = true
		end)
	end
end
function starRhapsodyActivity:gemEffect(target, data)
	if self.hasHD and data.index then
		local item = self.tableItem[data.index]
		if item then
			if starRhapsodyUtil.isStar() then
				return
			end
			starRhapsodyUtil = nil
			;(nil).cssFileName = "gemRhapsodyNode"
			;(nil).loop = false
			local effectNode = _G.SoraDCreatAnimationParam(nil)
			effectNode:addTo(self.nodeCenter, 200)
			effectNode:setPosition(cc.p(item:getPosition()))
			_ENV = cc.p(item:getPosition())
			cc.p(item:getPosition())[1] = cca.delay(5.0)
			cc.p(item:getPosition())[2] = cca.callFunc(function()
				effectNode:removeFromParent()
			end)
			cc.p(item:getPosition())[3] = cca.callFunc(function()
				effectNode:removeFromParent()
			end)
			effectNode:runAction(cca.seq(cc.p(item:getPosition())))
		end
	end
end
return starRhapsodyActivity
