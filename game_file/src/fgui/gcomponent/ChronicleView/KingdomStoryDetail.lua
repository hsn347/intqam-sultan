local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local KingdomStoryDetail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/KingdomStoryDetail", KingdomStoryDetail)
function KingdomStoryDetail:onInit()
	self.pageType = legendMDesRead.PageType.STORYDETAIL
	self.pageTitle = i18n("history_text_33")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function KingdomStoryDetail:onShow()
end
function KingdomStoryDetail:getTitle()
	return self.pageTitle
end
function KingdomStoryDetail:setPageType(pageType)
	self.pageType = pageType
end
function KingdomStoryDetail:initData(data)
	local pageData = data.pageData
	dump(data, "legendMPageStoryDetail:init(data)")
	self.fields.Text_title:setString(i18n(pageData.name))
	self.desArray = pageData.des
	self.fields.List:setNumItems(#self.desArray)
	self.fields.List:jumpToTop()
end
function KingdomStoryDetail:onItemRederer(index, target)
	target:setString(i18n(self.desArray[index + 1]))
end
return KingdomStoryDetail
