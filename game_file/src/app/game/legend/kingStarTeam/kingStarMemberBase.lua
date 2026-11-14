local scrollNode = include("scrollNode")
local legendTeamUtil = include("legendTeamUtil")
local buildLogic = include("buildLogic")
local kingStarMemberBase = class("kingStarMemberBase", function(target)
	return target
end)
function kingStarMemberBase:ctor()
	self.iconhead = SoraDGetChildByName(self, "icon_head")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtScoreNum = SoraDGetChildByName(self, "Text_score_num")
	self.spLeader = SoraDGetChildByName(self, "Sprite_leader")
	self.spriteCastle = SoraDGetChildByName(self, "Sprite_castle")
	self.labelCastleLv = SoraDGetChildByName(self, "Text_castleLv")
	self.spriteStar = SoraDGetChildByName(self, "Sprite_star")
	self.labelStarLv = SoraDGetChildByName(self, "Text_starLv")
	self.framehead = SoraDGetChildByName(self, "frame_head")
	if self.framehead then
		self.framehead = scrollNode.new(self.framehead)
	end
	self.tableSingleData, _ENV = scrollNode.new(self.framehead), scrollNode.new(self.framehead)
	self.handle = nil
	local Node_jinnBeastLv = SoraDGetChildByName(self, "Node_jinnBeastLv")
	local obj = fgui.UIPackage:createObject("CommonUI", "Com_jinnBeastLv")
	obj:addTo(Node_jinnBeastLv, 1)
	self.Com_jinnBeastLv = obj
end
function kingStarMemberBase:initData(data)
	self.tableSingleData = data
	self:updateInfo()
end
function kingStarMemberBase:updateInfo()
	SoraDGetHeadFromManager(self.iconhead, self.tableSingleData.headid, self.tableSingleData.avatar)
	local name = legendTeamUtil.getMemberName(self.tableSingleData)
	self.txtName:setString(name)
	local strScoreNum = string.formatnumberthousands(self.tableSingleData.totalFc or 0)
	self.txtScoreNum:setString(strScoreNum)
	if self.spLeader then
		self.spLeader:setVisible(self.tableSingleData.isLeader)
	end
	self:updateCastleInfo()
	self.Com_jinnBeastLv:initData(self.tableSingleData)
end
function kingStarMemberBase:updateCastleInfo()
	self.spriteCastle:setVisible(false)
	self.labelCastleLv:setVisible(false)
	self.spriteStar:setVisible(false)
	self.labelStarLv:setVisible(false)
end
function kingStarMemberBase:setScroll(scroll)
end
function kingStarMemberBase:setHandle(handle)
	self.handle = handle
	if self.framehead then
		self.framehead:setSwallowTouches(false)
		self.framehead:addTouchEventListener(handler(self, self.btnClickHeadCallBack))
	end
end
function kingStarMemberBase:btnClickHeadCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle(self.tableSingleData)
		end
	end
end
return kingStarMemberBase
