local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
local friendsCallbackMail = class("friendsCallbackMail", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("friendsCallbackMail")
	end
	return target
end)
function friendsCallbackMail:ctor()
	self.isAddToPopManager = true
	self.isOpen = false
	self.enableTouchCloseSelf = true
	self.isCantCloseByReturn = true
	self:initWidget()
	self:initData()
	self:panelScaleAct()
end
function friendsCallbackMail:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	local isRA = SoraDFIsRA()
	self.Node_text:setVisible(isRA)
	self.Node_text_en:setVisible(not isRA)
	local Node_text = isRA and self.Node_text or self.Node_text_en
	SoraDGetAllChildFromWidget(Node_text, self)
	self.Text_content = SoraDChangeTextToHtml(self.Text_content)
	self.Button_open:addTouchEventListener(handler(self, self.btnOpenClick))
end
function friendsCallbackMail:initData()
	if not self.isOpen then
		self.Node_open:setVisible(true)
		self.Node_receive:setVisible(false)
		self.Text_open_down:setString(i18n("common_text_246_ros"))
		self.Text_open_up:setString(i18n("common_text_246_ros"))
		_UPVALUE3_ = i18n("common_text_246_ros")
		i18n("common_text_246_ros")[1] = "ar"
		i18n("common_text_246_ros")[2] = "en"
		i18n("common_text_246_ros")[3] = "ko"
		self.Sprite_cover:setSpriteFrame(SoraDGetImageNameByLang("frame_hyzh_xfwz_%s.png", i18n("common_text_246_ros")))
	else
		self.Text_open_down:setString(i18n("common_text_1146"))
		self.Text_open_up:setString(i18n("common_text_1146"))
		self.Text_name:setString(lordInfoCtrl:getBaseInfo().nickName .. ":")
		if SoraDFIsRA() then
			self.Text_name:setString(":" .. lordInfoCtrl:getBaseInfo().nickName)
		end
		self.Text_content:setColor(cc.c3b(255, 255, 255))
		local createTime = lordInfoCtrl:getLordInfo().base.createTime
		local lastLogoutTime = honorBackCtrl:getLastLogoutTime()
		print("==createTime,lastLogoutTime==", createTime, lastLogoutTime)
		local day, _, _ = SoraDConverSecondToDayAndHours(serviceFunctions.systemTime() - lastLogoutTime)
		_ENV = cc.c3b(255, 255, 255)
		cc.c3b(255, 255, 255).year = os.date("!%Y.%m.%d", createTime)
		_ENV, _ENV, cc.c3b(255, 255, 255).num = "!%Y.%m.%d", os.date("!%Y.%m.%d", createTime), day
		_ENV, os.date("!%Y.%m.%d", createTime).year, ("!%Y.%m.%d").color = "!%Y.%m.%d", "!%Y.%m.%d", "#9f0977"
		_ENV, os.date("!%Y.%m.%d", createTime).num, ("!%Y.%m.%d").color = "!%Y.%m.%d", "!%Y.%m.%d", "#0d700b"
		os.date("!%Y.%m.%d", createTime).__default, ("!%Y.%m.%d").color = "!%Y.%m.%d", "#8d6e42"
		local str = i18n_html("returnnew_text_002", cc.c3b(255, 255, 255))
		self.Text_content:setString(str)
		self.Text_signature:setString(i18n("common_text_1012"))
	end
	if not self.isOpen then
		local effect = SoraDCreatAnimation("xinfeng_0")
		self.effect = effect
		SoraDMixtureGLONEByParent(effect)
		effect:addTo(self.Node_button)
		effect:setPosition(0, 62)
		self.lineEffect1 = SoraDGetChildByName(effect, "G_dh_xinfeng6_01_17")
		self.lineEffect2 = SoraDGetChildByName(effect, "G_dh_xinfeng6_02_19")
	else
		if self.lineEffect1 and self.lineEffect2 then
			self.lineEffect1:setVisible(false)
			self.lineEffect2:setVisible(false)
		end
		local effect = SoraDCreatAnimation("xinfeng", nil, false)
		SoraDMixtureGLONEByParent(effect)
		effect:addTo(self.Center_Node)
		effect:setPosition(3, -68)
		self.Particle_1 = SoraDGetChildByName(effect, "Particle_1")
		self.Particle_1:setVisible(false)
		lordInfoCtrl = -68
		;(-68)[1] = cca.delay(0.13333333333333333)
		;(-68)[2] = cca.callFunc(function()
			self.Particle_1:resetSystem()
			self.Particle_1:setVisible(true)
		end)
		;(-68)[3] = cca.callFunc(function()
			self.Particle_1:resetSystem()
			self.Particle_1:setVisible(true)
		end)
		;(-68)[4] = cca.callFunc(function()
			self.Particle_1:resetSystem()
			self.Particle_1:setVisible(true)
		end)
		;(-68)[5] = cca.callFunc(function()
			self.Particle_1:resetSystem()
			self.Particle_1:setVisible(true)
		end)
		;(-68)[6] = cca.callFunc(function()
			self.Particle_1:resetSystem()
			self.Particle_1:setVisible(true)
		end)
		;(-68)[7] = cca.callFunc(function()
			self.Particle_1:resetSystem()
			self.Particle_1:setVisible(true)
		end)
		;(-68)[8] = cca.callFunc(function()
			self.Particle_1:resetSystem()
			self.Particle_1:setVisible(true)
		end)
		;(-68)[9] = cca.callFunc(function()
			self.Particle_1:resetSystem()
			self.Particle_1:setVisible(true)
		end)
		self.Particle_1:runAction(cca.seq(-68))
		_UPVALUE7_ = cca.seq(-68)
		cca.seq(-68)[1] = cca.delay(0.13333333333333333)
		cca.seq(-68)[2] = cca.scaleTo(0.06666666666666667, 0.9)
		cca.seq(-68)[3] = cca.scaleTo(0.03333333333333333, 0.3)
		cca.seq(-68)[4] = cca.scaleTo(0.08333333333333333, 0.73)
		cca.seq(-68)[5] = cca.callFunc(function()
			self.Node_open:setVisible(false)
			self.Node_receive:setVisible(true)
			self.Node_opacity:setOpacity(0)
		end)
		cca.seq(-68)[6] = cca.scaleTo(0.08333333333333333, 1.05)
		cca.seq(-68)[7] = cca.scaleTo(0.03333333333333333, 1.0)
		cca.seq(-68)[8] = cca.callFunc(function()
			self.Node_move:runAction(cca.moveBy(0.36666666666666664, 0, 220))
			self.Node_opacity:runAction(cca.fadeTo(0.23333333333333334, 1))
		end)
		cca.seq(-68)[9] = cca.callFunc(function()
			self.Node_move:runAction(cca.moveBy(0.36666666666666664, 0, 220))
			self.Node_opacity:runAction(cca.fadeTo(0.23333333333333334, 1))
		end)
		self.scaleActTarget:runAction(cca.seq(cca.seq(-68)))
	end
end
function friendsCallbackMail:btnOpenClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.isOpen then
			self.isOpen = true
			self:initData()
		else
			SoraDRemoveAllPanelFromManager()
			SoraDCreatePanel("friendsCallbackGift"):show()
		end
	end
end
return friendsCallbackMail
