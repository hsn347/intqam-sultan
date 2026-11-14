local ItemBuyScroll = class("itemBuyScroll")
function ItemBuyScroll:ctor()
	self.itemBars, _UPVALUE0_, self.scroll = nil, nil, nil
end
function ItemBuyScroll:setScroll(scroll)
	self.scroll = scroll
end
function ItemBuyScroll:init(infoTbl)
	self.info = infoTbl
	self.buyOrUseCallBack = infoTbl.itemCallBack
	self.itemInitCallBack = infoTbl.itemInitCallBack
	self.itemIconClickCallBack = infoTbl.itemIconClickCallBack
	self.singleStyle = infoTbl.itemStyle or "commonItemUseBar_01"
	self.singleSize = infoTbl.itemSize or cc.size(628, 176)
	self.battleExclusive = infoTbl.battleExclusive
	self.isBuyOnly = infoTbl.isBuyOnly or false
	self.sortHandl = infoTbl.sortHandl
	self.itemList = self.isBuyOnly and infoTbl.itemList or self:sortByIndex(infoTbl.itemList)
	if self.info.posY then
		self.scroll:setPositionY(display.height - self.info.posY)
	end
	self:initView()
end
function ItemBuyScroll:sortByIndex(tbl)
