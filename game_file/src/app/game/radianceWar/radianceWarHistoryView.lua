local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local radianceWarHistoryView = class("radianceWarHistoryView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarHistoryView")
	end
	return target
end)
function radianceWarHistoryView:ctor()
	self.isHideCurrentSceneView = true
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("common_text_3032"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.textTip = SoraDGetChildByName(self, "Center_Text_Tip")
	self.textTip:setString(i18n("common_text_927"))
	SoraDShowLoading(self)
	radianceActivityCtrl:reqHistory()
end
function radianceWarHistoryView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_UI_REFRESH", handler(self, self.initData))
end
function radianceWarHistoryView:initData(target, data)
	if data.subMsg == "History" then
		SoraDCloseLoading(self)
		if data.err then
			return
		end
		local historyInfoList = radianceActivityCtrl:getHistoryList()
		self.textTip:setVisible(not next(historyInfoList))
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scroll:updateScrollView(cc.size(640, 110), historyInfoList, 1, nil)
	end
end
function radianceWarHistoryView:createScrollSingle()
	local single = self.nodeSingle:clone()
	return include("radianceWarHistorySingle").new(single)
end
function radianceWarHistoryView:msgCallBack(target, data)
end
return radianceWarHistoryView
