local baseProxy = require("fgui.base.baseProxy")
local ChatPopupMenuProxy = class("ChatPopupMenuProxy", baseProxy)
function ChatPopupMenuProxy:onRegisterEvent()
	print("=======ChatPopupMenuProxy:onRegisterEvent")
end
function ChatPopupMenuProxy:getBtnByTag(tag)
	return self.view:getBtnByTag(tag)
end
function ChatPopupMenuProxy:setHandle(handle)
	self.view:setHandle(handle)
end
return ChatPopupMenuProxy
