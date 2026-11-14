local militaryRankRead = include("militaryRankRead")
local funUnlockRead = include("funUnlockRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_detail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_detail", Com_detail)
function Com_detail:onInit()
	self.fields.Text_LordLv:setString(i18n("common_text_4489"))
	self.fields.Text_Power:setString(i18n("common_text_090"))
	self.fields.Text_Castle:setString(i18n("common_text_4488"))
	self.fields.Button_military:addClickListener(handler(self, self.militaryClick))
	self.fields.Icon_military:fixPos()
	self.fields.Label_reddot:fixPos()
	self.fields.Text_military:fixPos()
end
function Com_detail:onShow()
end
function Com_detail:initData(tablePlayerInfo, isSelfView)
	self.tablePlayerInfo = tablePlayerInfo
	self.isSelfView = isSelfView
	self.fields.Text_lordLv_val:setString(self.tablePlayerInfo.base.level)
	self.fields.Text_power_val:setString(string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc))
	local isShow, textLv = SoraDGetBuildWarLv(self.isSelfView and SoraDGetCastleLv() or self.tablePlayerInfo.base.castlelv)
	if isShow then
		_ENV = string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc)
		string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc).lv = textLv
		if i18n("common_text_1948", string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc)) then
			goto lbl_42
		end
	end
	local castleText = textLv
	::lbl_42::
	self.fields.Text_castle_val:setString(castleText)
	if self.isSelfView and SoraDGetBuildStarLv() > 0 then
		self.controllers.c1:setSelectedIndex(1)
		_ENV = string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc)
		string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc).lv = SoraDGetBuildStarLv()
		self.fields.Text_star_val:setString(i18n("Glory_text_26", string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc)))
	elseif not self.isSelfView and self.tablePlayerInfo.base.starLv and 0 < self.tablePlayerInfo.base.starLv then
		self.controllers.c1:setSelectedIndex(1)
		_ENV = i18n("Glory_text_26", string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc))
		i18n("Glory_text_26", string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc)).lv = self.tablePlayerInfo.base.starLv
		self.fields.Text_star_val:setString(i18n("Glory_text_26", i18n("Glory_text_26", string.formatnumberthousands(self.tablePlayerInfo.fcInfo.totalFc))))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.MILITARY_RANK)
	self.isUnlockMilitary = unlockLv <= SoraDGetCastleLv()
	self.controllers.c2:setSelectedIndex(self.isUnlockMilitary and 1 or 0)
	if self.isUnlockMilitary then
		self.fields.Text_military:setString(militaryRankRead.getRankNameByLv(self.tablePlayerInfo.militaryRankInfo.level))
		self.fields.Icon_military:setIcon(militaryRankRead.getRankIconByLv(self.tablePlayerInfo.militaryRankInfo.level))
		self:setRed()
	end
end
function Com_detail:setRed()
	if self.isUnlockMilitary then
		local haveReward = not lordInfoCtrl:getLordInfo().militaryRankInfo.gotReward and lordInfoCtrl:getLordInfo().militaryRankInfo.lastRank > 0
		local ret = self.isSelfView and haveReward
		self.fields.Label_reddot:initData(ret, 0)
	end
end
function Com_detail:militaryClick()
	if self.isSelfView then
		SoraDPlaySound()
		uiManager:show("militaryRankView")
	end
end
return Com_detail
