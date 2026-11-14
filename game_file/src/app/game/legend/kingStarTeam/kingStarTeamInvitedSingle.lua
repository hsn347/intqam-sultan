local legendTeamDef = include("legendTeamDef")
local scrollNode = include("scrollNode")
local kingStarTeamInvitedSingle = class("kingStarTeamInvitedSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingStarTeamInvitedSingle")
	end
	return target
end)
function kingStarTeamInvitedSingle:ctor()
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.ccs_head:setScale(1.0)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_text = SoraDGetChildByName(self, "Text_text")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Button_yes = SoraDGetChildByName(self, "Button_yes")
	self.Button_yes = scrollNode.new(self.Button_yes)
	self.Button_yes:setSwallowTouches(false)
	self.Button_yes:addTouchEventListener(handler(self, self.onYesClick))
	self.Button_no = SoraDGetChildByName(self, "Button_no")
	self.Button_no = scrollNode.new(self.Button_no)
	self.Button_no:setSwallowTouches(false)
	self.Button_no:addTouchEventListener(handler(self, self.onNoClick))
end
function kingStarTeamInvitedSingle:initData(data, otherData)
	self.data = data
	self.Button_yes:setScroll(otherData.scroll)
	self.Button_no:setScroll(otherData.scroll)
	self.ccs_head:setHeadSprite(self.data.iconID, self.data.avatar)
	self.ccs_head:setPlayerID(self.data.uid)
	self.ccs_head:setTouchEnabled(false)
	local name = data.nickname
	local teamAbbr = data.teamAbbr
	if teamAbbr ~= nil and string.len(teamAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = teamAbbr
		;(nil).name = name
		name = i18n("common_text_186", nil)
	end
	if data.kid then
		name = name .. "#" .. tostring(data.kid)
	end
	self.Text_name:setString(name)
	local strScoreNum = string.formatnumberthousands(data.totalFc or 0)
	_ENV = nil
	;(nil).power = strScoreNum
	self.Text_text:setString(i18n("common_text_1418", nil))
	_ENV = i18n("common_text_1418", nil)
	i18n("common_text_1418", nil).member = data.memberCount or 1
	i18n("common_text_1418", nil).total = legendTeamDef.TEAM_MEMBER_MAX
	self.Text_num:setString(i18n("common_text_155", i18n("common_text_1418", nil)))
	local tiemTab = os.date("*t", self.data.time)
	local str_date = string.format("%.4d-%.2d-%.2d", tiemTab.year, tiemTab.month, tiemTab.day)
	self.Text_time:setString(str_date)
	self.handlerInvite = otherData.handlerInvite
end
function kingStarTeamInvitedSingle:onYesClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handlerInvite then
			self.handlerInvite(true, self.data)
		end
	end
end
function kingStarTeamInvitedSingle:onNoClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handlerInvite then
			self.handlerInvite(false, self.data)
		end
	end
end
return kingStarTeamInvitedSingle
