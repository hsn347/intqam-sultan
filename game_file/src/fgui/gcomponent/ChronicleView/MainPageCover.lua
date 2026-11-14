local legendMDesRead = include("legendMDesRead")
local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local funUnlockRead = include("funUnlockRead")
local baseComponent = require("fgui.base.baseComponent")
local MainPageCover = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/MainPageCover", MainPageCover)
function MainPageCover:onInit()
	self.pageType = legendMDesRead.PageType.COVER
	self.pageTitle = i18n("history_name_11")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function MainPageCover:setPageType(pageType)
	self.pageType = pageType
end
function MainPageCover:getTitle()
	return self.pageTitle
end
function MainPageCover:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS", handler(self, self.sMsgUpdateCoverStatus))
end
function MainPageCover:onShow()
	self.coverList, legendMDesRead = nil, nil
	local coverList = legendMDesRead.getCoverCfg()
	for k, v in ipairs(coverList) do
		local key = legendMDesRead.getKeyByIndex(k)
		local showLv = funUnlockRead.getShowLevel(key)
		if not IsArClient then
			if k == gLegendHistoryCoverType.MILESTONE and showLv <= SoraDGetCastleLv() then
				table.insert(self.coverList, 1, v)
			end
		elseif k == gLegendHistoryCoverType.MILESTONE then
			if showLv <= SoraDGetCastleLv() then
				table.insert(self.coverList, 1, v)
			end
		elseif showLv <= SoraDGetCastleLv() then
			table.insert(self.coverList, v)
		end
	end
	self.fields.List:setNumItems(#self.coverList)
	if IsArClient then
		legendMCtrl:reqStoryData()
	end
	_ENV = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.callFunc(function()
		SoraDPlaySound("uicontrol", 3)
	end)
	;(nil)[3] = ffa.callFunc(function()
		SoraDPlaySound("uicontrol", 3)
	end)
	;(nil)[4] = ffa.callFunc(function()
		SoraDPlaySound("uicontrol", 3)
	end)
	;(nil)[5] = ffa.callFunc(function()
		SoraDPlaySound("uicontrol", 3)
	end)
	;(nil)[6] = ffa.callFunc(function()
		SoraDPlaySound("uicontrol", 3)
	end)
	;(nil)[7] = ffa.callFunc(function()
		SoraDPlaySound("uicontrol", 3)
	end)
	self:runAction(ffa.seq(nil))
end
function MainPageCover:onItemRederer(index, target)
	target:initData(self.coverList[index + 1], index + 1)
end
function MainPageCover:sMsgUpdateCoverStatus(target, data)
	self.fields.List:setNumItems(#self.coverList)
end
return MainPageCover
