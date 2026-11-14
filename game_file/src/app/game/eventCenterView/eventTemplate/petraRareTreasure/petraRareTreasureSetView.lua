local gametop = gModuleMgr.getObject("gametop")
local petraRareTreasureCtrl = gametop.playertop_:getModule("petraRareTreasureCtrl")
local petraRareTreasureRead = include("petraRareTreasureRead")
local petraRareTreasureUtil = include("petraRareTreasureUtil")
local petraRareTreasureSetView = class("petraRareTreasureSetView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("petraRareTreasureSetView")
	end
	return target
end)
function petraRareTreasureSetView:ctor()
	self.isHideCurrentSceneView = true
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("petra_title_03"))
	self.Button_buy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_gold")
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyClickCallBack))
	self.spIcon = SoraDGetChildByName(self, "Sprite_Icon")
	self.txtSetting = SoraDGetChildByName(self, "Text_setting")
	self.txtSetting:setString(i18n("petra_title_04"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setIsRight(SoraDFIsRA())
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.nodeSingle = SoraDGetChildByName(self, "Node_bind")
	self.nodeSingle:setVisible(false)
	self.preNode = nil
	self:initData()
end
function petraRareTreasureSetView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PETRA_RARE_TREASURE_BESTTREASURE", handler(self, self.closeLoading))
end
function petraRareTreasureSetView:closeLoading(target, data)
	if self.bestTreasureId ~= 0 and data.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("petra_text_11"))
	end
	SoraDCloseLoading(self)
	self:initData()
end
function petraRareTreasureSetView:initData(data)
	self.index = 0
	self.gold = 0
	if self.preNode then
		self.preNode:setLight(false)
		self.preNode = nil
	end
	self.bestTreasureId = petraRareTreasureCtrl:getBestTreasureID()
	self.itemArray = petraRareTreasureRead:getSelectItem()
	petraRareTreasureCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(100, 120), self.itemArray, 4, nil)
	self:setBestTreasureItem()
	self:setBtnInfo()
end
function petraRareTreasureSetView:setBestTreasureItem()
	if self.bestTreasureId ~= 0 then
		local itemData = self.itemArray[self.bestTreasureId]
		if itemData then
			local publicRead = include("publicRead")
			self.spIcon:setSpriteFrame(publicRead.getIcon(itemData.id))
			self.spIcon:setScale(0.8)
		end
		self:setSelect(self.bestTreasureId)
	end
end
function petraRareTreasureSetView:setBtnInfo()
	local gold = petraRareTreasureUtil:getBestTreasureGold()
	if gold <= 0 then
		petraRareTreasureUtil = nil
		;(nil).text = i18n("petra_btn_01")
		self.Button_buy:initData(nil, 0)
	else
		petraRareTreasureUtil = nil
		;(nil).title = i18n("common_text_713")
		;(nil).gold = gold
		self.Button_buy:initData(nil, 1)
	end
	self.gold = gold
end
function petraRareTreasureSetView:createSingle()
	local ocx = self.nodeSingle:clone()
	local single = include("petraRareTreasureSetSingle").new(ocx)
	single:setHandle(handler(self, self.opClickCallBack))
	single:setVisible(true)
	return single
end
function petraRareTreasureSetView:opClickCallBack(node, data)
	dump(data, "data", 10)
	local index = data.index or 0
	self:setSelect(index, node)
end
function petraRareTreasureSetView:setSelect(index, node)
	if self.preNode then
		self.preNode:setLight(false)
		self.preNode = nil
	end
	node = node or self.scroll:getChildByIndex(index)
	if node then
		node:setLight(true)
		self.preNode = node
		self.index = index
		local isBestTreasureId = self.index == self.bestTreasureId
		self.Button_buy:setTouchEnabled(not isBestTreasureId)
		self.Button_buy:setBright(not isBestTreasureId)
	end
end
function petraRareTreasureSetView:btnBuyClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.index > 0 then
			if 0 >= self.gold then
				petraRareTreasureCtrl:reqSelectBestTreasure(self.index)
				SoraDShowLoading(self)
			else
				_ENV = self.index
				self.index.num = self.gold
				local showMsg = i18n("petra_text_10", self.index)
				SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) and SoraDEnoughGold(self.gold) then
						petraRareTreasureCtrl:reqSelectBestTreasure(self.index)
						SoraDShowLoading(self)
					end
				end)
			end
		end
	end
end
return petraRareTreasureSetView
