local scrollNode = include("scrollNode")
local legendTeamUtil = include("legendTeamUtil")
local kingStarTeamChangeLeaderSingle = class("kingStarTeamChangeLeaderSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingStarTeamChangeLeaderSingle")
	end
	return target
end)
function kingStarTeamChangeLeaderSingle:ctor()
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.ccs_head:setScale(1.0)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_text = SoraDGetChildByName(self, "Text_text")
	SoraDSetTextWidthHeight(self.Text_text, cc.size(250, self.Text_text:getContentSize().height))
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.btnChange = scrollNode.new(self.btnChange)
	self.btnChange:setTitleText(i18n("free_team_text_50"))
	self.btnChange:setSwallowTouches(false)
	self.btnChange:addTouchEventListener(handler(self, self.onChangeClick))
	SoraDAutoSizeButtonTextByContent(self.btnChange)
end
function kingStarTeamChangeLeaderSingle:initData(data, otherData)
	self.data = data
	self.ccs_head:setHeadSprite(self.data.headid, self.data.avatar)
	self.ccs_head:setPlayerID(self.data.uid)
	self.ccs_head:setTouchEnabled(false)
	local name = legendTeamUtil.getMemberName(self.data)
	self.Text_name:setString(name)
	local strScoreNum = string.formatnumberthousands(data.totalFc or 0)
	legendTeamUtil = nil
	;(nil).power = strScoreNum
	self.Text_text:setString(i18n("common_text_1418", nil))
	self.handlerChange = otherData.handlerChange
	self.btnChange:setScroll(otherData.scroll)
end
function kingStarTeamChangeLeaderSingle:onChangeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handlerChange then
			self.handlerChange(self.data)
		end
	end
end
return kingStarTeamChangeLeaderSingle
