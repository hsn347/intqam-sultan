local baseFguiPanel = require("fgui.base.baseFguiPanel")
local wastelandHelpPanel = class("wastelandHelpPanel", baseFguiPanel)
function wastelandHelpPanel:ctor(...)
	self.super.ctor(self, ...)
	print("wastelandHelpPanel:ctor", self.viewName)
end
function wastelandHelpPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "wasteland"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "WiseTutor"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
	end
	return self._packageList
end
function wastelandHelpPanel:onInit()
	print("=======wastelandHelpPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_001"))
	local Com_help = self.fields.Com_help
	Com_help:getChild("Text_des"):setString(i18n("wasteland_text_001"))
	_UPVALUE3_ = Com_help:getChild("Text_des").setString
	Com_help:getChild("Text_des").setString[1] = "common_text_748"
	Com_help:getChild("Text_des").setString[2] = "wasteland_text_003"
	local Com_help:getChild("Text_des").setString[3], config = "wasteland_text_002", Com_help:getChild("Text_des").setString
	for i, v in ipairs(config) do
		local Text = Com_help:getChild("Text_" .. i)
		Text:setString(i18n(v))
		Text:fixPos()
	end
	self.helpData = self.proxy:getHelpData()
	local Scroll_help = Com_help:getChild("Scroll_help")
	Scroll_help:setItemRenderer(handler(self, self.onNormalItemRenderer))
	Scroll_help:setNumItems(#self.helpData)
end
function wastelandHelpPanel:onShow()
	print("=======wastelandHelpPanel:onShow")
end
function wastelandHelpPanel:onNormalItemRenderer(index, obj)
	local lv = index + 1
	local data = self.helpData[lv]
	obj:getChild("Text_3"):setString(lv)
	obj:getChild("Text_2"):setString(string.formatnumberthousands(data.monsterpoint))
	obj:getChild("Text_1"):setString(string.formatnumberthousands(data.bosspoint))
	obj:getController("c1"):setSelectedIndex(index % 2)
	obj:fixChildrenPos()
end
return wastelandHelpPanel
