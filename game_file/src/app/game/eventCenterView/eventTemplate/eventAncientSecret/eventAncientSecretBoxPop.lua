local publicRead = include("publicRead")
local eventAncientSecretBoxPop = class("eventAncientSecretBoxPop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventAncientSecretBoxPop")
	end
	return target
end)
function eventAncientSecretBoxPop:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("AncienTreasure_btn_04"))
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("AncienTreasure_text_17"))
	self.Node_reward = SoraDGetChildByName(self, "Node_reward")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
end
function eventAncientSecretBoxPop:initData(info, isActive)
	local statusStr = isActive and i18n("AncienTreasure_text_15") or i18n("AncienTreasure_text_16")
	self.Text_status:setString(statusStr)
	self.Text_status:setColor(isActive and cc.c3b(215, 195, 155) or cc.c3b(190, 40, 40))
	_UPVALUE2_ = isActive and cc.c3b(215, 195, 155) or cc.c3b(190, 40, 40)
	;(isActive and cc.c3b(215, 195, 155) or cc.c3b(190, 40, 40))[1] = "id"
	;(isActive and cc.c3b(215, 195, 155) or cc.c3b(190, 40, 40))[2] = "count"
	local reward = serviceFunctions.tableFormat(info.reward, isActive and cc.c3b(215, 195, 155) or cc.c3b(190, 40, 40))
	for k, v in ipairs(reward) do
		if k == 1 then
			self:setItemInfo(self.Node_item, v)
		else
			local cloneItem = self.Node_item:clone()
			cloneItem:setPositionY(0)
			cloneItem:addTo(self.Node_reward)
			self:setItemInfo(cloneItem, v)
		end
	end
	SoraDToCenter(self.Node_reward, 120, not SoraDFIsRA())
end
function eventAncientSecretBoxPop:setItemInfo(target, info)
	local item = SoraDGetExtendChildFromCCSByName(target, "CCS_commonItemAward_item")
	local name = SoraDGetChildByName(target, "Text_itemName")
	item:setOwnView(self)
	item:initData(info.id, info.count)
	item:setScale(0.8)
	item:setBaseScale(1.0)
	name:setString(publicRead.getName(info.id))
end
return eventAncientSecretBoxPop
