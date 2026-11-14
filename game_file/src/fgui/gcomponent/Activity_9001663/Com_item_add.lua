local baseComponent = require("fgui.base.baseComponent")
local Com_item_add = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001663/Com_item_add", Com_item_add)
function Com_item_add:onInit()
	self.isForbid = false
	self.fields.Com_add:addClickListener(handler(self, self.btnAddClick))
	self.fields.Com_item:setClickCallback(handler(self, self.btnAddClick))
end
function Com_item_add:onShow()
end
function Com_item_add:setActivityID(activityID)
	self.activityID = activityID
end
function Com_item_add:initData(id, enum, chooseMap)
	self.id = id
	self.enum = enum
	self.chooseMap = chooseMap
	self.controllers.c1:setSelectedIndex(self.id and 1 or 0)
	self.fields.title:setString(self.enum == 1 and i18n("bubble_party_text_14") or i18n("bubble_party_text_15"))
	if self.id then
		self.fields.Com_item:initData(self.id)
	end
end
function Com_item_add:setForbid(ret)
	self.isForbid = ret
end
function Com_item_add:btnAddClick()
	if self.isForbid then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).id = self.id
	;(nil).enum = self.enum
	;(nil).chooseMap = self.chooseMap
	uiManager:show("Activity_9001663_choose", nil)
end
return Com_item_add
