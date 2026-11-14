local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local KingdomStory = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/KingdomStory", KingdomStory)
function KingdomStory:onInit()
	self.pageType = legendMDesRead.PageType.STORY
	self.pageTitle = i18n("history_text_33")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function KingdomStory:setPageType(pageType)
	self.pageType = pageType
end
function KingdomStory:getTitle()
	return self.pageTitle
end
function KingdomStory:onShow()
	SoraDShowLoading()
	legendMCtrl:reqStoryData()
end
function KingdomStory:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_STORY_DATA_BACK", handler(self, self.sMsgStoryDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_STORY_REWARD_DATA_BACK", handler(self, self.sMsgStoryRewardBack))
end
function KingdomStory:onItemRederer(index, target)
	target:initData(self.dataList[index + 1], index + 1)
end
function KingdomStory:sMsgStoryDataBack(target, data)
	self.isDataBack = true
	SoraDCloseLoading()
	self:initScroll()
end
function KingdomStory:initScroll()
	self.dataList = legendMDesRead.getChapterCfg()
	self.fields.List:setNumItems(#self.dataList)
end
function KingdomStory:sMsgStoryRewardBack(target, data)
	SoraDCloseLoading()
	self:initScroll()
end
return KingdomStory
