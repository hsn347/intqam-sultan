local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity2112/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:fixChildrenPos()
	self.rewardData, _UPVALUE0_ = self.fixChildrenPos, self.fixChildrenPos
end
function Com_rankSingle:initData(index, data, rewardData)
	self.rankData = data
	if data.rank > 0 and data.rank <= 3 then
		self.fields.Load_bg:setURL(string.format("frame_alliance_pank_%02d.png", data.rank))
		self.fields.Load_rank:setURL(string.format("icon_ranking_%d.png", data.rank))
		self.controllers.c_top3:setSelectedIndex(0)
	else
		self.fields.Load_bg:setURL(string.format("frame_alliance_pank_%02d.png", 4))
		self.fields.Text_rank:setString(data.rank > 0 and tostring(data.rank) or i18n("common_text_827"))
		self.controllers.c_top3:setSelectedIndex(1)
		if allianceMgr:getOwnAid() and data.aid == allianceMgr:getAllianceInfo().property.aid then
			self.fields.Load_bg:setURL("frame_alliance_pank_05.png")
		end
	end
	self.fields.Load_flag:setURL(allianceDesRead.getFlagIcon(data.flag))
	_ENV = allianceDesRead.getFlagIcon(data.flag)
	allianceDesRead.getFlagIcon(data.flag).abbr = data.abbr
	allianceDesRead.getFlagIcon(data.flag).name = data.name
	self.fields.Text_alliance:setString(i18n("common_text_186", allianceDesRead.getFlagIcon(data.flag)))
	self.fields.Text_score:setString(string.formatnumberthousands(data.score))
	if rewardData and table.nums(rewardData) then
		allianceDesRead = string.formatnumberthousands(data.score)
		string.formatnumberthousands(data.score)[1] = "id"
		string.formatnumberthousands(data.score)[2] = "count"
		self.rewardData = serviceFunctions.tableFormat(rewardData, string.formatnumberthousands(data.score))
		self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
		self.fields.List_reward:setNumItems(table.nums(self.rewardData))
	end
end
function Com_rankSingle:onItemRenderer(index, object)
	object:initData(self.rewardData[index + 1].id, self.rewardData[index + 1].count)
end
function Com_rankSingle:onShow()
end
return Com_rankSingle
