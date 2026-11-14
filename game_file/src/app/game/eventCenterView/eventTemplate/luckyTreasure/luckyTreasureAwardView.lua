_ENV = nil
;(nil).x = 110
local (nil).y, beginPos = 31, nil
local gametop = gModuleMgr.getObject("gametop")
local luckyTreasureCtrl = gametop.playertop_:getModule("luckyTreasureCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local luckyTreasureAwardView = class("luckyTreasureAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("luckyTreasureAwardView")
	end
	if type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function luckyTreasureAwardView:ctor()
	self.panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.node_center = SoraDGetChildByName(self, "Center_Node")
	self.node_items = SoraDGetChildByName(self, "Node_items")
	self.btn_confirm = SoraDGetChildByName(self, "Button_gain")
	self.btn_buy_ten = SoraDGetChildByName(self, "Button_buy_ten")
	self.text_ten_cost = SoraDGetChildByName(self.btn_buy_ten, "Text_costNum")
	self.act_double = SoraDCreatAnimation("luckyDouble")
	self.act_double:setVisible(false)
	self.btn_confirm:setTitleText(i18n("common_text_204"))
	self.btn_confirm:addTouchEventListener(handler(self, self.onClickBtnConfirm))
	self.btn_buy_ten:addTouchEventListener(handler(self, self.onClickBtnTen))
	self.singleArray, _ENV = self.btn_buy_ten.addTouchEventListener, self.btn_buy_ten.addTouchEventListener
end
function luckyTreasureAwardView:initView()
	self.panelTouchBg = SoraDGetChildByName(self, "Panel_touchBg")
	SoraDDelayCallOnce("luckyTreasureAwardView_Function", function()
		if self.panelTouchBg then
			self.panelTouchBg:setVisible(false)
		end
	end, 2.0)
	local runRateAction = function(rate, nodeItem)
		local rateNode = SoraDCreatAnimation("luckyDouble")
		rateNode:addTo(self.node_items, 50)
		rateNode:setPosition(nodeItem:getPositionX() + 30, nodeItem:getPositionY() + 40)
		rateNode:setVisible(true)
		local textRate = rateNode:getChildByName("text_rate")
		textRate:setString("x" .. rate)
		textRate:setScale(5)
		local imgShine = textRate:getChildByName("Sprite_9")
		_UPVALUE4_ = "Sprite_9"
		;("Sprite_9")[1] = cca.scaleTo(0.03, 4.5)
		;("Sprite_9")[2] = cca.scaleTo(0.05, 3.75)
		;("Sprite_9")[3] = cca.scaleTo(0.07, 0.6)
		;("Sprite_9")[4] = cca.delay(0.1)
		;("Sprite_9")[5] = cca.callFunc(function()
			imgShine:setVisible(false)
		end)
		;("Sprite_9")[6] = cca.callFunc(function()
			imgShine:setVisible(false)
		end)
		local action = cca.seq("Sprite_9")
		textRate:runAction(action)
		local fadeTo = cca.fadeTo(0.2, 1)
		local func = cca.callFunc(function(...)
			if nodeItem:getChildByName("Node_particle") then
				nodeItem:getChildByName("Node_particle"):setVisible(false)
			end
		end)
		self = cca.scaleTo(0.07, 0.6)
		cca.scaleTo(0.07, 0.6)[1] = func
		local seq = cca.seq((cca.scaleTo(0.07, 0.6)))
		_UPVALUE2_ = func
		func[1] = fadeTo
		func[2] = seq
		local spawn = cca.spawn(func)
		rateNode:runAction(spawn)
	end
	for i = 1, #self.rewardList do
		do
			local item = self.singleArray[i]
			item:setVisible(true)
			if self.rewardList[i].curRate and 1 < self.rewardList[i].curRate then
				_UPVALUE1_ = item
				item[1] = cca.delay(0.4)
				item[2] = cca.callFunc(function()
					runRateAction(self.rewardList[i].curRate, item)
				end)
				item[3] = cca.callFunc(function()
					runRateAction(self.rewardList[i].curRate, item)
				end)
				local seq = cca.seq(item)
				item:runAction(seq)
			end
			if self.rewardList[i].position == self.importantItem then
				self:createSingleAnimation(item)
			end
		end
	end
end
function luckyTreasureAwardView:createSingleAnimation(single)
	SoraDPlaySound("pyramid", 6)
	if not single.animation then
		local singleAnt = SoraDCreatAnimationEx("luckyTreasureChoose", nil, false)
		singleAnt:addTo(single, 10)
		single.pFront1 = singleAnt:getChildByName("Particle_shine_1")
		single.pFront2 = singleAnt:getChildByName("Particle_shine_1")
		single.pBehind = singleAnt:getChildByName("Particle_shine_behind")
	else
		single.pFront1:stopSystem()
		single.pFront2:stopSystem()
		single.pBehind:stopSystem()
		single.pFront1:resetSystem()
		single.pFront2:resetSystem()
		single.pBehind:resetSystem()
	end
end
function luckyTreasureAwardView:initRewards(data)
	self.rewardList = data
	self.importantItem = luckyTreasureCtrl:getImportantRewardByIndex()
	self:initBtn()
	local beginIdx = 1
	_ENV = nil
	;(nil)[1] = cca.callFunc(function()
		local single = include("commonItemAward").new()
		single:setName(tostring(self.rewardList[beginIdx].reward.id))
		single:setOwnView(self)
		single:addTo(self.node_items)
		single:initData(self.rewardList[beginIdx].reward.id, self.rewardList[beginIdx].reward.count)
		single:setScale(1)
		single:setBaseScale(1.0)
		if self.rewardList[beginIdx].position == self.importantItem then
			single:showCoolSquare()
		end
		SoraDautoSortPos(self.node_items, 5, 1, cc.size(106, 106))
		table.insert(self.singleArray, single)
		if beginIdx == #self.rewardList + 1 then
			self:stopActionByTag(55)
			self:initView()
		end
	end)
	;(nil)[2] = cca.delay(0.1)
	;(nil)[3] = cca.delay(0.1)
	local seqMove = cca.seq(nil)
	local actionTen = cca.repeatForever(seqMove)
	actionTen:setTag(55)
	self:runAction(actionTen)
end
function luckyTreasureAwardView:initBtn()
	self.costItem = luckyTreasureCtrl:getCurrentCostItem()
	luckyTreasureCtrl = nil
	;(nil).count = 10
	self.btn_buy_ten:getChildByName("Text_alter"):setString(i18n("Lucky_treasure_text_06", nil))
	self.btn_buy_ten:getChildByName("Image_icon"):loadTexture(publicRead.getSmallIcon(self.costItem.tenCost.id), ccui.TextureResType.plistType)
	self.text_ten_cost:setString(self.costItem.tenCost.count)
	if not self:chectIsCostItemEnough(self.costItem.tenCost) then
		self.text_ten_cost:setColor(display.COLOR_RED)
	else
		self.text_ten_cost:setColor(cc.c3b(255, 255, 0))
	end
end
function luckyTreasureAwardView:chectIsCostItemEnough(param)
	local itemType = serviceFunctions.getIDType(param.id)
	local itemCount = 0
	if itemType == gIDType.GOLD then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		itemCount = lordInfoCtrl:getBaseInfo().gold
	elseif itemType == gIDType.ITEM then
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		itemCount = backpackCtrl:getItemCount(itemID)
	end
	return itemCount >= param.count
end
function luckyTreasureAwardView:setHandle(handle)
	self.handle = handle
end
function luckyTreasureAwardView:onClickBtnTen(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle()
		end
		self:showPrize()
		self:close(button, type)
	end
end
function luckyTreasureAwardView:onClickBtnConfirm(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:showPrize()
		self:close(button, type)
	end
end
function luckyTreasureAwardView:showPrize()
	local _ENV, curId
	for i, v in ipairs(self.rewardList) do
		_ENV = nil
		;(nil).id = v.reward.id
		;(nil).count = v.reward.count
		;(nil).rate = v.curRate
		table.insert(curId, nil)
	end
	SoraDMailGainItems(curId, true)
end
return luckyTreasureAwardView
