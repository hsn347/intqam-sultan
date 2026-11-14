local baseComponent = require("fgui.base.baseComponent")
local heroLockFJItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/heroLockFJItem", heroLockFJItem)
function heroLockFJItem:onInit()
end
function heroLockFJItem:onShow()
end
function heroLockFJItem:getItem()
	return self.fields.heroItem
end
return heroLockFJItem
