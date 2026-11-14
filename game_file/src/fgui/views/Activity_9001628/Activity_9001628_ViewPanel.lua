local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activity_9001628_Ctrl = gametop.playertop_:getModule("activity_9001628_Ctrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local activity_9001628_Read = include("activity_9001628_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001628_ViewPanel = class("Activity_9001628_ViewPanel", baseFguiPanel)
function Activity_9001628_ViewPanel:ctor(...)
	Activity_9001628_ViewPanel.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	_UPVALUE2_, self.debug = Activity_9001628_ViewPanel.super.ctor, true
	self.itemList, Activity_9001628_ViewPanel.super.ctor[1] = Activity_9001628_ViewPanel.super.ctor, 1683
	self.itemList, Activity_9001628_ViewPanel.super.ctor[2] = Activity_9001628_ViewPanel.super.ctor, 1694
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001628
	print("Activity_9001628_ViewPanel:ctor", self.viewName)
end
function Activity_9001628_ViewPanel:onInit()
	print("=======Activity_9001628_ViewPanel:onInit")
	self:initControls()
	self:initScroll()
end
function Activity_9001628_ViewPanel:onShow()
	print("=======Activity_9001628_ViewPanel:onShow")
end
function Activity_9001628_ViewPanel:initControls()
	self.txtDiceCount = SoraDGetChildByName(self, "text_times")
	self.ccs_title = SoraDGetChildByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.buttonHelpCallBack))
	self.btnDice = SoraDGetChildByName(self, "Button_10")
	self.usm1 = SoraDGetChildByName(self, "Usm_1")
	self.usm1:setCompleteCallback(function()
		self.usm1:setVisible(false)
	end)
	self.btnAdd = SoraDGetChildByName(self, "Button_add")
	self.btnQuation = SoraDGetChildByName(self, "Buttom_quation")
	self.Com_9001628_itemInfo = SoraDGetChildByName(self, "Com_9001628_itemInfo")
	self.btnQuation:addClickEventListener(handler(self, self.onEventTouchBegin))
	self.btnAchieve = SoraDGetChildByName(self, "btn_achieve")
	self.btnAchieve:setTitle(i18n("anniversary_dice_text_08"))
	self.imgFrameDice = SoraDGetChildByName(self, "frame_ygg_iconbg_01_15")
	self.fontDiceCount = SoraDGetChildByName(self, "BitmapFontLabel_1")
	self.fontDiceCount:setVisible(false)
	self.btnDice:addTouchEventListener(handler(self, self.buttonThrowCallBack))
	self.btnAdd:addTouchEventListener(handler(self, self.buttonAddBack))
	self.btnAchieve:addTouchEventListener(handler(self, self.buttonAchieveCallBack))
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001628
	self.buyDiceLimit = activity_9001628_Read:getBuyThrowDiceNumLimit()
	self.singleDiceCost = activity_9001628_Read:getBuySingleDiceCountCost()
	_ENV = handler(self, self.buttonAchieveCallBack)
	handler(self, self.buttonAchieveCallBack).byUID = true
	self.isSkip = SoraDConfigGet("Game:TreasureHuntView:isAuto~bool", handler(self, self.buttonAchieveCallBack)) or false
	self.Node_skip = SoraDGetChildByName(self, "Node_skip")
	self.Node_sp = SoraDGetChildByName(self, "Node_sp")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("anniversary_dice_text_20"))
	self.CheckBox_Box = SoraDGetChildByName(self, "CheckBox_Box")
	self.CheckBox_Box:setSelected(self.isSkip)
	self.CheckBox_Box:addClickEventListener(handler(self, self.btnActCallBack))
	self.fields.btn_gift:getChild("Text_name"):setString(i18n("nebula_treasure_hunt_text14"))
	self.fields.btn_gift:addTouchEventListener(handler(self, self.onBtnGiftClick))
	self.subDice, _ENV, self.diceCount = self.fields.btn_gift.addTouchEventListener, self.fields.btn_gift.addTouchEventListener, 0
	activity_9001628_Ctrl:sendReqInitDataMsg()
	SoraDShowLoading(self)
	self.imgFrameDice:fixChildrenPos(true)
	self.btnAchieve:fixPos()
	self.fields.btn_gift:fixPos()
end
function Activity_9001628_ViewPanel:onEventTouchBegin(context)
	self.Com_9001628_itemInfo:showInfo(true, self.itemList)
end
function Activity_9001628_ViewPanel:onEventTouchEnd(context)
	self.Com_9001628_itemInfo:showInfo(false, self.itemList)
end
function Activity_9001628_ViewPanel:btnActCallBack(checkBox, event)
	SoraDPlaySound()
	self.isSkip = self.CheckBox_Box:isSelected()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:TreasureHuntView:isAuto~bool", self.isSkip, nil)
end
function Activity_9001628_ViewPanel:initScroll()
	self.containerView = self.fields.container
	self.tableGlOne, _ENV, self.tableBtn, _ENV, self.tableNode, _ENV, self.viewScrollView = self.containerView, self.containerView, self.containerView, self.containerView, self.containerView, self.containerView, self.containerView
	self.btnShop = SoraDGetChildByName(self.containerView, "button_shop")
	local rotateByRight = ffa.rotateTo(0.1, 15)
	local rotateByToLeft = ffa.rotateTo(0.2, -30)
	local rotateBack = ffa.rotateTo(0.1, 15)
	local rotateByRight2 = ffa.rotateTo(0.08, -8)
	local rotateByToLeft2 = ffa.rotateTo(0.16, 16)
	local rotateBack2 = ffa.rotateTo(0.08, -8)
	local rotateByRight3 = ffa.rotateTo(0.05, 5)
	local rotateByToLeft3 = ffa.rotateTo(0.1, -10)
	local rotateBack3 = ffa.rotateTo(0.05, 0)
	local delayTime = ffa.delay(2.5)
	_UPVALUE10_ = nil
	;(nil)[1] = rotateByRight
	;(nil)[2] = rotateByToLeft
	;(nil)[3] = rotateBack
	;(nil)[4] = rotateByRight2
	;(nil)[5] = rotateByToLeft2
	;(nil)[6] = rotateBack2
	;(nil)[7] = rotateByRight3
	;(nil)[8] = rotateByToLeft3
	;(nil)[9] = rotateBack3
	;(nil)[10] = delayTime
	local seqA = ffa.seq(nil)
	local repeatA = ffa.repeatForever(seqA)
	self.btnShop:runAction(repeatA)
	self.btnShop:setVisible(false)
	self.btnShop:addClickEventListener(handler(self, self.onShopClick))
	self.tableBtn, _ENV, self.tableNode = SoraDGetChildsArrayByName(self.containerView, "node_cammel_", 36, 1), SoraDGetChildsArrayByName(self.containerView, "node_cammel_", 36, 1), SoraDGetChildsArrayByName(self.containerView, "node_cammel_", 36, 1)
	self.tableParent = self.tableNode[1]:getParent()
	for i, v in ipairs(self.tableNode) do
		table.insert(self.tableBtn, SoraDGetChildByName(v, "btn_cammel_1"))
	end
	for i, v in ipairs(self.tableBtn) do
		v:setTag(i)
		v:addTouchEventListener(handler(self, self.buttonEventCallBack))
	end
end
function Activity_9001628_ViewPanel:initMapObjects()
	activity_9001628_Read, self.mapInfo = activity_9001628_Read:getTreasureHuntMapInfo(), activity_9001628_Read:getTreasureHuntMapInfo()
	activity_9001628_Read:getTreasureHuntMapInfo()[11] = true
	activity_9001628_Read:getTreasureHuntMapInfo()[23] = true
	local activity_9001628_Read:getTreasureHuntMapInfo()[35], hjBox = true, activity_9001628_Read:getTreasureHuntMapInfo()
	local frames_yz = display.newFrames("4znbx_yz_%.5d.png", 0, 15)
	local frames_hj = display.newFrames("4znbx_hj_%.5d.png", 0, 15)
	local frames_by = display.newFrames("4znbx_by_%.5d.png", 0, 15)
	local card_effect = SoraDCreatAnimation("Node_Effect_znxbkuang01")
	local cardIndex = 0
	local boxIndex = 0
	for i, v in ipairs(self.mapInfo) do
		local isLeft = i < 19
		if v.type == gNTHMapBlockType.GIFT_MERCHANT then
			local spMerchant = display.newSprite("#lvxingshangren.png")
			spMerchant:setPosition(-20, 10)
			spMerchant:setScale(0.35)
			spMerchant:addTo(self.tableNode[i])
		elseif v.type == gNTHMapBlockType.ADVENTURE then
			cardIndex = cardIndex + 1
			local card = SoraDGetChildByName(card_effect, "Node_Effect_" .. cardIndex)
			if card then
				card:removeFromParent()
				card:addTo(self.tableNode[i])
				card:setPosition(-5, 10)
				local imageName, posx
				if isLeft then
					imageName = "4znfanpai_w_%.2d.png"
					posx = -5
				else
					imageName = "4znfanpai_e_%.2d.png"
					posx = 5
				end
				local sprite = display.newSprite("#" .. string.format(imageName, 1))
				local frames = display.newFrames(imageName, 1, 24)
				local animation = display.newAnimation(frames, 0.08333333333333333)
				sprite:playAnimationForever(animation)
				local posy = 10
				if i == 13 or i == 25 then
					posy = 15
				end
				sprite:setPosition(posx, posy)
				sprite:addTo(card:getChildByName("Node_card") or card)
			end
		elseif v.type == gNTHMapBlockType.SMALL_PRIZE then
			local sprite_yz = display.newSprite("#4znbx_yz_00000.png")
			sprite_yz:addTo(self.tableNode[i])
			function sprite_yz.onComplete()
				sprite_yz:setSpriteFrame("4znbx_yz_00000.png")
			end
			self.tableNode[i].sprite_yz = sprite_yz
			self.tableNode[i].frames_yz = frames_yz
			local sprite_box
			if hjBox[i] then
				sprite_box = display.newSprite("#4znbx_hj_00000.png")
				self.tableNode[i].frames_box = frames_hj
				function sprite_box.onComplete()
					sprite_box:setSpriteFrame("4znbx_hj_00000.png")
				end
				sprite_box:setPosition(0, 15)
				sprite_yz:setPosition(0, 20)
				boxIndex = boxIndex + 1
				local box_effect = SoraDCreatAnimation("Node_Effect_znxbBX01_" .. boxIndex)
				SoraDMixtureGLONEByParent(box_effect)
				box_effect:addTo(self.tableNode[i], 1)
				if boxIndex == 1 then
					box_effect:setPosition(-4, 9)
				else
					box_effect:setPosition(5, 10)
				end
				box_effect:setScale(0.85)
				box_effect:setVisible(false)
			else
				sprite_box = display.newSprite("#4znbx_by_00000.png")
				sprite_yz:setScale(0.85)
				self.tableNode[i].frames_box = frames_by
				function sprite_box.onComplete()
					sprite_box:setSpriteFrame("4znbx_by_00000.png")
				end
				sprite_box:setPosition(0, 10)
				sprite_yz:setPosition(0, 10)
			end
			sprite_box:addTo(self.tableNode[i])
			sprite_box:setFlippedX(isLeft)
			self.tableNode[i].sprite_box = sprite_box
		end
	end
end
function Activity_9001628_ViewPanel:updateShopBtn()
	if self.isMerchantGrid and not activity_9001628_Ctrl:isAllPackageBought() then
		self.btnShop:setVisible(true)
		local curGrid = activity_9001628_Ctrl:getCurGrid()
		local curNode = self.tableNode[curGrid]
		activity_9001628_Ctrl = nil
		;(nil)[1] = curNode:getPosition()
		;(nil)[2] = curNode:getPosition()
		dump(nil, "Activity_9001628_ViewPanel:updateShopBtn")
		self.btnShop:setPositionX(curNode:getPositionX())
		self.btnShop:setPositionY(curNode:getPositionY() - 100)
	else
		self.btnShop:setVisible(false)
	end
end
function Activity_9001628_ViewPanel:initData()
	local ownDiceCount = activity_9001628_Ctrl:getOwnDiceCount()
	activity_9001628_Ctrl = nil
	activity_9001628_Ctrl, activity_9001628_Ctrl, (nil).count = nil, nil, ownDiceCount
	;(nil).count, (nil).color = nil, "#4CE61A"
	self.txtDiceCount:setString(i18n_html("common_text_3875", nil, nil))
	if self.isSkip and ownDiceCount <= 0 then
		self:initCammelAnimation()
	end
	self.isMerchantGrid = activity_9001628_Ctrl:isMerchantGrid()
	self:refreshGiftBtn()
end
function Activity_9001628_ViewPanel:refreshGiftBtn()
	local num = activity_9001628_Ctrl:getBuyTimes()
	local max = activity_9001628_Ctrl:getMaxRoundGiftTimes()
	self.fields.btn_gift:setReddot(activity_9001628_Ctrl:isRoundGiftRed())
	activity_9001628_Ctrl = activity_9001628_Ctrl:isRoundGiftRed()
	activity_9001628_Ctrl:isRoundGiftRed().num = fguiHelper.getColorString(num == max and "#E02B2B" or "#F0E6D2", num)
	activity_9001628_Ctrl:isRoundGiftRed().max = max
	self.fields.btn_gift:setString(i18n("nebula_treasure_hunt_text15", activity_9001628_Ctrl:isRoundGiftRed()))
end
function Activity_9001628_ViewPanel:refreshRedPoint()
	local num = activity_9001628_Ctrl:getTaskRedNum()
	self.btnAchieve:setReddot(0 < num)
end
function Activity_9001628_ViewPanel:initCammelAnimation(x, y, tag)
	local isAni = not self.isSKip
	self.curGrid = activity_9001628_Ctrl:getCurGrid()
	print("self.curGrid####", self.curGrid)
	local curNode = self.tableNode[self.curGrid]
	local x = x or curNode:getPositionX()
	local y = y or curNode:getPositionY()
	if not self.cammel then
		isAni = false
		local node = SoraDGetChildByName(self, "node_main_cammel")
		node:setPosition(cc.p(x, y + 43))
		self.cammelNode = node
		local effect_1 = SoraDGetChildByName(node, "camel")
		self.cammel = effect_1
		self.cammel_sprite = SoraDGetChildByName(node, "sprite")
		self.cammel_light = SoraDGetChildByName(node, "effect")
		self.cammel_light:setVisible(false)
		if self.curGrid >= 1 and self.curGrid <= 6 or self.curGrid >= 32 then
			self.cammel:setScaleX(-1)
		end
	end
	self:moveMapViewToCammel(curNode, isAni)
end
function Activity_9001628_ViewPanel:startThrowDiceAnimation()
	if self.effectThrowDice then
		self.effectThrowDice:removeFromParent()
		self.effectThrowDice = nil
	end
	local spriteName1 = "#dh_4znsz_00000.png"
	self.effectThrowDice = display.newSprite(spriteName1)
	self.effectThrowDice:setPosition(self.imgFrameDice:getPositionX() + 100, display.height / 2)
	self.effectThrowDice:addTo(self)
	local frames = display.newFrames("dh_4znsz_%.5d.png", 0, 23)
	local animation = display.newAnimation(frames, 0.034782608695652174)
	self.effectThrowDice:playAnimationOnce(animation)
	_UPVALUE2_ = self.effectThrowDice
	self.effectThrowDice[1] = ffa.delay(0.8)
	self.effectThrowDice[2] = ffa.callFunc(function()
		self:stopThrowDiceAnimationShowCount(self.diceCount)
	end)
	self.effectThrowDice[3] = ffa.callFunc(function()
		self:runCammelToTargetGrid(self.stepSet)
	end)
	self.effectThrowDice[4] = ffa.callFunc(function()
		self:runCammelToTargetGrid(self.stepSet)
	end)
	local seq = ffa.seq(self.effectThrowDice)
	self:runAction(seq)
end
function Activity_9001628_ViewPanel:stopThrowDiceAnimationShowCount(count)
	if self.isSkip then
		return
	end
	if 0 < count then
		self.fontDiceCount:setVisible(true)
		self.btnDice:setVisible(false)
		self.fontDiceCount:setString(count)
		if self.effectThrowDice then
			self.effectThrowDice:stopAllActions()
		end
		if self.multiple > 1 then
			count = count / self.multiple
			self:showDiceRateForRunning(self.multiple)
		end
		if self.effectThrowDice then
			self.effectThrowDice:setSpriteFrame("dh_dice_new_" .. count .. ".png")
		end
		if self.effectThrowDice then
			self:runAction(ffa.seq(ffa.delay(0.5), ffa.callFunc(function()
				self.effectThrowDice:setVisible(false)
			end)))
		end
	else
		self.fontDiceCount:setVisible(false)
	end
end
function Activity_9001628_ViewPanel:showDiceRateForRunning(times)
	local diceStr = ""
	_ENV, diceStr = "X", "X" .. times
	;("X").color = cc.c3b(255, 255, 0)
	;("X").fontSize = 18
	;("X").pos = cc.p(self.imgFrameDice:getPositionX(), display.height / 2)
	;("X").zOrder = 10
	;("X").duration = 0.4
	;("X").moveH = 155
	;("X").scale = 1.5
	local ("X").font, param = "res/fonts/Arial_Bold_Border.fnt", "X"
	_ENV = self.imgFrameDice:getPositionX()
	self.imgFrameDice:getPositionX().text = diceStr
	self.imgFrameDice:getPositionX().font = param.font
	local waveLabel = display.newBMFontLabel((self.imgFrameDice:getPositionX()))
	waveLabel:addTo(self, 10)
	waveLabel:setColor(param.color)
	waveLabel:setScale(param.scale)
	waveLabel:setPosition(param.pos)
	local baseScale = param.scale
	waveLabel:setScale(0.1 * baseScale)
	waveLabel:setOpacity(0)
	_UPVALUE6_ = waveLabel
	_UPVALUE1_ = 0.24
	;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
	;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
	waveLabel[1] = cca.delay(0.06666666666666667)
	waveLabel[2] = cca.fadeTo(0.016666666666666666, 0.24)
	waveLabel[3] = cca.spawn(0.24)
	waveLabel[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	waveLabel[5] = cca.scaleTo(0.05, 1.0 * baseScale)
	waveLabel[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	waveLabel[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	waveLabel[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	waveLabel[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seqPrepare = cca.seq(waveLabel)
	local moveBy = cca.moveBy(param.duration, 0, param.moveH)
	local fadeTo = cca.fadeTo(param.duration, 0)
	_UPVALUE2_ = 0
	;(0)[1] = moveBy
	;(0)[2] = fadeTo
	local spawn = cca.spawn(0)
	local callFunc = cca.callFunc(function()
		waveLabel:setVisible(false)
	end)
	_UPVALUE3_ = fadeTo
	fadeTo[1] = seqPrepare
	fadeTo[2] = spawn
	fadeTo[3] = callFunc
	local seq = cca.seq(fadeTo)
	waveLabel:runAction(seq)
end
function Activity_9001628_ViewPanel:runCammelToTargetGrid(stepSet)
