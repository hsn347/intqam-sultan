local gametop = gModuleMgr.getObject("gametop")
local activity_9001628_Ctrl = gametop.playertop_:getModule("activity_9001628_Ctrl")
local activity_9001628_Read = include("activity_9001628_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activitty_9001628_CardFlopPanel = class("Activitty_9001628_CardFlopPanel", baseFguiPanel)
function Activitty_9001628_CardFlopPanel:ctor(...)
	Activitty_9001628_CardFlopPanel.super.ctor(self, ...)
	self.debug = true
	print("Activitty_9001628_CardFlopPanel:ctor", self.viewName)
end
function Activitty_9001628_CardFlopPanel:onInit()
	print("=======Activitty_9001628_CardFlopPanel:onInit")
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
function Activitty_9001628_CardFlopPanel:onShow()
	print("=======Activitty_9001628_CardFlopPanel:onShow")
end
function Activitty_9001628_CardFlopPanel:initCardFlopEffect()
	self.fanpai_effect = SoraDCreatAnimation("Node_Effect_fanpai", nil, false)
	SoraDMixtureGLONEByParent(self.fanpai_effect)
	self.fanpai_effect:setPosition(0, 0)
	self.fanpai_effect:addTo(self.nodeCenter)
	self:runAction(ffa.seq(ffa.delay(1.0), ffa.callFunc(function()
		self.fanpai_effect:setVisible(false)
		self.imgCardType:setVisible(true)
		self.txtIns:setVisible(true)
		self.imgCard:setIcon("frame_znxb_card_01.png")
		self.imgCard:setVisible(true)
	end)))
end
function Activitty_9001628_CardFlopPanel:initData(curIndex)
	local eventType, eventNum = activity_9001628_Ctrl:getAmazingGridEventTypeAndNum(curIndex)
	print("weiryieuwyriuweyriuewyrui", eventType, eventNum, curIndex)
	local flopInfo = activity_9001628_Read:getThaCfg(eventType, eventNum)
	self.eventType = eventType
	if eventType ~= gNTHAdveType.NONE then
		self.imgCardType:setIcon(flopInfo.image)
		self.imgCardType:setVisible(false)
		self.txtIns:setVisible(false)
		self.txtIns:setString(i18n(flopInfo.text))
	end
	self:initCardFlopEffect()
end
function Activitty_9001628_CardFlopPanel:setCloseCallBack(callback)
	self.closeCallback = callback
end
function Activitty_9001628_CardFlopPanel:onHide()
	local rewars = activity_9001628_Ctrl:getAdvRewwards()
	if rewars and 0 < #rewars and self.eventType == gNTHAdveType.RANDOM_REWARD then
		SoraDMailGainItems(rewars, true)
	end
	if self.closeCallback then
		self.closeCallback()
	end
end
return Activitty_9001628_CardFlopPanel
