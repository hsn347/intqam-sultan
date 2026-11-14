local legendKingRead = include("legendKingRead")
local gametop = gModuleMgr.getObject("gametop")
local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
local NodeGrantPlayer = class("NodeGrantPlayer", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("NodeGrantPlayer")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function NodeGrantPlayer:ctor()
	self:createUI()
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
function NodeGrantPlayer:createUI()
end
function NodeGrantPlayer:setHandle(handle)
	self.handle = handle
end
function NodeGrantPlayer:init(data, mapid)
	self.itemData = data
	self.mapid = mapid
	local titleBuff = self.itemData.titleBuff
	self.icon_official:setSpriteFrame(titleBuff.img)
	self.text_official:setString(i18n(titleBuff.name))
	local titleInfo = self.itemData.titleInfo
	if titleInfo then
		dump(titleInfo, "玩家数据")
		local playerInfo = titleInfo.playerInfo
		local strName = ""
		if playerInfo.abbr then
			_ENV = i18n(titleBuff.name)
			i18n(titleBuff.name).abbr = playerInfo.abbr
			i18n(titleBuff.name).name = playerInfo.nickname
		end
		strName = i18n("common_text_186", i18n(titleBuff.name)) or playerInfo.nickname
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
		local isKing = false
		if worldMapDefine.isKingStarMapId(self.mapid) then
			isKing = kingStarCtrl:getIsSelfLegendKing()
		else
			isKing = legendLordCtrl:getIsSelfLegendKing()
		end
		if isKing then
			self.btn_add:setVisible(true)
		else
			self.btn_add:setVisible(false)
		end
		self.text_name:setString(i18n("common_text_480"))
	end
	self:showLegendKingBuffs(titleBuff.type)
end
function NodeGrantPlayer:showLegendKingBuffs(buffId)
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
	local buffType = gLegendBuffType.PLAYER
	local buffDesTb = legendKingRead.getBuffDesTbById(buffType, buffId, self.mapid)
	local officialType = legendKingRead.getOfficialType(buffType, buffId, self.mapid)
	local isDown = officialType and 0 == officialType or false
	local color
	if isDown then
		color = cc.c3b(190, 40, 40)
	else
		color = cc.c3b(0, 190, 30)
	end
	local showNum = #buffDesTb
	local _ENV, showNodes = 0, 0
	local _ENV, paddingArray = 190, 190
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
function NodeGrantPlayer:onMessageListener()
end
function NodeGrantPlayer:onClick_btn_add(sender, event)
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
			panel:setLegendOfficialID(self.itemData.titleBuff.type, self.itemData.limitList, self.mapid)
			panel:show()
		end
	end
end
function NodeGrantPlayer:onClick_btn_op(sender, event)
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
		local panel = SoraDCreatePanel("legendaryOfficial")
		panel:init(clone(self.itemData), nil, nil, self.mapid)
		panel:show()
	end
end
function NodeGrantPlayer:setScroll(scroll)
	self.scroll = scroll
end
function NodeGrantPlayer:getItemWidth()
	return self.itemWidth
end
function NodeGrantPlayer:getItemHeight()
	return self.itemHeight
end
return NodeGrantPlayer
