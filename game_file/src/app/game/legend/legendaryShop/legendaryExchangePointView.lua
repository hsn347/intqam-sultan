local constantRead = include("constantRead")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local legendaryExchangePointView = class("legendaryExchangePointView", function(target)
	return target or SoraDCreateTouchPanel("legendaryExchangePointView")
end)
function legendaryExchangePointView:ctor()
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("luckyFlip_title_10"))
	self.Image_7 = SoraDGetChildByName(self, "Image_7")
	self.Image_7:setContentSize(cc.size(524, 38))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.textPoint = SoraDGetChildByName(self, "text_point")
	self.textCoin = SoraDGetChildByName(self, "text_coin")
	self.textTip = SoraDGetChildByName(self, "Text_Tip")
end
function legendaryExchangePointView:initData(mapid)
	self.mapid = mapid
	if worldMapDefine.isKingStarMapId(self.mapid) then
		self.textPoint:setString(i18n("legendaryking_text_50"))
		self.textCoin:setString(i18n("item_name_1654"))
		_ENV = i18n("item_name_1654")
		i18n("item_name_1654").nun = string.formatnumberthousands(constantRead.getConstValue("MAX_GET_LEGEND_POINTS"))
		self.textTip:setString(i18n("kingstarbattle_text_51", i18n("item_name_1654")))
	else
		self.textPoint:setString(i18n("legendaryking_text_50"))
		self.textCoin:setString(i18n("legendaryking_text_70"))
		_ENV = i18n("legendaryking_text_70")
		i18n("legendaryking_text_70").nun = string.formatnumberthousands(constantRead.getConstValue("MAX_GET_LEGEND_POINTS"))
		self.textTip:setString(i18n("legendaryking_text_60", i18n("legendaryking_text_70")))
	end
	local itemList = legendLordWarltCtrl.getPointConfig(self.mapid)
	self.scroll:updateScrollView(cc.size(522, 40), itemList, 1)
end
function legendaryExchangePointView:createSingle()
	local single = self.singleNode:clone()
	return single
end
function legendaryExchangePointView:refreshSingle(parent, data)
	local bg = SoraDGetChildByName(parent, "Image_bg")
	bg:setVisible(parent:getTag() % 2 ~= 0)
	local textCoin = SoraDGetChildByName(parent, "Text_Coin")
	local textPoint = SoraDGetChildByName(parent, "Text_Point")
	textCoin:setString(data.score)
	textPoint:setString(i18n(data.des))
end
function legendaryExchangePointView:createSingleLabel()
	local single = ccui.Text:create("", "", 22)
	return single
end
return legendaryExchangePointView
