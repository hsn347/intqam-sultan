local baseProxy = require("fgui.base.baseProxy")
local heroMskillFeedViewProxy = class("heroMskillFeedViewProxy", baseProxy)
function heroMskillFeedViewProxy:onRegisterEvent()
	print("=======heroMskillFeedViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_FEED_SKILL", handler(self, self.refreshView))
end
function heroMskillFeedViewProxy:refreshView(target, data)
	self.view:refreshView(target, data)
end
return heroMskillFeedViewProxy
