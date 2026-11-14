local GridScrollView = include("GridScrollView")
local gametop = gModuleMgr.getObject("gametop")
local sevenDaysSignCtrl = gametop.playertop_:getModule("sevenDaysSignCtrl")
local itemDesRead = include("itemDesRead")
local sevenDaysSignView = class("sevenDaysSignView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sevenDaysSignView")
	end
	return target
end)
function sevenDaysSignView:ctor()
	self.signData, sevenDaysSignCtrl = nil, nil
	self:initWidget()
	self:addMessage()
	sevenDaysSignCtrl:sendReqInfo()
	SoraDShowLoading(self)
end
function sevenDaysSignView:initWidget(...)
	self.scroll = SoraDGetChildByName(self, "Top_Size_scroll_signs")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	GridScrollView = "Top_Node"
	;("Top_Node")[1] = "Image_frame_bg"
	self.Image_frame_bg = SoraDGetChildByFullPath(self.Top_Node, "Top_Node")
	GridScrollView = "Top_Node"
	;("Top_Node")[1] = "Image_frame_bg_up"
	self.Image_frame_bg_up = SoraDGetChildByFullPath(self.Top_Node, "Top_Node")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_oab")
	GridScrollView = "CCS_commonFramTitle_oab"
	;("CCS_commonFramTitle_oab")[1] = "Text_time"
	self.Text_time = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonFramTitle_oab")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	GridScrollView = "Bottom_Node"
	;("Bottom_Node")[1] = "Image_bottom_bg"
	self.imgBottomBg = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	GridScrollView = "Bottom_Node"
	;("Bottom_Node")[1] = "Text_des"
	self.Text_des = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = "Node_item"
	;("Node_item").col = 3
	;("Node_item").left = 39
	;("Node_item").w = 20
	;("Node_item").h = 10
	;("Node_item").top = 15
	self.scroll:init("Node_item", 0, handler(self, self.createSignItem), handler(self, self.updateSignItem))
	self.Image_frame_bg:loadTexture("bg_qd1.png", ccui.TextureResType.plistType)
	self.ccs_title:setTitle(i18n("activityname_19"))
	self.imgBottomBg:setFillType(1)
	self.Text_des:setString(i18n("common_text_4352"))
end
function sevenDaysSignView:addMessage(...)
	SoraDAddMessage(self, "MESSAGE_SEVENDAYSSIGN_REQ_INFO_BACK", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SEVENDAYSSIGN_SIGN_BACK", function(target, data)
		SoraDCloseLoading(self)
		self:refreshData()
		self.scroll:refreshData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
end
function sevenDaysSignView:initData()
	local startDate, endDate = sevenDaysSignCtrl:getActivityDate()
	sevenDaysSignCtrl = nil
	;(nil).time = os.date("%Y.%m.%d", startDate) .. "——" .. os.date("%Y.%m.%d", endDate)
	self.Text_time:setString(i18n("common_text_1694", nil))
	self:refreshData()
	self.scroll:updateNum(#self.signData)
	self.scroll:scrollToIndex(self.curDay)
	local totalDays = sevenDaysSignCtrl:getTotalDays()
	if totalDays == 7 then
		self.Image_frame_bg_up:setSpriteFrame("bg_qd7.png")
	elseif totalDays == 14 then
		self.Image_frame_bg_up:setSpriteFrame("bg_qd14.png")
	else
		self.Image_frame_bg_up:setVisible(false)
	end
	self:setSignEffect(totalDays)
end
function sevenDaysSignView:refreshData(...)
	self.signData, sevenDaysSignCtrl = nil, nil
	local totalDays = sevenDaysSignCtrl:getTotalDays()
	self.curDay = sevenDaysSignCtrl:getCurDay()
	for i = 1, totalDays do
		sevenDaysSignCtrl = nil
		;(nil).day = i
		;(nil).hasSign = sevenDaysSignCtrl:checkHasSign(i)
		local (nil).curDay, tb = self.curDay, nil
		table.insert(self.signData, tb)
	end
end
function sevenDaysSignView:updateSignItem(item, i)
	item.initData(self.signData[i])
end
function sevenDaysSignView:createSignItem()
	local item = self.Node_item:clone()
	sevenDaysSignCtrl = nil
	;(nil)[1] = "Image_item_bg"
	item.Image_item_bg = SoraDGetChildByFullPath(item, nil)
	sevenDaysSignCtrl = nil
	;(nil)[1] = "item_icon"
	item.item_icon = SoraDGetChildByFullPath(item, nil)
	sevenDaysSignCtrl = nil
	;(nil)[1] = "Text_day"
	item.Text_day = SoraDGetChildByFullPath(item, nil)
	sevenDaysSignCtrl = nil
	;(nil)[1] = "Image_sign"
	item.Image_sign = SoraDGetChildByFullPath(item, nil)
	item.singleIsMoved = false
	item.Image_item_bg:setTouchEnabled(true)
	item.Image_item_bg:setSwallowTouches(false)
	item.Image_item_bg:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
				return
			end
			if item.singleIsMoved then
				item.singleIsMoved = false
				return
			end
			SoraDPlaySound()
			local panel = SoraDCreatePanel("sevenDaysSignPopView")
			_ENV = nil
			;(nil).day = item.info.day
			panel:initData(nil)
			panel:begin2Action()
			panel:show()
			panel:setFromAction(item:convertToWorldSpace(cc.p(25, 40)))
			if self.curDay ~= sevenDaysSignCtrl:getCurDay() then
				self:refreshData()
				self.scroll:refreshData()
			end
		elseif type == ccui.TouchEventType.moved then
			local touchBeganPoint = button:getTouchBeganPosition()
			local touchmovePoint = button:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > 5 then
				item.singleIsMoved = true
			end
		elseif type == ccui.TouchEventType.canceled then
			item.singleIsMoved = false
		end
	end)
	function item.initData(_info)
		item.info = _info
		local curDay = _info.curDay
		if _info.day then
			local reward = sevenDaysSignCtrl:getRewardInfo(_info.day)
			if reward and next(reward) then
				item.item_icon:loadTexture(itemDesRead.getIcon(reward[1]), ccui.TextureResType.plistType)
			end
			item = nil
			;(nil).day = _info.day
			item.Text_day:setString(i18n("common_text_3723", nil))
			_ENV = item.Text_day
			item.Text_day[1] = item.Image_item_bg
			item.Text_day[2] = item.item_icon
			SoraDSetArrayGray(item.Text_day, false)
			item.Text_day:setColor(cc.c3b(240, 230, 210))
			if not _info.hasSign and _info.day == curDay then
				if not item.effectNode then
					local effectNode = SoraDCreatAnimation("qiandao_new_single")
					item.effectNode = effectNode
					effectNode:setPosition(cc.p(2, 9))
					effectNode:setScale(0.93)
					item:addChild(effectNode)
					itemDesRead = item
					item[1] = "Sprite_5"
					item[2] = "dh_qiandaoq_01_5"
					item[3] = "Sprite_11"
					for i, v in ipairs(item) do
						local sp = SoraDGetChildByName(effectNode, v)
						if sp:isOpacityModifyRGB() then
							sp:setBlendFunc(gl.ONE, gl.ONE)
						else
							sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
						end
					end
				end
			else
				if curDay > _info.day then
					_ENV = ipairs(item)
					ipairs(item)[1] = item.Image_item_bg
					ipairs(item)[2] = item.item_icon
					SoraDSetArrayGray(ipairs(item))
					item.Text_day:setColor(cc.c3b(173, 173, 173))
				end
				if item.effectNode then
					item.effectNode:removeFromParent()
					item.effectNode = nil
				end
			end
		end
		if _info.hasSign then
			item.Image_sign:setVisible(true)
		else
			item.Image_sign:setVisible(false)
		end
	end
	return item
end
function sevenDaysSignView:judgeEventClose(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.SEVEN_DAYS_SIGNIN)
	if gActivityState.CLOSE == state then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function sevenDaysSignView:setSignEffect(totalDays)
	local effectNode = SoraDCreatAnimation("qiandao_new")
	effectNode:setPosition(cc.p(125, -662))
	self.Top_Node:addChild(effectNode)
	local Sprite_7 = SoraDGetChildByName(effectNode, "Sprite_21")
	local Sprite_14 = SoraDGetChildByName(effectNode, "Sprite_1")
	_UPVALUE2_ = "Sprite_1"
	;("Sprite_1")[1] = Sprite_7
	;("Sprite_1")[2] = Sprite_14
	for k, sp in pairs("Sprite_1") do
		if sp:isOpacityModifyRGB() then
			sp:setBlendFunc(gl.ONE, gl.ONE)
		else
			sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		end
	end
	if totalDays == 7 then
		Sprite_14:setVisible(false)
	elseif totalDays == 14 then
		Sprite_7:setVisible(false)
	else
		Sprite_7:setVisible(false)
		Sprite_14:setVisible(false)
	end
end
return sevenDaysSignView
