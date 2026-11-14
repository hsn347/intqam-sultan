local activity_9001700_Read = include("activity_9001700_Read")
local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001700_BagPanel = class("Activity_9001700_BagPanel", baseFguiPanel)
function Activity_9001700_BagPanel:ctor(...)
	self.isLRU = true
	Activity_9001700_BagPanel.super.ctor(self, ...)
	print("Activity_9001700_BagPanel:ctor", self.viewName)
	self.curTag = 1
end
function Activity_9001700_BagPanel:onInit()
	print("=======Activity_9001700_BagPanel:onInit")
	self.fields.Panel_bg:setString(i18n("eid_fireworks_004"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Text_noData:setString(i18n("eid_fireworks_016"))
end
function Activity_9001700_BagPanel:endShow()
	print("=======Activity_9001700_BagPanel:endShow")
	_ENV = print
	_ENV, _ENV, print.defaultClick = nil, "=======Activity_9001700_BagPanel:endShow", 1
	_ENV, ("=======Activity_9001700_BagPanel:endShow")[1], (nil).title = nil, nil, i18n("eid_fireworks_012")
	print.tabsetArray, ("=======Activity_9001700_BagPanel:endShow")[2], (nil).title = "=======Activity_9001700_BagPanel:endShow", nil, i18n("eid_fireworks_013")
	local print.callback, param = handler(self, self.onClickTab), print
	self.fields.com_TabW:initView(param)
	local ret = activity_9001700_Ctrl:getBtnBagRedNum()
	self.fields.com_TabW:setBtnRedDot(2, ret)
end
function Activity_9001700_BagPanel:onClickTab(tag)
	print("==Activity_9001700_BagPanel:onClickTab==", tag)
	self.curTag = tag
	self:updateShowList()
	if self.curTag == 2 then
		activity_9001700_Ctrl:setReadTime()
		self.fields.com_TabW:setBtnRedDot(2, false)
	end
end
function Activity_9001700_BagPanel:updateShowList(ignoreReset)
	local activity_9001700_Ctrl, showList
	if self.curTag == 1 then
		showList = activity_9001700_Ctrl:getMakedSaluteList()
	else
		showList = activity_9001700_Ctrl:getRecievedSaluteList()
	end
	self.showList = showList
	self.fields.List:setNumItems(#showList)
	self.fields.Text_noData:setVisible(#showList <= 0)
	self.fields.Com_fireworkInfo:setVisible(0 < #showList)
	if 0 < #showList then
		if not ignoreReset then
			self.fields.List:setSelectedIndex(0)
		end
		self:updateFireworkInfo()
	end
end
function Activity_9001700_BagPanel:onItemRenderer(index, obj)
	local data = self.showList[index + 1]
	local Com_firework = obj:getChild("Com_firework")
	Com_firework:initFireWorksID(data.saluteId)
end
function Activity_9001700_BagPanel:onClickItem(EventContext)
	SoraDPlaySound()
	self:updateFireworkInfo()
end
function Activity_9001700_BagPanel:updateFireworkInfo(...)
	local idx = self.fields.List:getSelectedIndex() + 1
	local data = self.showList[idx]
	self.fields.Com_fireworkInfo:initFireWorksInfo(self.curTag, idx, data)
end
function Activity_9001700_BagPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "give" then
		self:updateShowList(true)
	end
end
return Activity_9001700_BagPanel
