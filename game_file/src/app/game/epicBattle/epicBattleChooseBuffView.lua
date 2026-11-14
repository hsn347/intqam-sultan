local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local buffDesRead = include("buffDesRead")
local epicBattleDef = include("epicBattleDef")
_ENV = "epicBattleDef"
;("epicBattleDef").buff = 1
local ("epicBattleDef").cure, showModel = 2, "epicBattleDef"
local epicBattleChooseBuffView = class("epicBattleChooseBuffView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleChooseBuffView")
	end
	return target
end)
function epicBattleChooseBuffView:ctor()
	self:setBackGround(127.5)
	self.buffList, showModel, self.model = showModel.buff, showModel.buff, showModel.buff
	self.isSelected = false
	self.Sprite_notice = SoraDGetChildByName(self, "Sprite_notice")
	self.Node_buff = SoraDGetChildByName(self.Sprite_notice, "Node_buff")
	self.Node_cure = SoraDGetChildByName(self.Sprite_notice, "Node_cure")
	self.Node_cure:setVisible(false)
	self.Node_girl = SoraDGetChildByName(self, "Node_girl")
	self.spriteGirl = SoraDCreateGuideNPC()
	self.spriteGirl:setPosition(0, 0)
	self.spriteGirl:addTo(self.Node_girl)
	self:onEnterAction()
end
function epicBattleChooseBuffView:onEnterAction()
	self.Node_girl:runAction(cca.moveTo(0.5, SoraDFPosX(130, 0), -115))
	self.Sprite_notice:runAction(cca.moveTo(0.5, SoraDFPosX(320, 0), 0))
end
function epicBattleChooseBuffView:initData(data)
	self.buffList = data.info.eventData.eventParam
	self.pos = data.pos
	for i = 1, 4 do
		local nodeBuff = SoraDGetChildByName(self.Node_buff, "Node_buff_" .. i)
		if self.buffList and self.buffList[i] then
			local Image_touchBg = SoraDGetChildByName(nodeBuff, "Image_touchBg")
			Image_touchBg:setTag(i)
			Image_touchBg:setTouchEnabled(true)
			Image_touchBg:addTouchEventListener(handler(self, self.onBtnChooseClick))
			local Text_NO = SoraDGetChildByName(nodeBuff, "Text_NO")
			Text_NO:setString(i .. ".")
			local Text_name = SoraDGetChildByName(nodeBuff, "Text_name")
			Text_name:setString(buffDesRead.getTitleBase(self.buffList[i].buffType))
			local Text_value = SoraDGetChildByName(nodeBuff, "Text_value")
			Text_value:setString(string.format("%d%%", self.buffList[i].buffValue / 10))
		else
			nodeBuff:setVisible(false)
		end
	end
end
function epicBattleChooseBuffView:setShowModel(model)
	self.model = model
	if self.model == showModel.cure then
		self.Node_cure:setVisible(true)
		self.Node_buff:setVisible(false)
		self.Text_des_cure = SoraDGetChildByName(self.Node_cure, "Text_des_cure")
		self.Text_des_cure:setString(i18n("epicbattle_text_50"))
		self.Button_ok = SoraDGetChildByName(self.Node_cure, "Button_ok")
		self.Button_ok:setTitleText(i18n("common_text_314"))
		self.Button_ok:addTouchEventListener(handler(self, self.onBtnOkClick))
	else
		self.Node_cure:setVisible(false)
		self.Node_buff:setVisible(true)
		self.Text_des = SoraDGetChildByName(self.Node_buff, "Text_des")
		self.Text_des:setString(i18n("guide_text_139"))
	end
end
function epicBattleChooseBuffView:onBtnOkClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		epicBattleDef = nil
		;(nil)[1] = cca.callFunc(function()
			epicWarCtrl:sendReqTriggerEvent(nil, self.pos)
			SoraDShowLoading()
		end)
		;(nil)[2] = cca.delay(0.5)
		;(nil)[3] = cca.callFunc(function()
			SoraDShowMsgTip(i18n("epicbattle_text_51"))
			_ENV = i18n("epicbattle_text_51")
			i18n("epicbattle_text_51").msg = "MESSAGE_UI_EPICBATTLE_BUFF_CHOOSE"
			i18n("epicbattle_text_51").eType = epicBattleDef.epicFlyColor.green
			SoraDSendMessage(i18n("epicbattle_text_51"))
			self:removeFromParent()
		end)
		;(nil)[4] = cca.callFunc(function()
			SoraDShowMsgTip(i18n("epicbattle_text_51"))
			_ENV = i18n("epicbattle_text_51")
			i18n("epicbattle_text_51").msg = "MESSAGE_UI_EPICBATTLE_BUFF_CHOOSE"
			i18n("epicbattle_text_51").eType = epicBattleDef.epicFlyColor.green
			SoraDSendMessage(i18n("epicbattle_text_51"))
			self:removeFromParent()
		end)
		local seq = cca.seq(nil)
		self:runAction(seq)
	end
end
function epicBattleChooseBuffView:onBtnChooseClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		buffDesRead = nil
		;(nil)[1] = cca.callFunc(function()
			if not self.isSelected then
				target:setColor(cc.c3b(80, 50, 0))
				self.isSelected = true
				epicWarCtrl:sendReqTriggerEvent(nil, self.pos, nil, nil, target:getTag())
				SoraDShowLoading()
			end
		end)
		;(nil)[2] = cca.delay(0.5)
		;(nil)[3] = cca.callFunc(function()
			_ENV = nil
			;(nil).name = buffDesRead.getTitleBase(self.buffList[target:getTag()].buffType)
			SoraDShowMsgTip(i18n("epicbattle_text_52", nil))
			_ENV = i18n("epicbattle_text_52", nil)
			i18n("epicbattle_text_52", nil).msg = "MESSAGE_UI_EPICBATTLE_BUFF_CHOOSE"
			i18n("epicbattle_text_52", nil).eType = epicBattleDef.epicFlyColor.orange
			SoraDSendMessage(i18n("epicbattle_text_52", nil))
			self:removeFromParent()
		end)
		;(nil)[4] = cca.callFunc(function()
			_ENV = nil
			;(nil).name = buffDesRead.getTitleBase(self.buffList[target:getTag()].buffType)
			SoraDShowMsgTip(i18n("epicbattle_text_52", nil))
			_ENV = i18n("epicbattle_text_52", nil)
			i18n("epicbattle_text_52", nil).msg = "MESSAGE_UI_EPICBATTLE_BUFF_CHOOSE"
			i18n("epicbattle_text_52", nil).eType = epicBattleDef.epicFlyColor.orange
			SoraDSendMessage(i18n("epicbattle_text_52", nil))
			self:removeFromParent()
		end)
		local seq = cca.seq(nil)
		self:runAction(seq)
	end
end
return epicBattleChooseBuffView
