local cityCtrl = SoraDGetCtrl("cityCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local masteryDrawView = class("masteryDrawView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("masteryDrawView")
	end
	return target
end)
_ENV = "masteryDrawView"
;("masteryDrawView").ERR = 0
;("masteryDrawView").READY = 1
;("masteryDrawView").DRAWING = 2
local ("masteryDrawView").FINISH, DRAWING_STATE = 3, "masteryDrawView"
local DRAWING_ITEM_ID = 852501
_UPVALUE3_ = nil
;(nil)[1] = 853101
;(nil)[2] = 853102
local (nil)[3], SPEED_ITEM_ID_LIST = 853103, nil
function masteryDrawView:ctor()
	self.isHideCurrentSceneView = true
	self.checkBoxList, DRAWING_STATE, self.state = DRAWING_STATE.ERR, DRAWING_STATE.ERR, DRAWING_STATE.ERR
	self.curCheckIndex = 1
	self.itemAddBuff = 0
	self.effectItemList, DRAWING_STATE, self.costItems, DRAWING_STATE, self.masteryAddBuff = DRAWING_STATE.ERR, DRAWING_STATE.ERR, DRAWING_STATE.ERR, DRAWING_STATE.ERR, 0
	self:initWidget()
	self:initDeviceFit()
	self:initEffectNode()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_UPDATE_MASTERY_DRAWING_VIEW", handler(self, self.msgUpdateView))
end
function masteryDrawView:msgUpdateView(target, event)
	SoraDCloseLoading(self)
	SoraDRemoveAllAfterPanelFromManager(self, true)
	local preSate = self.state
	self.state = self:getDrawState()
	self:refreshState(self.state)
	if preSate == DRAWING_STATE.DRAWING and self.state == DRAWING_STATE.READY then
		SoraDShowMsgTip(i18n("drawing_text_12"))
	end
end
function masteryDrawView:initWidget(...)
	local ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_build")
	ccs_title:setTitle(i18n("drawing_text_01"))
	self.ccs_title = ccs_title
	_UPVALUE1_ = i18n("drawing_text_01")
	i18n("drawing_text_01")[1] = "Button_help"
	local Button_help = SoraDGetChildByFullPath(ccs_title, i18n("drawing_text_01"))
	Button_help:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.MASTERY_DRAW)
		end
	end)
	local root = self._ccsView
	_UPVALUE1_ = i18n("drawing_text_01")
	i18n("drawing_text_01")[1] = "Top_Node"
	self.Top_Node = SoraDGetChildByFullPath(root, i18n("drawing_text_01"))
	_UPVALUE1_ = i18n("drawing_text_01")
	i18n("drawing_text_01")[1] = "Text_top"
	self.Text_top = SoraDGetChildByFullPath(self.Top_Node, i18n("drawing_text_01"))
	self.Text_top:setString(i18n("drawing_text_14") .. i18n("drawing_text_15"))
	_UPVALUE1_ = i18n("drawing_text_14") .. i18n("drawing_text_15")
	;(i18n("drawing_text_14") .. i18n("drawing_text_15"))[1] = "Image_1"
	self.Image_1 = SoraDGetChildByFullPath(self.Top_Node, i18n("drawing_text_14") .. i18n("drawing_text_15"))
	_UPVALUE1_ = i18n("drawing_text_14") .. i18n("drawing_text_15")
	;(i18n("drawing_text_14") .. i18n("drawing_text_15"))[1] = "Center_Node"
	self.Center_Node = SoraDGetChildByFullPath(root, i18n("drawing_text_14") .. i18n("drawing_text_15"))
	_UPVALUE1_ = i18n("drawing_text_14") .. i18n("drawing_text_15")
	;(i18n("drawing_text_14") .. i18n("drawing_text_15"))[1] = "Node_ready"
	self.Node_ready = SoraDGetChildByFullPath(self.Center_Node, i18n("drawing_text_14") .. i18n("drawing_text_15"))
	_UPVALUE1_ = i18n("drawing_text_14") .. i18n("drawing_text_15")
	;(i18n("drawing_text_14") .. i18n("drawing_text_15"))[1] = "Node_add_1"
	self.Node_add_1 = SoraDGetChildByFullPath(self.Node_ready, i18n("drawing_text_14") .. i18n("drawing_text_15"))
	_UPVALUE1_ = i18n("drawing_text_14") .. i18n("drawing_text_15")
	;(i18n("drawing_text_14") .. i18n("drawing_text_15"))[1] = "Button_add"
	SoraDGetChildByFullPath(self.Node_add_1, i18n("drawing_text_14") .. i18n("drawing_text_15")):addTouchEventListener(handler(self, self.onClick_add))
	_UPVALUE1_ = handler(self, self.onClick_add)
	handler(self, self.onClick_add)[1] = "Node_add_2"
	self.Node_add_2 = SoraDGetChildByFullPath(self.Node_ready, handler(self, self.onClick_add))
	_UPVALUE1_ = handler(self, self.onClick_add)
	handler(self, self.onClick_add)[1] = "Button_add"
	SoraDGetChildByFullPath(self.Node_add_2, handler(self, self.onClick_add)):addTouchEventListener(handler(self, self.onClick_add))
	_UPVALUE1_ = handler(self, self.onClick_add)
	handler(self, self.onClick_add)[1] = "Node_text_tool"
	self.Node_text_tool = SoraDGetChildByFullPath(self.Node_ready, handler(self, self.onClick_add))
	_UPVALUE1_ = handler(self, self.onClick_add)
	handler(self, self.onClick_add)[1] = "Text_tool_des"
	SoraDGetChildByFullPath(self.Node_text_tool, handler(self, self.onClick_add)):setString(i18n("drawing_text_02"))
	_UPVALUE1_ = i18n("drawing_text_02")
	i18n("drawing_text_02")[1] = "Text_tool_value"
	self.Text_tool_value = SoraDGetChildByFullPath(self.Node_text_tool, i18n("drawing_text_02"))
	self.Text_tool_value = SoraDCreateScoreLabel(self.Text_tool_value)
	self.Text_tool_value:setUpdateHandler(function(numText)
		self.Text_tool_value:setString(string.format("+%d%%", numText))
	end)
	function _UPVALUE1_(numText)
		self.Text_tool_value:setString(string.format("+%d%%", numText))
	end
	;(function(numText)
		self.Text_tool_value:setString(string.format("+%d%%", numText))
	end)[1] = "Node_text_mastery"
	self.Node_text_mastery = SoraDGetChildByFullPath(self.Node_ready, function(numText)
		self.Text_tool_value:setString(string.format("+%d%%", numText))
	end)
	function _UPVALUE1_(numText)
		self.Text_tool_value:setString(string.format("+%d%%", numText))
	end
	;(function(numText)
		self.Text_tool_value:setString(string.format("+%d%%", numText))
	end)[1] = "Text_mastery_des"
	SoraDGetChildByFullPath(self.Node_text_mastery, function(numText)
		self.Text_tool_value:setString(string.format("+%d%%", numText))
	end):setString(i18n("drawing_text_03"))
	_UPVALUE1_ = i18n("drawing_text_03")
	i18n("drawing_text_03")[1] = "Text_mastery_value"
	self.Text_mastery_value = SoraDGetChildByFullPath(self.Node_text_mastery, i18n("drawing_text_03"))
	self.Text_mastery_value = SoraDCreateScoreLabel(self.Text_mastery_value)
	self.Text_mastery_value:setUpdateHandler(function(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end)
	function _UPVALUE1_(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end
	;(function(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end)[1] = "Node_choose_time"
	self.Node_choose_time = SoraDGetChildByFullPath(self.Node_ready, function(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end)
	function _UPVALUE1_(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end
	;(function(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end)[1] = "Image_checkBox"
	self.Image_checkBox = SoraDGetChildByFullPath(self.Node_choose_time, function(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end)
	function _UPVALUE1_(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end
	;(function(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end)[1] = "Image_select"
	self.Image_select = SoraDGetChildByFullPath(self.Node_choose_time, function(numText)
		self.Text_mastery_value:setString(string.format("+%d%%", numText))
	end)
	self.Image_select:setLocalZOrder(99)
	self:initCheckBox()
	_UPVALUE1_ = 99
	;(99)[1] = "Button_draw"
	self.Button_draw = SoraDGetChildByFullPath(self.Node_ready, 99)
	self.Button_draw:setTitleText(i18n("drawing_text_06"))
	self.Button_draw:addTouchEventListener(handler(self, self.onClick_draw))
	_UPVALUE1_ = handler(self, self.onClick_draw)
	handler(self, self.onClick_draw)[1] = "Node_reward"
	self.Node_reward_1 = SoraDGetChildByFullPath(self.Node_ready, handler(self, self.onClick_draw))
	_UPVALUE1_ = handler(self, self.onClick_draw)
	handler(self, self.onClick_draw)[1] = "Text_reward"
	SoraDGetChildByFullPath(self.Node_reward_1, handler(self, self.onClick_draw)):setString(i18n("drawing_text_10"))
	_UPVALUE1_ = i18n("drawing_text_10")
	i18n("drawing_text_10")[1] = "Text_value"
	self.Text_value_1 = SoraDGetChildByFullPath(self.Node_reward_1, i18n("drawing_text_10"))
	_UPVALUE1_ = i18n("drawing_text_10")
	i18n("drawing_text_10")[1] = "Text_value_add"
	self.Text_value_add_1 = SoraDGetChildByFullPath(self.Node_reward_1, i18n("drawing_text_10"))
	self.Text_value_1 = SoraDCreateScoreLabel(self.Text_value_1)
	self.Text_value_add_1 = SoraDCreateScoreLabel(self.Text_value_add_1)
	self.Text_value_add_1:setUpdateHandler(function(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end)
	function _UPVALUE1_(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end
	;(function(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end)[1] = "Node_drawing"
	self.Node_drawing = SoraDGetChildByFullPath(self.Center_Node, function(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end)
	function _UPVALUE1_(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end
	;(function(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end)[1] = "icon_pen"
	self.icon_pen = SoraDGetChildByFullPath(self.Node_drawing, function(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end)
	function _UPVALUE1_(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end
	;(function(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end)[1] = "Text_drawing"
	SoraDGetChildByFullPath(self.Node_drawing, function(numText)
		self.Text_value_add_1:setString(string.format("(+%d)", numText))
	end):setString(i18n("drawing_text_09"))
	self.loadingBar = SoraDGetExtendChildFromCCSByName(self.Node_drawing, "CCS_commonProgressBar_time")
	_UPVALUE1_ = "CCS_commonProgressBar_time"
	;("CCS_commonProgressBar_time")[1] = "Text_leftTime"
	self.Text_leftTime = SoraDGetChildByFullPath(self.loadingBar, "CCS_commonProgressBar_time")
	self.Text_leftTime = SoraDCreateTimerLabel(self, self.Text_leftTime)
	_UPVALUE1_ = self.Text_leftTime
	self.Text_leftTime[1] = "Text_des"
	self.Text_des = SoraDGetChildByFullPath(self.Node_drawing, self.Text_leftTime)
	self.Text_des:setString(i18n("drawing_text_08"))
	_UPVALUE1_ = i18n("drawing_text_08")
	i18n("drawing_text_08")[1] = "Button_cancel"
	self.Button_cancel = SoraDGetChildByFullPath(self.Node_drawing, i18n("drawing_text_08"))
	self.Button_cancel:setTitleText(i18n("common_text_185"))
	self.Button_cancel:addTouchEventListener(handler(self, self.onClick_cancel))
	_UPVALUE1_ = handler(self, self.onClick_cancel)
	handler(self, self.onClick_cancel)[1] = "Node_reward"
	self.Node_reward_2 = SoraDGetChildByFullPath(self.Node_drawing, handler(self, self.onClick_cancel))
	_UPVALUE1_ = handler(self, self.onClick_cancel)
	handler(self, self.onClick_cancel)[1] = "Text_reward"
	SoraDGetChildByFullPath(self.Node_reward_2, handler(self, self.onClick_cancel)):setString(i18n("drawing_text_10"))
	_UPVALUE1_ = i18n("drawing_text_10")
	i18n("drawing_text_10")[1] = "Text_value"
	self.Text_value_2 = SoraDGetChildByFullPath(self.Node_reward_2, i18n("drawing_text_10"))
	_UPVALUE1_ = i18n("drawing_text_10")
	i18n("drawing_text_10")[1] = "Text_value_add"
	self.Text_value_add_2 = SoraDGetChildByFullPath(self.Node_reward_2, i18n("drawing_text_10"))
	_UPVALUE1_ = i18n("drawing_text_10")
	i18n("drawing_text_10")[1] = "Node_finish"
	self.Node_finish = SoraDGetChildByFullPath(self.Center_Node, i18n("drawing_text_10"))
	_UPVALUE1_ = i18n("drawing_text_10")
	i18n("drawing_text_10")[1] = "Sprite_item"
	self.Sprite_item = SoraDGetChildByFullPath(self.Node_finish, i18n("drawing_text_10"))
	_UPVALUE1_ = i18n("drawing_text_10")
	i18n("drawing_text_10")[1] = "Text_finish"
	SoraDGetChildByFullPath(self.Node_finish, i18n("drawing_text_10")):setString(i18n("drawing_text_13"))
	_UPVALUE1_ = i18n("drawing_text_13")
	i18n("drawing_text_13")[1] = "Button_receive"
	self.Button_receive = SoraDGetChildByFullPath(self.Node_finish, i18n("drawing_text_13"))
	self.Button_receive:setTitleText(i18n("common_text_1146"))
	self.Button_receive:addTouchEventListener(handler(self, self.onClick_receive))
	_UPVALUE1_ = handler(self, self.onClick_receive)
	handler(self, self.onClick_receive)[1] = "Node_reward"
	self.Node_reward_3 = SoraDGetChildByFullPath(self.Node_finish, handler(self, self.onClick_receive))
	_UPVALUE1_ = handler(self, self.onClick_receive)
	handler(self, self.onClick_receive)[1] = "Text_reward"
	SoraDGetChildByFullPath(self.Node_reward_3, handler(self, self.onClick_receive)):setString(i18n("drawing_text_17"))
	_UPVALUE1_ = i18n("drawing_text_17")
	i18n("drawing_text_17")[1] = "Text_value"
	self.Text_value_3 = SoraDGetChildByFullPath(self.Node_reward_3, i18n("drawing_text_17"))
	_UPVALUE1_ = i18n("drawing_text_17")
	i18n("drawing_text_17")[1] = "Text_value_add"
	self.Text_value_add_3 = SoraDGetChildByFullPath(self.Node_reward_3, i18n("drawing_text_17"))
	_UPVALUE1_ = i18n("drawing_text_17")
	i18n("drawing_text_17")[1] = "Bottom_Node"
	self.Bottom_Node = SoraDGetChildByFullPath(root, i18n("drawing_text_17"))
	_UPVALUE2_ = i18n("drawing_text_17")
	i18n("drawing_text_17")[1] = "Node_bottomLine"
	i18n("drawing_text_17")[2] = "Text_bottom"
	SoraDGetChildByFullPath(self.Bottom_Node, i18n("drawing_text_17")):setString(i18n("drawing_text_16"))
	_UPVALUE2_ = i18n("drawing_text_16")
	i18n("drawing_text_16")[1] = "Node_bottomLine"
	i18n("drawing_text_16")[2] = "Sprite_left"
	self.Sprite_left = SoraDGetChildByFullPath(self.Bottom_Node, i18n("drawing_text_16"))
	_UPVALUE2_ = i18n("drawing_text_16")
	i18n("drawing_text_16")[1] = "Node_bottomLine"
	i18n("drawing_text_16")[2] = "Sprite_right"
	self.Sprite_right = SoraDGetChildByFullPath(self.Bottom_Node, i18n("drawing_text_16"))
end
function masteryDrawView:initDeviceFit(...)
	if display.height < 960 then
		self.Center_Node:setPositionY(self.Center_Node:getPositionY() + 50)
		self.Node_text_tool:setPositionY(self.Node_text_tool:getPositionY() - 30)
		self.Node_text_mastery:setPositionY(self.Node_text_mastery:getPositionY() - 30)
		self.Text_top:setVisible(false)
	end
end
function masteryDrawView:initData(...)
	self.state = self:getDrawState()
	self.masteryAddBuff = self:computeMasteryAddBuff()
	self:refreshState(self.state)
	if self.state == DRAWING_STATE.READY then
		self.isHideCurrentSceneView = false
		self:showEnterAction()
	end
end
function masteryDrawView:getDrawingTime(index)
	if not self.drawing_config then
		local config = require_data("drawing_config", true)
		self.drawing_config = config.data
	end
	local data = self.drawing_config[index]
	return data and data.time or 0
end
function masteryDrawView:getDrawingReward(index)
	if not self.drawing_config then
		local config = require_data("drawing_config", true)
		self.drawing_config = config.data
	end
	local data = self.drawing_config[index]
	return data and data.reward and data.reward[2] or 0
end
function masteryDrawView:initCheckBox(...)
	for i = 1, 4 do
		local box
		if i == 1 then
			box = self.Image_checkBox
		else
			box = self.Image_checkBox:clone()
			box:addTo(self.Node_choose_time)
		end
		box:setTag(i)
		box:addTouchEventListener(handler(self, self.onClick_checkBox))
		local num = math.ceil(self:getDrawingTime(i) / 3600)
		_UPVALUE1_ = i
		i[1] = "Text_time"
		_ENV = handler(self, self.onClick_checkBox)
		handler(self, self.onClick_checkBox).num = num
		SoraDGetChildByFullPath(box, i):setString(i18n("drawing_text_04", handler(self, self.onClick_checkBox)))
		local col = (i - 1) % 2 + 1
		local row = math.ceil(i / 2)
		box:setPosition(cc.p(-180 + 300 * (col - 1), 28 - 66 * (row - 1)))
		self.checkBoxList[i] = box
	end
end
function masteryDrawView:refreshState(state)
	queueCtrl = nil
	;(nil)[1] = self.Node_ready
	;(nil)[2] = self.Node_drawing
	local (nil)[3], nodeList = self.Node_finish, nil
	for i, node in ipairs(nodeList) do
		node:setVisible(i == state)
	end
	if state == DRAWING_STATE.READY then
		self:selectCheckBox(1)
		local masteryAddBuff = buffCtrl:getBuffEffect(gBuffEffect.DRAWING_OUTPUT_ADD) or 0
		self:setBuffAddValue(self.Text_tool_value, 0, 0)
		self:setBuffAddValue(self.Text_mastery_value, masteryAddBuff / 10, (self.lastMasteryAdd or 0) / 10)
		self.lastMasteryAdd = masteryAddBuff
	else
		self:cleanItemAddBuff()
	end
	if state == DRAWING_STATE.DRAWING then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.construction_drawing)
		if queue then
			local totalTime = queue.ottime or queue.totaltime
			local remainTime = queue.timerNode.timer:getRemainTime()
			_ENV = (self.lastMasteryAdd or 0) / 10
			;(self.lastMasteryAdd or 0) / 10.maxValue = totalTime
			;(self.lastMasteryAdd or 0) / 10.curValue = totalTime - remainTime
			self.loadingBar:setProgressDate((self.lastMasteryAdd or 0) / 10)
			self.Text_leftTime:beginTime(remainTime)
			self.Text_leftTime:setTimeUpdateListener(function(leftTime)
				local curValue = totalTime - leftTime
				self.loadingBar:updateData(curValue)
			end)
		end
		self.Text_des:setVisible(self:checkIsCostItem())
		self:refreshWidgetCount(self.Text_value_2, self.Text_value_add_2)
		self:showPenAction()
	else
		self:hidePenAction()
	end
	if state == DRAWING_STATE.FINISH then
		self:refreshWidgetCount(self.Text_value_3, self.Text_value_add_3)
		_ENV = self.refreshWidgetCount
		self.refreshWidgetCount[1] = "frame_hzjzt_02.png"
		self.refreshWidgetCount[2] = "frame_hzjzt_03.png"
		self.refreshWidgetCount[3] = "frame_hzjzt_04.png"
		local self.refreshWidgetCount[4], iconTable = "frame_hzjzt_05.png", self.refreshWidgetCount
		local index = self:getDrawingIndex()
		self.Sprite_item:setSpriteFrame(iconTable[index])
		_ENV = self.Sprite_item.setSpriteFrame
		self.Sprite_item.setSpriteFrame[1] = cc.p(326, 316)
		self.Sprite_item.setSpriteFrame[2] = cc.p(329, 312)
		self.Sprite_item.setSpriteFrame[3] = cc.p(328, 314)
		local self.Sprite_item.setSpriteFrame[4], positionTab = cc.p(330, 314), self.Sprite_item.setSpriteFrame
		self.Sprite_item:setPosition(positionTab[index])
		self:showEffectNode(index)
	else
		self:hideEffectNode()
	end
end
function masteryDrawView:onClick_add(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	SoraDRemoveAllAfterPanelFromManager(self, true)
	local _ENV, dataList = SoraDRemoveAllAfterPanelFromManager, SoraDRemoveAllAfterPanelFromManager
	local needJump = true
	for i, v in ipairs(SPEED_ITEM_ID_LIST) do
		local isSelectCount = self.costItems[tostring(v)] or 0
		local count = backpackCtrl:getItemCount(v) - isSelectCount
		_ENV = backpackCtrl
		backpackCtrl.mid = v
		local backpackCtrl.count, data = count, backpackCtrl
		table.insert(dataList, data)
		if needJump and 0 < count then
			needJump = false
		end
	end
	if needJump then
		self:materialsJumpHandle()
		return
	end
	local panel = SoraDCreatePanel("materialsListView")
	panel:initData(gEquipMaterialType.MATERIAL, dataList, button)
	panel:setHandle(handler(self, self.selectItemCallback))
	panel:setJumpHandle(handler(self, self.materialsJumpHandle))
	panel:setTitle(i18n("drawing_text_18"))
	panel:show()
	self.lastClikNode = button:getParent()
end
function masteryDrawView:selectItemCallback(mid, target)
	target:removeFromParent()
	local single = self.lastClikNode:getChildByName("materialsListSingle")
	if not single then
		single = SoraDCreatePanel("materialsListSingle")
		single:setName("materialsListSingle")
		single:addTo(self.lastClikNode)
		single:setPosition(cc.p(0, -50))
		local button = ccui.Button:create()
		button:loadTextures("icon_mgyzz_new_red.png", "icon_mgyzz_new_red.png", "icon_mgyzz_new_red.png", ccui.TextureResType.plistType)
		button:setPosition(-35, 85)
		button:addTouchEventListener(function(button, eventType)
			if eventType ~= ccui.TouchEventType.ended then
				return
			end
			single:removeFromParent()
			self:refreshItemAddBuff()
		end)
		button:addTo(single, 99)
	end
	single:setTag(mid)
	_ENV = mid
	mid.mid = mid
	mid.count = 1
	single:initMaterialSingle(mid)
	self:refreshItemAddBuff()
end
function masteryDrawView:materialsJumpHandle(mid)
	mid = mid or 853101
	SoraDShowMsgBox(i18n("common_text_2086"), i18n("common_text_204"), nil, function(etype)
		if etype == MSGBOX_CALLBACK_YES then
			_ENV = nil
			;(nil).type = 1
			;(nil).mid = mid
			uiManager:show("bagView", nil)
		end
	end)
end
function masteryDrawView:onClick_checkBox(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	self:selectCheckBox(button:getTag())
end
function masteryDrawView:selectCheckBox(index)
	self.curCheckIndex = index
	for tag, box in ipairs(self.checkBoxList) do
		if tag == index then
			self.Image_select:setPosition(cc.p(box:getPositionX(), box:getPositionY()))
		end
	end
	self:refreshFinalCount()
end
function masteryDrawView:onClick_draw(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	local costTime = self:getDrawingTime(self.curCheckIndex)
	local costItems = self.costItems
	cityCtrl:sendReqMasteryDrawStart(costTime, costItems)
	SoraDShowLoading(self)
end
function masteryDrawView:onClick_cancel(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("drawing_text_11"), i18n("common_text_054"), nil, function(event)
		if event == MSGBOX_CALLBACK_YES then
			queueCtrl:cancelQueueReq(gQueueTypeDef.construction_drawing)
			SoraDShowLoading(self)
		end
	end)
end
function masteryDrawView:onClick_receive(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	cityCtrl:sendReqMasteryDrawReceive()
	SoraDShowLoading(self)
end
function masteryDrawView:getDrawState(...)
	local state = DRAWING_STATE.ERR
	local cityCell = cityCtrl:getCurCity()
	local drawingData = cityCell:getDrawingData()
	if drawingData and next(drawingData) then
		if drawingData.canReceive then
			state = DRAWING_STATE.FINISH
		else
			state = DRAWING_STATE.DRAWING
		end
	else
		state = DRAWING_STATE.READY
	end
	return state
end
function masteryDrawView:checkIsCostItem(...)
	local cityCell = cityCtrl:getCurCity()
	local drawingData = cityCell:getDrawingData()
	return drawingData and drawingData.isCostItem
end
function masteryDrawView:getRewardCount(...)
	local cityCell = cityCtrl:getCurCity()
	local drawingData = cityCell:getDrawingData()
	if not drawingData or not drawingData.reward then
		local cityCtrl, reward = drawingData.reward, drawingData.reward
	end
	for i, v in ipairs(reward) do
		if v.id == DRAWING_ITEM_ID then
			return v.count
		end
	end
	return 0
end
function masteryDrawView:getDrawingIndex(...)
	local cityCell = cityCtrl:getCurCity()
	local drawingData = cityCell:getDrawingData()
	return drawingData and drawingData.index or 1
end
function masteryDrawView:getCostItems(...)
	local _ENV, costItems
	_UPVALUE2_ = nil
	;(nil)[1] = self.Node_add_1
	;(nil)[2] = self.Node_add_2
	for i, v in ipairs(nil) do
		local single = v:getChildByName("materialsListSingle")
		if single then
			local key = tostring(single:getTag())
			costItems[key] = (costItems[key] or 0) + 1
		end
	end
	return costItems
end
function masteryDrawView:refreshItemAddBuff(...)
	self.itemAddBuff = self:computeItemAddBuff()
	self:setBuffAddValue(self.Text_tool_value, self.itemAddBuff / 10, (self.lastToolAdd or 0) / 10)
	self.lastToolAdd = self.itemAddBuff
	self:refreshFinalCount()
end
function masteryDrawView:computeItemAddBuff(...)
	local itemAddBuff = 0
	self.costItems = self:getCostItems()
	for id, count in pairs(self.costItems) do
		local itemID = tonumber(id)
		local itemCount = tonumber(count)
		if not backpackltCtrl:getResult(itemID) then
			local _ENV, result = backpackltCtrl:getResult(itemID), backpackltCtrl:getResult(itemID)
		end
		local buffID = result[1]
		itemAddBuff = itemAddBuff + buffltCtrl:getEffect(buffID) * itemCount
	end
	return itemAddBuff
end
function masteryDrawView:computeMasteryAddBuff(...)
	local masteryAddBuff = buffCtrl:getBuffEffect(gBuffEffect.DRAWING_OUTPUT_ADD) or 0
	return masteryAddBuff
end
function masteryDrawView:refreshFinalCount(...)
	local baseCount = self:getDrawingReward(self.curCheckIndex)
	local finalCount = baseCount * (1 + self.masteryAddBuff / 1000) * (1 + self.itemAddBuff / 1000)
	finalCount = math.floor(finalCount)
	self.Text_value_1:setString(tostring(baseCount))
	self.Text_value_1:runScoreAnimation(self.lastBaseCount or 0, baseCount, 0.5)
	self.lastBaseCount = baseCount
	local addCount = finalCount - baseCount
	if 0 < addCount then
		self.Text_value_add_1:setVisible(true)
		self.Text_value_add_1:runScoreAnimation(self.lastAddCount or 0, addCount, 0.2)
	else
		self.Text_value_add_1:setVisible(false)
	end
	self.lastAddCount = addCount
end
function masteryDrawView:refreshWidgetCount(widget_value, widget_add)
	local index = self:getDrawingIndex()
	local baseCount = self:getDrawingReward(index)
	widget_value:setString(tostring(baseCount))
	local addCount = self:getRewardCount() - baseCount
	if 0 < addCount then
		widget_add:setVisible(true)
		widget_add:setString(string.format("(+%d)", addCount))
	else
		widget_add:setVisible(false)
	end
end
function masteryDrawView:cleanItemAddBuff(...)
	_UPVALUE2_ = nil
	;(nil)[1] = self.Node_add_1
	;(nil)[2] = self.Node_add_2
	for i, v in ipairs(nil) do
		local single = v:getChildByName("materialsListSingle")
		if single then
			single:removeFromParent()
		end
	end
	self:refreshItemAddBuff()
end
function masteryDrawView:initEffectNode()
	local effectNode = SoraDCreatAnimation("jianzaotu")
	effectNode:addTo(self.Center_Node)
	effectNode:setPosition(cc.p(0, 20))
	self.effectNode = effectNode
	_UPVALUE4_ = effectNode
	effectNode[1] = "dh_hzjianzao_01_1"
	effectNode[2] = "dh_hzjianzao_02_2"
	effectNode[3] = "dh_hzjianzao_03_3"
	effectNode[4] = "dh_hzjianzao_04_4"
	for i, v in ipairs(effectNode) do
		local node = effectNode:getChildByName(v)
		SoraDMixtureGLONE(node)
		self.effectItemList[i] = node
	end
	_UPVALUE2_ = ipairs(effectNode)
	ipairs(effectNode)[1] = "dh_huizhijzt_01_1"
	ipairs(effectNode)[2] = "dh_huizhijzt_01_2"
	for i, v in ipairs(ipairs(effectNode)) do
		SoraDMixtureGLONE(effectNode:getChildByName(v))
	end
end
function masteryDrawView:showEffectNode(index)
	for i = 1, 4 - index do
		self.effectItemList[i]:setVisible(false)
	end
	for i = 4 - index + 1, 4 do
		self.effectItemList[i]:setVisible(true)
	end
	self.effectNode:getChildByName("Particle_8"):setVisible(true)
end
function masteryDrawView:hideEffectNode(...)
	for i, v in ipairs(self.effectItemList) do
		v:setVisible(false)
	end
	self.effectNode:getChildByName("Particle_8"):setVisible(false)
end
function masteryDrawView:showEnterAction(...)
	self.Image_1:setScale(1.5)
	self.Image_1:setOpacity(0)
	_ENV = nil
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(0.4666666666666667, 1.0)
	;(nil)[2] = cca.fadeIn(0.16666666666666666)
	;(nil)[3] = cca.fadeIn(0.16666666666666666)
	;(nil)[4] = cca.fadeIn(0.16666666666666666)
	;(nil)[5] = cca.fadeIn(0.16666666666666666)
	;(nil)[1] = cca.spawn(nil)
	;(nil)[2] = cca.spawn(nil)
	;(nil)[3] = cca.spawn(nil)
	;(nil)[4] = cca.spawn(nil)
	;(nil)[5] = cca.spawn(nil)
	;(nil)[6] = cca.spawn(nil)
	;(nil)[7] = cca.spawn(nil)
	self.Image_1:runAction(cca.seq(nil))
	self.Center_Node:setScale(1.8)
	self.Center_Node:setOpacity(0)
	_UPVALUE1_ = cca.seq(nil)
	_UPVALUE1_ = cca.seq(nil)
	cca.seq(nil)[1] = cca.scaleTo(0.35555555555555557, 1.0)
	cca.seq(nil)[2] = cca.fadeIn(0.15555555555555556)
	cca.seq(nil)[3] = cca.fadeIn(0.15555555555555556)
	cca.seq(nil)[4] = cca.fadeIn(0.15555555555555556)
	cca.seq(nil)[1] = cca.delay(0.14444444444444443)
	cca.seq(nil)[2] = cca.spawn(cca.seq(nil))
	cca.seq(nil)[3] = cca.spawn(cca.seq(nil))
	cca.seq(nil)[4] = cca.spawn(cca.seq(nil))
	cca.seq(nil)[5] = cca.spawn(cca.seq(nil))
	cca.seq(nil)[6] = cca.spawn(cca.seq(nil))
	cca.seq(nil)[7] = cca.spawn(cca.seq(nil))
	self.Center_Node:runAction(cca.seq(cca.seq(nil)))
	self.Sprite_left:setPosition(cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130))
	_UPVALUE1_ = cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)
	cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)[1] = cca.delay(0.2222222222222222)
	cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)[2] = cca.moveBy(0.35555555555555557, 80, 130)
	cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)[3] = cca.moveBy(0.35555555555555557, 80, 130)
	cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)[4] = cca.moveBy(0.35555555555555557, 80, 130)
	cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)[5] = cca.moveBy(0.35555555555555557, 80, 130)
	cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)[6] = cca.moveBy(0.35555555555555557, 80, 130)
	cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)[7] = cca.moveBy(0.35555555555555557, 80, 130)
	self.Sprite_left:runAction(cca.seq(cc.p(self.Sprite_left:getPositionX() - 80, self.Sprite_left:getPositionY() - 130)))
	self.Sprite_right:setPosition(cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130))
	_UPVALUE1_ = cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)
	cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)[1] = cca.delay(0.2222222222222222)
	cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)[2] = cca.moveBy(0.35555555555555557, -80, 130)
	cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)[3] = cca.moveBy(0.35555555555555557, -80, 130)
	cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)[4] = cca.moveBy(0.35555555555555557, -80, 130)
	cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)[5] = cca.moveBy(0.35555555555555557, -80, 130)
	cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)[6] = cca.moveBy(0.35555555555555557, -80, 130)
	cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)[7] = cca.moveBy(0.35555555555555557, -80, 130)
	self.Sprite_right:runAction(cca.seq(cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)))
	self.Text_top:setOpacity(0)
	self.ccs_title:setPositionY(self.ccs_title:getPositionY() + 94)
	_UPVALUE2_ = self.ccs_title
	_UPVALUE1_ = cca.seq(cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130))
	cca.seq(cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130))[1] = cca.moveBy(0.16666666666666666, 0, -98)
	cca.seq(cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130))[2] = cca.callFunc(function()
		self.Text_top:runAction(cca.fadeIn(0.15555555555555556))
	end)
	cca.seq(cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130))[3] = cca.callFunc(function()
		self.Text_top:runAction(cca.fadeIn(0.15555555555555556))
	end)
	cca.seq(cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130))[4] = cca.callFunc(function()
		self.Text_top:runAction(cca.fadeIn(0.15555555555555556))
	end)
	self.ccs_title[1] = cca.delay(0.35555555555555557)
	self.ccs_title[2] = cca.spawn(cca.seq(cc.p(self.Sprite_right:getPositionX() + 80, self.Sprite_right:getPositionY() - 130)))
	self.ccs_title[3] = cca.moveBy(0.2, 0, 4)
	self.ccs_title[4] = cca.moveBy(0.2, 0, 4)
	self.ccs_title[5] = cca.moveBy(0.2, 0, 4)
	self.ccs_title[6] = cca.moveBy(0.2, 0, 4)
	self.ccs_title[7] = cca.moveBy(0.2, 0, 4)
	self.ccs_title:runAction(cca.seq(self.ccs_title))
	_UPVALUE1_ = cca.seq(self.ccs_title)
	cca.seq(self.ccs_title)[1] = cca.delay(0.16666666666666666)
	cca.seq(self.ccs_title)[2] = cca.callFunc(function()
		self.isHideCurrentSceneView = true
		self = nil
		;(nil).isHideCurrentSceneView = true
		;(nil).isHideMainUI = true
		SoraDHideCurrentSceneViewAndMainUI(nil)
	end)
	cca.seq(self.ccs_title)[3] = cca.callFunc(function()
		self.isHideCurrentSceneView = true
		self = nil
		;(nil).isHideCurrentSceneView = true
		;(nil).isHideMainUI = true
		SoraDHideCurrentSceneViewAndMainUI(nil)
	end)
	cca.seq(self.ccs_title)[4] = cca.callFunc(function()
		self.isHideCurrentSceneView = true
		self = nil
		;(nil).isHideCurrentSceneView = true
		;(nil).isHideMainUI = true
		SoraDHideCurrentSceneViewAndMainUI(nil)
	end)
	cca.seq(self.ccs_title)[5] = cca.callFunc(function()
		self.isHideCurrentSceneView = true
		self = nil
		;(nil).isHideCurrentSceneView = true
		;(nil).isHideMainUI = true
		SoraDHideCurrentSceneViewAndMainUI(nil)
	end)
	cca.seq(self.ccs_title)[6] = cca.callFunc(function()
		self.isHideCurrentSceneView = true
		self = nil
		;(nil).isHideCurrentSceneView = true
		;(nil).isHideMainUI = true
		SoraDHideCurrentSceneViewAndMainUI(nil)
	end)
	cca.seq(self.ccs_title)[7] = cca.callFunc(function()
		self.isHideCurrentSceneView = true
		self = nil
		;(nil).isHideCurrentSceneView = true
		;(nil).isHideMainUI = true
		SoraDHideCurrentSceneViewAndMainUI(nil)
	end)
	self:runAction(cca.seq(cca.seq(self.ccs_title)))
end
function masteryDrawView:setBuffAddValue(widget, value, lastValue)
	widget:runScoreAnimation(lastValue, value, 0.5)
	if 0 < value then
		widget:setColor(display.COLOR_GREEN)
	else
		widget:setColor(display.COLOR_WHITE)
	end
end
function masteryDrawView:showPenAction(...)
	self.icon_pen:setVisible(false)
	if not self.meshNode then
		local _shader = require("app.game.buildView.masteryView.huizhijzpic_shader")
		local _meshData = require("app.game.buildView.masteryView.huizhijzpic_meshData")
		local _param = require("app.game.buildView.masteryView.huizhijzpic_param")
		_ENV = "app.game.buildView.masteryView.huizhijzpic_param"
		;("app.game.buildView.masteryView.huizhijzpic_param").meshData = _meshData
		_ENV, ("app.game.buildView.masteryView.huizhijzpic_param").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.buildView.masteryView.huizhijzpic_param").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.buildView.masteryView.huizhijzpic_param").param = _param.param
		_ENV, ("app.game.buildView.masteryView.huizhijzpic_param").pos = cc.p(330, 495), cc.p(330, 495)
		cc.p(330, 495).x = 0.12911649
		;("app.game.buildView.masteryView.huizhijzpic_param").scale, cc.p(330, 495).y = cc.p(330, 495), -0.2171967
		local createData = "app.game.buildView.masteryView.huizhijzpic_param"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		meshNode:addTo(self.Node_drawing)
		self.meshNode = meshNode
	end
	if not self.timeHandle then
		self.appearValue = 0.9
		self.alphaValue = 0.3
		self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime), true)
	end
	if not self.spine_pen then
		local spine_pen = sp.SkeletonAnimation:create("spine/huizhi.skel", "spine/huizhi.atlas", 1.0)
		spine_pen:setAnimation(0, "animation", true)
		spine_pen:setPosition(cc.p(100, 360))
		spine_pen:addTo(self.Node_drawing)
		self.spine_pen = spine_pen
	end
end
function masteryDrawView:hidePenAction(...)
	if self.meshNode then
		self.meshNode:removeFromParent()
		self.meshNode = nil
	end
	if self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
	end
	if self.spine_pen then
		self.spine_pen:removeFromParent()
		self.spine_pen = nil
	end
end
function masteryDrawView:updateTime(dt)
	local totalTime = 12
	local appearMax, appearMin = 1.0, 0.0
	local step = dt / totalTime
	self.appearValue = self.appearValue - step
	if appearMin > self.appearValue then
		self.appearValue = appearMax
	end
	local alphaMax, alphaMin = 0.8, 0.3
	local step = (alphaMax - alphaMin) * dt / totalTime
	self.alphaValue = self.alphaValue + step
	if alphaMax < self.alphaValue then
		self.alphaValue = alphaMin
	end
	local state = self.meshNode:getGLProgramState()
	state:setUniformFloat("_appear", self.appearValue)
	state:setUniformFloat("_alpha", self.alphaValue)
end
function masteryDrawView:gameGuide_getTarget(itemName, parameters)
	if itemName == "checkBox" then
		return self.checkBoxList[4]
	elseif itemName == "Button_draw" then
		return self.Button_draw
	elseif itemName == "Button_receive" then
		return self.Button_receive
	end
	return nil
end
return masteryDrawView
