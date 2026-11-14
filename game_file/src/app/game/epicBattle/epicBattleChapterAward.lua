local epicBattleChapterAward = class("epicBattleChapterAward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleChapterAward")
	end
	return target
end)
function epicBattleChapterAward:ctor()
	self.data, _ENV = nil, nil
	SoraDGetChildByName(self, "Image_contentBg"):setFillType(1)
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_title:setString(i18n("epicbattle_text_03"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_reward")
	self.Node_star = SoraDGetChildByName(self, "Node_star")
	self.Text_star = SoraDGetChildByName(self.Node_star, "Text_star")
	self.Text_star_max = SoraDGetChildByName(self.Node_star, "Text_star_max")
	self.Button_gain = SoraDGetChildByName(self, "Button_gain")
	self.Button_gain:addTouchEventListener(handler(self, self.onBtnClickBack))
end
function epicBattleChapterAward:initData(data)
	self.data = data
	self.Text_star:setString(self.data.ownScore)
	self.Text_star:setColor(self.data.ownScore >= self.data.maxStar and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	self.Text_star_max:setString("/" .. self.data.maxStar)
	if self.data.isPass then
		if self.data.isGetReward then
			self.Button_gain:setTitleText(i18n("common_text_1892"))
			self.Button_gain:setBright(false)
			self.Button_gain:setTouchEnabled(false)
			self.Button_gain:setTitleColor(cc.c3b(120, 120, 120))
		else
			self.Button_gain:setTitleText(i18n("common_text_1146"))
			self.Button_gain:setBright(true)
			self.Button_gain:setTouchEnabled(true)
			self.Button_gain:setTitleColor(cc.c3b(255, 255, 255))
		end
	else
		self.Button_gain:setTitleText(i18n("common_text_1146"))
		self.Button_gain:setBright(false)
		self.Button_gain:setTouchEnabled(false)
		self.Button_gain:setTitleColor(cc.c3b(120, 120, 120))
	end
	self:setAwards()
end
function epicBattleChapterAward:setAwards()
	local scrollH = math.max(self.scroll:getContentSize().height, 100 * math.ceil(#self.data.award / 5))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	self.scroll:setBounceEnabled(self.scroll:getInnerContainerSize().height > self.scroll:getContentSize().height)
	for k, v in ipairs(self.data.award) do
		local line = math.ceil(k / 5)
		local row = k % 5 == 0 and 5 or k % 5
		local itemAward = include("commonItemAward").new()
		itemAward:setScale(0.8)
		itemAward:setBaseScale(1.0)
		itemAward:setOwnView(self)
		itemAward:initData(v.id, v.count)
		itemAward:setPosition(50 + (row - 1) * 100, scrollH - line * 100 + 50)
		itemAward:addTo(self.scroll)
	end
end
function epicBattleChapterAward:onBtnClickBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
		epicWarCtrl:sendReqClaimChapterReward(self.data.index)
		self:removeFromParent()
	end
end
return epicBattleChapterAward
