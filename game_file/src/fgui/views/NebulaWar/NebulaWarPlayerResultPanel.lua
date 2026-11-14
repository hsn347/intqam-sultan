local lordLocalData = include("lordLocalData")
local nebulaWarRead = include("nebulaWarRead")
local nebulaWarUtil = include("nebulaWarUtil")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarPlayerResultPanel = class("NebulaWarPlayerResultPanel", baseFguiPanel)
function NebulaWarPlayerResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarPlayerResultPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.isHidePrePanel = true
end
function NebulaWarPlayerResultPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaCompetition"
	end
	return self._packageList
end
function NebulaWarPlayerResultPanel:onInit()
	print("=======NebulaWarPlayerResultPanel:onInit")
	if not self.proxy.param.notifyData then
		_ENV = self.proxy.param.notifyData
	end
	self.notifyData = self.proxy.param.notifyData
	self.fields.Usm_bg:setMaxChunkSize(182784)
	self.fields.Text_close:setString(i18n("mail_2_text_12"))
	self.fieldsVs = fguiHelper.get_fields(self.fields.Com_vsInfo)
	_UPVALUE1_ = i18n("mail_2_text_12")
	i18n("mail_2_text_12")[1] = ffa.delay(1.5)
	i18n("mail_2_text_12")[2] = ffa.callFunc(function()
		self.fields.Node_content:setVisible(true)
		self:initView()
	end)
	i18n("mail_2_text_12")[3] = ffa.callFunc(function()
		self.fields.Node_content:setVisible(true)
		self:initView()
	end)
	self:runAction(ffa.seq(i18n("mail_2_text_12")))
	if not SoraDFIsRA() then
		self.fields.Usm_effect:fix()
		self.fields.Com_player1:fixPos()
		self.fields.Com_player2:fixPos()
		self.fields.Com_vsInfo:fixChildrenPos()
	end
end
function NebulaWarPlayerResultPanel:initView(...)
	self:showPlayerView()
end
function NebulaWarPlayerResultPanel:onShow()
	print("=======NebulaWarPlayerResultPanel:onShow")
end
function NebulaWarPlayerResultPanel:showPlayerView(...)
	local selfCamp = nebulaWarUtil.getOutWarSelfCamp()
	local enemyCamp = NEBULA_WAR_CAMP.SOUTH + NEBULA_WAR_CAMP.NORTH - selfCamp
	local campInfo = self.notifyData.campInfo
	for __, v in pairs(campInfo) do
		v.score = math.floor(v.score or 0)
	end
	local isSelfWin = campInfo[selfCamp].isWin
	if SoraDFIsRA() then
		if isSelfWin then
			self.fields.Load_win:setURL("title_yjyh_win.png")
		else
			self.fields.Load_win:setURL("title_yjyh_lose.png")
		end
	elseif isSelfWin then
		self.fields.Load_win:setURL("title_yjyh_win_en.png")
	else
		self.fields.Load_win:setURL("title_yjyh_lose_en.png")
	end
	local campInfo1 = campInfo[selfCamp]
	local campInfo2 = campInfo[enemyCamp]
	self:updatePlayer(self.fields.Com_player1, campInfo1)
	self:updatePlayer(self.fields.Com_player2, campInfo2)
	self.fieldsVs.Text_score1:setString(string.formatnumberthousands(campInfo1.score))
	self.fieldsVs.Text_score2:setString(string.formatnumberthousands(campInfo2.score))
	local percent = 50
	if campInfo1.score + campInfo2.score ~= 0 then
		percent = campInfo1.score / (campInfo1.score + campInfo2.score) * 100
	end
	self.fieldsVs.bar:initData(percent / 100)
	self:initGroupItem(campInfo1.groupId, 1)
	self:initGroupItem(campInfo2.groupId, 2)
	local winCamp = isSelfWin and selfCamp or enemyCamp
	local loseCamp = isSelfWin and enemyCamp or selfCamp
	local winInfo = campInfo[winCamp]
	local loseInfo = campInfo[loseCamp]
	local winCampName = nebulaWarRead.getWarGroupName(winInfo.groupId)
	local loseCampName = nebulaWarRead.getWarGroupName(loseInfo.groupId)
	local winScore, loseScore = nebulaWarUtil.getAddSeasonScore(winInfo.score, loseInfo.score)
	nebulaWarUtil = string.formatnumberthousands(campInfo2.score)
	string.formatnumberthousands(campInfo2.score).camp1 = winCampName
	local desStr = i18n("nebula_war_text_0546", string.formatnumberthousands(campInfo2.score))
	nebulaWarUtil = string.formatnumberthousands(campInfo2.score)
	string.formatnumberthousands(campInfo2.score).num1 = string.formatnumberthousands(winScore)
	desStr = desStr .. "," .. i18n("nebula_war_text_0563", string.formatnumberthousands(campInfo2.score))
	if winInfo.nickName then
		nebulaWarUtil = string.formatnumberthousands(campInfo2.score)
		string.formatnumberthousands(campInfo2.score).name1 = winInfo.nickName
		string.formatnumberthousands(campInfo2.score).camp1 = winCampName
		desStr = desStr .. "," .. i18n("nebula_war_text_0564", string.formatnumberthousands(campInfo2.score))
	end
	nebulaWarUtil = winInfo.nickName
	winInfo.nickName.num1 = string.formatnumberthousands(loseScore)
	desStr = desStr .. ".\n" .. loseCampName .. i18n("nebula_war_text_0563", winInfo.nickName)
	if loseInfo.nickName then
		nebulaWarUtil = "nebula_war_text_0563"
		;("nebula_war_text_0563").name1 = loseInfo.nickName
		;("nebula_war_text_0563").camp1 = loseCampName
		desStr = desStr .. "," .. i18n("nebula_war_text_0564", "nebula_war_text_0563")
	end
	desStr = desStr .. "."
	self.fields.Text_des:setString(desStr)
end
function NebulaWarPlayerResultPanel:updatePlayer(obj, data)
	if data and data.uid then
		local fieldsCom = fguiHelper.get_fields(obj)
		fieldsCom.icon:setURL(lordLocalData.getPortrait(data.headid))
		fieldsCom.Text_name:setString(data.nickName .. "#" .. data.kid)
		_ENV = data.kid
		data.kid.abbr = data.teamAbbr
		data.kid.name = data.teamName
		fieldsCom.Text_team:setString(i18n("common_text_186", data.kid))
	else
		obj:setVisible(false)
	end
end
function NebulaWarPlayerResultPanel:initGroupItem(groupId, index)
	local Com_group = self.fieldsVs["Com_group" .. index]
	local abbr = nebulaWarRead.getWarGroupAbbr(groupId)
	local name = nebulaWarRead.getWarGroupName(groupId)
	nebulaWarRead = nil
	;(nil).abbr = abbr
	;(nil).name = name
	Com_group:setString(i18n("common_text_186", nil))
	Com_group:setIcon(nebulaWarRead.getWarGroupIcon(groupId))
end
function NebulaWarPlayerResultPanel:onHide(...)
	if worldMapDefine.isInNebula() then
		nebulaActivityCtrl:resetNebulaWarEnd()
	end
end
function NebulaWarPlayerResultPanel:close(...)
	self:closePanel()
	if not worldMapDefine.isInNebula() then
		_G.SoraDQuickLogin()
	end
end
function NebulaWarPlayerResultPanel:initTestData(...)
	_UPVALUE0_ = nil
	_UPVALUE0_, _UPVALUE0_, (nil).round = nil, nil, 2
	;(nil).groupId = 1
	;(nil).isWin = true
	;(nil).score = 17373
	;(nil).headid = 1403
	;(nil).avatar = ""
	;(nil).kid = 1
	;(nil).nickName = "zw7"
	;(nil).teamAbbr = "ddd"
	;(nil).teamName = "ddddd"
	_UPVALUE0_, (nil)[1], (nil).uid = nil, nil, 7
	;(nil).groupId = 2
	;(nil).isWin = false
	;(nil).campInfo, (nil)[2], (nil).score = nil, nil, 0
	local notifyData
	_UPVALUE0_ = nil
	self.proxy.param, (nil).notifyData = nil, notifyData
end
return NebulaWarPlayerResultPanel
