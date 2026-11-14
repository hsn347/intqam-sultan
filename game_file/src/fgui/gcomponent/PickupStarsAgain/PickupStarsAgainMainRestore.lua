local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local pickupStarsAgainRead = include("pickupStarsAgainRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local longEventTime = 0.4
local spaceTime = 0.1
local longActTag = 100
_ENV = nil
;(nil).PERSON = 1
local (nil).GLOBAL, REWARDTYPE = 2, nil
local baseComponent = require("fgui.base.baseComponent")
local PickupStarsAgainMainRestore = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/PickupStarsAgainMainRestore", PickupStarsAgainMainRestore)
function PickupStarsAgainMainRestore:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.isFirst = true
	print("PickupStarsAgainMainRestore:ctor")
end
function PickupStarsAgainMainRestore:onInit()
	SoraDPlaySound("sixYear", "ui_colossus")
	local constantRead = include("constantRead")
	self.itemID = constantRead.getConstValue("PICKUP_STARS_ITEM")
	self.fields.Com_have:initData(self.itemID)
	_UPVALUE5_ = self.fields.Com_have.initData
	self.boxes, self.fields.Com_have.initData[1] = self.fields.Com_have.initData, self.fields.Button_box1
	self.boxes, self.fields.Com_have.initData[2] = self.fields.Com_have.initData, self.fields.Button_box2
	self.boxes, self.fields.Com_have.initData[3] = self.fields.Com_have.initData, self.fields.Button_box3
	self.boxes, self.fields.Com_have.initData[4] = self.fields.Com_have.initData, self.fields.Button_box4
	self.boxes, self.fields.Com_have.initData[5] = self.fields.Com_have.initData, self.fields.Button_box5
	for index, value in ipairs(self.boxes) do
		value:setTag(index)
		value:addClickListener(handler(self, self.onBoxClick))
	end
	self.fields.button_use:setTitle(i18n("pickup_star_30"))
	self.fields.txt_use_tip:setString(i18n("pickup_star_31"))
	self.fields.button_use:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onUseClickStart))
	self.fields.button_use:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onUseClickMove))
	self.fields.button_use:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onUseClickEnd))
	pickupStarsAgainCtrl:reqInit()
	self.fields.global_box:fixPos()
	self.fields.progressBar2:fixPos()
	self.fields.progressBar2:fix()
	for index, value in ipairs(self.boxes) do
		value:fixPos()
	end
	self.fields.button_use:getGroup():ensureBoundsCorrect()
end
function PickupStarsAgainMainRestore:onShow()
	print("=======PickupStarsAgainMainRestore:onShow")
	self.soundId = SoraDPlaySound("sixYear", "amb_city")
end
function PickupStarsAgainMainRestore:onHide()
	AudioEngine.stopEffect(self.soundId)
end
function PickupStarsAgainMainRestore:onDispose()
	print("=======PickupStarsAgainMainRestore:onDispose")
end
function PickupStarsAgainMainRestore:updateUI()
	self:updatePersonBox()
	self:updateGlobalBox()
	self.fields.button_use:setReddot(pickupStarsAgainCtrl:canBuid())
	self.isFirst = false
end
function PickupStarsAgainMainRestore:updatePersonBox()
	local myScore = pickupStarsAgainCtrl:getMyScore()
	local myRewardCfgs = pickupStarsAgainRead:getRewards(REWARDTYPE.PERSON)
	self.myRewardCfgs = myRewardCfgs
	for i, v in ipairs(myRewardCfgs) do
		local isGot = pickupStarsAgainCtrl:isRewardGot(REWARDTYPE.PERSON, v.Rank)
		local box = self.boxes[i]
		box:setString(v.NeedNum)
		if isGot then
			box:initData(2)
		elseif myScore >= v.NeedNum then
			box:initData(1)
		else
			box:initData(0)
		end
	end
	local myScore = pickupStarsAgainCtrl:getMyScore()
	local maxScore = pickupStarsAgainRead:getMaxScore(REWARDTYPE.PERSON)
	self.fields.progressBar2:setValue(myScore / maxScore * 100)
	pickupStarsAgainCtrl = self.boxes[i]
	self.boxes[i].num = myScore
	self.fields.txt_value:setString(i18n_html("pickup_star_005", self.boxes[i]))
	self.haveNum = backpackCtrl:getItemCount(self.itemID)
	self.fields.Com_have:updateNum()
end
function PickupStarsAgainMainRestore:updateGlobalBox()
	self.fields.global_box:updateGlobalBox()
end
function PickupStarsAgainMainRestore:onBoxClick(context)
	SoraDPlaySound()
	local tag = context:getSender():getTag()
	_ENV = nil
	;(nil).rewardCfg = self.myRewardCfgs[tag]
	uiManager:show("PickupStarsAgainReward", nil)
end
function PickupStarsAgainMainRestore:onUseClick()
	SoraDPlaySound()
	if self.haveNum > 0 then
		self.haveNum = self.haveNum - 1
		pickupStarsAgainCtrl:reqAnnivColossusBuild()
		if self.haveNum > 0 and self.isLong then
			self:runLongPress(spaceTime)
		end
	else
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("Glory_text_19", nil))
		self:stopActionByTag(longActTag)
	end
end
function PickupStarsAgainMainRestore:onUseClickStart(eventContext)
	self:runLongPress(longEventTime)
	print("PickupStarsAgainMainRestore:onUseClickStart")
	self.touchBeganPoint = eventContext:getInput():getPosition()
end
function PickupStarsAgainMainRestore:onUseClickMove(eventContext)
	print("PickupStarsAgainMainRestore:onUseClickMove")
	self.touchmovePoint = eventContext:getInput():getPosition()
	local distance = cc.pGetDistance(self.touchBeganPoint, self.touchmovePoint)
	if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
		print("PickupStarsAgainMainRestore:Moved")
		self:stopActionByTag(longActTag)
	end
end
function PickupStarsAgainMainRestore:onUseClickEnd(eventContext)
	print("PickupStarsAgainMainRestore:onUseClickEnd")
	self:stopActionByTag(longActTag)
	if not self.isLong then
		self:onUseClick()
	end
	self.isLong = false
end
function PickupStarsAgainMainRestore:runLongPress(dt)
	self.isLong = false
	self.stop = true
	longActTag = nil
	;(nil)[1] = ffa.delay(dt)
	;(nil)[2] = ffa.callFunc(function()
		self.isLong = true
		self:onUseClick()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.isLong = true
		self:onUseClick()
	end)
	local seqLong = ffa.seq(nil)
	seqLong:setTag(longActTag)
	self:runAction(seqLong)
end
return PickupStarsAgainMainRestore
