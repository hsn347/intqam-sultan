local gametop = gModuleMgr.getObject("gametop")
local spiritualGiftCtrl = SoraDGetCtrl("spiritualGiftCtrl")
local spiritualGiftRecordView = class("spiritualGiftRecordView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("spiritualGiftRecordView")
	end
	return target
end)
singleNodeH = 100
function spiritualGiftRecordView:ctor()
	self:initControls()
end
function spiritualGiftRecordView:initControls()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.Node_tt = SoraDGetChildByName(self, "Node_tt")
	self.scroll = SoraDGetChildByName(self, "ScrollView_1")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "commonAutoScrollList")
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.txtName = SoraDGetChildByName(self.Node_tt, "Text_name")
	self.txtLuck = SoraDGetChildByName(self.Node_tt, "Text_lucky")
	self.txtGold = SoraDGetChildByName(self.Node_tt, "Text_gold")
	self.txtTime = SoraDGetChildByName(self.Node_tt, "Text_time")
	self.txtTip = SoraDGetChildByName(self, "text_tip")
	self.ccs_bg:setTitleName(i18n("godGift_btn_01"))
	self.txtName:setString(i18n("subscribe_gift_text_06"))
	self.txtLuck:setString(i18n("godGift_title_04"))
	self.txtGold:setString(i18n("common_text_020"))
	self.txtTime:setString(i18n("petra_title_09"))
	self.txtTip:setString(i18n("godGift_text_23"))
	spiritualGiftCtrl:reqGiftRecord()
	SoraDShowLoading(self)
end
function spiritualGiftRecordView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_RECORD_BACK", function(target, data)
		SoraDCloseLoading(self)
		self.recordList, _ENV = SoraDCloseLoading, SoraDCloseLoading
		self.recordList = spiritualGiftCtrl:getPlayerRecordData()
		self.scroll:updateScrollView(cc.size(520, singleNodeH), self.recordList)
	end)
end
function spiritualGiftRecordView:createSingle()
	local ocx = self.nodeSingle:clone()
	local txtGoldValue = SoraDGetChildByName(ocx, "text_goldValue")
	local time = SoraDGetChildByName(ocx, "text_timeValue")
	local txtLuckyNumber = SoraDGetChildByName(ocx, "BitmapFontLabel_1")
	local imgBg = SoraDGetChildByName(ocx, "Image_37")
	function ocx.initData(target, data, otherData)
		txtGoldValue:setString(data.luckyGold)
		txtGoldValue:setVisible(data.luckyGold > 0)
		time:setString(os.date("!%Y-%m-%d %H:%M:%S", data.time))
		if not ocx.itemAward then
			local itemAward = SoraDCreatePanel("commonItemAward")
			itemAward:setScale(0.7)
			itemAward:setBaseScale(1.0)
			itemAward:setOwnView(self)
			itemAward:addTo(ocx)
			if SoraDFIsRA() then
				itemAward:setPosition(450, 50)
			else
				itemAward:setPosition(60, 50)
			end
			ocx.itemAward = itemAward
		end
		ocx.itemAward:initData(data.reward[1].id, data.reward[1].count)
		txtLuckyNumber:setString(data.luckyNumber)
		if data.luckyGold <= 0 then
			imgBg:loadTexture("frame_alliance_grade_01.png", ccui.TextureResType.plistType)
		else
			imgBg:loadTexture("frame_alliance_grade_02.png", ccui.TextureResType.plistType)
		end
	end
	return ocx
end
return spiritualGiftRecordView
