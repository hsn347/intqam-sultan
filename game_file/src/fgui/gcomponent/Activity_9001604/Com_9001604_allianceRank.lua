local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001604_allianceRank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001604/Com_9001604_allianceRank", Com_9001604_allianceRank)
function Com_9001604_allianceRank:onInit()
	self.fields.Load_bg:fix()
end
function Com_9001604_allianceRank:onShow()
end
function Com_9001604_allianceRank:initData(data, otheData)
	self.data = data
	local index = 0
	local rank = self.data.rank or otheData.index
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
	self.controllers.c3:setSelectedIndex(self.data.aid and 0 or 1)
	if self.data.aid then
		self.fields.Com_head:setVisible(false)
		self.fields.flag:setVisible(true)
		self.fields.Sprite_rank:setVisible(false)
		local flagNode = allianceDesRead.getFlagNode(self.data.flag)
		flagNode:setScale(0.4)
		self.fields.flag:setContent(flagNode)
		_ENV = string.formatnumberthousands(self.data.score)
		string.formatnumberthousands(self.data.score).abbr = self.data.abbr
		string.formatnumberthousands(self.data.score).name = self.data.name
		_ENV = string.formatnumberthousands(self.data.score)
		string.formatnumberthousands(self.data.score).name = self.data.leaderName
		self.fields.Text_name:setString(i18n("common_text_186", string.formatnumberthousands(self.data.score)) .. "\n" .. i18n("common_text_926", string.formatnumberthousands(self.data.score)))
	else
		self.fields.Com_head:setVisible(true)
		self.fields.flag:setVisible(false)
		self.fields.Sprite_rank:setVisible(false)
		self.fields.Sprite_rank:setVisible(true)
		self.fields.Com_head:setHeadSprite(self.data.headid, self.data.avatar)
		if self.fields.Text_quest then
			dump(otheData, "otheData")
			self.fields.Text_quest:setString((self.data.acceptCount or 0) .. "/" .. otheData.questLimit)
		end
		self.fields.Com_head:setPlayerID(self.data.uid)
		self.fields.Text_name:setString(self.data.nickName)
		self.fields.Sprite_rank:setSpriteFrame(allianceDesRead.getIcon(self.data.allianceRank or 1))
	end
	self:fixChildrenPos()
end
return Com_9001604_allianceRank
