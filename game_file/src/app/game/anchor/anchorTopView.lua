local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local anchorTopView = class("anchorTopView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("anchorTopView")
	end
	return target
end)
local RW_CAMP = _G.RW_CAMP
function anchorTopView:ctor()
	self.nodeScore = SoraDGetExtendChildFromCCSByName(self, "CCS_anchorSearchBase_title")
	self.nodeScore:initInfoData(false)
	self.btnSouth = SoraDGetChildByName(self, "Button_south")
	self.btnNorth = SoraDGetChildByName(self, "Button_north")
	self.btnSouth:addTouchEventListener(handler(self, self.onClickSouth))
	self.btnNorth:addTouchEventListener(handler(self, self.onClickNorth))
end
function anchorTopView:onClickSouth(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:doTeamInfo(RW_CAMP.SOUTH_KEY)
	end
end
function anchorTopView:onClickNorth(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:doTeamInfo(RW_CAMP.NORTH_KEY)
	end
end
function anchorTopView:doTeamInfo(camp)
	local data = remainsWarCtrl:getRemainsWarCampData()
	if not data[camp] then
		local remainsWarCtrl, warData = data[camp], data[camp]
	end
	local teamId = warData.teamId
	if teamId and 0 < teamId then
		local panel = SoraDCreatePanel("teamDetailsView")
		panel:show()
		panel:initAnchorView(teamId)
	end
end
return anchorTopView
