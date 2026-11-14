local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local mailFunctions = include("mailFunctions")
local militaryRankRead = include("militaryRankRead")
local hegemonRead = include("hegemonRead")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Legends = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_Legends", Com_Legends)
function Com_Legends:onInit()
	_UPVALUE7_ = nil
	;(nil)[1] = "txt_name"
	;(nil)[2] = "txt_power"
	;(nil)[3] = "n27"
	;(nil)[4] = "Com_head"
	;(nil)[5] = "txt_kill_num"
	;(nil)[6] = "txt_execute_num"
	;(nil)[7] = "Image_military"
	for index, value in ipairs(nil) do
		self.fields[value]:fixPos()
	end
	self.fields.txt_ach_title:setString(i18n("history_title_01"))
	self.fields.txt_des_title:setString(i18n("history_title_02"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Com_head:setHandle(handler(self, self.onClick_btnPlayer))
end
function Com_Legends:onShow()
end
function Com_Legends:initData(serverData)
	self.serverData = serverData
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
	if not self.serverData.userInfo.history then
		mailFunctions = self.serverData.userInfo.history
	end
	self.history = self.serverData.userInfo.history
	self.fields.List:setNumItems(#self.history)
	self.fields.List:resizeToFit(#self.history)
	self:updateDes()
	local chatFunctions = include("chatFunctions")
	local selfId = chatFunctions:getSelfId()
	local isSelf = selfId == self.serverData.uid
end
function Com_Legends:updateDes()
	local strTip = legendMDesRead.getKingDes(self.serverData)
	self.fields.text_des:setString(strTip)
end
function Com_Legends:onItemRederer(index, target)
	target:setString(self:getStrTip(self.history[index + 1]))
end
function Com_Legends:getStrTip(serverData)
	if serverData then
		local strTip
		local strYear = legendMCtrl:getHistoryYearFull(serverData.time)
		local setType = serverData.setType
		if setType == gKingBiographyType.king then
			legendMCtrl = nil
			;(nil).time = strYear
			;(nil).num = serverData.term
			strTip = i18n("history_text_09", nil)
		elseif setType == gKingBiographyType.legend then
			legendMCtrl = nil
			;(nil).time = strYear
			;(nil).num = serverData.term
			strTip = i18n("history_text_07", nil)
		elseif setType == gKingBiographyType.starking then
			if serverData.activityId then
				legendMCtrl = serverData.activityId
				legendMCtrl = nil
				;(nil).time = strYear
				;(nil).num = serverData.term
				serverData.activityId[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("kingstarbattle_text_81", nil)
				legendMCtrl = nil
				;(nil).time = strYear
				;(nil).num = serverData.term
				;(nil).ranklist = i18n("remains_name_01")
				serverData.activityId[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text12", nil)
				legendMCtrl = nil
				;(nil).time = strYear
				;(nil).num = serverData.term
				;(nil).ranklist = i18n("king_star_rank_text3")
				local serverData.activityId[gActivityTimeActivityID.LEGEND_LORD_9001647], tipCfg = i18n("king_star_rank_text12", nil), serverData.activityId
				strTip = tipCfg[serverData.activityId]
			else
				legendMCtrl = i18n("king_star_rank_text12", nil)
				i18n("king_star_rank_text12", nil).time = strYear
				i18n("king_star_rank_text12", nil).num = serverData.term
				strTip = i18n("kingstarbattle_text_81", (i18n("king_star_rank_text12", nil)))
			end
		elseif serverData.setType >= gKingBiographyType.hegemon1 and serverData.setType <= gKingBiographyType.hegemon6 then
			local buildTypeID = legendMCtrl:getHegemonBuildIdBySetType(serverData.setType)
			local buildName = hegemonRead.getName(buildTypeID)
			legendMCtrl = nil
			;(nil).time = strYear
			;(nil).name = buildName
			;(nil).num = serverData.term
			strTip = i18n("history_text_08", nil)
		end
		return strTip
	end
	return "undefined"
end
function Com_Legends:onClick_btnPlayer()
	SoraDPlaySound()
	_ENV = nil
	;(nil).uid = self.serverData.uid
	;(nil).sourceKid = self.serverData.sourceKid
	self:queryPlayerInfo(nil)
end
function Com_Legends:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		if playerID == 0 then
			return
		end
		local kid = data.sourceKid
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading()
	end
end
return Com_Legends
