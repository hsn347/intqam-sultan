local scrollNode = include("scrollNode")
local buildLogic = include("buildLogic")
local myTeamMember = class("myTeamMember", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("myTeamMember")
	end
	if target ~= nil then
		local timerClass = include("teamMemberBase")
		target = timerClass.new(target)
	end
	return target
end)
function myTeamMember:ctor()
	self.nodeHas = SoraDGetChildByName(self, "Node_member_has")
	self.nodeAdding = SoraDGetChildByName(self, "Node_member_adding")
	self.txtTeamTips = SoraDGetChildByName(self, "Text_team_tips")
	self.txtTeamTips:setString(i18n("remains_text_36"))
	self.spriteCastle = SoraDGetChildByName(self, "Sprite_castle")
	self.labelCastleLv = SoraDGetChildByName(self, "Text_castleLv")
	self:initCastleLvStarLvNode()
	self.labelOnline = SoraDGetChildByName(self, "Text_online")
	self.labelOnline:setString(i18n("common_text_224"))
	self.nodeOnline = SoraDGetChildByName(self, "Node_onlne")
	self.frame_rank = SoraDGetChildByName(self, "Panel_info")
	if self.frame_rank then
		self.frame_rank:setSwallowTouches(false)
		self.frame_rank = scrollNode.new(self.frame_rank)
		self.frame_rank:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function myTeamMember:initData(data)
	self.tableSingleData = data
	self.headClick = false
	if self.tableSingleData and self.tableSingleData.uid then
		self.nodeAdding:setVisible(false)
		self.nodeHas:setVisible(true)
		self.iconhead:setScale(0.8)
		local isOnline = self.tableSingleData.online == 0
		self.nodeOnline:setVisible(isOnline)
		self.framehead:setTouchEnabled(true)
		self:updateInfo()
		self:updateCastleInfo()
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
		self.nodeAdding:setVisible(true)
		self.nodeHas:setVisible(false)
		self.nodeOnline:setVisible(false)
	end
end
function myTeamMember:initCastleLvStarLvNode(...)
	local node = SoraDCreatePanel("commonCastleLvStarLv")
	node:addTo(self.spriteCastle:getParent())
	node:setPosition(SoraDFPosX(435, 560), self.spriteCastle:getPositionY())
	node:setTextLvColor(self.labelCastleLv:getColor())
	self.node_lv = node
	self.spriteCastle:setVisible(false)
	self.labelCastleLv:setVisible(false)
end
function myTeamMember:updateCastleInfo()
	self.node_lv:initData(self.tableSingleData.cityLevel, self.tableSingleData.starLv)
end
function myTeamMember:setScroll(scroll)
	self.frame_rank:setScroll(scroll)
	self.framehead:setScroll(scroll)
end
function myTeamMember:setHandleBg(handle)
	self.handleBg = handle
end
function myTeamMember:btnClickHeadCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.headClick = true
		if self.handle then
			self.handle(self.tableSingleData)
		end
	end
end
function myTeamMember:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
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
return myTeamMember
