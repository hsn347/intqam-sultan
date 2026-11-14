local activity_9001639_Read = include("activity_9001639_Read")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001639_CumuPopPanel = class("Activity_9001639_CumuPopPanel", baseFguiPanel)
function Activity_9001639_CumuPopPanel:ctor(...)
	Activity_9001639_CumuPopPanel.super.ctor(self, ...)
	print("Activity_9001639_CumuPopPanel:ctor", self.viewName)
end
function Activity_9001639_CumuPopPanel:onInit()
	print("=======Activity_9001639_CumuPopPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("eidal_market_text1"))
	self.fields.Lab_title:setString(i18n("eidal_market_text4"))
	self.fields.Text_tip:setString(i18n("eidal_market_text2"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001639_CumuPopPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function Activity_9001639_CumuPopPanel:onShow()
	print("=======Activity_9001639_CumuPopPanel:onShow")
	local cfg = activity_9001639_Read.getDailyCfgByIndex(1)
	local items = backpackltCtrl:getShowItems(cfg.reward[1])
	for k, v in ipairs(items) do
		v.count = v.count * cfg.reward[2]
		table.insert(self.itemList, v)
	end
	self.fields.List:setNumItems(#self.itemList)
end
return Activity_9001639_CumuPopPanel
