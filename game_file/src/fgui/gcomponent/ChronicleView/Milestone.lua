local gametop = gModuleMgr.getObject("gametop")
local mileStoneCtrl = gametop.playertop_:getModule("mileStoneCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local legendMDesRead = include("legendMDesRead")
local legendMDesRead = include("legendMDesRead")
local mileStoneCtrl = SoraDGetCtrl("mileStoneCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Milestone = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Milestone", Milestone)
function Milestone:onInit()
	self.pageType = legendMDesRead.PageType.MILESTONE
	self.pageTitle = i18n("history_text_60")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function Milestone:setPageType(pageType)
	self.pageType = pageType
end
function Milestone:getTitle()
	return self.pageTitle
end
function Milestone:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_MILESTONE_INIT_BACK", handler(self, self.sMsgRoadDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_MILESTONE_REWARD_BACK", handler(self, self.sMsgRoadDataBack))
end
function Milestone:onShow()
	SoraDShowLoading()
	mileStoneCtrl:reqInitData()
end
function Milestone:onItemRederer(index, target)
	target:initData(self.dataList[index + 1])
end
function Milestone:sMsgRoadDataBack(target, data)
	print("legendMPageRoad:sMsgRoadDataBack(target, data)", self.pageType)
	if data.pageType ~= self.pageType then
		print("检测到类型不一致----")
		return
	end
	SoraDCloseLoading()
	dump(data, "data----")
	self.isDataBack = true
	self:initScroll()
end
function Milestone:initScroll()
	self.dataList = legendMDesRead.getMileStoneCfg()
	self.fields.List:setNumItems(#self.dataList)
end
return Milestone
