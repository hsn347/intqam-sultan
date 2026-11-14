local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local baseComponent = require("fgui.base.baseComponent")
local allianceActiveRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceActiveView/allianceActiveRankSingle", allianceActiveRankSingle)
function allianceActiveRankSingle:onInit()
	self.fields.Panel_touch:addClickListener(handler(self, self.onPanelTouchClick))
	self:fixChildrenPos()
	self.fields.Load_bg:fix()
end
function allianceActiveRankSingle:onShow()
end
function allianceActiveRankSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function allianceActiveRankSingle:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceActiveRankSingle" and not SoraDSearchPanelFromManagerByName("allianceInfoView") then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function allianceActiveRankSingle:initData(data, otheData)
	self.data = data
	local index = 0
	local rank = data.rank
	if rank <= RANK_TOP_SPECIAL then
		index = rank
	elseif self.data.aid and self.data.aid == allianceMgr:getOwnAid() or data.uid and data.uid == lordInfoCtrl:getLordInfo().base.uid then
		index = 4
	end
	self.controllers.c1:setSelectedIndex(index)
	if rank <= 0 then
		self.fields.Text_rank:setString(i18n("common_text_827"))
	else
		self.fields.Text_rank:setString(rank)
	end
	self.fields.Text_score:setString(string.formatnumberthousands(self.data.point))
	if self.data.flag then
		self.fields.Com_head:setVisible(false)
		self.fields.flag:setVisible(true)
		self.fields.Panel_touch:setVisible(true)
		local flagNode = allianceDesRead.getFlagNode(self.data.flag)
		flagNode:setScale(0.4)
		flagNode:setPosition(50, 50)
		self.fields.flag:setContent(flagNode)
		_ENV = string.formatnumberthousands(self.data.point)
		string.formatnumberthousands(self.data.point).abbr = self.data.allianceAbbr
		string.formatnumberthousands(self.data.point).name = self.data.allianceName
		_ENV = string.formatnumberthousands(self.data.point)
		string.formatnumberthousands(self.data.point).name = self.data.leaderName
		self.fields.Text_name:setString(i18n("common_text_186", string.formatnumberthousands(self.data.point)) .. "\n" .. i18n("common_text_926", string.formatnumberthousands(self.data.point)))
	else
		self.fields.Com_head:setVisible(true)
		self.fields.flag:setVisible(false)
		self.fields.Panel_touch:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.headid or data.iconID, data.avatar)
		self.fields.Com_head:setPlayerID(data.uid)
		self.fields.Text_name:setString(self.data.nickName)
	end
end
function allianceActiveRankSingle:onPanelTouchClick()
	if self.data.aid then
		SoraDPlaySound()
		if self.data.aid then
			_ENV = nil
			_ENV, (nil).aid = self.data.aid, self.data.aid
			self.data.aid.from = "allianceActiveRankSingle"
			allianceQuery:reqAllianceByID(nil, self.data.aid)
			SoraDShowLoading(self)
		end
	end
end
return allianceActiveRankSingle
