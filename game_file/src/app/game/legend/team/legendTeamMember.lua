local scrollNode = include("scrollNode")
local teamDef = include("teamDef")
local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
local legendTeamMember = class("legendTeamMember", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("legendTeamMember")
	end
	if target ~= nil then
		local timerClass = include("legendMemberBase")
		target = timerClass.new(target)
	end
	return target
end)
function legendTeamMember:ctor()
	self.labelOnline = SoraDGetChildByName(self, "Text_online")
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
function legendTeamMember:initData(data, otherData)
	self.tableSingleData = data
	self.headClick = false
	self.outClick = false
	if self.tableSingleData and self.tableSingleData.uid then
		self.iconhead:setScale(0.8)
		local isOnline = self.tableSingleData.online == 0
		self.nodeOnline:setVisible(true)
		self.framehead:setTouchEnabled(true)
		self:updateInfo()
		local inBattleField = self.tableSingleData.inBattleField
		self.nodeTip:setVisible(not inBattleField)
		if not inBattleField then
			self.txtWarTip:setString(i18n("legendary_commander_text28"))
		end
		self.labelOnline:setString(isOnline and i18n("common_text_224") or i18n("common_text_3976"))
		self.labelOnline:setColor(isOnline and cc.c3b(76, 230, 26) or cc.c3b(116, 110, 101))
		if IsArClient then
			self.imgOut:setVisible(self.tableSingleData.isSelfLeader and not self.tableSingleData.isLeader)
		elseif self.tableSingleData.isSelfLeader and not self.tableSingleData.isLeader and otherData.teamType and otherData.teamType >= teamDef.teamAreaEnum.LEGEND_HEGEMON_1 and otherData.teamType <= teamDef.teamAreaEnum.LEGEND_HEGEMON_6 and not self.tableSingleData.inBattleField then
			self.imgOut:setVisible(true)
		else
			self.imgOut:setVisible(false)
		end
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
function legendTeamMember:setScroll(scroll)
	self.frame_rank:setScroll(scroll)
	self.framehead:setScroll(scroll)
	self.imgOut:setScroll(scroll)
end
function legendTeamMember:setHandleBg(handle)
	self.handleBg = handle
end
function legendTeamMember:setHandleOut(handle)
	self.handleOut = handle
end
function legendTeamMember:btnClickHeadCallBack(button, type)
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
function legendTeamMember:btnClickCallBack(button, type)
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
function legendTeamMember:btnOutClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.imgClick = true
		if self.handleOut then
			self.handleOut(self.tableSingleData)
		end
	end
end
return legendTeamMember
