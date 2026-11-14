local activity_9001658_Read = include("activity_9001658_Read")
local activity_9001658_Ctrl = SoraDGetCtrl("activity_9001658_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001658_PlotMainPanel = class("Activity_9001658_PlotMainPanel", baseFguiPanel)
function Activity_9001658_PlotMainPanel:ctor(...)
	Activity_9001658_PlotMainPanel.super.ctor(self, ...)
	print("Activity_9001658_PlotMainPanel:ctor", self.viewName)
	self.debug = true
	self.curChapter = activity_9001658_Ctrl:getCurStage()
	self.chapterNewMap = activity_9001658_Ctrl:getChapterNewMap()
end
function Activity_9001658_PlotMainPanel:onInit()
	print("=======Activity_9001658_PlotMainPanel:onInit")
	self.fields.Com_title:initData(i18n("BUBBLE_LEGEND_TEXT_98"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function Activity_9001658_PlotMainPanel:onShow()
	print("=======Activity_9001658_PlotMainPanel:onShow")
	local stageMax = activity_9001658_Read.getStageMax()
	self.fields.List:setNumItems(stageMax)
	local jumpChapter = self.curChapter
	for chapter = 1, self.curChapter do
		if not self.chapterNewMap[chapter] then
			jumpChapter = chapter
			break
		end
	end
	self.fields.List:scrollToView(jumpChapter - 1)
end
function Activity_9001658_PlotMainPanel:onItemRenderer(index, obj)
	local width = obj:getWidth()
	if G_IS_UNITY and SoraDFIsRA() then
		obj:setPositionX(width * (index % 2))
	else
		obj:setPositionX(-width * (index % 2))
	end
	local c1 = obj:getController("c1")
	local chapter = index + 1
	if chapter <= self.curChapter then
		c1:setSelectedIndex(0)
	else
		c1:setSelectedIndex(1)
	end
	local nameStr = activity_9001658_Read.getChapterName(chapter)
	obj:setString(nameStr)
	local iconName = activity_9001658_Read.getChapterIcon(chapter)
	obj:setIcon(iconName)
	local Load_new = obj:getChild("Load_new")
	_UPVALUE2_ = nil
	;(nil)[1] = "ar"
	;(nil)[2] = "en"
	Load_new:setURL(SoraDGetImageNameByLang("img_common_new_%s.png", nil))
	local showNew = not self.chapterNewMap[chapter]
	Load_new:setVisible(showNew)
end
function Activity_9001658_PlotMainPanel:onClickItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List:getChildIndex(obj)
	local chapter = childIndex + 1
	if chapter > self.curChapter then
		SoraDShowMsgTip(i18n("BUBBLE_LEGEND_TEXT_27"))
		return
	end
	_ENV = i18n("BUBBLE_LEGEND_TEXT_27")
	i18n("BUBBLE_LEGEND_TEXT_27").chapter = chapter
	uiManager:show("Activity_9001658_PlotDetail", i18n("BUBBLE_LEGEND_TEXT_27"))
	local Load_new = obj:getChild("Load_new")
	Load_new:setVisible(false)
	self.chapterNewMap[chapter] = true
	activity_9001658_Ctrl:setChapterNewMap(self.chapterNewMap)
end
return Activity_9001658_PlotMainPanel
