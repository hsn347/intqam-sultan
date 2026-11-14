local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local allianceHuntView = class("allianceHuntView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("allianceHuntView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function allianceHuntView:ctor()
	self:createUI()
	self.selectIndex = 1
	self.switch = false
	self.node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTiger = SoraDGetChildByName(self, "node_tiger")
	self.imgBgL = SoraDGetChildByName(self, "img_bg_L")
	self.imgBgR = SoraDGetChildByName(self, "img_bg_R")
	self.imgTigerL = SoraDGetChildByName(self, "img_tiger_L")
	self.imgTigerR = SoraDGetChildByName(self, "img_tiger_R")
	self.imgTigerScar = SoraDGetChildByName(self, "img_tiger_scar")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.bottomInfo = SoraDGetChildByName(self, "bottom_info")
	self.fireNodeL = SoraDGetChildByName(self, "fireNodeL")
	self.fireNodeR = SoraDGetChildByName(self, "fireNodeR")
	self.btnEnter = SoraDGetChildByName(self, "Button_enter")
	self.imgBottomBg = SoraDGetChildByName(self, "Image_bottom_bg")
	self.imgBottomBg:setFillType(1)
	self.imgNumBg = SoraDGetChildByName(self, "img_num_bg")
	self.textRemainNum = SoraDGetChildByName(self, "text_remain_num")
	self.textCurScore = SoraDGetChildByName(self, "text_cur_score")
	self.textMyScore = SoraDGetChildByName(self, "text_my_score")
	self.frameLine = SoraDGetChildByName(self, "frame_line")
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.frameLordinfo051 = SoraDGetChildByName(self, "frame_lordinfo_05_1")
	self.iconExclamation4 = SoraDGetChildByName(self, "icon_exclamation_4")
	self.nodeRank = SoraDGetChildByName(self, "node_rank")
	self.btnRank = SoraDGetChildByName(self, "btn_rank")
	self.imgTextBg = SoraDGetChildByName(self, "img_text_bg")
	self.txtOpRank = SoraDGetChildByName(self, "Text_Op_Rank")
	self.iconOp = SoraDGetChildByName(self, "icon_op")
	self.nodeExchange = SoraDGetChildByName(self, "node_exchange")
	self.btnExchange = SoraDGetChildByName(self, "btn_exchange")
	self.imgTextBg = SoraDGetChildByName(self, "img_text_bg")
	self.txtOpExchange = SoraDGetChildByName(self, "Text_Op_Exchange")
	self.iconOp = SoraDGetChildByName(self, "icon_op")
	self.imgDayNumber1 = SoraDGetChildByName(self, "img_day_number1")
	self.textDayNum = SoraDGetChildByName(self, "text_day_num")
	self.frameLine17165 = SoraDGetChildByName(self, "frame_line_17_165")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.btnEnter:addTouchEventListener(handler(self, self.onClick_btnEnter))
	self.btnInfo:addTouchEventListener(handler(self, self.onClick_btnInfo))
	self.btnRank:addTouchEventListener(handler(self, self.onClick_btnRank))
	self.btnExchange:addTouchEventListener(handler(self, self.onClick_btnExchange))
	self.Image_border = SoraDGetChildByName(self, "Image_border")
	self.Image_border:setVisible(false)
	self.node_dropBox = SoraDGetChildByName(self, "node_dropBox")
	self.Button_choose = SoraDGetChildByName(self.node_dropBox, "Button_choose")
	self.Button_choose:addTouchEventListener(handler(self, self.onClick_btnChoose))
	self.ScrollView_list = SoraDGetChildByName(self.node_dropBox, "ScrollView_list")
	self.ScrollView_list = SoraDCreatePanelByCloneNode(self.ScrollView_list, "commonAutoScrollList")
	self.ScrollView_list:setSingleCreate(handler(self, self.createSingle))
	self.commonFramTitle_node:setTitle(i18n("alliance_hunt_btn_02"))
	self.btnEnter:setTitleText(i18n("common_text_4413"))
	self.txtOpRank:setString(i18n("common_text_851"))
	self.txtOpExchange:setString(i18n("alliance_hunt_btn_01"))
	self.Panel_Shadow = SoraDGetChildByName(self, "Panel_Shadow")
	SoraDChangeTextToHtml(self.textRemainNum)
	self.btnEnter:setAutoGray(false)
	self:init()
	self:fitDevice()
	self.Panel_Shadow:runAction(cca.fadeOut(0.6))
	SoraDPlaySound("huntSound", "hunt_into")
end
function allianceHuntView:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function allianceHuntView:fitDevice()
	if display.height > 1160 then
		local offsetY = display.height - 960 - 200
		if 0 < offsetY then
			self.bottomInfo:setPositionY(offsetY)
		end
	end
	local shadowSize = self.Panel_Shadow:getContentSize()
	self.Panel_Shadow:setContentSize(cc.size(shadowSize.width, shadowSize.height + display.height - 960))
end
function allianceHuntView:init(data)
	self.data = allianceHuntCtrl:getHuntData()
	if not self.data then
		return
	end
	self:updateInfo()
	self:initDropBox()
	self:updateDropBox()
end
function allianceHuntView:initDropBox()
	local self.indexArray, _ENV, _ENV, tableData
	for i = 1, HUNTING_MAX_TIMES do
		table.insert(tableData, i)
	end
	self.ScrollView_list:updateScrollView(cc.size(274, 35), tableData)
end
function allianceHuntView:createSingle()
	local ocx = self.Node_single:clone()
	local Button_select = SoraDGetChildByName(ocx, "Button_select")
	local Image_select = SoraDGetChildByName(ocx, "Image_select")
	function ocx.initData(target, data, otherData)
		local curNum = HUNTING_MAX_TIMES - self.data.challengeTimes
		Button_select:setSwallowTouches(false)
		Button_select:setTag(data)
		Button_select:setTouchEnabled(data <= curNum)
		_ENV = nil
		;(nil).count = data
		;(nil).num = data
		Button_select:setTitleText(i18n("alliance_text_38", nil))
		SoraDAutoSizeButtonText(Button_select)
		Button_select:addTouchEventListener(handler(self, self.selectDropBox))
		Image_select:setVisible(data == self.selectIndex)
		if data <= curNum then
			Button_select:setTitleColor(data == self.selectIndex and cc.c3b(255, 255, 255) or cc.c3b(215, 195, 155))
		else
			Button_select:setTitleColor(cc.c3b(120, 120, 120))
		end
	end
	return ocx
end
function allianceHuntView:updateDropBox()
	self.selectIndex = self.selectIndex or 1
	local Text_choose = SoraDGetChildByName(self.node_dropBox, "Text_choose")
	_ENV = nil
	;(nil).count = self.selectIndex
	;(nil).num = self.selectIndex
	Text_choose:setString(i18n("alliance_text_38", nil))
	self.Image_border:setVisible(false)
	local frame_arrow = SoraDGetChildByName(self.node_dropBox, "frame_arrow")
	frame_arrow:setRotation(SoraDFIsRA() and 90 or -90)
	self.ScrollView_list:setVisible(false)
end
function allianceHuntView:showDropBox()
	self.Image_border:setVisible(true)
	local frame_arrow = SoraDGetChildByName(self.node_dropBox, "frame_arrow")
	frame_arrow:setRotation(0)
	self.ScrollView_list:setVisible(true)
end
function allianceHuntView:selectDropBox(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isMoved then
			self.isMoved = false
			return
		end
		self.selectIndex = target:getTag()
		self.switch = false
		self:initDropBox()
		self:updateDropBox()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.isMoved = false
	end
end
function allianceHuntView:updateInfo()
	self.curNum = HUNTING_MAX_TIMES - self.data.challengeTimes
	local totalNum = HUNTING_MAX_TIMES
	local numColor = self.curNum > 0 and "#F1C672" or "#FF0000"
	_ENV = self.curNum
	self.curNum.color = numColor
	local numStr1 = SoraDWrapHtmlTagByStyle(tostring(self.curNum), self.curNum)
	local str = string.format("%s/%s", numStr1, tostring(totalNum))
	_ENV = tostring(totalNum)
	tostring(totalNum).num = str
	self.textRemainNum:setString(i18n("arena_columntext_03", tostring(totalNum)))
	_ENV = i18n("arena_columntext_03", tostring(totalNum))
	i18n("arena_columntext_03", tostring(totalNum)).num = allianceHuntCtrl:getHuntingPoint() or 0
	self.textCurScore:setString(i18n("alliance_hunt_text_04", i18n("arena_columntext_03", tostring(totalNum))))
	_ENV = i18n("alliance_hunt_text_04", i18n("arena_columntext_03", tostring(totalNum)))
	i18n("alliance_hunt_text_04", i18n("arena_columntext_03", tostring(totalNum))).num = self.data.todayHuntingPoint or 0
	self.textMyScore:setString(i18n("alliance_hunt_text_05", i18n("alliance_hunt_text_04", i18n("arena_columntext_03", tostring(totalNum)))))
	if self.curNum == 0 then
		self.btnEnter:setBright(false)
	else
		self.btnEnter:setBright(true)
	end
	self:updateExchangeRedPoint()
end
function allianceHuntView:msgUpdateExhcangeRedPoint(target, data)
	self:updateExchangeRedPoint()
end
function allianceHuntView:updateExchangeRedPoint()
	local canExchange = allianceHuntCtrl:hasAnyExchange()
	if canExchange then
		allianceHuntCtrl = nil
		;(nil).byUID = true
		local configTime = SoraDConfigGet("Game:allianceHuntView:saveTime~integer", nil)
		local nowTime = serviceFunctions.systemTime()
		if os.date("%d", nowTime) ~= os.date("%d", configTime) then
			self.isNeedShowRedPoint = true
			self.imgDayNumber1:setVisible(true)
		else
			self.imgDayNumber1:setVisible(false)
			self.isNeedShowRedPoint = false
		end
	else
		self.imgDayNumber1:setVisible(false)
		self.isNeedShowRedPoint = false
	end
end
function allianceHuntView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BATTLE_END", handler(self, self.sMsgHandlerBattleEnd))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_UPDATE_EXCHANGE_POINT", handler(self, self.msgUpdateExhcangeRedPoint))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_DAILY_REFRESH", handler(self, self.sMsgHandlerDailyRefresh))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BUY_SUCCESS", handler(self, self.sMsgBuySuccess))
end
function allianceHuntView:onClick_btnEnter(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local curNum = HUNTING_MAX_TIMES - self.data.challengeTimes
		if curNum <= 0 then
			SoraDShowMsgTip(i18n("alliance_hunt_text_02"))
			return
		end
		local panel = SoraDCreatePanel("allianceHuntChallenge")
		panel:initChallengeTimes(self.selectIndex)
		panel:show()
	end
end
function allianceHuntView:onClick_btnInfo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("alliance_hunt_text_03"))
	end
end
function allianceHuntView:onClick_btnRank(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceHuntRank"):show()
	end
end
function allianceHuntView:onClick_btnExchange(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceHuntExchangeView"):show()
		if self.isNeedShowRedPoint then
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:allianceHuntView:saveTime~integer", serviceFunctions.systemTime(), nil)
			self.imgDayNumber1:setVisible(false)
		end
	end
end
function allianceHuntView:onClick_btnChoose(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switch = not self.switch
		if self.switch then
			self:showDropBox()
		else
			self:updateDropBox()
		end
	end
end
function allianceHuntView:sMsgHandlerBattleEnd(target, data)
	self:updateInfo()
	self.selectIndex = 1
	self:initDropBox()
	self:updateDropBox()
end
function allianceHuntView:sMsgHandlerDailyRefresh(target, data)
	self:updateInfo()
end
function allianceHuntView:sMsgBuySuccess(target, data)
	self:updateInfo()
end
return allianceHuntView
