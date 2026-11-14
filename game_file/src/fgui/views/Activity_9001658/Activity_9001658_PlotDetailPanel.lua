local activity_9001658_Read = include("activity_9001658_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001658_PlotDetailPanel = class("Activity_9001658_PlotDetailPanel", baseFguiPanel)
function Activity_9001658_PlotDetailPanel:ctor(...)
	Activity_9001658_PlotDetailPanel.super.ctor(self, ...)
	print("Activity_9001658_PlotDetailPanel:ctor", self.viewName)
end
function Activity_9001658_PlotDetailPanel:onInit()
	print("=======Activity_9001658_PlotDetailPanel:onInit")
	local chapter = self.param and self.param.chapter or 1
	self.storyID = chapter
	local nameStr = activity_9001658_Read.getChapterName(chapter)
	self.fields.Com_title:initData(nameStr, handler(self, self.onClickClose))
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001658_PlotDetailPanel:onShow()
	print("=======Activity_9001658_PlotDetailPanel:onShow")
	self.dataList = activity_9001658_Read.getStoryConfig(self.storyID)
	self.fields.List:setNumItems(#self.dataList)
end
function Activity_9001658_PlotDetailPanel:onItemProvider(index)
	local cfg = self.dataList[index + 1]
	local showType = cfg.showType or 1
	return "ui://Activity_9001658/Com_dailog" .. showType
end
function Activity_9001658_PlotDetailPanel:onItemRenderer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local cfg = self.dataList[index + 1]
	local showType = cfg.showType or 1
	if showType == 1 then
		obj:setString(i18n(cfg.text))
	elseif showType == 2 or showType == 3 then
		obj:setString(i18n(cfg.text))
		local name = activity_9001658_Read.getCharacterName(cfg.characterID)
		_fields.Text_name:setString(name)
		local bustSmall = activity_9001658_Read.getCharacterSmallBust(cfg.characterID)
		obj:setIcon(bustSmall)
	elseif showType == 4 then
		obj:setIcon(cfg.pic)
		obj:setString(i18n(cfg.text))
	end
end
return Activity_9001658_PlotDetailPanel
