local heroTrialView = class("heroTrialView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroTrialView")
	end
	return target
end)
function heroTrialView:ctor()
	self.isAddToPopManager = true
	local challengeBtn = SoraDGetChildByName(self, "challengeBtn")
	local rankBtn = SoraDGetChildByName(self, "rankBtn")
	local praiseBtn = SoraDGetChildByName(self, "praiseBtn")
	local rankWord = SoraDGetChildByName(self, "rankWord")
	local praiseWord = SoraDGetChildByName(self, "praiseWord")
	local title = SoraDGetChildByName(self, "title")
	local closeBtn = SoraDGetChildByName(self, "closeBtn")
	local helpBtn = SoraDGetChildByName(self, "helpBtn")
	local text1 = SoraDGetChildByName(self, "text1")
	local text2 = SoraDGetChildByName(self, "text2")
	local challengeWord = SoraDGetChildByName(self, "challengeWord")
	title:setString(i18n("common_text_1697"))
	text1:setString(i18n("common_text_1701"))
	text2:setString(i18n("common_text_1702"))
	rankWord:setString(i18n("common_text_1699"))
	praiseWord:setString(i18n("common_text_1700"))
	challengeWord:setString(i18n("common_text_1698"))
	challengeBtn:addTouchEventListener(handler(self, self.onChallenge))
	rankBtn:addTouchEventListener(handler(self, self.onRank))
	praiseBtn:addTouchEventListener(handler(self, self.onPraise))
	closeBtn:addTouchEventListener(handler(self, self.onClose))
	helpBtn:addTouchEventListener(handler(self, self.onHelp))
	self:addTouchEventListener(handler(self, self.onClose))
	_ENV, _UPVALUE1_ = self, self.addTouchEventListener
	self.name = "FrameAnimation/worldMapMonster"
	local self.addTouchEventListener[1], imgArray = self, self.addTouchEventListener
	self:loadImages(imgArray, function()
		self.loadFinish = true
	end)
end
function heroTrialView:onChallenge(sender, type)
	if type == ccui.TouchEventType.ended and self.loadFinish then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("heroTrialArea")
		panel:show()
		panel:showCurMap()
	end
end
function heroTrialView:onRank(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("heroTrialRank"):show()
	end
end
function heroTrialView:onPraise(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("heroTrialPraise"):show()
	end
end
function heroTrialView:onClose(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 1)
		self:close(sender, type)
	end
end
function heroTrialView:onHelp(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HERO_TRIAL)
	end
end
function heroTrialView:gameGuide_getTarget(itemName, parameters)
	return SoraDGetChildByName(self, itemName)
end
return heroTrialView
