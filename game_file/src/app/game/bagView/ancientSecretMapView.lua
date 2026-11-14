local ancientTreasureRead = include("ancientTreasureRead")
local ancientSecretMapView = class("ancientSecretMapView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("ancientSecretMapView")
	end
	return target
end)
function ancientSecretMapView:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self:setTouchEnabled(false)
	self.Text_tip_title:setString(i18n("AncienTreasure_text_24"))
	self.Text_des:setString(i18n("AncienTreasure_btn_05"))
	self.Text_tip:setString(i18n("AncienTreasure_text_26"))
	self.Text_come:setString(i18n("AncienTreasure_text_25"))
	self.Button_explore:setTitleText(i18n("AncienTreasure_text_27"))
	SoraDAutoSizeButtonText(self.Button_explore, cc.size(160, 60))
	self.frame_title:setLocalZOrder(1)
	self.Button_explore:addTouchEventListener(handler(self, self.btnExploreCallBack))
	self:setBoxInfo()
	self:initSelfEffect()
	self:initOpenEffect()
end
function ancientSecretMapView:setBoxInfo()
	for i = 1, 3 do
		local nodeBox = SoraDGetChildByName(self, "Node_box_" .. i)
		local Button_box = SoraDGetChildByName(nodeBox, "Button_box")
		Button_box:setTag(i)
		Button_box:addTouchEventListener(handler(self, self.onBoxClick))
		local Sprite_box = SoraDGetChildByName(Button_box, "Sprite_Box")
		local boxInfo = ancientTreasureRead.getBoxInfoByIndex(i)
		Sprite_box:setSpriteFrame(boxInfo.box)
	end
end
function ancientSecretMapView:initSelfEffect()
	self.popEffect = SoraDCreatAnimationEx(self.__cname, self, false)
	self.Center_Node:setVisible(false)
	SoraDMixtureGLONEByParent(self.popEffect)
end
function ancientSecretMapView:initOpenEffect()
	self.openEffect = SoraDCreatAnimationEx("sgjzopen", nil, false)
	self.openEffect:setPosition(0, -30)
	SoraDMixtureGLONEByParent(self.openEffect)
	self.openEffect:addTo(self.Center_Node_effect)
	_UPVALUE5_ = -30
	;(-30)[1] = cca.delay(1.4)
	;(-30)[2] = cca.callFunc(function()
		self.openEffect.action:gotoFrameAndPlay(85, 186, true)
	end)
	;(-30)[3] = cca.callFunc(function()
		self.Center_Node:setVisible(true)
		self.popEffect.action:gotoFrameAndPlay(54, 84, false)
	end)
	;(-30)[4] = cca.callFunc(function()
		self:initTransferGateEffect()
	end)
	;(-30)[5] = cca.delay(2.0)
	;(-30)[6] = cca.callFunc(function()
		self:setTouchEnabled(true)
	end)
	;(-30)[7] = cca.callFunc(function()
		self:setTouchEnabled(true)
	end)
	self.openEffect:runAction(cca.seq(-30))
end
function ancientSecretMapView:initTransferGateEffect()
	self.gateEffect = SoraDCreatAnimation("sgjzcsm", nil, true)
	self.gateEffect:setPosition(0, 0)
	SoraDMixtureGLONEByParent(self.Center_Node)
	self.gateEffect:addTo(self.Center_Node_effect, -1)
end
function ancientSecretMapView:initData(data)
	local _ENV, data = nil, data or nil
	self.pos = cc.p(data.buildX or 0, data.buildY or 0)
	self.Text_pos:setString(self.pos.x .. "," .. self.pos.y)
	SoraDDrawTextUnderLine(self.Text_pos, cc.c4b(105, 180, 230, 255))
end
function ancientSecretMapView:onExitPanel()
	local gametop = gModuleMgr.getObject("gametop")
	local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
	ancientTreasureCtrl:sendReqInitDataMsg()
end
function ancientSecretMapView:btnExploreCallBack(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("跳转到世界坐标======")
		_ENV = "跳转到世界坐标======"
		;("跳转到世界坐标======").x = self.pos.x
		;("跳转到世界坐标======").y = self.pos.y
		SoraDGotoWorldMapPoint("跳转到世界坐标======", true)
		SoraDRemoveAllPanelFromManager()
	end
end
function ancientSecretMapView:onBoxClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("eventAncientSecretAwardView")
		panel:initData(target:getTag())
		panel:show()
	end
end
return ancientSecretMapView
