local publicRead = include("publicRead")
local constantRead = include("constantRead")
local activity_9001639_Read = include("activity_9001639_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_recordList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001639/Com_recordList", Com_recordList)
function Com_recordList:onInit()
	self.itemID = constantRead.getConstValue("EIDAL_MARKET_BROADCAST_ITEM")
	self:fixChildrenPos()
end
function Com_recordList:onShow()
end
function Com_recordList:initData(data)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	local nameStr = fguiHelper.getColorString("#FFD43E", textParser.formatPlayerName(data.abbr, data.nickName, data.kid))
	_ENV = textParser.formatPlayerName(data.abbr, data.nickName, data.kid)
	textParser.formatPlayerName(data.abbr, data.nickName, data.kid).param = publicRead.getIcon(self.itemID, true)
	textParser.formatPlayerName(data.abbr, data.nickName, data.kid).width = 26
	textParser.formatPlayerName(data.abbr, data.nickName, data.kid).height = 26
	textParser.formatPlayerName(data.abbr, data.nickName, data.kid).offsety = 5
	local itemIcon = SoraDWrapReplaceTag(textParser.formatPlayerName(data.abbr, data.nickName, data.kid))
	local itemStr = fguiHelper.getColorString("#FFD43E", publicRead.getName(self.itemID)) .. itemIcon
	local numStr = fguiHelper.getColorString(activity_9001639_Read.getBroadcastColor(data.count), data.count)
	_ENV = publicRead.getName(self.itemID)
	publicRead.getName(self.itemID).name = nameStr
	publicRead.getName(self.itemID).item = itemStr
	publicRead.getName(self.itemID).num = numStr
	self.fields.Text_des:setString(i18n("eidal_market_text3", publicRead.getName(self.itemID)))
	if data.time then
		self.fields.Text_date:setString(os.date("%m-%d %H:%M:%S", data.time))
	end
end
return Com_recordList
