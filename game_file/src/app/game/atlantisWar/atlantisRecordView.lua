local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisRecordView = class("atlantisRecordView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("atlantisRecordView")
end)
function atlantisRecordView:onEnterPanel()
	SoraDShowLoading(self)
	atlantisActivityCtrl:reqHistory()
end
function atlantisRecordView:ctor(properties)
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.nodeCommonFramTitle:setTitle(i18n("common_text_3032"))
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleCCS("atlantisRecordSingle")
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.textNoRecord = SoraDGetChildByName(self, "Center_Text_NoRecord")
	self.textNoRecord:setString(i18n("atlantiswar_text_0034"))
end
function atlantisRecordView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH", handler(self, self.msgCallBack))
end
function atlantisRecordView:updateScroll()
	if next(self.historyInfo) then
		self.textNoRecord:setVisible(false)
		self.scroll:updateScrollView(cc.size(640, 500), self.historyInfo, 1)
	else
		self.textNoRecord:setVisible(true)
	end
end
function atlantisRecordView:createScrollSingle()
	return include("atlantisRecordSingle").new(self.nodeSingle:clone())
end
function atlantisRecordView:msgCallBack(target, data)
	if data.key == "reqHistoryRsp" and self:isVisible() then
		SoraDCloseLoading(self)
		if tonumber(data.err) ~= 0 then
			return
		end
		if not data.rspdata then
			_ENV = data.rspdata
		end
		self.historyInfo = data.rspdata
		self:updateScroll()
	end
end
return atlantisRecordView
