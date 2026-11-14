local baseProxy = require("fgui.base.baseProxy")
local Activity_9001573_ChooseProxy = class("Activity_9001573_ChooseProxy", baseProxy)
function Activity_9001573_ChooseProxy:onRegisterEvent()
	print("=======Activity_9001573_ChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.onMsgSearchBack))
end
function Activity_9001573_ChooseProxy:onMsgSearchBack(target, event)
	SoraDCloseLoading(self.view:displayObject())
	local retdata = event.data
	self.view.nextIndex = retdata.nextindex
	if not event.data.uinfolist then
		local _ENV, uinfolist = event.data.uinfolist, event.data.uinfolist
	end
	for i, v in ipairs(uinfolist) do
		v.kid = v.partition
		v.headid = v.iconID
	end
	self.view:refreshMemberList(uinfolist)
end
return Activity_9001573_ChooseProxy
