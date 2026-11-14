local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local legendShopCtrl = gametop.playertop_:getModule("legendShopCtrl")
local legendKingRead = include("legendKingRead")
local shopTpye = legendKingRead.shopTpye
local legendaryShopSingle = class("legendaryShopSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendaryShopSingle")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function legendaryShopSingle:ctor()
	self.otherData, _ENV, self.singleData, _ENV = nil, nil, nil, nil
	if SoraDGetChildByName(self, "Image_bg") then
		SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	end
	self.Panel_single = SoraDGetChildByName(self, "Panel_single")
	self.Panel_single:setSwallowTouches(false)
	self.Text_target = SoraDGetChildByName(self, "Text_target")
	self.Text_targetScore = SoraDGetChildByName(self, "Text_targetScore")
	self.Text_score = SoraDGetChildByName(self, "Text_score")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Image_quality = SoraDGetChildByName(self.Node_item, "Image_quality")
	self.Image_item = SoraDGetChildByName(self.Node_item, "Image_item")
	self.Text_bought = SoraDGetChildByName(self.Node_item, "Text_bought")
	self.Text_limit = SoraDGetChildByName(self.Node_item, "Text_limit")
	self.Text_itemName = SoraDGetChildByName(self, "Text_itemName")
	self.Text_itemDes = SoraDGetChildByName(self, "Text_itemDes")
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Button_buy:setSwallowTouches(false)
	self.Text_curPrice = SoraDGetChildByName(self, "Text_curPrice")
	self.Text_oldPrice = SoraDGetChildByName(self, "Text_oldPrice")
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyCallBack))
end
function legendaryShopSingle:initData(singleData, otherData)
	self.singleData = singleData
	self.otherData = otherData
	self:setTargetInfo()
	self:setItemInfo()
	self:setBtnInfo()
end
function legendaryShopSingle:setTargetInfo()
	local ret = self.singleData.limit > 0
	self.Text_target:setVisible(ret)
	self.Text_targetScore:setVisible(ret)
	self.Text_score:setVisible(ret)
	if ret then
		local score = self.otherData.score
		shopTpye = self.Text_score
		self.Text_score[shopTpye.SPEED] = "worldshop_text_02"
		self.Text_score[shopTpye.TREAT] = "worldshop_text_03"
		local self.Text_score[shopTpye.LEGEND_CRYSTAL], config = "worldshop_text_08", self.Text_score
		local targetKey = config[self.singleData.type] or ""
		shopTpye = nil
		;(nil).num = ""
		self.Text_target:setString(i18n(targetKey, nil))
		self.Text_targetScore:setString("/" .. string.formatnumberthousands(self.singleData.limit))
		self.Text_score:setString(string.formatnumberthousands(score))
		self.Text_score:setColor(score >= self.singleData.limit and cc.c3b(255, 210, 70) or cc.c3b(190, 40, 40))
		if SoraDFIsRA() then
			self.Text_targetScore:setPositionX(self.Text_target:getPositionX() - self.Text_target:getContentSize().width - 10)
			self.Text_score:setPositionX(self.Text_targetScore:getPositionX() - self.Text_targetScore:getContentSize().width)
		else
			self.Text_score:setPositionX(self.Text_target:getPositionX() + self.Text_target:getContentSize().width + 10)
			self.Text_targetScore:setPositionX(self.Text_score:getPositionX() + self.Text_score:getContentSize().width)
		end
	end
end
function legendaryShopSingle:setItemInfo()
	local leftBuyCount = math.max(0, self.singleData.number - legendShopCtrl:getLeftBuyCount(self.singleData.shopItemID))
	self.Image_quality:loadTexture(publicRead.getBg(self.singleData.itemId), ccui.TextureResType.plistType)
	self.Image_item:loadTexture(publicRead.getIcon(self.singleData.itemId), ccui.TextureResType.plistType)
	self.Text_bought:setString(leftBuyCount)
	self.Text_bought:setColor(0 < leftBuyCount and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	self.Text_limit:setString("/" .. self.singleData.number)
	self.Text_itemName:setString(self:getItemName())
	self.Text_itemDes:setString(publicRead.getDes(self.singleData.itemId))
	if not SoraDFIsRA() then
		self.Text_bought:setPositionX(self.Text_limit:getPositionX() - self.Text_limit:getContentSize().width)
	else
		self.Text_limit:setPositionX(self.Text_bought:getPositionX() + self.Text_bought:getContentSize().width)
	end
end
function legendaryShopSingle:setBtnInfo()
	self.Button_buy:setBright(self.otherData.score >= self.singleData.limit)
	self.Text_curPrice:setString(string.formatnumberthousands(self.singleData.price))
	self.Text_oldPrice:setString(string.formatnumberthousands(self.singleData.originalPrice))
end
function legendaryShopSingle:btnBuyCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.otherData.score < self.singleData.limit then
			_ENV = self.otherData.score
			self.otherData.score[shopTpye.SPEED] = "worldshop_text_06"
			self.otherData.score[shopTpye.TREAT] = "worldshop_text_04"
			local self.otherData.score[shopTpye.LEGEND_CRYSTAL], config = "worldshop_text_07", self.otherData.score
			local tipKey = config[self.singleData.type] or ""
			_ENV = nil
			;(nil).num = string.formatnumberthousands(self.singleData.limit)
			SoraDShowHelpMsgTip(i18n(tipKey, nil))
		else
			local ret = SoraDEnoughGold(self.singleData.price)
			if ret then
				local leftBuyCount = math.max(0, self.singleData.number - legendShopCtrl:getLeftBuyCount(self.singleData.shopItemID))
				if 0 < leftBuyCount then
					local maxCount = math.min(20, leftBuyCount)
					local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
					local haveGold = lordInfoCtrl:getBaseInfo().gold
					local maxBuy = math.min(math.floor(haveGold / self.singleData.price), maxCount)
					_ENV = i18n(tipKey, nil)
					_ENV, i18n(tipKey, nil).labelName = self:getItemName(), self:getItemName()
					self:getItemName().id = self.singleData.itemId
					self:getItemName().originalPrice = self.singleData.originalPrice
					self:getItemName().price = self.singleData.price
					self:getItemName().max = maxBuy
					_ENV, i18n(tipKey, nil).itemData, self:getItemName().cur = self:getItemName(), self:getItemName(), maxBuy
					i18n(tipKey, nil).otherData, self:getItemName().curValue = self:getItemName(), 1
					i18n(tipKey, nil).buyHandle = function(num)
						SoraDShowLoading()
						legendShopCtrl:sendBuy(self.singleData.shopItemID, num)
					end
					uiManager:show("newShopSingleBuy", i18n(tipKey, nil))
				else
					SoraDShowHelpMsgTip(i18n("worldshop_text_05"))
				end
			end
		end
	end
end
function legendaryShopSingle:getItemName(...)
	local itemName = publicRead.getName(self.singleData.itemId)
	local resDesRead = include("resDesRead")
	if resDesRead.checkResID(self.singleData.itemId) then
		itemName = SoraDConvertNumberWithUnit(self.singleData.itemNum) .. itemName
	end
	return itemName
end
return legendaryShopSingle
