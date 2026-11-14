local gametop = gModuleMgr.getObject("gametop")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local citybuffItemView = include("citybuffItemView")
local citybuffHalloweenItemView = class("citybuffHalloweenItemView", citybuffItemView)
function citybuffHalloweenItemView:ctor()
	citybuffHalloweenItemView.super.ctor(self)
end
function citybuffHalloweenItemView:update(target, redata)
	local underTopY = 0
	SoraDCloseLoading(self.scroll)
	local buffData = buffCtrl:queryHalloweenBuff(self.tableBuff.bid)
	if buffData then
		self.topProBar:setVisible(true)
		self.topProBar:setMeSize(100)
		self.topProBar:initData(buffData)
		underTopY = 170 + self.specialHeigh
	else
		self.topProBar:setVisible(false)
		underTopY = 120
	end
	self.scroll:setPosition(self.scroll:getPositionX(), display.height - underTopY - 80)
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, display.height - underTopY - 80))
	buffCtrl = self.scroll.setContentSize
	local _ENV, self.scroll.setContentSize[1], tblBuffList = self.tableBuff.itemID, self.tableBuff.itemID, self.scroll.setContentSize
	self.tableBuff.itemID.itemList = tblBuffList
	self.tableBuff.itemID.itemCallBack = handler(self, self.buyOrUseCallBack)
	self.tableBuff.itemID.itemStyle = "commonItemUseBar_01"
	local self.tableBuff.itemID.itemSize, transTbl = cc.size(620, 170), self.tableBuff.itemID
	self.itemScroll:setScroll(self.scroll)
	self.itemScroll:init(transTbl)
	self.frmBg:setContentSize(cc.size(self.frmBg:getContentSize().width, underTopY))
	local singleShow = self.itemScroll:getSingleToShow()
	if not buffData and (not singleShow or not next(singleShow)) then
		self:removeFromParent()
	end
end
return citybuffHalloweenItemView
