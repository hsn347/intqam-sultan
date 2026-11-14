local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local anniversaryTreasureHuntCtrl = gametop.playertop_:getModule("anniversaryTreasureHuntCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local anniversaryTreasureHuntRead = include("anniversaryTreasureHuntRead")
local anniversaryTreasureHuntCardFlopView = class("anniversaryTreasureHuntCardFlopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anniversaryTreasureHuntCardFlopView")
	end
	return target
end)
_ENV = "anniversaryTreasureHuntCardFlopView"
_ENV = nil
;(nil).key = "anniversary_dice_text_03"
;("anniversaryTreasureHuntCardFlopView")[gTHAmazingEvent.MUTIPLE_DICE], (nil).png = nil, "bg_znxb_card_01.png"
_ENV = nil
;(nil).key = "anniversary_dice_text_04"
;("anniversaryTreasureHuntCardFlopView")[gTHAmazingEvent.FORWARD], (nil).png = nil, "bg_znxb_card_03.png"
_ENV = nil
;(nil).key = "anniversary_dice_text_05"
;("anniversaryTreasureHuntCardFlopView")[gTHAmazingEvent.BACK], (nil).png = nil, "bg_znxb_card_04.png"
_ENV = nil
;(nil).key = "anniversary_dice_text_06"
;("anniversaryTreasureHuntCardFlopView")[gTHAmazingEvent.MERCHANT], (nil).png = nil, "bg_znxb_card_02.png"
local flopInfo = "anniversaryTreasureHuntCardFlopView"
function anniversaryTreasureHuntCardFlopView:ctor()
	self:initControls()
end
function anniversaryTreasureHuntCardFlopView:initControls()
	self.nodeCenter = SoraDGetChildByName(self, "node_center")
	self.imgCard = SoraDGetChildByName(self, "Sprite_1")
	self.imgCard:setVisible(false)
	self.imgCardType = SoraDGetChildByName(self, "Sprite_2")
	self.txtTitle = SoraDGetChildByName(self, "text_title")
	self.txtShadow = SoraDGetChildByName(self, "text_shadow")
	self.txtIns = SoraDGetChildByName(self, "text_ins")
	self.nodeCenter:setPositionY(display.height / 2)
	self.txtTitle:setString(i18n("anniversary_dice_text_16"))
	self.txtShadow:setString(i18n("anniversary_dice_text_16"))
end
function anniversaryTreasureHuntCardFlopView:initCardFlopEffect()
	self.fanpai_effect = SoraDCreatAnimation("Node_Effect_fanpai", nil, false)
	SoraDMixtureGLONEByParent(self.fanpai_effect)
	self.fanpai_effect:setPosition(display.width / 2, display.height / 2)
	self.fanpai_effect:addTo(self)
	_ENV = display.height / 2
	;(display.height / 2).delay = 1.0
	;(display.height / 2).onComplete = function()
		self.fanpai_effect:setVisible(false)
		self.imgCardType:setVisible(true)
		self.txtIns:setVisible(true)
		self.imgCard:setSpriteFrame("frame_znxb_card_01.png")
		self.imgCard:setVisible(true)
	end
	transition.execute(self, nil, display.height / 2)
end
function anniversaryTreasureHuntCardFlopView:initData(curIndex)
	local eventType, eventNum = anniversaryTreasureHuntCtrl:getAmazingGridEventTypeAndNum(curIndex)
	print("weiryieuwyriuweyriuewyrui", eventType, eventNum, curIndex)
	if eventType ~= gTHAmazingEvent.NONE then
		self.imgCardType:setSpriteFrame(flopInfo[eventType].png)
		self.imgCardType:setVisible(false)
		self.txtIns:setVisible(false)
		if eventType == gTHAmazingEvent.MERCHANT then
			self.txtIns:setString(i18n(flopInfo[eventType].key))
		else
			anniversaryTreasureHuntCtrl = i18n(flopInfo[eventType].key)
			i18n(flopInfo[eventType].key).Num = eventNum
			self.txtIns:setString(i18n(flopInfo[eventType].key, i18n(flopInfo[eventType].key)))
		end
	end
	self:initCardFlopEffect()
end
function anniversaryTreasureHuntCardFlopView:flopAction(parent, card)
	local rotateOut = cc.OrbitCamera:create(0.2, 1, 0, 0, 90, 0, 0)
	local rotateIn = cc.OrbitCamera:create(0.2, 1, 0, 90, -90, 0, 0)
	local bgCard = cc.Sprite:createWithSpriteFrameName("frame_znxb_card_02.png")
	local cardsPox, cardsPoy = card:getPosition()
	print("backCardsAction")
	bgCard:setAnchorPoint(0.5, 0.5)
	bgCard:setPosition(cardsPox, cardsPoy)
	parent:addChild(bgCard, 60)
	local afterMoveCall = function()
		bgCard:removeFromParent()
	end
	local afterCall = function()
		if card then
			card:setVisible(true)
			card:setSpriteFrame("frame_znxb_card_01.png")
			card = nil
			;(nil).delay = 0.08
			;(nil).onComplete = function()
				self.imgCardType:setVisible(true)
			end
			transition.execute(self, nil, nil)
		end
	end
	local actCall = cc.CallFunc:create(afterMoveCall)
	local cardActCall = cc.CallFunc:create(afterCall)
	local seq_1 = cc.Sequence:create(cc.DelayTime:create(0.7), rotateOut, actCall)
	local seq_2 = cc.Sequence:create(cc.DelayTime:create(1.0), cardActCall, rotateIn)
	bgCard:runAction(seq_1)
	card:runAction(seq_2)
end
return anniversaryTreasureHuntCardFlopView
