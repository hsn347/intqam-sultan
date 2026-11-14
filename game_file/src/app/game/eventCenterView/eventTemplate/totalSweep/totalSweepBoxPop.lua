local gametop = gModuleMgr.getObject("gametop")
local annihilationCtrl = gametop.playertop_:getModule("annihilationCtrl")
local publicRead = include("publicRead")
local totalSweepBoxPop = class("totalSweepBoxPop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("totalSweepBoxPop")
	end
	return target
end)
function totalSweepBoxPop:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_059"))
	self.Node_reward = SoraDGetChildByName(self, "Node_reward")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Button_get = SoraDGetChildByName(self, "Button_get")
	self.Button_get:addTouchEventListener(handler(self, self.btnGetClick))
end
function totalSweepBoxPop:initData(data, status)
	self.data = data
	self.status = status
	self:setBtnStatus()
	self:setReward()
end
function totalSweepBoxPop:setReward()
	for k, v in ipairs(self.data.reward) do
		local item
		if k == 1 then
			item = self.Node_item
		else
			item = self.Node_item:clone()
			item:addTo(self.Node_reward)
		end
		local ccs_item = SoraDGetExtendChildFromCCSByName(item, "CCS_commonItemAward_item")
		ccs_item:setOwnView(self)
		ccs_item:initData(v.id, v.count)
		ccs_item:setBaseScale(1.0)
		local Text_itemName = SoraDGetChildByName(item, "Text_itemName")
		Text_itemName:setString(publicRead.getName(v.id))
		item:setScale(0.8)
	end
	SoraDautoSortPos(self.Node_reward, #self.data.reward, 1, cc.size(100, 100))
end
function totalSweepBoxPop:setBtnStatus()
	if self.status == gBtnTargetStatusDef.GOT then
		self.Button_get:setBright(false)
		self.Button_get:setTitleText(i18n("common_text_1892"))
	elseif self.status == gBtnTargetStatusDef.GET then
		self.Button_get:setBright(true)
		self.Button_get:setTitleText(i18n("common_text_1146"))
	else
		self.Button_get:setBright(true)
		self.Button_get:setTitleText(i18n("common_text_054"))
	end
end
function totalSweepBoxPop:btnGetClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.status == gBtnTargetStatusDef.GOT then
			SoraDShowMsgTip(i18n("common_text_1892"))
		elseif self.status == gBtnTargetStatusDef.GET then
			annihilationCtrl:sendReqClaimGiftMsg(self.data.index)
			self:close(button, event)
		else
			self:close(button, event)
		end
	end
end
return totalSweepBoxPop
