local wrathBeastRecordSingle = include("wrathBeastRecordSingle")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
local wrathBeastRecordView = class("wrathBeastRecordView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("wrathBeastRecordView")
	end
	return target
end)
function wrathBeastRecordView:ctor()
	self.records = wrathBeastCtrl:getActivityData("records")
	self:initWidget()
	wrathBeastCtrl:sendReqRecordLogMsg()
end
function wrathBeastRecordView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WRATH_BEAST_REFRESH", handler(self, self.initData))
end
function wrathBeastRecordView:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("god_beast_text_31"))
	self.Text_noRecord = SoraDGetChildByName(self, "Text_noRecord")
	self.Text_noRecord:setString(i18n("god_beast_text_16"))
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_record")
	self.scroll = include("commonScrollView").new(self.scroll)
	_ENV = "ScrollView_record"
	;("ScrollView_record").listData = clone(self.records)
	;("ScrollView_record").createNodeHandler = handler(self, self.createSingleNode)
	self.scroll:init("ScrollView_record")
end
function wrathBeastRecordView:initData(target, data)
	if data.name ~= "record" then
		return
	end
	self.records = wrathBeastCtrl:getActivityData("records")
	self.Text_noRecord:setVisible(not self.records or not next(self.records))
	self.scroll:refreshList(clone(self.records))
end
function wrathBeastRecordView:createSingleNode(...)
	return wrathBeastRecordSingle.new(self.Node_single:clone())
end
return wrathBeastRecordView
