local sheepRunCtrl = SoraDGetCtrl("sheepRunCtrl")
local sheepRunRead = include("sheepRunRead")
local sheepRunReward = class("sheepRunReward", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sheepRunReward")
end)
function sheepRunReward:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("common_text_2078"))
	self.textTips = SoraDGetChildByName(self, "Text_tips2")
	self.textTips:setString(i18n("runningSheep_text_30"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btn_go = SoraDGetChildByName(self, "Button_receive")
	self.btn_go:addTouchEventListener(handler(self, self.onBtnGo))
	self.btn_go:setTitleText(i18n("common_text_054"))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
end
function sheepRunReward:onMessageListener()
end
function sheepRunReward:initData(rewards)
	self.items, _ENV = nil, nil
	for i, v in ipairs(rewards) do
		local newItem = self.tmpItem:clone()
		newItem:setScale(0.8)
		local item = include("commonItemAward").new(SoraDGetChildByName(newItem, "Item"))
		item:setBaseScale(1)
		item:setOwnView(self)
		item:initData(v.id, v.count)
		if v.heightlight then
			item:showLightEffect()
		end
		local Image_multi = SoraDGetChildByName(newItem, "Image_multi")
		local Text_multi = SoraDGetChildByName(newItem, "Text_multi")
		if 1 < v.multi then
			Image_multi:setVisible(true)
			Text_multi:setVisible(true)
			Text_multi:setString("X" .. v.multi)
		else
			Image_multi:setVisible(false)
			Text_multi:setVisible(false)
		end
		newItem:addTo(self.nodeAward)
		table.insert(self.items, newItem)
	end
	self.nodeAward:setAnchorPoint(cc.p(0.5, 1))
	if SoraDFIsRA() then
		SoraDautoSortPos(self.nodeAward, 5, 2, cc.size(100, 98), SoraDFIsRA())
	else
		SoraDautoSortPos(self.nodeAward, 5, 0, cc.size(100, 98), SoraDFIsRA())
	end
	self.nodeAward:setPositionY(290 - 100 * math.floor(#rewards / 5 + 0.99999) / 2)
end
function sheepRunReward:onBtnGo(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
return sheepRunReward
