local mailFunctions = include("mailFunctions")
local militaryRankRead = include("militaryRankRead")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_KingSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_KingSingle", Com_KingSingle)
function Com_KingSingle:onInit()
	self.fields.Com_head:setHandle(handler(self, self.onClick_btnInfo))
	self.fields.Button_Q:addClickListener(handler(self, self.onClick_btnInfo))
end
function Com_KingSingle:onShow()
end
function Com_KingSingle:initData(data)
	self.data = data
	self.serverData = data.data
	local strName = mailFunctions:getWrappedName(self.serverData.userInfo.allianceAbbr, self.serverData.userInfo.nickName, self.serverData.sourceKid)
	local strYear = SoraDConvertTimeToYear(self.serverData.assumeTime)
	if self.serverData.setType == gKingBiographyType.king then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.txt_title:setString(i18n("history_title_04"))
		self.fields.txt_time:setString(strYear)
	else
		self.controllers.c1:setSelectedIndex(1)
		local title
		local round = self.serverData.round
		if self.serverData.setType == gKingBiographyType.legend then
			mailFunctions = i18n("history_title_04")
			i18n("history_title_04").num = round
			title = i18n("history_text_38", i18n("history_title_04"))
		elseif self.serverData.setType == gKingBiographyType.starking then
			if self.serverData.activityId then
				mailFunctions = self.serverData.activityId
				mailFunctions = i18n("history_title_04")
				i18n("history_title_04").num = round
				self.serverData.activityId[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("kingstarbattle_text_84", i18n("history_title_04"))
				mailFunctions = i18n("history_title_04")
				i18n("history_title_04").num = round
				i18n("history_title_04").ranklist = i18n("remains_name_01")
				self.serverData.activityId[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text11", i18n("history_title_04"))
				mailFunctions = i18n("history_title_04")
				i18n("history_title_04").num = round
				i18n("history_title_04").ranklist = i18n("king_star_rank_text3")
				local self.serverData.activityId[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text11", i18n("history_title_04")), self.serverData.activityId
				title = titleCfg[self.serverData.activityId]
			else
				mailFunctions = i18n("king_star_rank_text11", i18n("history_title_04"))
				i18n("king_star_rank_text11", i18n("history_title_04")).num = round
				title = i18n("kingstarbattle_text_84", (i18n("king_star_rank_text11", i18n("history_title_04"))))
			end
		elseif self.serverData.setType >= gKingBiographyType.hegemon1 and self.serverData.setType <= gKingBiographyType.hegemon6 then
			local hegemonRead = include("hegemonRead")
			local buildTypeID = self.serverData.setType - 3 + 601
			local buildName = hegemonRead.getName(buildTypeID)
			mailFunctions = i18n("king_star_rank_text3")
			i18n("king_star_rank_text3").num = round
			i18n("king_star_rank_text3").name = buildName
			title = i18n("history_text_39", (i18n("king_star_rank_text3")))
		end
		self.fields.txt_title:setString(title)
		self.fields.txt_time:setString(strYear)
	end
	self.fields.txt_name:setString(strName)
	self.fields.Image_military:setURL(militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank))
	mailFunctions = militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank)
	militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank).count = string.formatnumberthousands(self.serverData.userInfo.totalFc)
	self.fields.txt_power:setString(i18n("common_text_555", militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank)))
	self.fields.Com_head:setHeadSprite(self.serverData.userInfo.iconId, self.serverData.userInfo.avatar)
	mailFunctions = i18n("common_text_555", militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank))
	i18n("common_text_555", militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank)).kills = string.formatnumberthousands(self.serverData.userInfo.killCount)
	self.fields.txt_kill_num:setString(i18n("common_text_344", i18n("common_text_555", militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank))))
	mailFunctions = i18n("common_text_344", i18n("common_text_555", militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank)))
	i18n("common_text_344", i18n("common_text_555", militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank))).num = string.formatnumberthousands(self.serverData.userInfo.killHeroCount)
	self.fields.txt_execute_num:setString(i18n("prison_text_22", i18n("common_text_344", i18n("common_text_555", militaryRankRead.getRankIconByLv(self.serverData.userInfo.militaryRank)))))
	local hegemonNum, kingNum, legendNum = self.serverData.userInfo.hegemonNum or 0, self.serverData.userInfo.kingNum or 0, self.serverData.userInfo.legendNum or 0
	self.fields.Official_1:setVisible(false)
	self.fields.Official_2:setVisible(false)
	self.fields.Official_3:setVisible(false)
	if 0 < legendNum then
		self.fields.Official_1:setVisible(true)
		local iconName = "icon_legendary_01.png"
		self.fields.Official_1:setIcon(iconName)
		self.fields.Official_1:setText(SoraDFValueSuit("X", legendNum))
	end
	if 0 < hegemonNum then
		self.fields.Official_2:setVisible(true)
		local iconName = "icon_bazhuzhizhan_01.png"
		self.fields.Official_2:setIcon(iconName)
		self.fields.Official_2:setText(SoraDFValueSuit("X", hegemonNum))
	end
	if 0 < kingNum then
		self.fields.Official_3:setVisible(true)
		local iconName = "icon_king.png"
		self.fields.Official_3:setIcon(iconName)
		self.fields.Official_3:setText(SoraDFValueSuit("X", kingNum))
	end
end
function Com_KingSingle:onClick_btnInfo()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDM_LOADPAGE"
	;(nil).pageType = legendMDesRead.PageType.KINGDETAIL
	;(nil).pageData = self.data
	SoraDSendMessage(nil)
end
return Com_KingSingle
