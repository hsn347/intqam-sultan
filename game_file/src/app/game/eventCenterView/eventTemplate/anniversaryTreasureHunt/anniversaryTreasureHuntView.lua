local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local anniversaryTreasureHuntCtrl = gametop.playertop_:getModule("anniversaryTreasureHuntCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local anniversaryTreasureHuntRead = include("anniversaryTreasureHuntRead")
local anniversaryTreasureHuntView = class("anniversaryTreasureHuntView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("anniversaryTreasureHuntView")
	end
	return target
end)
function anniversaryTreasureHuntView:ctor()
	self.isHideCurrentSceneView = true
	self:initControls()
	self:initScroll()
end
function anniversaryTreasureHuntView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_INIT_BACK", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
		self.curGrid = anniversaryTreasureHuntCtrl:getCurGrid()
		self.oldGrid = anniversaryTreasureHuntCtrl:getCurGrid()
		self.mapSize = anniversaryTreasureHuntCtrl:getMapSize()
		self.isMerchantGrid = anniversaryTreasureHuntCtrl:isMerchantGrid()
		local curNode = self.tableNode[self.curGrid]
		print("self.curGrid======", self.curGrid)
		self:initCammelAnimation(curNode:getPositionX(), curNode:getPositionY(), curNode:getLocalZOrder())
		self:initMapObjects()
		if self.isMerchantGrid and not anniversaryTreasureHuntCtrl:isAllPackageBought() then
			uiManager:show("treasureHuntMerchantPop")
		end
		local isHaveRed, num = anniversaryTreasureHuntCtrl:getReceiveStatusAndNum()
		self.imgRedPoint:setVisible(0 < num)
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_THROW_DICE", function(target, data)
		SoraDCloseLoading(self)
		if self.mapInfo == nil or next(self.mapInfo) == nil then
			return
		end
		if data.err == gErrDef.Err_None then
			SoraDShowLoading(self, nil, nil, true)
			self.stepSet = anniversaryTreasureHuntCtrl:getCastDataStepSet()
			self.multiple = anniversaryTreasureHuntCtrl:getMultipleForAmazing()
			if self.stepSet then
				self.diceCount = (self.stepSet[1].curMapIndex - self.oldGrid) % self.mapSize or 0
			end
			if not self.isSkip then
				self:startThrowDiceAnimation()
			else
				self:stopThrowDiceAnimationShowCount(self.diceCount)
				self:runCammelToTargetGrid(self.stepSet)
			end
		elseif self.isSkip then
			self:initCammelAnimation()
		end
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_DICE_COUNT", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_CANCEL_BUY_PACKAGE", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
		if self.isSkip then
			self:initCammelAnimation()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_GET_REWARD_BACK", function(target, data)
		self:refreshRedPoint()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function anniversaryTreasureHuntView:initControls()
	self.txtDiceCount = SoraDGetChildByName(self, "text_times")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.buttonHelpCallBack))
	self.btnDice = SoraDGetChildByName(self, "Button_10")
	self.btnAchieve = SoraDGetChildByName(self, "btn_achieve")
	self.imgFrameDice = SoraDGetChildByName(self, "frame_ygg_iconbg_01_15")
	self.fontDiceCount = SoraDGetChildByName(self, "BitmapFontLabel_1")
	self.fontDiceCount:setVisible(false)
	self.ccs_title:setTitle(i18n("anniversary_dice_title_01"))
	self.btnAchieve:loadTextures("icon_znxb_achievement.png", "icon_znxb_achievement.png", "icon_znxb_achievement.png", ccui.TextureResType.plistType)
	self.imgRedPoint = display.newSprite("#frame_mail_round_01.png")
	self.imgRedPoint:setScale(0.8)
	self.imgRedPoint:setPosition(70, 70)
	self.imgRedPoint:addTo(self.btnAchieve)
	self.btnDice:addTouchEventListener(handler(self, self.buttonThrowCallBack))
	self.btnAchieve:addTouchEventListener(handler(self, self.buttonAchieveCallBack))
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_TREASURE_HUNT
	self.buyDiceLimit = anniversaryTreasureHuntRead:getBuyThrowDiceNumLimit()
	self.singleDiceCost = anniversaryTreasureHuntRead:getBuySingleDiceCountCost()
	_ENV = handler(self, self.buttonAchieveCallBack)
	handler(self, self.buttonAchieveCallBack).byUID = true
	self.isSkip = SoraDConfigGet("Game:TreasureHuntView:isAuto~bool", handler(self, self.buttonAchieveCallBack)) or false
	self.Node_skip = SoraDGetChildByName(self, "Node_skip")
	self.Node_sp = SoraDGetChildByName(self, "Node_sp")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("anniversary_dice_text_20"))
	self.CheckBox_Box = SoraDGetChildByName(self, "CheckBox_Box")
	self.CheckBox_Box:setSelected(self.isSkip)
	self.CheckBox_Box:addEventListener(handler(self, self.btnActCallBack))
	SoraDToCenter(self.Node_sp)
	self.subDice, _ENV, self.diceCount = SoraDToCenter, SoraDToCenter, 0
	anniversaryTreasureHuntCtrl:sendReqInitInfoMsg()
	SoraDShowLoading(self)
end
function anniversaryTreasureHuntView:btnActCallBack(checkBox, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		checkBox:setSelected(true)
		self.isSkip = true
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:TreasureHuntView:isAuto~bool", true, nil)
	else
		SoraDPlaySound()
		checkBox:setSelected(false)
		self.isSkip = false
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:TreasureHuntView:isAuto~bool", false, nil)
	end
end
function anniversaryTreasureHuntView:initScroll()
	self.containerView = cc.CSLoader:createNode(getCCSPath("anniversayTreasureHuntLayer"))
	local viewScrollView = cc.ScrollView:create(self:getContentSize())
	viewScrollView:setContainer(self.containerView)
	viewScrollView:setMinScale(1.0)
	viewScrollView:setMaxScale(1.0)
	viewScrollView:setZoomScale(1)
	viewScrollView:setBounceable(false)
	local containerViewSize = self.containerView:getContentSize()
	local containerViewscale = viewScrollView:getZoomScale()
	viewScrollView:setContentOffset(cc.p(-(containerViewSize.width - display.width) / 2 * containerViewscale, -(containerViewSize.height - display.height) * containerViewscale), false)
	viewScrollView:setPosition(cc.p(0, 0))
	self:addChild(viewScrollView, 0)
	self.viewScrollView = viewScrollView
	self.viewScrollView:setDelegate()
	self.tableGlOne, _ENV, self.tableBtn, _ENV, self.tableNode, _ENV = self.viewScrollView.setDelegate, self.viewScrollView.setDelegate, self.viewScrollView.setDelegate, self.viewScrollView.setDelegate, self.viewScrollView.setDelegate, self.viewScrollView.setDelegate
	self.tableNode = SoraDGetChildsArrayByName(self.containerView, "node_cammel_", 35, 1)
	self.tableBtn = SoraDGetChildsArrayByName(self.containerView, "btn_cammel_", 35, 1)
	for i, v in ipairs(self.tableNode) do
		v:setLocalZOrder(containerViewSize.height - v:getPositionY())
	end
	for i, v in ipairs(self.tableBtn) do
		v:setTag(i)
		v:addTouchEventListener(handler(self, self.buttonEventCallBack))
	end
	local _shader = require("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shader")
	local _meshData = require("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_meshData")
	local _param = require("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg")
	_ENV = "app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg"
	;("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg").meshData = _meshData
	_ENV, ("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg").size = cc.size(0, 111), cc.size(0, 111)
	cc.size(0, 111).vertBytes = _shader.vertBytes
	;("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg").shader, cc.size(0, 111).fragBytes = cc.size(0, 111), _shader.fragBytes
	;("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg").param = _param.param
	_ENV, ("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg").pos = cc.p(containerViewSize.width / 2, containerViewSize.height / 2 + 50), cc.p(containerViewSize.width / 2, containerViewSize.height / 2 + 50)
	cc.p(containerViewSize.width / 2, containerViewSize.height / 2 + 50).x = 1.6758
	;("app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg").scale, cc.p(containerViewSize.width / 2, containerViewSize.height / 2 + 50).y = cc.p(containerViewSize.width / 2, containerViewSize.height / 2 + 50), 3.1234
	local createData = "app.game.eventCenterView.eventTemplate.anniversaryTreasureHunt.water_shaderCfg"
	local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
	meshNode:setPosition(cc.p(createData.pos))
	meshNode:setScale(createData.scale.x, createData.scale.y)
	meshNode:setBlendFunc(gl.ONE, gl.ONE)
	meshNode:addTo(self.containerView, 1)
	meshNode:setAutoCull(false)
end
function anniversaryTreasureHuntView:initMapObjects()
	anniversaryTreasureHuntRead, self.mapInfo = anniversaryTreasureHuntRead:getTreasureHuntMapInfo(), anniversaryTreasureHuntRead:getTreasureHuntMapInfo()
	anniversaryTreasureHuntRead:getTreasureHuntMapInfo()[11] = true
	anniversaryTreasureHuntRead:getTreasureHuntMapInfo()[23] = true
	local anniversaryTreasureHuntRead:getTreasureHuntMapInfo()[35], hjBox = true, anniversaryTreasureHuntRead:getTreasureHuntMapInfo()
	local frames_yz = display.newFrames("4znbx_yz_%.5d.png", 0, 15)
	local frames_hj = display.newFrames("4znbx_hj_%.5d.png", 0, 15)
	local frames_by = display.newFrames("4znbx_by_%.5d.png", 0, 15)
	local card_effect = SoraDCreatAnimation("Node_Effect_znxbkuang01")
	local cardIndex = 0
	local boxIndex = 0
	for i, v in ipairs(self.mapInfo) do
		local isLeft = i < 19
		if v.type == gTHMapBlockType.GIFT_MERCHANT then
			local spMerchant = display.newSprite("#lvxingshangren.png")
			spMerchant:setPosition(0, 15)
			spMerchant:setScale(0.5)
			spMerchant:addTo(self.tableNode[i])
		elseif v.type == gTHMapBlockType.ADVENTURE then
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
		elseif v.type == gTHMapBlockType.SMALL_PRIZE then
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
function anniversaryTreasureHuntView:initData()
	local ownDiceCount = anniversaryTreasureHuntCtrl:getOwnDiceCount()
	anniversaryTreasureHuntCtrl = nil
	;(nil).count = ownDiceCount
	self.txtDiceCount:setString(i18n("common_text_3875", nil))
	if self.isSkip and ownDiceCount <= 0 then
		self:initCammelAnimation()
	end
	self.isMerchantGrid = anniversaryTreasureHuntCtrl:isMerchantGrid()
end
function anniversaryTreasureHuntView:refreshRedPoint()
	local isHaveRed, num = anniversaryTreasureHuntCtrl:getReceiveStatusAndNum()
	self.imgRedPoint:setVisible(0 < num)
end
function anniversaryTreasureHuntView:initCammelAnimation(x, y, tag)
	self.curGrid = anniversaryTreasureHuntCtrl:getCurGrid()
	print("self.curGrid####", self.curGrid)
	local curNode = self.tableNode[self.curGrid]
	local x = x or curNode:getPositionX()
	local y = y or curNode:getPositionY()
	local tag = tag or curNode:getLocalZOrder()
	if not self.cammel then
		local node = display.newNode()
		node:setPosition(cc.p(x, y + 43))
		node:addTo(self.containerView, tag)
		self.cammelNode = node
		local effect_1 = SoraDCreatAnimationEx("Node_Effect_znxb01", nil, false)
		effect_1:addTo(node)
		SoraDMixtureGLONEByParent(effect_1)
		effect_1:stopAllActions()
		self.cammel_action = effect_1.action
		self.cammel_action:gotoFrameAndPlay(0, false)
		self.cammel_action:retain()
		self.cammel = effect_1
		self.cammel_sprite = SoraDGetChildByName(effect_1, "Sprite_3")
		self.cammel_light = SoraDGetChildByName(effect_1, "G_dh_Tex_znxb_001")
		self.cammel_light:setVisible(false)
		if self.curGrid >= 1 and self.curGrid <= 6 or self.curGrid >= 32 then
			self.cammel:setScaleX(-1)
		end
	end
	self:moveMapViewToCammel(x, y)
end
function anniversaryTreasureHuntView:startThrowDiceAnimation()
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
	self.effectThrowDice[1] = cca.delay(0.8)
	self.effectThrowDice[2] = cca.callFunc(function()
		self:stopThrowDiceAnimationShowCount(self.diceCount)
	end)
	self.effectThrowDice[3] = cca.callFunc(function()
		self:runCammelToTargetGrid(self.stepSet)
	end)
	self.effectThrowDice[4] = cca.callFunc(function()
		self:runCammelToTargetGrid(self.stepSet)
	end)
	local seq = cca.seq(self.effectThrowDice)
	self:runAction(seq)
end
function anniversaryTreasureHuntView:stopThrowDiceAnimationShowCount(count)
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
			_ENV = count
			count.delay = 0.5
			function count.onComplete()
				self.effectThrowDice:setVisible(false)
			end
			transition.execute(self, nil, count)
		end
	else
		self.fontDiceCount:setVisible(false)
	end
end
function anniversaryTreasureHuntView:showDiceRateForRunning(times)
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
function anniversaryTreasureHuntView:runCammelToTargetGrid(stepSet)
