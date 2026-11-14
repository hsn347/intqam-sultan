local baseComponent = require("fgui.base.baseComponent")
local Com_top3single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMemberView/Com_top3single", Com_top3single)
function Com_top3single:onInit()
end
function Com_top3single:onShow()
end
function Com_top3single:initData(rank, data)
	local isNotEmpty = data and next(data) and true or false
	self.controllers.cRank:setSelectedIndex(rank - 1)
	if isNotEmpty then
		self.fields.Com_head:setVisible(true)
		self.fields.Com_head:setPlayerID(data.data.minfo.uid)
		self.fields.Com_head:setHeadSprite(data.data.uinfo.iconID, data.data.uinfo.avatar)
		self.fields.Text_name:setString(_G.textParser.formatPlayerName(data.data.allianceAbbr, data.data.uinfo.nickName))
		self.fields.Text_score:setString(string.formatnumberthousands(data.data.uinfo.totalFc))
	else
		self.fields.Com_head:setVisible(false)
		self.fields.Text_name:setString("")
		self.fields.Text_score:setString("")
	end
end
return Com_top3single
