local gametop = gModuleMgr.getObject("gametop")
local cavalryRiseCtrl = SoraDGetCtrl("cavalryRiseCtrl")
local cavalryRiseMainAwardSingle = class("cavalryRiseMainAwardSingle", function(target)
	return target
end)
local cavalryRiseUtil = include("cavalryRiseUtil")
local CAVALRY_RISE_AWARD_TYPE = cavalryRiseUtil.CAVALRY_RISE_AWARD_TYPE
local CAVALRY_RISE_ITEM_TYPE = cavalryRiseUtil.CAVALRY_RISE_ITEM_TYPE
_UPVALUE3_, _UPVALUE2_ = nil, nil
_UPVALUE3_, (nil)[1] = 390, 390
_UPVALUE3_, (nil)[2] = 390, 440
_UPVALUE3_, (nil)[3] = 390, 338
;(390)[1] = 118
;(390)[2] = 166
;(390)[3] = 80
;(nil)[1] = nil
local (nil)[2], ItemPosX = 390, nil
function cavalryRiseMainAwardSingle:ctor()
	self.data, _ENV, self.listNode, _ENV, self.scrollItems, _ENV = nil, nil, nil, nil, nil, nil
	self.txtLevel = SoraDGetChildByName(self, "Text_award_lv")
	self.Node_singleEffect = SoraDGetChildByName(self, "Node_singleEffect")
	self.Node1 = SoraDGetChildByName(self, "Node1")
	self.Text_more = SoraDGetChildByName(self, "Text_more")
	self.Text_more:setVisible(false)
	self.Node_effectBronze = SoraDGetChildByName(self.Node_singleEffect, "Node_effectBronze")
	self.Node_effectGold = SoraDGetChildByName(self.Node_singleEffect, "Node_effectGold")
	self:initEffect()
end
function cavalryRiseMainAwardSingle:setSpecialSinle()
	self.isSpecialSingle = true
end
function cavalryRiseMainAwardSingle:playAnimation(index)
	self.index = index
	self:stopAllActions()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.05 * (index - 1))
	;(nil)[2] = cca.callFunc(function()
		SoraDCreatAnimationEx(self.__cname, self, false, nil, 0, 25)
		self = false
		;(false)[1] = cca.delay(0.43333333333333335)
		;(false)[2] = cca.callFunc(function()
			self.action:gotoFrameAndPlay(100, 200, true)
		end)
		;(false)[3] = cca.callFunc(function()
			self.action:gotoFrameAndPlay(100, 200, true)
		end)
		self:runAction(cca.seq(false))
	end)
	;(nil)[3] = cca.callFunc(function()
		SoraDCreatAnimationEx(self.__cname, self, false, nil, 0, 25)
		self = false
		;(false)[1] = cca.delay(0.43333333333333335)
		;(false)[2] = cca.callFunc(function()
			self.action:gotoFrameAndPlay(100, 200, true)
		end)
		;(false)[3] = cca.callFunc(function()
			self.action:gotoFrameAndPlay(100, 200, true)
		end)
		self:runAction(cca.seq(false))
	end)
	self:runAction(cca.seq(nil))
end
function cavalryRiseMainAwardSingle:initData(data, otherData)
	if not self.isSpecialSingle and otherData.view.playSingleAnimation then
		self:playAnimation(data.lv)
	else
		self:stopAllActions()
		SoraDCreatAnimationEx(self.__cname, self, true, nil, 100, 200)
	end
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
	end
	self.activityType = SoraDGetCtrl("cavalryRiseCtrl"):getClassType()
	self:recycleSingle()
	self:setAward()
end
function cavalryRiseMainAwardSingle:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = self:createItem()
	end
	single:setVisible(true)
	return single
end
function cavalryRiseMainAwardSingle:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function cavalryRiseMainAwardSingle:createItem()
	local single = include("cavalryRiseItem").new()
	single:setScale(0.65)
	single:setBaseScale(1.0)
	single:setOwnView(self.view)
	single:setOwnScroll(self.ownScroll)
	single:addTo(self.Node1, 100)
	return single
end
function cavalryRiseMainAwardSingle:setAward_imp(award, awardType, lv)
	local awardStatus = cavalryRiseCtrl:getAwardItemStatus(awardType, lv)
	local posY = 56
	local arrPos = awardType == 1 and ItemPosX[2] or ItemPosX[1]
	local awardNum = #award
	for k, v in ipairs(award) do
		local posX = awardNum == 1 and arrPos[1] or arrPos[k + 1]
		local single = self:getSingle()
		single:setPosition(SoraDFPosX(posX, self.ownScroll), posY)
		single:initData(v.id, v.count)
		single:setItemStatus(awardStatus, awardType)
		table.insert(self.scrollItems, single)
	end
end
function cavalryRiseMainAwardSingle:setAward()
	local lv = self.data.lv
	self:showEffect(false, #self.data.bronzeAward > 0, lv)
	self:setAward_imp(self.data.bronzeAward, CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_NORMAL, lv)
	self:setAward_imp(self.data.goldAward, CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_GOLD, lv)
	local cavalryRiseRead = include("cavalryRiseRead")
	if cavalryRiseRead:isLastLevel(self.activityType, lv) then
		self.Text_more:setVisible(true)
		CAVALRY_RISE_AWARD_TYPE = nil
		;(nil).lv = lv
		self.txtLevel:setString(i18n("cavalryrise_text_19", nil))
	else
		self.Text_more:setVisible(false)
		self.txtLevel:setString(lv)
	end
	local canGetBronze = cavalryRiseCtrl:canGetLevelAwardBronze(lv) and #self.data.bronzeAward > 0
	self.Node_effectBronze:setVisible(canGetBronze)
	local canGetGold = cavalryRiseCtrl:canGetLevelAwardGold(lv) and 0 < #self.data.goldAward
	self.Node_effectGold:setVisible(canGetGold)
end
function cavalryRiseMainAwardSingle:showEffect(fromLast, showNormalEffect, lv)
end
function cavalryRiseMainAwardSingle:initEffect()
end
return cavalryRiseMainAwardSingle
