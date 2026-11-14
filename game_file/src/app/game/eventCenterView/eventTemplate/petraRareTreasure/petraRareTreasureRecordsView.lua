local gametop = gModuleMgr.getObject("gametop")
local petraRareTreasureCtrl = gametop.playertop_:getModule("petraRareTreasureCtrl")
local petraRareTreasureRecordsView = class("petraRareTreasureRecordsView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("tradeBoardRecordsView")
	end
	return target
end)
function petraRareTreasureRecordsView:ctor()
	self.infoTbl, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_btns")
	self.nodeCommonTab:setVisible(false)
	self.ccs_bg:setTitleName(i18n("petra_text_12"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("petraRareTreasureRecordsSingle")
	self.scroll:setPositionY(self.scroll:getPositionY() + 50)
	self.scroll:setContentSize(cc.size(530, 604))
	self.txtNoRecords = SoraDGetChildByName(self, "Text_noRecords")
	self.txtNoRecords:setString(i18n("common_text_1464"))
	self:req4Info()
end
function petraRareTreasureRecordsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PETRA_RARE_TREASURE_RECORD", handler(self, self.initData))
end
function petraRareTreasureRecordsView:req4Info()
	petraRareTreasureCtrl:reqLuckyCoinRecord()
end
function petraRareTreasureRecordsView:initData(target, redata)
	self.rData = redata.record
	dump(self.rData, "self.rData", 10)
	self.scroll:updateScrollView(cc.size(530, 80), self.rData)
	self:initView()
end
function petraRareTreasureRecordsView:initView(...)
	if self.rData and next(self.rData) ~= nil then
		self.txtNoRecords:setVisible(false)
	else
		self.txtNoRecords:setVisible(true)
	end
end
return petraRareTreasureRecordsView
