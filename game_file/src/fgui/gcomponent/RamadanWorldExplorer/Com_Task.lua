local ramadanWorldExplorerRead = include("ramadanWorldExplorerRead")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local ramadanWorldExplorerCtrl = SoraDGetCtrl("ramadanWorldExplorerCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanWorldExplorer/Com_Task", Com_Task)
function Com_Task:onInit()
	self:fixChildrenPos()
	self.fields.Button:addClickListener(handler(self, self.onButtonClick))
	self.fields.Text_Pos:addClickListener(handler(self, self.onTextPosClick))
	self.fields.RewardList:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.RewardList:setSwallowTouches(false)
end
function Com_Task:onShow()
end
function Com_Task:initData(data)
	self.data = data
	local desTbl = ramadanWorldExplorerRead.getTaskDescribeByType(self.data.taskId)
	desTbl.build = i18n(allianceStrongholdMineRead.getMineName(self.data.mapObj.objId))
	self.fields.Text_Des:setString(i18n(desTbl))
	local pointStr = string.format("%d,%d", self.data.mapObj.x, self.data.mapObj.y)
	ramadanWorldExplorerRead = i18n(desTbl)
	i18n(desTbl).u = true
	self.fields.Text_Pos:setString(SoraDWrapHtmlTagByStyle(pointStr, i18n(desTbl)))
	self.fields.Button:setString(self.data.isCompleted and i18n("common_text_1146") or i18n("common_text_477"))
	self.fields.Button:setBtnColorIndex(self.data.isCompleted and 0 or 2)
	self.fields.Icon:setURL(allianceStrongholdMineRead.getMineImage(self.data.mapObj.objId))
	allianceStrongholdMineRead = self.data.taskId
	self.data.taskId[1] = "id"
	self.data.taskId[2] = "count"
	self.rewards = serviceFunctions.tableFormat(ramadanWorldExplorerRead.getTaskRewardByTaskID(self.data.taskId), self.data.taskId)
	self.fields.RewardList:setNumItems(#self.rewards)
end
function Com_Task:onItemRenderer(index, target)
	target:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Com_Task:onButtonClick()
	SoraDPlaySound()
	if self.data.isCompleted then
		ramadanWorldExplorerCtrl:reqRamadanWorldExplorerTaskReward(self.data.taskIdx)
	else
		SoraDGotoWorldMapPoint(cc.p(self.data.mapObj.x, self.data.mapObj.y), true)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function Com_Task:onTextPosClick(content)
	SoraDGotoWorldMapPoint(cc.p(self.data.mapObj.x, self.data.mapObj.y), true)
	SoraDRemoveAllPrePanelFromManager(self)
end
return Com_Task
