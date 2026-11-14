local gametop = gModuleMgr.getObject("gametop")
local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
local radianceWarRead = include("radianceWarRead")
_UPVALUE1_ = "radianceWarRead"
local ("radianceWarRead")[1], buffArray = 5447, "radianceWarRead"
local radianceWarResAmberMine = class("radianceWarResAmberMine", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarResAmberMine")
	end
	return target
end)
function radianceWarResAmberMine:ctor()
	self.isHideCurrentSceneView = true
	self.txtValueAll = SoraDGetChildByName(self, "Text_Value_All")
	self.txtValueCur = SoraDGetChildByName(self, "Text_Value_Cur")
	self.txtTitleScore = SoraDGetChildByName(self, "Text_Title_Score")
	self.txtTitleEvent = SoraDGetChildByName(self, "Text_Title_Event")
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.txtTips = SoraDGetChildByName(self, "Text_Tips")
	self.txtTips1 = SoraDGetChildByName(self, "Text_Tips_1")
	self.btnExchange = SoraDGetChildByName(self, "Button_exchange")
	self.btnOcupyInfo = SoraDGetChildByName(self, "Button_Ocupy_Info")
	self.txtRemains = SoraDGetChildByName(self, "Text_remains")
	self.btnExchange:addTouchEventListener(handler(self, self.onClickExchange))
	self.btnOcupyInfo:addTouchEventListener(handler(self, self.onClickOcupyInfo))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.nodeSingle:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_Info")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.nodeSingleCreate))
	self.scroll:setSingleRefresh(handler(self, self.nodeSingleRefresh))
	_G.SoraDChangeTextToHtml(self.txtValueAll)
	_G.SoraDChangeTextToHtml(self.txtValueCur)
	self.ccs_buff = SoraDGetExtendChildFromCCSByName(self, "CCS_radianceWarBuffNode_node")
	self.ccs_buff:setTimeEndHandle(function()
		self.ccs_buff:setVisible(false)
	end)
	self.ccs_buff:initData(buffArray)
	self.ccs_buff:setVisible(false)
	local spRes = SoraDGetChildByName(self, "Sprite_res")
	self.txtTitleScore:setString(i18n("item_name_1611"))
	_UPVALUE2_ = self.txtTitleScore
	self.txtTitleScore[1] = self.txtTitleScore
	self.txtTitleScore[2] = spRes
	buffArray = spRes
	spRes[1] = 10
	_G.SoraDAlignNodeArrayOnCenterX(self.txtTitleScore:getPositionX(), self.txtTitleScore, not SoraDFIsRA(), spRes)
	self.txtTitleEvent:setString(i18n("brightWar_text_167"))
	self.title:setTitle(i18n("brightWar_text_163"))
	spRes:addTouchEventListener(handler(self, self.btnHelpCickCallBack))
	_G.SoraDChangeTextToHtml(self.txtTips)
	local point = include("constantRead").getConstValue("RADIANCE_WAR_AMBER_POINT_EXCHANGE") or 1
	self.txtTips:setString(i18n("brightWar_text_165"))
	_ENV = i18n("brightWar_text_165")
	i18n("brightWar_text_165").point = point
	i18n("brightWar_text_165").num = 1
	self.txtTips1:setString(i18n("brightWar_text_197", i18n("brightWar_text_165")))
	_G.SoraDGetAutoHeightLabelNew(self.txtTips, 600, false)
	self.imgBg = SoraDGetChildByName(self, "Image_bg_tips")
	self.imgBg:setContentSize(cc.size(640, self.txtTips:getContentSize().height + 26))
	self.btnExchange:setTitleText(i18n("brightWar_text_185"))
	self.btnOcupyInfo:setTitleText(i18n("brightWar_text_186"))
	SoraDAutoSizeButtonTextByContent(self.btnExchange)
	SoraDAutoSizeButtonTextByContent(self.btnOcupyInfo)
	self:initView()
	self:setBuffInfo()
end
function radianceWarResAmberMine:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_AMBER_POINT", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_AMBER_POINT_EXCHANGE", handler(self, self.rspDispatchBack))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW", function(target, data)
		if data and data.eventID == gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY then
			self:setBuffInfo()
		end
	end)
end
function radianceWarResAmberMine:setBuffInfo()
	local isActive = lightShiningCtrl:isBuffActive()
	local isInBuff = lightShiningCtrl:isInBuffList(buffArray)
	self.ccs_buff:setVisible(isInBuff and isActive)
	if isInBuff and isActive then
		self.ccs_buff:setVisible(true)
	else
		self.ccs_buff:setVisible(false)
	end
end
function radianceWarResAmberMine:initView()
	self:updateView()
	self:updateScroll()
end
local numColor = cc.c3b(255, 200, 56)
function radianceWarResAmberMine:updateView()
	_ENV = nil
	;(nil).param = "#1611.png"
	;(nil).name = "image1"
	;(nil).width = 40
	;(nil).height = 40
	;(nil).custom = "Sprite"
	;(nil).scale = 1.0
	;(nil).offsety = 12
	local strImage = _G.SoraDWrapReplaceTag(nil)
	do
		local total = math.floor(radianceActivityCtrl:getWarTotalAmberPoint())
		local max = include("constantRead").getConstValue("RADIANCE_WAR_AMBER_POINT_MAX") or 0
		local strTotal = string.formatnumberthousands(total) .. "/" .. string.formatnumberthousands(max)
		strTotal = strImage .. strTotal
		_ENV = max
		_ENV, _ENV, max.num = radianceActivityCtrl:getWarTotalAmberPoint()
		radianceActivityCtrl:getWarTotalAmberPoint().num, radianceActivityCtrl:getWarTotalAmberPoint().color = radianceActivityCtrl:getWarTotalAmberPoint()
		local strDes = _G.i18n_html("brightWar_text_164", max, radianceActivityCtrl:getWarTotalAmberPoint())
		self.txtValueAll:setString(strDes)
		_G.SoraDGetAutoHeightLabelNew(self.txtValueAll, 450, true)
	end
	do
		local cur = math.floor(radianceActivityCtrl:getWarAmberPoint())
		local strNum = string.formatnumberthousands(cur)
		strNum = strImage .. strNum
		_ENV = radianceActivityCtrl:getWarAmberPoint()
		_ENV, _ENV, radianceActivityCtrl:getWarAmberPoint().num = radianceActivityCtrl:getWarAmberPoint()
		radianceActivityCtrl:getWarAmberPoint().num, radianceActivityCtrl:getWarAmberPoint().color = radianceActivityCtrl:getWarAmberPoint()
		local strDes = _G.i18n_html("brightWar_text_189", radianceActivityCtrl:getWarAmberPoint())
		self.txtValueCur:setString(strDes)
		_G.SoraDGetAutoHeightLabelNew(self.txtValueCur, 450, true)
		local point = include("constantRead").getConstValue("RADIANCE_WAR_AMBER_POINT_EXCHANGE") or 1
		local curValue = math.floor(cur / point)
		_ENV = radianceActivityCtrl:getWarAmberPoint()
		radianceActivityCtrl:getWarAmberPoint().num = string.formatnumberthousands(curValue)
		self.txtRemains:setString(i18n("brightWar_text_168", radianceActivityCtrl:getWarAmberPoint()))
		if curValue <= 0 then
			self.btnExchange:setBright(false)
		else
			self.btnExchange:setBright(true)
		end
	end
end
function radianceWarResAmberMine:updateScroll()
	local list = radianceWarRead.getRadianceRuleConfig()
	radianceWarRead = nil
	;(nil).index = 0
	table.insert(list, 1, nil)
	radianceWarRead = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(640, 50), list, 1, nil)
end
function radianceWarResAmberMine:nodeSingleCreate(parent, data)
	local single = self.nodeSingle:clone()
	single:setVisible(true)
	return single
end
function radianceWarResAmberMine:nodeSingleRefresh(parent, data)
	SoraDGetChildByName(parent, "Image_Bg"):setVisible(data.index % 2 == 1)
	local textTime = SoraDGetChildByName(parent, "Text_time")
	local textContent = SoraDGetChildByName(parent, "Text_content")
	if data.index == 0 then
		textContent:setString(i18n("brightWar_text_187"))
		textTime:setString(i18n("brightWar_text_188"))
	else
		textContent:setString(i18n(data.des))
		textTime:setString(string.format("%.3f", data.amberPoint / 1000))
	end
end
function radianceWarResAmberMine:rspDispatchBack(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:removeFromParent()
	else
		local itemList = data.data
		if itemList or 0 < #itemList then
			SoraDMailGainItems(itemList, true)
		end
	end
end
function radianceWarResAmberMine:onClickExchange(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.btnExchange:isBright() then
			SoraDShowMsgTip(i18n("brightWar_text_169"))
			return
		end
		radianceActivityCtrl:reqExchangeAmberPoint()
		SoraDShowLoading(self)
	end
end
function radianceWarResAmberMine:onClickOcupyInfo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("radianceWarSituationView")
		panel:changeToTab(1, 5)
		panel:show()
	end
end
function radianceWarResAmberMine:btnHelpCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("radianceWarResAmberMineInfo")
		panel:show()
	end
end
return radianceWarResAmberMine
