local radianceWarRead = include("radianceWarRead")
local radianceWarRulePopView = class("radianceWarRulePopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("radianceWarRulePopView")
end)
function radianceWarRulePopView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("common_text_1173"))
	self.textDate = SoraDGetChildByName(self, "Text_Date")
	self.textDate:setString(i18n("brightWar_text_29"))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.nodeSingleCreate))
	self.scroll:setSingleRefresh(handler(self, self.nodeSingleRefresh))
	_ENV = handler(self, self.nodeSingleRefresh)
	handler(self, self.nodeSingleRefresh).scroll = self.scroll
	handler(self, self.nodeSingleRefresh).view = self
	self.scroll:updateScrollView(cc.size(540, 78), radianceWarRead.getRadianceRuleConfig(), 1, handler(self, self.nodeSingleRefresh))
end
function radianceWarRulePopView:nodeSingleCreate(parent, data)
	local single = self.nodeSingle:clone()
	return single
end
function radianceWarRulePopView:nodeSingleRefresh(parent, data)
	SoraDGetChildByName(parent, "Image_Sheer"):setVisible(data.index % 2 == 0)
	local textTime = SoraDGetChildByName(parent, "Text_Time")
	local textKingInfo = SoraDGetChildByName(parent, "Text_KingInfo")
	textKingInfo:setString(i18n(data.des))
	textTime:setString(string.formatnumberthousands(data.Exploits))
end
return radianceWarRulePopView
