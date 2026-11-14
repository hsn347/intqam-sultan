local worldMapComDevil = class("worldMapComDevil", include("worldMapCom"))
function worldMapComDevil:ctor()
	worldMapComDevil.super.ctor(self, "worldMapComDevil")
end
function worldMapComDevil:init()
	local Z_ORDER = worldMapDefine.Z_ORDER
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	local topInfo = SoraDCreatePanel("worldMapNewTrialTopInfo")
	topInfo:addTo(self.target_)
	topInfo:setPosition(cc.p(0, display.height - 150))
	self.btnFieldIntegral = SoraDGetChildByName(self.target_, "Button_FieldIntegral")
	self.btnFieldIntegral:setVisible(false)
	do
		local btn = self.btnFieldIntegral:clone()
		btn:getChildByName("icon_fight_block"):setSpriteFrame("btn_devilvalley_02.png")
		btn:setVisible(true)
		btn:addTo(self.target_)
		btn:setPositionX(SoraDFPosX(555))
		btn:setPositionY(btn:getPositionY() - 40 + display.iPhoneXBottom)
		btn:addTouchEventListener(function(button, type)
			if type ~= ccui.TouchEventType.ended then
				return
			end
			SoraDPlaySound()
			local panel = uiManager:show("AllianceWarView")
			panel.view:tabChange(gAllianceQueueClassType.pve)
		end)
	end
	do
		local btn = self.btnFieldIntegral:clone()
		btn:getChildByName("icon_fight_block"):setSpriteFrame("btn_devilValley_quit.png")
		btn:setVisible(true)
		btn:addTo(self.target_)
		btn:setPositionX(SoraDFPosX(140))
		btn:setPositionY(btn:getPositionY() - 40 + display.iPhoneXBottom)
		btn:addTouchEventListener(function(button, type)
			if type ~= ccui.TouchEventType.ended then
				return
			end
			SoraDPlaySound()
			SoraDShowMsgBox(i18n("devilvalley_text_26"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					_G.SoraDGetCtrl("devilValleyCtrl"):sendReqEndChallenge()
					SoraDShowLoading(self.target_)
				end
			end)
		end)
	end
	if _G.SoraDGetCtrl("devilValleyCtrl"):getShowCountDown() then
		_G.SoraDGetCtrl("devilValleyCtrl"):setShowCountDown(false)
		SoraDShowLoading(self.target_, nil, nil, true, 3)
		local effectNode = SoraDCreatAnimation("newTrialCountDown", nil, false)
		effectNode:setPosition(cc.p(display.cx, display.cy))
		self.target_:addChild(effectNode)
	end
end
function worldMapComDevil:onMessageListener()
end
return worldMapComDevil
