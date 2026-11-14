local baseComponent = require("fgui.base.baseComponent")
local ComHistory = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComHistory", ComHistory)
function ComHistory:onInit()
	self.fields.listHistory:setItemRenderer(handler(self, self.itemRenderer_listHistory))
	self.fields.listHistory:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClick_listHistory))
	self.fields.btnHide:addClickListener(handler(self, self.onClick_btnHide))
end
function ComHistory:onShow()
end
function ComHistory:onClick_btnHide(...)
	local proxy = uiManager:getProxy("FarmTrade")
	if proxy then
		if self.type == "history" then
			proxy:hideSearchHistory()
		elseif self.type == "candidate" then
			proxy:hideCandidate()
		end
	end
end
function ComHistory:onClick_listHistory(context)
	if self.type == "history" then
		uiManager:getProxy("FarmTrade"):search(context.data.data)
	elseif self.type == "candidate" then
		_ENV = uiManager:getProxy("FarmTrade")
		uiManager:getProxy("FarmTrade").msg = "MESSAGE_MANOR_FARM_SEARCH_SEED_CANDIDATE"
		uiManager:getProxy("FarmTrade").data = context.data.data
		SoraDSendMessage((uiManager:getProxy("FarmTrade")))
	end
end
function ComHistory:itemRenderer_listHistory(index, obj)
	obj.data = self.data[index + 1]
	obj:setTitle(i18n(self.data[index + 1].name))
end
function ComHistory:initData(historys)
	self.type = "history"
	self.data = historys
	self.fields.listHistory:setNumItems(#self.data)
	self.fields.listHistory:ResizeToFit(#self.data)
end
function ComHistory:initData_candidate(data)
	self.type = "candidate"
	self.data = data
	self.fields.listHistory:setNumItems(#self.data)
	self.fields.listHistory:ResizeToFit(#self.data)
end
return ComHistory
