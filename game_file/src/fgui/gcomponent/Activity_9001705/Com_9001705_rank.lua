local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001705_rank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001705/Com_9001705_rank", Com_9001705_rank)
function Com_9001705_rank:onInit()
	self.fields.Panel_touch:addClickListener(handler(self, self.onPanelTouchClick))
	self:fixChildrenPos()
	self.fields.Load_bg:fix()
end
function Com_9001705_rank:onShow()
end
function Com_9001705_rank:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function Com_9001705_rank:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "Com_9001705_rank" and not SoraDSearchPanelFromManagerByName("allianceInfoView") then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function Com_9001705_rank:initData(data, otheData)
	self.data = data
	local index = 0
	local rank = data.rank or 0
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
	self.fields.Text_score:setString(string.formatnumberthousands(math.floor(self.data.score)))
	if self.data.allianceFlag then
		self.fields.Com_head:setVisible(false)
		self.fields.flag:setVisible(true)
		self.fields.Panel_touch:setVisible(true)
		local flagNode = allianceDesRead.getFlagNode(self.data.allianceFlag)
		flagNode:setScale(0.4)
		flagNode:setPosition(50, 50)
		self.fields.flag:setContent(flagNode)
		_ENV = string.formatnumberthousands(math.floor(self.data.score))
		string.formatnumberthousands(math.floor(self.data.score)).abbr = self.data.allianceAbbr
		string.formatnumberthousands(math.floor(self.data.score)).name = self.data.allianceName
		self.fields.Text_name:setString(i18n("common_text_186", string.formatnumberthousands(math.floor(self.data.score))))
	else
		self.fields.Com_head:setVisible(true)
		self.fields.flag:setVisible(false)
		self.fields.Panel_touch:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.headid or data.iconID, data.avatar)
		self.fields.Com_head:setPlayerID(data.uid)
		local kid = data.kid or ""
		local nameStr = textParser.formatPlayerName(data.allianceAbbr, data.name, kid)
		self.fields.Text_name:setString(nameStr)
	end
end
function Com_9001705_rank:onPanelTouchClick()
	if self.data.aid then
		SoraDPlaySound()
		if self.data.aid then
			_ENV = nil
			;(nil).aid = self.data.aid
			_ENV, (nil).kid = self.data.kid, self.data.kid
			self.data.kid.from = "Com_9001705_rank"
			allianceQuery:reqAllianceByID(nil, self.data.kid)
		end
	end
end
return Com_9001705_rank
