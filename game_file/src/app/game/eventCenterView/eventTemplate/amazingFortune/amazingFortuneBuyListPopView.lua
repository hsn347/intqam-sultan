local amazingFortuneCtrl = SoraDGetCtrl("amazingFortuneCtrl")
local publicRead = include("publicRead")
local amazingFortuneBuyListPopView = class("amazingFortuneBuyListPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("amazingFortuneBuyListPopView")
	end
	return target
end)
function amazingFortuneBuyListPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	amazingFortuneCtrl:resetListInfo()
	self.beginIndex = 1
	self.count = 50
	amazingFortuneCtrl:sendReqBuyListMsg(self.beginIndex, self.count)
	SoraDAddMessage(self, "MESSAGE_AMAZINGFORTUNE_REFRESH", handler(self, self.refreshView))
end
function amazingFortuneBuyListPopView:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("valueTreasure_title_01"))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_buyList"
	self.Text_buyList = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomId = gametop.playertop_:getKingdomID()
	_ENV = i18n("valueTreasure_title_01")
	i18n("valueTreasure_title_01").country = "K" .. kingdomId
	self.Text_buyList:setString(i18n("valueTreasure_title_02", i18n("valueTreasure_title_01")))
	_UPVALUE1_ = i18n("valueTreasure_title_02", i18n("valueTreasure_title_01"))
	i18n("valueTreasure_title_02", i18n("valueTreasure_title_01"))[1] = "Text_norecord"
	self.Text_norecord = SoraDGetChildByFullPath(self.Node_content, i18n("valueTreasure_title_02", i18n("valueTreasure_title_01")))
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
function amazingFortuneBuyListPopView:createSingle(...)
	local item = self.Node_record:clone()
	_UPVALUE1_ = nil
	;(nil)[1] = "Image_record"
	item.Image_record = SoraDGetChildByFullPath(item, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Text_record"
	item.Text_record = SoraDGetChildByFullPath(item, nil)
	function item.initData(item, data, otherData)
		local nickName = data.nickName or "  "
		_ENV = nil
		;(nil).name = nickName
		;(nil).tiem = "  " .. os.date("!%Y/%m/%d %H:%M:%S", data.buyTime)
		local str = i18n("valueTreasure_text_09", nil)
		item.Text_record:setString(str)
		item.Image_record:setVisible(data.index % 2 == 1)
	end
	return item
end
function amazingFortuneBuyListPopView:initData()
	local recordList = amazingFortuneCtrl:getListInfo()
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
function amazingFortuneBuyListPopView:scrollBottomEventCallBack(...)
	if amazingFortuneCtrl:getBuyListHasMore() then
		self.needJump = true
		self.beginIndex = self.beginIndex + self.count
		amazingFortuneCtrl:sendReqBuyListMsg(self.beginIndex, self.count)
	end
end
function amazingFortuneBuyListPopView:refreshView(target, event)
	if "BuyListPopView" == event.eventName then
		self:initData()
	end
end
return amazingFortuneBuyListPopView
