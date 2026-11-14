local WorldMapKingdomCityAppointSingle = class("worldMapKingdomCityAppointSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityAppointSingle")
	end
	return target
end)
function WorldMapKingdomCityAppointSingle:ctor()
	self.singleData = nil
	self.tmpImgItem, _ENV, self.usrID = nil, nil, nil
	self.spHead = nil
	self.callHandl = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.Node_slave = SoraDGetChildByName(self, "Node_slave")
	self.Node_slave:setLocalZOrder(2)
	self.Node_slave:setVisible(false)
	self.Image_slave = SoraDGetChildByName(self, "Image_slave")
	self.Node_official = SoraDGetChildByName(self, "Node_official")
	self.Node_official:setLocalZOrder(2)
	self.Node_official:setVisible(false)
	self.Image_official = SoraDGetChildByName(self, "Image_official")
	self.imgItem = SoraDGetChildByName(self, "Node_item")
	self.imgItem:setLocalZOrder(1)
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.imgHead:setLocalZOrder(3)
	self.imgHeadFrm = SoraDGetChildByName(self, "Image_frmHead")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtName:setLocalZOrder(4)
	self.txtOfficialName = SoraDGetChildByName(self, "Text_official")
	self.txtOfficialName:setLocalZOrder(4)
	self.imgHeadFrm:setLocalZOrder(0)
	self.panel = SoraDGetChildByName(self, "Panel_Touch")
	self.panel:setSwallowTouches(false)
	self.panel:addTouchEventListener(handler(self, self.panelClick))
	SoraDGetChildByName(self, "Image_d"):setFillType(1)
	self.imgHeadFrm:ignoreContentAdaptWithSize(true)
	self.checkBox = SoraDGetChildByName(self, "CheckBox_item")
	self.checkBox:setSelected(false)
	self.checkBox:setTouchEnabled(false)
	self.checkBox:setSwallowTouches(false)
end
function WorldMapKingdomCityAppointSingle:initData(data)
	local officialInfoRead = include("officialInfoRead")
	self.singleData = officialInfoRead.getInfoByType(data.singleID)
	self.usrID = data.otherData
	self:initView()
end
function WorldMapKingdomCityAppointSingle:initView()
	local officialBuffRead = include("officialBuffRead")
	if next(self.tmpImgItem) ~= nil then
		for k, v in pairs(self.tmpImgItem) do
			v:removeFromParent()
		end
	end
	_UPVALUE1_, self.tmpImgItem, _ENV = pairs(self.tmpImgItem)
	local pairs(self.tmpImgItem)[1], ocxTbl = self.imgItem, pairs(self.tmpImgItem)
	for i = 2, #self.singleData.buff do
		local single = self.imgItem:clone()
		single:setLocalZOrder(1)
		single:addTo(self.imgItem:getParent())
		table.insert(ocxTbl, single)
		table.insert(self.tmpImgItem, single)
	end
	local offsetH = 40
	for i, v in ipairs(self.singleData.buff) do
		ocxTbl[i]:getChildByName("Text_content"):setString(i18n(officialBuffRead.getItem(v).buffDes))
		local pascal = #ocxTbl - 1 - 2 * (i - 1)
		ocxTbl[i]:setPosition(SoraDFPosX(430, 0), -95 + offsetH * pascal / 2)
		if 2 == self.singleData.class then
			ocxTbl[i]:getChildByName("Text_content"):setColor(cc.c3b(190, 40, 40))
		elseif 1 == self.singleData.class then
			ocxTbl[i]:getChildByName("Text_content"):setColor(cc.c3b(0, 190, 30))
		end
	end
	if 2 == self.singleData.class then
		self.imgHeadFrm:loadTexture("frame_throne_contend_04.png", ccui.TextureResType.plistType)
	elseif 1 == self.singleData.class then
		self.imgHeadFrm:loadTexture("frame_throne_contend_03.png", ccui.TextureResType.plistType)
	end
	self.Node_slave:setVisible(2 == self.singleData.class)
	self.Node_official:setVisible(1 == self.singleData.class)
	if self.usrID.iconID then
		SoraDGetHeadFromManager(self.imgHead, self.usrID.iconID, self.usrID.avatar)
	end
	if self.usrID.nickName then
		self.imgHead:setVisible(true)
		self.Image_official:setVisible(false)
		self.Image_slave:setVisible(false)
		self.txtOfficialName:setString(i18n(self.singleData.name))
		self.txtName:setVisible(true)
		self.txtName:setString(self.usrID.nickName)
	else
		self.txtOfficialName:setString(i18n(self.singleData.name))
		self.txtName:setVisible(false)
		self.imgHead:setVisible(false)
		self.Image_official:setVisible(true)
		self.Image_slave:setVisible(true)
		if 1 == self.singleData.class then
			self.Image_official:loadTexture(self.singleData.img, ccui.TextureResType.plistType)
		elseif 2 == self.singleData.class then
			self.Image_slave:loadTexture(self.singleData.img, ccui.TextureResType.plistType)
		end
	end
end
function WorldMapKingdomCityAppointSingle:panelClick(button, type)
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
		self.checkBox:setSelected(not self.checkBox:isSelected())
		if self.callHandl then
			_ENV = not self.checkBox:isSelected()
			;(not self.checkBox:isSelected()).singleID = self.singleData.type
			;(not self.checkBox:isSelected()).usrID = self.usrID.uid
			;(not self.checkBox:isSelected()).isChecked = self.checkBox:isSelected()
			self.callHandl(self, not self.checkBox:isSelected())
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function WorldMapKingdomCityAppointSingle:returnMeInfo(...)
	_UPVALUE0_ = nil
	;(nil).singleID = self.singleData.type
	;(nil).usrID = self.usrID.uid
	;(nil).isChecked = self.checkBox:isSelected()
	return nil
end
function WorldMapKingdomCityAppointSingle:setMeUnCheck(...)
	self.checkBox:setSelected(false)
end
function WorldMapKingdomCityAppointSingle:setScroll(scroll)
	self.scroll = scroll
end
function WorldMapKingdomCityAppointSingle:callBackToParent(handl)
	self.callHandl = handl
end
function WorldMapKingdomCityAppointSingle:returnHeigh(...)
	return 195
end
return WorldMapKingdomCityAppointSingle
