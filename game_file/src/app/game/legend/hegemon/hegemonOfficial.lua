local hegemonRead = include("hegemonRead")
local gametop = gModuleMgr.getObject("gametop")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local hegemonOfficial = class("hegemonOfficial", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("hegemonOfficial")
		end
		if type(target) == "string" then
			return SoraDCreateTouchPanel(target)
		end
		return target
	end
end)
function hegemonOfficial:ctor()
	self:createUI()
	self.nodeBgBox_node = SoraDGetExtendChildFromCCSByName(self, "Center_CCS_nodeBgBox_node")
	self.Center_Node_Grant = SoraDGetChildByName(self, "Center_Node_Grant")
	self.Sprite_lace_t = SoraDGetChildByName(self, "Sprite_lace_t")
	self.Sprite_Official_Bg = SoraDGetChildByName(self, "Sprite_Official_Bg")
	self.Sprite_Official_Icon = SoraDGetChildByName(self, "Sprite_Official_Icon")
	self.Sprite_Line = SoraDGetChildByName(self, "Sprite_Line")
	self.Text_Name = SoraDGetChildByName(self, "Text_Name")
	self.Sprite_Circle_Dismiss = SoraDGetChildByName(self, "Sprite_Circle_Dismiss")
	self.Button_Dismiss = SoraDGetChildByName(self, "Button_Dismiss")
	self.Sprite_Dimiss_Bg = SoraDGetChildByName(self, "Sprite_Dimiss_Bg")
	self.Text_Dismiss = SoraDGetChildByName(self, "Text_Dismiss")
	self.Sprite_Circle_Mail = SoraDGetChildByName(self, "Sprite_Circle_Mail")
	self.Button_Mail = SoraDGetChildByName(self, "Button_Mail")
	self.Sprite_Mail_Bg = SoraDGetChildByName(self, "Sprite_Mail_Bg")
	self.Text_Mail = SoraDGetChildByName(self, "Text_Mail")
	self.Sprite_Circle_Info = SoraDGetChildByName(self, "Sprite_Circle_Info")
	self.Button_Info = SoraDGetChildByName(self, "Button_Info")
	self.sprite_Info_Bg = SoraDGetChildByName(self, "sprite_Info_Bg")
	self.Text_Info = SoraDGetChildByName(self, "Text_Info")
	self.Node_jiacheng_1 = SoraDGetChildByName(self, "Node_jiacheng_1")
	self.bg_jiacheng_1 = SoraDGetChildByName(self, "bg_jiacheng_1")
	self.text_jiacheng_1 = SoraDGetChildByName(self, "text_jiacheng_1")
	self.Node_jiacheng_2 = SoraDGetChildByName(self, "Node_jiacheng_2")
	self.bg_jiacheng_2 = SoraDGetChildByName(self, "bg_jiacheng_2")
	self.text_jiacheng_2 = SoraDGetChildByName(self, "text_jiacheng_2")
	self.Node_jiacheng_3 = SoraDGetChildByName(self, "Node_jiacheng_3")
	self.bg_jiacheng_3 = SoraDGetChildByName(self, "bg_jiacheng_3")
	self.text_jiacheng_3 = SoraDGetChildByName(self, "text_jiacheng_3")
	self.text_show = SoraDGetChildByName(self, "text_show")
	self.btnShow = SoraDGetChildByName(self, "Button_show")
	self.btnShow:setTitleText(i18n("common_btn_17"))
	self.btnShow:setVisible(false)
	self.nodeControls = SoraDGetChildByName(self, "Node_Controls")
	self.btnShow:addTouchEventListener(handler(self, self.btnShowClick))
	self.Button_Dismiss:addTouchEventListener(handler(self, self.onClick_Button_Dismiss))
	self.Button_Mail:addTouchEventListener(handler(self, self.onClick_Button_Mail))
	self.Button_Info:addTouchEventListener(handler(self, self.onClick_Button_Info))
	self.Text_Dismiss:setString(i18n("common_text_1297"))
	self.Text_Mail:setString(i18n("chat_text_69"))
	self.Text_Info:setString(i18n("common_text_002"))
	_UPVALUE3_ = self.Text_Info.setString
	_UPVALUE3_, self.buffNodes, self.Text_Info.setString[1] = self.Text_Info.setString, self.Text_Info.setString, self.Node_jiacheng_1
	_UPVALUE3_, self.buffNodes, self.Text_Info.setString[2] = self.Text_Info.setString, self.Text_Info.setString, self.Node_jiacheng_2
	_UPVALUE3_, self.buffNodes, self.Text_Info.setString[3] = self.Text_Info.setString, self.Text_Info.setString, self.Node_jiacheng_3
	_UPVALUE3_, self.textBuffNodes, self.Text_Info.setString[1] = self.Text_Info.setString, self.Text_Info.setString, self.text_jiacheng_1
	_UPVALUE3_, self.textBuffNodes, self.Text_Info.setString[2] = self.Text_Info.setString, self.Text_Info.setString, self.text_jiacheng_2
	_UPVALUE3_, self.textBuffNodes, self.Text_Info.setString[3] = self.Text_Info.setString, self.Text_Info.setString, self.text_jiacheng_3
	self.tbOfficialNodes, self.Text_Info.setString[1] = self.Text_Info.setString, self.Sprite_Circle_Dismiss
	self.tbOfficialNodes, self.Text_Info.setString[2] = self.Text_Info.setString, self.Sprite_Circle_Mail
	self.tbOfficialNodes, self.Text_Info.setString[3] = self.Text_Info.setString, self.Sprite_Circle_Info
end
function hegemonOfficial:createUI()
end
function hegemonOfficial:init(data, isHideOp, isShowMode)
	self.isShowMode = isShowMode
	self.itemData = data
	self.bid = self.itemData.bid
	local titleBuff = self.itemData.titleBuff
	self.Sprite_Official_Icon:setSpriteFrame(titleBuff.Image)
	if titleBuff.Digitype == 1 then
		self.Sprite_Official_Icon:setScale(0.5850000000000001)
	else
		self.Sprite_Official_Icon:setScale(1.3)
	end
	local isGood = hegemonRead.judgeIsGood(titleBuff.Digitype)
	if isGood then
		self.Sprite_Official_Bg:setSpriteFrame("frame_touxiangkuang_01.png")
	else
		self.Sprite_Official_Bg:setSpriteFrame("frame_touxiangkuang_02.png")
	end
	self.Sprite_Official_Bg:setScale(1.3)
	self.nodeBgBox_node:setTitle(i18n(titleBuff.Name))
	local titleInfo = self.itemData.titleInfo
	if titleInfo then
		local playerInfo = titleInfo.playerInfo
		local strName = ""
		if playerInfo.abbr then
			hegemonRead = i18n(titleBuff.Name)
			i18n(titleBuff.Name).abbr = playerInfo.abbr
			i18n(titleBuff.Name).name = playerInfo.nickname
		end
		strName = i18n("common_text_186", i18n(titleBuff.Name)) or playerInfo.nickname
		if playerInfo.kid then
			strName = strName .. "#" .. playerInfo.kid
		end
		self.Text_Name:setString(strName)
	end
	self:showLegendKingBuffs(titleBuff.Digitype)
	SoraDSetNodeArrayVisible(self.tbOfficialNodes, false)
	local hegemonRead, tbShowNodes = SoraDSetNodeArrayVisible, SoraDSetNodeArrayVisible
	local titleInfo = self.itemData.titleInfo
	if titleInfo then
		local playerInfo = titleInfo.playerInfo
		if playerInfo.uid then
			local chatFunctions = include("chatFunctions")
			local selfId = chatFunctions:getSelfId()
			if selfId ~= playerInfo.uid then
				table.insert(tbShowNodes, self.Sprite_Circle_Info)
				table.insert(tbShowNodes, self.Sprite_Circle_Mail)
			end
		end
	end
	if hegemonCtrl:getIsSelfHegemon() and hegemonCtrl:getJoinBid() == self.bid then
		table.insert(tbShowNodes, self.Sprite_Circle_Dismiss)
	end
	if isHideOp then
		tbShowNodes, hegemonRead = table.insert, table.insert
	end
	SoraDSetNodeArrayVisible(tbShowNodes, true)
	local totalWidth = 531
	SoraDAlignHNodesOnCenterX(tbShowNodes, -totalWidth / 2, totalWidth, SoraDFIsRA())
	if self.isShowMode then
		self.btnShow:setVisible(true)
		if lordInfoCtrl:getShowOfficialType() == gShowOfficialType.HEGEMON then
			self.btnShow:setVisible(false)
			self.text_show:setString(i18n("common_text_4361"))
		elseif lordInfoCtrl:canChangeShowOfficialType() then
			print("可以切换-----")
			self.btnShow:setBright(true)
			self.btnShow:setTouchEnabled(true)
		else
			print("无法切换--------")
			self.btnShow:setTouchEnabled(true)
			self.btnShow:setBright(false)
		end
	end
	SoraDToCenter(self.nodeControls, 70, true)
end
function hegemonOfficial:showLegendKingBuffs(buffId)
	for i = 1, #self.buffNodes do
		self.buffNodes[i]:setVisible(false)
		self.textBuffNodes[i]:setVisible(false)
	end
	local buffType = gLegendBuffType.PLAYER
	local buffDesTb = hegemonRead.getBuffDesTbById(buffId)
	for i, v in ipairs(buffDesTb) do
		if self.buffNodes[i] then
			self.buffNodes[i]:setVisible(true)
			self.textBuffNodes[i]:setVisible(true)
		end
		if self.textBuffNodes[i] then
			self.textBuffNodes[i]:setString(v)
		end
	end
	self:reArrangeDes(#buffDesTb)
end
function hegemonOfficial:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
end
function hegemonOfficial:onClick_Button_Dismiss(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		local titleBuff = self.itemData.titleBuff
		local titleID = titleBuff.Digitype
		local titleInfo = self.itemData.titleInfo
		if titleInfo then
			local playerInfo = titleInfo.playerInfo
			if playerInfo.uid then
				hegemonCtrl:reqCancelLordTitle(titleID, playerInfo.uid)
			end
		end
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function hegemonOfficial:onClick_Button_Mail(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local titleInfo = self.itemData.titleInfo
		if titleInfo then
			local playerInfo = titleInfo.playerInfo
			_ENV = nil
			;(nil).targetType = gMailType.CHAT
			;(nil).target = playerInfo.uid
			;(nil).nickName = playerInfo.nickname
			local (nil).allianceAbbr, data = playerInfo.abbr or "", nil
			SoraDCreateChatView(data)
		end
	end
end
function hegemonOfficial:onClick_Button_Info(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local titleInfo = self.itemData.titleInfo
		if titleInfo then
			local playerInfo = titleInfo.playerInfo
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			local kid = playerInfo.kid
			local uid = playerInfo.uid
			_ENV = nil
			;(nil).fromhegemonOfficial = true
			;(nil).targetName = self.__cname
			lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
		end
	end
end
function hegemonOfficial:msgGetLordInfo(target, data)
	if data.clientData then
		local fromhegemonOfficial = data.clientData.fromhegemonOfficial
		if fromhegemonOfficial == true then
			SoraDOpenLordView(data.lord)
		end
	end
end
function hegemonOfficial:btnShowClick(button, type)
	if type == ccui.TouchEventType.ended then
		if not lordInfoCtrl:canChangeShowOfficialType() then
			SoraDShowMsgTip(i18n("hegemon_text_52"))
			return
		end
		lordInfoCtrl:reqSetShowOfficialType(gShowOfficialType.HEGEMON)
		self:closePanel()
	end
end
function hegemonOfficial:reArrangeDes(num)
	local singleH = 62
	local centerY = 43
	local totalH = num * singleH
	local offsetY = -(totalH / 2 - centerY)
	print("offsetY = ", offsetY)
	for i = 1, num do
		local posY = (i - 1) * singleH + offsetY
		self.buffNodes[i]:setPositionY(posY)
		print("posY = ", posY)
	end
end
return hegemonOfficial
