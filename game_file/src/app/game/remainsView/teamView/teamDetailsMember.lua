local scrollNode = include("scrollNode")
local teamDetailsMember = class("teamDetailsMember", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("teamDetailsMember")
	end
	if target ~= nil then
		local timerClass = include("teamMemberBase")
		target = timerClass.new(target)
	end
	return target
end)
function teamDetailsMember:ctor()
	self.frame_rank = SoraDGetChildByName(self, "Panel_info")
	if self.frame_rank then
		self.frame_rank:setTouchEnabled(true)
		self.frame_rank:setSwallowTouches(false)
		self.frame_rank = scrollNode.new(self.frame_rank)
		self.frame_rank:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function teamDetailsMember:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		local data = self.tableSingleData
		if data and data.uid and data.army and next(data.army) then
			SoraDPlaySound()
			local panel = SoraDCreatePanel("teamMemberArmyView")
			panel:show()
			panel:initAnchorView(data)
		end
	end
end
return teamDetailsMember
