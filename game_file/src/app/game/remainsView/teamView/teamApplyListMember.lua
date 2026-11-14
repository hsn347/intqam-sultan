local teamApplyListMember = class("teamApplyListMember", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("teamApplyListMember")
	end
	if target ~= nil then
		local timerClass = include("teamMemberBase")
		target = timerClass.new(target)
	end
	return target
end)
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function teamApplyListMember:ctor()
	self.panelBg = SoraDGetChildByName(self, "Panel_info")
end
function teamApplyListMember:initData(data)
	self.tableSingleData = data
	self:updateInfo()
	self:updateTeamFullStatus()
	if self.txtName:getContentSize().width > 154 then
		local width = self.txtName:getContentSize().width + self.spScore:getScaleX() * self.spScore:getContentSize().width / 2 + 16
		local pox = self.txtName:getPositionX() - SoraDFSign(width)
		self.spScore:setPositionX(pox)
		self.txtScoreNum:setPositionX(pox - SoraDFSign(self.spScore:getScaleX() * self.spScore:getContentSize().width / 2 + 16))
		if self.starNode then
			self.starNode:setPositionX(self.spScore:getPositionX())
		end
	end
end
function teamApplyListMember:updateTeamFullStatus()
	if self.tableSingleData.isFull then
		self.panelBg:setColor(colorGray)
	else
		self.panelBg:setColor(colorNormal)
	end
end
function teamApplyListMember:setScroll(scroll)
	self.framehead:setScroll(scroll)
end
return teamApplyListMember
