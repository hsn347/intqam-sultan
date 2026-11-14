local baseComponent = require("fgui.base.baseComponent")
local Com_9001624_itemLevel = fgui.extension_class(fgui.GButton, baseComponent)
local activity_9001624_Ctrl = SoraDGetCtrl("activity_9001624_Ctrl")
fgui.register_extension("ui://Activity_9001624/Com_9001624_itemLevel", Com_9001624_itemLevel)
function Com_9001624_itemLevel:onInit()
	if self.fields.Icon_lock_1 then
		self.fields.Icon_lock_1:fix(false)
	end
	self:addClickListener(handler(self, self.onClickReward))
	self.fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
end
function Com_9001624_itemLevel:onShow()
end
function Com_9001624_itemLevel:initData(index, data, hadGet, unlock, isCanGet)
	self.unlock = unlock
	self.hadGet = hadGet
	self.fields.Com_item:initData(data.id, data.count)
	if unlock ~= nil and unlock == false then
		self.controllers.state:setSelectedIndex(0)
	elseif isCanGet then
		self.controllers.state:setSelectedIndex(hadGet == true and 2 or 1)
	else
		self.controllers.state:setSelectedIndex(3)
	end
end
function Com_9001624_itemLevel:onClickReward()
end
function Com_9001624_itemLevel:onShow()
end
return Com_9001624_itemLevel
