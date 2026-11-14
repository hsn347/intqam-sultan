local gametop = gModuleMgr.getObject("gametop")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local hegemonRead = include("hegemonRead")
local HegemonGrantPlayerNode = class("hegemonGrantPlayerNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("hegemonGrantPlayerNode")
	end
	return target
end)
function HegemonGrantPlayerNode:ctor()
	self.sprite_frame_top = SoraDGetChildByName(self, "sprite_frame_top")
	self.sprite_frame_top_line = SoraDGetChildByName(self, "sprite_frame_top_line")
	self.sprite_icon_bg = SoraDGetChildByName(self, "sprite_icon_bg")
	self.icon_official = SoraDGetChildByName(self, "icon_official")
	self.node_sel = SoraDGetChildByName(self, "node_sel")
	self.sprite_sel_bg = SoraDGetChildByName(self, "sprite_sel_bg")
	self.sprite_sel_frm = SoraDGetChildByName(self, "sprite_sel_frm")
	self.btn_op = SoraDGetChildByName(self, "btn_op")
	self.btn_add = SoraDGetChildByName(self, "btn_add")
	self.img_icon = SoraDGetChildByName(self, "img_icon")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.text_official = SoraDGetChildByName(self, "text_official")
	self.attr_bg_1 = SoraDGetChildByName(self, "attr_bg_1")
	self.attr_text_1 = SoraDGetChildByName(self, "attr_text_1")
	self.attr_bg_2 = SoraDGetChildByName(self, "attr_bg_2")
	self.attr_text_2 = SoraDGetChildByName(self, "attr_text_2")
	self.attr_bg_3 = SoraDGetChildByName(self, "attr_bg_3")
	self.attr_text_3 = SoraDGetChildByName(self, "attr_text_3")
	self.img_bg_down = SoraDGetChildByName(self, "img_bg_down")
	self.img_bg_down:setVisible(false)
	self.btn_add:addTouchEventListener(handler(self, self.onClick_btn_add))
	_UPVALUE3_ = self.btn_add.addTouchEventListener
	_UPVALUE3_, self.buffNodes, self.btn_add.addTouchEventListener[1] = self.btn_add.addTouchEventListener, self.btn_add.addTouchEventListener, self.attr_bg_1
	_UPVALUE3_, self.buffNodes, self.btn_add.addTouchEventListener[2] = self.btn_add.addTouchEventListener, self.btn_add.addTouchEventListener, self.attr_bg_2
	_UPVALUE3_, self.buffNodes, self.btn_add.addTouchEventListener[3] = self.btn_add.addTouchEventListener, self.btn_add.addTouchEventListener, self.attr_bg_3
	self.textBuffNodes, self.btn_add.addTouchEventListener[1] = self.btn_add.addTouchEventListener, self.attr_text_1
	self.textBuffNodes, self.btn_add.addTouchEventListener[2] = self.btn_add.addTouchEventListener, self.attr_text_2
	self.textBuffNodes, self.btn_add.addTouchEventListener[3] = self.btn_add.addTouchEventListener, self.attr_text_3
	self.btn_op:addTouchEventListener(handler(self, self.onClick_btn_op))
	self.btn_add:setSwallowTouches(false)
	self.btn_op:setSwallowTouches(false)
	self.itemWidth = 640
	self.oriItemHeight = 150
	self.itemHeight = self.oriItemHeight
	self.itemSize = cc.size(self.itemWidth, self.itemHeight)
end
function HegemonGrantPlayerNode:setHandle(handle)
	self.handle = handle
end
function HegemonGrantPlayerNode:init(data, bid)
	self.itemData = data
	self.bid = bid
	if bid == nil then
		print(debug.traceback())
	end
	local titleBuff = self.itemData.titleBuff
	self.icon_official:setSpriteFrame(titleBuff.Image)
	self.text_official:setString(i18n(titleBuff.Name))
	local titleInfo = self.itemData.titleInfo
	if titleInfo then
		local playerInfo = titleInfo.playerInfo
		local strName = ""
		if playerInfo.abbr then
			_ENV = i18n(titleBuff.Name)
			i18n(titleBuff.Name).abbr = playerInfo.abbr
			i18n(titleBuff.Name).name = playerInfo.nickname
		end
		strName = i18n("common_text_186", i18n(titleBuff.Name)) or playerInfo.nickname
		if playerInfo.kid then
			strName = strName .. "#" .. playerInfo.kid
		end
		self.text_name:setString(strName)
		SoraDGetHeadFromManager(self.img_icon, playerInfo.iconID, playerInfo.avatar)
		self.img_icon:setVisible(true)
		self.btn_add:setVisible(false)
		self.btn_op:setVisible(true)
	else
		self.img_icon:setVisible(false)
		self.btn_op:setVisible(false)
		print("hegemonCtrl:getJoinBid = ", hegemonCtrl:getJoinBid(), ", self.bid = ", self.bid)
		if hegemonCtrl:getIsSelfHegemon() and hegemonCtrl:getJoinBid() == self.bid then
			self.btn_add:setVisible(true)
		else
			self.btn_add:setVisible(false)
		end
		self.text_name:setString(i18n("common_text_480"))
	end
	self:showLegendKingBuffs(titleBuff.Digitype)
end
function HegemonGrantPlayerNode:showLegendKingBuffs(buffId)
	local limitTextWidth = 338
	local normalTotalHeight = 92
	for i = 1, #self.buffNodes do
		self.buffNodes[i]:setVisible(false)
		self.buffNodes[i]:setContentSize(cc.size(325, 36))
		self.textBuffNodes[i]:setVisible(false)
		self.textBuffNodes[i]:setString("")
		self.textBuffNodes[i]:ignoreContentAdaptWithSize(true)
		self.textBuffNodes[i]:setTextAreaSize(cc.size(0, 0))
	end
	local buffDesTb = hegemonRead.getBuffDesTbById(buffId)
	local officialType = hegemonRead.getOfficialType(buffId)
	local isDown = officialType and 0 == officialType or false
	local color
	if isDown then
		color = cc.c3b(190, 40, 40)
		self.sprite_icon_bg:setSpriteFrame("frame_touxiangkuang_02.png")
	else
		color = cc.c3b(0, 190, 30)
		self.sprite_icon_bg:setSpriteFrame("frame_touxiangkuang_01.png")
	end
	self.img_bg_down:setVisible(isDown)
	local showNum = #buffDesTb
	local _ENV, showNodes = self.img_bg_down, self.img_bg_down
	local _ENV, paddingArray = isDown, isDown
	for i, v in ipairs(buffDesTb) do
		if self.buffNodes[i] then
			self.buffNodes[i]:setVisible(true)
			self.textBuffNodes[i]:setVisible(true)
		end
		if self.textBuffNodes[i] then
			self.textBuffNodes[i]:setString(v)
			self.textBuffNodes[i]:setColor(color)
			if limitTextWidth < self.textBuffNodes[i]:getContentSize().width then
				local height = SoraDGetAutoHeightLabel(self.textBuffNodes[i], limitTextWidth)
				self.buffNodes[i]:setContentSize(cc.size(325, height + 13))
			end
		end
		showNodes[i] = self.buffNodes[i]
		if 1 < i then
			paddingArray[i - 1] = 2
		end
	end
	local accuHeight = SoraDAlignNodeArrayV(showNodes, true, paddingArray)
	for i = 1, showNum do
		self.textBuffNodes[i]:setPositionY(self.buffNodes[i]:getPositionY() - 2)
	end
	if normalTotalHeight < accuHeight then
		local deltaHeight = accuHeight - normalTotalHeight
		self.itemHeight = self.oriItemHeight + deltaHeight
	end
	self.itemSize = cc.size(self.itemWidth, self.itemHeight)
end
function HegemonGrantPlayerNode:onMessageListener()
end
function HegemonGrantPlayerNode:onClick_btn_add(sender, event)
	if event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(self)
		else
			local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
			panel:setLegendOfficialID(self.itemData.titleBuff.type, self.itemData.limitList)
			panel:show()
		end
	end
end
function HegemonGrantPlayerNode:onClick_btn_op(sender, event)
	if event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("node is not on view")
			return
		end
		print("点击了操作按钮-----")
		SoraDPlaySound()
		local panel = SoraDCreatePanel("hegemonOfficial")
		self.itemData.bid = self.bid
		panel:init(clone(self.itemData))
		panel:show()
	end
end
function HegemonGrantPlayerNode:setScroll(scroll)
	self.scroll = scroll
end
function HegemonGrantPlayerNode:getItemWidth()
	return self.itemWidth
end
function HegemonGrantPlayerNode:getItemHeight()
	return self.itemHeight
end
return HegemonGrantPlayerNode
