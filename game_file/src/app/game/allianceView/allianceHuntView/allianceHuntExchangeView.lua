local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local allianceHuntDesRead = include("allianceHuntDesRead")
local allianceHuntExchangeView = class("allianceHuntExchangeView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("allianceHuntExchangeView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function allianceHuntExchangeView:ctor()
	self:createUI()
	self.sizeTileImgBg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.sizeScrollWinRewards = SoraDGetChildByName(self, "Top_Size_scroll_win_rewards")
	self.node = SoraDGetChildByName(self, "Top_Node")
	self.imgTop = SoraDGetChildByName(self, "Image_top")
	self.imgBlack = SoraDGetChildByName(self, "Image_black")
	self.frameSVIPTitle011 = SoraDGetChildByName(self, "frame_SVIP_title_01_1")
	self.frameSVIPTitle012 = SoraDGetChildByName(self, "frame_SVIP_title_01_2")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.frameCjxtT1 = SoraDGetChildByName(self, "frame_cjxt_t_1")
	self.frameCjxtT2 = SoraDGetChildByName(self, "frame_cjxt_t_2")
	self.frameQdlhlBt1 = SoraDGetChildByName(self, "frame_qdlhl_bt_1")
	self.frameQdlhlBt2 = SoraDGetChildByName(self, "frame_qdlhl_bt_2")
	self.commonFramTitle_oab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_oab")
	self.nodeCoin = SoraDGetChildByName(self, "Node_coin")
	self.btnCoin = SoraDGetChildByName(self, "Button_coin")
	self.imgCoinBtn = SoraDGetChildByName(self, "Image_coin_btn")
	self.txtCoinNum = SoraDGetChildByName(self, "Text_coin_num")
	self.spCoin = SoraDGetChildByName(self, "Sprite_coin")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.panelSingle = SoraDGetChildByName(self, "panel_single")
	self.img1 = SoraDGetChildByName(self, "Image_1")
	self.img2 = SoraDGetChildByName(self, "Image_2")
	self.img103 = SoraDGetChildByName(self, "Image_103")
	self.img1030 = SoraDGetChildByName(self, "Image_103_0")
	self.textLimit = SoraDGetChildByName(self, "text_limit")
	self.textDes = SoraDGetChildByName(self, "text_des")
	self.btnBuy = SoraDGetChildByName(self, "btn_buy")
	self.iconBuy = SoraDGetChildByName(self, "icon_buy")
	self.textGold = SoraDGetChildByName(self, "text_gold")
	self.btnCoin:addTouchEventListener(handler(self, self.onClick_btnCoin))
	self.btnHelp:addTouchEventListener(handler(self, self.onClick_btnHelp))
	self.scroll = include("commonAutoScrollList").new(self.sizeScrollWinRewards)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.commonFramTitle_oab:setTitle(i18n("alliance_hunt_btn_01"))
	self.txtTitle:setString(i18n("common_text_4416"))
	self:init()
end
function allianceHuntExchangeView:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function allianceHuntExchangeView:init(data)
	local huntData = allianceHuntCtrl:getHuntData()
	local shopdata = huntData.shopdata
	dump(shopdata, "狩猎商店数据", 10)
	local huntingPoint = allianceHuntCtrl:getHuntingPoint()
	print("玩家当前的狩猎点数:", huntingPoint)
	self.txtCoinNum:setString(string.formatnumberthousands(huntingPoint))
	self.itemList, allianceHuntCtrl = self.txtCoinNum.setString, self.txtCoinNum.setString
	local exchangeList = allianceHuntDesRead.getExchangeList()
	for i, v in ipairs(exchangeList) do
		allianceHuntCtrl = string.formatnumberthousands(huntingPoint)
		string.formatnumberthousands(huntingPoint).itemdata = exchangeList[i]
		table.insert(self.itemList, string.formatnumberthousands(huntingPoint))
	end
	dump(self.itemList, "self.itemList", 10)
	local shopData = allianceHuntCtrl:getShopData()
	table.sort(self.itemList, function(item1, item2)
		item1 = item1.itemdata
		item2 = item2.itemdata
		local total1 = item1.limitNum
		local cur1 = shopData[tostring(item1.shopIndex)] or 0
		local total2 = item2.limitNum
		local cur2 = shopData[tostring(item2.shopIndex)] or 0
		local isItem1Limited = total1 <= cur1 and true or false
		local isItem2Limited = total2 <= cur2 and true or false
		if isItem1Limited == isItem2Limited then
			return item1.shopIndex < item2.shopIndex
		elseif isItem1Limited == false then
			return true
		end
		return false
	end)
	print("刷新scroll-----")
	allianceHuntCtrl = self.itemList
	self.itemList.scroll = self.scroll
	self.scroll:updateScrollView(cc.size(640, 126), self.itemList, 1, self.itemList)
end
function allianceHuntExchangeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BUY_SUCCESS", handler(self, self.sMsgBuySuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BUY_FAILED", handler(self, self.sMsgBuyFailed))
end
function allianceHuntExchangeView:createSingle()
	local ocx = self.panelSingle:clone()
	local single = include("nodeHuntShopItem").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setParentView(self)
	single:setView(self)
	return ocx
end
function allianceHuntExchangeView:onClick_btnCoin(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function allianceHuntExchangeView:onClick_btnHelp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function allianceHuntExchangeView:sMsgBuySuccess(target, data)
	self:init()
	self:closeLoading()
end
function allianceHuntExchangeView:sMsgBuyFailed(target, data)
	self:closeLoading()
end
function allianceHuntExchangeView:showLoading()
	SoraDShowLoading(self, nil, nil, true)
end
function allianceHuntExchangeView:closeLoading()
	SoraDCloseLoading(self)
end
return allianceHuntExchangeView
