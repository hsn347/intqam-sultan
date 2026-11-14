local activity_9001727_Ctrl = SoraDGetCtrl("activity_9001727_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_lvSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001727/Com_lvSingle", Com_lvSingle)
function Com_lvSingle:onInit()
end
function Com_lvSingle:onShow()
end
function Com_lvSingle:initData(data)
	self.fields.Text_lv:setString("lv" .. "\n" .. data.lv)
	local normal = data.bronzeAward[1]
	self.fields.item_normal:initData(normal.id, normal.count)
	local status_nor = activity_9001727_Ctrl:getLvStatus(data.lv, false)
	self.fields.item_normal:setStatus(status_nor)
	local adv = data.goldAward1[1]
	self.fields.item_adv:initData(adv.id, adv.count)
	local status_adv = activity_9001727_Ctrl:getLvStatus(data.lv, true)
	self.fields.item_adv:setStatus(status_adv)
end
return Com_lvSingle
