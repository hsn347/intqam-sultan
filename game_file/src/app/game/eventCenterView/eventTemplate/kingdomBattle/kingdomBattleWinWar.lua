local KingdomBattleWinWar = class("kingdomBattleWinWar", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("kingdomBattleWinWar")
	end
	return target
end)
function KingdomBattleWinWar:ctor()
	self.nodeAni = SoraDGetChildByName(self, "Node_ani")
	self.centerNode = SoraDGetChildByName(self, "Center_Node_logo")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtTitle:setString(i18n("common_text_2182"))
	self.btnPrice = SoraDGetChildByName(self, "Button_price")
	self.btnPrice:setTitleText(i18n("common_text_854"))
	self.btnPrice:addTouchEventListener(handler(self, self.btnPriceClickCallBack))
	local shareBtn = include("commonShareButton").createSnapshootButton(6)
	shareBtn:setPosition(self.btnPrice:getPositionX() - SoraDFSign(185), self.btnPrice:getPositionY())
	shareBtn:addTo(self.btnPrice:getParent(), self.btnPrice:getLocalZOrder())
end
function KingdomBattleWinWar:initData(_mid)
	self.getMid = _mid
	self:initView()
end
function KingdomBattleWinWar:initView(...)
	local node
	node = SoraDCreatAnimation("animationKingWarWin", nil, false)
	if node then
		node:setLocalZOrder(-1)
		self.nodeAni:addChild(node)
	end
	SoraDPlaySound("innerbuildsound", 106)
end
function KingdomBattleWinWar:btnPriceClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.getMid then
			SoraDRequestMailReport(self.getMid, true)
		end
		self:removeFromParent()
	end
end
return KingdomBattleWinWar
