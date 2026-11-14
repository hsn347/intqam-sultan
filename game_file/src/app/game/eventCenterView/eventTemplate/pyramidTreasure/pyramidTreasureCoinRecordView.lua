local gametop = gModuleMgr.getObject("gametop")
local pyramidRareTreasureCtrl = gametop.playertop_:getModule("pyramidRareTreasureCtrl")
local pyramidTreasureCoinRecordView = class("pyramidTreasureCoinRecordView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("tradeBoardRecordsView")
	end
	return target
end)
function pyramidTreasureCoinRecordView:ctor()
	self.infoTbl, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("petra_text_12"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("pyramidTreasureCoinRecordSingle")
	self.txtNoRecords = SoraDGetChildByName(self, "Text_noRecords")
	self.txtNoRecords:setString(i18n("common_text_1464"))
	self.ccs_tabEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_btns")
	self.ccs_tabEX:setVisible(false)
	self.scroll:setPositionY(280)
	self.scroll:setContentSize(cc.size(530, 600))
	pyramidRareTreasureCtrl:reqLuckyCoinRecord()
end
function pyramidTreasureCoinRecordView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_TREASURE_RECORD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function pyramidTreasureCoinRecordView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function pyramidTreasureCoinRecordView:req4Info()
	petraRareTreasureCtrl:reqLuckyCoinRecord()
end
function pyramidTreasureCoinRecordView:initData(target, redata)
	self.rData = redata.record
	dump(self.rData, "self.rData", 10)
	self.scroll:updateScrollView(cc.size(530, 80), self.rData)
	self:initView()
end
function pyramidTreasureCoinRecordView:initView()
	if self.rData and next(self.rData) then
		self.txtNoRecords:setVisible(false)
	else
		self.txtNoRecords:setVisible(true)
	end
end
return pyramidTreasureCoinRecordView
