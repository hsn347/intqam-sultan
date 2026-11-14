local amazingFortuneCtrl = SoraDGetCtrl("amazingFortuneCtrl")
local publicRead = include("publicRead")
local amazingFortuneRecordPopView = class("amazingFortuneRecordPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("amazingFortuneRecordPopView")
	end
	return target
end)
function amazingFortuneRecordPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	amazingFortuneCtrl:resetRewardRecordData()
	self.beginIndex = 1
	self.count = 50
	amazingFortuneCtrl:sendReqRewardListMsg(self.beginIndex, self.count)
	SoraDAddMessage(self, "MESSAGE_AMAZINGFORTUNE_REFRESH", handler(self, self.refreshView))
end
function amazingFortuneRecordPopView:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("valueTreasure_btn_01"))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_norecord"
	self.Text_norecord = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	self.Text_norecord:setString(i18n("common_text_1464"))
	_UPVALUE1_ = i18n("common_text_1464")
	i18n("common_text_1464")[1] = "ScrollView_record"
	self.scroll = SoraDGetChildByFullPath(self.Node_content, i18n("common_text_1464"))
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setScrollBottomFun(handler(self, self.scrollBottomEventCallBack))
	if SoraDFIsRA() then
		self.Node_record = SoraDGetChildByName(self, "Node_record")
	else
		self.Node_record = SoraDGetChildByName(self, "Node_record_en")
	end
end
function amazingFortuneRecordPopView:createSingle(...)
	local item = self.Node_record:clone()
	publicRead = nil
	;(nil)[1] = "Image_record"
	item.Image_record = SoraDGetChildByFullPath(item, nil)
	publicRead = nil
	;(nil)[1] = "Text_record"
	item.Text_record = SoraDGetChildByFullPath(item, nil)
	item.Text_record = SoraDChangeTextToHtml(item.Text_record)
	function item.initData(item, data, otherData)
		local nickName = data.nickName or ""
		nickName = SoraDCheckHtmlUtf8Str(nickName)
		if SoraDFIsRA() then
			_ENV = data.kid
			data.kid.color = "#787878"
			local strKing = SoraDWrapHtmlTagByStyle("#" .. data.kid, data.kid)
			nickName = string.format("  %s  %s", nickName, strKing)
		else
			_ENV = "#"
			;("#").color = "#787878"
			local strKing = SoraDWrapHtmlTagByStyle(data.kid .. "#", "#")
			nickName = string.format("%s  %s  ", strKing, nickName)
		end
		_ENV = "%s  %s  "
		;("%s  %s  ").name = nickName
		_ENV, _ENV, ("%s  %s  ").item = publicRead.getName(data.reward[1].id), "  " .. publicRead.getName(data.reward[1].id) .. "X" .. string.formatnumberthousands(data.reward[1].count), "  " .. publicRead.getName(data.reward[1].id) .. "X" .. string.formatnumberthousands(data.reward[1].count)
		_ENV, ("  " .. publicRead.getName(data.reward[1].id) .. "X" .. string.formatnumberthousands(data.reward[1].count)).name, publicRead.getName(data.reward[1].id).color = publicRead.getName(data.reward[1].id), publicRead.getName(data.reward[1].id), "#D7C39B"
		_ENV, ("  " .. publicRead.getName(data.reward[1].id) .. "X" .. string.formatnumberthousands(data.reward[1].count)).item, publicRead.getName(data.reward[1].id).color = publicRead.getName(data.reward[1].id), publicRead.getName(data.reward[1].id), "#FFFF00"
		;("  " .. publicRead.getName(data.reward[1].id) .. "X" .. string.formatnumberthousands(data.reward[1].count)).__default, publicRead.getName(data.reward[1].id).color = publicRead.getName(data.reward[1].id), "#787878"
		local strName = i18n_html("valueTreasure_text_01", "%s  %s  ", "  " .. publicRead.getName(data.reward[1].id) .. "X" .. string.formatnumberthousands(data.reward[1].count))
		item.Text_record:setString(strName)
		item.Image_record:setVisible(data.index % 2 == 1)
	end
	return item
end
function amazingFortuneRecordPopView:initData()
	local recordList = amazingFortuneCtrl:getRewardRecordData()
	for i, v in ipairs(recordList) do
		v.index = i
	end
	if recordList and next(recordList) then
		self.Text_norecord:setVisible(false)
	end
	self.scroll:updateScrollView(cc.size(520, 38), recordList)
	if self.needJump then
		self.scroll:jumpIndexToBottom(self.beginIndex - 1)
	end
end
function amazingFortuneRecordPopView:scrollBottomEventCallBack(...)
	if amazingFortuneCtrl:getBuyListHasMore() then
		self.needJump = true
		self.beginIndex = self.beginIndex + self.count
		amazingFortuneCtrl:sendReqRewardListMsg(self.beginIndex, self.count)
	end
end
function amazingFortuneRecordPopView:refreshView(target, event)
	if "RecordPopView" == event.eventName then
		self:initData()
	end
end
return amazingFortuneRecordPopView
