local gametop = gModuleMgr.getObject("gametop")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local itemLogic = include("itemLogic")
local itemDesRead = include("itemDesRead")
local CityEffectInfoRead = include("cityEffectInfoRead")
local CitybuffItemView = class("citybuffItemView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("citybuffItemView")
	end
	return target
end)
function CitybuffItemView:ctor()
	self.tableBuff, _ENV, self.tableBuffindex, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.isNewPlayer = false
	self.specialHeigh = 0
	self.itemScroll = include("itemBuyScroll").new()
	self.frmTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_citybuffitemView")
	self.topProBar = SoraDGetExtendChildFromCCSByName(self, "CCS_citybuffProgressBar_itemViewProBar")
	self.topItemDes = SoraDGetChildByName(self, "Text_des")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_itemList")
	self.frmBg = SoraDGetChildByName(self, "Image_frameBg")
	self.Top_Node_info = SoraDGetChildByName(self, "Top_Node_info")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
end
function CitybuffItemView:initData(tableBuff, isNewPlayer)
	self.tableBuff = tableBuff
	self.isNewPlayer = isNewPlayer
	self.frmTitle:setTitle(self.tableBuff.buffname)
	self.topItemDes:setString(self.tableBuff.buftip)
	if self.tableBuff.bid == gBuffEffect.MASSACRE and worldMapDefine.isInPyramid() then
		SoraDChangeTextToHtml(self.topItemDes)
		_ENV = "common_text_4707"
		;("common_text_4707").color = "#ff0000"
		local nameStr = SoraDWrapHtmlTagByStyle(i18n("common_text_4707"), "common_text_4707")
		self.topItemDes:setString(self.tableBuff.buftip .. nameStr)
	end
	self:update()
end
function CitybuffItemView:update(target, redata)
	local underTopY = 0
	SoraDCloseLoading(self.scroll)
	local closeBuff = function(bool)
		if 21 == self.tableBuff.bid then
			self.specialHeigh = 52
			if bool then
				if not SoraDGetChildByName(self, "Button_closeBuff") then
					local button = ccui.Button:create()
					button:loadTextures("btn_yellow_small_01.png", "", "", ccui.TextureResType.plistType)
					button:setPosition(320, -250)
					button:setTitleText(i18n("common_text_2088"))
					button:setName("Button_closeBuff")
					button:setTitleFontSize(20)
					button:addTouchEventListener(function(btn, type)
						if type == ccui.TouchEventType.ended then
							SoraDPlaySound()
							buffCtrl:closeAntiScoutBuff()
						end
					end)
					button:addTo(self.Top_Node_info, 99)
					SoraDAutoSizeButtonText(button)
				end
			else
				self.specialHeigh = 0
				if SoraDGetChildByName(self.Top_Node_info, "Button_closeBuff") then
					SoraDGetChildByName(self.Top_Node_info, "Button_closeBuff"):removeFromParent()
				end
			end
		end
	end
	local buffData = buffCtrl:queryCityBuff(self.tableBuff.bid)
	if self.isNewPlayer then
		buffData = buffCtrl:queryNewPlayerBuff(self.tableBuff.bid)
	end
	if buffData then
		closeBuff(true)
		self.topProBar:setVisible(true)
		self.topProBar:setMeSize(100)
		self.topProBar:initData(buffData)
		underTopY = 170 + self.specialHeigh
	else
		closeBuff(false)
		self.topProBar:setVisible(false)
		underTopY = 120
	end
	self.scroll:setPosition(self.scroll:getPositionX(), display.height - underTopY - 80)
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, display.height - underTopY - 80))
	local tblBuffList = buffCtrl:getBuffItemArray(self.tableBuff.bid)
	if self.isNewPlayer then
		tblBuffList, _ENV = self.isNewPlayer, self.isNewPlayer
	end
	dump(tblBuffList, "tblBuffList===")
	table.sort(tblBuffList, function(a, b)
		return a < b
	end)
	_ENV = table.sort
	table.sort.itemList = tblBuffList
	table.sort.itemCallBack = handler(self, self.buyOrUseCallBack)
	table.sort.itemStyle = "commonItemUseBar_01"
	local table.sort.itemSize, transTbl = cc.size(620, 170), table.sort
	self.itemScroll:setScroll(self.scroll)
	self.itemScroll:init(transTbl)
	self.frmBg:setContentSize(cc.size(self.frmBg:getContentSize().width, underTopY))
end
function CitybuffItemView:buyOrUseCallBack(controlTbl)
	local itemLogic = include("itemLogic")
	local buyItem = function(itemID)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
		if itemInfo then
			local itemLogic = include("itemLogic")
			local ret, src = itemLogic.checkItemSpecialTip(itemID)
			local itemUseAndBuy = function(...)
				itemLogic = nil
				;(nil).needBuy = true
				if not itemLogic.checkItemSpecial(itemID, 1, nil) then
					shopCtrl:reqBuyInItemShop(itemInfo.shopItemID, 1, true)
				end
			end
			if ret then
				SoraDShowMsgBox(src, i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						itemUseAndBuy()
					end
				end)
			else
				_ENV = i18n("common_text_204")
				i18n("common_text_204").var = controlTbl.needGold
				i18n("common_text_204").name = include("publicRead").getName(itemID)
				src = i18n("common_text_4593", (i18n("common_text_204")))
				SoraDShowMsgBox(src, i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						itemUseAndBuy()
					end
				end)
			end
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
	if controlTbl.buy then
		if SoraDEnoughGold(controlTbl.needGold) then
			buyItem(controlTbl.itemID)
		end
	elseif controlTbl.use then
		itemLogic.useItemsLine(controlTbl.itemID, controlTbl.itemCount)
	end
end
return CitybuffItemView
