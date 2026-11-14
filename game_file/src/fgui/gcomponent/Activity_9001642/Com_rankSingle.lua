local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001642/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
	self.fields.Load_bg:fix()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, rank, tag)
	local index = 0
	local selfIndex = 0
	self.data = data
	self.tag = tag
	if rank == 0 then
		self.fields.Text_rank:setString(i18n("common_text_827"))
	elseif rank <= RANK_TOP_SPECIAL then
		index = rank
	else
		self.fields.Text_rank:setString(rank)
		selfIndex = data.uid == SoraDGetPlayerID() and 1 or 0
	end
	self.controllers.c1:setSelectedIndex(index)
	self.controllers.c3:setSelectedIndex(selfIndex)
	if tag == 1 then
		self.fields.Com_head:setVisible(false)
		self.fields.flag:setVisible(true)
		local flagNode = include("allianceDesRead").getFlagNode(data.flag)
		flagNode:setScale(0.48)
		flagNode:setPosition(50, 50)
		self.fields.flag:clearContent()
		self.fields.flag:setContent(flagNode)
		if data.aid and 0 < data.aid then
			_ENV = i18n("common_text_827")
			i18n("common_text_827").abbr = data.abbr
			i18n("common_text_827").name = data.name
			self.fields.Text_name:setString(i18n("common_text_186", i18n("common_text_827")))
		else
			self.fields.Text_name:setString(i18n("activity_hjyt_noUnion_name"))
		end
		self.fields.Text_score:setString(string.formatnumberthousands(data.score))
	else
		self.fields.Com_head:setVisible(true)
		self.fields.flag:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.Com_head:setPlayerID(data.uid)
		self.fields.Com_head:setKid(data.kid)
		self.fields.Text_name:setString(textParser.formatPlayerName(data.allianceAbbr, data.name))
		self.fields.Text_score:setString(string.formatnumberthousands(data.score))
	end
end
function Com_rankSingle:btnClick()
	SoraDPlaySound()
	if self.tag == 1 then
		local allianceQuery = SoraDGetCtrl("allianceQuery")
		_ENV = nil
		_ENV, (nil).aid = self.data.aid, self.data.aid
		self.data.aid.from = "Activity_9001642_Rank"
		allianceQuery:reqAllianceByID(nil, self.data.aid)
	else
		_ENV = allianceQuery.reqAllianceByID
		allianceQuery.reqAllianceByID.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		allianceQuery.reqAllianceByID.playerID = self.data.uid
		allianceQuery.reqAllianceByID.kid = self.data.kid
		SoraDSendMessage(allianceQuery.reqAllianceByID)
	end
end
return Com_rankSingle
