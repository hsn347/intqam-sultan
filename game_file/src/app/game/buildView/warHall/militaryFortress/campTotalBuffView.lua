local militaryFortressRead = include("militaryFortressRead")
local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local campTotalBuffView = class("campTotalBuffView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("campTotalBuffView")
end)
function campTotalBuffView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("fortress_text_01"))
	self.scrollItem = SoraDGetChildByName(self, "ScrollView_item")
	self.scrollItem = include("commonAutoScrollList").new(self.scrollItem)
	self.scrollItem:setSingleCreate(handler(self, self.createScrollSingle))
	self.scrollItem:setSingleRefresh(handler(self, self.nodeSingleRefresh))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	_ENV, self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX")
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX").defaultClick = "CCS_commonTabBtnEX", self, 1
	;("CCS_commonTabBtnEX").title = i18n("fortress_name_07")
	;("CCS_commonTabBtnEX").handle = handler(self, self.btnTabClick)
	;("CCS_commonTabBtnEX").tag = 1
	_ENV, self[1], ("CCS_commonTabBtnEX").fontSize = "CCS_commonTabBtnEX", "CCS_commonTabBtnEX", 22
	;("CCS_commonTabBtnEX").title = i18n("fortress_name_06")
	;("CCS_commonTabBtnEX").handle = handler(self, self.btnTabClick)
	;("CCS_commonTabBtnEX").tag = 2
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX").tabsetArray, self[2], ("CCS_commonTabBtnEX").fontSize = self, "CCS_commonTabBtnEX", 22
	local param = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX")
	self.nodeCommonTabBtnEX:setContentSize(cc.size(534, 56))
	self.nodeCommonTabBtnEX:setNewStyle(true)
	self.nodeCommonTabBtnEX:initView(param)
end
function campTotalBuffView:createScrollSingle()
	local single = self.nodeSingle:clone()
	return single
end
function campTotalBuffView:nodeSingleRefresh(parent, data, otherData)
	local fortessType = parent:getTag()
	local textCamp = SoraDGetChildByName(parent, "Text_Camp_Title")
	textCamp:setString(i18n(militaryFortressRead.getFortessTitle(fortessType)))
	local imgIcon = SoraDGetChildByName(parent, "icon_camp")
	imgIcon:setSpriteFrame(string.format("icon_jjys_%.2d.png", fortessType))
	local buffScroll = SoraDGetChildByName(parent, "ScrollView_Buff")
	buffScroll:setBounceEnabled(false)
	buffScroll:setTouchEnabled(false)
	if not parent.buffScroll then
		parent.buffScroll = include("buffScrollView").new(buffScroll)
		parent.buffScroll:setProportion(0.75)
	end
	parent.buffScroll:updateScrollView(cc.size(260, 35), militaryFortressCtrl:getBuffList(fortessType, otherData.campType), 1)
end
function campTotalBuffView:btnTabClick(tag, name)
	_ENV, _ENV, _ENV, _ENV, _UPVALUE4_ = nil, nil, nil, 150, 532
	;(532)[1] = 150
	;(532)[2] = nil
	;(532)[3] = nil
	;(532)[4] = nil
	_ENV = nil
	;(nil).campType = tag
	self.scrollItem:updateScrollView(cc.size(532, 150), 532, 1, nil)
end
return campTotalBuffView
