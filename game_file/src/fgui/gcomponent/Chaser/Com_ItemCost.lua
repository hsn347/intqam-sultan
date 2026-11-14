local baseComponent = require("fgui.base.baseComponent")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local Com_ItemCost = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_ItemCost", Com_ItemCost)
function Com_ItemCost:onInit()
end
function Com_ItemCost:onShow()
end
function Com_ItemCost:initData(data)
	self.fields.Com_item:initData(data.id)
	local myCount = backpackCtrl:getItemCount(data.id)
	backpackCtrl = nil
	;(nil).var1 = fguiHelper.getColorString(myCount >= data.count and "#FFFFFF" or "#E02B2B", myCount)
	;(nil).var2 = data.count
	self.fields.Text_num:setString(i18n("%{var1}/%{var2}", nil))
end
return Com_ItemCost
