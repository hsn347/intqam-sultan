local remainsWarRead = include("remainsWarRead")
local remainsWarltCtrl = include("remainsWarltCtrl")
local remainsWarRankHistorySeasonSingle = class("remainsWarRankHistorySeasonSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarRankHistorySeasonSingle")
	end
	return target
end)
function remainsWarRankHistorySeasonSingle:ctor()
	self.spScoreTitle = SoraDGetChildByName(self, "Sprite_score_title")
	if not IsArClient then
		self.txtScoreTitle = SoraDChangeDanToText(self.spScoreTitle)
	end
	self.spDanBg = SoraDGetChildByName(self, "Sprite_dan_bg")
	self.txtSeasonTitle = SoraDGetChildByName(self, "Text_name")
	self.bg = SoraDGetChildByName(self, "frame_rank_bg")
	self.bg:setFillType(1)
	self.btn_share = SoraDGetChildByName(self, "btn_share")
	self.btn_share:setSwallowTouches(false)
	self.btn_share = SoraDCreatePanelByCloneNode(self.btn_share, "commonBtnInstance")
	self.btn_share:setHandle(handler(self, self.onClick_btn_share))
	self.tableSingleData, _ENV = self.btn_share.setHandle, self.btn_share.setHandle
	self:initTitleItem()
end
function remainsWarRankHistorySeasonSingle:initData(data)
	self.tableSingleData = data
	self:updateSeasenStatus()
	self:updateScoreStatus()
	self:updateInfo()
end
function remainsWarRankHistorySeasonSingle:updateScoreStatus()
	local danID = self.tableSingleData.segment or 1
	if IsArClient then
		local strTitleName = remainsWarRead.getDanNameIcon(danID)
		self.spScoreTitle:setSpriteFrame(strTitleName)
	else
		local strTitle = remainsWarRead.getDanName(danID)
		self.txtScoreTitle:setString(strTitle)
		local color = remainsWarRead.getDanColor(danID)
		self.txtScoreTitle:setColor(color)
	end
	local imageDan = remainsWarRead.getDanBgImage(danID)
	self.spDanBg:setSpriteFrame(imageDan)
	local startNode = SoraDGetRemainsWarStartNode(self.tableSingleData.star or 0)
	startNode:addTo(self.spDanBg:getParent())
	startNode:setPosition(-2, -80)
end
function remainsWarRankHistorySeasonSingle:updateSeasenStatus()
	local round = self.tableSingleData.season or 1
	local gametop = gModuleMgr.getObject("gametop")
	local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
	local curRound = remainsTeamCtrl:getActivitySeasonRound()
	_ENV = nil
	;(nil).num = round
	local strTitle = i18n("remains_text_02", nil)
	if round == curRound then
		strTitle = strTitle .. i18n("remains_text_196")
	end
	local beginTime = self.tableSingleData.activeTime or 0
	local endTime = self.tableSingleData.finishTime or 0
	local beginTimeStr = os.date("!%Y.%m.%d", beginTime)
	local endTimeStr = os.date("!%Y.%m.%d", endTime)
	local timeStr = " " .. beginTimeStr .. " - " .. endTimeStr
	strTitle = strTitle .. timeStr
	self.txtSeasonTitle:setString(strTitle)
end
function remainsWarRankHistorySeasonSingle:updateInfo()
	local battleTimes = self.tableSingleData.battleTimes or 0
	if battleTimes < 0 then
		battleTimes = 0
	end
	do
		local txtNum = SoraDGetChildByName(self, "Text_score_num")
		local gradePoints = self.tableSingleData.totalGradePoints or 0
		local alreadyBattleTimes = self.tableSingleData.alreadyBattleTimes or 0
		local realBattleTimes = battleTimes - alreadyBattleTimes
		local points = 0
		if 0 < realBattleTimes then
			points = math.ceil(gradePoints / realBattleTimes)
		end
		local strArmyNum = string.formatnumberthousands(points or 0)
		_ENV = nil
		;(nil).num = strArmyNum or 0
		txtNum:setString(i18n("remains_text_188", nil))
		local score = remainsWarltCtrl.getRuinsWarGrade(points)
		local strScore = remainsWarRead.getScoreName(score)
		local txtScoreFont = SoraDGetChildByName(self, "Text_score_font")
		txtScoreFont:setString(strScore)
	end
	do
		local txtNum = SoraDGetChildByName(self, "Text_battle_times")
		_ENV = string.formatnumberthousands(points or 0)
		string.formatnumberthousands(points or 0).num = battleTimes
		txtNum:setString(i18n("remains_text_189", (string.formatnumberthousands(points or 0))))
	end
	do
		local txtNum = SoraDGetChildByName(self, "Text_win_times")
		_ENV = i18n("remains_text_189", (string.formatnumberthousands(points or 0)))
		i18n("remains_text_189", (string.formatnumberthousands(points or 0))).num = self.tableSingleData.winTimes or 0
		txtNum:setString(i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0)))))
	end
	do
		local txtNum = SoraDGetChildByName(self, "Text_win_percent")
		local winTimes = self.tableSingleData.winTimes or 0
		local percent = "0.00"
		if 0 < battleTimes then
			percent = string.format("%.2f%%", winTimes * 100 / battleTimes)
		end
		_ENV = i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0))))
		i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0)))).num = percent
		txtNum:setString(i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0))))))
	end
	do
		local txtNum = SoraDGetChildByName(self, "Text_mvp_times")
		_ENV = i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0)))))
		i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0))))).num = self.tableSingleData.mvpTimes or 0
		txtNum:setString(i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0)))))))
	end
	do
		local txtNum = SoraDGetChildByName(self, "Text_atkwin_num")
		local strArmyNum = string.formatnumberthousands(self.tableSingleData.atkCityWinNum or 0)
		_ENV = i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0))))))
		i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0)))))).num = strArmyNum
		txtNum:setString(i18n("remains_text_193", i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0))))))))
	end
	do
		local txtNum = SoraDGetChildByName(self, "Text_killnpc_num")
		local strArmyNum = string.formatnumberthousands(self.tableSingleData.killNpcNum or 0)
		_ENV = i18n("remains_text_193", i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0)))))))
		i18n("remains_text_193", i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0))))))).num = strArmyNum
		txtNum:setString(i18n("remains_text_194", i18n("remains_text_193", i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0)))))))))
	end
	do
		local txtArmyNum = SoraDGetChildByName(self, "Text_killarmy_num")
		local strArmyNum = string.formatnumberthousands(self.tableSingleData.killArmyFc or 0)
		_ENV = i18n("remains_text_194", i18n("remains_text_193", i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0))))))))
		i18n("remains_text_194", i18n("remains_text_193", i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0)))))))).num = strArmyNum
		txtArmyNum:setString(i18n("remains_text_195", i18n("remains_text_194", i18n("remains_text_193", i18n("remains_text_192", i18n("remains_text_191", i18n("remains_text_190", i18n("remains_text_189", (string.formatnumberthousands(points or 0))))))))))
		SoraDSetTextWidthHeight(txtArmyNum, cc.size(180, 42))
	end
	if not self.tableSingleData.title then
		local _ENV, title = self.tableSingleData.title, self.tableSingleData.title
	end
	for i = 1, 5 do
		self.itemList[i].Text_num:setString(title[tostring(i)] or 0)
	end
end
function remainsWarRankHistorySeasonSingle:onClick_btn_share(sender, event)
	local panel = SoraDCreatePanel("remainsWarHistoryShareBox")
	panel:init(self.tableSingleData)
	panel:show()
end
function remainsWarRankHistorySeasonSingle:initTitleItem(...)
	self.Node_bottom = SoraDGetChildByName(self, "Node_bottom")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Node_item:setVisible(false)
	self.itemList, _ENV = self.Node_item.setVisible, self.Node_item.setVisible
	for i = 1, 5 do
		local item = self.Node_item:clone()
		item:addTo(self.Node_bottom)
		item:setVisible(true)
		item:setPosition(SoraDFSign(106 * (3 - i)), -40)
		self.itemList[i] = item
		SoraDGetChildByName(item, "Sprite_icon"):setSpriteFrame(remainsWarRead.getRuinsTitleIcon(i))
		item.Text_num = SoraDGetChildByName(item, "Text_num")
		local Button_click = SoraDGetChildByName(item, "Button_click")
		Button_click:setSwallowTouches(false)
		Button_click:setTag(i)
		Button_click = SoraDCreatePanelByCloneNode(Button_click, "commonBtnInstance")
		Button_click:setLongHandle(handler(self, self.onBtnClick))
	end
end
function remainsWarRankHistorySeasonSingle:onBtnClick(button, event)
	if not button.pFloor then
		local tips = SoraDCreatePanel("commonItemTips")
		tips:addTo(self.Node_bottom)
		tips:setPosition(SoraDFSign(140), 140)
		local titleType = button:getTag()
		tips:customName(remainsWarRead.getRuinsTitleName(titleType))
		tips:customDes(remainsWarRead.getRuinsTitleDes(titleType))
		button.pFloor = tips
	end
	button.pFloor:setVisible(true)
end
return remainsWarRankHistorySeasonSingle
