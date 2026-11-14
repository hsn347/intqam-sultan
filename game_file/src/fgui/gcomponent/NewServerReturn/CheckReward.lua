local baseComponent = require("fgui.base.baseComponent")
local CheckReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/CheckReward", CheckReward)
local newServerPetCtrl = SoraDGetCtrl("newServerPetCtrl")
local newServerPetRead = include("newServerPetRead")
local publicRead = include("publicRead")
function CheckReward:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.Panel_bg:setTitle(i18n("return_lcks_text_026"))
	self.fields.Text_reward_1:setString(i18n("return_lcks_text_029"))
	self.fields.Text_tip_1:setString(i18n("kits_text_07"))
	self.fields.Text_reward_2:setString(i18n("return_lcks_text_027"))
	self.fields.Text_tip_2:setString(i18n("kits_text_07"))
	self.fields.scroll_1:setItemRenderer(handler(self, self.cellRender1))
	self.fields.scroll_2:setItemRenderer(handler(self, self.cellRender2))
end
function CheckReward:onShow()
	self.rewards = newServerPetRead.getReturnCatRewardConfig()
	self.fields.scroll_1:setNumItems(#self.rewards.highWalkReward)
	self.fields.scroll_2:setNumItems(#self.rewards.lowWalkReward)
end
function CheckReward:cellRender1(index, item)
	local data = self.rewards.highWalkReward[index + 1]
	self:setItem(item, data)
end
function CheckReward:cellRender2(index, item)
	local data = self.rewards.lowWalkReward[index + 1]
	self:setItem(item, data)
end
function CheckReward:setItem(obj, data)
	if not SoraDFIsRA() then
		obj:fixChildrenPos(true, true)
	end
	local itemObj = fguiHelper.get_fields(obj).item
	itemObj:initData(data.id)
	local item_des = fguiHelper.get_fields(obj).item_des
	item_des:setString(publicRead.getDes(data.id))
	local item_num = fguiHelper.get_fields(obj).item_num
	item_num:setString("x" .. data.count)
end
return CheckReward
