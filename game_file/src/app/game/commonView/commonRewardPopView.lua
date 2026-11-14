local commonRewardPopView = class("commonRewardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonRewardPopView")
	end
	return target
end)
function commonRewardPopView:ctor()
	self:initWidget()
end
function commonRewardPopView:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_1235"))
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Node_reward = SoraDGetChildByName(self, "Node_reward")
	self.Button_receive = SoraDGetChildByName(self, "Button_receive")
	self.Button_receive:addTouchEventListener(handler(self, self.onClickReceive))
end
function commonRewardPopView:initData(data)
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
	local align = data.align or SoraDFIsRA() and 2 or 0
	local itemSize = cc.size(103, 103)
	local lineNum = 5
	SoraDautoSortPos(self.Node_reward, lineNum, align, itemSize)
	self:setTextDes(data.des)
	self:setTitleName(data.title)
	self:setButtonText(data.btnText)
	local maxH = math.ceil(#rewards / lineNum)
	local totalH = maxH * itemSize.height
	local rewardY = -107 - totalH / 2 + itemSize.height / 2
	self.Node_reward:setPositionY(rewardY)
	local poy = (maxH - 1) * itemSize.height
	self.Button_receive:setPositionY(-poy - 207)
	local bgH = 520 + (maxH - 3) * itemSize.height + 20
	if not self.Button_receive:isVisible() then
		bgH = bgH - 80
	end
	if not self.Text_des:isVisible() then
		bgH = bgH - 63
	end
	self.ccs_bg:setSize(cc.size(self.ccs_bg:getSize().width, bgH))
	local bgY = -bgH / 2 + 10
	self.ccs_bg:setPositionY(bgY)
	if self.Text_des:isVisible() then
		bgY = bgY - 63
	end
	self.Node_content:setPositionY(bgY + bgH)
	if bgH > display.height - 50 then
		self.Center_Node = SoraDGetChildByName(self, "Center_Node")
		self.Center_Node:setScale((display.height - 50) / bgH)
	end
end
function commonRewardPopView:setTextDes(des)
	if des then
		self.Text_des:setVisible(true)
		self.Text_des:setString(des)
	else
		self.Text_des:setVisible(false)
	end
end
function commonRewardPopView:setTitleName(title)
	if title then
		self.ccs_bg:setTitleName(title)
	end
end
function commonRewardPopView:setButtonText(btnText)
	if btnText then
		self.Button_receive:setVisible(true)
		self.Button_receive:setTitleText(btnText)
	else
		self.Button_receive:setVisible(false)
	end
end
function commonRewardPopView:onClickReceive(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle()
		end
		self:close(button, type)
	end
end
return commonRewardPopView
