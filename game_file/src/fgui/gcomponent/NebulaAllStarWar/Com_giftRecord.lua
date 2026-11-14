local publicRead = include("publicRead")
local nebulaWarRead = include("nebulaWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftRecord = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaAllStarWar/Com_giftRecord", Com_giftRecord)
function Com_giftRecord:onInit()
	self:fixChildrenPos()
end
function Com_giftRecord:onShow()
end
function Com_giftRecord:initData(data)
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
	nebulaWarRead = name
	name.name = publicRead.getName(data.itemId)
	name.num = string.formatnumberthousands(data.count)
	self.fields.Text_items:setString(i18n("%{name}*%{num}", name))
	self.fields.Text_score:setString(string.formatnumberthousands(data.charm))
	self.fields.Text_num:setString(string.formatnumberthousands(data.bandageCount))
end
return Com_giftRecord
