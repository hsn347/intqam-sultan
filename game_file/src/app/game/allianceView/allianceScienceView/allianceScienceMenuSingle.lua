_ENV = nil
;(nil).RECOMMEND = 1
;(nil).OPEN = 2
local (nil).LOCK, SingleDataType = 3, nil
local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local AllianceScienceMenuSingle = class("allianceScienceMenuSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceScienceMenuSingle")
	end
	return target
end)
function AllianceScienceMenuSingle:ctor()
	self.tableSinglePoint, _ENV, self.tableSingleData, _ENV = nil, nil, nil, nil
	self.isLaunched = false
	self.handl = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.spriteArr = SoraDGetChildByName(self, "Sprite_arr")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelLv = SoraDGetChildByName(self, "Text_lv")
	self.layerMember = SoraDGetChildByName(self, "Panel_member")
	self.imgLvBg = SoraDGetChildByName(self, "Image_1")
	self.layerMember:setSwallowTouches(false)
	self.imgUpgrade = SoraDGetChildByName(self, "img_upgrade")
	if self.layerTouch then
		self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceScienceMenuSingle:updateSingleH()
	if self.isLaunched then
		local panelH = 0
		for i, v in ipairs(self.tableSinglePoint) do
			panelH = panelH + v:getSingleH()
			v:setPosition(cc.p(320, panelH))
		end
		self.layerMember:setContentSize(cc.size(640, panelH))
		if self.handl then
			self.handl(self, self.isLaunched)
		end
	end
end
function AllianceScienceMenuSingle:initData(singleData)
	self.tableSingleData = singleData
	local singleDataType = singleData.singleDataType
	self.imgUpgrade:setVisible(false)
	self:updateOtherUI()
	if singleDataType == SingleDataType.RECOMMEND then
		local strDes = i18n("alliance_text_01") .. string.format("(%d/%d)", #singleData.data, 2)
		self.labelDes:setString(strDes)
		self.imgUpgrade:setVisible(true)
	else
		self.labelLv:setString(tostring(singleData.index))
	end
	self:removeScience()
	if self.isLaunched then
		self:initScience()
	end
end
function AllianceScienceMenuSingle:updateNextGroup(isOpened)
	if isOpened and self.tableSingleData.isOpened == false then
		self.tableSingleData.isOpened = true
		for i, v in ipairs(self.tableSinglePoint) do
			v:updateData()
		end
	end
	self:updateOtherUI()
end
function AllianceScienceMenuSingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeScience()
		self.spriteArr:setRotation(90)
		if not SoraDFIsRA() then
			self.spriteArr:setRotation(-90)
		end
	else
		self:initScience()
		self.spriteArr:setRotation(SoraDFPosX(0, 0))
	end
	self.isLaunched = state
end
function AllianceScienceMenuSingle:updateOtherUI()
	if self.tableSingleData.isOpened then
		self.labelDes:setString("")
	else
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		local curLv = allianceScience:getCurSciTotalLv()
		_ENV = nil
		;(nil).cur = curLv
		;(nil).need = self.tableSingleData.needLv
		self.labelDes:setString(i18n("common_text_278", nil))
	end
end
function AllianceScienceMenuSingle:initScience()
	local panelH = 0
	for i = #self.tableSingleData.data, 1, -1 do
		local v = self.tableSingleData.data[i]
		local single = SoraDCreatePanel("allianceScienceSingle")
		if not self.tableSingleData.isOpened then
			_ENV = self.tableSingleData.isOpened
			v, self.tableSingleData.isOpened.id = self.tableSingleData.isOpened, v
		end
		single:addTo(self.layerMember)
		table.insert(self.tableSinglePoint, single)
		_ENV = single
		single.data = v
		single.isOpened = self.tableSingleData.isOpened
		single:initData(single)
		single:setScroll(self.scroll)
		panelH = panelH + single:getSingleH()
		single:setPosition(cc.p(320, panelH))
		single:singleHeightUpdateCallBack(handler(self, self.updateSingleH))
	end
	self.layerMember:setContentSize(cc.size(640, panelH))
end
function AllianceScienceMenuSingle:removeScience()
	self.layerMember:removeAllChildren()
	self.tableSinglePoint, _ENV = self.layerMember.removeAllChildren, self.layerMember.removeAllChildren
	self.layerMember:setContentSize(cc.size(640, 0))
end
function AllianceScienceMenuSingle:getSingleH()
	return self.layerMember:getContentSize().height + self.layerTouch:getContentSize().height
end
function AllianceScienceMenuSingle:setClickCallBack(handle)
	self.handl = handle
end
function AllianceScienceMenuSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceScienceMenuSingle:jumpToSicence(sid)
	local offsetY = self:getPositionY()
	for i, v in ipairs(self.tableSingleData.data) do
		if type(v) == "table" and v.id and v.id == sid or type(v) == "number" and v == sid then
			if self.scroll and self.handl then
				offsetY = offsetY - (180 * #self.tableSingleData.data - self.tableSinglePoint[i]:getPositionY()) - 0.5 * self.scroll:getContentSize().height - 140
				self.scroll:getInnerContainer():setPositionY(-offsetY)
				self.handl(self, self.isLaunched)
			end
			return true
		end
	end
	return false
end
function AllianceScienceMenuSingle:btnClickCallBack(button, type)
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
		if self.tableSingleData.data and #self.tableSingleData.data > 0 then
			local firstData = self.tableSingleData.data[1]
			local firstID = self.tableSingleData.isOpened and firstData.id or firstData
			if not allianceDesRead.isScience(firstID) then
				SoraDUpdateDownload(true, true)
				return
			end
		end
		self:setState(not self.isLaunched)
		if self.handl then
			self.handl(self, self.isLaunched)
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
return AllianceScienceMenuSingle
