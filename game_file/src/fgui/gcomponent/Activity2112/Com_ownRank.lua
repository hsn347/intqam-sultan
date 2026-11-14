local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_ownRank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Com_ownRank", Com_ownRank)
function Com_ownRank:onInit()
	self:fixChildrenPos()
	self.fields.Load_flag:fixPos()
	self.fields.n1:fix(false)
	self.fields.n2:fix(false)
	self.fields.n3:fix(false)
	self.fields.n4:fix(false)
	self.fields.Text_none:setString(i18n("common_text_826"))
end
function Com_ownRank:initData(data)
	if not allianceMgr:hasJoinAlliance() then
		self.controllers.state:setSelectedIndex(1)
		return
	end
	self.rankData = data
	if data.rank <= 100 and data.rank >= 0 then
		self.fields.Text_rank:setString(tostring(data.rank))
	else
		self.fields.Text_rank:setString(i18n("common_text_827"))
	end
	self.fields.Text_name:setString(data.leader)
	self.fields.Load_flag:setURL(allianceDesRead.getFlagIcon(data.allianceFlag))
	allianceMgr = allianceDesRead.getFlagIcon(data.allianceFlag)
	allianceDesRead.getFlagIcon(data.allianceFlag).abbr = data.abbr
	allianceDesRead.getFlagIcon(data.allianceFlag).name = data.name
	self.fields.Text_alliance:setString(i18n("common_text_186", allianceDesRead.getFlagIcon(data.allianceFlag)))
	self.fields.Text_score:setString(string.formatnumberthousands(math.round(data.score)))
end
function Com_ownRank:onShow()
end
return Com_ownRank
