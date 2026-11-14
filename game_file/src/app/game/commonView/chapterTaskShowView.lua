local newPlayerTaskRead = include("newPlayerTaskRead")
local chapterTaskShowView = class("chapterTaskShowView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chapterTaskShowView")
	end
	return target
end)
function chapterTaskShowView:ctor()
	self.isAddToPopManager = true
	self.Top_bg_chapter = SoraDGetChildByName(self, "Top_bg_chapter")
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.Bottom_Image_shadow = SoraDGetChildByName(self, "Bottom_Image_shadow")
	self.Bottom_Node_title = SoraDGetChildByName(self, "Bottom_Node_title")
	self:suitView()
	SoraDPlaySound("uicontrol", 53)
end
function chapterTaskShowView:suitView()
	self.Top_bg_chapter:setPositionY(math.max(1085, display.height))
	self.Bottom_Image_shadow:setPositionY(math.max(-190, -display.height + 705))
	if display.height > 1136 then
		self.Top_bg_chapter:setPositionY(display.rheight)
		self.Bottom_Image_shadow:setPositionY(0)
	elseif display.height < 960 then
		self.Top_bg_chapter:setPositionY(display.rheight)
	end
	self.Bottom_Node_title:setPositionY(180)
	local et_node = SoraDCreatAnimationEx("animationCTaskShow", nil, false, 0.95)
	et_node:addTo(self.Node_effect)
end
function chapterTaskShowView:initData(chatperID)
	self.chatperID = chatperID
	self.Top_bg_chapter:setSpriteFrame(newPlayerTaskRead.getPngByCID(chatperID))
	local titlePng = newPlayerTaskRead.getChapterTitlePng(chatperID)
	self.ccs_title = SoraDCreatePanel("animationCTitle")
	self.ccs_title:initAni(titlePng, 0.2)
	self.ccs_title:setPosition(0, 0)
	self.ccs_title:addTo(self.Bottom_Node_title)
	self.Top_bg_chapter:setScale(1.1)
	_UPVALUE5_ = self.Top_bg_chapter
	self.Top_bg_chapter[1] = cca.delay(0.2)
	self.Top_bg_chapter[2] = cca.scaleTo(1.0, 1.0, 1.0)
	self.Top_bg_chapter[3] = cca.delay(1.65)
	self.Top_bg_chapter[4] = cca.callFunc(function()
		self:fadeOutExit()
	end)
	self.Top_bg_chapter[5] = cca.delay(0.5)
	self.Top_bg_chapter[6] = cca.callFunc(function()
		self:onOneChatperDone()
		self = nil
		;(nil).byUID = true
		local chapterIDTb = SoraDConfigGet("Game:newPlayerTask:chapterID~table", nil)
		chapterIDTb[tostring(self.chatperID)] = 2
		self = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:newPlayerTask:chapterID~table", chapterIDTb, nil)
		self:removeFromParent()
		SoraDCreatePanel("newPlayerQuestView"):show()
	end)
	self.Top_bg_chapter[7] = cca.callFunc(function()
		self:onOneChatperDone()
		self = nil
		;(nil).byUID = true
		local chapterIDTb = SoraDConfigGet("Game:newPlayerTask:chapterID~table", nil)
		chapterIDTb[tostring(self.chatperID)] = 2
		self = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:newPlayerTask:chapterID~table", chapterIDTb, nil)
		self:removeFromParent()
		SoraDCreatePanel("newPlayerQuestView"):show()
	end)
	local animation = cca.seq(self.Top_bg_chapter)
	self.Top_bg_chapter:runAction(animation)
end
function chapterTaskShowView:fadeOutExit()
	_UPVALUE3_ = nil
	;(nil)[1] = self.Top_bg_chapter
	;(nil)[2] = self.Bottom_Image_shadow
	local (nil)[3], targetArray = self.ccs_title.Frame_target, nil
	for k, v in ipairs(targetArray) do
		v:runAction(cca.fadeOut(0.5))
	end
end
function chapterTaskShowView:onOneChatperDone()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAPTERTASK_CLOSE"
	;(nil).id = self.chatperID
	SoraDSendMessage(nil)
	if self.chatperID == 4103000 then
	elseif self.chatperID == 4103100 then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_BUILD_CASTLE_LV2)
		_ENV = mildGuideManager
		mildGuideManager.msg = "MESSAGE_SERVER_GUIDE_HIDE_AND_SHOW"
		SoraDSendMessage(mildGuideManager)
	end
end
function chapterTaskShowView:endShow()
end
return chapterTaskShowView
