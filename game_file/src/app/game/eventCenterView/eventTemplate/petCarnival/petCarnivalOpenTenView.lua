local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = gametop.playertop_:getModule("petCarnivalCtrl")
local petCarnivalRead = include("petCarnivalRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local petCarnivalOpenTenView = class("petCarnivalOpenTenView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("petCarnivalOpenTenView")
	end
	return target
end)
function petCarnivalOpenTenView:ctor()
	self.award, _ENV = nil, nil
	self.data = nil
	self.targetView = nil
	self.isFirstShow = true
	self.Center_Panel_cut = SoraDGetChildByName(self, "Center_Panel_cut")
	self.commonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ScrollView_item = SoraDGetChildByName(self, "ScrollView_item")
	self.Text_leftNum = SoraDGetChildByName(self, "Text_leftNum")
	self.Text_Num = SoraDGetChildByName(self, "Text_Num")
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go:addTouchEventListener(handler(self, self.clickGoBtn))
	self.Text_need = SoraDGetChildByName(self, "Text_need")
	self.Text_need_10 = SoraDGetChildByName(self, "Text_need_10")
	self.Text_leftNum:setString(i18n("equip_text_09"))
	self.Text_star = SoraDGetChildByName(self, "Text_star")
	self.Text_star_10 = SoraDGetChildByName(self, "Text_star_10")
	self.Text_star:setString(i18n("luckyFlip_title_01"))
	_ENV = i18n("luckyFlip_title_01")
	i18n("luckyFlip_title_01").num = 10
	self.Text_star_10:setString(i18n("luckyFlip_btn_01", i18n("luckyFlip_title_01")))
	self.icon_double = SoraDGetChildByName(self, "icon_double")
	self.icon_double_10 = SoraDGetChildByName(self, "icon_double_10")
	self.icon_double:setVisible(false)
	self.icon_double_10:setVisible(false)
	self.Text_need:setString("1")
	self.Text_need_10:setString("10")
	self.Text_need = SoraDGetChildByName(self, "Text_need")
	self.Text_need_10 = SoraDGetChildByName(self, "Text_need_10")
	self.Button_star = SoraDGetChildByName(self, "Button_star")
	self.Button_star_ten = SoraDGetChildByName(self, "Button_star_ten")
	self.Button_star:addTouchEventListener(handler(self, self.clickStarBtn))
	self.Button_star_ten:addTouchEventListener(handler(self, self.clientStarTenBtn))
	self.Text_no = SoraDGetChildByName(self, "Text_no")
	self.Text_card = SoraDGetChildByName(self, "Text_card")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_reward = SoraDGetChildByName(self, "Text_reward")
	self.Text_no:setString(SoraDFIsRA() and i18n("pet_flip_text_09") or i18n("pet_flip_text_13"))
	self.Text_card:setString(i18n("pet_flip_text_14"))
	self.Text_reward:setString(SoraDFIsRA() and i18n("pet_flip_text_13") or i18n("pet_flip_text_09"))
	self.Text_title:setString(i18n("Lucky_treasure_text_05"))
	self.FileNode_loop = SoraDGetChildByName(self, "FileNode_loop")
	self.Node_loop_ani = SoraDGetChildByName(self, "Node_loop_ani")
	self:fitDevice()
	self:setBackGround(204.0)
	self:itemChange()
	self.Text_reward:setFontSize(18)
	SoraDSetTextWidthHeight(self.Text_no, cc.size(120, 40))
	SoraDSetTextWidthHeight(self.Text_card, cc.size(120, 40))
	SoraDSetTextWidthHeight(self.Text_reward, cc.size(120, 40))
	self.Button_star:setEnabled(false)
	self.Button_star_ten:setEnabled(false)
	self.enableTouchCloseSelf = true
end
function petCarnivalOpenTenView:fitDevice(...)
	local dis = display.height - 960
	if 0 < dis then
	elseif dis == 0 then
	else
		print("fitDevicefitDevicefitDevicefitDevice")
		self.Center_Panel_cut:setPositionY(320)
	end
end
function petCarnivalOpenTenView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.itemChange))
end
function petCarnivalOpenTenView:clickGoBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeID = 14089
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, 14089)
			panel:show()
		end
	end
end
function petCarnivalOpenTenView:itemChange()
	print("petCarnivalOpenTenView道具数量", backpackCtrl:getItemCount(833801))
	local num = backpackCtrl:getItemCount(833801)
	self.Text_Num:setString(string.formatnumberthousands(num))
	self.Text_need:setColor(0 < num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	self.Text_need_10:setColor(10 <= num and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
end
function petCarnivalOpenTenView:initData(data, view)
	self.data = data
	table.sort(self.data, function(l, r)
		return l.index < r.index
	end)
	self.limit = #data
	self.targetView = view
	self.FileNode_loop:setVisible(true)
	self.Node_loop_ani:setVisible(false)
	SoraDCreatAnimation("Node_petCarnivalTen_loop", self.FileNode_loop, true)
	SoraDCreatAnimationEx(self.__cname, self, false, 1, 109, 193)
	self:initScroll()
	_UPVALUE1_ = false
	;(false)[1] = cca.delay(1.5)
	;(false)[2] = cca.callFunc(function(...)
		self.Button_star:setEnabled(true)
		self.Button_star_ten:setEnabled(true)
		self.enableTouchCloseSelf = false
	end)
	;(false)[3] = cca.callFunc(function(...)
		self.Button_star:setEnabled(true)
		self.Button_star_ten:setEnabled(true)
		self.enableTouchCloseSelf = false
	end)
	self:runAction(cca.seq(false))
end
function petCarnivalOpenTenView:initScroll()
	self.ScrollView_item:removeAllChildren()
	local scrollH = math.max(self.ScrollView_item:getContentSize().height, 128 * #self.data)
	self.ScrollView_item:setInnerContainerSize(cc.size(540, scrollH))
	for i, v in ipairs(self.data) do
		local cell = include("petCarnivalOpenTenItem").new()
		_ENV = cc.size(540, scrollH)
		cc.size(540, scrollH).scroll = self.ScrollView_item
		cc.size(540, scrollH).view = self
		cell:initData(v, cc.size(540, scrollH))
		cell:setPosition(0, scrollH - i * 128 - 5)
		self:runCellAction(cell, i)
		cell:addTo(self.ScrollView_item)
	end
end
function petCarnivalOpenTenView:runCellAction(cell, index)
	cell:setVisible(false)
	cell:setOpacity(0)
	cell:setScale(1.0, 0.5)
	_UPVALUE2_ = 0.5
	;(0.5)[1] = cca.callFunc(function(...)
		cell:setVisible(true)
		_ENV = nil
		;(nil)[1] = cca.fadeIn(0.16666666666666666)
		;(nil)[2] = cca.scaleTo(0.25, 1.0, 1.0)
		;(nil)[3] = cca.scaleTo(0.25, 1.0, 1.0)
		;(nil)[4] = cca.scaleTo(0.25, 1.0, 1.0)
		;(nil)[5] = cca.scaleTo(0.25, 1.0, 1.0)
		cell:runAction(cca.spawn(nil))
	end)
	;(0.5)[2] = cca.delay((index - 1) * 6 / 60)
	;(0.5)[3] = cca.callFunc(function(...)
		self.ScrollView_item:jumpToPercentVertical(100 * index / #self.data)
	end)
	;(0.5)[4] = cca.callFunc(function(...)
		self.ScrollView_item:jumpToPercentVertical(100 * index / #self.data)
	end)
	self.ScrollView_item:runAction(cca.seq(0.5))
end
function petCarnivalOpenTenView:clickStarBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if backpackCtrl:getItemCount(833801) > 0 then
			petCarnivalCtrl:reqOpenCard()
			SoraDRemoveAllAfterPanelFromManager(self)
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	end
end
function petCarnivalOpenTenView:clientStarTenBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if backpackCtrl:getItemCount(833801) >= 10 then
			petCarnivalCtrl:reqOpenTenCard()
			SoraDShowLoading(self)
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	end
end
function petCarnivalOpenTenView:showDouble(flag)
	self.icon_double:setVisible(flag)
	self.icon_double_10:setVisible(flag)
end
function petCarnivalOpenTenView:close(ref, type)
	print("关闭自己～～～～～")
	if type == ccui.TouchEventType.ended then
		self.data = nil
		if self.targetView and self.targetView.showOrHideBfTen then
			self.targetView:showOrHideBfTen(true)
		end
		self:closePanel()
	end
end
return petCarnivalOpenTenView
