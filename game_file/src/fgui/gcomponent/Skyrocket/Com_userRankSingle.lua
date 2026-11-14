local textParser = include("textParser")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local rocketRushRead = include("rocketRushRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_userRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Skyrocket/Com_userRankSingle", Com_userRankSingle)
function Com_userRankSingle:onInit()
	self.fields.list:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Btn_quest:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_quest:setVisible(false)
	self.fields.Load_bg:fix()
end
function Com_userRankSingle:onListRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Com_userRankSingle:onShow()
end
function Com_userRankSingle:initData(data, group, rank)
	local isSelf = data.uid == lordInfoCtrl:getLordInfo().base.uid
	local index = 0
	if rank <= RANK_TOP_SPECIAL then
		index = rank
	elseif isSelf then
		index = 4
	end
	self.controllers.c1:setSelectedIndex(index)
	if rank <= 0 then
		self.fields.Text_rank:setString(i18n("common_text_827"))
	else
		self.fields.Text_rank:setString(rank)
	end
	self.fields.Text_score:setString(string.formatnumberthousands(data.score))
	self.fields.Text_score:setColor(cc.c3b(230, 180, 110))
	local nickName = data.name
	local abbr = data.allianceAbb or data.allianceName or data.abbr or data.allianceAbbr
	self.fields.Text_name:setString(textParser.formatPlayerName(abbr, nickName))
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Btn_quest:setVisible(false)
	if self.controllers.c2:getSelectedIndex() == 0 then
		self.rewardList = rocketRushRead.getRankReward(group, rank)
		self.fields.list:setNumItems(#self.rewardList)
		if data.score < include("constantRead").getConstValue("ROCKETRUSH_RANK_POINT_DEMAND", 500) then
			self.fields.Btn_quest:setVisible(true)
			self.fields.Text_score:setColor(cc.c3b(190, 40, 40))
		end
	end
	self:fixChildrenPos()
end
function Com_userRankSingle:btnClick()
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("RocketRush_text_07"))
end
return Com_userRankSingle
