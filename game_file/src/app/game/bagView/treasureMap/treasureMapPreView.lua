local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local collectSalaryRead = include("collectSalaryRead")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local treasureMapPreView = class("treasureMapPreView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("treasureMapPreView")
	end
	return target
end)
local MaxNum = 5
local maxMap = 2
_ENV = nil
;(nil).FROM_CHAT = 1
local _ENV, _ENV, _UPVALUE4_, (nil).FROM_BAG, openViewType = nil, nil, nil, 2, nil
;(nil).x = -210
_ENV, (nil)[5], (nil).y = nil, nil, 105
;(nil).x = -213
_ENV, _ENV, (nil)[4], (nil).y = nil, nil, nil, 83
;(nil).x = -120
_ENV, (nil)[5], (nil).y = nil, nil, -60
;(nil).x = -70
_ENV, _ENV, (nil)[4], (nil).y = nil, nil, nil, -65
;(nil).x = 10
_ENV, (nil)[5], (nil).y = nil, nil, 45
;(nil).x = 72.0
_ENV, _ENV, (nil)[4], (nil).y = nil, nil, nil, 67
;(nil).x = 113
;(nil)[5], (nil).y = nil, -21
;(nil)[1] = nil
;(nil)[2] = nil
;(nil)[3] = nil
local (nil)[4], posXY
function treasureMapPreView:ctor()
	self.checkBoxTbl, _ENV, self.timerTbl, _ENV = nil, nil, nil, nil
	self.curPage = 1
	self.canClick = true
	self.itemNameTitle = SoraDGetChildByName(self, "Text_Title")
	self.textItemInfo = SoraDGetChildByName(self, "Text_MapInfo")
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textAndBtn = SoraDGetChildByName(self, "Text_BtnView")
	self.textAndBtn = SoraDChangeTextToHtml(self.textAndBtn)
	self.mapNode = SoraDGetChildByName(self, "Node_Map")
	self.mapOutNode = SoraDGetChildByName(self, "Node_Map_Out")
	SoraDGetChildByName(self.mapNode, "icon_Box"):setVisible(false)
	SoraDGetChildByName(self.mapOutNode, "icon_Box"):setVisible(false)
	self.btnClose = SoraDGetChildByName(self, "Button_Close")
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnLeft = SoraDGetChildByName(self, "Button_Left")
	self.btnRight = SoraDGetChildByName(self, "Button_Right")
	self.btnClose:addTouchEventListener(handler(self, self.close))
	self.btnSure:addTouchEventListener(handler(self, self.btnClickSure))
	self.textItemInfo:setString(i18n("treasuremap_dec_01"))
	_ENV = i18n("treasuremap_dec_01")
	_ENV, _ENV, i18n("treasuremap_dec_01").name = "decrypt_text_03", i18n("decrypt_text_03"), i18n("decrypt_text_03")
	;("decrypt_text_03").u = "true"
	;("decrypt_text_03").c = "true"
	i18n("decrypt_text_03").name, ("decrypt_text_03").name = "decrypt_text_03", "viewAward"
	self.textAndBtn:setString(i18n_html("common_text_035", i18n("treasuremap_dec_01")))
	self.textAndBtn:setTouchEnabled(true)
	self.textAndBtn:addTouchEventListener(handler(self, self.btnClickText))
	self.pagePoint = include("commonScrollIndicatorNumber").new()
	self.pagePoint:addTo(SoraDGetChildByName(self, "Center_Node"), 1)
	self.pagePoint:setPosition(0, -1 * SoraDGetChildByName(self, "Center_Node"):getPositionY() + 20)
	self.btnLeft:addTouchEventListener(handler(self, self.btnTurnMapClick))
	self.btnRight:addTouchEventListener(handler(self, self.btnRightPageClick))
	self:initMapNode(self.mapOutNode)
end
function treasureMapPreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_COLLECT_RANK_MESSAGE", handler(self, self.showSuccessView))
end
function treasureMapPreView:showSuccessView(target, data)
	if data.subMsg == "showSuccess" then
		SoraDCloseLoading(self)
		local treasureMapID = self.mapInfo[self.curPage].treasureMapID
		local panel = SoraDCreatePanel("treasureMapRqSuccess")
		panel:initData(1, treasureMapID)
		panel:show()
		self:removeFromParent()
	elseif data.subMsg == "requestHelp" then
		self.cdLock = true
		self.btnSure:setBright(false)
		self.btnSure:setTouchEnabled(false)
		self.selectedFragmentID = data.fragmentID
		self:setSelectItem(self:getIndexByFragmentID(self.selectedFragmentID), false)
	end
end
function treasureMapPreView:initMapNode(mapNode)
	local lightLine = SoraDGetChildByName(mapNode, "Image_Light_Line_1")
	local iconPos = SoraDGetChildByName(mapNode, "single_Pos_1")
	local singleInfo = SoraDGetChildByName(mapNode, "Node_SingleInfo_1")
	local checkBox = SoraDGetChildByName(singleInfo, "CheckBox")
	for i = 2, MaxNum do
		if i < MaxNum then
			local itemPos = iconPos:clone()
			itemPos:addTo(mapNode)
			itemPos:setName("single_Pos_" .. i)
			local singleLight = lightLine:clone()
			singleLight:addTo(mapNode)
			singleLight:setName("Image_Light_Line_" .. i)
		end
		local itemInfo = singleInfo:clone()
		itemInfo:addTo(mapNode)
		itemInfo:setName("Node_SingleInfo_" .. i)
		local checkBox = SoraDGetChildByName(itemInfo, "CheckBox")
	end
end
function treasureMapPreView:initData(viewType, itemID, otherData)
