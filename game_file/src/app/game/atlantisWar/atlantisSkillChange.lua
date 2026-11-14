local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local ASD = require_data("atlantiswar_skill_display").data
local qualityConfig = gAtlantisQualityConfig
local atlantisActivityRead = include("atlantisActivityRead")
local atlantisWarUtil = include("atlantisWarUtil")
local atlantisSkillChange = class("atlantisSkillChange", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisSkillChange")
	end
	return target
end)
function atlantisSkillChange:ctor()
	self.candidateSkill = atlantisActivityCtrl:getSkillData("candidateSkill")
	self.skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
	self.lotteryTimes = atlantisActivityCtrl:getSkillData("lotteryTimes")
	self.itemID = ATLANTIS_WAR_SKILL_CAR
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	self.itemCost = 1
	self.isAction = false
	self:initWidget()
end
function atlantisSkillChange:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_LOTTERY", handler(self, self.onMessageSkillLottery))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_REPLACE", handler(self, self.onMessageSkillReplace))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMessageBagChange))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_SELECT", handler(self, self.onMessageSkillSelect))
end
function atlantisSkillChange:initWidget()
	atlantisWarUtil = nil
	;(nil)[1] = "Center_Node"
	self.Center_Node = SoraDGetChildByFullPath(self._ccsView, nil)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self.Center_Node, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("atlantiswar_skill_text_024"))
	_UPVALUE2_ = i18n("atlantiswar_skill_text_024")
	i18n("atlantiswar_skill_text_024")[1] = "Node_tip"
	i18n("atlantiswar_skill_text_024")[2] = "Text_tip"
	self.Text_tip = SoraDGetChildByFullPath(self.Center_Node, i18n("atlantiswar_skill_text_024"))
	self.Text_tip:setString(i18n("atlantiswar_skill_text_025"))
	atlantisWarUtil = i18n("atlantiswar_skill_text_025")
	i18n("atlantiswar_skill_text_025")[1] = "Sprite_arrow"
	self.Sprite_arrow = SoraDGetChildByFullPath(self.Center_Node, i18n("atlantiswar_skill_text_025"))
	atlantisWarUtil = i18n("atlantiswar_skill_text_025")
	i18n("atlantiswar_skill_text_025")[1] = "Node_skillCur"
	self.Node_skillCur = SoraDGetChildByFullPath(self.Center_Node, i18n("atlantiswar_skill_text_025"))
	SoraDGetAllChildFromWidget(self.Node_skillCur, self.Node_skillCur)
	self.Node_skillCur.Text_skillCur:setString(i18n("atlantiswar_skill_text_026"))
	atlantisWarUtil = i18n("atlantiswar_skill_text_026")
	i18n("atlantiswar_skill_text_026")[1] = "Node_skillNew"
	self.Node_skillNew = SoraDGetChildByFullPath(self.Center_Node, i18n("atlantiswar_skill_text_026"))
	SoraDGetAllChildFromWidget(self.Node_skillNew, self.Node_skillNew)
	self.Node_skillNew.Text_skillNew:setString(i18n("atlantiswar_skill_text_053"))
	if SoraDFIsRA() then
		self.Node_skillCur:setPositionX(-140)
		self.Node_skillNew:setPositionX(132)
		self.Sprite_arrow:setFlippedX(false)
	else
		self.Node_skillCur:setPositionX(132)
		self.Node_skillNew:setPositionX(-140)
	end
	_UPVALUE2_ = -140
	;(-140)[1] = "Node_btns"
	;(-140)[2] = "Button_use"
	self.Button_use = SoraDGetChildByFullPath(self.Center_Node, -140)
	self.Button_use:setTitleText(i18n("Canyon_Treasur_text_14"))
	self.Button_use:addTouchEventListener(handler(self, self.btnUseClick))
	_UPVALUE2_ = handler(self, self.btnUseClick)
	handler(self, self.btnUseClick)[1] = "Node_btns"
	handler(self, self.btnUseClick)[2] = "Node_get"
	self.Node_get = SoraDGetChildByFullPath(self.Center_Node, handler(self, self.btnUseClick))
	self.ccs_get = SoraDGetExtendChildFromCCSByName(self.Node_get, "CCS_commonGoldNormalBtn_1")
	self.ccs_get:addTouchEventListener(handler(self, self.btnGetClick))
	self.ccs_get:setColor(gBtnColorDef.YELLOW)
	_ENV = gBtnColorDef.YELLOW
	gBtnColorDef.YELLOW.id = self.itemID
	self.ccs_get:initData(gBtnColorDef.YELLOW, 3)
	self.ccs_get:setTextGoldColor(display.COLOR_WHITE)
	self:refreshItemCount()
	atlantisWarUtil = display.COLOR_WHITE
	display.COLOR_WHITE[1] = "Text_remain"
	self.Text_remain = SoraDGetChildByFullPath(self.Node_get, display.COLOR_WHITE)
	self.Text_remain = SoraDChangeTextToHtml(self.Text_remain)
	self:refreshLotteryTimes()
	if atlantisWarUtil.isNewMap() then
		local obj = fguiHelper.createObject("RoaringFlameWar", "Button_extra")
		obj:addTo(self.Center_Node)
		obj:setPosition(190, 395)
		obj:addClickListener(handler(self, self.btnExtraClick))
		self.Button_extra = obj
		self:updateBtnExtra()
	end
end
function atlantisSkillChange:initData(index)
	self.index = index
	self.curSkillId = self.skillSlot[tostring(self.index)].skillId
	self:initSkillSingle(self.Node_skillCur, self.curSkillId)
	self:refreshNewSkill()
end
function atlantisSkillChange:btnUseClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isAction then
			return
		end
		atlantisActivityCtrl:reqSkillReplace(self.index)
		SoraDShowLoading()
	end
end
function atlantisSkillChange:btnGetClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isAction then
			return
		end
		if self.itemCount < self.itemCost then
			_ENV, _ENV = nil, nil
			;(nil).noStyle, (nil).normal = nil, "btn_green_normal_01.png"
			SoraDShowMsgBox(i18n("atlantiswar_text_0262"), i18n("atlantiswar_skill_text_010"), i18n("common_text_1809"), function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_UPVALUE3_ = MSGBOX_CALLBACK_YES
					MSGBOX_CALLBACK_YES[1] = 14426
					MSGBOX_CALLBACK_YES[2] = 14427
					local MSGBOX_CALLBACK_YES[3], giftArray = 14428, MSGBOX_CALLBACK_YES
					if GLOBAL_GAME_RECHARGE_MODE then
						_ENV = nil
						;(nil).rechargeIDList = giftArray
						uiManager:show("rechargeView", nil)
					else
						local panel = SoraDCreatePanel("rechargeView")
						panel:jumpToLimitNodeByList(IsArClient and 5 or 12, giftArray)
						panel:show()
					end
				elseif MSGBOX_CALLBACK_NO == eventType then
					local atlantisWarUtil = include("atlantisWarUtil")
					atlantisWarUtil.openExchangeShop()
				end
			end, nil)
		else
			atlantisActivityCtrl:reqSkillLottery(self.index)
			SoraDShowLoading()
		end
	end
end
function atlantisSkillChange:initSkillSingle(single, skillId)
	ASD = nil
	;(nil)[1] = "framer_zcjn_jnk_03.png"
	;(nil)[2] = "framer_zcjn_jnk_04.png"
	local (nil)[3], qualityIcon = "framer_zcjn_jnk_05.png", nil
	local config = ASD[skillId]
	local qConfig = qualityConfig[config.quality]
	local sConfig = qualityConfig[config.sort]
	SoraChangeSpriteImage(single.Image_skill, config.img)
	single.Text_name:setString(i18n(config.name))
	single.Text_name:setColor(qConfig.color)
	single.Sprite_frame:setSpriteFrame(qualityIcon[config.quality])
	single.Text_type:setString(i18n(sConfig.tName))
	single.Text_des:setString(i18n(config.describe))
	if single.Node_state1 then
		single.Node_state1:setVisible(false)
	end
	single.Node_state2:setVisible(true)
end
function atlantisSkillChange:resetSkillSingle(single)
	single.Node_state1:setVisible(true)
	single.Node_state2:setVisible(false)
end
function atlantisSkillChange:refreshNewSkill(...)
	self.newSkillId = self.candidateSkill[tostring(self.index)]
	if self.newSkillId then
		self.Button_use:setVisible(true)
		self.Button_use:setPositionX(SoraDFSign(130))
		self.Node_get:setPositionX(SoraDFSign(-130))
		self.ccs_get:setTitleStr(i18n("atlantiswar_skill_text_031"))
		self:initSkillSingle(self.Node_skillNew, self.newSkillId)
	else
		self.Button_use:setVisible(false)
		self.Node_get:setPositionX(0)
		self.ccs_get:setTitleStr(i18n("atlantiswar_skill_text_029"))
		self:resetSkillSingle(self.Node_skillNew)
	end
end
function atlantisSkillChange:refreshLotteryTimes(...)
	self.lotteryTimes = atlantisActivityCtrl:getSkillData("lotteryTimes")
	local times_max = MAX_SKILL_LOTTERY_TIMES
	local remain = math.max(0, times_max - self.lotteryTimes)
	if 0 < remain then
		self.ccs_get:setTouchEnabled(true)
		atlantisActivityCtrl = nil
		;(nil).var1 = remain
		;(nil).var2 = times_max
		self.Text_remain:setString(i18n("atlantiswar_skill_text_028", nil))
	else
		self.ccs_get:setTouchEnabled(false)
		atlantisActivityCtrl = i18n("atlantiswar_skill_text_028", nil)
		i18n("atlantiswar_skill_text_028", nil).var1 = remain
		atlantisActivityCtrl, atlantisActivityCtrl, i18n("atlantiswar_skill_text_028", nil).var2 = i18n("atlantiswar_skill_text_028", nil)
		i18n("atlantiswar_skill_text_028", nil).var1, i18n("atlantiswar_skill_text_028", nil).color = i18n("atlantiswar_skill_text_028", nil)
		self.Text_remain:setString(i18n_html("atlantiswar_skill_text_028", i18n("atlantiswar_skill_text_028", nil)))
	end
end
function atlantisSkillChange:onMessageSkillLottery(target, event)
	if event.index ~= self.index then
		return
	end
	self.candidateSkill = atlantisActivityCtrl:getSkillData("candidateSkill")
	self.newSkillId = self.candidateSkill[tostring(self.index)]
	if self.newSkillId then
		self.isAction = true
		self:initShowSkillEffect(self.Node_skillNew)
		_ENV = nil
		;(nil)[1] = cca.delay(0.5)
		;(nil)[2] = cca.callFunc(function()
			self.isAction = false
			self:refreshNewSkill()
		end)
		;(nil)[3] = cca.callFunc(function()
			self.isAction = false
			self:refreshNewSkill()
		end)
		self:runAction(cca.seq(nil))
	end
	self:refreshLotteryTimes()
	self:updateBtnExtra()
end
function atlantisSkillChange:onMessageSkillReplace(target, event)
	if event.index ~= self.index then
		return
	end
	self.isAction = true
	self:initReplaceSkillEffect()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(1)
	;(nil)[2] = cca.callFunc(function()
		self.isAction = false
		self:replaceSkill()
	end)
	;(nil)[3] = cca.callFunc(function()
		self.isAction = false
		self:replaceSkill()
	end)
	self:runAction(cca.seq(nil))
end
function atlantisSkillChange:initShowSkillEffect(skillSingle)
	local criSprite = cc.criSprite.createCriSprite("G_JNBH.usm", true, false, nil)
	criSprite:addTo(skillSingle, 1)
	criSprite:setPosition(4, 6)
	criSprite:setBlendFunc(gl.ONE, gl.ONE)
end
function atlantisSkillChange:initReplaceSkillEffect(...)
	local criSprite = cc.criSprite.createCriSprite("G_JNTJ.usm", true, false, nil)
	criSprite:addTo(self.Center_Node, 1)
	criSprite:setPosition(-5, 90)
	criSprite:setBlendFunc(gl.ONE, gl.ONE)
	if SoraDFIsRA() then
		criSprite:setScale(-1, 1)
	end
end
function atlantisSkillChange:replaceSkill(...)
	self.candidateSkill = atlantisActivityCtrl:getSkillData("candidateSkill")
	self:refreshNewSkill()
	self:updateCurSkill()
	self:initShowSkillEffect(self.Node_skillCur)
end
function atlantisSkillChange:updateCurSkill()
	self.skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
	self.curSkillId = self.skillSlot[tostring(self.index)].skillId
	self:initSkillSingle(self.Node_skillCur, self.curSkillId)
end
function atlantisSkillChange:onMessageBagChange(target, event)
	if not event.itemMap then
		return
	end
	for k, v in pairs(event.itemMap) do
		if k == self.itemID then
			self:refreshItemCount()
			break
		end
	end
end
function atlantisSkillChange:refreshItemCount()
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	backpackCtrl = self.itemID
	self.itemID.member = string.formatnumberthousands(self.itemCount)
	self.itemID.total = tostring(self.itemCost)
	local goldStr = i18n("common_text_155", self.itemID)
	self.ccs_get:setGoldText(goldStr)
	self.ccs_get:setEnouhGold(self.itemCount >= self.itemCost)
end
function atlantisSkillChange:btnExtraClick()
	SoraDPlaySound()
	if not atlantisWarUtil.isNewMap() then
		return
	end
	_ENV = nil
	;(nil).skillIdx = self.index
	;(nil).warType = gKingdomClassType.atlantis
	uiManager:show("RoaringFlame_SkillSelect", nil)
end
function atlantisSkillChange:updateBtnExtra()
	if not atlantisWarUtil.isNewMap() then
		return
	end
	local curNum = atlantisActivityCtrl:getUsedSkillTimes()
	local maxNum = atlantisActivityRead.getConstValue("ATLANTISWAR_SKILL_TIME", 60)
	local isEnough = curNum >= maxNum
	local numStr = ""
	if isEnough then
		atlantisWarUtil = nil
		;(nil).color = "#00FF00"
		atlantisWarUtil = nil
		;(nil).color = "#00FF00"
		numStr = SoraDWrapHtmlTagByStyle(curNum, nil) .. "/" .. SoraDWrapHtmlTagByStyle(maxNum, nil)
	else
		atlantisWarUtil = SoraDWrapHtmlTagByStyle(maxNum, nil)
		SoraDWrapHtmlTagByStyle(maxNum, nil).color = "#FFD43E"
		numStr = SoraDWrapHtmlTagByStyle(curNum, (SoraDWrapHtmlTagByStyle(maxNum, nil))) .. "/" .. maxNum
	end
	local btnStr = i18n("Promise_Summit_text_41") .. "\n" .. numStr
	self.Button_extra:setString(btnStr)
	self.Button_extra:setReddot(isEnough)
end
function atlantisSkillChange:onMessageSkillSelect(target, event)
	if event.index ~= self.index then
		return
	end
	SoraDCloseLoading()
	self:updateCurSkill()
	self:updateBtnExtra()
end
return atlantisSkillChange
