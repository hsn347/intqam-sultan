local ChangeSloganNode = class("changeSloganNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("changeSloganNode")
	end
	return target
end)
function ChangeSloganNode:ctor()
	self.nodeSize = SoraDGetChildByName(self, "Panel_size")
	self.btnSave = SoraDGetChildByName(self, "Button_save")
	self.btnSave:setTitleText(i18n("common_text_195"))
	self.btnEdit = SoraDGetChildByName(self, "Button_edit")
	self.btnEdit:setTitleText(i18n("common_text_244"))
	self.labelSlogan = SoraDGetChildByName(self, "Text_slogan")
	self.tfdSlogan = SoraDGetChildByName(self, "TextField_edit")
	_ENV = "TextField_edit"
	;("TextField_edit").func = handler(self, self.OnInputNotice)
	self.tfdSlogan = SoraDChangeToEditBox(self.tfdSlogan, "TextField_edit")
	self.tfdSlogan:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdSlogan:setFontSize(20)
	self.tfdSlogan:setPlaceHolder("")
	self.tfdSlogan:setFontColor(cc.c3b(50, 40, 40))
	self.tfdSlogan:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	self.nodeSize:setSwallowTouches(false)
	self.btnSave:addTouchEventListener(handler(self, self.btnSaveClickCallBack))
	self.btnEdit:addTouchEventListener(handler(self, self.btnEditClickCallBack))
	self:changeBtn(true)
	self:initData()
end
function ChangeSloganNode:initData()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.labelSlogan:setString(allianceMgr:getAllianceProperty("manifesto"))
end
function ChangeSloganNode:changeBtn(showEdit)
	self.btnEdit:setTouchEnabled(showEdit)
	self.btnEdit:setBright(showEdit)
	self.btnSave:setTouchEnabled(not showEdit)
	self.btnSave:setBright(not showEdit)
	self.tfdSlogan:setVisible(not showEdit)
	self.labelSlogan:setVisible(showEdit)
	self.btnEdit:setSwallowTouches(false)
	self.btnSave:setSwallowTouches(false)
	self.tfdSlogan:setSwallowTouches(false)
end
function ChangeSloganNode:btnEditClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:changeBtn(false)
		self.tfdSlogan:setString(self.labelSlogan:getString())
		self.tfdSlogan:closeIME()
		self:OnEditBoxTouch(self.tfdSlogan, ccui.TouchEventType.ended)
	end
end
function ChangeSloganNode:btnSaveClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceSetting = gametop.playertop_:getModule("allianceSetting")
		self:changeBtn(true)
		self.labelSlogan:setString(self.tfdSlogan:getString())
		allianceSetting:reqModifyManifesto(self.tfdSlogan:getString())
	end
end
function ChangeSloganNode:getSingleH()
	return self.nodeSize:getContentSize().height
end
function ChangeSloganNode:OnInputNotice(eventType, textField)
	if eventType == "began" then
	elseif eventType == "changed" then
	elseif eventType == "ended" then
	elseif eventType == "return" then
	end
end
function ChangeSloganNode:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		target:touchDownAction(target, type)
	end
end
return ChangeSloganNode
