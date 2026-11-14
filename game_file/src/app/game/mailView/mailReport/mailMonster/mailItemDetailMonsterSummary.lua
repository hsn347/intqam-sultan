local itemDesRead = include("itemDesRead")
local worldMapDefine = include("worldMapDefine")
local mailItemDetailMonsterSummary = class("mailItemDetailMonsterSummary", function(target)
	return include("ccsView").new(getCCSPath("mailItemDetailMonsterSummary"))
end)
function mailItemDetailMonsterSummary:ctor()
	self:setCascadeOpacityEnabled(true)
	self.contentPanel = SoraDGetChildByName(self, "layout_content")
	self.contentPanel:setCascadeOpacityEnabled(true)
	self.contentPanel:setSwallowTouches(false)
	self.text_power = SoraDGetChildByName(self, "text_power")
	self.text_power_value = SoraDGetChildByName(self, "text_power_value")
	self.text_total = SoraDGetChildByName(self, "text_total")
	self.text_total_value = SoraDGetChildByName(self, "text_total_value")
	self.text_wounded = SoraDGetChildByName(self, "text_wounded")
	self.text_wounded_value = SoraDGetChildByName(self, "text_wounded_value")
	self.text_remain = SoraDGetChildByName(self, "text_remain")
	self.text_remain_value = SoraDGetChildByName(self, "text_remain_value")
	self.text_power:setString(i18n("common_text_097"))
	self.text_total:setString(i18n("common_text_095"))
	self.text_wounded:setString(i18n("common_text_098"))
	self.text_remain:setString(i18n("common_text_096"))
	_UPVALUE4_ = self.text_remain
	self.text_remain[1] = self.text_power
	self.text_remain[2] = self.text_total
	self.text_remain[3] = self.text_wounded
	self.text_remain[4] = self.text_remain
	for i, v in ipairs(self.text_remain) do
		if v:getContentSize().width > 130 then
			SoraDSetTextWidthHeight(v, cc.size(130, 25))
		end
	end
	local itemSize = self.contentPanel:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailMonsterSummary:initWithData(data)
	if nil == data then
		return
	end
	if data.fightInfo == nil then
		return
	end
	self.text_power_value:setString(string.formatnumberthousands(data.fightInfo.lostPower))
	self.text_wounded_value:setString(string.formatnumberthousands(data.fightInfo.woundedNum))
	self.text_total_value:setString(string.formatnumberthousands(data.fightInfo.totalNum))
	self.text_remain_value:setString(string.formatnumberthousands(data.fightInfo.remainNum))
end
function mailItemDetailMonsterSummary:getItemWidth()
	return self.itemWidth
end
function mailItemDetailMonsterSummary:getItemHeight()
	return self.itemHeight
end
return mailItemDetailMonsterSummary
