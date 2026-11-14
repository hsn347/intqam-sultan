local itemDesRead = include("itemDesRead")
local publicRead = include("publicRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local flyingStarWishCtrl = SoraDGetCtrl("flyingStarWishCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemGift = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Anniversary2022/Com_itemGift", Com_itemGift)
function Com_itemGift:onInit()
	self:fixChildrenPos()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_itemGift:initData(index, data, selectHandle)
	self.index = index
	self.data = data
	self.selectHandle = selectHandle
	self.fields.icon:setURL(publicRead.getIcon(data.id))
	self.fields.Text_num:setString(data.count)
	self:setSpecialNum(data.id)
	self:setForceBgColor(publicRead.getQuality(data.id))
	self.fields.Text_price:setString(data.price)
	self.fields.Text_price:setColor(data.price > lordInfoCtrl:getBaseInfo().gold and cc.c3b(255, 0, 0) or cc.c3b(255, 219, 109))
	self.controllers.c1:setSelectedIndex(0)
	if data.isSelect then
		self.controllers.c1:setSelectedIndex(1)
		data.isSelect = false
	end
end
function Com_itemGift:setSpecialNum(itemID)
	local specialNum = itemDesRead.getNumByID(itemID)
	if specialNum then
		self.fields.Text_count:setVisible(true)
		self.fields.sheer:setVisible(true)
		self.fields.Text_count:setString(specialNum and specialNum or "")
	end
end
function Com_itemGift:setForceBgColor(quality)
	if quality == gQualityDef.WHITE then
		self.fields.Icon_quality:setColor(cc.c3b(89, 107, 102))
	elseif quality == gQualityDef.GREEN then
		self.fields.Icon_quality:setColor(cc.c3b(19, 139, 108))
	elseif quality == gQualityDef.BLUE then
		self.fields.Icon_quality:setColor(cc.c3b(35, 104, 181))
	elseif quality == gQualityDef.PURPLE then
		self.fields.Icon_quality:setColor(cc.c3b(107, 48, 149))
	elseif quality == gQualityDef.ORANGE then
		self.fields.Icon_quality:setColor(cc.c3b(224, 129, 6))
	elseif quality == gQualityDef.GOLD then
		self.fields.Icon_quality:setColor(cc.c3b(229, 178, 0))
	end
end
function Com_itemGift:onBtnClick()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.title = publicRead.getName(self.data.id)
	SoraDPlaySound.itemDes = publicRead.getDes(self.data.id)
	SoraDPlaySound.btnTitle = i18n("giftgiving_text_29")
	SoraDPlaySound.itemID = self.data.id
	SoraDPlaySound.costID = 1001
	SoraDPlaySound.cost = self.data.price
	SoraDPlaySound.haveNum = flyingStarWishCtrl:getLeftGold()
	SoraDPlaySound.minValue = self.data.minCount
	SoraDPlaySound.maxValue = self.data.maxCount
	SoraDPlaySound.curValue = self.data.curCount
	SoraDPlaySound.singleCount = self.data.count
	function SoraDPlaySound.btnHandle(buyCount)
		SoraDPlaySound()
		self.data.curCount = buyCount
		self.selectHandle(self.index, self.data, buyCount)
	end
	SoraDPlaySound.panelFixFlag = true
	local SoraDPlaySound.inputFixFlag, param = true, SoraDPlaySound
	uiManager:show("FlyingStarWishSelect", param):setOwnerKey(self)
end
function Com_itemGift:setCurBuyCount(buyCount)
	self.data.curCount = buyCount
end
function Com_itemGift:onShow()
end
return Com_itemGift
