local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local publicRead = include("publicRead")
local epicBattleDef = include("epicBattleDef")
local epicBattleWinPopView = class("epicBattleWinPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleWinPopView")
	end
	return target
end)
function epicBattleWinPopView:ctor()
	self.data = nil
	self.starArray, _ENV, self.receiveAll = nil, nil, nil
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("epicbattle_text_16"))
	self.Node_awardShow = SoraDGetChildByName(self, "Node_awardShow")
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	local spine_lost = sp.SkeletonAnimation:create("spine/shengli.skel", "spine/shengli.atlas", 1)
	spine_lost:addTo(self.Node_spine)
	spine_lost:setAnimation(0, "animation", true)
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.onBtnOKClick))
	self.Button_look = SoraDGetChildByName(self, "Button_look")
	self.Button_look:setTitleText(i18n("common_text_829"))
	self.Button_look:addTouchEventListener(handler(self, self.onBtnLookClick))
end
function epicBattleWinPopView:initAllReceive(passScore)
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
function epicBattleWinPopView:initData(data, pointType)
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
function epicBattleWinPopView:onBtnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function epicBattleWinPopView:onBtnLookClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panle = SoraDCreatePanel("epicBattleMailView")
		panle:initData(self.data)
		panle:show(nil, 2)
	end
end
function epicBattleWinPopView:onExitPanel()
	local bless = epicWarCtrl:getBossDropBless()
	dump(bless, "epicBattleWinPopView:onExitPanel bless============")
	if next(bless) then
		SoraDShowLoading(nil, nil, nil, true)
		local panel = SoraDCreatePanel("epicWarChooseBlessView")
		panel:initData(self.pointType)
		panel:show()
	elseif self.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and epicWarCtrl:isBossKilled() then
		SoraDShowMsgTip(i18n("tips_epic_war_killGuard"))
	end
end
function epicBattleWinPopView:gameGuide_getTarget(itemName, parameters)
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
return epicBattleWinPopView
