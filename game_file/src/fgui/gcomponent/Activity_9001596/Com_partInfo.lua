local activity_9001596_Read = include("activity_9001596_Read")
local activity_9001596_Ctrl = SoraDGetCtrl("activity_9001596_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_partInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001596/Com_partInfo", Com_partInfo)
function Com_partInfo:onInit()
	self.reward, _ENV = nil, nil
	self.fields.Text_des1:setString(i18n("Ramadan_2024_text9"))
	self.fields.Text_award:setString(i18n("Ramadan_2024_text15"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_add:setString(i18n("common_text_4347"))
	self.fields.Btn_add:addClickListener(handler(self, self.btnAddClick))
	self.fields.Text_count:fixPos()
	self.fields.Btn_add:fixPos()
end
function Com_partInfo:onShow()
end
function Com_partInfo:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_partInfo:initData(part)
	self.part = part
	if self.part == 0 then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_name:setString(i18n("Ramadan_2024_text8"))
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_name:setString(activity_9001596_Read.getPartName(self.part))
		self.fields.Text_des2:setString(activity_9001596_Read.getPartDes(self.part))
		self.itemID = activity_9001596_Read.getPartID(self.part)
		local num = backpackCtrl:getItemCount(self.itemID)
		local need = activity_9001596_Read.getPartNum(self.part)
		_ENV = activity_9001596_Read.getPartDes(self.part)
		activity_9001596_Read.getPartDes(self.part).name = activity_9001596_Read.getPartName(self.part)
		activity_9001596_Read.getPartDes(self.part).num = fguiHelper.getColorString(num >= need and "#006E00" or "#A02828", num)
		activity_9001596_Read.getPartDes(self.part).need = need
		self.fields.Text_count:setString(i18n("Ramadan_2024_text49", activity_9001596_Read.getPartDes(self.part)))
		local isMerged = activity_9001596_Ctrl:isMerged(self.part)
		self.fields.Btn_add:setVisible(not isMerged)
		self.reward = activity_9001596_Read.getPartReward(self.part)
		self.fields.List:setNumItems(#self.reward)
	end
end
function Com_partInfo:btnAddClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).part = self.part
	uiManager:show("Activity_9001596_gain", nil)
end
return Com_partInfo
