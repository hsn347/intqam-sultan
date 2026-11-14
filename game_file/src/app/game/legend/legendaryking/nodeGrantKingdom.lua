local legendKingRead = include("legendKingRead")
local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local palaceInfoRead = include("palaceInfoRead")
local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
local NodeGrantKingdom = class("NodeGrantKingdom", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("NodeGrantKingdom")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function NodeGrantKingdom:ctor()
	self:createUI()
	self.sprite_frame_top = SoraDGetChildByName(self, "sprite_frame_top")
	self.sprite_frame_top_line = SoraDGetChildByName(self, "sprite_frame_top_line")
	self.sprite_frame_circle = SoraDGetChildByName(self, "sprite_frame_circle")
	self.sprite_circle_frame = SoraDGetChildByName(self, "sprite_circle_frame")
	self.node_sel = SoraDGetChildByName(self, "node_sel")
	self.sprite_sel_bg = SoraDGetChildByName(self, "sprite_sel_bg")
	self.sprite_sel_frm = SoraDGetChildByName(self, "sprite_sel_frm")
	self.btn_add = SoraDGetChildByName(self, "btn_add")
	self.btn_op = SoraDGetChildByName(self, "btn_op")
	self.img_icon = SoraDGetChildByName(self, "img_icon")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.text_official = SoraDGetChildByName(self, "text_official")
	self.icon_official = SoraDGetChildByName(self, "icon_official")
	self.attr_bg_1 = SoraDGetChildByName(self, "attr_bg_1")
	self.attr_text_1 = SoraDGetChildByName(self, "attr_text_1")
	self.attr_bg_2 = SoraDGetChildByName(self, "attr_bg_2")
	self.attr_text_2 = SoraDGetChildByName(self, "attr_text_2")
	self.attr_bg_3 = SoraDGetChildByName(self, "attr_bg_3")
	self.attr_text_3 = SoraDGetChildByName(self, "attr_text_3")
	self.btn_add:addTouchEventListener(handler(self, self.onClick_btn_add))
	self.btn_op:addTouchEventListener(handler(self, self.onClick_btn_op))
	_UPVALUE3_ = self.btn_op.addTouchEventListener
	_UPVALUE3_, self.buffNodes, self.btn_op.addTouchEventListener[1] = self.btn_op.addTouchEventListener, self.btn_op.addTouchEventListener, self.attr_bg_1
	_UPVALUE3_, self.buffNodes, self.btn_op.addTouchEventListener[2] = self.btn_op.addTouchEventListener, self.btn_op.addTouchEventListener, self.attr_bg_2
	_UPVALUE3_, self.buffNodes, self.btn_op.addTouchEventListener[3] = self.btn_op.addTouchEventListener, self.btn_op.addTouchEventListener, self.attr_bg_3
	self.textBuffNodes, self.btn_op.addTouchEventListener[1] = self.btn_op.addTouchEventListener, self.attr_text_1
	self.textBuffNodes, self.btn_op.addTouchEventListener[2] = self.btn_op.addTouchEventListener, self.attr_text_2
	self.textBuffNodes, self.btn_op.addTouchEventListener[3] = self.btn_op.addTouchEventListener, self.attr_text_3
	self.btn_add:setSwallowTouches(false)
	self.btn_op:setSwallowTouches(false)
	self.itemWidth = 640
	self.oriItemHeight = 150
	self.itemHeight = self.oriItemHeight
	self.itemSize = cc.size(self.itemWidth, self.itemHeight)
end
function NodeGrantKingdom:createUI()
end
function NodeGrantKingdom:setHandle(handle)
	self.handle = handle
end
function NodeGrantKingdom:init(data, mapid)
	self.itemData = data
	self.mapid = mapid
	local titleBuff = self.itemData.titleBuff
	self.icon_official:setSpriteFrame(titleBuff.img)
	self.text_official:setString(i18n(titleBuff.name))
	local titleInfo = self.itemData.titleInfo
	if titleInfo then
		local kid = titleInfo.kid
		local ret, kInfo = kingdomCtrl:isFoundKingdomID(kid)
		if ret then
			local icon = palaceInfoRead.getIcon(kInfo.palaceModel or 1)
			self.img_icon:loadTexture(icon, ccui.TextureResType.plistType)
			self.text_name:setString(kInfo.kname)
			self.img_icon:setVisible(true)
		else
			self.text_name:setString("#" .. titleInfo.kid)
		end
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
function NodeGrantKingdom:showLegendKingBuffs(buffId)
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
	local buffType = gLegendBuffType.KINGDOM
	local officialType = legendKingRead.getOfficialType(buffType, buffId, self.mapid)
	local isDown = officialType and 0 == officialType or false
	local color
	if isDown then
		color = cc.c3b(190, 40, 40)
	else
		color = cc.c3b(0, 190, 30)
	end
	local buffDesTb = legendKingRead.getBuffDesTbById(buffType, buffId, self.mapid)
	local showNum = #buffDesTb
	local _ENV, showNodes = buffId, buffId
	local _ENV, paddingArray = self.mapid, self.mapid
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
function NodeGrantKingdom:onMessageListener()
end
function NodeGrantKingdom:onClick_btn_add(sender, event)
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
		print("点击了添加按钮--------")
		SoraDPlaySound()
		_ENV = "点击了添加按钮--------"
		;("点击了添加按钮--------").msg = "MESSAGE_UI_LEGENDKING_SHOW_WORLDMAP_KINGDOM"
		;("点击了添加按钮--------").legendKingdomTitleID = self.itemData.titleBuff.type
		SoraDSendMessage("点击了添加按钮--------")
	end
end
function NodeGrantKingdom:setScroll()
	self.scroll = scroll
end
function NodeGrantKingdom:onClick_btn_op(sender, event)
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
		print("点击了操作按钮--------")
		SoraDPlaySound()
	end
end
function NodeGrantKingdom:getItemWidth()
	return self.itemWidth
end
function NodeGrantKingdom:getItemHeight()
	return self.itemHeight
end
return NodeGrantKingdom
