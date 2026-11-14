local nebulaWarRead = include("nebulaWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaAllStarWar/Com_giftRankSingle", Com_giftRankSingle)
function Com_giftRankSingle:onInit()
	self.fields.Com_head:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_score:fixPos()
end
function Com_giftRankSingle:onShow()
end
function Com_giftRankSingle:initData(data, rank)
	data.rank = rank
	self.fields.Com_rankBase:initRankBaseData(data)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setAvatarFrame(data.avatarFrameId)
	if data.camp then
		local areaAbbr = nebulaWarRead.getAreaAbbr(data.camp)
		nebulaWarRead = data.avatar
		data.avatar.abbr = areaAbbr
		data.avatar.name = data.nickName
		local name = i18n("common_text_186", data.avatar)
		self.fields.Text_name:setString(name)
	else
		self.fields.Text_name:setString(data.nickName)
	end
	self.fields.Text_score:setString(string.formatnumberthousands(data.charm))
end
return Com_giftRankSingle
