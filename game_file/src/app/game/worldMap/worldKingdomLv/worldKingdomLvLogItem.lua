local colorYellow = cc.c3b(255, 255, 0)
local maxTextWidth = 350
local widthCell = 510
local heightCell = 50
local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
local worldKingdomLvLogItem = class("worldKingdomLvLogItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldKingdomLvLogItem")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function worldKingdomLvLogItem:ctor()
	self.itemWidth = 510
	self.itemHeight = 50
	self.node_icon = SoraDGetChildByName(self, "node_icon")
	self.node_title = SoraDGetChildByName(self, "node_title")
end
function worldKingdomLvLogItem:init(data)
	self.itemData = data
	local id = 0
	if self.itemData.logType == gKingdomLevelLogType.LOG_EVENTS then
		local logData = self.itemData.logData
		self.node_icon:loadTexture(logData.picture, ccui.TextureResType.plistType)
		print("logData.name = ", logData.name)
		if logData.name and logData.name ~= "" then
			self.node_title:setString(i18n(logData.name))
		end
		id = self.itemData.index
	elseif self.itemData.logType == gKingdomLevelLogType.LOG_HISTORY then
		local logData = self.itemData.logData
		id = logData.expSource
		local value = logData.exp
		local logCfg = worldKingdomLvDesRead.getExpItem(id)
		if not logCfg then
			self.node_title:setString(i18n("common_text_1464"))
			return
		end
		self.node_icon:loadTexture(logCfg.picture, ccui.TextureResType.plistType)
		_ENV = i18n("common_text_1464")
		i18n("common_text_1464").num = value
		self.node_title:setString(i18n(logCfg.des, i18n("common_text_1464")))
	end
	self.node_icon:ignoreContentAdaptWithSize(false)
	local iconSize = cc.size(50, 50)
	if worldKingdomLvDesRead.getExpItemSize(id) then
		iconSize = worldKingdomLvDesRead.getExpItemSize(id).size
	end
	self.node_icon:setContentSize(iconSize)
	if self.itemData.index % 2 == 0 then
		self:setBackGroundColorType(ccui.LayoutBackGroundColorType.none)
	else
		self:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		self:setBackGroundColor(cc.c3b(140, 123, 114))
	end
end
function worldKingdomLvLogItem:setScroll(scroll)
	self.scroll = scroll
end
function worldKingdomLvLogItem:onMessageListener()
end
function worldKingdomLvLogItem:getItemWidth()
	return self.itemWidth
end
function worldKingdomLvLogItem:getItemHeight()
	return self.itemHeight
end
return worldKingdomLvLogItem
