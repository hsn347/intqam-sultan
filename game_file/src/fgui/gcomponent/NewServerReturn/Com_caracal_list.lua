local baseComponent = require("fgui.base.baseComponent")
local Com_caracal_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_caracal_list", Com_caracal_list)
function Com_caracal_list:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_caracal_list:onShow()
end
function Com_caracal_list:initData(data, isUnlock, isGot, tipStr)
	if data.type ~= 1 then
		self.fields.pet_lv:setString("" .. data.lv .. "+")
		self.controllers.c1:setSelectedIndex(2)
		self:setItem(self.fields.item_1_1, data.uplvReward[1], true, false)
		self.fields.text_tip:setString(tipStr)
		return
	else
		self.fields.pet_lv:setString(data.lv)
		self.controllers.c1:setSelectedIndex(1 < #data.highReward and 0 or 1)
		self.controllers.c3:setSelectedIndex(1 < #data.lowReward and 0 or 1)
		self:setItem(self.fields.item_1, data.highReward[1], isUnlock, isGot)
		self:setItem(self.fields.item_2, data.highReward[2], isUnlock, isGot)
		self:setItem(self.fields.item_3, data.lowReward[1], true, isGot)
		self:setItem(self.fields.item_3_1, data.lowReward[1], true, isGot)
		self:setItem(self.fields.item_4, data.lowReward[2], true, isGot)
	end
end
function Com_caracal_list:setItem(itemObj, itemData, isUnlock, isGot)
	if not itemData or not itemObj then
		return
	end
	local ctrl = fguiHelper.get_controllers(itemObj).c1
	local com_item = fguiHelper.get_fields(itemObj).item
	if isUnlock then
		ctrl:setSelectedIndex(isGot and 2 or 0)
	else
		ctrl:setSelectedIndex(1)
	end
	com_item:initData(itemData.id, itemData.count)
	if not isUnlock then
		com_item:setClickCallback(handler(self, self.clickCallback))
	else
		com_item:setClickCallback(nil)
	end
end
function Com_caracal_list:clickCallback()
	SoraDShowMsgTip(i18n("return_lcks_text_022"))
end
return Com_caracal_list
