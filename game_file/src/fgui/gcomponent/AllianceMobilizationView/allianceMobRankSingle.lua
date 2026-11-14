local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceMobRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMobilizationView/allianceMobRankSingle", allianceMobRankSingle)
function allianceMobRankSingle:onInit()
	self.fields.Panel_touch:addClickListener(handler(self, self.onPanelTouchClick))
	self:fixChildrenPos()
	self.fields.Load_bg:fix()
end
function allianceMobRankSingle:onShow()
end
function allianceMobRankSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function allianceMobRankSingle:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceMobRankSingle" and not SoraDSearchPanelFromManagerByName("allianceInfoView") then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function allianceMobRankSingle:initData(data, otheData)
	self.data = data
	local index = 0
	local rank = self.data.rank
	if rank <= RANK_TOP_SPECIAL then
		index = rank
	elseif self.data.aid and self.data.aid == allianceMgr:getOwnAid() or self.data.uid and self.data.uid == lordInfoCtrl:getLordInfo().base.uid then
		index = 4
	end
	self.controllers.c1:setSelectedIndex(index)
	if rank <= 0 then
		self.fields.Text_rank:setString(i18n("common_text_3575"))
	else
		self.fields.Text_rank:setString(rank)
	end
	self.fields.Text_score:setString(string.formatnumberthousands(self.data.score))
	if self.data.aid then
		self.fields.Com_head:setVisible(false)
		self.fields.flag:setVisible(true)
		self.fields.Sprite_rank:setVisible(false)
		self.fields.Panel_touch:setVisible(true)
		local flagNode = allianceDesRead.getFlagNode(self.data.aInfo.allianceFlag)
		flagNode:setScale(0.4)
		flagNode:setPosition(50, 50)
		self.fields.flag:setContent(flagNode)
		_ENV = string.formatnumberthousands(self.data.score)
		string.formatnumberthousands(self.data.score).abbr = self.data.aInfo.allianceAbbr
		string.formatnumberthousands(self.data.score).name = self.data.aInfo.allianceName
		_ENV = string.formatnumberthousands(self.data.score)
		string.formatnumberthousands(self.data.score).name = self.data.leadername
		self.fields.Text_name:setString(i18n("common_text_186", string.formatnumberthousands(self.data.score)) .. "\n" .. i18n("common_text_926", string.formatnumberthousands(self.data.score)))
	else
		self.fields.Com_head:setVisible(true)
		self.fields.flag:setVisible(false)
		self.fields.Sprite_rank:setVisible(true)
		self.fields.Panel_touch:setVisible(false)
		self.fields.Com_head:setHeadSprite(self.data.uInfo.headid, self.data.uInfo.avatar)
		self.fields.Com_head:setPlayerID(self.data.uid)
		self.fields.Text_name:setString(self.data.uInfo.nickName)
		self.fields.Sprite_rank:setSpriteFrame(allianceDesRead.getIcon(self.data.alliancerank))
	end
end
function allianceMobRankSingle:onPanelTouchClick()
	if self.data and self.data.aid then
		SoraDPlaySound()
		_ENV = nil
		;(nil).aid = self.data.aid
		_ENV, (nil).kid = self.data.aInfo.kid, self.data.aInfo.kid
		self.data.aInfo.kid.from = "allianceMobRankSingle"
		allianceQuery:reqAllianceByID(nil, self.data.aInfo.kid)
	end
end
return allianceMobRankSingle
