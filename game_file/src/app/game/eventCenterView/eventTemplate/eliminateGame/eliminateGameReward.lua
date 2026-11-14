local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local siegeCombatCtrl = gametop.playertop_:getModule("siegeCombatCtrl")
local EliminateGameReward = class("eliminateGameReward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eliminateGameReward")
	end
	return target
end)
_ENV = "eliminateGameReward"
;("eliminateGameReward").begin = 320
;("eliminateGameReward").dis = 48
local ("eliminateGameReward").size, giftPosMsg = 94, "eliminateGameReward"
function EliminateGameReward:ctor()
	self.scroll = SoraDGetChildByName(self, "ScrollView_reward")
	self.text_title = SoraDGetChildByName(self, "Text_title")
	self.text_title:setString(i18n("common_text_2798"))
	self.btnConfirm = SoraDGetChildByName(self, "Button_gain")
	self.btnConfirm:addTouchEventListener(handler(self, self.onClose))
	self.btnConfirm:setTitleText(i18n("common_text_204"))
end
function EliminateGameReward:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_ELIMINATEGAME_SHOW_ITEMINFO", handler(self, self.openItemInfo))
	SoraDAddMessage(self, "MESSAGE_UI_ELIMINATEGAME_CLOSE_ITEMINFO", handler(self, self.closeItemInfo))
end
function EliminateGameReward:sortItem(data)
	_ENV = nil
	;(nil)["frame_item_base_01.png"] = 1
	;(nil)["frame_item_base_02.png"] = 2
	;(nil)["frame_item_base_03.png"] = 3
	;(nil)["frame_item_base_04.png"] = 4
	;(nil)["frame_item_base_05.png"] = 5
	local (nil)["frame_item_base_06.png"], values = 6, nil
	table.sort(data, function(a, b)
		return values[publicRead.getBg(a.id)] > values[publicRead.getBg(b.id)]
	end)
end
function EliminateGameReward:initData(data)
	self.scroll:removeAllChildren()
	self:sortItem(data)
	local scrollH = math.max(self.scroll:getContentSize().height, 100 * math.ceil(#data / 5))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	self.scroll:setBounceEnabled(self.scroll:getInnerContainerSize().height > self.scroll:getContentSize().height)
	for k, v in ipairs(data) do
		local line = math.ceil(k / 5)
		local row = k % 5 == 0 and 5 or k % 5
		local itemAward = include("commonItemAward").new()
		itemAward:setScale(0.8)
		itemAward:setBaseScale(1.0)
		itemAward:setOwnView(self)
		itemAward:initData(v.id, v.count)
		itemAward:setPosition(SoraDFPoint(50 + (row - 1) * 100, scrollH - line * 100 + 50, 500))
		itemAward:addTo(self.scroll)
	end
end
function EliminateGameReward:getRewardItem(reawrdData)
	local eliminateGameRewardItem = include("eliminateGameRewardItem")
	local itemNode = eliminateGameRewardItem.new()
	itemNode:initWithData(reawrdData)
	itemNode:setScale(90 / itemNode:getItemWidth())
	itemNode:setCascadeOpacityEnabled(true)
	return itemNode
end
function EliminateGameReward:onClose(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function EliminateGameReward:openItemInfo(target, data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	self.itemTips:initData(itemID)
end
function EliminateGameReward:closeItemInfo(target, data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
return EliminateGameReward
