local WorldMapKingdomCityOfficialManagerResBalence = class("worldMapKingdomCityOfficialManagerResBalence", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityOfficialManagerResBalence")
	end
	return target
end)
function WorldMapKingdomCityOfficialManagerResBalence:ctor()
	self.resTable, _ENV, self.singleIsMoved = nil, nil, false
	self.timeQueen = nil
	self.timer = nil
	_UPVALUE4_, self.isInCD = nil, false
	self.tableResType, (nil)[1] = nil, gIDDef.MITHRIL
	self.tableResType, (nil)[2] = nil, gIDDef.IRON
	self.tableResType, (nil)[3] = nil, gIDDef.WOOD
	self.tableResType, (nil)[4] = nil, gIDDef.FOOD
	self.selectResId = nil
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.imgFrmRes = SoraDGetChildByName(self, "Node_item")
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.imgSelectFrm = SoraDGetChildByName(self, "Image_selected")
	self.txtTitle:setString(i18n("common_text_1195"))
	self.btnChange:setTitleText(i18n("common_text_243"))
	self.imgSelectFrm:setVisible(false)
	self.btnChange:addTouchEventListener(handler(self, self.btnChangeClick))
	self:initData()
end
function WorldMapKingdomCityOfficialManagerResBalence:initData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	self.timeQueen = queueCtrl:queryQueue(gQueueTypeDef.change_resource_rate, gChangeResourceRateQueueId)
	if self.timeQueen then
		self:updateTime()
		self.timer = SoradCreateTimer(self, handler(self, self.updateTime))
	end
	self:initView()
end
function WorldMapKingdomCityOfficialManagerResBalence:initView()
	table.insert(self.resTable, self.imgFrmRes)
	for i = 2, 4 do
		local newRes = self.imgFrmRes:clone()
		newRes:addTo(self, 1)
		table.insert(self.resTable, newRes)
	end
	local resDesRead = include("resDesRead")
	local sortNum = 4
	for i, v in ipairs(self.resTable) do
		local _line = i % sortNum == 0 and sortNum or i % sortNum
		local _row = math.ceil(i / sortNum)
		local fX = 105 + (_line - 1) * 150
		local fY = -130 - (_row - 1) * 150
		v:setPosition(SoraDFPosX(fX), fY)
		local btnTouch = SoraDGetChildByName(v, "Button_touch")
		btnTouch:setTag(i)
		btnTouch:setSwallowTouches(false)
		btnTouch:addTouchEventListener(handler(self, self.imgFrmClick))
		local Image_res = SoraDGetChildByName(v, "Image_res")
		Image_res:loadTexture(resDesRead.getMIcon(self.tableResType[i]), ccui.TextureResType.plistType)
	end
	self:changeButton(false)
end
function WorldMapKingdomCityOfficialManagerResBalence:recvMsgOfChange(target, redata)
	self:changeButton(false)
end
function WorldMapKingdomCityOfficialManagerResBalence:btnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("common_text_4344"), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				local gametop = gModuleMgr.getObject("gametop")
				local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
				KWKingdomCtrl:changeResRate(self.selectResId)
				self:changeButton(false)
			end
		end)
	end
end
function WorldMapKingdomCityOfficialManagerResBalence:imgFrmClick(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.selectResId and self.selectResId == self.tableResType[button:getTag()] and self.imgSelectFrm:isVisible() then
			self.imgSelectFrm:setVisible(false)
			self.selectResId = nil
			self:changeButton(false)
		else
			self.imgSelectFrm:setVisible(true)
			self.imgSelectFrm:setPosition(button:getParent():getPositionX(), button:getParent():getPositionY() + 2)
			if self.isInCD then
				self:changeButton(false)
			else
				self:changeButton(true)
			end
			self.selectResId = self.tableResType[button:getTag()]
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > 5 then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function WorldMapKingdomCityOfficialManagerResBalence:setScroll(scroll)
	self.scroll = scroll
end
function WorldMapKingdomCityOfficialManagerResBalence:getHeigh()
	return 300
end
function WorldMapKingdomCityOfficialManagerResBalence:changeButton(bool)
	self.btnChange:setTouchEnabled(bool and SoraDIsSelfKing())
	self.btnChange:setBright(bool and SoraDIsSelfKing())
end
function WorldMapKingdomCityOfficialManagerResBalence:updateTime(dt)
	local leftTime = self.timeQueen.timerNode.timer:getRemainTime()
	if 0 < leftTime then
		self.isInCD = true
		self.btnChange:setTitleText(SoraDConvertSecondToString(leftTime))
	else
		self.isInCD = false
		self.btnChange:setTitleText(i18n("common_text_243"))
		if self.imgSelectFrm:isVisible() then
			self:changeButton(true)
		end
	end
end
return WorldMapKingdomCityOfficialManagerResBalence
