local gametop = gModuleMgr.getObject("gametop")
local pyramidRareTreasureCtrl = gametop.playertop_:getModule("pyramidRareTreasureCtrl")
local pyramidTreasureRead = include("pyramidTreasureRead")
local publicRead = include("publicRead")
local pyramidTreasureChooseView = class("pyramidTreasureChooseView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pyramidTreasureChooseView")
	end
	return target
end)
function pyramidTreasureChooseView:ctor()
	self.itemArray, _ENV = nil, nil
	self.selectIndex = nil
	self.costGold = 0
	self.bestID = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Pyramid_treasure_text_03"))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("Pyramid_treasure_text_05"))
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.icon_wh = SoraDGetChildByName(self, "icon_wh")
	self.Image_select = SoraDGetChildByName(self, "Image_select")
	self.Button_choose = SoraDGetChildByName(self, "Button_choose")
	self.Button_choose:addTouchEventListener(handler(self, self.btnChooseClick))
	self.Node_gold = SoraDGetChildByName(self, "Node_gold")
	self.Text_gold = SoraDGetChildByName(self, "Text_gold")
	self.Node_gold:setVisible(false)
	self.Node_SBG = SoraDGetChildByName(self, "Node_SBG")
	SoraDCreatAnimation("animationJZTXZD"):addTo(self.Node_SBG)
	self.Node_SURE = SoraDGetChildByName(self, "Node_SURE")
	self:initItems()
	self:initData()
end
function pyramidTreasureChooseView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_TREASURE_BESTTREASURE", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function pyramidTreasureChooseView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function pyramidTreasureChooseView:showSelectEffect()
	if not self.et_refresh then
		self.et_refresh = SoraDCreatAnimationEx("animationJZTXZ", nil, false)
		self.et_refresh:addTo(self.Node_SURE)
	else
		self.et_refresh.action:gotoFrameAndPlay(0, false)
	end
end
function pyramidTreasureChooseView:closeLoading(target, data)
	SoraDCloseLoading(self)
	if self.selectIndex ~= 0 and data.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("petra_text_11"))
	end
	self.Button_choose:setBright(false)
	self.Button_choose:setTouchEnabled(false)
	self:initData()
	self:showSelectEffect()
end
function pyramidTreasureChooseView:initData()
	local hasBest = pyramidRareTreasureCtrl:hasBestTreasureID()
	self.icon_wh:setVisible(not hasBest)
	self.Image_select:setVisible(hasBest)
	if hasBest then
		local bestIndex = pyramidRareTreasureCtrl:getBestTreasureID()
		local id, count = pyramidTreasureRead.getBestCfg(bestIndex)
		self.bestID = id
		self.Image_select:loadTexture(publicRead.getIcon(self.bestID), ccui.TextureResType.plistType)
	end
	local times = pyramidRareTreasureCtrl:getBestTreasureTimes()
	local curTimes = times + 1
	if 0 < times then
		self.Node_gold:setVisible(true)
		self.Button_choose:setTitleText("")
		local gold = pyramidTreasureRead.getRefreshGold(curTimes)
		self.costGold = gold
		self.Text_gold:setString(gold)
		SoraDToCenter(self.Node_gold)
	else
		self.Node_gold:setVisible(false)
		self.Button_choose:setTitleText(i18n("petra_btn_01"))
	end
end
function pyramidTreasureChooseView:initItems()
	local itemList = pyramidTreasureRead.getSelectList()
	for k, v in ipairs(itemList) do
		if not self.itemArray[k] then
			local item = include("commonItemAward").new()
			item:setOwnView(self)
			item:setPosition(0, 0)
			item:addTo(self.Node_items)
			item:setScale(0.9)
			item:setBaseScale(1.0)
			item:setHandle(handler(self, self.chooseItem))
			item.index = v.index
			self.itemArray[k] = item
		end
		self.itemArray[k]:initData(v.id, v.count)
	end
	SoraDautoSortPos(self.Node_items, 4, 1, cc.size(110, 110))
end
function pyramidTreasureChooseView:chooseItem(button, event, itemID)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		for k, v in ipairs(self.itemArray) do
			local _itemID, _num = v:getData()
			if _itemID == itemID then
				v:showCoolSquare()
				self.selectIndex = v.index
				self.icon_wh:setVisible(false)
				self.Image_select:setVisible(true)
				self.Image_select:loadTexture(publicRead.getIcon(itemID), ccui.TextureResType.plistType)
				if self.bestID then
					self.Button_choose:setBright(self.bestID ~= itemID)
					self.Button_choose:setTouchEnabled(self.bestID ~= itemID)
				end
			else
				v:hideCoolSquare()
			end
		end
	end
end
function pyramidTreasureChooseView:btnChooseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.selectIndex then
			SoraDShowMsgTip(i18n("Pyramid_treasure_text_05"))
			return
		end
		if self.costGold > 0 then
			_ENV = i18n("Pyramid_treasure_text_05")
			i18n("Pyramid_treasure_text_05").num = self.costGold
			SoraDShowMsgBox(i18n("petra_text_10", i18n("Pyramid_treasure_text_05")), i18n("common_text_204"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES and SoraDEnoughGold(self.costGold) then
					pyramidRareTreasureCtrl:reqSelectBestTreasure(self.selectIndex)
					SoraDShowLoading(self)
				end
			end)
		else
			pyramidRareTreasureCtrl:reqSelectBestTreasure(self.selectIndex)
			SoraDShowLoading(self)
		end
	end
end
return pyramidTreasureChooseView
