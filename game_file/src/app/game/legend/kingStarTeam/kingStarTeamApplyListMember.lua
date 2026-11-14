local kingStarTeamApplyListMember = class("kingStarTeamApplyListMember", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("kingStarTeamApplyListMember")
	end
	if target ~= nil then
		local timerClass = include("kingStarMemberBase")
		target = timerClass.new(target)
	end
	return target
end)
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function kingStarTeamApplyListMember:ctor()
	self.panelBg = SoraDGetChildByName(self, "Panel_info")
	self.spScore = SoraDGetChildByName(self, "Sprite_score")
end
function kingStarTeamApplyListMember:initData(data)
	self.tableSingleData = data
	self:updateInfo()
	self:updateTeamFullStatus()
end
function kingStarTeamApplyListMember:updateTeamFullStatus()
	if self.tableSingleData.isFull then
		self.panelBg:setColor(colorGray)
	else
		self.panelBg:setColor(colorNormal)
	end
end
function kingStarTeamApplyListMember:setScroll(scroll)
	self.framehead:setScroll(scroll)
end
return kingStarTeamApplyListMember
