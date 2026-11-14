local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
local chatAudioTip = class("chatAudioTip", function(target)
	return SoraDCreateBasePanel("chatAudioTip")
end)
_ENV = "chatAudioTip"
;("chatAudioTip").audio = 1
;("chatAudioTip").timeShort = 2
;("chatAudioTip").timeOut = 3
local ("chatAudioTip").cancle, ShowType = 4, "chatAudioTip"
function chatAudioTip:ctor(properties)
	self.viewName = "chatAudioTip"
	self:setName(self.viewName)
	self.spYjyh = SoraDGetChildByName(self, "icon_yjyh")
	self.nodeCapture = SoraDGetChildByName(self, "Node_Capture")
	self.textTime = SoraDGetChildByName(self, "Text_time")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	SoraDCreatAnimation("chatAudioTip", self, true)
	self:showOrHideAnim(false)
end
function chatAudioTip:initData(showType, parent)
	self.tipParent = parent
	if showType == ShowType.audio then
		self.spYjyh:setSpriteFrame("icon_yjyh_yy_01.png")
		self.spYjyh:setPositionY(30)
		self.textTime:setVisible(true)
		self.textTips:setString(i18n("chat_text_68"))
		self:showOrHideAnim(true)
	else
		self:showOrHideAnim(false)
		self.spYjyh:setPositionY(0)
		if showType == ShowType.timeShort then
			self.spYjyh:setSpriteFrame("icon_yjyh_tx.png")
			self.textTips:setString(i18n("common_text_2052"))
		elseif showType == ShowType.timeOut then
			self.spYjyh:setSpriteFrame("icon_yjyh_tx.png")
			self.textTips:setString(i18n("chat_text_70"))
		end
		self.textTime:setVisible(false)
		_ENV = i18n("chat_text_70")
		i18n("chat_text_70")[1] = cca.delay(0.7)
		i18n("chat_text_70")[2] = cca.callFunc(function()
			self:setVisible(false)
		end)
		i18n("chat_text_70")[3] = cca.callFunc(function()
			self:setVisible(false)
		end)
		self:runAction(cca.seq(i18n("chat_text_70")))
	end
	self:setVisible(true)
end
function chatAudioTip:updateAudioTime(audioTime)
	if 55 <= audioTime then
		self.textTips:setString(i18n("chat_text_68"))
		self.spYjyh:setSpriteFrame(string.format("frame_ltyh_djs_0%d.png", 60 - audioTime))
		self:showOrHideAnim(false)
	end
end
function chatAudioTip:showOrHideAnim(isShow)
	self.nodeCapture:setVisible(isShow)
	self.spYjyh:setVisible(not isShow)
end
function chatAudioTip:setTimeStr(timeStr)
	self.textTime:setString(timeStr)
end
function chatAudioTip:show(other)
	local parent = display.getRunningScene()
	local prePromptTip = parent:getChildByName(self.viewName)
	if prePromptTip then
		prePromptTip:removeFromParent(true)
	end
	self:setName(self.viewName)
	parent:addChild(self, 200)
end
return chatAudioTip
