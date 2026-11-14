local mailItemDetailSpeedUp = class("mailItemDetailSpeedUp", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("mailItemDetailSpeedUp")
	end
	return target
end)
function mailItemDetailSpeedUp:ctor()
	self.isHidePrePanel = false
	self.singleNode = SoraDGetChildByName(self, "Node_score")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_4520"))
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.textTips = SoraDGetChildByName(self, "Text_Tip")
	self.textTips:setString(i18n("common_text_4521"))
end
function mailItemDetailSpeedUp:initWithData(data)
	table.sort(data, function(member1, member2)
		return member1.t > member2.t
	end)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(533, 50), data, 1, nil)
end
function mailItemDetailSpeedUp:createSingle()
	local single = self.singleNode:clone()
	return single
end
function mailItemDetailSpeedUp:refreshSingle(single, info)
	local index = single:getTag()
	local txtInfo = SoraDGetChildByName(single, "Text_info")
	local spBg = SoraDGetChildByName(single, "Image_Bg")
	local txtTime = SoraDGetChildByName(single, "Text_time")
	spBg:setVisible(false)
	local itemDesRead = include("itemDesRead")
	local itemname = itemDesRead.getName(info.itemId)
	_ENV = nil
	;(nil).time = ""
	;(nil).playerName = info.name
	;(nil).name = itemname
	txtInfo:setString(i18n("common_text_4509", nil))
	txtTime:setString(os.date("%H:%M:%S", info.t))
	txtInfo:setFontSize(18)
	txtInfo:setColor(cc.c3b(215, 195, 155))
end
function mailItemDetailSpeedUp:onBtnBg(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(target, event)
	end
end
return mailItemDetailSpeedUp
