local activity_9001729_Read = include("activity_9001729_Read")
local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001729_CardFlopPanel = class("Activity_9001729_CardFlopPanel", baseFguiPanel)
function Activity_9001729_CardFlopPanel:ctor(...)
	self.isLRU = true
	Activity_9001729_CardFlopPanel.super.ctor(self, ...)
	print("Activity_9001729_CardFlopPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
end
function Activity_9001729_CardFlopPanel:onInit()
	print("=======Activity_9001729_CardFlopPanel:onInit")
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
function Activity_9001729_CardFlopPanel:onShow()
	print("=======Activity_9001729_CardFlopPanel:onShow")
	self:initData(self.param.eventType, self.param.callback)
end
function Activity_9001729_CardFlopPanel:initCardFlopEffect()
	self.fanpai_effect = SoraDCreatAnimation("Node_Effect_fanpai", nil, false)
	SoraDMixtureGLONEByParent(self.fanpai_effect)
	self.fanpai_effect:setPosition(0, 0)
	self.fanpai_effect:addTo(self.nodeCenter)
	self.fanpai_effect:setVisible(true)
	self.imgCardType:setVisible(false)
	self.imgCard:setVisible(false)
	self.txtIns:setVisible(false)
	local _ENV, actions = self.txtIns.setVisible, self.txtIns.setVisible
	table.insert(actions, ffa.delay(1.0))
	table.insert(actions, ffa.callFunc(function()
		self.fanpai_effect:setVisible(false)
		self.imgCardType:setVisible(true)
		self.txtIns:setVisible(true)
		self.imgCard:setIcon("frame_znxb_card_01.png")
		self.imgCard:setVisible(true)
	end))
	if self.param.isAuto then
		table.insert(actions, ffa.delay(1.5))
		table.insert(actions, ffa.callFunc(function()
			self:close()
		end))
	end
	self:runAction(ffa.seq(actions))
end
function Activity_9001729_CardFlopPanel:initData(eventType, callback)
	self.closeCallback = callback
	local flopInfo = activity_9001729_Read.getEventConfig(eventType)
	self.eventType = eventType
	if eventType ~= 0 then
		self.imgCardType:setIcon(flopInfo.image)
		self.imgCardType:setVisible(false)
		self.txtIns:setVisible(false)
		self.txtIns:setString(i18n(flopInfo.text))
	end
	self:initCardFlopEffect()
end
function Activity_9001729_CardFlopPanel:onHide()
	if self.closeCallback then
		self.closeCallback()
	end
end
return Activity_9001729_CardFlopPanel
