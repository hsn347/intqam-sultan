local GameNPCHelperView = class("gameNPCHelperView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("gameNPCHelperView")
	end
	return target
end)
function GameNPCHelperView:ctor()
	_UPVALUE8_ = nil
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[1] = nil, nil, nil, i18n("common_text_2284")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[2] = nil, nil, nil, i18n("common_text_1082")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[3] = nil, nil, nil, i18n("common_text_1083")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[4] = nil, nil, nil, i18n("common_text_1085")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[5] = nil, nil, nil, i18n("common_text_1089")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[6] = nil, nil, nil, i18n("common_text_1094")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[7] = nil, nil, nil, i18n("common_text_1098")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[8] = nil, nil, nil, i18n("common_text_1100")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[9] = nil, nil, nil, i18n("common_text_1107")
	self.tableNotice, _ENV, self.tableSpareNotice, (nil)[10] = nil, nil, nil, i18n("common_text_1107")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.layerTop = SoraDGetChildByName(self, "Panel_top")
	self.imgFrame = SoraDGetChildByName(self, "Image_frame")
	self.layerBottom = SoraDGetChildByName(self, "Panel_bottom")
	self.imgFrame = SoraDGetChildByName(self, "Image_frame")
	self.imgBg2 = SoraDGetChildByName(self, "Image_bg2")
	self.imgBg1 = SoraDGetChildByName(self, "Image_bg1")
	self.imgBg1:setFillType(1)
	self.imgBg2:setFillType(1)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelName:setString(i18n("common_text_2291"))
	self.labelTip = SoraDGetChildByName(self, "Text_tip")
	self.btnLeft = SoraDGetChildByName(self, "Button_left")
	self.btnRight = SoraDGetChildByName(self, "Button_right")
	self.img2 = SoraDGetChildByName(self, "Image_2")
	self.labelRemind = SoraDGetChildByName(self, "Text_remind")
	self.labelRemind:setString(i18n("common_text_2273"))
	self.checkBoxClose = SoraDGetChildByName(self, "CheckBox_close")
	self.checkBoxClose:addEventListener(handler(self, self.btnCheckClickCallBack))
	self.btnLeft:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnRight:addTouchEventListener(handler(self, self.btnClickCallBack))
	self:setCheck(false)
	self:randomNotice()
	self:initView()
end
function GameNPCHelperView:initView()
	local _UPVALUE5_, _ENV, tableSingle
	;(nil)[1] = gNPCHelperTypeDef.stuff
	;(nil)[2] = gNPCHelperTypeDef.build
	;(nil)[3] = gNPCHelperTypeDef.army
	;(nil)[4] = gNPCHelperTypeDef.college
	local (nil)[5], tableNPCType = gNPCHelperTypeDef.troops, nil
	for i, v in ipairs(tableNPCType) do
		local single = SoraDCreatePanel("gameNPCHelperSingle")
		if single:initData(v) then
			table.insert(tableSingle, 1, single)
		else
			table.insert(tableSingle, single)
		end
		single:addTo(self.layerTop)
	end
	for i, v in ipairs(tableSingle) do
		v:setPosition(cc.p(270, 460 - (i - 1) * 92))
	end
end
function GameNPCHelperView:randomNotice()
	if #self.tableNotice == 0 then
		for i, v in ipairs(self.tableSpareNotice) do
			table.insert(self.tableNotice, v)
		end
	end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	self.labelTip:setString(table.remove(self.tableNotice, math.random(1, #self.tableNotice)))
end
function GameNPCHelperView:setCheck(isCheck)
	self.checkBoxClose:setSelected(isCheck)
	self.checkBoxClose:setTouchEnabled(not isCheck)
end
function GameNPCHelperView:btnCheckClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self:setCheck(true)
		SoraDShowMsgBox(i18n("common_text_2272"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				_ENV = nil
				;(nil).type = 3
				;(nil).jump = 0
				userSDKManager.logEvent(gSDKDef.TDonEvent.game_assistant_log, nil)
				self:removeFromParent()
			else
				self:setCheck(false)
			end
		end)
	end
end
function GameNPCHelperView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:randomNotice()
	end
end
return GameNPCHelperView
