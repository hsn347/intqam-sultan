local mermaidGiftCtrl = SoraDGetCtrl("mermaidGiftCtrl")
local mermaidGiftRead = include("mermaidGiftRead")
local constantRead = include("constantRead")
local mermaidGiftRewardView = class("mermaidGiftRewardView", function(target)
	return target or SoraDCreateTouchPanel("mermaidGiftRewardView")
end)
function mermaidGiftRewardView:ctor()
	self.haveStandardNum = false
	self.sizeBg = SoraDGetChildByName(self, "Size_bg")
	self.sizeBg:setContentSize(display.size)
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.btnFlopOne = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_One")
	self.btnFlopTen = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_Ten")
	local numberLimit = string.formatnumberthousands(constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000))
	self.highTips = SoraDGetChildByName(self, "Text_highs_tip")
	_ENV = constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000)
	constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000).num = numberLimit
	self.highTips:setString(i18n("Mermaid_text_17", constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000)))
	self.noRewardLb = SoraDGetChildByName(self, "Text_no_reward")
	self.noRewardLb:setString(i18n("Mermaid_text_15"))
	self.noLuckLb = SoraDGetChildByName(self, "Text_no_luck")
	self.noLuckLb:setString(i18n("Mermaid_text_16"))
	self.btnFlopOne:setTag(1)
	_ENV = 1
	_ENV = i18n("Mermaid_text_16")
	i18n("Mermaid_text_16").num = 1
	;(1).title = i18n("Mermaid_title_04", i18n("Mermaid_text_16"))
	;(1).gold = 1 * mermaidGiftCtrl:getFlipNum()
	;(1).icon = "icon_mermaid_changeNum.png"
	self.btnFlopOne:initData(1, 1)
	self.btnFlopOne:setTitleSize(cc.size(210, 21))
	self.btnFlopOne:addTouchEventListener(handler(self, self.btnClickFlop))
	self.btnFlopTen:setTag(10)
	self.btnFlopTen:setColor(gBtnColorDef.YELLOW)
	_ENV = gBtnColorDef.YELLOW
	_ENV = handler(self, self.btnClickFlop)
	handler(self, self.btnClickFlop).num = 10
	gBtnColorDef.YELLOW.title = i18n("Mermaid_title_04", handler(self, self.btnClickFlop))
	gBtnColorDef.YELLOW.gold = 10 * mermaidGiftCtrl:getFlipNum()
	gBtnColorDef.YELLOW.icon = "icon_mermaid_changeNum.png"
	self.btnFlopTen:initData(gBtnColorDef.YELLOW, 1)
	self.btnFlopTen:setTitleSize(cc.size(210, 21))
	self.btnFlopTen:addTouchEventListener(handler(self, self.btnClickFlop))
	self.nodeTitleNum = SoraDGetChildByName(self, "Node_UpReward")
	SoraDGetChildByName(self.nodeTitleNum, "Text_Title"):setString(i18n("Mermaid_text_07"))
	self.nodeGifts = SoraDGetChildByName(self, "Node_gifts")
	self.nodeTitleLove = SoraDGetChildByName(self, "Node_LoveAward")
	SoraDGetChildByName(self.nodeTitleLove, "Text_Title"):setString(i18n("Mermaid_title_09"))
	self.addLoveText = SoraDGetChildByName(self, "Text_AddLove")
	self.nodeTitleExtra = SoraDGetChildByName(self, "Node_ExtraAward")
	SoraDGetChildByName(self.nodeTitleExtra, "Text_Title"):setString(i18n("Mermaid_title_10"))
	self.nodeRewards = SoraDGetChildByName(self, "Node_rewards")
	self.nodeLucky = SoraDGetChildByName(self, "Node_lucky")
	SoraDGetChildByName(self.nodeLucky, "Text_Title"):setString(i18n("Mermaid_title_06"))
	self.nodeLuckys = SoraDGetChildByName(self, "Node_luckys")
	self.nodeButtons = SoraDGetChildByName(self, "Node_buttons")
	self.nodePoint = SoraDGetChildByName(self, "Node_Num")
	self.btnAddPoint = SoraDGetChildByName(self.nodePoint, "Button_Add")
	self.textNum = SoraDGetChildByName(self.nodePoint, "Text_NumHave")
	self.textNum = SoraDChangeTextToHtml(self.textNum)
	self.btnAddPoint:addTouchEventListener(handler(self, self.btnClickAddPoint))
	self.closeBtn = SoraDGetChildByName(self, "Button_close")
	self.closeBtn:addTouchEventListener(handler(self, self.onClose))
	self.giftSingle = SoraDGetChildByName(self, "Node_gift")
	_ENV, self.luckySingle = SoraDGetChildByName(self, "Node_lucky_num"), SoraDGetChildByName(self, "Node_lucky_num")
	SoraDGetChildByName(self, "Node_lucky_num").Node_UpReward = self.nodeTitleNum:getPositionY()
	SoraDGetChildByName(self, "Node_lucky_num").Node_gifts = self.nodeGifts:getPositionY()
	SoraDGetChildByName(self, "Node_lucky_num").Node_LoveAward = self.nodeTitleLove:getPositionY()
	SoraDGetChildByName(self, "Node_lucky_num").Node_ExtraAward = self.nodeTitleExtra:getPositionY()
	SoraDGetChildByName(self, "Node_lucky_num").Node_lucky = self.nodeLucky:getPositionY()
	SoraDGetChildByName(self, "Node_lucky_num").Node_luckys = self.nodeLuckys:getPositionY()
	SoraDGetChildByName(self, "Node_lucky_num").Node_Num = self.nodePoint:getPositionY()
	self.posYs, SoraDGetChildByName(self, "Node_lucky_num").Node_buttons = SoraDGetChildByName(self, "Node_lucky_num"), self.nodeButtons:getPositionY()
	if SoraDFIsRA() then
		SoraDGetChildByName(self, "font_ar"):setVisible(true)
	else
		SoraDGetChildByName(self, "font_en"):setVisible(true)
	end
	self.items, _ENV = SoraDGetChildByName(self, "font_en").setVisible, SoraDGetChildByName(self, "font_en").setVisible
	self:createEffect()
end
function mermaidGiftRewardView:createEffect()
	_UPVALUE3_ = nil
	;(nil)[1] = SoraDGetChildByName(self.nodeTitleNum, "Node_title_bg")
	;(nil)[2] = SoraDGetChildByName(self.nodeTitleLove, "Node_title_bg")
	;(nil)[3] = SoraDGetChildByName(self.nodeTitleExtra, "Node_title_bg")
	;(nil)[4] = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	;(nil)[5] = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	;(nil)[6] = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	;(nil)[7] = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	;(nil)[8] = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	;(nil)[9] = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	;(nil)[10] = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	;(nil)[11] = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	local (nil)[12], imageParents = SoraDGetChildByName(self.nodeLucky, "Node_title_bg")
	for k, v in pairs(imageParents) do
		local effect_normal = SoraDCreatAnimation("Node_Effect_rydkz01", nil, true)
		effect_normal:setPosition(cc.p(v:getContentSize().width / 2, v:getContentSize().height / 2))
		effect_normal:addTo(v)
		effect_normal:setLocalZOrder(-1)
	end
	local bgSp2 = cc.criSprite.createCriSprite("sp_rydkz_002.usm", false, true, true)
	bgSp2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	bgSp2:setPosition(display.width / 2, display.height / 2)
	bgSp2:addTo(self)
	self.centerNode:setScale(0)
	local bgSp = cc.criSprite.createCriSprite("sp_rydkz_001.usm", false, false, function(bgSp)
		self.centerNode:setScale(0.3)
		bgSp:start()
		_UPVALUE2_ = nil
		;(nil)[1] = cca.delay(0)
		;(nil)[2] = cca.scaleTo(0.15, 1)
		;(nil)[3] = cca.callFunc(function()
			self.sizeBg:setVisible(false)
		end)
		;(nil)[4] = cca.callFunc(function()
			self.sizeBg:setVisible(false)
		end)
		self.centerNode:runAction(cca.seq(nil))
	end)
	bgSp:setCompleteCallback(function()
		bgSp2:start()
		bgSp:removeFromParent()
	end)
	bgSp:setPosition(display.width / 2, display.height / 2)
	bgSp:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	bgSp:addTo(self)
end
function mermaidGiftRewardView:onExitPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_MERMAID_GIFT_REWARD_CLOSE"
	SoraDSendMessage(nil)
end
function mermaidGiftRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MERMAID_GIFT_SWAP", handler(self, self.updataData))
end
function mermaidGiftRewardView:updataData(target, data)
	self:initData(data.result)
end
function mermaidGiftRewardView:initData(data)
	self.score = mermaidGiftCtrl:getScore()
	self.btnFlopOne:setTextGoldColor(mermaidGiftCtrl:isScoreEnough(self.score, 1) and COLOR3.YELLOW or display.COLOR_RED)
	self.btnFlopTen:setTextGoldColor(mermaidGiftCtrl:isScoreEnough(self.score, 10) and COLOR3.YELLOW or display.COLOR_RED)
	mermaidGiftCtrl = mermaidGiftCtrl:isScoreEnough(self.score, 10) and COLOR3.YELLOW or display.COLOR_RED
	mermaidGiftCtrl, mermaidGiftCtrl, (mermaidGiftCtrl:isScoreEnough(self.score, 10) and COLOR3.YELLOW or display.COLOR_RED).num = self.score, string.formatnumberthousands(self.score), string.formatnumberthousands(self.score)
	string.formatnumberthousands(self.score).num, self.score.color = self.score, "#FFCC00"
	local str = i18n_html("Mermaid_text_13", mermaidGiftCtrl:isScoreEnough(self.score, 10) and COLOR3.YELLOW or display.COLOR_RED, (string.formatnumberthousands(self.score)))
	self.textNum:setString(str)
	local height = self.textNum:getContentSize().width
	SoraDSetTextWidthHeight(self.textNum, cc.size(height < 500 and height or 500, 23))
	SoraDToCenter(self.nodePoint, 0, SoraDFIsRA())
	self:setButtonTitleColor(self.btnFlopTen)
	self:setButtonTitleColor(self.btnFlopOne)
	dump(data, "mermaidGiftRewardView")
	if not data or not data.vals then
		local mermaidGiftCtrl, gifts = data.vals, data.vals
	end
	if not data or not data.rewards then
		local mermaidGiftCtrl, rewards = data.rewards, data.rewards
	end
	if not data or not data.lucks then
		local mermaidGiftCtrl, lucks = data.lucks, data.lucks
	end
	self:updateGifts(gifts)
	self:updateRewards(rewards)
	self:updateLuckys(lucks)
	if table.nums(gifts) > 5 then
		self.nodeGifts:setPositionY(self.posYs.Node_gifts - 20)
		self.nodeTitleLove:setPositionY(self.posYs.Node_LoveAward - 40)
		self.nodeTitleExtra:setPositionY(self.posYs.Node_ExtraAward - 40)
		self.nodeLucky:setPositionY(self.posYs.Node_lucky - 40)
		if table.nums(lucks) > 5 then
			self.nodeLuckys:setPositionY(self.posYs.Node_luckys - 13)
			self.nodePoint:setPositionY(self.posYs.Node_Num - 50)
			self.nodeButtons:setPositionY(self.posYs.Node_buttons - 50)
		else
			self.nodePoint:setPositionY(self.posYs.Node_Num - 40)
			self.nodeButtons:setPositionY(self.posYs.Node_buttons - 40)
		end
	else
		self.nodeGifts:setPositionY(self.posYs.Node_gifts)
		self.nodeTitleLove:setPositionY(self.posYs.Node_LoveAward)
		self.nodeTitleExtra:setPositionY(self.posYs.Node_ExtraAward)
		self.nodeLucky:setPositionY(self.posYs.Node_lucky)
		if table.nums(lucks) > 5 then
			self.nodeLuckys:setPositionY(self.posYs.Node_luckys - 15)
			self.nodePoint:setPositionY(self.posYs.Node_Num - 30)
			self.nodeButtons:setPositionY(self.posYs.Node_buttons - 30)
		else
			self.nodePoint:setPositionY(self.posYs.Node_Num)
			self.nodeButtons:setPositionY(self.posYs.Node_buttons)
		end
	end
end
function mermaidGiftRewardView:updateGifts(gifts)
	local addGiftNum = 0
	local parentNode = self.nodeGifts
	for k, v in pairs(parentNode:getChildren()) do
		v:setVisible(false)
	end
	for k, v in pairs(gifts) do
		local giftNode = parentNode:getChildByTag(k)
		if giftNode == nil then
			giftNode = self.giftSingle:clone()
			giftNode:addTo(parentNode)
			giftNode:setTag(k)
			giftNode:setPositionY(0)
		end
		giftNode:setVisible(true)
		local giftNum = mermaidGiftRead.getGiftNumByType(v)
		addGiftNum = addGiftNum + giftNum
		local icon = SoraDGetChildByName(giftNode, "Sprtie_icon")
		icon:setSpriteFrame(string.format("icon_mermaid_rewardType_%02d.png", v))
	end
	_ENV = parentNode:getChildren()
	parentNode:getChildren().num = addGiftNum
	self.addLoveText:setString(i18n("Mermaid_text_06", parentNode:getChildren()))
	SoraDautoSortPos(parentNode, 5, 1, cc.size(95, 60), not SoraDFIsRA())
end
function mermaidGiftRewardView:updateRewards(rewards)
	local parentNode = self.nodeRewards
	for k, v in pairs(parentNode:getChildren()) do
		v:setVisible(false)
	end
	for k, v in pairs(rewards) do
		local itemNode = parentNode:getChildByTag(k)
		if itemNode == nil then
			itemNode = SoraDPopItemAward()
			itemNode:addTo(parentNode)
			itemNode:setTag(k)
			itemNode:setScale(0.9)
			itemNode:setPositionY(2)
			itemNode:setScroll(self)
			table.insert(self.items, itemNode)
		end
		itemNode:setVisible(true)
		itemNode:initData(v.id, v.count)
	end
	SoraDToCenter(parentNode, 100)
	self.noRewardLb:setVisible(table.nums(rewards) <= 0)
end
function mermaidGiftRewardView:updateLuckys(luckys)
	local parentNode = self.nodeLuckys
	for k, v in pairs(parentNode:getChildren()) do
		v:setVisible(false)
	end
	for k, v in pairs(luckys) do
		local luckyNode = parentNode:getChildByTag(k)
		if luckyNode == nil then
			luckyNode = self.luckySingle:clone()
			luckyNode:addTo(parentNode)
			luckyNode:setTag(k)
			luckyNode:setScale(0.9)
			luckyNode:setPositionY(0)
		end
		luckyNode:setVisible(true)
		local numLb = SoraDGetChildByName(luckyNode, "Text_lucky_num")
		numLb:enableShadow(cc.c3b(0, 0, 0), cc.size(1, -1))
		numLb:setString(v)
	end
	SoraDautoSortPos(parentNode, 5, 1, cc.size(95, 52), not SoraDFIsRA())
	self.noLuckLb:setVisible(0 >= table.nums(luckys))
end
function mermaidGiftRewardView:setButtonTitleColor(target)
	if mermaidGiftCtrl:isScoreEnough(self.score, target:getTag()) then
		target:setTitleColor(cc.c3b(255, 255, 255))
	else
		target:setTitleColor(cc.c3b(255, 0, 0))
	end
end
function mermaidGiftRewardView:btnClickFlop(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.centerNode:getScale() < 1 or self.isClicked then
			return
		end
		SoraDPlaySound()
		local flopTimes = button:getTag()
		if mermaidGiftCtrl:isScoreEnough(self.score or 0, flopTimes) then
			if mermaidGiftCtrl:isScoreEnough(self.score, flopTimes) then
				mermaidGiftCtrl:reqMermaidGiftSwap(tonumber(flopTimes) == 10)
				self.isClicked = true
				self:close(self, eventType)
			else
				SoraDShowMsgTip(i18n("Mermaid_text_14"))
			end
		else
			SoraDShowMsgTip(i18n("luckyFlip_text_08"))
		end
	end
end
function mermaidGiftRewardView:btnClickAddPoint(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		if self.centerNode:getScale() < 1 then
			return
		end
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function mermaidGiftRewardView:onClose(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closePanel()
	end
end
return mermaidGiftRewardView
