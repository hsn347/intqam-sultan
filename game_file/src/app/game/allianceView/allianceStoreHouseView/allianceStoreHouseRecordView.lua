local GridScrollView = include("GridScrollView")
local gametop = gModuleMgr.getObject("gametop")
local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
local allianceTreasureltCtrl = include("allianceTreasureltCtrl")
local allianceStoreHouseRecordView = class("allianceStoreHouseRecordView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceStoreHouseRecordView")
	end
	return target
end)
function allianceStoreHouseRecordView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_REQ_INFO_BACK", handler(self, self.reqInfoBack))
end
function allianceStoreHouseRecordView:bandWidget()
	local offsetY = display.height - 960
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Center_Node:setPositionY(self.Center_Node:getPositionY() - offsetY / 2)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self.Center_Node, "CCS_commonPopBox_record")
	self.ccs_bg:setTitleName(i18n("common_text_836"))
	self.ccs_bg:setSize(cc.size(self.ccs_bg:getSize().width, self.ccs_bg:getSize().height + offsetY))
	GridScrollView = cc.size(self.ccs_bg:getSize().width, self.ccs_bg:getSize().height + offsetY)
	cc.size(self.ccs_bg:getSize().width, self.ccs_bg:getSize().height + offsetY)[1] = "ScrollView_record"
	self.scroll = SoraDGetChildByFullPath(self.Center_Node, cc.size(self.ccs_bg:getSize().width, self.ccs_bg:getSize().height + offsetY))
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY))
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY)
	cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY).col = 1
	cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY).h = 10
	self.scroll:init(cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY))
	GridScrollView = cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY)
	cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY)[1] = "Text_no_record"
	self.Text_no_record = SoraDGetChildByFullPath(self.Center_Node, cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY))
	self.Text_no_record:setString(i18n("common_text_1464"))
	self.Text_no_record:setPositionY(self.Text_no_record:getPositionY() + offsetY / 2)
	GridScrollView = self.Text_no_record:getPositionY() + offsetY / 2
	;(self.Text_no_record:getPositionY() + offsetY / 2)[1] = "Button_close"
	self.Button_close = SoraDGetChildByFullPath(self.Center_Node, self.Text_no_record:getPositionY() + offsetY / 2)
	self.Button_close:setTitleText(i18n("allitreas_text_38_ros"))
	self.Button_close:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		self:closePanel()
	end)
end
function allianceStoreHouseRecordView:initData(data)
	self.recordData = data
	if #self.recordData > 0 then
		self.Text_no_record:setVisible(false)
	end
	self.scroll:updateNum(#self.recordData)
end
function allianceStoreHouseRecordView:createCell()
	local cell = self:createRecordItem()
	return cell
end
function allianceStoreHouseRecordView:updateCell(item, i)
	item.initData(self.recordData[i])
end
function allianceStoreHouseRecordView:createRecordItem()
	local item = SoraDCreateCSBNode("allianceStoreHouseRecordSingle")
	item.labTime = SoraDGetChildByName(item, "Text_time")
	item.Text_des = SoraDGetChildByName(item, "Text_des")
	function item.initData(data)
		local timeStr = os.date("%m-%d %H:%M", data.time)
		item.labTime:setString(timeStr)
		local desStr = self:getDesStr(data.event) or ""
		local treasure = ""
		if data.treasure and data.treasure.teasureID and data.treasure.quality then
			treasure = allianceTreasureltCtrl.getTreasureName(data.treasure.teasureID, data.treasure.quality)
		end
		local name = data.name or ""
		_ENV = nil
		;(nil).treasure = treasure
		;(nil).name = name
		item.Text_des:setString(i18n(desStr, nil))
	end
	return item
end
function allianceStoreHouseRecordView:setRecordType(rType)
	self.recordType = rType
	allianceTreasureCtrl:reqRecord(self.recordType)
end
function allianceStoreHouseRecordView:getDesStr(subType)
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil)[1] = "allitreas_text_32_ros"
	;(nil)[2] = "allitreas_text_33_ros"
	;(nil)[3] = "allitreas_text_34_ros"
	_UPVALUE0_, (nil)[1], (nil)[4] = nil, nil, "allitreas_text_35_ros"
	;(nil)[1] = "allitreas_text_36_ros"
	;(nil)[2], (nil)[2] = nil, "allitreas_text_37_ros"
	local recordConfig
	local config = recordConfig[self.recordType]
	return config and config[subType] or ""
end
function allianceStoreHouseRecordView:reqInfoBack(event, data)
	if self.recordType == data.nType then
		local _ENV, nData = self.recordType, self.recordType
		for i, v in ipairs(data.nData) do
			table.insert(nData, 1, v)
		end
		self:initData(nData)
	end
end
return allianceStoreHouseRecordView
