local newKingFundRead = include("newKingFundRead")
local gametop = gModuleMgr.getObject("gametop")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local newTrialRead = include("newTrialRead")
local christmasBattleCtrl = SoraDGetCtrl("christmasBattleCtrl", gametop)
local ChristmasBattleShowBoxReward = class("ChristmasBattleShowBoxReward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("ChristmasBattleShowBoxReward")
	end
	return target
end)
function ChristmasBattleShowBoxReward:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_UPDATE", function(target, data)
		self:removeFromParent()
	end)
end
function ChristmasBattleShowBoxReward:bandWidget()
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Panel_cut:setPositionY(display.cy)
	christmasBattleCtrl = display.cy
	display.cy[1] = "Text_name"
	SoraDGetChildByFullPath(self.Panel_cut, display.cy):setString(i18n("common_text_4280"))
	christmasBattleCtrl = i18n("common_text_4280")
	i18n("common_text_4280")[1] = "ScrollView_reward"
	self.scroll = SoraDGetChildByFullPath(self.Panel_cut, i18n("common_text_4280"))
	self.scroll:setContentSize(cc.size(450, 200))
	self.scroll:setInnerContainerSize(cc.size(450, 300))
	christmasBattleCtrl = cc.size(450, 300)
	cc.size(450, 300)[1] = "Button_get"
	self.Button_get = SoraDGetChildByFullPath(self.Panel_cut, cc.size(450, 300))
	self.Button_get:setTitleText(i18n("common_text_1146"))
	self.Button_get:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			christmasBattleCtrl:sendGetFavorGift(self.giftIndex)
		end
	end)
end
function ChristmasBattleShowBoxReward:initData(data)
	self.giftIndex = data.index
	if not data.reward then
		local _ENV, rewards = data.reward, data.reward
	end
	local dataCount = #rewards
	local MAX_REWARD = 8
	dataCount = math.min(MAX_REWARD, math.floor(dataCount / 2) * 2)
	if dataCount == 0 then
		return
	end
	local MAX_COLUMN = 4
	local offsetX = 2
	local offsetY = -10
	local SINGLE_WIDTH = 120
	local SINGLE_HEIGHT = 100
	if dataCount <= MAX_COLUMN then
		offsetX = offsetX + (MAX_COLUMN - dataCount) / 2 * SINGLE_WIDTH
		offsetY = 42
	end
	local scrollMinH = 0
	local scrollH = math.max(scrollMinH, math.ceil(dataCount / MAX_COLUMN) * SINGLE_HEIGHT)
	self.scroll:setInnerContainerSize(cc.size(450, scrollH))
	local _ENV, positions = self.scroll.setInnerContainerSize, self.scroll.setInnerContainerSize
	for i = 1, MAX_REWARD do
		local column = (i - 1) % MAX_COLUMN + 1
		local row = math.ceil(i / MAX_COLUMN)
		_UPVALUE2_ = i / MAX_COLUMN
		;(i / MAX_COLUMN)[1] = offsetX + (column - 1) * SINGLE_WIDTH
		local (i / MAX_COLUMN)[2], position = offsetY + scrollH - (row - 1) * SINGLE_HEIGHT, i / MAX_COLUMN
		positions[#positions + 1] = position
	end
	if dataCount == 6 then
		for i = 1, dataCount do
			if i <= 2 then
				positions[i] = clone(positions[i + 1])
			else
				positions[i] = clone(positions[i + 2])
			end
		end
	end
	for i = 1, dataCount do
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(positions[i][1], positions[i][2]))
		singleItem:addTo(self.scroll)
		singleItem:setScale(0.55)
		_ENV, _ENV = cc.p(positions[i][1], positions[i][2])
		cc.p(positions[i][1], positions[i][2]).id = rewards[i].key
		;(0.55).itemData, cc.p(positions[i][1], positions[i][2]).count = cc.p(positions[i][1], positions[i][2])
		singleItem:initData(0.55)
		singleItem:setButtonTag(rewards[i].key)
		singleItem:setItemClickCallback(handler(self, self.showDetail))
	end
	if dataCount <= MAX_COLUMN * 2 then
		self.scroll:setTouchEnabled(false)
	else
		self.scroll:setTouchEnabled(true)
	end
end
function ChristmasBattleShowBoxReward:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
		self.tips = SoraDCreatePanel("commonItemTips")
		self.tips:initData(button:getTag())
		local dt = 140
		if not SoraDFIsRA() then
			dt = -140
		end
		self.tips:setPosition(cc.p(320 + dt, display.height / 2 - 80))
		self.tips:addTo(self, 99)
	end
end
return ChristmasBattleShowBoxReward
