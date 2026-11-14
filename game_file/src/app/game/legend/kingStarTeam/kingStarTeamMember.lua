local scrollNode = include("scrollNode")
local kingStarTeamMember = class("kingStarTeamMember", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("kingStarTeamMember")
	end
	if target ~= nil then
		local timerClass = include("kingStarMemberBase")
		target = timerClass.new(target)
	end
	return target
end)
function kingStarTeamMember:ctor()
	self.labelOnline = SoraDGetChildByName(self, "Text_online")
	self.labelOnline:setVisible(false)
	self.labelOnline:setString(i18n("common_text_224"))
	self.nodeOnline = SoraDGetChildByName(self, "Node_onlne")
	self.imgOut = SoraDGetChildByName(self, "Image_out")
	self.imgOut = scrollNode.new(self.imgOut)
	self.imgOut:setTouchEnabled(true)
	self.imgOut:addTouchEventListener(handler(self, self.btnOutClickCallBack))
	self.frame_rank = SoraDGetChildByName(self, "Panel_info")
	if self.frame_rank then
		self.frame_rank:setSwallowTouches(false)
		self.frame_rank = scrollNode.new(self.frame_rank)
		self.frame_rank:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.nodeTip = SoraDGetChildByName(self, "Node_war_top")
	self.txtWarTip = SoraDGetChildByName(self, "Text_war_tips")
end
function kingStarTeamMember:initData(data, otherData)
	self.tableSingleData = data
	self.headClick = false
	self.outClick = false
	if self.tableSingleData and self.tableSingleData.uid then
		self.iconhead:setScale(0.8)
		local isOnline = self.tableSingleData.online == 0
		self.nodeOnline:setVisible(isOnline)
		self.framehead:setTouchEnabled(true)
		self:updateInfo()
		local inBattleField = self.tableSingleData.inBattleField
		self.nodeTip:setVisible(not inBattleField)
		if not inBattleField then
			self.txtWarTip:setString(i18n("Anchor_text_07"))
		end
		self.imgOut:setVisible(self.tableSingleData.isSelfLeader and not self.tableSingleData.isLeader)
	else
		if self.tableSingleData.canInvited then
			self.iconhead:setSpriteFrame("frame_LegendaryKing_green_add.png")
			self.iconhead:setScale(0.9)
		else
			self.iconhead:setSpriteFrame("icon_fight_block.png")
			self.iconhead:setScale(75 / self.iconhead:getContentSize().width)
		end
		self.framehead:setTouchEnabled(false)
		self.spLeader:setVisible(false)
		self.nodeOnline:setVisible(false)
		self.nodeTip:setVisible(false)
	end
	self:setHandle(otherData.handlerPlayer)
	self:setHandleOut(otherData.handlerOut)
	self:setScroll(otherData.scroll)
end
function kingStarTeamMember:setScroll(scroll)
	self.frame_rank:setScroll(scroll)
	self.framehead:setScroll(scroll)
	self.imgOut:setScroll(scroll)
end
function kingStarTeamMember:setHandleBg(handle)
	self.handleBg = handle
end
function kingStarTeamMember:setHandleOut(handle)
	self.handleOut = handle
end
function kingStarTeamMember:btnClickHeadCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.imgClick then
			return
		end
		SoraDPlaySound()
		self.headClick = true
		if self.handle then
			self.handle(self.tableSingleData)
		end
	end
end
function kingStarTeamMember:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.imgClick then
			self.imgClick = false
			return
		end
		if self.headClick then
			self.headClick = false
			return
		end
		SoraDPlaySound()
		if self.handleBg then
			self.handleBg(self.tableSingleData)
		end
	end
end
function kingStarTeamMember:btnOutClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.imgClick = true
		if self.handleOut then
			self.handleOut(self.tableSingleData)
		end
	end
end
return kingStarTeamMember
