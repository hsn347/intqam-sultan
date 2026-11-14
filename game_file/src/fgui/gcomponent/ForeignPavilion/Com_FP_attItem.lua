local baseComponent = require("fgui.base.baseComponent")
local Com_FP_attItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_attItem", Com_FP_attItem)
function Com_FP_attItem:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_FP_attItem:onShow()
end
function Com_FP_attItem:initData(str, isUnlock, isCur)
	self.fields.text:setString(str)
	self.fields.text:setColor(isUnlock and cc.c3b(255, 255, 255) or cc.c3b(197, 197, 197))
	self.fields.lock:setVisible(not isUnlock)
	self.fields.unlock:setVisible(isUnlock)
end
return Com_FP_attItem
