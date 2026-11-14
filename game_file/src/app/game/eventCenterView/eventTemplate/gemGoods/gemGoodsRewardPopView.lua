local gemGoodsRewardPopView = class("gemGoodsRewardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("gemGoodsRewardPopView")
	end
	return target
end)
function gemGoodsRewardPopView:ctor()
	self.isTranslucentView = true
	self:runAction(cca.callFunc(function()
		self:setBackGroundColorOpacity(0)
	end))
	self:initWidget()
end
function gemGoodsRewardPopView:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_1235"))
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.scroll = SoraDGetChildByName(self, "ScrollView_items")
	self.Node_reward = SoraDGetChildByName(self, "Node_reward")
end
function gemGoodsRewardPopView:initData(data)
	self.handle = data.handle
	if not data.rewards then
		local _ENV, rewards = data.rewards, data.rewards
	end
	for k, v in ipairs(rewards) do
		local single = SoraDCreatePanel("commonItemAward")
		single:addTo(self.Node_reward)
		single:setOwnView(self)
		single:initData(v.id, v.count)
		single:setScale(0.88)
	end
	local align = SoraDFIsRA() and 2 or 0
	local itemSize = cc.size(103, 103)
	local lineNum = 5
	SoraDautoSortPos(self.Node_reward, lineNum, align, itemSize)
	self:setTextDes(data.des)
	self:setTitleName(data.title)
	local sSize = self.scroll:getContentSize()
	local maxH = math.ceil(#rewards / lineNum)
	local totalH = math.max(sSize.height, maxH * itemSize.height)
	self.scroll:setOpacity(255)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, totalH + 0))
	self.Node_reward:setPositionY(totalH / 2 + 40)
end
function gemGoodsRewardPopView:setTextDes(des)
	if des then
		self.Text_des:setVisible(true)
		self.Text_des:setString(des)
	else
		self.Text_des:setVisible(false)
	end
end
function gemGoodsRewardPopView:setTitleName(title)
	if title then
		self.ccs_bg:setTitleName(title)
	end
end
function gemGoodsRewardPopView:showEnterAction(beginPos)
	self.beginPos = beginPos or cc.p(display.cx, display.cy)
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Panel_black = SoraDGetChildByName(self, "Top_Size_Panel_black")
	self.Center_Node:setScale(0.09, 0.01)
	self.Center_Node:setOpacity(0)
	self.Center_Node:setPosition(self.beginPos)
	_UPVALUE1_ = 0.01
	_UPVALUE2_ = nil
	;(nil)[1] = cca.scaleTo(0.25, 1.0)
	;(nil)[2] = cca.fadeIn(0.08333333333333333)
	;(nil)[3] = cca.moveTo(0.25, display.cx, display.cy)
	;(nil)[4] = cca.moveTo(0.25, display.cx, display.cy)
	;(nil)[5] = cca.moveTo(0.25, display.cx, display.cy)
	;(nil)[6] = cca.moveTo(0.25, display.cx, display.cy)
	;(0.01)[1] = cca.delay(0.1)
	;(0.01)[2] = cca.spawn(nil)
	;(0.01)[3] = cca.spawn(nil)
	;(0.01)[4] = cca.spawn(nil)
	;(0.01)[5] = cca.spawn(nil)
	;(0.01)[6] = cca.spawn(nil)
	;(0.01)[7] = cca.spawn(nil)
	;(0.01)[8] = cca.spawn(nil)
	;(0.01)[9] = cca.spawn(nil)
	self.Center_Node:runAction(cca.seq(0.01))
	self.Panel_black:setOpacity(0)
	_UPVALUE1_ = cca.seq(0.01)
	cca.seq(0.01)[1] = cca.delay(0.03333333333333333)
	cca.seq(0.01)[2] = cca.fadeIn(0.3)
	cca.seq(0.01)[3] = cca.fadeIn(0.3)
	cca.seq(0.01)[4] = cca.fadeIn(0.3)
	cca.seq(0.01)[5] = cca.fadeIn(0.3)
	cca.seq(0.01)[6] = cca.fadeIn(0.3)
	cca.seq(0.01)[7] = cca.fadeIn(0.3)
	cca.seq(0.01)[8] = cca.fadeIn(0.3)
	cca.seq(0.01)[9] = cca.fadeIn(0.3)
	self.Panel_black:runAction(cca.seq(cca.seq(0.01)))
end
function gemGoodsRewardPopView:showExitAction(...)
	self.Center_Node:stopAllActions()
	self.Panel_black:stopAllActions()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.11666666666666667)
	;(nil)[2] = cca.fadeOut(0.08333333333333333)
	;(nil)[3] = cca.fadeOut(0.08333333333333333)
	self.Center_Node:runAction(cca.seq(nil))
	self.Center_Node:runAction(cca.scaleTo(0.2, 0.01))
	self.Center_Node:runAction(cca.moveTo(0.2, self.beginPos.x, self.beginPos.y))
	_UPVALUE1_ = cca.moveTo(0.2, self.beginPos.x, self.beginPos.y)
	cca.moveTo(0.2, self.beginPos.x, self.beginPos.y)[1] = cca.fadeOut(0.25)
	cca.moveTo(0.2, self.beginPos.x, self.beginPos.y)[2] = cca.callFunc(function()
		if self.exitHandle then
			self.exitHandle()
		end
		self:closePanel()
	end)
	cca.moveTo(0.2, self.beginPos.x, self.beginPos.y)[3] = cca.callFunc(function()
		if self.exitHandle then
			self.exitHandle()
		end
		self:closePanel()
	end)
	self.Panel_black:runAction(cca.seq(cca.moveTo(0.2, self.beginPos.x, self.beginPos.y)))
end
function gemGoodsRewardPopView:setExitHandle(exitHandle)
	self.exitHandle = exitHandle
end
function gemGoodsRewardPopView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		self:showExitAction()
	end
end
return gemGoodsRewardPopView
