local nebulaWarRead = include("nebulaWarRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_scheduleGroup = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaWar5/Com_scheduleGroup", Com_scheduleGroup)
function Com_scheduleGroup:onInit()
	self:addClickListener(function()
		SoraDPlaySound()
		_ENV = nil
		;(nil).groupId = self.groupId
		uiManager:show("NebulaWarCampKingdom", nil)
	end)
	if SoraDFIsRA() then
		self.fields.Load_win:setURL("title_yjyh_win.png")
	else
		self.fields.Load_win:setURL("title_yjyh_win_en.png")
	end
end
function Com_scheduleGroup:onShow()
end
function Com_scheduleGroup:initData(groupId, showRound)
	self.groupId = groupId
	local abbr = nebulaWarRead.getWarGroupAbbr(groupId)
	local name = nebulaWarRead.getWarGroupName(groupId)
	nebulaWarRead = nil
	;(nil).abbr = abbr
	;(nil).name = name
	self.fields.title:setString(i18n("common_text_186", nil))
	self:setIcon(nebulaWarRead.getWarGroupImg(groupId))
	local curRound = showRound
	if nebulaActivityCtrl:getCurRound() == showRound and (nebulaWarUtil.checkShowEnterBtn() or nebulaWarUtil.checkIsInWarReady()) then
		curRound = curRound - 1
	end
	local winCount, loseCount = nebulaWarUtil.getWinAndLoseCount(groupId, curRound)
	nebulaWarRead = nebulaWarRead.getWarGroupImg(groupId)
	nebulaWarRead.getWarGroupImg(groupId).num1 = winCount
	nebulaWarRead.getWarGroupImg(groupId).num2 = loseCount
	self.fields.Text_win:setString(i18n("nebula_war_text_0625", nebulaWarRead.getWarGroupImg(groupId)))
	local score = nebulaWarUtil.getSeasonScore(groupId, curRound)
	nebulaWarRead = i18n("nebula_war_text_0625", nebulaWarRead.getWarGroupImg(groupId))
	i18n("nebula_war_text_0625", nebulaWarRead.getWarGroupImg(groupId)).num = string.formatnumberthousands(score)
	self.fields.Text_score:setString(i18n("nebula_war_text_0504", i18n("nebula_war_text_0625", nebulaWarRead.getWarGroupImg(groupId))))
	local roundSettleData = nebulaActivityCtrl:getRoundSettleData(groupId)
	local roundData = roundSettleData[tostring(showRound)]
	if roundData and roundData.isWin then
		self.fields.Load_win:setVisible(true)
	else
		self.fields.Load_win:setVisible(false)
	end
	if roundData and roundData.isWin == false then
		self.fields.icon:setColor(cc.c3b(100, 100, 100))
	else
		self.fields.icon:setColor(cc.c3b(255, 255, 255))
	end
	if nebulaActivityCtrl:getSelfGroupId() == groupId then
		self.controllers.c_own:setSelectedIndex(1)
	else
		self.controllers.c_own:setSelectedIndex(0)
	end
end
return Com_scheduleGroup
