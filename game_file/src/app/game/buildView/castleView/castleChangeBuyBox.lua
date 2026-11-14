local gametop = gModuleMgr.getObject("gametop")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local castleChangeBuyBox = class("castleChangeBuyBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("castleChangeBuyBox")
	end
	return target
end)
function castleChangeBuyBox:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.Text_msg = SoraDGetChildByName(self, "Text_msg")
	self.btn_buy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_buy")
	self.btn_buy:addTouchEventListener(handler(self, self.btnBuyCallBack))
	self.Node_activite = SoraDGetChildByName(self, "Node_activite")
	self.CheckBox_act = SoraDGetChildByName(self.Node_activite, "CheckBox")
	self.CheckBox_act:addEventListener(handler(self, self.btnActCallBack))
	self.CheckBox_act:setSelected(false)
	self.text_check_act = SoraDGetChildByName(self.Node_activite, "text_check_tip")
	self.text_check_act:setString(i18n("common_btn_05"))
	self.Node_dress = SoraDGetChildByName(self, "Node_dress")
	self.CheckBox_dre = SoraDGetChildByName(self.Node_dress, "CheckBox")
	self.CheckBox_dre:addEventListener(handler(self, self.btnDreCallBack))
	self.CheckBox_dre:setSelected(false)
	self.text_check_dre = SoraDGetChildByName(self.Node_dress, "text_check_tip")
	self.text_check_dre:setString(i18n("castle_skin_btn_01"))
	SoraDSetTextWidthHeight(self.text_check_dre, cc.size(160, 60))
	self.text_check_dre:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
end
function castleChangeBuyBox:initData(msg, gold, shopItemID)
	self.Text_msg:setString(msg)
	self.shopItemID = shopItemID
	_ENV = msg
	msg.title = i18n("common_text_054")
	msg.gold = gold
	self.btn_buy:initData(msg, 1)
end
function castleChangeBuyBox:btnActCallBack(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self.CheckBox_act:setSelected(true)
		self.CheckBox_dre:setSelected(false)
	else
		self.CheckBox_act:setSelected(false)
	end
end
function castleChangeBuyBox:btnDreCallBack(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self.CheckBox_act:setSelected(false)
		self.CheckBox_dre:setSelected(true)
	else
		self.CheckBox_dre:setSelected(false)
	end
end
function castleChangeBuyBox:btnBuyCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.CheckBox_dre:isSelected() then
			print("激活并装扮=========")
			shopCtrl:buyInDressShop(self.shopItemID, 1, true, true)
		elseif self.CheckBox_act:isSelected() then
			print("激活=========")
			shopCtrl:buyInDressShop(self.shopItemID, 1, true)
		else
			print("普通购买=========")
			shopCtrl:buyInDressShop(self.shopItemID, 1)
		end
		self:removeFromParent()
	end
end
return castleChangeBuyBox
