local sendRedPacketRechargeView = class("sendRedPacketRechargeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sendRedPacketRechargeView")
	end
	return target
end)
function sendRedPacketRechargeView:ctor()
	self.singleTbl, _ENV = nil, nil
	self.nodeContent = SoraDGetChildByName(self, "Node_content")
	self.txtTips = SoraDGetChildByName(self, "Text_tips")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnNext = SoraDGetChildByName(self, "Button_next")
	self.imgSingle = SoraDGetChildByName(self, "Image_single")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_gift")
	self.mailViewFrame = SoraDGetExtendChildFromCCSByName(self, "CCS_mailViewFrame_node", true)
	self.nodeFramMail = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_mail")
	self.nodeFramMail:setTitle(i18n("common_text_3479"))
	self.nodeFramMail:setTitleSize()
	SoraDGetChildByName(self, "Text_tips"):setString(i18n("common_text_3480"))
	self.btnNext:setTitleText(i18n("common_text_3478"))
	self.btnNext:setTouchEnabled(false)
	self.btnNext:setBright(false)
	self.btnNext:addTouchEventListener(handler(self, self.btnNextClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REDPACKETSUCCESS", handler(self, self.rechargeSuccess))
	self:createSingleClass()
	self:initData()
end
function sendRedPacketRechargeView:createSingleClass()
	self.singleClass = class("sendRedPacketRechargeSingle", function()
		local target = self.imgSingle:clone()
		return target
	end)
	function self.singleClass:ctor()
		self.isSelect = false
		self.txtPrice = self:getChildByName("Text_price")
		self.txtGold = self:getChildByName("BitmapFontLabel_gold")
		self.imgSelect = self:getChildByName("Image_select")
		self:setTouchEnabled(true)
		self:setSwallowTouches(false)
		self:addTouchEventListener(handler(self, self.itemClick))
	end
	function self.singleClass:initData(_info)
		self.info = _info
		self:initView()
	end
	function self.singleClass:initView(...)
		local showPrice, isGetPrice = paymentManager.judgePrice(self.info.rid, self.info.price)
		self.txtPrice:setString(showPrice)
		self.txtGold:setString(self.info.result[2])
		self.imgSelect:setVisible(self.isSelect)
	end
	function self.singleClass:initHandl(_selectFun, _checkSelected)
		self.selectFun = _selectFun
		self.popSelect = _checkSelected
	end
	function self.singleClass:itemClick(button, eventType, noSound)
		if eventType == ccui.TouchEventType.ended then
			if not noSound then
				SoraDPlaySound()
			end
			if self.isSelect then
				self.isSelect = false
				self.imgSelect:setVisible(false)
			else
				self.selectFun(self)
			end
			self.popSelect()
		end
	end
end
function sendRedPacketRechargeView:checkSelected(...)
	if self:popSelectSingle() then
		self.btnNext:setTouchEnabled(true)
		self.btnNext:setBright(true)
	else
		self.btnNext:setTouchEnabled(false)
		self.btnNext:setBright(false)
	end
end
function sendRedPacketRechargeView:selectOne(single)
	for _, v in pairs(self.singleTbl) do
		if single == v then
			v.isSelect = true
			v:getChildByName("Image_select"):setVisible(true)
		else
			v.isSelect = false
			v:getChildByName("Image_select"):setVisible(false)
		end
	end
end
function sendRedPacketRechargeView:initData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local propCtrl = gametop.playertop_:getModule("propCtrl")
	self.goldData = propCtrl:getRechargeRedEnvelopesList()
	self:initView()
end
function sendRedPacketRechargeView:initView(...)
	for i, v in ipairs(self.goldData) do
		local single = self.singleClass.new()
		single:initData(v)
		single:initHandl(handler(self, self.selectOne), handler(self, self.checkSelected))
		single:addTo(self.nodeContent)
		single:setPosition(0, -(i - 1) * 130 - 70)
		table.insert(self.singleTbl, single)
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, 120 + 130 * #self.goldData + 80)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeContent:setPosition(sSize.width / 2, sH - 50)
	self.btnNext:setPosition(0, -120 - 130 * #self.goldData)
	if self.singleTbl[1] then
		self.singleTbl[1]:itemClick(nil, ccui.TouchEventType.ended, true)
	end
end
function sendRedPacketRechargeView:popSelectSingle(...)
	local _info
	for _, v in pairs(self.singleTbl) do
		if v.isSelect then
			_info = v.info
			break
		end
	end
	return _info
end
function sendRedPacketRechargeView:btnNextClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _info = self:popSelectSingle()
		print("id = ", _info.id)
		local layer = SoraDCreatePanel("sendRedPacketRechargeNext")
		layer:initData(_info)
		layer:show()
	end
end
function sendRedPacketRechargeView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function sendRedPacketRechargeView:rechargeSuccess(...)
	self:close(nil, ccui.TouchEventType.ended)
end
return sendRedPacketRechargeView
