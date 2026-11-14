local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local publicRead = include("publicRead")
local epicBattleDef = include("epicBattleDef")
local epicWarWinPopView = class("epicWarWinPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarWinPopView")
	end
	return target
end)
function epicWarWinPopView:ctor()
	SoraDCreatAnimation(self.__cname, self._ccsView, false)
	self.data = nil
	self.starArray, _ENV, self.receiveAll = SoraDCreatAnimation, SoraDCreatAnimation, nil
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("epicbattle_text_16"))
	self.Node_awardShow = SoraDGetChildByName(self, "Node_awardShow")
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.onBtnOKClick))
	self.Button_look = SoraDGetChildByName(self, "Button_look")
	self.Button_look:setTitleText(i18n("common_text_829"))
	self.Button_look:addTouchEventListener(handler(self, self.onBtnLookClick))
	self.Node_cri = SoraDGetChildByName(self, "Node_cri")
	local G_xh_dunpai3 = cc.criSprite.createCriSprite("G_xh_dunpai3.usm", false, true)
	G_xh_dunpai3:addTo(self.Node_cri, 5)
	G_xh_dunpai3:setBlendFunc(gl.ONE, gl.ONE)
	G_xh_dunpai3:setVisible(false)
	local dunpai2 = cc.criSprite.createCriSprite("dunpai2.usm", false, false)
	dunpai2:addTo(self.Node_cri, 1)
	dunpai2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	if not SoraDFIsRA() then
		local dunpaiWord = cc.criSprite.createCriSprite("dunpai4.usm", false, false)
		dunpaiWord:addTo(self.Node_cri, 2)
		dunpaiWord:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	else
		local dunpaiWord = cc.criSprite.createCriSprite("dunpai5.usm", false, false)
		dunpaiWord:addTo(self.Node_cri, 3)
		dunpaiWord:setPosition(0, 20)
		dunpaiWord:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	local G_dunpai1 = cc.criSprite.createCriSprite("G_dunpai1.usm", true, false)
	G_dunpai1:addTo(self.Node_cri, 4)
	G_dunpai1:setBlendFunc(gl.ONE, gl.ONE)
	G_dunpai1:setCompleteCallback(function(...)
		G_xh_dunpai3:setVisible(true)
	end)
end
function epicWarWinPopView:initAllReceive(passScore)
	self.receiveAll = true
	self.Text_tip:setString(i18n("epicbattle_text_42"))
	self.Node_awardShow:setVisible(false)
	self.Button_look:setTitleText(i18n("hero_title_02"))
	self.Button_ok:setTitleText(i18n("common_text_1402"))
	if passScore then
		for k, v in ipairs(self.starArray) do
			v.star:setVisible(passScore >= k)
			v.des:setColor(passScore >= k and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
		end
	end
end
function epicWarWinPopView:initData(data, pointType)
	self.data = data
	self.pointType = pointType
	if not self.data.reward then
		local _ENV, reward = self.data.reward, self.data.reward
	end
	if SoraDIsGameGuide() and SoraDIsGameGuide() == 81004 then
		local isOwnPiece = false
		for k, v in ipairs(reward) do
			if v.id == 900000 then
				v.count = 10
				isOwnPiece = true
				break
			end
		end
		if not isOwnPiece then
			_ENV = ipairs(reward)
			ipairs(reward).id = 900000
			reward[#reward + 1], ipairs(reward).count = ipairs(reward)
		end
	end
	for i = 1, 4 do
		local awardItem = SoraDGetChildByName(self, "Node_award_" .. i)
		local sprite_item = SoraDGetChildByName(awardItem, "sprite_item")
		local Text_ItemName = SoraDGetChildByName(awardItem, "Text_ItemName")
		local Text_num = SoraDGetChildByName(awardItem, "Text_num")
		local itemID = reward[i] and reward[i].id
		local itemNum = reward[i] and reward[i].count or 1
		if itemID then
			sprite_item:setSpriteFrame(publicRead.getIcon(itemID))
			Text_ItemName:setString(publicRead.getName(itemID))
			Text_num:setString(string.formatnumberthousands(itemNum))
		else
			awardItem:setVisible(false)
			sprite_item:setSpriteFrame("icon_equip_storagebox.png")
			Text_ItemName:setString(i18n("common_text_486"))
		end
		sprite_item:setScale(95.03999999999999 / sprite_item:getContentSize().width)
	end
	SoraDToCenter(self.Node_awardShow, 140)
	if self.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS then
		self.Text_tip:setString(i18n("epicbattle_text_19"))
	end
end
function epicWarWinPopView:onBtnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function epicWarWinPopView:onBtnLookClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panle = SoraDCreatePanel("epicBattleMailView")
		panle:initData(self.data)
		panle:show(nil, 2)
	end
end
function epicWarWinPopView:onExitPanel()
	local bless = epicWarCtrl:getBossDropBless()
	if next(bless) then
		SoraDShowLoading(nil, nil, nil, true)
		local panel = SoraDCreatePanel("epicWarChooseBlessView")
		panel:initData(self.pointType)
		panel:show()
	elseif self.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and epicWarCtrl:isBossKilled() then
		SoraDShowMsgTip(i18n("tips_epic_war_killGuard"))
	end
end
function epicWarWinPopView:gameGuide_getTarget(itemName, parameters)
	if itemName == "heroChip" then
		local index = 1
		for i, v in ipairs(self.data.reward) do
			if v.id == parameters.heroChipID then
				index = i
				break
			end
		end
		return SoraDGetChildByName(SoraDGetChildByName(self, "Node_award_" .. index), "sprite_item")
	else
		return SoraDGetChildByName(self, itemName)
	end
end
return epicWarWinPopView
